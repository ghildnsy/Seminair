<?php

// Simple migration runner for this native PHP project.
// Usage: php scripts/migrate.php

$server = 'localhost';
$user = 'root';
$password = '';
$database_name = 'seminair';

$configPath = __DIR__ . '/../config.php';
$configContent = file_exists($configPath) ? file_get_contents($configPath) : false;
if ($configContent !== false) {
    $map = [
        'server' => 'server',
        'user' => 'user',
        'password' => 'password',
        'database_name' => 'database_name',
    ];

    foreach ($map as $varName => $target) {
        $pattern = '/\$' . preg_quote($varName, '/') . '\s*=\s*"([^"]*)"\s*;/';
        if (preg_match($pattern, $configContent, $matches)) {
            $$target = $matches[1];
        }
    }
}

$server = getenv('DB_HOST') ?: $server;
$user = getenv('DB_USER') ?: $user;
$password = getenv('DB_PASSWORD') !== false ? getenv('DB_PASSWORD') : $password;
$database_name = getenv('DB_NAME') ?: $database_name;

$connection = new mysqli($server, $user, $password);
if ($connection->connect_error) {
    fwrite(STDERR, "[ERROR] Gagal konek ke MySQL server: " . $connection->connect_error . "\n");
    exit(1);
}

$sqlPath = __DIR__ . '/../database/seminair_migration.sql';
if (!file_exists($sqlPath)) {
    fwrite(STDERR, "[ERROR] File migration tidak ditemukan: {$sqlPath}\n");
    exit(1);
}

$sql = file_get_contents($sqlPath);
if ($sql === false || trim($sql) === '') {
    fwrite(STDERR, "[ERROR] Isi file migration kosong atau gagal dibaca.\n");
    exit(1);
}

if (!$connection->multi_query($sql)) {
    fwrite(STDERR, "[ERROR] Gagal menjalankan migration: " . $connection->error . "\n");
    exit(1);
}

// Drain remaining results from multi_query.
do {
    if ($result = $connection->store_result()) {
        $result->free();
    }
} while ($connection->more_results() && $connection->next_result());

if ($connection->errno) {
    fwrite(STDERR, "[ERROR] Migration selesai dengan error: " . $connection->error . "\n");
    exit(1);
}

echo "[OK] Migration selesai. Database '{$database_name}' siap dipakai.\n";

$connection->close();
