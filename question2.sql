CREATE DATABASE course_report
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE course_report;

CREATE TABLE Users (
  user_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(80) NOT NULL,
  last_name  VARCHAR(80) NOT NULL,

  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (user_id),
  KEY idx_users_name (last_name, first_name)
);

CREATE TABLE Courses (
  course_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  description VARCHAR(255) NOT NULL,

  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (course_id),
  KEY idx_courses_desc (description)
);

CREATE TABLE Enrolments (
  enrolment_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id  BIGINT UNSIGNED NOT NULL,
  course_id BIGINT UNSIGNED NOT NULL,

  completion_status ENUM('not started','in progress','completed') NOT NULL DEFAULT 'not started',

  enrolled_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  completed_at  TIMESTAMP NULL DEFAULT NULL,

  PRIMARY KEY (enrolment_id),

  UNIQUE KEY uk_user_course (user_id, course_id),

  KEY idx_enrol_user_status (user_id, completion_status),
  KEY idx_enrol_course_status (course_id, completion_status),

  CONSTRAINT fk_enrol_user
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
    ON DELETE CASCADE ON UPDATE CASCADE,

  CONSTRAINT fk_enrol_course
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);