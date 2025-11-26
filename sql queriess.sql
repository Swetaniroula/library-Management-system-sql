USE librarymanagement;
Drop Table if exists branch;
CREATE TABLE branch (
    branch_id VARCHAR(100) PRIMARY KEY,
    manager_id VARCHAR(100),
    branch_address VARCHAR(100),
    contact_no VARCHAR(100)
);

Drop table if exists employees;
CREATE TABLE employees (
    emp_id VARCHAR(10) PRIMARY KEY,
    emp_name VARCHAR(50),
    position VARCHAR(50),
    salary INT,
    branch_id VARCHAR(10)
);

Drop table if exists books;
CREATE TABLE books (
    isbn VARCHAR(25) PRIMARY KEY,
    book_title VARCHAR(100),
    category VARCHAR(50),
    rental_price FLOAT,
    status VARCHAR(20),
    author VARCHAR(30),
    publisher VARCHAR(50)
);

Drop table if exists members;
CREATE TABLE members (
    member_id VARCHAR(20) PRIMARY KEY,
    member_name VARCHAR(30),
    member_address VARCHAR(30),
    reg_date DATE
);

Drop table if exists issued_status;
CREATE TABLE issued_status (
    issues_id VARCHAR(20) PRIMARY KEY,
    issued_memeber_id VARCHAR(20),
    issued_book_name VARCHAR(75),
    issued_date DATE,
    issued_book_isbn VARCHAR(50),
    issued_emp_id VARCHAR(50)
);
SELECT 
    *
FROM
    issued_status;
Alter table issued_status change column issued_memeber_id issued_member_id varchar(20);

Drop table if exists return_status;
CREATE TABLE return_status (
    return_id VARCHAR(20) PRIMARY KEY,
    issued_id VARCHAR(30),
    return_book_name VARCHAR(75),
    return_date DATE,
    return_book_isbn VARCHAR(20)
);

-- Foreign key-- 
Alter table employees Add constraint fk_branch foreign key (branch_id) references branch(branch_id);
Alter table issued_status Add constraint fk_members foreign key (issued_member_id) references members(member_id);
Alter table issued_status Add constraint fk_books foreign key (issued_book_isbn) references books(isbn);
Alter table issued_status Add constraint fk_employees foreign key (issued_emp_id) references employees(emp_id);
Alter table return_status Add Constraint fk_issued_status Foreign key(issued_id) references issued_status(issues_id);

-- Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
insert into books (isbn,book_title,category,rental_price,status,author,publisher) values
('978-1-60123-455-2','To kill a Mockingbird','Classic',6.00,'yes','Harper Lee','J.B. Lippincott & Co.');
SELECT 
    *
FROM
    books;

-- Update an Existing Member's Address
UPDATE members 
SET 
    member_address = '125 oak st'
WHERE
    member_id = 'C103';

-- Delete a Record from the Issued Status Table 
DELETE FROM issued_status 
WHERE
    issues_id = 'IS121';

-- Retrieve All Books Issued by a Specific Employee 
SELECT 
    *
FROM
    issued_status
WHERE
    issued_emp_id = 'E101';

-- List Members Who Have Issued More Than One Book
SELECT 
    issued_emp_id, COUNT(*)
FROM
    issued_status
GROUP BY 1
HAVING COUNT(*) > 1;

-- Create Summary Tables: 
CREATE TABLE book_issued_cnt AS SELECT b.isbn, b.book_title, COUNT(ist.issued_id) AS issue_count FROM
    issued_status AS ist
        JOIN
    books AS b ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn , b.book_title;
SELECT 
    *
FROM
    book_issued_cnt;

-- Retrieve All Books in a Specific Category
SELECT 
    *
FROM
    books
WHERE
    category = 'children';

-- Find Total Rental Income by Category:
SELECT 
    b.category, SUM(b.rental_price), COUNT(*)
FROM
    issued_status AS ist
        JOIN
    books AS b ON b.isbn = ist.issued_book_isbn
GROUP BY 1;

-- List Members Who Registered in the Last 800 Days:
SELECT 
    *
FROM
    members
WHERE
    reg_date >= CURRENT_DATE - INTERVAL 800 DAY;

-- List Employees with Their Branch Manager's Name and their branch details:
SELECT 
    e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.*,
    e2.emp_name AS manager
FROM
    employees AS e1
        JOIN
    branch AS b ON e1.branch_id = b.branch_id
        JOIN
    employees AS e2 ON e2.emp_id = b.manager_id;

-- Create a Table of Books with Rental Price Above a Certain Threshold:
CREATE TABLE expensive_book AS SELECT * FROM
    books
WHERE
    rental_price > 7.00;
SELECT 
    *
FROM
    expensive_book;

-- Retrieve the List of Books Not Yet Returned
SELECT 
    *
FROM
    issued_status AS ist
        LEFT JOIN
    return_status AS rs ON rs.issued_id = ist.issues_id
WHERE
    rs.return_id IS NULL;
