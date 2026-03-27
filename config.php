<?php

// Local defaults.
$server = "localhost";
$user = "root";
$password = "";
$database_name = "seminair";
$db_port = 3306;

// Override from explicit env vars.
$server = getenv('DB_HOST') ?: $server;
$user = getenv('DB_USER') ?: $user;
$password = getenv('DB_PASSWORD') !== false ? getenv('DB_PASSWORD') : $password;
$database_name = getenv('DB_NAME') ?: $database_name;
$db_port = (int) (getenv('DB_PORT') ?: $db_port);

// Support URL-style env vars from cloud DB providers.
$databaseUrl = getenv('DATABASE_URL') ?: (getenv('MYSQL_URL') ?: getenv('MYSQL_PUBLIC_URL'));
if ($databaseUrl) {
    $parts = parse_url($databaseUrl);
    if ($parts !== false) {
        $server = $parts['host'] ?? $server;
        $user = $parts['user'] ?? $user;
        $password = $parts['pass'] ?? $password;
        $db_port = isset($parts['port']) ? (int) $parts['port'] : $db_port;
        if (!empty($parts['path'])) {
            $database_name = ltrim($parts['path'], '/');
        }
    }
}

mysqli_report(MYSQLI_REPORT_OFF);
$db = @new mysqli($server, $user, $password, $database_name, $db_port);

if ($db->connect_errno) {
    $onVercel = getenv('VERCEL') === '1';
    if ($onVercel && $server === 'localhost') {
        http_response_code(500);
        die('Database belum diset di Vercel. Isi env DB_HOST, DB_PORT, DB_USER, DB_PASSWORD, DB_NAME (atau DATABASE_URL).');
    }

    die("Gagal terhubung dengan database: " . $db->connect_error);
}


return $db;
