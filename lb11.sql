-- Zestaw 11

 --1 Utworzyć anonimowy blok PL/SQL, w którym zadeklarowane zostaną zmienne: 
--a. NUMBER 
--b. VARCHAR2 
--c. DATE 
-- Zainicjować zmienne dowolnymi wartościami, zaś jedną z nich określić jako CONSTANT. Wyświetlić w konsoli zadeklarowane zmienne (pakiet DBMS_OUTPUT, funkcja PUT_LINE).

DECLARE
    dziesiec CONSTANT NUMBER(2) := 10;
    imie VARCHAR2(20) := 'Adrian';
    data_domyslna DATE DEFAULT SYSDATE;
BEGIN
    DBMS_OUTPUT.PUT_LINE(dziesiec || ' ' || imie || ' ' || data_domyslna);
END;
/

--2 Stworzyć blok wyświetlający liczbę dni, tygodni i miesięcy, które minęły od określonej daty z przeszłości (np. własnych urodzin). Wyniki przedstawić w przejrzystej formie (niezbędne zaokrąglenia wartości, itp.) wraz z opisem.
DECLARE
    days NUMBER(5);
    weeks NUMBER(5);
    months NUMBER(5);
    my_date DATE := TO_DATE('01-01-2000', 'DD-MM-YYYY');
    current_date DATE := SYSDATE;
BEGIN
    days := ROUND(current_date - my_date, 0);
    weeks := ROUND(days / 7, 0);
    months := ROUND(MONTHS_BETWEEN(current_date, my_date), 0);
    DBMS_OUTPUT.PUT_LINE(days || ' :ilość dni ' || weeks || ' :ilość tygodni ' || months || ' :ilość miesięcy');
END;
/

--4 Napisać anonimowy blok PL/SQL, wyświetlający dane osobowe z tabeli emp tych pracowników, którzy zarabiają najmniej i najwięcej (wykorzystać niejawny kursor, obsłużyć sytuacje, w których jest kliku pracowników zarabiających najmniej lub najwięcej) 

DECLARE
    imie VARCHAR2(25);
    nazwisko VARCHAR2(25);
BEGIN
    SELECT first_name, last_name 
      INTO imie, nazwisko
    FROM emp
    WHERE salary = (SELECT MIN(salary) FROM emp);
    DBMS_OUTPUT.PUT_LINE('dane osoby zarabiającej najmniej: ' || imie || ' ' || nazwisko);

    SELECT first_name, last_name 
      INTO imie, nazwisko
    FROM emp
    WHERE salary = (SELECT MAX(salary) FROM emp);
    DBMS_OUTPUT.PUT_LINE('dane osoby zarabiającej najwięcej: ' || imie || ' ' || nazwisko);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('brak takich osób');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('zbyt wiele osób');
END;
/

--5 Wyświetlić w bloku PL/SQL dane wszystkich pracowników. Zadanie wykonać przy użyciu: 

--a) kursora jawnego z wykorzystaniem pętli LOOP; 
--b) kursora niejawnego, pętla FOR. 

-- 5a
DECLARE
    uv_nazwisko VARCHAR2(25);
    uv_imie VARCHAR2(25);

    CURSOR c_emp IS
        SELECT first_name, last_name
        FROM emp
        ORDER BY last_name;
BEGIN
    OPEN c_emp;
    LOOP
        FETCH c_emp INTO uv_imie, uv_nazwisko;
        EXIT WHEN c_emp%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(c_emp%ROWCOUNT || '. ' || uv_imie || ' ' || uv_nazwisko);
    END LOOP;
    CLOSE c_emp;
END;
/

-- 5b
DECLARE
    nazwisko VARCHAR2(25);
    imie VARCHAR2(25);
    i NUMBER(2);
    max_i NUMBER(2);
    licz NUMBER(2);
BEGIN
    SELECT MAX(id)
      INTO max_i
    FROM emp;
    FOR i IN 1..max_i LOOP
        SELECT first_name, last_name, id
          INTO imie, nazwisko, licz
        FROM emp
        WHERE id = i;
        DBMS_OUTPUT.PUT_LINE(licz || ': ' || imie || ' ' || nazwisko);
    END LOOP;
END;
/

--6 Napisać blok ze zdefiniowanym kursorem z parametrami. Wyświetlić zamówienia z tabeli ord, które zostały 

--złożone w jakimś okresie (parametry date_ord_from, date_ord_to). Dodatkowo wyświetlić dane klienta 

--składającego dane zamówienie oraz dane pracownika opiekującego się tym zamówieniem.
DECLARE
    CURSOR c_ord (first_d DATE, second_d DATE) IS
        SELECT c.name, o.id, e.last_name, e.first_name
        FROM ord o
        JOIN customer c ON o.customer_id = c.id
        JOIN emp e ON o.sales_rep_id = e.id
        WHERE o.date_ordered BETWEEN first_d AND second_d
        ORDER BY o.id;
    uv_ord c_ord%ROWTYPE;
BEGIN
    OPEN c_ord(TO_DATE('28-08-1992', 'DD-MM-YYYY'), TO_DATE('31-08-1992', 'DD-MM-YYYY'));
    LOOP
        FETCH c_ord INTO uv_ord;
        EXIT WHEN c_ord%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(c_ord%ROWCOUNT || '. ' ||
            'order_id: '    || uv_ord.id || ' ' ||
            'customer: '    || uv_ord.name || ' ' ||
            'emp_first: '   || uv_ord.first_name || ' ' ||
            'emp_last: '    || uv_ord.last_name);
    END LOOP;
    CLOSE c_ord;
END;
/

--7 Napisać blok PL/SQL, który zmodyfikuje zarobki pracowników: 

--a) dla zarabiających poniżej ½ średniej wszystkich zarobków, wprowadzi podwyżkę o 20%; 
--b) dla zarabiających pomiędzy ½ a ⅚ średniej, wprowadzi podwyżkę o 10%; 
--c) dla pozostałych pracowników wprowadzi podwyżkę o 5%. 
CREATE TABLE new_emp AS SELECT * FROM emp;

DECLARE
    half NUMBER(4);
    upper_limit NUMBER(4);
BEGIN
    SELECT AVG(salary) / 2
      INTO half
    FROM new_emp;

    upper_limit := half * (5/3);

    UPDATE new_emp
    SET salary = salary * 1.2
    WHERE salary < half;

    UPDATE new_emp
    SET salary = salary * 1.1
    WHERE salary >= half
      AND salary <= upper_limit;

    UPDATE new_emp
    SET salary = salary * 1.05
    WHERE salary > upper_limit;
END;
/
