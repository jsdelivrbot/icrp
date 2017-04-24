<?php

/**
 * @file
 * Contains \Drupal\db_search_api\Controller\DatabaseSearchAPIController.
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
class DatabaseSearchAPIController extends ControllerBase {

  private static $parameter_mappings = [
    'page_size'                  => 'PageSize',
    'page_size'                  => 'PageSize',
    'page_number'                => 'PageNumber',
    'sort_column'                => 'SortCol',
    'sort_type'                  => 'SortDirection',
    'search_terms'               => 'terms',
    'search_type'                => 'termSearchType',
    'years'                      => 'yearList',
    'institution'                => 'institution',
    'pi_first_name'              => 'piFirstName',
    'pi_last_name'               => 'piLastName',
    'pi_orcid'                   => 'piORCiD',
    'award_code'                 => 'awardCode',
    'countries'                  => 'countryList',
    'states'                     => 'stateList',
    'cities'                     => 'cityList',
    'funding_organization_types' => 'FundingOrgType',
    'funding_organizations'      => 'fundingOrgList',
    'is_childhood_cancer'        => 'IsChildhood',
    'cancer_types'               => 'cancerTypeList',
    'project_types'              => 'projectTypeList',
    'cso_research_areas'         => 'CSOList',
  ];

  private static $sort_column_mappings = [
    'project_title'         => 'title',
    'pi_name'               => 'pi',
    'institution'           => 'Inst',
    'city'                  => 'city',
    'state'                 => 'state',
    'country'               => 'country',
    'funding_organization'  => 'FO',
    'award_code'            => 'code'
  ];

  private static $output_mappings = [
    'search_id'             => 'searchCriteriaID',
    'num_results'           => 'ResultCount',
  ];

  /**
   * Returns a PDO connection to a database
   * @param $cfg - An associative array containing connection parameters
   *   driver:    DB Driver
   *   server:    Server Name
   *   database:  Database
   *   user:      Username
   *   password:  Password
   *
   * @return A PDO connection
   * @throws PDOException
   */
  function get_connection(string $database_config = 'icrp_database') {

    $cfg = [];
    $icrp_database = \Drupal::config($database_config);
    foreach(['driver', 'host', 'port', 'database', 'username', 'password'] as $key) {
       $cfg[$key] = $icrp_database->get($key);
    }

    // connection string
    $cfg['dsn'] =
      $cfg['driver'] .
      ":Server={$cfg['host']},{$cfg['port']}" .
      ";Database={$cfg['database']}";

    // default configuration options
    $cfg['options'] = [
      PDO::SQLSRV_ATTR_ENCODING    => PDO::SQLSRV_ENCODING_UTF8,
      PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
      PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
  //  PDO::ATTR_EMULATE_PREPARES   => false,
    ];

    // create new PDO object
    return new PDO(
      $cfg['dsn'],
      $cfg['username'],
      $cfg['password'],
      $cfg['options']
    );
  }

  function create_updated_input_parameters($request) {
    $input_parameters = [
      'page_size'                   => 50,
      'page_number'                 => 1,
      'sort_column'                 => 'title',
      'sort_type'                   => 'ASC',
      'search_terms'                => NULL,
      'search_type'                 => NULL,
      'years'                       => NULL,
      'institution'                 => NULL,
      'pi_first_name'               => NULL,
      'pi_last_name'                => NULL,
      'pi_orcid'                    => NULL,
      'award_code'                  => NULL,
      'countries'                   => NULL,
      'states'                      => NULL,
      'cities'                      => NULL,
      'funding_organization_types'  => NULL,
      'funding_organizations'       => NULL,
      'cancer_types'                => NULL,
      'is_childhood_cancer'         => NULL,
      'project_types'               => NULL,
      'cso_research_areas'          => NULL,
    ];



    foreach(array_keys($input_parameters) as $key) {
      $value = $request->query->get($key, NULL);
//      if ($key == 'sort_column') {
//        $value = self::$sort_column_mappings[$value];
//      }

      if ($value != NULL) {
        $input_parameters[$key] = $value;
      }
    }

    return $input_parameters;
  }

  function retrieve_search_parameters($search_id, string $database_config = 'icrp_database') {

    $pdo = self::get_connection($database_config);
    $stmt = $pdo->prepare('SELECT * FROM SearchCriteria where SearchCriteriaID = :search_id');
    $stmt->bindParam(':search_id', $search_id);

    $output = [];

    if ($stmt->execute()) {
        $output = $stmt->fetch(PDO::FETCH_ASSOC);
    }

    if (sizeof($output) == 1) {
      return false;
    }

    return $output;
  }

  function get_analytics_updated($search_id, string $database_config = 'icrp_database') {

    $pdo = self::get_connection($database_config);

    $queries = [
      'projects_by_country' => 'SET NOCOUNT ON; EXECUTE GetProjectCountryStatsBySearchID @SearchID = :search_id, @ResultCount = :total_projects_by_country',
      'projects_by_cso_research_area' => 'SET NOCOUNT ON; EXECUTE GetProjectCSOStatsBySearchID @SearchID = :search_id, @ResultCount = :total_projects_by_cso_research_area',
      'projects_by_cancer_type' => 'SET NOCOUNT ON; EXECUTE GetProjectCancerTypeStatsBySearchID @SearchID = :search_id, @ResultCount = :total_projects_by_cancer_type',
      'projects_by_type' => 'SET NOCOUNT ON; EXECUTE GetProjectTypeStatsBySearchID @SearchID = :search_id, @ResultCount = :total_projects_by_type',
    ];

    $output_keys = [
      'projects_by_country' => 'total_projects_by_country',
      'projects_by_cso_research_area' => 'total_projects_by_cso_research_area',
      'projects_by_cancer_type' => 'total_projects_by_cancer_type',
      'projects_by_type' => 'total_projects_by_type',
      'projects_by_year' => 'total_projects_by_year'
    ];

    $output = [
      'projects_by_country' => [
        'results' => [],
        'count' => 0,
      ],

      'projects_by_cso_research_area' => [
        'results' => [],
        'count' => 0,
      ],

      'projects_by_cancer_type' => [
        'results' => [],
        'count' => 0,
      ],

      'projects_by_type' => [
        'results' => [],
        'count' => 0,
      ],

      'projects_by_year' => [
        'results' => [],
        'count' => 0,
      ],

    ];

    $output_column_labels = [
      'projects_by_country' => 'country',
      'projects_by_cso_research_area' => 'categoryName',
      'projects_by_cancer_type' => 'CancerType',
      'projects_by_type' => 'ProjectType',
      'projects_by_year' => 'Year',
    ];

    $output_column_pairs = [
      'projects_by_cso_research_area' => ['Relevance', 'ProjectCount'],
      'projects_by_cancer_type' => ['Relevance', 'ProjectCount'],
    ];

    foreach(array_keys($queries) as $key) {
      $stmt = $pdo->prepare($queries[$key]);
      $stmt->bindParam(':search_id', $search_id);
      $stmt->bindParam(':' . $output_keys[$key], $output[$key]['count'], PDO::PARAM_INT|PDO::PARAM_INPUT_OUTPUT, 1000);

      if ($stmt->execute()) {


        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        	$result = [
	    		'label' => $row[$output_column_labels[$key]]
        	];

        	if (in_array($key, ['projects_by_cso_research_area', 'projects_by_cancer_type'])) {
        		$result['value'] = $row['Relevance'];
        		$result['count'] = $row['ProjectCount'];
        	}

        	else {
        		$result['value'] = $row['Count'];
        	}

        	array_push($output[$key]['results'], $result);
        }
      }
    }

    return $output;
  }

  function get_partner_analytics_funding($search_id, $year, string $database_config = 'icrp_database') {

    $pdo = self::get_connection($database_config);

    $total = 0;
    $stmt = $pdo->prepare('SET NOCOUNT ON; EXECUTE GetProjectAwardStatsBySearchID @SearchID = :search_id, @Year = :year, @Total = :total');
    $stmt->bindParam(':search_id', $search_id);
    $stmt->bindParam(':year', $year);
    $stmt->bindParam(':total', $total, PDO::PARAM_INT|PDO::PARAM_INPUT_OUTPUT, 1000);

    $results = [];

    if ($stmt->execute()) {
      while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        array_push($results, [
          'label' => $row['Year'],
          'value' => $row['amount'],
        ]);
      }
    }

    return $results;
  }



  function get_partner_analytics_funding_years(string $database_config = 'icrp_database') {

    $pdo = self::get_connection($database_config);
    $stmt = $pdo->prepare('SELECT DISTINCT Year as year FROM CurrencyRate ORDER BY Year DESC');

    return $stmt->execute()
      ? $stmt->fetchAll(PDO::FETCH_ASSOC)
      : [];
  }



  function get_partner_analytics_updated($search_id, string $database_config = 'icrp_database') {

    $pdo = self::get_connection($database_config);

    $queries = [
      'projects_by_country' => 'SET NOCOUNT ON; EXECUTE GetProjectCountryStatsBySearchID @SearchID = :search_id, @ResultCount = :total_projects_by_country',
      'projects_by_cso_research_area' => 'SET NOCOUNT ON; EXECUTE GetProjectCSOStatsBySearchID @SearchID = :search_id, @ResultCount = :total_projects_by_cso_research_area',
      'projects_by_cancer_type' => 'SET NOCOUNT ON; EXECUTE GetProjectCancerTypeStatsBySearchID @SearchID = :search_id, @ResultCount = :total_projects_by_cancer_type',
      'projects_by_type' => 'SET NOCOUNT ON; EXECUTE GetProjectTypeStatsBySearchID @SearchID = :search_id, @ResultCount = :total_projects_by_type',
    ];

    $output_keys = [
      'projects_by_country' => 'total_projects_by_country',
      'projects_by_cso_research_area' => 'total_projects_by_cso_research_area',
      'projects_by_cancer_type' => 'total_projects_by_cancer_type',
      'projects_by_type' => 'total_projects_by_type',
      'projects_by_year' => 'total_projects_by_year'
    ];

    $output = [
      'projects_by_country' => [
        'results' => [],
        'count' => 0,
      ],

      'projects_by_cso_research_area' => [
        'results' => [],
        'count' => 0,
      ],

      'projects_by_cancer_type' => [
        'results' => [],
        'count' => 0,
      ],

      'projects_by_type' => [
        'results' => [],
        'count' => 0,
      ],

      'projects_by_year' => [
        'results' => [],
        'count' => 0,
      ],

    ];

    $output_column_labels = [
      'projects_by_country' => 'country',
      'projects_by_cso_research_area' => 'categoryName',
      'projects_by_cancer_type' => 'CancerType',
      'projects_by_type' => 'ProjectType',
      'projects_by_year' => 'Year',
    ];

    $output_column_pairs = [
      'projects_by_cso_research_area' => ['Relevance', 'ProjectCount'],
      'projects_by_cancer_type' => ['Relevance', 'ProjectCount'],
    ];

    foreach(array_keys($queries) as $key) {
      $stmt = $pdo->prepare($queries[$key]);
      $stmt->bindParam(':search_id', $search_id);
      $stmt->bindParam(':' . $output_keys[$key], $output[$key]['count'], PDO::PARAM_INT|PDO::PARAM_INPUT_OUTPUT, 1000);

      if ($stmt->execute()) {


        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
          $result = [
          'label' => $row[$output_column_labels[$key]]
          ];

          if (in_array($key, ['projects_by_cso_research_area', 'projects_by_cancer_type'])) {
            $result['value'] = $row['Relevance'];
            $result['count'] = $row['ProjectCount'];
          }

          else {
            $result['value'] = $row['Count'];
          }

          array_push($output[$key]['results'], $result);
        }
      }
    }

    return $output;
  }

  function sort_paginate_search_results($parameters, string $database_config = 'icrp_database') {
    $pdo = self::get_connection($database_config);

    $stmt = $pdo->prepare("SET NOCOUNT ON; EXECUTE GetProjectsBySearchID
      @PageSize = :page_size,
      @PageNumber = :page_number,
      @SortCol = :sort_column,
      @SortDirection = :sort_type,
      @SearchID = :search_id,
      @ResultCount = :result_count");

    $stmt->bindParam(":result_count", $result_count, PDO::PARAM_INT|PDO::PARAM_INPUT_OUTPUT, 1000);
    foreach(['page_size', 'page_number', 'search_id', 'sort_column', 'sort_type', 'search_id'] as $key) {
      $stmt->bindParam(":$key", $parameters[$key]);
    }

    $results = [];
    if ($stmt->execute()) {
      while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        array_push($results, [
          'project_id'            => $row['ProjectID'],
          'project_title'         => $row['Title'],
          'pi_name'               => $row['piLastName'].", ".$row['piFirstName'],
          'institution'           => $row['institution'],
          'country'               => $row['country'],
          'funding_organization'  => $row['FundingOrgShort'],
          'award_code'            => $row['AwardCode'],
        ]);
      }
    }

    return $results;
  }

  function search_database_updated($input_parameters, string $database_config = 'icrp_database') {

    $pdo = self::get_connection($database_config);

    $output_parameters = [
      'search_id'             => NULL,
      'results_count'         => NULL,
    ];

    $stmt = $pdo->prepare("SET NOCOUNT ON; EXECUTE GetProjectsByCriteria
      @PageSize = :page_size,
      @PageNumber = :page_number,
      @SortCol = :sort_column,
      @SortDirection = :sort_type,
      @terms = :search_terms,
      @termSearchType = :search_type,
      @yearList = :years,
      @Institution = :institution,
      @piFirstName = :pi_first_name,
      @piLastName = :pi_last_name,
      @piORCiD = :pi_orcid,
      @awardCode = :award_code,
      @countryList = :countries,
      @stateList = :states,
      @cityList = :cities,
      @FundingOrgType = :funding_organization_types,
      @fundingOrgList = :funding_organizations,
      @cancerTypeList = :cancer_types,
      @IsChildhood = :is_childhood_cancer,
      @projectTypeList = :project_types,
      @CSOList = :cso_research_areas,
      @searchCriteriaID = :search_id,
      @ResultCount = :results_count");

    foreach(array_keys($input_parameters) as $input_key) {
      $stmt->bindParam(":$input_key", $input_parameters[$input_key]);
    }

    foreach(array_keys($output_parameters) as $output_key) {
      $stmt->bindParam(":$output_key", $output_parameters[$output_key], PDO::PARAM_INT|PDO::PARAM_INPUT_OUTPUT, 1000);
    }

    $results = [];

    if ($stmt->execute()) {
      while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        array_push($results, [
          'project_id'            => $row['ProjectID'],
          'project_title'         => $row['Title'],
          'pi_name'               => $row['piLastName'].", ".$row['piFirstName'],
          'institution'           => $row['institution'],
          'country'               => $row['country'],
          'funding_organization'  => $row['FundingOrgShort'],
          'award_code'            => $row['AwardCode'],
        ]);
      }
    }

    $_SESSION['database_search_id'] = $output_parameters['search_id'];

    return [
      'search_id' => $output_parameters['search_id'],
      'results_count' => $output_parameters['results_count'],
      'results' => $results,
    ];
  }


  /**
  * Creates a PDO prepared statement for searching projects
  * @param $pdo - The PDO connection oject
  * @param $parameters - An associative array containing
  * parameters to bind to the statement
  */
  function create_prepared_statement($pdo, $parameters, &$output) {
    $stmt_conditions = [];
    $stmt_parameters = [];

    foreach (array_keys($parameters) as $key) {
      $param_key = "@$key";
      $query_key = ":$key";

      $stmt_parameters[$query_key] = $parameters[$key];
      array_push($stmt_conditions, "{$param_key}={$query_key}");
    }

/**
    foreach (array_keys($output) as $key) {

      $mapped_key = self::$output_mappings[$key];
      $param_key = "@$mapped_key";
      $query_key = ":$mapped_key";

      array_push($stmt_conditions, "{$param_key}={$query_key}");
    }
*/
    $stmt = $pdo->prepare('SET NOCOUNT ON; EXECUTE GetProjectsByCriteria ' . implode(',', $stmt_conditions) . 'searchCriteriaID=:searchCriteriaID, ResultsCount=:ResultsCount');
    return self::bind_parameters($stmt, $stmt_parameters, $output);

//    return $stmt;
  }

  /**
  * Binds parameters to a PDO prepared statement
  * @param $stmt - The PDO prepared statement to modify
  * @param $param - An associative array containing
  * parameters to bind to the statement
  */
  function bind_parameters($stmt, $param, &$output) {
    foreach (array_keys($param) as $key) {
      $stmt->bindParam($key, $param[$key]);
    }

    $stmt->bindParam(':searchCriteriaID', $search_id);
    $stmt->bindParam(':ResultsCount', $num_results);
//    foreach (array_keys($output) as $key) {
//      $mapped_key = ":{self::$output_mappings[$key]}";
//      $stmt->bindParam($mapped_key, $output[$key], PDO::PARAM_INT|PDO::PARAM_INPUT_OUTPUT, 1000);
//    }
    return $stmt;
  }

  /**
  * Retrieves valid field values to be used as query parameters
  */
  function query_form_fields(string $database_config = 'icrp_database') {
    $pdo = self::get_connection($database_config);

    $fields = [
      'years'                      => [],
      'cities'                     => [],
      'states'                     => [],
      'countries'                  => [],
      'funding_organization_types' => [],
      'funding_organizations'      => [],
      'cancer_types'               => [],
      'project_types'              => [],
      'cso_research_areas'         => [],
    ];

    $queries = [
      'cities'                     => 'SELECT DISTINCT City AS [value], City AS [label], State AS [group], Country AS [supergroup] FROM Institution WHERE len(City) > 0 ORDER BY [label]',
      'states'                     => 'SELECT Abbreviation AS [value], Name AS [label], Country AS [group] FROM State ORDER BY [label]',
      'countries'                  => 'SELECT Abbreviation AS [value], Name AS [label] FROM Country ORDER BY [label]',
      'funding_organization_types' => 'SELECT FundingOrgType AS [value], FundingOrgType AS [label] FROM lu_FundingOrgType',
      'funding_organizations'      => 'SELECT FundingOrgID AS [value], Name AS [label], SponsorCode AS [group], Country AS [supergroup] from FundingOrg WHERE LastImportDate is NOT NULL',
      'cancer_types'               => 'SELECT CancerTypeID AS [value], Name AS [label] FROM CancerType ORDER BY [label]',
      'project_types'              => 'SELECT ProjectType AS [value], ProjectType AS [label] FROM ProjectType',
      'cso_research_areas'         => 'SELECT Code AS [value], Code + \' \' + Name AS [label], CategoryName AS [group], \'All Areas\' as [supergroup] FROM CSO WHERE isActive = 1',
    ];

    // map query results to field values
    foreach (array_keys($queries) as $key) {
      $stmt = $queries[$key];
      $fields[$key] = (array) $pdo->query($stmt)->fetchAll();
    }

    // create year ranges from current year to 2000
    foreach(range(intval(date('Y')), 2000) as $year) {
      array_push($fields['years'], ['value' => $year, 'label' => (string) $year]);
    }

    // set 'Uncoded' as the last entry in cso_research_areas
    if ($fields['cso_research_areas'][0]['value'] == '0') {
      array_push($fields['cso_research_areas'], array_shift($fields['cso_research_areas']));
    }

    return $fields;
  }

  /**
  * Queries the database for projects
  * @param $parameters - An associative array of parameters
  */
  function search_database($parameters) {


    $pdo = self::get_connection();

    $search_id = 0;
    $num_results = 0;
    $output = [
      'search_id' => 0,
      'num_results' => 0
    ];

    $results = [];

    $stmt = self::create_prepared_statement($pdo, $parameters, $output);

/**
    if ($stmt->execute()) {
      while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        array_push($results, [
          'project_id'            => $row['ProjectID'],
          'project_title'         => $row['Title'],
          'pi_name'               => $row['piLastName'].", ".$row['piFirstName'],
          'institution'           => $row['institution'],
          'city'                  => $row['City'],
          'state'                 => $row['State'],
          'country'               => $row['Country'],
          'funding_organization'  => $row['FundingOrg'],
          'award_code'            => $row['AwardCode']
        ]);
      }
    }

    return $results;
*/
//    echo print_r($parameters);
    return json_encode($parameters);
  }



  /**
  * Adds CORS Headers to a response
  */
  public function add_cors_headers($response) {
    $response->headers->set('Access-Control-Allow-Headers', 'origin, content-type, accept');
    $response->headers->set('Access-Control-Allow-Origin', '*');
    $response->headers->set('Access-Control-Allow-Methods', 'POST, GET, PUT, DELETE, PATCH, OPTIONS');

    return $response;
  }

  /**
  * Extracts valid fields from a request object
  * and maps them to query parameters
  */
  public function map_fields(Request $request) {
    $fields = [];
    foreach([
      'page_size',
      'page_number',
      'sort_column',
      'sort_type',
      'search_terms',
      'search_type',
      'years',
      'institution',
      'pi_first_name',
      'pi_last_name',
      'pi_orcid',
      'award_code',
      'countries',
      'states',
      'cities',
      'funding_organization_types',
      'funding_organizations',
      'cancer_types',
      'is_childhood_cancer',
      'project_types',
      'cso_codes'
    ] as $field) {
      $value = $request->query->get($field);
      if ($value) {

        // retrieve the mapped field value
        $mapped_field = self::$parameter_mappings[$field];

        // apply mapping to values in the sort_column field
        if ($field == 'sort_column') {
            $mapped_value = self::$sort_column_mappings[$value];
            if ($mapped_value) {
                $fields[$mapped_field] = $mapped_value;
            }
        }

        // do not modify values in other fields
        elseif ($mapped_field) {
            $fields[$mapped_field] = $value;
        }
      }
    }

    return $fields;
  }

  /**
   * Callback for `db/public/search/` API method.
   */
  public function public_form_fields() {
    $response = new JSONResponse( self::query_form_fields() );
    return self::add_cors_headers($response);
  }

  /**
   * Callback for `db/public/search/` API method.
   */
  public function public_search( Request $request ) {
    $param = self::create_updated_input_parameters($request);
    $response = new JSONResponse( self::search_database_updated($param) );
    return self::add_cors_headers($response);
  }

  /**
   * Callback for `db/public/search/` API method.
   */
  public function public_search_sort_paginate( Request $request ) {

    $param = [
      'search_id' => NULL,
      'page_size' => 50,
      'page_number' => 1,
      'sort_column' => 'title',
      'sort_type' => 'ASC'
    ];

    foreach(array_keys($param) as $key) {
      $value = $request->query->get($key);

      if ($key == 'sort_column') {
        $value = self::$sort_column_mappings[$value];
      }

      if ($value) {
        $param[$key] = $value;
      }
    }

    $response = new JSONResponse( self::sort_paginate_search_results($param) );
    return self::add_cors_headers($response);
  }

  /**
   * Callback for `db/public/analytics/` API method.
   */
  public function public_analytics( Request $request ) {
//    $param = self::map_fields($request);
    $param = $request->query->get('search_id');
    $response = new JSONResponse( self::get_analytics_updated($param) );
    return self::add_cors_headers($response);
  }

  /**
   * Callback for `db/partner/search/` API method.
   */
  public function partner_search( Request $request ) {
    $param = self::map_fields($request);
    $response = new JSONResponse( self::search_database_updated($param) );
    return self::add_cors_headers($response);
  }

  /**
   * Callback for `db/partner/analytics/` API method.
   */
  public function partner_analytics( Request $request ) {
    //$param = self::map_fields($request);
    $param = $request->query->get('search_id');
    $response = new JSONResponse( self::get_partner_analytics_updated($param) );
    return self::add_cors_headers($response);
  }

  public function partner_analytics_funding( Request $request ) {
    //$param = self::map_fields($request);
    $search_id = $request->query->get('search_id');
    $year = $request->query->get('year');

    if (!$year) {
      $year = 2017;
    }

    $response = new JSONResponse( self::get_partner_analytics_funding($search_id, $year) );
    return self::add_cors_headers($response);
  }

  public function partner_analytics_funding_years(  ) {
    //$param = self::map_fields($request);
    $response = new JSONResponse( self::get_partner_analytics_funding_years() );
    return self::add_cors_headers($response);
  }


  public function retrieve_parameters( Request $request ) {
    $search_id = $request->query->get('search_id');
    $response = new JSONResponse( self::retrieve_search_parameters($search_id) );
    return self::add_cors_headers($response);
  }




  /**
   * Callback for `db/public/search/` API method.
   */
  public function load_public_form_fields() {
    $response = new JSONResponse( self::query_form_fields('icrp_load_database') );
    return self::add_cors_headers($response);
  }

  /**
   * Callback for `db/public/search/` API method.
   */
  public function load_public_search( Request $request ) {
    $param = self::create_updated_input_parameters($request);
    $response = new JSONResponse( self::search_database_updated($param, 'icrp_load_database') );
    return self::add_cors_headers($response);
  }

  /**
   * Callback for `db/public/search/` API method.
   */
  public function load_public_search_sort_paginate( Request $request ) {

    $param = [
      'search_id' => NULL,
      'page_size' => 50,
      'page_number' => 1,
      'sort_column' => 'title',
      'sort_type' => 'ASC'
    ];

    foreach(array_keys($param) as $key) {
      $value = $request->query->get($key);

      if ($key == 'sort_column') {
        $value = self::$sort_column_mappings[$value];
      }

      if ($value) {
        $param[$key] = $value;
      }
    }

    $response = new JSONResponse( self::sort_paginate_search_results($param, 'icrp_load_database') );
    return self::add_cors_headers($response);
  }

  public function retrieve_sponsor_upload_table() {
    $pdo = self::get_connection('icrp_load_database');

    $stmt = $pdo->prepare('SET NOCOUNT ON; EXECUTE GetDataUploadInStaging');

    $output = [];
    if ($stmt->execute()) {
      while ($row = $stmt->fetch()) {
        array_push($output, [
          'sponsor_code'  => $row['SponsorCode'],
          'funding_years' => $row['FundingYear'],
          'received_date' => $row['ReceivedDate'],
          'note'          => $row['Note'],
        ]);
      }
    }


    foreach($output as &$row) {
      // add sponsor ids to sponsor codes
      $sponsors = [];
      $sponsor_code = $row['sponsor_code'];
      $sponsor_stmt = $pdo->prepare('SELECT FundingOrgID AS [value] from FundingOrg where SponsorCode=:sponsor_code');

      if ($sponsor_stmt->execute([':sponsor_code' => $sponsor_code])) {
        $rows = (array) $sponsor_stmt->fetchAll(PDO::FETCH_ASSOC);
        $sponsors = array_column($rows, 'value');
      }

      $row['sponsor_code'] = $sponsors;
      array_push($row['sponsor_code'], $sponsor_code);


      $dates = $row['funding_years'];

      // split funding years to date ranges
      if (strpos($dates, '-') !== false) {
        $date_array = explode('-', $dates);

        $start_date = $date_array[0];
        $end_date = $date_array[1];
        $row['funding_years'] = range($start_date, $end_date);
      }

      else {
        $row['funding_years'] = [$dates];
      }

    }

    return $output;
  }

  /**
   * Callback for `db/public/analytics/` API method.
   */
  public function load_public_analytics( Request $request ) {
//    $param = self::map_fields($request);
    $param = $request->query->get('search_id');
    $response = new JSONResponse( self::get_analytics_updated($param, 'icrp_load_database') );
    return self::add_cors_headers($response);
  }

  /**
   * Callback for `db/partner/search/` API method.
   */
  public function load_partner_search( Request $request ) {
    $param = self::map_fields($request);
    $response = new JSONResponse( self::search_database_updated($param, 'icrp_load_database') );
    return self::add_cors_headers($response);
  }

  /**
   * Callback for `db/partner/analytics/` API method.
   */
  public function load_partner_analytics( Request $request ) {
    //$param = self::map_fields($request);
    $param = $request->query->get('search_id');
    $response = new JSONResponse( self::get_partner_analytics_updated($param, 'icrp_load_database') );
    return self::add_cors_headers($response);
  }

  public function load_partner_analytics_funding( Request $request ) {
    //$param = self::map_fields($request);
    $search_id = $request->query->get('search_id');
    $year = $request->query->get('year');

    if (!$year) {
      $year = 2017;
    }

    $response = new JSONResponse( self::get_partner_analytics_funding($search_id, $year, 'icrp_load_database') );
    return self::add_cors_headers($response);
  }

  public function load_partner_analytics_funding_years(  ) {
    //$param = self::map_fields($request);
    $response = new JSONResponse( self::get_partner_analytics_funding_years('icrp_load_database') );
    return self::add_cors_headers($response);
  }


  public function load_retrieve_parameters( Request $request ) {
    $search_id = $request->query->get('search_id');
    $response = new JSONResponse( self::retrieve_search_parameters($search_id, 'icrp_load_database') );
    return self::add_cors_headers($response);
  }

  public function load_sponsor_upload_table( Request $request ) {
    $response = new JSONResponse( self::retrieve_sponsor_upload_table() );
    return self::add_cors_headers($response);
  }

}

