-- Zestaw 12

CREATE SEQUENCE id_up
start with 26
increment by 1;

CREATE TABLE topNemp AS
select first_name, last_name, salary from emp;

delete from topNemp;


--1 Utworzyć pakiet o nazwie pracownicy oraz zaimplementować podane niżej procedury i funkcje. 
create or replace PACKAGE pracownicy AS

--2 dodaj_emp – zadaniem procedury ma być dodawanie nowego pracownika do tabeli emp.Numer ID powinien być pobierany automatycznie ze zdefiniowanej w tym celu sekwencji. 

PROCEDURE dodaj_emp 
    (in_last_name emp.last_name%TYPE,
    in_first_name emp.first_name%TYPE,
    in_userid emp.userid%TYPE,
    in_start_date emp.start_date%TYPE,
    in_manager_id emp.manager_id%TYPE,
    in_title emp.title%TYPE,
    in_dept_id emp.dept_id%TYPE,
    in_salary emp.salary%TYPE,
    in_commission_pct emp.commission_pct%TYPE);
--3 zmień_emp – procedura modyfikująca dane wskazanego pracownika
PROCEDURE zmien_emp 
   (in_id emp.id%TYPE,
    in_last_name emp.last_name%TYPE,
    in_first_name emp.first_name%TYPE,
    in_userid emp.userid%TYPE,
    in_start_date emp.start_date%TYPE,
    in_manager_id emp.manager_id%TYPE,
    in_title emp.title%TYPE,
    in_dept_id emp.dept_id%TYPE,
    in_salary emp.salary%TYPE,
    in_commission_pct emp.commission_pct%TYPE);
--4 kasuj_emp – procedura kasująca dane wskazanego pracownika. 
PROCEDURE kasuj_emp 
   (in_id emp.id%TYPE);
--5 zmiana_salary – zadaniem tej procedury jest zmiana zarobków wskazanego pracownika. 
PROCEDURE zmiana_salary
    (in_id emp.id%TYPE,
    in_percent NUMBER);
--6 top_n_emp – wyświetla listę n pracowników, którzy zarabiają najwięcej (n podawane jako parametr wejściowy procedury). 
--Dane o tych pracownikach (imię, nazwisko, zarobki) powinny zostać dodatkowo zapisane do tabeli o nazwie top_n_emp. 
PROCEDURE top_n_emp
    (in_num NUMBER);
--7 zmiana_dept – procedura zmienia przypisanie pracownika do wydziału (tabela dept). 
PROCEDURE zmiana_dept
    (in_id emp.id%TYPE,
    in_dept_id emp.dept_id%TYPE);
--8 stat_emp – zadaniem funkcji jest zwrócenie jednej wartości (w zależności od podanego parametru): 
--zarobków maksymalnych, minimalnych, średnich albo sumy zarobków wszystkich pracowników.
FUNCTION stat_emp
    (in_parameter varchar2)
    return number;
END pracownicy;/



--implementacja BODY

create or replace PACKAGE BODY pracownicy AS

    null_last_name EXCEPTION;

--1
    PROCEDURE dodaj_emp (
        in_id             emp.id%TYPE,
        in_last_name      emp.last_name%TYPE,
        in_first_name     emp.first_name%TYPE,
        in_userid         emp.userid%TYPE,
        in_start_date     emp.start_date%TYPE,
        in_manager_id     emp.manager_id%TYPE,
        in_title          emp.title%TYPE,
        in_dept_id        emp.dept_id%TYPE,
        in_salary         emp.salary%TYPE,
        in_commission_pct emp.commission_pct%TYPE
    ) AS
    BEGIN
        IF in_last_name IS NULL THEN
            RAISE null_last_name;
        END IF;
        INSERT INTO emp (
            id,
            last_name,
            first_name,
            userid,
            start_date,
            manager_id,
            title,
            dept_id,
            salary,
            commission_pct
        ) VALUES (
            id_up.NEXTVAL,
            in_last_name,
            in_first_name,
            in_userid,
            in_start_date,
            in_manager_id,
            in_title,
            in_dept_id,
            in_salary,
            in_commission_pct
        );

    EXCEPTION
        WHEN null_last_name THEN
            dbms_output.put_line('Last name cannot be null.');
        WHEN value_error THEN
            dbms_output.put_line('Invalid data format');
    END dodaj_emp;

--2
    PROCEDURE zmien_emp (
        in_id             emp.id%TYPE,
        in_last_name      emp.last_name%TYPE,
        in_first_name     emp.first_name%TYPE,
        in_userid         emp.userid%TYPE,
        in_start_date     emp.start_date%TYPE,
        in_manager_id     emp.manager_id%TYPE,
        in_title          emp.title%TYPE,
        in_dept_id        emp.dept_id%TYPE,
        in_salary         emp.salary%TYPE,
        in_commission_pct emp.commission_pct%TYPE
    ) AS
    BEGIN
        IF in_last_name IS NULL THEN
            RAISE null_last_name;
        END IF;
        UPDATE emp
        SET
            first_name = in_first_name,
            userid = in_userid,
            start_date = in_start_date,
            manager_id = in_manager_id,
            title = in_title,
            dept_id = in_dept_id,
            salary = in_salary,
            commission_pct = in_commission_pct
        WHERE
            id = in_id;

    EXCEPTION
        WHEN null_last_name THEN
            dbms_output.put_line('Last name cannot be null.');
        WHEN value_error THEN
            dbms_output.put_line('Invalid data format');
    END zmien_emp;

--3
    PROCEDURE kasuj_emp (
        in_id emp.id%TYPE
    ) AS
    BEGIN
        DELETE FROM emp
        WHERE
            id = in_id;

    EXCEPTION
        WHEN value_error THEN
            dbms_output.put_line('Invalid data format');
    END kasuj_emp;

--4
    PROCEDURE zmiana_salary (
        in_id      emp.id%TYPE,
        in_percent NUMBER
    ) AS
    BEGIN
        UPDATE emp
        SET
            salary = salary * ( 1 + in_percent / 100 )
        WHERE
            id = in_id;

    EXCEPTION
        WHEN value_error THEN
            dbms_output.put_line('Invalid data format');
    END zmiana_salary;

--5
    PROCEDURE top_n_emp (
        in_num NUMBER
    ) AS

        uv_last_name  emp.last_name%TYPE;
        uv_first_name emp.first_name%TYPE;
        uv_salary     emp.salary%TYPE;

        CURSOR c_top_emp IS
        SELECT
            last_name,
            first_name,
            salary
        FROM
            emp

        WHERE ROWNUM <= 5
        ORDER BY salary DESC;

    BEGIN
        OPEN c_top_emp;
        LOOP
            FETCH c_top_emp INTO
                uv_last_name,
                uv_first_name,
                uv_salary;
            EXIT WHEN c_top_emp%notfound;

            dbms_output.put_line(uv_last_name
                                 || ' '
                                 || uv_first_name
                                 || ' '
                                 || uv_salary);

            INSERT INTO topNemp (
                last_name,
                first_name,
                salary
            ) VALUES (
                uv_last_name,
                uv_first_name,
                uv_salary
            );

        END LOOP;

        CLOSE c_top_emp;
    EXCEPTION
        WHEN value_error THEN
            dbms_output.put_line('Invalid data format');
    END top_n_emp;

--6
    PROCEDURE zmiana_dept (
        in_id      emp.id%TYPE,
        in_dept_id emp.dept_id%TYPE
    ) AS
    BEGIN
        UPDATE emp
        SET
            dept_id = in_dept_id
        WHERE
            id = in_id;

    EXCEPTION
        WHEN value_error THEN
            dbms_output.put_line('Invalid data format');
    END zmiana_dept;

--7
    FUNCTION stat_emp (
        in_parameter VARCHAR2
    ) RETURN NUMBER AS
        uv_value emp.salary%TYPE;
    BEGIN
        IF in_parameter = 'MAX' THEN
            SELECT
                MAX(salary)
            INTO uv_value
            FROM
                emp;

        ELSIF in_parameter = 'MIN' THEN
            SELECT
                MIN(salary)
            INTO uv_value
            FROM
                emp;

        ELSIF in_parameter = 'SUM' THEN
            SELECT
                SUM(salary)
            INTO uv_value
            FROM
                emp;

        ELSIF in_parameter = 'AVG' THEN
            SELECT
                AVG(salary)
            INTO uv_value
            FROM
                emp;

        ELSE
            dbms_output.put_line('wrong parameter');
            uv_value := NULL;
        END IF;

        RETURN uv_value;
    EXCEPTION
        WHEN no_data_found THEN
            dbms_output.put_line('No data found');
    END stat_emp;

END pracownicy;
