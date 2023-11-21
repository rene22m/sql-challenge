-- Data Engineering
-- We first drop the tables, if they do not exist this lines will be skipped
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS dept_emp;
DROP TABLE IF EXISTS dept_manager;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS salaries;
DROP TABLE IF EXISTS titles;


CREATE TABLE "departments" (
    "dept_no" VARCHAR(10)   NOT NULL,
    "dept_name" VARCHAR(200)   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "titles" (
    "title_id" VARCHAR(50)   NOT NULL,
    "title" VARCHAR(50)   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

CREATE TABLE "employees" (
    "emp_no" int   NOT NULL,
    "emp_title" VARCHAR(200)   NOT NULL,
    "birth_date" VARCHAR(200)   NOT NULL,
    "first_name" VARCHAR(200)   NOT NULL,
    "last_name" VARCHAR(200)   NOT NULL,
    "sex" VARCHAR(1)   NOT NULL,
    "hire_date" VARCHAR(200)   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" int   NOT NULL,
    "dept_no" VARCHAR(10)   NOT NULL
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR(10)   NOT NULL,
    "emp_no" int   NOT NULL
);

CREATE TABLE "salaries" (
    "emp_no" int   NOT NULL,
    "salary" int   NOT NULL
);

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title" FOREIGN KEY("emp_title")
REFERENCES "titles" ("title_id");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

--- To confirm the imports of the tables and display the data we will use the following:
SELECT * FROM departments;
SELECT * FROM titles;
SELECT * FROM employees;
SELECT * FROM dept_emp;
SELECT * FROM dept_manager;
SELECT * FROM salaries;



-- Data Analysis
-- 1.- List the employee number, last name, first name, sex, and salary of each employee.

-- In order to display the salary we had to join the two tables "employees" and "salaries"
-- We can do this simply by joining in the "emp_no" column 
SELECT employees.emp_no, employees.last_name, employees.first_name, employees.sex, salaries.salary
FROM employees
JOIN salaries
ON employees.emp_no = salaries.emp_no;


-- 2.- List the first name, last name, and hire date for the employees who were hired in 1986 (2 points)
-- To  only display the data of employees that were hired in 1986 we used the WHERE

SELECT first_name, last_name, hire_date 
FROM employees
WHERE hire_date Like '%1986%'
ORDER BY hire_date;

-- 3.- List the manager of each department along with their department number, department name, employee number, last name, and first name (2 points)
-- To display this data we had to select from 3 different tables "departments", "dept_manager" and "employees"
-- We joined the tables on the columns "dept_no" and "emp_no"
SELECT departments.dept_no, departments.dept_name, dept_manager.emp_no, employees.last_name, employees.first_name
FROM departments
JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no
JOIN employees
ON dept_manager.emp_no = employees.emp_no;

-- 4.- List the department number for each employee along with that employee’s employee number, last name, first name, and department name (2 points)
-- To display this data we had to select from 3 different tables "departments", "employees" and "dept_emp"
-- We joined the tables on the columns "emp_no" and "dept_no"
SELECT dept_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name, departments.dept_no
FROM dept_emp
JOIN employees
ON dept_emp.emp_no = employees.emp_no
JOIN departments
ON dept_emp.dept_no = departments.dept_no;

-- 5.- List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B (2 points)
-- To  only display the data of employees which names are "Hercules" and last name starting with a "B" we used the WHERE
SELECT employees.first_name, employees.last_name, employees.sex
FROM employees
WHERE first_name = 'Hercules'
AND last_name Like 'B%';

--6.- List each employee in the Sales department, including their employee number, last name, and first name (2 points)
-- To display this data we had to select from 3 different tables "departments", "employees" and "dept_emp"
-- We joined the tables on the columns "emp_no" and "dept_no"
-- To display the data of only the "Sales" department we used the WHERE

SELECT departments.dept_name, employees.last_name, employees.first_name, employees.emp_no
FROM dept_emp
JOIN employees
ON dept_emp.emp_no = employees.emp_no
JOIN departments
ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_name = 'Sales';

-- 7.- List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name (4 points)
-- To display this data we had to select from 3 different tables "departments", "employees" and "dept_emp"
-- We joined the tables on the columns "emp_no" and "dept_no"
-- To display the data of only the "Sales" and the "Development" departments we used the WHERE
SELECT dept_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM dept_emp
JOIN employees
ON dept_emp.emp_no = employees.emp_no
JOIN departments
ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_name = 'Sales' 
OR departments.dept_name = 'Development';

-- 8.- List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name) (4 points)
SELECT last_name,
COUNT(last_name) AS "frequency"
FROM employees
GROUP BY last_name
ORDER BY
COUNT(last_name) DESC;