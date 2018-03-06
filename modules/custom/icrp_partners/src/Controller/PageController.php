<?php

/**
 * @file
 * Contains \Drupal\icrp_partners\Controller\PageController.
 */

namespace Drupal\icrp_partners\Controller;

use Drupal\Core\Controller\ControllerBase;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\StreamedResponse;
use PDO;

class PageController extends ControllerBase {


    public static function content(): array {
        \Drupal::service('page_cache_kill_switch')->trigger();

        $pdo = PDOBuilder::getConnection();

        $partners = PDOBuilder::executePreparedStatement(
            $pdo, 'EXECUTE GetPartners'
        )->fetchAll();

        $fundingOrganizations = PDOBuilder::executePreparedStatement(
            $pdo, 'EXECUTE GetFundingOrgs @type=funding'
        )->fetchAll();

        usort($partners, function($a, $b) {
            return strcmp($a['name'], $b['name']);
        });

        return [
            '#theme' => 'icrp_partners',
            '#partners' => $partners,
            '#fundingOrganizations' => $fundingOrganizations,
            '#attached' => [
                'library' => [
                    'icrp_partners/content'
                ],
            ],
        ];
    }

    public static function export(): StreamedResponse {
        return new StreamedResponse(function() {
            $pdo = PDOBuilder::getConnection();
            ExcelBuilder::exportQueries('ICRP Partners and Funding Orgs.xlsx', [
                [
                    'title' => 'ICRP Partners',
                    'query' => $pdo->prepare('EXECUTE GetPartners'),
                    'columns' => [
                        'name' => 'Partner Name',
                        'sponsorcode' => 'Sponsor Code',
                        'country' => 'Country',
                        'joindate' => 'Join Date',
                        'status' => 'Status',
                        'description' => 'Mission',
                    ],
                ],

                [
                    'title' => 'ICRP Funding Organizations',
                    'query' => $pdo->prepare('EXECUTE GetFundingOrgs @type=funding'),
                    'columns' => [
                       'name' => 'Name',
                       'type' => 'Type',
                       'memberstatus' => 'Status',
                       'abbreviation' => 'Abbreviation',
                       'sponsorcode' => 'Sponsor Code',
                       'country' => 'Country',
                       'currency' => 'Currency',
                       'isannualized' => [
                           'name' => 'Annualized Funding',
                           'formatter' => function($value) {
                                return $value ? 'YES' : 'NO';
                           }],
                       'lastimportdate' => 'Last Import Date',
                       'lastimportdesc' => 'Import Description',
                    ],
                ],
            ]);
        });
    }


    public static function authenticatedExport(): StreamedResponse {
        return new StreamedResponse(function() {
            $pdo = PDOBuilder::getConnection();
            ExcelBuilder::exportQueries('ICRP Partners and Funding Orgs.xlsx', [
                [
                    'title' => 'ICRP Partners',
                    'query' => $pdo->prepare('EXECUTE GetPartners'),
                    'columns' => [
                        'name' => 'Partner Name',
                        'sponsorcode' => 'Sponsor Code',
                        'country' => 'Country',
                        'joindate' => 'Join Date',
                        'status' => 'Status',
                        'description' => 'Mission',
                    ],
                ],

                [
                    'title' => 'ICRP Funding Organizations',
                    'query' => $pdo->prepare('EXECUTE GetFundingOrgs @type=funding'),
                    'columns' => [
                       'name' => 'Name',
                       'type' => 'Type',
                       'memberstatus' => 'Status',
                       'abbreviation' => 'Abbreviation',
                       'sponsorcode' => 'Sponsor Code',
                       'country' => 'Country',
                       'currency' => 'Currency',
                       'isannualized' => [
                           'name' => 'Annualized Funding',
                           'formatter' => function($value) {
                                return $value ? 'YES' : 'NO';
                           }],
                       'lastimportdate' => 'Last Import Date',
                       'lastimportdesc' => 'Import Description',
                    ],
                ],
            ]);
        });
    }
}