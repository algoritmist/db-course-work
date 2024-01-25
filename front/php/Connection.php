<?php
require_once "config.php";
function connect(string $host, string $port, string $db, string $user, string $password): PDO
{
	try {
		$dsn = "pgsql:host=$host;port=$port;dbname=$db;";
		return new PDO(
			$dsn,
			$user,
			$password,
			[PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
		);
		if ($pdo) {
    		echo "Connected to the $db database successfully!";
    	}
	} catch (PDOException $e) {
		die($e->getMessage());
	}
}

$conn = connect($host, $port, $db, $user, $password);

?>
