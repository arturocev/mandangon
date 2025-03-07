<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

$mysqli = new mysqli("localhost", "root", "", "mandangon");

if ($mysqli->connect_errno) {
    echo "Fallo al conectar a MYSQL: (" . $mysqli->connect_errno . " )";
    $mysqli->connect_error;
} else {
    echo "Conexion exitosa";
}

echo $mysqli->host_info . "\n";
?>