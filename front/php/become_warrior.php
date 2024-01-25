<?php

require_once "Connection.php";

function become_warrior($con){
    if(!isset($_POST["id"])){
        return "error: id required for find person request";
    }
    if(!isset($_POST["warrior_type"])){
        return "error: warrior type required";
    }
    $id = $_GET["id"];
    $warrior_type = $_POST["warrior_type"];
    $who = $warrior_type == "soldier" ? "warrior" : "leader";
    $result = $con->query("SELECT be_$who($id) as satisfied")->fetch();
    return $result["satisfied"];
}

return become_warrior($conn);

?>