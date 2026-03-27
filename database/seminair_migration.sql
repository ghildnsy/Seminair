-- Seminair database migration (MySQL/MariaDB)
-- Generated for native PHP app in this repository.

CREATE DATABASE IF NOT EXISTS seminair
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE seminair;

SET NAMES utf8mb4;
SET time_zone = '+00:00';

DROP TABLE IF EXISTS daftar_peserta;
DROP TABLE IF EXISTS event;
DROP TABLE IF EXISTS kategori;
DROP TABLE IF EXISTS pengguna;
DROP TABLE IF EXISTS admin;

CREATE TABLE admin (
  id_admin INT UNSIGNED NOT NULL AUTO_INCREMENT,
  username VARCHAR(100) NOT NULL,
  password VARCHAR(255) NOT NULL,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id_admin),
  UNIQUE KEY uq_admin_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE pengguna (
  id_pengguna INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nama_pengguna VARCHAR(150) NOT NULL,
  email_pengguna VARCHAR(150) NOT NULL,
  instansi_pengguna VARCHAR(150) NOT NULL,
  password_pengguna VARCHAR(255) NOT NULL,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id_pengguna),
  UNIQUE KEY uq_pengguna_email (email_pengguna)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE kategori (
  id_kategori INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nama_kategori VARCHAR(100) NOT NULL,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id_kategori),
  UNIQUE KEY uq_kategori_nama (nama_kategori)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE event (
  id_event INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_kategori INT UNSIGNED NOT NULL,
  nama_event VARCHAR(200) NOT NULL,
  gambar_event VARCHAR(255) NOT NULL,
  tgl_event DATETIME NOT NULL,
  lokasi_event VARCHAR(255) NOT NULL,
  penyelenggara_event VARCHAR(255) NOT NULL,
  deskripsi_event TEXT NOT NULL,
  tipe_event ENUM('gratis', 'berbayar') NOT NULL,
  harga_event INT UNSIGNED NOT NULL DEFAULT 0,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id_event),
  KEY idx_event_kategori (id_kategori),
  CONSTRAINT fk_event_kategori
    FOREIGN KEY (id_kategori) REFERENCES kategori(id_kategori)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE daftar_peserta (
  id_peserta INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_event INT UNSIGNED NOT NULL,
  id_pengguna INT UNSIGNED NOT NULL,
  status ENUM('terbayar', 'belum_terbayar') NOT NULL DEFAULT 'belum_terbayar',
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id_peserta),
  UNIQUE KEY uq_peserta_event_pengguna (id_event, id_pengguna),
  KEY idx_peserta_pengguna (id_pengguna),
  CONSTRAINT fk_peserta_event
    FOREIGN KEY (id_event) REFERENCES event(id_event)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_peserta_pengguna
    FOREIGN KEY (id_pengguna) REFERENCES pengguna(id_pengguna)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Seed categories used by UI filters.
INSERT INTO kategori (id_kategori, nama_kategori) VALUES
  (1, 'education'),
  (2, 'healthy'),
  (3, 'best_events'),
  (4, 'beauty')
ON DUPLICATE KEY UPDATE nama_kategori = VALUES(nama_kategori);

-- Default admin account
-- username: admin
-- password: admin123
INSERT INTO admin (username, password)
VALUES ('admin', '$2y$10$lQIfzyGtgWhZpz8YhObjKu0oLOaT2xr7ClxMSBzwJTjq1fBW17QmK')
ON DUPLICATE KEY UPDATE password = VALUES(password);
