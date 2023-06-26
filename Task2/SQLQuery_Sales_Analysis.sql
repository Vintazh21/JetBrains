SELECT 
			OI.license_type
			,O.currency
			,PR.product_family
			,CU.type_id
			,CU.name
			,YEAR(O.exec_date) as Year
			,MONTH(O.exec_date) as Month
			,CO.region AS Region
			,CO.name AS Country
			,SUM(OI.quantity) AS Qty
			,SUM(OI.amount_total) AS AmntTotal
			,SUM(OI.amount_total / ER.rate) AS AmntTotal_USD
FROM		dea.sales.Orders 	O
LEFT JOIN	dea.sales.OrderItems	OI			ON OI.order_id = O.id
LEFT JOIN	dea.sales.Product		PR			ON OI.product_id = PR.product_id
LEFT JOIN	dea.sales.ExchangeRate	ER			ON O.exec_date = ER.date AND O.currency = ER.currency
LEFT JOIN	dea.sales.Customer		CU			ON O.customer = CU.id
LEFT JOIN	dea.sales.Country		CO			ON CU.country_id = CO.id
WHERE		O.is_paid = 1						-- Only paid orders, exclude pre-orders
AND			YEAR(O.exec_date) IN (2018, 2019)	-- Year 2018, 2019
AND			MONTH(O.exec_date) BETWEEN 1 AND 6	-- H1
GROUP BY	PR.product_family, OI.[license_type], O.currency, CU.type_id, CU.name, YEAR(O.exec_date), MONTH(O.exec_date), CO.region, CO.name