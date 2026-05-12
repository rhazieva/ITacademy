## Listado de los países que están generando ventas.
SELECT company.country FROM transactions.company
JOIN transactions.transaction
ON company.id = transaction.company_id
GROUP BY company.country;

##Desde cuántos países se generan las ventas.
SELECT COUNT(DISTINCT company.country) as num_companies FROM transactions.company
JOIN transactions.transaction
ON company.id = transaction.company_id;

##Identifica a la compañía con la mayor media de ventas.

SELECT company.id, company.company_name, ROUND(AVG(transaction.amount), 2) as avg_sale 
FROM transactions.company
JOIN transactions.transaction
ON  company.id = transaction.company_id
GROUP BY company.id
ORDER BY avg_sale DESC
LIMIT 1;

## Muestra todas las transacciones realizadas por empresas de Alemania.
SELECT transaction.id FROM transactions.transaction
WHERE transaction.company_id IN (
	SELECT company.id FROM transactions.company
    WHERE company.country = "Germany"
);


##Lista las empresas que han realizado transacciones por un amount superior a la media de todas las transacciones.
SELECT company.id, company.company_name FROM transactions.company
WHERE company.id IN (
	SELECT transaction.company_id FROM transactions.transaction
	WHERE transaction.amount > (
		SELECT AVG(transaction.amount) FROM transactions.transaction
	)	
);
	
##Eliminarán del sistema las empresas que carecen de transacciones registradas, entrega el listado de estas empresas.
SELECT company.id, company.company_name FROM transactions.company
WHERE company.id NOT IN (
	SELECT transaction.company_id FROM transactions.transaction
    );
    


/*El departamento de Recursos Humanos ha identificado un error en el número de cuenta asociado a su tarjeta de crédito
 con ID CcU-2938. La información que debe mostrarse para este registro es: TR323456312213576817699999. 
 Recuerda mostrar que el cambio se realizó. */
 
 UPDATE transactions.credit_card SET
 credit_card.iban = "TR323456312213576817699999"
 WHERE credit_card.id = "CcU-2938";

SELECT * FROM transactions.credit_card 
WHERE credit_card.id = "CcU-2938";

##En la tabla "transaction" ingresa una nueva transacción con la siguiente información

INSERT INTO credit_card (id, iban, pan, pin, cvv, expiring_date) 
VALUES ('CcU-9999', '', '', '', '', '2030-12-31');

INSERT INTO company (id, company_name, phone, email, country, website) 
VALUES ('b-9999', '', '', '', '', '');

INSERT INTO user(id)
VALUES('9999');

INSERT INTO transactions.transaction (id, credit_card_id, company_id, user_id, lat, longitude, timestamp, amount, declined) 
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', '9999', '829.999', '-117.999', '2015-02-12 02:52:35', '111.11', '0');

SELECT * FROM transactions.transaction
WHERE transaction.id = '108B1D1D-5B23-A76C-55EF-C568E49A99DD';

##Desde recursos humanos te solicitan eliminar la columna "pan" de la tabla credit_card. Recuerda mostrar el cambio realizado.

ALTER TABLE credit_card DROP COLUMN pan;

SHOW COLUMNS FROM credit_card;

-- Realiza una subconsulta que muestre a todos los usuarios con más de 80 transacciones utilizando al menos 2 tablas.
SELECT users.id FROM new_transactions.users
JOIN (    
	SELECT transactions.user_id, COUNT(transactions.id) as num_trans FROM new_transactions.transactions
    WHERE transactions.declined = 0
	GROUP BY transactions.user_id
) as num_trans_users
ON users.id = num_trans_users.user_id
AND num_trans_users.num_trans >80
;

-- Muestra la media de amount por IBAN de las tarjetas de crédito en la compañía Donec Ltd., utiliza por lo menos 2 tablas.
SELECT credit_cards.iban, ROUND(AVG(transactions.amount),2) as avg_sales 
FROM new_transactions.credit_cards
JOIN new_transactions.transactions
ON credit_cards.id = transactions.card_id
WHERE transactions.business_id = (
	SELECT companies.id FROM new_transactions.companies
    WHERE company_name = 'Donec Ltd'
)
AND transactions.declined = 0
GROUP BY credit_cards.iban
;











 
 