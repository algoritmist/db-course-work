<?php
require_once "Connection.php";
function find_object($con){
    if(!isset($_POST["id"])){
        return "error: id required for find person request";
    }
    if(!isset($_POST["object_name"])){
        return "error: subject name required for find person request";
    }
    $id = $_POST["id"];
    $object_name = $_POST["object_name"];
    $result = $con->query("SELECT find_object($id, $object_name) AS owner_id")->fetch();
    $owner_id = $result["owner_id"];
    $owner_info = $con->query("SELECT ИМЯ, ФАМИЛИЯ,МЕСТОПОЛОЖЕНИЕ FROM ЧЕЛОВЕК WHERE ИД = $owner_id")->fetch();
    $location_id = $owner_info["МЕСТОПОЛОЖЕНИЕ"];
    $coordinates = $con->query("SELECT ШИРОТА, ДОЛГОТА FROM МЕСТОПОЛОЖЕНИЕ WHERE МЕСТОПОЛОЖЕНИЕ.ИД = $location_id")->fetch();
    /*
        Info about the previous owner and location of buy
    */
    return array(
        "first_name" => $owner_info["ИМЯ"],
        "last_name" => $owner_info["ФАМИЛИЯ"],
        "latitude" => $coordinates["ШИРОТА"],
        "longitude" => $coordinates["ДОЛГОТА"]
    );
}

return find_object($conn);

?>