<?php
require_once "Connection.php";
function war($con){
    if(!isset($_POST["id"])){
        return "error: id required for find person request";
    }
    if(!isset($_POST["journal_id"])){
        return "error: journal_id required for war";
    }
    $id = $_POST["id"];
    $jid = $_POST["journal_id"];
    $cid = $con->query("SELECT КОНТРАКТ_ИД FROM ВЕДОМОСТЬ WHERE ИД = $jid")->fetch();
    $rid = $con->query("SELECT ЗАЯВКА_ИД FROM КОНТРАКТ WHERE ИД = $cid")->fetch();
    $opponent_id = $con->query("SELECT ЦЕЛЬ_ЧЛВК_ИД FROM ЗАЯВКА WHERE ИД = $rid")->fetch();
    $result = $con->query("SELECT war($id, $opponent_id) AS coordinates_id")->fetch();
    $coordinates_id = $result["coordinates_id"];
    $coordinates = $con->query("SELECT ШИРОТА, ДОЛГОТА FROM МЕСТОПОЛОЖЕНИЕ WHERE ИД = $coordinates_id")->fetch();
    /*
    returns where war took place
    */
    return array(
        "latitude" => $coordinates["ШИРОТА"],
        "longitude" => $coordinates["ДОЛГОТА"]
    );
}

return war($conn);
?>