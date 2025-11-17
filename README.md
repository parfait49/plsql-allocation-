Employee Bonus Allocation — PL/SQL Demonstration-IZABAYO Parfait
This repository demonstrates the use of PL/SQL Collections, Records, and the GOTO statement through a small project that calculates employee bonuses by department.

Project Overview
The project simulates a company’s bonus allocation system.
It includes:

A database schema for departments, employees, and bonuses
PL/SQL record types for employee and bonus data
Collections (associative arrays and nested tables) to store and process data in memory
A GOTO statement to skip certain employees (e.g., those on leave)
A stored procedure that calculates and stores employee bonuses
A report procedure to print bonus details
Database Objects
Object Type	Name	Description
Table	departments	Holds department information
Table	employees	Holds employee details
Table	bonuses	Stores computed bonuses
Package	bonus_pkg	Contains procedures for calculation and reporting
Key PL/SQL Features Used
Concept	Description
Record	Combines employee fields into a single variable
Associative Array	Groups employee records by department
Nested Table	Collects bonus results for later insertion
GOTO Statement	Used to skip employees who are on leave
How to Run the Project
Option 1 — Run Online (Recommended)
Use Oracle Live SQL:

Log in or create a free Oracle account.
Copy and paste the scripts from the sql/ folder in order:
01_create_schema.sql
02_insert_sample_data.sql
03_package_bonus.sql
04_run_tests.sql
Execute each script.
View the results in the Output tab.
Clone and Explore
git clone https://github.com/ub-victor/plsql-allocation-collection.git
cd plsql-bonus-allocation
Credits
Assignment by Lecturer Eric Maniraguha
Developed by Ushindi Bihame Victoire
GitHub: ub-victor
