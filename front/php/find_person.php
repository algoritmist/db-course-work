<?php

function find_person(){
  require_once "Connection.php";
  header('Access-Control-Allow-Origin: *');
  header('Access-Control-Allow-Headers: *');

  $data = json_decode(file_get_contents('php://input'), true);
    if(!isset($data["id"])){
        echo "error: id required for find person request";
        return;
    }
    if(!isset($data["first_name"])){
        echo "error: first_name required for find person request";
        return;
    }
    if(!isset($data["last_name"])){
        echo "error: last_name required for find person request";
        return;
    }
    $id = $data["id"];
    $first_name = $data["first_name"];
    $last_name = $data["last_name"];
    $result = $conn->query("SELECT find_person($id, '$first_name','$last_name') AS journal")->fetch();
    $jid = (int) $result["journal"];
    $location_id = $conn->query("SELECT МЕСТО_ПРОВЕДЕНИЯ FROM ВЕДОМОСТЬ WHERE ИД = $jid;")->fetch();
    $loc = $location_id["МЕСТО_ПРОВЕДЕНИЯ"];
    $location = $conn->query("SELECT ШИРОТА, ДОЛГОТА FROM МЕСТОПОЛОЖЕНИЕ WHERE ИД = $loc")->fetch();

    echo "latitude " , $location["ШИРОТА"],
        " longitude " , $location["ДОЛГОТА"],
        " journal_id " , $jid;
}

find_person();
?>
