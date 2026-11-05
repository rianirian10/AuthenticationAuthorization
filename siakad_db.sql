-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.0.30 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             12.1.0.6537
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for siakad_db
CREATE DATABASE IF NOT EXISTS `siakad_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `siakad_db`;

-- Dumping structure for table siakad_db.academic_years
CREATE TABLE IF NOT EXISTS `academic_years` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `year_name` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `year_name` (`year_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table siakad_db.academic_years: ~0 rows (approximately)

-- Dumping structure for table siakad_db.audit_logs
CREATE TABLE IF NOT EXISTS `audit_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint DEFAULT NULL,
  `activity` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `detail` text COLLATE utf8mb4_unicode_ci,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_audit_user` (`user_id`),
  KEY `idx_audit_created` (`created_at`),
  CONSTRAINT `fk_audit_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table siakad_db.audit_logs: ~0 rows (approximately)

-- Dumping structure for table siakad_db.classes
CREATE TABLE IF NOT EXISTS `classes` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `class_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `grade_level` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `class_name` (`class_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table siakad_db.classes: ~0 rows (approximately)

-- Dumping structure for table siakad_db.grades
CREATE TABLE IF NOT EXISTS `grades` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `student_id` bigint NOT NULL,
  `teacher_subject_id` bigint NOT NULL,
  `score` decimal(5,2) NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `student_id` (`student_id`,`teacher_subject_id`),
  KEY `fk_grade_teacher_subject` (`teacher_subject_id`),
  KEY `idx_grades_student` (`student_id`),
  CONSTRAINT `fk_grade_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`),
  CONSTRAINT `fk_grade_teacher_subject` FOREIGN KEY (`teacher_subject_id`) REFERENCES `teacher_subjects` (`id`),
  CONSTRAINT `chk_grade_score` CHECK (((`score` >= 0) and (`score` <= 100)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table siakad_db.grades: ~0 rows (approximately)

-- Dumping structure for table siakad_db.semesters
CREATE TABLE IF NOT EXISTS `semesters` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `academic_year_id` bigint NOT NULL,
  `semester_name` enum('Ganjil','Genap') COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `academic_year_id` (`academic_year_id`,`semester_name`),
  CONSTRAINT `fk_semester_year` FOREIGN KEY (`academic_year_id`) REFERENCES `academic_years` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table siakad_db.semesters: ~0 rows (approximately)

-- Dumping structure for table siakad_db.students
CREATE TABLE IF NOT EXISTS `students` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `class_id` bigint DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `gender` enum('L','P') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` text COLLATE utf8mb4_unicode_ci,
  `parent_name` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `parent_phone` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  KEY `idx_students_class` (`class_id`),
  CONSTRAINT `fk_student_class` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`),
  CONSTRAINT `fk_student_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table siakad_db.students: ~0 rows (approximately)

-- Dumping structure for table siakad_db.subjects
CREATE TABLE IF NOT EXISTS `subjects` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `subject_code` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `subject_code` (`subject_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table siakad_db.subjects: ~0 rows (approximately)

-- Dumping structure for table siakad_db.teachers
CREATE TABLE IF NOT EXISTS `teachers` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `teacher_number` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `fk_teacher_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table siakad_db.teachers: ~0 rows (approximately)

-- Dumping structure for table siakad_db.teacher_subjects
CREATE TABLE IF NOT EXISTS `teacher_subjects` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `teacher_id` bigint NOT NULL,
  `subject_id` bigint NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table siakad_db.teacher_subjects: ~0 rows (approximately)

-- Dumping structure for table siakad_db.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `usermane` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `full_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('Admin','Guru','Siswa') COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `usermane` (`usermane`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table siakad_db.users: ~0 rows (approximately)

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
