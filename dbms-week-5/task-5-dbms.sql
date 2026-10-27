USE `E-Commerce`;

CREATE TABLE Payment (
    Payment_ID INT AUTO_INCREMENT PRIMARY KEY,
    Order_ID INT NOT NULL UNIQUE,
    Payment_Date DATE NOT NULL,
    Payment_Mode VARCHAR(30) NOT NULL,
    Payment_Status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    Transaction_Amount DECIMAL(10,2) NOT NULL,

    CONSTRAINT chk_payment_mode
        CHECK (Payment_Mode IN (
            'UPI', 'Credit Card', 'Debit Card',
            'Net Banking', 'Cash on Delivery'
        )),

    CONSTRAINT chk_payment_status
        CHECK (Payment_Status IN (
            'Pending', 'Success', 'Failed'
        )),

    CONSTRAINT chk_transaction_amount
        CHECK (Transaction_Amount >= 0),

    CONSTRAINT fk_payment_order
        FOREIGN KEY (Order_ID)
        REFERENCES Orders(Order_ID)
);

DESCRIBE Payment;
SHOW TABLES;

SELECT * FROM Orders;
SELECT * FROM Payment;

INSERT INTO Payment
(Order_ID, Payment_Date, Payment_Mode,
 Payment_Status, Transaction_Amount)
VALUES
(1, CURDATE(), 'UPI', 'Success', 1800.00),
(2, CURDATE(), 'Credit Card', 'Failed', 1100.00),
(3, CURDATE(), 'Debit Card', 'Pending', 1900.00),
(4, CURDATE(), 'Net Banking', 'Success', 1500.00),
(5, CURDATE(), 'Cash on Delivery', 'Pending', 800.00);

SELECT * FROM Payment
WHERE Payment_Status = 'Success';

SELECT * FROM Payment
WHERE Payment_Status = 'Failed';

SELECT * FROM Payment
WHERE Payment_Status = 'Pending';

UPDATE Payment
SET Payment_Status = 'Success',
    Payment_Date = CURDATE()
WHERE Order_ID = 2;

SELECT * FROM Payment
WHERE Order_ID = 1;

SELECT Payment_Status, COUNT(*) AS Total_Payments
FROM Payment
WHERE Payment_Status IN ('Success', 'Failed')
GROUP BY Payment_Status;

SELECT
    p.Payment_ID,
    o.Order_ID,
    c.Customer_ID,
    o.Order_Date,
    o.Order_Status,
    p.Payment_Date,
    p.Payment_Mode,
    p.Payment_Status,
    p.Transaction_Amount
FROM Payment p
JOIN Orders o ON p.Order_ID = o.Order_ID
JOIN Customer c ON o.Customer_ID = c.Customer_ID;

SELECT Payment_Mode, COUNT(*) AS Total_Transactions
FROM Payment
GROUP BY Payment_Mode;

SELECT Payment_Mode, COUNT(*) AS Total_Transactions
FROM Payment
GROUP BY Payment_Mode
ORDER BY Total_Transactions DESC
LIMIT 1;

SELECT SUM(Transaction_Amount) AS Successful_Revenue
FROM Payment
WHERE Payment_Status = 'Success';

-- 15. CALCULATE REVENUE BY PAYMENT MODE
SELECT Payment_Mode,
       SUM(Transaction_Amount) AS Total_Amount
FROM Payment
WHERE Payment_Status = 'Success'
GROUP BY Payment_Mode;

SELECT AVG(Transaction_Amount) AS Average_Transaction
FROM Payment;

SELECT
    c.Customer_ID,
    c.Customer_Name,
    p.Order_ID,
    p.Payment_Date,
    p.Payment_Mode,
    p.Payment_Status,
    p.Transaction_Amount
FROM Customer c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
JOIN Payment p ON o.Order_ID = p.Order_ID
ORDER BY c.Customer_ID;

SELECT Payment_Status, COUNT(*) AS Total
FROM Payment
GROUP BY Payment_Status;

SELECT
    o.Order_ID,
    o.Order_Status,
    p.Payment_Mode,
    p.Payment_Status,
    p.Transaction_Amount
FROM Orders o
JOIN Payment p ON o.Order_ID = p.Order_ID
WHERE p.Payment_Status IN ('Failed', 'Pending');

SELECT * FROM Payment;
UPDATE Payment
SET Payment_Status = 'Success'
WHERE Order_ID = 3;

