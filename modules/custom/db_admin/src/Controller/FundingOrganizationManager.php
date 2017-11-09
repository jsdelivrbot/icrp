<?php

namespace Drupal\db_admin\Controller;
use Drupal\db_admin\Helpers\PDOBuilder;
use PDO;

class FundingOrganizationManager {

  const FUNDING_ORGANIZATION_PARAMETERS = [
    'sponsor_code'              => NULL,
    'member_type'               => NULL,
    'member_status'             => NULL,
    'organization_name'         => NULL,
    'organization_abbreviation' => NULL,
    'organization_type'         => NULL,
    'is_annualized'             => NULL,
    'country'                   => NULL,
    'currency'                  => NULL,
    'note'                      => NULL,
    'latitude'                  => NULL,
    'longitude'                 => NULL,
    'website'                   => NULL,
  ];

  public static function getFields(PDO $pdo) {
    $queries = [

      'funding_organizations' => 'SELECT
                                    FundingOrgID as funding_organization_id,
                                    Name as organization_name,
                                    Type as organization_type,
                                    Abbreviation as organization_abbreviation,
                                    SponsorCode as sponsor_code,
                                    MemberType as member_type,
                                    MemberStatus as member_status,
                                    Website as organization_website,
                                    Country as country,
                                    Longitude as longitude,
                                    Latitude as latitude,
                                    Currency as currency,
                                    IsAnnualized as is_annualized,
                                    Note as note
                                    FROM FundingOrg',

      'partners'    =>  'SELECT
                          p.SponsorCode AS value,
                          p.Name AS label,
                          p.Country AS country,
                          c.Currency AS currency
                          FROM Partner p
                          LEFT JOIN Country c ON p.Country = c.Abbreviation
                          ORDER BY label ASC',

      'countries'   =>  'SELECT
                          LTRIM(RTRIM(Abbreviation)) AS value,
                          name AS label,
                          Currency AS currency
                          FROM icrp_data.dbo.Country
                          ORDER BY label ASC',

      'currencies'  =>  'SELECT
                          LTRIM(RTRIM(Code)) AS value,
                          Description AS label
                          FROM Currency
                          ORDER BY value ASC',
    ];

    // map query results to field values
    $fields = [];
    foreach ($queries as $key => $value)
      $fields[$key] = $pdo->query($value)->fetchAll(PDO::FETCH_ASSOC);

    return $fields;
  }

  public static function validate(PDO $pdo, array $parameters) {
    $required_keys = array_keys(self::FUNDING_ORGANIZATION_PARAMETERS);
    $errors = [];

    foreach($required_keys as $key) {
      if (!array_key_exists($key, $parameters)) {
        array_push($errors, ['ERROR' => "Parameter [$key] not found."]);
      }
    }

    $stmt = $pdo->prepare("
      SELECT * FROM FundingOrg
      WHERE (Name = :organization_name OR Abbreviation = :abbreviation)
      AND SponsorCode = :sponsor_code
    ");

    if ($stmt->execute([
      ':organization_name'  => $parameters['organization_name'],
      ':abbreviation'       => $parameters['organization_abbreviation'],
      ':sponsor_code'       => $parameters['sponsor_code'],
    ])) {
      if (!empty($stmt->fetch())) {
        array_push($errors, [
          'ERROR' => 'A funding organization with the same name and sponsor code already exists in the database. '
            . 'No changes have been made.'
          ]);
      }
    }

    return $errors;
  }

  public static function addFundingOrganization(PDO $pdo, array $parameters) {
    try {

      $validation_errors = self::validate($pdo, $parameters);

      if (!empty($validation_errors)) {
        return $validation_errors;
      }

      $stmt = PDOBuilder::createPreparedStatement(
        $pdo,
        "INSERT INTO FundingOrg (
          [Name],
          [Abbreviation],
          [Type],
          [Country],
          [Currency],
          [SponsorCode],
          [MemberType],
          [MemberStatus],
          [IsAnnualized],
          [Note],
          [Latitude],
          [Longitude],
          [Website]
        ) VALUES (
          :organization_name,
          :organization_abbreviation,
          :organization_type,
          :country,
          :currency,
          :sponsor_code,
          :member_type,
          :member_status,
          :is_annualized,
          :note,
          :latitude,
          :longitude,
          :website
        )",
      $parameters);

      if ($stmt->execute()) {
        return [
          ['SUCCESS' => 'The funding organization has been added to the database.']
        ];
      }
    }

    catch (PDOException $e) {
      return [
        ['ERROR' => $e->getMessage()]
      ];
    }

    return [false];
  }


  public static function updateFundingOrganization(PDO $pdo, array $parameters) {
    try {

      $validation_errors = self::validate($pdo, $parameters);

      if (!empty($validation_errors)) {
        return $validation_errors;
      }

      $stmt = PDOBuilder::createPreparedStatement(
        $pdo,
        "EXECUTE UpdateFundingOrg
          @FundingOrgId = :funding_organization_id,
          @Name = :organization_name,
          @Abbreviation = :organization_abbreviation,
          @Type = :organization_type,
          @Country = :country,
          @Currency = :currency,
          @MemberType = :member_type,
          @MemberStatus = :member_status,
          @IsAnnualized = :is_annualized,
          @Note = :note,
          @Website = :website,
          @Latitude = :latitude,
          @Longitude = :longitude
        )",
      $parameters);

      if ($stmt->execute()) {
        return [
          ['SUCCESS' => 'The funding organization has been updated.']
        ];
      }
    }

    catch (PDOException $e) {
      return [
        ['ERROR' => $e->getMessage()]
      ];
    }

    return [false];
  }
}

