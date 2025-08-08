--ZESTAW 10 

--1 Usunąć wszystkie tabele znajdujące się na koncie serwera Oracle (napisać własny skrypt) 
--mialem troche wiecej tabel niz z samego SUMMIT
select table_name from user_tables;
select table_name from user_tables;
drop table region_kopia cascade constraints;
drop table customer cascade constraints;
drop table dept cascade constraints;
drop table emp cascade constraints;
drop table image cascade constraints;
drop table inventory cascade constraints;
drop table item cascade constraints;
drop table longtext cascade constraints;
drop table ord cascade constraints;
drop table product cascade constraints;
drop table title cascade constraints;
drop table warehouse cascade constraints;
drop table departamenty cascade constraints;
drop table region cascade constraints;
drop table klienci cascade constraints;
drop table zamówienia cascade constraints;
drop table pracownicy cascade constraints;
drop table stanowiska cascade constraints;
drop table statusy cascade constraints;
drop table books cascade constraints;
drop table patrons cascade constraints;
drop table transactions cascade constraints;
-- sprawdzam
select table_name from user_tables;
--2 Utworzyć tabele za pomocą skryptu wygenerowanego w rozwiązaniu zestawu 9 
--uruchamiam skrypt z zestawu 9

--3 Wylistować nazwy wszystkich tabel 
select table_name from user_tables;

--4 Pokazać, jakie kolumny znajdują się w poszczególnych tabelach, a także ich parametry (typ danych, długość, precyzję oraz czy są dopuszczalne wartości NULL
SELECT
    column_name,
    data_length,
    data_precision,
    nullable
FROM
    user_tab_columns;

--5 Wyświetlić, jakie ograniczenia są narzucone na poszczególne kolumny każdej tabeli w projekcie (z użyciem odpowiedniego polecenia SQL) 
SELECT
    constraint_name
FROM
    user_constraints
WHERE
    table_name = 'BOOKS';

SELECT
    constraint_name
FROM
    user_constraints
WHERE
    table_name = 'PATRONS';

SELECT
    constraint_name
FROM
    user_constraints
WHERE
    table_name = 'TRANSACTIONS';

--6 Dodać kolejną tabelę do projektu i wprowadzić w niej klucz obcy do kolumny jednej z istniejących tabel. Zademonstrować 3 sposoby takiego ograniczenia (kolumnowe, tablicowe oraz metodę ALTER TABLE) 
--tablicowe
CREATE TABLE REVIEW (
    review_id INT PRIMARY KEY,
    patrons_id int,
    review_text VARCHAR(500),
    rating INT,
    CONSTRAINT fk_patrons_id
      FOREIGN KEY (patrons_id) 
      REFERENCES Patrons (patrons_id)
);
--kolumnowe
CREATE TABLE REVIEW (
    review_id INT PRIMARY KEY,
    patrons_id int constraint patrons_id_fk
    references patrons (patrons_id),
    review_text VARCHAR(500),
    rating INT
);
--za pomocą ALTER TABLE
ALTER TABLE REVIEW
ADD CONSTRAINT pk_patrons_ID
FOREIGN KEY (patrons_id)
REFERENCES PATRONS (patrons_id);

--Wprowadzenie i modyfikacja danych 

--8 We wszystkich tabelach wprowadzić przykładowe dane. Utworzyć odpowiedni skrypt ładujący “sensowne” dane, tzn. Przykładowe imiona, nazwiska, nazwy, daty, itp. (a nie tylko dowolne zestawienie liter bądź znaków). Zwrócić uwagę na ograniczenia integralnościowe.  
INSERT INTO books (book_id, title, author_last_name, rating, author_first_name)
VALUES ('B001', 'The Great Gatsby', 'Fitzgerald', 5, 'F. Scott');
INSERT INTO books (book_id, title, author_last_name, rating, author_first_name)
VALUES ('B002', '1984', 'Orwell', 4, 'George');

INSERT INTO patrons (person_id, first_name, last_name, street_address, city, state, zip)
VALUES (1, 'John', 'Doe', '123 Main St', 'Anytown', 'NY', '12345');
INSERT INTO patrons (person_id, first_name, last_name, street_address, city, state, zip)
VALUES (2, 'Jane', 'Smith', '456 Elm St', 'Otherville', 'CA', '98765');

INSERT INTO transactions (transaction_id, transaction_date, transaction_type, books_books_id, patrons_patrons_id)
VALUES (1, TO_DATE('2024-05-01', 'YYYY-MM-DD'), 1, 1, 1);
INSERT INTO transactions (transaction_id, transaction_date, transaction_type, books_books_id, patrons_patrons_id)
VALUES (2, TO_DATE('2024-05-02', 'YYYY-MM-DD'), 2, 2, 2);

INSERT INTO REVIEW (review_id, patrons_id, review_text, rating)
VALUES (1, 1, 'Great book, highly recommended!', 5);
INSERT INTO REVIEW (review_id, patrons_id, review_text, rating)
VALUES (2, 2, 'Enjoyed reading it.', 4);


--9 Wyświetlić zawartość wybranej tabeli 
select * from patrons

--10 Dokonać próby zmiany wybranych danych według opracowanego przez siebie schematu (np. Filtrując odpowiednio dane do zmiany). Sprawdzić, czy nie są naruszane ograniczenia integralnościowe 
update patrons
SET
first_name = 'Jonny',
last_name = 'Deep'
where patrons_id = 1;

--sprawdzam mozliwosc naruszenia ograniczenia integralnosciowego
update patrons
SET
patrons_id = 10; (nie da sie wykonac takiego działania)


--11 Ponownie wyświetlić zawartość tabeli.  
select * from patrons;

--12 Wykorzystując skrypt SUMMIT.SQL utworzyć jedną ze zdefiniowanych w nim tabel oraz wypełnić ją odpowiednią treścią (wybrać właściwe polecenia ze skryptu). 
CREATE TABLE ord 
(id                         NUMBER(7) 
   CONSTRAINT ord_id_nn NOT NULL,
 customer_id                NUMBER(7) 
   CONSTRAINT ord_customer_id_nn NOT NULL,
 date_ordered               DATE,
 date_shipped               DATE,
 sales_rep_id               NUMBER(7),
 total                      NUMBER(11, 2),
 payment_type               VARCHAR2(6),
 order_filled               VARCHAR2(1),
     CONSTRAINT ord_id_pk PRIMARY KEY (id),
     CONSTRAINT ord_payment_type_ck
        CHECK (payment_type in ('CASH', 'CREDIT')),
     CONSTRAINT ord_order_filled_ck
        CHECK (order_filled in ('Y', 'N')));

INSERT INTO ord VALUES (
   100, 204, '31-AUG-1992', '10-SEP-1992',
   11, 601100, 'CREDIT', 'Y');
INSERT INTO ord VALUES (
   101, 205, '31-AUG-1992', '15-SEP-1992',
   14, 8056.6, 'CREDIT', 'Y');
INSERT INTO ord VALUES (
   102, 206, '01-SEP-1992', '08-SEP-1992',
   15, 8335, 'CREDIT', 'Y');
INSERT INTO ord VALUES (
   103, 208, '02-SEP-1992', '22-SEP-1992',
   15, 377, 'CASH', 'Y');
INSERT INTO ord VALUES (
   104, 208, '03-SEP-1992', '23-SEP-1992',
   15, 32430, 'CREDIT', 'Y');
INSERT INTO ord VALUES (
   105, 209, '04-SEP-1992', '18-SEP-1992',
   11, 2722.24, 'CREDIT', 'Y');
INSERT INTO ord VALUES (
   106, 210, '07-SEP-1992', '15-SEP-1992',
   12, 15634, 'CREDIT', 'Y');
INSERT INTO ord VALUES (
   107, 211, '07-SEP-1992', '21-SEP-1992',
   15, 142171, 'CREDIT', 'Y');
INSERT INTO ord VALUES (
   108, 212, '07-SEP-1992', '10-SEP-1992',
   13, 149570, 'CREDIT', 'Y');
INSERT INTO ord VALUES (
   109, 213, '08-SEP-1992', '28-SEP-1992',
   11, 1020935, 'CREDIT', 'Y');
INSERT INTO ord VALUES (
   110, 214, '09-SEP-1992', '21-SEP-1992',
   11, 1539.13, 'CASH', 'Y');
INSERT INTO ord VALUES (
   111, 204, '09-SEP-1992', '21-SEP-1992',
   11, 2770, 'CASH', 'Y');
INSERT INTO ord VALUES (
   97, 201, '28-AUG-1992', '17-SEP-1992',
   12, 84000, 'CREDIT', 'Y');
INSERT INTO ord VALUES (
   98, 202, '31-AUG-1992', '10-SEP-1992',
   14, 595, 'CASH', 'Y');
INSERT INTO ord VALUES (
   99, 203, '31-AUG-1992', '18-SEP-1992',
   14, 7707, 'CREDIT', 'Y');
INSERT INTO ord VALUES (
   112, 210, '31-AUG-1992', '10-SEP-1992',
   12, 550, 'CREDIT', 'Y');
COMMIT;


--13 Napisać polecenie, które umożliwi przekopiowanie wybranych danych z tabeli pochodzącej ze skryptu SUMMIT do jednej z własnych tabel 
INSERT into review (review_id, review_text)
select id, date_shipped
from ord;

--14 Sprawdzić zawartość tak zmodyfikowanej tabeli własnej 
select * from review;