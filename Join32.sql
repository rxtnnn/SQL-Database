use orders;

-- 1
SELECT CONCAT(c.custLastName, ', ', c.custFirstName) 'Customer Name', orderDate 'Date of Order' , deliveryDate 'Date of Delivery'
FROM customer c
JOIN orderheader oh on c.custID = oh.custID
WHERE (deliveryDate - orderDate) = 5;

-- 2 
SELECT od.orderID 'Order ID', FORMAT(SUM(qtyOrdered * price), 2) 'Total Amount'
FROM orderdetail od
JOIN orderheader oh ON od.orderID = oh.orderID
JOIN customer c ON oh.custID = c.custID
WHERE c.custLastName = 'Co' AND c.custFirstName = 'Nelly'
GROUP BY od.orderID
ORDER BY SUM(qtyOrdered * price) desc;

-- 3
SELECT CONCAT(c.custLastName, ', ', c.custFirstName) 'Customer Name', COUNT(oh.orderID) 'Count of Orders'
FROM customer c
LEFT JOIN orderheader oh ON c.custID = oh.custID
GROUP BY c.custID
ORDER BY COUNT(oh.orderID) desc, c.custFirstName asc;

-- 4
SELECT CONCAT(c.custLastName, ', ', c.custFirstName) 'Customer Name', MAX(oh.orderDate) 'Date of Last Order'
FROM customer c
JOIN orderheader oh ON c.custID = oh.custID
GROUP BY c.custID
ORDER BY CONCAT(c.custLastName, ', ', c.custFirstName) asc;

-- 5
SELECT CONCAT(c.custLastName, ', ', c.custFirstName) 'Customer Name', oh.orderID 'Order ID', FORMAT(SUM(qtyOrdered * price), 2) 'Total Amount'
FROM customer c
JOIN orderheader oh ON c.custID = oh.custID
JOIN orderdetail od ON oh.orderID = od.orderID
JOIN product p ON od.prodID = p.prodID
GROUP BY oh.orderID
HAVING COUNT(p.prodID) > 2 AND SUM(od.qtyOrdered * od.price)  > 100000;




