<?php

// Support local defaults and cloud env vars (e.g. Vercel).
$server = getenv('DB_HOST') ?: "localhost";
$user = getenv('DB_USER') ?: "root";
$password = getenv('DB_PASSWORD') !== false ? getenv('DB_PASSWORD') : "";
$database_name = getenv('DB_NAME') ?: "seminair";
$db_port = (int) (getenv('DB_PORT') ?: 3306);

$db = new mysqli($server, $user, $password, $database_name, $db_port);

if ($db->connect_error) {
    die("Gagal terhubung dengan database: " . $db->connect_error);
}


return $db;
