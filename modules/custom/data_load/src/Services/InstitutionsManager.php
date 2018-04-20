<?php

namespace Drupal\data_load\Services;

use PDO;
use PDOException;
use Exception;

class InstitutionsManager {

  /**
   * Imports institutions into the database
   *
   * @param PDO $connection
   * @param array $data A non-associative array containing the records to be inserted
   * @return array
   */
  public static function importInstitutions(PDO $connection, array $institutions) {
    $index = 1;
    try {

      // create a new institution import log id
      $stmt = $connection->prepare(
        'DECLARE @ImportInstitutionLogID INT;
        EXECUTE AddImportInstitutionLog
          @Count = :count,
          @ImportInstitutionLogID = @ImportInstitutionLogID OUTPUT;
        SELECT @ImportInstitutionLogID');
      $stmt->execute(['count' => count($data)]);
      $logId = $stmt->fetchColumn();

      // insert records into ImportInstitutionStaging
      $stmt = $connection->prepare(
        "INSERT INTO ImportInstitutionStaging (
          [ImportInstitutionLogID],
          [Name],
          [City],
          [State],
          [Country],
          [Postal],
          [Latitude],
          [Longitude],
          [GRID])
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");

      foreach($institutions as $institution) {
        $index ++;
        $data = array_map(function($value) {
          return strlen($value) > 0 ? $value : NULL;
        }, $institution);

        // prepend rows with the import log id
        array_unshift($data, $logId);
        $stmt->execute($data);
      }

      // return any collaborators that were not successfully imported
      $stmt = $connection->prepare(
        'SET NOCOUNT ON;
        EXECUTE ImportInstitutions
          @ImportInstitutionLogID = :logId,
          @count = NULL');
      $stmt->execute(['logId' => $logId]);
      return $stmt->fetchAll();
    }

    catch (PDOException $e) {

      $message = preg_replace('/^SQLSTATE\[.*\]/', '', $e->getMessage());

      if ($index < count($data)) {
         $message = "An error occured while reading row $index: $message";
      }

      return ['ERROR' => $message];
    }

    catch (Exception $e) {
      return [
        'ERROR' => $e->getMessage()
      ];
    }
  }
}