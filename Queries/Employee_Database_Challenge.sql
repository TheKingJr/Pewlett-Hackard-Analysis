-- PH-EmployeeDB Challenge

-- Creating the departments table
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

-- Creating the employees table
CREATE TABLE employees ( 
	 emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);

-- Creating the dept_manager table
-- Foreign key making connection to primary key in employees for emp_no
-- Foreign key making connection to primary key in departments for dept_no
-- Primary key for both emp_no & dept_no to remove duplicate errors 
CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

-- Creating the salaries table
-- Foreign key making connection to primary key in employees for emp_no
CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

-- Creating the salaries table
-- Foreign key making connection to primary key in employees for emp_no
-- Primary key for both emp_no & from_date to remove duplicate errors 
CREATE TABLE titles (
  emp_no INT NOT NULL,
  title VARCHAR NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no, from_date)
);

-- Creating the dept_emp table
-- Foreign key making connection to primary key in employees for emp_no
-- Foreign key making connection to primary key in departments for dept_no
-- Primary key for both emp_no & dept_no to remove duplicate errors 
CREATE TABLE dept_emp (
	dept_no VARCHAR NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

-- Find individuals with retirement eligibility 
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31'
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Individuals born in 1952 with retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

-- Individuals born in 1953 with retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

-- Individuals born in 1954 with retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

-- Individuals born in 1955 with retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

-- Counting the number of eligible individuals for retirement
SELECT COUNT(first_name)
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31'
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Creating another table to hold the number of eligible personnel
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--Checking tables
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
-- View the INNER JOIN command
SELECT d.dept_name,
       dm.emp_no,
       dm.from_date,
       dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

-- Joining retirement_info and dept_emp tables
-- View the INNER JOIN command
SELECT ri.emp_no,
       ri.first_name,
       ri.last_name,
       de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;

-- Joining retirement_info and dept_emp tables for current employees
-- View filter on data using WHERE
SELECT ri.emp_no,
       ri.first_name,
       ri.last_name,
       de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

--Checking tables
SELECT * FROM employees;

-- Employee count by department number
-- Using GROUP BY command to join employee count by department
-- Using ORDER BY command to order employee count by department
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- Creating table containing eligibile retirement employees information
-- View INTO command used for generating a new table containing desried info
-- View the INNER JOIN commands used to join three tables
-- View the WHERE & AND commands used to specify eligible individuals
SELECT e.emp_no, e.first_name, e.last_name, e.gender, s.salary, de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

-- Checking tables
-- * selects all the information present in table
SELECT * FROM manager_info;

-- Creating table containing list of managers per department
-- View INTO command used for generating a new table containing desried info
-- View the INNER JOIN commands used to join three tables
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);

--Checking tables
SELECT * FROM manager_info;

-- Creating table containing eligibile retirement employees still employed
-- View INTO command used for generating a new table containing desried info
-- View the INNER JOIN commands used to join three tables
-- View the WHERE command used to specify only the employees still at the company
SELECT ce.emp_no,
	   ce.first_name,
	   ce.last_name,
	   d.dept_name,
	   de.to_date
INTO dept_info
FROM current_emp as ce
	INNER JOIN dept_emp AS de
		ON (ce.emp_no = de.emp_no)
	INNER JOIN departments AS d
		ON (de.dept_no = d.dept_no)
WHERE (de.to_date = '9999-01-01');

-- Making errors, deleting table and then rechecking after making corrections
DROP TABLE retire_sales_dev;
SELECT * FROM retire_sales_dev;

-- Creating table containing eligibile retirement employees still employed
-- View INTO command used for generating a new table containing desried info
-- View the INNER JOIN commands used to join three tables
-- View the WHERE command used to specify only the employees still at the company
-- AND employees in the sales department
SELECT ce.emp_no,
	   ce.first_name,
	   ce.last_name,
	   d.dept_name
INTO retire_sales
FROM current_emp as ce
	INNER JOIN dept_emp AS de
		ON (ce.emp_no = de.emp_no)
	INNER JOIN departments AS d
		ON (de.dept_no = d.dept_no)
WHERE (de.to_date = '9999-01-01')
AND (d.dept_name = 'Sales');

-- Creating table containing eligibile retirement employees still employed
-- View INTO command used for generating a new table containing desried info
-- View the INNER JOIN commands used to join three tables
-- View the WHERE command used to specify only the employees still at the company
-- AND/OR employees in the sales and development departments
SELECT ce.emp_no,
	   ce.first_name,
	   ce.last_name,
	   d.dept_name
INTO retire_sales_dev
FROM current_emp as ce
	INNER JOIN dept_emp AS de
		ON (ce.emp_no = de.emp_no)
	INNER JOIN departments AS d
		ON (de.dept_no = d.dept_no)
WHERE (de.to_date = '9999-01-01')
	AND (d.dept_name = 'Sales')
OR (d.dept_name = 'Development');

-- Making errors, deleting table and then rechecking after making corrections
DROP TABLE unique_titles;
SELECT * FROM unique_titles;

-- Creating table containing eligibile retirement employees and their titles
-- View INTO command used for generating a new table containing desried info
-- View the INNER JOIN commands used to join two tables
-- View the WHERE command used to specify eligibile employees
-- VIew the ORDER BY command to order employees by emp_no
SELECT -- DISTINCT ON (emp_no)
	   e.emp_no,
	   e.first_name,
	   e.last_name,
	   t.title,
	   t.from_date,
	   t.to_date
INTO retirement_titles
FROM employees as e
	INNER JOIN titles AS t
		ON (e.emp_no = t.emp_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no ASC;

-- Creating table containing eligibile retirement employees still employed
-- View INTO command used for generating a new table containing desried info
-- View the WHERE command used to filter out former company employees
-- View the ORDER BY command to order employees by emp_no and last date
-- View the DISTINCT ON command to only get individuals most recently held position
SELECT DISTINCT ON (rt.emp_no) 
				    rt.emp_no,
					rt.first_name,
					rt.last_name,
					rt.title
INTO unique_titles
FROM retirement_titles as rt
WHERE (to_date = '9999-01-01')
ORDER BY emp_no ASC, to_date DESC;

-- Creating table containing titles held by eligibile retirement employees 
-- View INTO command used for generating a new table containing desried info
-- View the GROUP BY command used to groupl count by title
-- VIew the ORDER BY command to order title count by title
SELECT COUNT(ut.title), ut.title
INTO retiring_titles
FROM unique_titles as ut
GROUP BY ut.title
ORDER BY COUNT(ut.title) DESC;

--Checking tables
SELECT * FROM unique_titles;

-- Creating table containing employees eligibile for mentorship program
-- View INTO command used for generating a new table containing desried info
-- View the INNER JOIN commands used to join three tables
-- View the WHERE command used to specify employees still employed at company
-- AND employees born between the specified dates
-- VIew the ORDER BY command to order employees by emp_no
SELECT DISTINCT ON (e.emp_no) 
		e.emp_no,
        e.first_name,
        e.last_name,
        e.birth_date,
        de.from_date,
        de.to_date,
		t.title
INTO mentorship_eligibility
FROM employees AS e
    INNER JOIN dept_emp AS de
        ON (e.emp_no = de.emp_no)
    INNER JOIN titles AS t
        ON (e.emp_no = t.emp_no)
WHERE (de.to_date = '9999-01-01')		
	AND (birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no ASC;

-- Checking the available personnel to mentor people by position
SELECT COUNT(me.title), 
			me.title
FROM mentorship_eligibility as me
GROUP BY me.title
ORDER BY COUNT(me.title) DESC;

-- Checking the available personnel to mentor people
SELECT COUNT(mp.first_name)
FROM mentorship_eligibility as mp;

-- Checking the amount of retiring individuals
SELECT COUNT(ut.first_name)
FROM unique_titles as ut;
