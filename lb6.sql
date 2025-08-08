-- Zestaw 6

--1 
SELECT first_name, last_name
FROM emp
WHERE salary < 1300
ORDER BY last_name;
--wyswietlam pracowników których pensja jest niższa niż 1300, poźniej sortuje względem nazwisk, order by w domyśle jest ASC
--2
SELECT
    to_char(date_ordered)
FROM
    ord
UNION
SELECT
    to_char(total)
FROM
    ord;
--wyswietlam daty zamówień oraz ich wartości
--aby uzyskać wyniki w jednej kolumnie używam UNION
--funkcja to_char zapewnia jednolitość typu w obu poleceniach SELECT
--3
SELECT
    first_name,
    last_name
FROM emp
WHERE salary > (
        SELEC AVG(salary)
        FROM emp
        WHERE title = 'Warehouse Manager'
    ) AND title = 'Stock Clerk';
--wybieram pracowników którzy pracują na stanowisku Stock Clerk z pensją wyższą niz
--średnia pensja pracowników na stanowisku Warehouse Manager
--4
SELECT
    COUNT(salary)
FROM
    emp
WHERE
    salary < (
        SELECT
            AVG(salary)
        FROM
            emp
    );
--za pomocą COUNT określam liczbę pracowników których pensja jest mniejsza niż średnia pensja wszytkich pracowników
--5
SELECT first_name,
  last_name, start_date
FROM emp
WHERE ROUND(months_between
(to_date('01/03/2021', 'dd/mm/yyyy'), 
to_date(start_date, 'dd/mm/yyyy')), 0) > 360
order by start_date;
--wyswietlam imiona i nazwiska pracowników kiedy ilość miesięcy miedzy datą podaną w zadaniu a datą zatrudniena danego pracownika
-- jest większa niż 30lat--(360 miesięcy) następnie sortuje za pomocą order by;
--6
SELECT sales_rep_id, SUM(total) from ord group by sales_rep_id;
--wyswietlam numery przedstawicieli handlowych oraz sumę zamówień przez nich realizowanych, grupuje numerami
--7
SELECT sales_rep_id,
  SUM(total)
FROM ord
WHERE total IN
  (SELECT MAX(SUM(total)) FROM ord GROUP BY total
  )
GROUP BY total,
  sales_rep_id;
--wyswietlam nr id. przedstawiciela(lub przedstawicieli) handlowego gdzie 
--wartośc jego zamówienia jest równa maksymalnej wartości zamówienia z tabeli ord;
--wyświetlam również sume wartości jego zamówień
--8
SELECT o.sales_rep_id,
  SUM(o.total), e.last_name
FROM ord o, emp e
WHERE total IN
  (SELECT MAX(SUM(total)) FROM ord
  group by total
  ) AND e.id = o.sales_rep_id
GROUP BY
  sales_rep_id, last_name;
-- modyfikuje poprzednie zadanie dodając nazwisko do wyniku oraz drobne zmiany 
-- by dopasować dobrze składnie, używam złączenia równościowego aby zapobiec
 -- pojawieniu sie innych pracowników z tabeli emp którzy nie spełniają wymogów
-- zadania
--9
SELECT start_date,
  COUNT(start_date)
FROM emp
GROUP BY start_date
ORDER BY start_date;
-- wyswietlam daty zatrudnienia oraz ich ilość, następnie grupuje oraz sortuje --względem dat 
--10
SELECT p.name
FROM product p,
  inventory i
WHERE i.amount_in_stock         = 0
AND i.out_of_stock_explanation IS NOT NULL
AND p.id                        = i.product_id; 
-- wyswietlam nazwe produktu w którego ilość na stanie wynosi 0 oraz sprawdzam 
--czy ma komentarz za pomocą warunku IS NOT NULL 
--11
SELECT p.name
FROM product p,
  inventory i
WHERE p.id = i.product_id
group by p.name
having sum(i.amount_in_stock) < 500;
-- wyswietlam nazwe produktów gdzie suma ich ilości na stanie jest mniejsza niż 
-- 500; za pomocą funkcji agregującec SUM mogę sprawdzić nie dla jednego a wszystkich magazynów
--12
SELECT name
FROM product
WHERE LENGTH(short_desc) - LENGTH(REPLACE(short_desc, ' ', '')) + 1 = 3;
-- każdy opis mający wyłącznie 3 słowa posiada 2 spacje, za pomocą arytmetki na
-- długości napisu kalkuluje ilośc słow i ustawiam to jako warunek do -- wyswietlenia nazwy towaru
