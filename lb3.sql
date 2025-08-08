-- Zestaw 3

-- 1. Oblicz ogólne statystyki płac: maksimum, minimum, średnia, suma oraz liczba wszystkich wynagrodzeń
SELECT
    MAX(salary),
    MIN(salary),
    AVG(salary),
    SUM(salary),
    COUNT(salary)
FROM
    emp;

-- 2. Znajdź alfabetycznie pierwsze i ostatnie nazwisko w tabeli emp
SELECT
    MIN(last_name),
    MAX(last_name)
FROM
    emp;

-- 3. Zlicz pracowników w dziale 31, którzy otrzymują prowizję większą niż zero
SELECT
    COUNT(commission_pct) AS "Liczba pracowników"
FROM
    emp
WHERE
    commission_pct > 0
  AND dept_id = 31;

-- 4. Pokaż liczbę klientów pogrupowaną według ratingu kredytowego
SELECT
    credit_rating,
    COUNT(credit_rating)
FROM
    customer
GROUP BY
    credit_rating;

-- 5. Suma wynagrodzeń według tytułu, z wyłączeniem ról zaczynających się od 'VP', posortowana według sumy
SELECT
    title,
    SUM(salary)
FROM
    emp
WHERE
    title NOT LIKE 'VP%'
GROUP BY
    title
ORDER BY
    SUM(salary);

-- 6. Maksymalne wynagrodzenie dla każdego tytułu
SELECT
    title,
    MAX(salary)
FROM
    emp
GROUP BY
    title;

-- 7. Pokaz działy, których średnie wynagrodzenie przekracza 1450
SELECT
    dept_id,
    AVG(salary)
FROM
    emp
GROUP BY
    dept_id
HAVING
    AVG(salary) > 1450;

-- 8. Nazwiska, które występują w tabeli emp więcej niż raz
SELECT
    last_name
FROM
    emp
GROUP BY
    last_name
HAVING
    COUNT(last_name) > 1;

-- 9. Unikalne pary ID i nazwy z tabel dept oraz region, posortowane według nazwy
SELECT
    region_id AS id,
    name
FROM
    dept
UNION
SELECT
    id,
    name
FROM
    region
ORDER BY
    name;

-- 10. Unikalne nazwy występujące w tabelach dept lub region, posortowane alfabetycznie
SELECT
    name
FROM
    dept
UNION
SELECT
    name
FROM
    region
ORDER BY
    name;

-- 11. Wszystkie nazwy z tabel dept i region, łącznie z duplikatami
SELECT
    name
FROM
    dept
UNION ALL
SELECT
    name
FROM
    region;

-- 12. Połącz identyfikatory działów z nazwiskami pracowników oraz identyfikatory regionów z nazwami regionów, posortowane według drugiej kolumny
SELECT
    dept_id AS id,
    last_name AS label
FROM
    emp
UNION
SELECT
    id,
    name AS label
FROM
    region
ORDER BY
    label;

-- 13. ID klientów, którzy złożyli przynajmniej jedno zamówienie (przecięcie customer i ord)
SELECT
    id
FROM
    customer
INTERSECT
SELECT
    customer_id
FROM
    ord;

-- 14. ID klientów, którzy nie złożyli żadnego zamówienia (klienci minus zamówienia)
SELECT
    id
FROM
    customer
MINUS
SELECT
    customer_id
FROM
    ord;
