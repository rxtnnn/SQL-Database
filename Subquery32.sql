USE orders;

-- 1 Who among the customers did not place any order?
SELECT custLastName "Last Name", custFirstName "First Name"
FROM customer c
WHERE c.custID not in
	(SELECT oh.custID FROM orderheader oh WHERE oh.orderID);

-- 2 What is the total amount of each order placed by "Nene Wang"?
SELECT od.orderID "Order ID", FORMAT(SUM(qtyOrdered * price),2) "Total Amount"
FROM orderdetail od
WHERE od.orderID IN
	(SELECT oh.orderID FROM orderheader oh WHERE oh.custID IN
		(SELECT c.custID FROM customer c WHERE c.custLastName ='Wang' AND c.custFirstName = 'Nene'))
GROUP BY od.orderID;
        
-- 3  Who among the customers ordered a product that belongs to category ‘C’? Sort the list according to last name in ascending order.
SELECT custLastName "Last Name", custFirstName "First Name"
FROM customer c
WHERE c.custID IN
	(SELECT oh.custID FROM orderheader oh WHERE oh.orderID IN
		(SELECT od.orderID FROM orderdetail od WHERE od.prodID IN
			(SELECT p.prodID FROM product p WHERE p.category = 'C')))
ORDER BY custLastName asc;

-- 4 What categories have a product in which the unit price is less than the minimum
-- price of any product in category ‘A’? Include the count of products. Sort the list according to the count of products in ascending order.
SELECT p.category 'Category', COUNT(p.category) 'Count of Products'
FROM product p
WHERE p.uPrice <
	(SELECT MIN(p.uPrice) FROM product p WHERE p.category = 'A')
GROUP BY p.category
ORDER BY COUNT(p.category) asc;


-- 5 How many pieces (total quantity) of “HP LaserJet 1102 Printer” has Nelly Co ordered?
SELECT SUM(od.qtyOrdered) "Total Qty Ordered"
FROM orderdetail od
WHERE od.prodID IN 
	(SELECT p.prodID FROM product p WHERE p.prodName = 'HP LaserJet 1102 Printer') AND od.orderID IN
    (SELECT oh.orderID FROM orderheader oh WHERE oh.custID IN
		(SELECT c.custID FROM customer c WHERE c.custLastName = 'Co' AND c.custFirstName = 'Nelly'));

-- 6 Customers who ordered more than once of any product in category ‘A’
SELECT CONCAT(c.custLastName, ', ', c.custFirstName) "Customer Name"
FROM customer c
WHERE c.custID IN
	(SELECT oh.custID FROM orderheader oh WHERE oh.orderID IN
		(SELECT od.orderID FROM orderdetail od WHERE od.prodID IN
			(SELECT p.prodID FROM product p WHERE p.category ='A'))
            GROUP BY oh.custID
            HAVING COUNT(oh.orderID) > 1);
            


-- practice
-- What products in category 'A' were ordered more than once? Sort the list according to product name in ascending order
SELECT p.prodName "Product Name"
FROM product p 
WHERE p.category = 'A' AND p.prodID in
	(SELECT od.prodID FROM orderdetail od GROUP BY od.prodID HAVING count(od.orderID) > 1)
ORDER BY p.prodName asc;

        
        
        
-- Orders whose total amount exceeds the total amount of order ID ‘302’
SELECT od.orderID "Order ID",  SUM(qtyOrdered * price) "Total Amount ordered"
FROM orderdetail od
GROUP BY od.orderID
HAVING SUM(qtyOrdered * price) >
	(SELECT SUM(qtyOrdered * price) FROM orderdetail od WHERE od.orderID ='302');



-- Products whose unit price is greater than the maximum price of product in category ‘C’.   
SELECT p.prodID "Product ID", p.prodName "Product Name", p.uPrice "Unit Price"
FROM product p
WHERE p.uPrice >
	(SELECT MAX(uPrice) FROM product p WHERE p.category ='C');
        
        
SELECT SUM(qtyOrdered) "Total Quantity Ordered"
FROM orderdetail od
WHERE od.prodID IN
	(SELECT p.prodID FROM product p WHERE p.prodName = "HP LaserJet 1102 Printer") AND od.orderID IN
    (SELECT oh.orderID FROM orderheader oh WHERE oh.custID in
		(SELECT c.custID FROM customer c WHERE c.custLastName ='Co' AND c.custFirstName = 'Nelly'))
GROUP BY od.prodID;
        

-- Show the total revenue generated from all orders placed in November 2018.
SELECT FORMAT(SUM(qtyOrdered * price),2) "total revenue"
FROM orderdetail od
WHERE od.orderID in
	(SELECT oh.orderID FROM orderheader oh WHERE oh.orderDate BETWEEN '2018-11-01' AND '2018-11-30');
        
        
-- Find the customers who ordered more than 50 units of any product.
SELECT c.custlastname "Customer"
FROM customer c
WHERE c.custID in	
	(SELECT oh.custID FROM orderheader oh WHERE oh.orderID IN
		(SELECT od.orderID FROM orderdetail od WHERE od.qtyOrdered > 50));
        

-- Display the names of customers who live in 'Cebu City' and have placed orders.
SELECT c.custlastname "Last Name", c.custfirstname "First Name"
FROM customer c
WHERE c.custAddress = 'Cebu City' 
AND EXISTS
	(SELECT oh.orderID FROM orderheader oh);

-- List the customer names and the total number of orders they placed.
SELECT c.custlastname "Last Name", c.custfirstname "First Name"
FROM customer c
WHERE c.custID in 
	(SELECT oh.custID FROM orderheader oh WHERE oh.orderID IN
    (SELECT COUNT(od.orderid) FROM orderdetail od GROUP BY od.orderID));


SELECT s.storeName "Name of Store"
FROM store s
WHERE s.storeID IN
	(SELECT sh.storeID FROM salesheader sh WHERE sh.orderID IN
		(SELECT sd.orderID FROM salesdetail sd WHERE sd.titleID IN
			(SELECT t.titleID FROM title t WHERE t.type = "Computer Science" AND t.pubID IN
				(SELECT p.pubID FROM publishr p WHERE p.pubName = "McGraw-Hill Education"))));



