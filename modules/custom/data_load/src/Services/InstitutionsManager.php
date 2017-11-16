<?php

namespace Drupal\data_load\Services;

use PDO;
use PDOException;

class InstitutionsManager {

  private static function initializeTable(PDO $pdo): void {
    $pdo->exec("
      DROP TABLE IF EXISTS tmp_LoadInstitutions;
      CREATE TABLE tmp_LoadInstitutions (
        Id            INT IDENTITY (1,1),
        Name          VARCHAR(250),
        City          VARCHAR(50),
        State         VARCHAR(50),
        Country       VARCHAR(3),
        Postal        VARCHAR(50),
        Longitude     DECIMAL(9, 6),
        Latitude      DECIMAL(9, 6),
        GRID          VARCHAR(250)
      );
    ");
  }

  public static function importInstitutions(PDO $pdo, array $institutions) {
    try {
      self::initializeTable($pdo);
      $stmt = $pdo->prepare(
        "INSERT INTO tmp_LoadInstitutions ([Name], [City], [State], [Country], [Postal], [Longitude], [Latitude], [GRID])
          VALUES (?, ?, ?, ?, ?, ?, ?, ?)");

      foreach($institutions as $institution) {

        $data = array_map(function($value) {
          return strlen($value) > 0 ? $value : NULL;
        }, $institution);

        $stmt->execute($data);
      }

      return $pdo->query("SET NOCOUNT ON; EXEC AddInstitutions")->fetchAll();
    }

    catch (PDOException $e) {
      return [
        'ERROR' => preg_replace('/^SQLSTATE\[.*\]/', '', $e->getMessage())
      ];
    }
  }
}