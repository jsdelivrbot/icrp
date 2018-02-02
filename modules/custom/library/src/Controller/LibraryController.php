<?php

namespace Drupal\library\Controller;

use Drupal\Core\Controller\ControllerBase;
use Drupal\Core\Url;
use Ds\Set;
use PDO;
use Symfony\Component\HttpFoundation\BinaryFileResponse;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\HttpFoundation\Response;
use Zipstream\ZipStream;

class LibraryController extends ControllerBase {
  public function testQuery() {
    return new JsonResponse(array(),$status=Response::HTTP_FORBIDDEN);
    $return = array();
    $connection = self::get_connection();
    $stmt = $connection->prepare(
      "SELECT * FROM Library WHERE LibraryID IN (5,1121)"
    );
    if ($stmt->execute()) {
      while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        $row_output = array();
        foreach ($row as $key=>$value) {
          $row_output[$key] = $value;
        }
        array_push($return,$row_output);
      }
    }
    return new BinaryFileResponse($zip);
  }

  private static $initFolderQuery = array(
    "public" => "SELECT ".
          "a.*, ".
          "0 AS ArchivedCount, ".
          "SUM(CASE WHEN b.ArchivedDate IS NULL THEN 1 ELSE 0 END)-SUM(CASE WHEN b.LibraryID IS NULL THEN 1 ELSE 0 END) AS UnarchivedCount ".
        "FROM LibraryFolder a ".
        "LEFT OUTER JOIN Library b ON a.LibraryFolderID = b.LibraryFolderID AND b.IsPublic=1 AND b.archivedDate IS NULL ".
        "WHERE a.IsPublic=1 AND a.archivedDate IS NULL AND a.ParentFolderID > 0 ".
        "GROUP BY a.Name, a.LibraryFolderID, a.ParentFolderID, a.IsPublic, a.ArchivedDate, a.CreatedDate, a.UpdatedDate ".
        "ORDER BY a.Name;",
    "private" => "SELECT ".
          "a.*, ".
          "0 AS ArchivedCount, ".
          "SUM(CASE WHEN b.ArchivedDate IS NULL THEN 1 ELSE 0 END)-SUM(CASE WHEN b.LibraryID IS NULL THEN 1 ELSE 0 END) AS UnarchivedCount ".
        "FROM LibraryFolder a ".
        "LEFT OUTER JOIN Library b ON a.LibraryFolderID = b.LibraryFolderID AND b.archivedDate IS NULL ".
        "WHERE a.archivedDate IS NULL AND a.ParentFolderID > 0 ".
        "GROUP BY a.Name, a.LibraryFolderID, a.ParentFolderID, a.IsPublic, a.ArchivedDate, a.CreatedDate, a.UpdatedDate ".
        "ORDER BY a.Name;",
    "partner" => "SELECT ".
          "a.*, ".
          "0 AS ArchivedCount, ".
          "SUM(CASE WHEN b.ArchivedDate IS NULL THEN 1 ELSE 0 END)-SUM(CASE WHEN b.LibraryID IS NULL THEN 1 ELSE 0 END) AS UnarchivedCount ".
        "FROM LibraryFolder a ".
        "LEFT OUTER JOIN Library b ON a.LibraryFolderID = b.LibraryFolderID AND b.ArchivedDate IS NULL ".
        "WHERE a.ParentFolderID > 0 ".
        "GROUP BY a.Name, a.LibraryFolderID, a.ParentFolderID, a.IsPublic, a.ArchivedDate, a.CreatedDate, a.UpdatedDate ".
        "ORDER BY a.Name;",
    "admin" => "SELECT ".
          "a.*, ".
          "COUNT(b.ArchivedDate) AS ArchivedCount, ".
          "SUM(CASE WHEN b.ArchivedDate IS NULL THEN 1 ELSE 0 END)-SUM(CASE WHEN b.LibraryID IS NULL THEN 1 ELSE 0 END) AS UnarchivedCount ".
        "FROM LibraryFolder a ".
        "LEFT OUTER JOIN Library b ON a.LibraryFolderID = b.LibraryFolderID ".
        "WHERE a.ParentFolderID > 0 ".
        "GROUP BY a.Name, a.LibraryFolderID, a.ParentFolderID, a.IsPublic, a.ArchivedDate, a.CreatedDate, a.UpdatedDate ".
        "ORDER BY a.Name;"
  );
  private static $folderQuery = array(
    "public" => "SELECT * FROM LibraryFolder WHERE IsPublic=1 AND archivedDate IS NULL AND LibraryFolderID=:lfid;",
    "private" => "SELECT * FROM LibraryFolder WHERE archivedDate IS NULL AND LibraryFolderID=:lfid;",
    "partner" => "SELECT * FROM LibraryFolder WHERE archivedDate IS NULL AND LibraryFolderID=:lfid;",
    "admin" => "SELECT * FROM LibraryFolder WHERE archivedDate IS NULL AND LibraryFolderID=:lfid;"
  );
  private static $fileQuery = array(
    "public" => "SELECT * FROM Library WHERE IsPublic=1 AND archivedDate IS NULL AND LibraryFolderID=:lfid ORDER BY CreatedDate DESC, LOWER(Title);",
    "private" => "SELECT * FROM Library WHERE archivedDate IS NULL AND LibraryFolderID=:lfid ORDER BY CreatedDate DESC, LOWER(DisplayName);",
    "partner" => "SELECT * FROM Library WHERE archivedDate IS NULL AND LibraryFolderID=:lfid ORDER BY CreatedDate DESC, LOWER(DisplayName);",
    "admin" => "SELECT * FROM Library WHERE LibraryFolderID=:lfid ORDER BY CreatedDate DESC, LOWER(DisplayName);"
  );
  private static $fileSearch = array(
    "public" => "SELECT * FROM Library WHERE IsPublic=1 AND archivedDate IS NULL AND (LOWER(DisplayName) LIKE :keywords1 OR LOWER(Title) LIKE :keywords2 OR LOWER(Description) LIKE :keywords3) ORDER BY CreatedDate DESC, LOWER(Title);",
    "private" => "SELECT * FROM Library WHERE archivedDate IS NULL AND (LOWER(DisplayName) LIKE :keywords1 OR LOWER(Title) LIKE :keywords2 OR LOWER(Description) LIKE :keywords3) ORDER BY CreatedDate DESC, LOWER(Title);",
    "partner" => "SELECT * FROM Library WHERE archivedDate IS NULL AND (LOWER(DisplayName) LIKE :keywords1 OR LOWER(Title) LIKE :keywords2 OR LOWER(Description) LIKE :keywords3) ORDER BY CreatedDate DESC, LOWER(Title);",
    "admin" => "SELECT * FROM Library WHERE (LOWER(DisplayName) LIKE :keywords1 OR LOWER(Title) LIKE :keywords2 OR LOWER(Description) LIKE :keywords3) ORDER BY CreatedDate DESC, LOWER(Title);"
  );

  public function content() {
    $request = \Drupal::request();
    if ($route = $request->attributes->get(\Symfony\Cmf\Component\Routing\RouteObjectInterface::ROUTE_OBJECT)) {
      $route->setDefault('_title', 'Library');
    }
    return [
      '#theme' => 'library',
      '#attached' => [
        'library' => [
          'library/resources'
        ],
      ],
    ];
  }

  public function onLoad() {
    $returnValue = array(
      "role" => "public",
      "initial" => array(),
      "folders" => []
    );
    $returnValue["role"] = self::getRole();
    $connection = self::get_connection();
    $stmt = $connection->prepare(self::$initFolderQuery[$returnValue["role"]]);
    if ($stmt->execute()) {
      while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        $row_output = array();
        foreach ($row as $key=>$value) {
          $row_output[$key] = $value;
        }
        array_push($returnValue["folders"],$row_output);
      }
      $returnValue["initial"] = $returnValue["folders"][0];
    }
    return new JsonResponse($returnValue);
  }

  public function searchFiles() {
    $role = self::getRole();
    $keywords = \Drupal::request()->request->get('keywords');
    $keywords = '%'.$keywords.'%';
    $result = array();
    $connection = self::get_connection();
    $stmt = $connection->prepare(self::$fileSearch[$role]);
    $stmt->bindParam(":keywords1",$keywords);
    $stmt->bindParam(":keywords2",$keywords);
    $stmt->bindParam(":keywords3",$keywords);
    if ($stmt->execute()) {
      while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        $row_output = array();
        foreach ($row as $key=>$value) {
          $row_output[$key] = $value;
        }
        array_push($result,$row_output);
      }
    }
    return new JsonResponse($result);
  }

  public function fileRest($id) {
    $method = \Drupal::request()->getMethod();
    switch ($method) {
      case "DELETE":
        if (self::getRole() == "admin") {
          return new JsonResponse(self::archiveFile($id));
        } else {
          return new JsonResponse(array(
            "success"=>false
          ), Response::HTTP_FORBIDDEN);
        }
        break;
      case "PUT":
        if (self::getRole() == "admin") {
          return new JsonResponse(self::unarchiveFile($id));
        } else {
          return new JsonResponse(array(
            "success"=>false
          ), Response::HTTP_FORBIDDEN);
        }
        break;
    }
  }

  public function folderRest($id) {
    $method = \Drupal::request()->getMethod();
    switch ($method) {
      case "GET":
        return self::getFolder($id);
        break;
      case "DELETE":
        if (self::getRole() == "admin") {
          return new JsonResponse(self::archiveFolder($id));
        } else {
          return new JsonResponse(array(
            "success"=>false
          ), Response::HTTP_FORBIDDEN);
        }
        break;
      case "PUT":
        if (self::getRole() == "admin") {
          return new JsonResponse(self::unarchiveFolder($id));
        } else {
          return new JsonResponse(array(
            "success"=>false
          ), Response::HTTP_FORBIDDEN);
        }
        break;
    }
  }

  public function postFolder() {
    $params = \Drupal::request()->request->all();
    if (!isset($params['id_value']) || empty($params['id_value'])) {
      $params['id_value'] = null;
    }
    $new = ($params['id_value'] == null);
    if (!isset($params['is_public'])) {
      $params['is_public'] = "0";
    }
    if (!isset($params["title"]) || empty($params["title"]) ||
        !isset($params["parent"]) || !is_numeric($params["parent"])) {
      return new JsonResponse(array(
          "success"=>false
      ));
    }
    $connection = self::get_connection();
    if ($new) {
      $stmt = $connection->prepare("SELECT CASE WHEN ArchivedDate IS NULL THEN NULL ELSE GETDATE() END AS ArchivedDate FROM LibraryFolder WHERE LibraryFolderID=:pfid");
      $stmt->bindParam(":pfid",$params["parent"]);
      if ($stmt->execute()) {
        $row_output = array();
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
          foreach ($row as $key=>$value) {
            $row_output[$key] = $value;
          }
          break;
        }
        $stmt = $connection->prepare("INSERT INTO LibraryFolder (Name,ParentFolderID,IsPublic,ArchivedDate) OUTPUT INSERTED.* VALUES (:name,:pfid,:ip,:ad);");
        $stmt->bindParam(":name",$params["title"]);
        $stmt->bindParam(":pfid",$params["parent"]);
        $stmt->bindParam(":ip",$params["is_public"]);
        $stmt->bindParam(":ad",$row_output["ArchivedDate"]);
        if ($stmt->execute()) {
          while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            $row_output = array();
            foreach ($row as $key=>$value) {
              $row_output[$key] = $value;
            }
            return new JsonResponse(array(
              "success"=>true,
              "row"=>$row_output
            ));
          }
        }
      }
    } else {
      $stmt = $connection->prepare("UPDATE LibraryFolder SET ParentFolderID=:pfid, Name=:name, IsPublic=:ip, UpdatedDate=GETDATE() OUTPUT inserted.* WHERE LibraryFolderID=:lfid");
      $stmt->bindParam(":pfid",$params["parent"]);
      $stmt->bindParam(":name",$params["title"]);
      $stmt->bindParam(":ip",$params["is_public"]);
      $stmt->bindParam(":lfid",$params["id_value"]);
      if ($stmt->execute()) {
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
          $row_output = array();
          foreach ($row as $key=>$value) {
            $row_output[$key] = $value;
          }
          return new JsonResponse(array(
            "success"=>true,
            "row"=>$row_output
          ));
        }
      }
    }
  }

  public function postFile() {
    $role = self::getRole();
    $params = \Drupal::request()->request->all();
    if (!isset($params['id_value']) || empty($params['id_value'])) {
      $params['id_value'] = null;
    }
    $new = ($params['id_value'] == null);
    if ($role == "public" || $role == "private" || ($role == "partner" && !$new)) {
      return new JsonResponse(array(
          "success"=>false
      ),Response::HTTP_FORBIDDEN);
    }
    if (!isset($params['is_public'])) {
      $params['is_public'] = "0";
    }
    $upload = \Drupal::request()->files->get('upload');
    $thumb = \Drupal::request()->files->get('thumbnail');
    if (!isset($params["title"]) || empty($params["title"]) ||
        !isset($params["parent"]) || !is_numeric($params["parent"]) ||
        !isset($params["description"]) || empty($params["description"]) ||
        ($new && $upload == null) ||
        ($upload != null && !$upload->isValid())
      ) {
      return new JsonResponse(array(
          "success"=>false
      ),Response::HTTP_BAD_REQUEST);
    }

    if ($thumb && !$thumb->isValid()) $thumb = null;
    $connection = self::get_connection();
    if ($new) {
      $stmt = $connection->prepare("
          EXECUTE AddLibraryFile
            :lfid,
            :title,
            :desc,
            :ip,
            :file,
            :thumb,
            :display
        ");
      $stmt->bindParam(":lfid",$params["parent"]);
      $stmt->bindParam(":title",$params["title"]);
      $stmt->bindParam(":desc",$params["description"]);
      $stmt->bindParam(":ip",$params["is_public"]);
      $stmt->bindValue(":file",$upload->getClientOriginalName());
      if ($thumb) {
        $stmt->bindValue(":thumb",$thumb->getClientOriginalName());
      } else {
        $stmt->bindValue(":thumb",null,PDO::PARAM_NULL);
      }
      $stmt->bindValue(":display",$upload->getClientOriginalName());
      if ($stmt->execute()) {
        $row = array_merge(array(),$stmt->fetchAll(PDO::FETCH_ASSOC))[0];
        $upload->move("public://library/uploads",$row['Filename']);
        if ($thumb) $thumb->move("public://library/uploads/thumbs",$row['ThumbnailFilename']);
        return new JsonResponse(array(
          "success"=>true,
          "row"=>$row
        ));
      }
    } else {
      $stmt = $connection->prepare("EXECUTE UpdateLibraryFile
          :lid,
          :lfid,
          :title,
          :desc,
          :ip,
          :file,
          :display
        ");
      $stmt->bindParam(":lid",$params["id_value"]);
      $stmt->bindParam(":lfid",$params["parent"]);
      $stmt->bindParam(":title",$params["title"]);
      $stmt->bindParam(":desc",$params["description"]);
      $stmt->bindParam(":ip",$params["is_public"]);
      if ($upload) {
        $stmt->bindValue(":file",$upload->getClientOriginalName());
      } else {
        $stmt->bindValue(":file",null,PDO::PARAM_NULL);
      }
      $stmt->bindParam(":display",$params["display_name"]);
      if ($stmt->execute()) {
          $row = array_merge(array(),$stmt->fetchAll(PDO::FETCH_ASSOC))[0];
          if ($upload) $upload->move("public://library/uploads",$row['Filename']);
          //if ($thumb) $thumb->move("public://library/uploads/thumbs",$row['ThumbnailFilename']);
          return self::getFolder($params["parent"]);
      }
    }
    return new JsonResponse(array(
        "success"=>false
    ),Response::HTTP_INTERNAL_SERVER_ERROR);
  }

  public function thumbsDownload($file) {
    if (self::getRole() == "public") {
      $connection = self::get_connection();
      $stmt = $connection->prepare("SELECT IsPublic FROM Library WHERE IsPublic=1 AND ThumbnailFilename=:file");
      $stmt->bindParam(":file",$file);
      if (!$stmt->execute() || $stmt->rowCount() == 0) {
        return new RedirectResponse(Url::fromUserInput('/user/login',array("query"=>array("destination"=>\Drupal::request()->getRequestUri())))->toString(),$status=Response::HTTP_TEMPORARY_REDIRECT);
      }
    }
    return self::getFile(join('/',array("thumbs",$file)));
  }

  private function archiveFile($id) {
    $connection = self::get_connection();
    $stmt = $connection->prepare("UPDATE Library SET ArchivedDate=GETDATE(), UpdatedDate=GETDATE() WHERE LibraryID=:lid");
    $stmt->bindParam(":lid",$id);
    if ($stmt->execute()) {
      return array(
        "success"=>true
      );
    }
    return array(
      "success"=>false,
      Response::HTTP_INTERNAL_SERVER_ERROR
    );
  }

  private function unarchiveFile($id) {
    $returnValue = array(
      "success"=>false
    );
    $connection = self::get_connection();
    $stmt1 = $connection->prepare("UPDATE Library SET ArchivedDate=NULL, UpdatedDate=GETDATE() WHERE LibraryID=:lid");
    $stmt1->bindParam(":lid",$id);
    $stmt2 = $connection->prepare("SELECT * FROM Library WHERE LibraryID=:lid");
    $stmt2->bindParam(":lid",$id);
    if ($stmt1->execute() && $stmt2->execute()) {
      $returnValue['success'] = true;
      while ($row = $stmt2->fetch(PDO::FETCH_ASSOC)) {
        $row_output = array();
        foreach ($row as $key=>$value) {
          $row_output[$key] = $value;
        }
        $result = self::unarchiveFolder($row_output['LibraryFolderID']);
        if ($result["success"]) {
          $returnValue['ids'] = $result['ids'];
        } else {
          $returnValue['success'] = false;
        }
      }
    }
    return $returnValue;
  }

  private function archiveFolder($id) {
    $connection = self::get_connection();
    $stmt = $connection->prepare("UPDATE Library SET ArchivedDate=GETDATE(), UpdatedDate=GETDATE() WHERE ArchivedDate IS NULL AND LibraryFolderID=:lfid;");
    $stmt->bindParam(":lfid",$id);
    if ($stmt->execute()) {
      return array(
        "success"=>true
      );
    }
    return array(
      "success"=>false
    );
  }

  private function unarchiveFolder($id) {
    return new JsonResponse(array("success"=>false),Response::HTTP_FORBIDDEN);
    $returnValue = array(
      "success"=>false,
      "ids"=>array($id)
    );
    $connection = self::get_connection();
    $stmt1 = $connection->prepare("SELECT ParentFolderID FROM LibraryFolder WHERE ArchivedDate IS NOT NULL AND ParentFolderID > 0 AND LibraryFolderID=:lfid;");
    $stmt1->bindParam(":lfid",$id);
    $stmt2 = $connection->prepare("UPDATE LibraryFolder SET ArchivedDate=NULL, UpdatedDate=GETDATE() WHERE ArchivedDate IS NOT NULL AND LibraryFolderID=:lfid");
    $stmt2->bindParam(":lfid",$id);
    if ($stmt1->execute() && $stmt2->execute()) {
      $returnValue['success'] = true;
      while ($row = $stmt1->fetch(PDO::FETCH_ASSOC)) {
        $row_output = array();
        foreach ($row as $key=>$value) {
          $row_output[$key] = $value;
        }
        $id = $row_output['ParentFolderID'];
        $result = self::unarchiveFolder($id);
        if (!$result["success"]) $returnValue['success'] = false;
        $returnValue['ids'] = array_merge($returnValue['ids'],$result['ids']);
      }
    }
    return $returnValue;
  }

  public function bulkDownload() {
    $downloads = explode(",",\Drupal::request()->query->get('downloads'));
    $result = array();
    $connection = self::get_connection();
    $stmt = $connection->prepare("SELECT * FROM Library WHERE ArchivedDate IS NULL AND LibraryID IN (".implode(",",array_fill(0,count($downloads),"?")).")");
    foreach ($downloads as $k => $id)
      $stmt->bindValue(($k+1), $id);
    $zip = new \ZipStream\ZipStream('archive.zip');
    if ($stmt->execute()) {
      while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        $row_output = array();
        foreach ($row as $key=>$value) {
          $row_output[$key] = $value;
        }
        array_push($result,$row_output);
        try {
          $zip->addFileFromPath($row_output['DisplayName'],join('/',array(drupal_realpath('public://library/uploads'),$row_output['Filename'])));
        } catch (\Zipstream\Exception\FileNotFoundException $e) { }
      }
    }
    $zip->finish();
    return new Response();
  }

  public function fileDownload($id,$name) {
    $connection = self::get_connection();
    $request = "SELECT Filename FROM Library WHERE LibraryID=:lfid AND DisplayName=:file";
    if (self::getRole() == "public") {
      $request .= " AND IsPublic=1";
    }
    $stmt = $connection->prepare($request);
    $stmt->bindParam(":lfid",$id);
    $stmt->bindParam(":file",$name);
    if (!$stmt->execute() || $stmt->rowCount() == 0) {
      return new RedirectResponse(Url::fromUserInput('/user/login',array("query"=>array("destination"=>\Drupal::request()->getRequestUri())))->toString(),$status=Response::HTTP_TEMPORARY_REDIRECT);
    }
    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    $row_output = array();
    foreach ($row as $key=>$value) {
      $row_output[$key] = $value;
    }
    return self::getFile($row_output["Filename"]);
  }

  private function getFile($location) {
    $uploads_folder = \Drupal::config('library')->get('uploads_folder') ?? 'data/library/uploads';
    return new BinaryFileResponse(join('/',array($uploads_folder,$location)));
  }

  private function getFolder($id) {
    $returnValue = array(
      "isPublic" => false,
      "files" => []
    );
    $role = self::getRole();
    $connection = self::get_connection();
    $stmt = $connection->prepare(self::$folderQuery[$role]);
    $stmt->bindParam(":lfid",$id);
    if ($stmt->execute()) {
      while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        $returnValue["isPublic"] = $row["IsPublic"]=="1";
        break;
      }
      $stmt = $connection->prepare(self::$fileQuery[$role]);
      $stmt->bindParam(":lfid",$id);
      if ($stmt->execute()) {
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
          $row_output = array();
          foreach ($row as $key=>$value) {
            $row_output[$key] = $value;
          }
          array_push($returnValue["files"],$row_output);
        }
      }
    }
    return new JsonResponse($returnValue);
  }

  private function getRole() {
    $user = \Drupal\user\Entity\User::load(\Drupal::currentUser()->id());
    $role = "public";
    $authenticated = $user->isAuthenticated();
    if ($authenticated) {
      if ($user->get('field_can_upload_library_files')->getValue()[0]['value'] == "1") {
        $role = "partner";
      } else {
        $role = "private";
      }
      foreach (parent::currentUser()->getRoles() as $value) {
        if ($value == "administrator" || $value == "manager") {
          $role = "admin";
          break;
        }
      }
    }
    return $role;
  }

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
  private function get_connection() {
    $cfg = [];
    $icrp_database = \Drupal::config('icrp_database');
    foreach(['driver', 'host', 'port', 'database', 'username', 'password'] as $key) {
       $cfg[$key] = $icrp_database->get($key);
    }
    // connection string
    $cfg['dsn'] =
      $cfg['driver'] .
      ":Server={$cfg['host']},{$cfg['port']}" .
      ";Database={$cfg['database']};ConnectionPooling=0";
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
}