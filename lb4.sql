-- Zestaw 4

-- 1. Połączenie wewnętrzne tabel emp i dept, aby wyświetlić imię, nazwisko, identyfikator i nazwę departamentu dla każdego pracownika
SELECT
    e.first_name,
    e.last_name,
    d.id,
    d.name
FROM
    emp  e,
    dept d
WHERE
    e.dept_id = d.id;

-- 2. Połączenie wewnętrzne tabel dept i region, aby wyświetlić identyfikator departamentu, identyfikator regionu oraz nazwę regionu
SELECT
    d.id,
    d.region_id,
    r.name
FROM
    dept   d,
    region r
WHERE
    r.id = d.region_id;

-- 3. Znajdź pracownika o nazwisku 'Menchu' i wyświetl jego nazwisko, imię oraz identyfikator departamentu
SELECT
    e.last_name,
    e.first_name,
    d.id
FROM
    emp  e,
    dept d
WHERE
    e.last_name LIKE 'Menchu'
  AND e.dept_id    = d.id;

-- 4. Wyświetl wszystkich pracowników z niepustą prowizją, pokazując ich nazwisko, nazwę regionu i procent prowizji
SELECT
    e.last_name,
    r.name,
    e.commission_pct
FROM
    emp    e,
    dept   d,
    region r
WHERE
    e.commission_pct IS NOT NULL
  AND e.dept_id       = d.id
  AND d.region_id     = r.id
ORDER BY
    r.name;

-- 5. Pobierz nazwę klienta, nazwisko przedstawiciela handlowego, sformatowaną datę zamówienia, ilość i nazwę produktu dla zamówienia nr 101
SELECT
    c.name,
    e.last_name,
    TO_CHAR(o.date_ordered, 'yy/mm/dd') AS "DATA ZAMÓWIENIA",
    i.quantity,
    p.name
FROM
    customer c,
    emp      e,
    item     i,
    ord      o,
    product  p
WHERE
    o.id            = 101
  AND o.customer_id = c.id
  AND o.sales_rep_id= e.id
  AND i.ord_id      = o.id
  AND p.id          = i.product_id;

-- 6. Lewostronne złączenie tabel emp i customer, aby wyświetlić nazwisko i ID przedstawiciela handlowego dla każdego klienta, używając '–' gdy brak przypisanego przedstawiciela
SELECT
    NVL(e.last_name, '-')       AS nazwisko,
    NVL(TO_CHAR(e.id), '-')     AS "ID",
    c.name
FROM
    emp      e,
    customer c
WHERE
    e.id(+) = c.sales_rep_id;

-- 7. Lewostronne złączenie tabel customer i ord, aby wyświetlić wszystkich klientów z numerem zamówienia, '–' jeśli klient nie złożył żadnego zamówienia
SELECT
    c.id,
    c.name,
    NVL(TO_CHAR(o.id), '-') AS "Nr Zamówienia"
FROM
    customer c,
    ord      o
WHERE
    o.customer_id(+) = c.id
ORDER BY
    c.id;

-- 8. Złączenie tabeli emp z samą sobą, aby wyświetlić każdego pracownika i jego przełożonego w formie „Pracownik pracuje dla Przełożony”
SELECT
    e1.last_name || ' pracuje dla ' || e2.last_name
FROM
    emp e1,
    emp e2
WHERE
    e1.manager_id = e2.id;

-- 9. Zapytanie hierarchiczne od najwyższych menedżerów w dół, wyświetlające imię, nazwisko, tytuł, ID przełożonego i poziom w hierarchii
SELECT
    first_name,
    last_name,
    title,
    NVL(TO_CHAR(manager_id), ' ') AS manager_id,
    LEVEL
FROM
    emp
CONNECT BY
    PRIOR id = manager_id
START WITH
    manager_id IS NULL
ORDER BY
    LEVEL;

-- 10. Zapytanie hierarchiczne rozpoczynające się od stanowiska 'VP, Operations', pokazujące podwładnych według poziomów
SELECT
    first_name,
    last_name,
    title,
    NVL(TO_CHAR(manager_id), '1') AS manager_id,
    LEVEL
FROM
    emp
CONNECT BY
    PRIOR id = manager_id
START WITH
    title = 'VP, Operations'
ORDER BY
    LEVEL;
