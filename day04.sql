--DELETING TABLE
DROP TABLE IF EXISTS users;

--CREATING TABLE
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    NAME VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    age INTEGER CHECK (age >=18),
    reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

--INSERTING DATA INTO TABLE
INSERT INTO users (user_id, name, email, age)
VALUES(1,'John doe', 'john.doe@example.com',25);

INSERT INTO users (user_id, name, email, age)
VALUES(3,'Ria', 'ria@example.com',20);

INSERT INTO users (user_id, name, email, age)
VALUES(4,'Nia', 'Nia@example.com',19);

INSERT INTO users (user_id, name, email, age)
VALUES(5,'Ajit', 'ajit@example.com',20);

SELECT * FROM users;
