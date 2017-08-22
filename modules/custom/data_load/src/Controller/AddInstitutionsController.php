<?php


namespace Drupal\data_load\Controller;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\JsonResponse;
use PDO;

class AddInstitutionsController {

  private static function initializeTable(PDO $pdo): void {
    $pdo->exec("
      DROP TABLE IF EXISTS tmp_LoadIInstitutions;
      CREATE TABLE tmp_LoadIInstitutions (
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

  public static function addInstitutions(PDO $pdo, array $institutions): array {

    self::initializeTable($pdo);
    $stmt = $pdo->prepare(
      "INSERT INTO tmp_LoadIInstitutions ([Name], [City], [State], [Country], [Postal], [Longitude], [Latitude], [GRID])
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)");

    foreach($institutions as $institution) {

      $data = array_map(function($value) {
        return $value ? $value : NULL;
      }, $institution);

      $stmt->execute($data);
    }

    return $pdo->query("SET NOCOUNT ON; EXEC AddInstitutions")->fetchAll();
  }

    /**
    * Adds CORS Headers to a response
    */
    function addCorsHeaders($response) {
      $response->headers->set('Access-Control-Allow-Headers', 'origin, content-type, accept');
      $response->headers->set('Access-Control-Allow-Origin', '*');
      $response->headers->set('Access-Control-Allow-Methods', 'POST, GET, PUT, DELETE, PATCH, OPTIONS');

      return $response;
  }

  public static function addInstitutionsRoute(Request $request) {
    $institutions = json_decode($request->getContent(), true);

    $pdo = DatabaseAdapter::get_connection();
    $data = self::addInstitutions($pdo, $institutions);
    return self::addCorsHeaders(new JsonResponse($data));
  }
}