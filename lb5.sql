-- Zestaw 5

-- 1. Znajdź zamówienie o najwyższej wartości całkowitej
SELECT id, total
FROM ord
WHERE total = (
  SELECT MAX(total) FROM ord
);

-- 2. Pobierz zamówienie o najwyższej wartości spośród płatności gotówkowych, wyświetlając sformatowane daty zamówienia i realizacji
SELECT
  id,
  TO_CHAR(date_ordered, 'yy/mm/dd')   AS "DATA ZAMÓWIENIA",
  TO_CHAR(date_shipped, 'yy/mm/dd')   AS "DATA REALIZACJI",
  total
FROM ord
WHERE total = (
  SELECT MAX(total) FROM ord
  WHERE payment_type = 'CASH'
);

-- 3. Wyświetl wszystkie zamówienia, których wartość całkowita przekracza średnią wartość zamówienia
SELECT
  id,
  date_ordered,
  date_shipped,
  total
FROM ord
WHERE total > (
  SELECT AVG(total) FROM ord
);

-- 4. Pokaż produkty wycenione poniżej średniej ceny hurtowej produktów "Prostar%"
SELECT
  name,
  suggested_whlsl_price
FROM product
WHERE suggested_whlsl_price < (
  SELECT AVG(suggested_whlsl_price)
  FROM product
  WHERE name LIKE 'Prostar%'
);

-- 5. Dla każdego magazynu pobierz produkt(y) o maksymalnym stanie magazynowym, używając podzapytania IN z grupowaniem
SELECT
  warehouse_id,
  product_id,
  amount_in_stock
FROM inventory
WHERE (warehouse_id, amount_in_stock) IN (
  SELECT
    warehouse_id,
    MAX(amount_in_stock)
  FROM inventory
  GROUP BY warehouse_id
);

-- 6. To samo co w zadaniu 5, ale przy użyciu skorelowanego podzapytania, aby znaleźć maksymalny stan magazynowy dla każdego magazynu
SELECT
  warehouse_id,
  product_id,
  amount_in_stock
FROM inventory i
WHERE amount_in_stock = (
  SELECT MAX(amount_in_stock)
  FROM inventory
  WHERE warehouse_id = i.warehouse_id
);

-- 7. Pokaż miasto każdego magazynu, nazwę produktu oraz maksymalny stan magazynowy w danym magazynie
SELECT
  w.city,
  p.name,
  i.amount_in_stock
FROM inventory i
JOIN warehouse w ON w.id = i.warehouse_id
JOIN product   p ON p.id = i.product_id
WHERE i.amount_in_stock = (
  SELECT MAX(amount_in_stock)
  FROM inventory
  WHERE warehouse_id = i.warehouse_id
);

-- 8. Wyświetl klientów, którzy nigdy nie złożyli zamówienia, używając NOT EXISTS
SELECT name
FROM customer c
WHERE NOT EXISTS (
  SELECT 1
  FROM ord o
  WHERE o.customer_id = c.id
);

-- 9. Wyświetl każdego klienta i numery jego zamówień, ale tylko dla klientów, którzy mają co najmniej jedno zamówienie
SELECT
  c.id,
  c.name,
  o.id AS "Numer Zamowienia"
FROM customer c
JOIN ord o ON o.customer_id = c.id
WHERE EXISTS (
  SELECT 1
  FROM ord o2
  WHERE o2.customer_id = c.id
)
ORDER BY c.id;

-- 10. Wyświetl identyfikatory klientów i numery zamówień dla wszystkich zamówień (używając EXISTS, które zawsze zwraca prawdę)
SELECT
  o.customer_id,
  o.id AS "Numer Zamowienia"
FROM ord o
WHERE EXISTS (
  SELECT 1
  FROM ord o2
)
ORDER BY o.customer_id;

-- 11. Znajdź nazwiska pracowników, którzy pełnili rolę przedstawicieli handlowych w zamówieniach o numerze < 100, używając podzapytania IN na krotkach
SELECT last_name
FROM emp
WHERE last_name IN (
  SELECT e.last_name
  FROM emp e
  JOIN ord o ON e.id = o.sales_rep_id
  WHERE o.id < 100
);

-- 12. To samo co w zadaniu 11, ale z użyciem DISTINCT w celu usunięcia duplikatów
SELECT DISTINCT e.last_name
FROM emp e
JOIN ord o ON o.sales_rep_id = e.id
WHERE o.id < 100;

-- 13. Wybierz pracowników (imię i nazwisko), którzy obsłużyli co najmniej cztery zamówienia, używając klauzuli HAVING na grupowaniu
SELECT
  first_name,
  last_name
FROM emp
WHERE (first_name, last_name) IN (
  SELECT
    e.first_name,
    e.last_name
  FROM emp e
  JOIN ord o ON e.id = o.sales_rep_id
  GROUP BY
    e.first_name,
    e.last_name
  HAVING COUNT(o.sales_rep_id) >= 4
);
