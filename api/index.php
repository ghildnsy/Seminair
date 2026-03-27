<?php

// Vercel entrypoint for native PHP app.
// It dispatches incoming requests to existing PHP files in project root.

$projectRoot = realpath(__DIR__ . '/..');
$requestPath = parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH) ?: '/';
$requestPath = rawurldecode($requestPath);

if ($requestPath === '/') {
    $requestPath = '/index.php';
}

$normalizedPath = str_replace('\\', '/', $requestPath);

// Security check: block traversal attempts.
if (strpos($normalizedPath, '..') !== false) {
    http_response_code(400);
    echo 'Bad request';
    exit;
}

$target = realpath($projectRoot . $normalizedPath);

if ($target === false || strpos($target, $projectRoot) !== 0 || !is_file($target)) {
    http_response_code(404);
    echo 'Not Found';
    exit;
}

$extension = strtolower(pathinfo($target, PATHINFO_EXTENSION));
if ($extension !== 'php') {
    http_response_code(404);
    echo 'Not Found';
    exit;
}

// Execute target file with its own directory as cwd so relative includes still work.
chdir(dirname($target));
require basename($target);
