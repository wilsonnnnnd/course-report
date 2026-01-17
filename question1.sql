CREATE DATABASE test_mysql
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE test_mysql;

CREATE TABLE Users (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    Username VARCHAR(50) NOT NULL
);

CREATE TABLE UserFieldName (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    Field VARCHAR(50) NOT NULL
);

CREATE TABLE UserData (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    FieldID INT NOT NULL,
    Data VARCHAR(255),
    UserID INT NOT NULL,
    FOREIGN KEY (FieldID) REFERENCES UserFieldName(ID),
    FOREIGN KEY (UserID) REFERENCES Users(ID)
);

INSERT INTO Users (Username) VALUES
('User1'),
('User2'),
('User3');

INSERT INTO UserFieldName (Field) VALUES
('Phone'),
('Email'),
('Position');

INSERT INTO UserData (FieldID, Data, UserID) VALUES
(1, '1111111', 1),
(2, 'User1@gmail.com', 1),
(1, '2222222', 2),
(2, 'User2@gmail.com', 2),
(1, '3333333', 3),
(2, 'User3@gmail.com', 3),
(3, 'Tester', 3);

SELECT * FROM Users;
SELECT * FROM UserFieldName;
SELECT * FROM UserData;

SELECT
    u.Username,
    phone.Data  AS Phone,
    email.Data  AS Email,
    position.Data AS Position
FROM Users u
LEFT JOIN UserData phone
    ON u.ID = phone.UserID AND phone.FieldID = 1
LEFT JOIN UserData email
    ON u.ID = email.UserID AND email.FieldID = 2
LEFT JOIN UserData position
    ON u.ID = position.UserID AND position.FieldID = 3;