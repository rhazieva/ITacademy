
/*Identifica los cinco días que se generó la mayor cantidad de ingresos en la empresa por ventas. 
Muestra la fecha de cada transacción junto con el total de las ventas. */


SELECT  DATE(transactions.timestamp) AS transaction_date,
SUM(transactions.amount) AS total_sales
FROM new_transactions.transactions
WHERE transactions.declined = 0
GROUP BY  transaction_date
ORDER BY total_sales DESC
LIMIT 5;


/*Presenta el nombre, teléfono, país, fecha y amount, de aquellas empresas que realizaron transacciones con un valor compras 
entre 350 y 400 euros y en alguna de estas fechas: 29 de abril de 2015, 20 de julio de 2018 y 13 de marzo de 2024. 
Ordena los resultados de mayor a menor cantidad. */

SELECT companies.company_name, companies.phone, companies.country, DATE(transactions.timestamp) as sales_date, 
transactions.amount FROM new_transactions.companies
JOIN new_transactions.transactions
ON companies.id = transactions.business_id
WHERE transactions.id IN (
	SELECT transactions.id FROM new_transactions.transactions
	WHERE transactions.amount BETWEEN 350 AND 400
	AND DATE(transactions.timestamp) IN ('2015-04-29', '2018-07-20', '2024-03-13')
)
AND  transactions.declined = 0
ORDER BY transactions.amount DESC
;

/*Necesitamos optimizar la asignación de los recursos y dependerá de la capacidad operativa que se requiera,
por lo que te piden la información sobre la cantidad de transacciones que realizan las empresas, 
pero el departamento de recursos humanos es exigente y quiere un listado de las empresas en las que especifiques 
si tienen igual o más de 400 transacciones o menos. */


SELECT companies.id, companies.company_name, COUNT(transactions.id),
CASE
	WHEN COUNT(transactions.id) >= 400 THEN '400+'
    ELSE '399-'
END AS num_trans 
FROM new_transactions.companies
JOIN new_transactions.transactions
ON companies.id = transactions.business_id
GROUP BY companies.id, companies.company_name;


/*Elimina de la tabla transacción el registro con ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD de la base de datos.*/


DELETE FROM new_transactions.transactions 
WHERE transactions.id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

SELECT * FROM new_transactions.transactions
WHERE transactions.id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';


/*La sección de marketing desea tener acceso a información específica para realizar análisis y estrategias efectivas. 
Se ha solicitado crear una vista que proporcione detalles clave sobre las compañías y sus transacciones. 
Será necesaria que crees una vista llamada VistaMarketing que contenga la siguiente información:
 Nombre de la compañía. Teléfono de contacto. País de residencia. Media de compra realizado por cada compañía.
 Presenta la vista creada, ordenando los datos de mayor a menor promedio de compra.*/

SELECT * FROM VistaMarketing
ORDER BY avg_sale DESC;

/* Crea una nueva tabla que refleje el estado de las tarjetas de crédito basado en si las tres últimas transacciones
 han sido declinadas entonces es inactivo, si por lo menos una no es rechazada entonces es activo. Partiendo de esta tabla responde:
¿Cuántas tarjetas están activas? */

CREATE TABLE credit_cards_status AS
SELECT  ranked_transactions.card_id,
CASE 
	WHEN SUM(ranked_transactions.declined) >= 3 THEN 'Inactive'
	ELSE 'Active'
END AS card_status
 FROM (
	SELECT transactions.card_id, transactions.id, transactions.declined, RANK()
	OVER (PARTITION BY transactions.card_id ORDER BY DATE(transactions.timestamp) DESC)
	AS rank_transaction_date 
	FROM new_transactions.transactions
) AS ranked_transactions
WHERE rank_transaction_date <= 3
GROUP BY  card_id;	


SELECT COUNT(*) active_cards FROM new_transactions.credit_cards_status
WHERE credit_cards_status.card_status = 'Active';







