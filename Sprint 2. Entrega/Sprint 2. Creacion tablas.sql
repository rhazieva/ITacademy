    -- Creamos la base de datos
    CREATE DATABASE IF NOT EXISTS transactions;
    USE transactions;

    -- Creamos la tabla company
    CREATE TABLE IF NOT EXISTS company (
        id VARCHAR(15) PRIMARY KEY,
        company_name VARCHAR(255),
        phone VARCHAR(15),
        email VARCHAR(100),
        country VARCHAR(100),
        website VARCHAR(255)
    );


    -- Creamos la tabla transaction
    CREATE TABLE IF NOT EXISTS transaction (
        id VARCHAR(255) PRIMARY KEY,
        credit_card_id VARCHAR(15),
        company_id VARCHAR(20), 
        user_id INT,
        lat FLOAT,
        longitude FLOAT,
        timestamp TIMESTAMP,
        amount DECIMAL(10, 2),
        declined BOOLEAN,
        FOREIGN KEY (company_id) REFERENCES company(id) 
    );
    
	CREATE TABLE IF NOT EXISTS credit_card (
    id VARCHAR(15) PRIMARY KEY,
    iban VARCHAR(34),
    pan VARCHAR(19),
    pin CHAR(4),
    cvv CHAR(3),
    expiring_date  VARCHAR(10)
	);

ALTER TABLE credit_card ADD COLUMN temp_date DATE;
UPDATE credit_card 
SET temp_date = STR_TO_DATE(expiring_date, '%m/%d/%y');
ALTER TABLE credit_card DROP COLUMN expiring_date;
ALTER TABLE credit_card RENAME COLUMN temp_date TO expiring_date;

ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_credit_card
FOREIGN KEY (credit_card_id) 
REFERENCES credit_card(id);

CREATE TABLE IF NOT EXISTS  user(
id INT PRIMARY KEY
);

ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_user
FOREIGN KEY (user_id) 
REFERENCES user(id);




   