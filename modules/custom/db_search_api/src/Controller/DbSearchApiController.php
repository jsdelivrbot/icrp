<?php

/**
 * @file
 * Contains \Drupal\db_search_api\Controller\DbSearchAPIController.
 */

namespace Drupal\db_search_api\Controller;

use Drupal\Core\Controller\ControllerBase;
use Drupal\Core\Database\Database;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\JsonResponse;
use PDO;

/**
 * Controller routines for db_search_api routes.
 */
class DbSearchApiController extends ControllerBase {


  private $parameter_mappings = array(
    'page_size' => 'PageSize',
    'page_number' => 'PageNumber',
    'sort_column' => 'SortCol',
    'sort_type' => 'SortDirection',
    'search_terms' => 'terms',
    'search_type' => 'termSearchType',
    'years' => NULL,
    'institution' => 'institution',
    'pi_first_name' => 'piFirstName',
    'pi_last_name' => 'piLastName',
    'pi_orcid' => 'piORCiD' ,
    'award_code' => 'awardCode',
    'countries' => 'countryList',
    'states' => 'stateList',
    'cities' => 'cityList',
    'funding_organizations' => 'fundingOrgList',
    'cancer_types' => 'cancerTypeList',
    'project_types' => 'projectTypeList',
    'cso_codes' => 'CSOList'
  );


  /**
   * Returns a PDO connection to a database
   * @param $cfg - An associative array containing connection parameters 
   *   driver:  DB Connector Driver
   *   host:    Server Name
   *   dbname:  Database
   *   user:    Username
   *   pass:    Password
   *
   * @return A PDO connection
   * @throws PDOException
   */
  function get_connection($cfg) {
    // connection string
    $cfg['dsn'] = 
      $cfg['driver'] .
      ":host="    . $cfg['host'] .
      ";dbname="  . $cfg['dbname'] .
      ";charset=UTF-8";
    // default configuration options
    $cfg['opt'] = [
      PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
      PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
  //  PDO::ATTR_EMULATE_PREPARES   => false,
    ];
    // create new PDO object
    return new PDO(
      $cfg['dsn'], 
      $cfg['user'], 
      $cfg['pass'], 
      $cfg['opt']);
  }

  /**
   * Parses user input (json) as an associative array
   * @param $input - A json string containing query parameters 
   *
   *  page_size
   *  page_number
   *  sort_column
   *  sort_type
   *  search_terms
   *  search_type
   *  year
   *  institution
   *  pi_first_name
   *  pi_last_name
   *  pi_orcid
   *  award_code
   *  countries
   *  states
   *  cities
   *  funding_organizations
   *  cancer_types
   *  project_types
   *  cso_codes
   *
   * @return An array containing mapped parameters
   */  
  function parse_input($input) {
    $parameter_mappings = $this->parameter_mappings;
    $user_param = (array) $input;
    $query_param = array();

    foreach (array_keys($user_param) as $key) {
      if (array_key_exists($key, $parameter_mappings)) {
        $query_key = $parameter_mappings[$key];
        $query_param[$query_key] = $user_param[$key];
      }
    }

    return $query_param;
  }

  /**
  * Binds parameters to a PDO prepared statement
  * @param $stmt - The PDO prepared statement to modify
  * @param $param - An associative array containing 
  * parameters to bind to the statement
  */
  function bind_parameters($stmt, $param) {
    foreach (array_keys($param) as $key) {
      $stmt->bindParam($key, $param[$key]);
    }
  }

  function query_db_group($parameters) {

    $groups = array(
      'count' => 0,
      'projects_by_country' => array(),
      'projects_by_cso_category' => array(),
      'projects_by_cancer_type' => array(),
      'projects_by_type' => array()
    );

    $pdo = $this->get_connection(parse_ini_file("config.ini"));
    $stmt_conditions = array();
    $stmt_parameters = array();


    foreach (array('PageSize', 'PageNumber', 'SortCol', 'SortDirection') as $key) {
      if (isset($parameters[$key])) {
        unset($parameters[$key]);
      }
    }

    foreach (array_keys($parameters) as $key) {
      $query_key = ":".$key;
      $param_key = "@".$key;

      $stmt_parameters[$query_key] = $parameters[$key];
      array_push($stmt_conditions, $param_key."=".$query_key);
    }

    $stmt = $pdo->prepare("EXECUTE GetProjects " . implode(",", $stmt_conditions));
    $this->bind_parameters($stmt, $stmt_parameters);


    if ($stmt->execute()) {
      while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {


        $country = $row['country'];
        $cso_category = $row['CSOCode'][0];
        $cancer_type = $row['CancerType'];
        $project_type = $row['ProjectType'];

        if (!isset($groups['projects_by_country'][$country])) {
          $groups['projects_by_country'][$country] = 0;
        }

        if (!isset($groups['projects_by_cso_category'][$cso_category])) {
          $groups['projects_by_cso_category'][$cso_category] = 0;
        }

        if (!isset($groups['projects_by_cancer_type'][$cancer_type])) {
          $groups['projects_by_cancer_type'][$cancer_type] = 0;
        }

        if (!isset($groups['projects_by_type'][$project_type])) {
          $groups['projects_by_type'][$project_type] = 0;
        }

        $groups['projects_by_country'][$country]++;
        $groups['projects_by_cso_category'][$cso_category]++;
        $groups['projects_by_cancer_type'][$cancer_type]++;
        $groups['projects_by_type'][$project_type]++;
        $groups['count']++;
      }
    }

    arsort($groups['projects_by_country']);
    arsort($groups['projects_by_cso_category']);
    arsort($groups['projects_by_cancer_type']);
    arsort($groups['projects_by_type']);

    return $groups;
  }

  /**
  * Queries the database for projects
  * @param $parameters - An associative array of parameters
  */
  function query_db($parameters) {
    $pdo = $this->get_connection(parse_ini_file("config.ini"));
    $stmt_conditions = array();
    $stmt_parameters = array();


    foreach (array_keys($parameters) as $key) {
      $query_key = ":".$key;
      $param_key = "@".$key;

      $stmt_parameters[$query_key] = $parameters[$key];
      array_push($stmt_conditions, $param_key."=".$query_key);
    }

    $stmt = $pdo->prepare("EXECUTE GetProjects " . implode(",", $stmt_conditions));
    $this->bind_parameters($stmt, $stmt_parameters);


    if ($stmt->execute()) {
      $rows = array();
      while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {

        foreach (array_keys($row) as $key) {

          $row[$key] = mb_convert_encoding($row[$key], "UTF-8", mb_detect_encoding($row[$key]));
//          $row[$key] = json_decode('"'.$row[$key].'"');
        }

        $escaped_row = array(
          'project_id' => $row['ProjectID'],
          'project_title' => $row['Title'],
          'pi_name' => $row['piLastName'].", ".$row['piFirstName'],
          'institution' => $row['institution'],
          'city' => $row['City'],
          'state' => $row['State'],
          'country' => $row['country'],
          'funding_organization' => $row['FundingOrg'],
          'award_code' => $row['AwardCode']
        );

        array_push($rows, $escaped_row);
      }

      return $rows;
    }

    return array("No results found");
  }

  function query_search($json) {
    return $this->query_db($this->parse_input($json));
  }

  function query_group($json) {
    return $this->query_db_group($this->parse_input($json));
  }



  /**
  * Adds CORS Headers to a response
  */
  public function addCorsHeaders($response) {
    $response->headers->set('Access-Control-Allow-Headers', 'origin, content-type, accept');
    $response->headers->set('Access-Control-Allow-Origin', '*');
    $response->headers->set('Access-Control-Allow-Methods', 'POST, GET, PUT, DELETE, PATCH, OPTIONS');

    return $response;
  }

  /**
  * Extracts valid fields from a request object 
  */
  public function getFields(Request $request) {

    $fields = array();
    foreach(array(
      'page_size',
      'page_number',
      'sort_column',
      'sort_type',
      'search_terms',
      'search_type',
      'year',
      'institution',
      'pi_first_name',
      'pi_last_name',
      'pi_orcid',
      'award_code',
      'countries',
      'states',
      'cities',
      'funding_organizations',
      'cancer_types',
      'project_types',
      'cso_codes'
    ) as $field) {

      $value = $request->query->get($field);

      if ($value) {
        $fields[$field] = $value;  
      }
    }

    return $fields;
  }

  public function searchDatabase($param) {
    return $this->query_search($param);
  }

  public function countGroups($param) {
    return $this->query_group($param);
  }

  /**
   * Callback for `db/public/search/` API method.
   */
  public function publicSearch( Request $request ) {
    $param = self::getFields($request);
    $response = new JSONResponse( self::searchDatabase($param) );
//    $response = new Response( print_r(self::searchDatabase($param)) );

//    $response = new Response( print_r(json_encode(self::searchDatabase($param), JSON_UNESCAPED_UNICODE)) );
//    $reponse->headers->set('Content-Type', 'application/json');
//    $response = new JSONResponse( $param );

    return self::addCorsHeaders($response);
  }

  public function publicAnalytics( Request $request ) {
    $param = self::getFields($request);
    $response = new JSONResponse( self::countGroups($param) );
    return self::addCorsHeaders($response);
  }

  /**
   * Callback for `db/partner/search/` API method.
   */
  public function partnerSearch( Request $request ) {
    $param = self::getFields($request);
    $response = new JSONResponse( self::searchDatabase($param) );
    return self::addCorsHeaders($response);
  }

  /**
   * Callback for `db/partner/analytics/` API method.
   */
  public function partnerAnalytics( Request $request, $type ) {
    $param = self::getFields($request);
    $response = new JSONResponse( self::countGroups($param) );
    return self::addCorsHeaders($response);
  }
}
