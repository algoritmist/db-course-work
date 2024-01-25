<?php
function authorize(){
  require_once "Connection.php";
  header('Access-Control-Allow-Origin: *');
  header('Access-Control-Allow-Headers: *');
  $data = json_decode(file_get_contents('php://input'), true);
  $fname = $data["first_name"];
  $lname = $data["last_name"];
  $gender = $data["gender"];
  $birthday = $data["birthday"];
  $hell = $data["hellSale"];
  $latitude = $data["latitude"];
  $longitude = $data["longitude"];
  if(!isset($data["first_name"])){
      echo "Unready2";
      return;
  }
  if(!isset($data["last_name"])){
      echo "Unready3";
      return;
  }
  if(!isset($data["gender"])){
        echo "Unready4";
        return;
  }
  if(!isset($data["birthday"])){
    echo "Unready5";
    return;
  }
  if(!isset($data["hellSale"])){
          echo "Unready6";
          return;
  }
  if(!isset($data["latitude"])){
          echo "Unready7";
          return;
    }
    if(!isset($data["longitude"])){
            echo "Unready8";
            return;
    }
    $hellBool = 'false';
    if($hell == 1) $hellBool = 'true';
    $location = $conn->query("INSERT INTO МЕСТОПОЛОЖЕНИЕ(ШИРОТА,ДОЛГОТА) VALUES ($latitude,$longitude)");
    $lastId=$conn->lastInsertId();
    $conn->query("INSERT INTO ЧЕЛОВЕК(ИМЯ,ФАМИЛИЯ,ПОЛ,ДАТА_РОЖДЕНИЯ,СТАТУС_ИД,БАЛАНС,ПРОДАЖА_ДУШИ,МЕСТОПОЛОЖЕНИЕ) VALUES
    ('$fname','$lname','$gender', '$birthday', 1, 100, '$hellBool', $lastId)");
    $lastId=$conn->lastInsertId();
    echo $lastId;
}

authorize();
?>
