Select * FROM bank_loan_data;

--#KPI’s:
--1. Total Loan Application
SELECT COUNT(id) AS Total_Loan_Application FROM bank_loan_data;

--2. MTD Loan Applications
SELECT COUNT(id) AS MTD_Total_Loan_Application 
FROM bank_loan_data
WHERE MONTH(issue_date) =12 AND YEAR(issue_date) = 2021;

--OR make it Dynamic

SELECT COUNT(id) AS MTD_Total_Loan_Application 
FROM bank_loan_data
WHERE MONTH(issue_date) =12 AND YEAR(issue_date) = (select MAX(YEAR(issue_date)) from bank_loan_data);

--3. PMTD (Preious Month to Date) Loan Applications
SELECT COUNT(id) AS PMTD_Total_Loan_Application 
FROM bank_loan_data
WHERE MONTH(issue_date) =11 AND YEAR(issue_date) = (select MAX(YEAR(issue_date)) from bank_loan_data);

--4. Total Funded Amount
SELECT SUM(loan_amount) as Total_Funded_Amount FROM bank_loan_data;

--5. MTD Total Funded Amount
SELECT SUM(loan_amount) as MTD_Total_Funded_Amount 
FROM bank_loan_data
WHERE  MONTH(issue_date) =12 AND YEAR(issue_date) = (select MAX(YEAR(issue_date)) from bank_loan_data);

--6. PMTD Total Funded Amount
SELECT SUM(loan_amount) as PMTD_Total_Funded_Amount 
FROM bank_loan_data
WHERE  MONTH(issue_date) =11 AND YEAR(issue_date) = (select MAX(YEAR(issue_date)) from bank_loan_data);

--7. Total Amount Received
SELECT SUM(total_payment) AS Total_Amount_Collected FROM bank_loan_data;

--6. MTD Total Amount Received
SELECT SUM(total_payment) AS MTD_Total_Amount_Collected 
FROM bank_loan_data
WHERE  MONTH(issue_date) =12 AND YEAR(issue_date) = (select MAX(YEAR(issue_date)) from bank_loan_data);

--7. PMTD Total Amount Received
SELECT SUM(total_payment) AS PMTD_Total_Amount_Collected 
FROM bank_loan_data
WHERE  MONTH(issue_date) =11 AND YEAR(issue_date) = (select MAX(YEAR(issue_date)) from bank_loan_data);

--8. Average Interest Rate
SELECT ROUND(AVG(int_rate)*100, 2) AS Avg_Int_Rate FROM bank_loan_data;

--9. MTD Average Interest
SELECT ROUND(AVG(int_rate)*100, 2) AS MTD_Avg_Int_Rate 
FROM bank_loan_data
WHERE  MONTH(issue_date) =12 AND YEAR(issue_date) = (select MAX(YEAR(issue_date)) from bank_loan_data);

--10. PMTD Average Interest
SELECT ROUND(AVG(int_rate)*100, 2) AS PMTD_Avg_Int_Rate 
FROM bank_loan_data
WHERE  MONTH(issue_date) =11 AND YEAR(issue_date) = (select MAX(YEAR(issue_date)) from bank_loan_data);

--11. Avg DTI
SELECT ROUND(AVG(dti)*100, 2) as Avg_DTI FROM bank_loan_data;

--12. MTD Avg DTI
SELECT ROUND(AVG(dti)*100, 2) as MTD_Avg_DTI 
FROM bank_loan_data
WHERE  MONTH(issue_date) =12 AND YEAR(issue_date) = (select MAX(YEAR(issue_date)) from bank_loan_data);

--13. PMTD Avg DTI
SELECT ROUND(AVG(dti)*100, 2) as PMTD_Avg_DTI 
FROM bank_loan_data
WHERE  MONTH(issue_date) =11 AND YEAR(issue_date) = (select MAX(YEAR(issue_date)) from bank_loan_data);


-- #GOOD LOAN ISSUED

--14. Good Loan Percentage
SELECT 
(COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END)) * 100
/
COUNT(id) AS Good_Loan_Percentage
FROM bank_loan_data;

--15. Good Loan Applications
SELECT COUNT(id) AS Good_Loan_Applications
FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

--16. Good Loan Funded Amount
SELECT SUM(loan_AMount) AS Good_Loan_Funded_Amount
FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

--17. Good Loan Amount Received
SELECT SUM(total_payment) AS Good_Loan_Amount_Received
FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';


--#BAD LOAN ISSUED

--18. Bad Loan Percentage

SELECT 
(COUNT(CASE WHEN loan_status = 'Charged off' THEN id END) *100.0)
/
COUNT(id)  As Bad_Loan_Percentage
FROM bank_loan_data;


-- 19. Bad Loan Applications
SELECT COUNT(id) AS Bad_Loan_Applications FROM bank_loan_data
WHERE loan_status = 'Charged Off'

--20. Bad Loan Funded Amount
SELECT SUM(loan_amount) AS Bad_Loan_Funded_amount FROM bank_loan_data
WHERE loan_status = 'Charged Off'

--21. Bad Loan Amount Received
SELECT SUM(total_payment) AS Bad_Loan_amount_received FROM bank_loan_data
WHERE loan_status = 'Charged Off'


-- #LOAN STATUS

SELECT loan_status,
COUNT(id) AS LoanCount,
SUM(total_payment) AS Total_Amount_Received,
SUM(loan_amount) AS Total_Funded_Amount,
AVG(int_rate * 100) AS Interest_Rate,
AVG(dti * 100) AS DTI
FROM 
	bank_loan_data
GROUP BY	
	loan_status;



SELECT loan_status,
SUM(total_payment) AS MTD_Total_Amount_Received,
SUM(loan_amount) AS MTD_Total_Funded_Amount
FROM 
	bank_loan_data

WHERE 
	MONTH(issue_date) =12 AND YEAR(issue_date) = (select MAX(YEAR(issue_date)) from bank_loan_data)
GROUP BY loan_status;


-- #B.	BANK LOAN REPORT | OVERVIEW

SELECT 
	MONTH(issue_date) AS Month_Munber, 
	DATENAME(MONTH, issue_date) AS Month_name, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY MONTH(issue_date), DATENAME(MONTH, issue_date)
ORDER BY MONTH(issue_date);


-- #STATE

SELECT 
	address_state AS State, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY address_state
ORDER BY address_state;


-- #TERM

SELECT 
	term AS Term, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY term
ORDER BY term;


--#EMPLOYEE LENGTH

SELECT 
	emp_length AS Employee_Length, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY emp_length
ORDER BY emp_length;

-- #PURPOSE

SELECT 
	purpose AS PURPOSE, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY purpose
ORDER BY purpose;



-- #HOME OWNERSHIP

SELECT 
	home_ownership AS Home_Ownership, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY home_ownership
ORDER BY home_ownership;


-- See the results when we hit the Grade A in the filters for dashboards.
SELECT 
	purpose AS PURPOSE, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
WHERE grade = 'A'
GROUP BY purpose
ORDER BY purpose;

