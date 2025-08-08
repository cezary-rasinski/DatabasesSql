# SQL & PL/SQL Lab Assignments

This repository contains a series of hands-on lab exercises for Oracle SQL and PL/SQL, all built on top of the **SUMMIT.sql** schema.  The `SUMMIT.sql` script creates and populates a realistic transactional database (customers, orders, products, inventory, employees, etc.) with sequences, triggers and referential constraints. Each lab (`lb3.sql` through `lb12.sql`) explores a different set of core database skills.

![Descriptive alt text](/schemat%20SUMMIT.jpg)

---

---

## Key Topics Covered

### Lab Set 3
- **Aggregate scalar functions**: `MAX`, `MIN`, `AVG`, `SUM`, `COUNT`
- **Grouping and filtering groups**: `GROUP BY` + `HAVING`
- **Set operators**: `UNION`, `UNION ALL`, `INTERSECT`, `MINUS`

### Lab Set 4
- **Inner joins**: joining `emp` ⇄ `dept` and `dept` ⇄ `region`
- **Outer joins**: `LEFT OUTER JOIN` with `NVL`/`COALESCE`
- **Self-joins**: manager → employee relationships via self-join
- **Hierarchical queries**: `CONNECT BY ... START WITH`

### Lab Set 5 
- **Uncorrelated subqueries**: `WHERE total = (SELECT MAX(...))`
- **Correlated subqueries**: row-dependent filters in the `WHERE` clause
- **`EXISTS` / `NOT EXISTS`** and **`IN` / `NOT IN`** for relational filtering

### Lab Set 6 
- **Simple filtering** and sorting
- **Type casting**: `TO_CHAR` on dates and numbers
- **Date functions**: `MONTHS_BETWEEN`, `ROUND` on date differences
- **Aggregations** with `HAVING`, `COUNT`, `SUM`

### Lab Set 9 
- **DDL generated** by Oracle SQL Developer Data Modeler
- Definition of tables, primary keys, foreign keys, sequences and triggers

### Lab Set 10 
- **Schema cleanup**: `DROP TABLE ... CASCADE CONSTRAINTS`
- **Metadata introspection**: `USER_TABLES`, `USER_TAB_COLUMNS`, `USER_CONSTRAINTS`
- **Foreign key creation** in three styles: column-level, table-level, `ALTER TABLE`
- **Loading sample data** and integrity validation (`INSERT`, `UPDATE`)

### Lab Set 11 
- **Anonymous PL/SQL blocks** with variable declarations (`NUMBER`, `VARCHAR2`, `DATE`)
- **Exception handling** (`NO_DATA_FOUND`, `TOO_MANY_ROWS`)
- **Explicit and implicit cursors**, `LOOP` and `FOR` constructs
- **Dynamic calculations** (days, weeks, months between dates)

### Lab Set 12 
- **PL/SQL package** `pracownicy` featuring:
  - CRUD procedures (`dodaj_emp`, `zmien_emp`, `kasuj_emp`)
  - Specialized procedures (`zmiana_salary`, `zmiana_dept`)
  - Aggregate function (`stat_emp`)
  - Procedure `top_n_emp` writing results to an auxiliary table



