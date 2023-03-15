-- 3-event show?
SELECT TOP 3 *
FROM Wydarzenia

--how many employees there are ?
SELECT COUNT(*)
FROM Pracownik

-- Show the floor number of the promotion department
SELECT NrPietra
FROM Dzial
WHERE NazwaDzialu = ˈPromocjaˈ-- Show employees who are not named Anna and Stefan
SELECT * 
FROM Pracownik
WHERE Imie NOT IN ('Anna', 'Stefan') --How many events are happening over the vacations
SELECT COUNT(*) 
FROM Wydarzenia
WHERE DataWydarzenia BETWEEN '2015-07-01' AND '2015-08-31'

--Show all women 
SELECT *
FROM Pracownik
WHERE Imie LIKE '%a'

--Show all events that took place outside of Wroclaw
SELECT * 
FROM Wydarzenia 
WHERE Miejsce NOT LIKE 'Wrocław%'

--How many events were organized in Wroclaw?
SELECT COUNT(*) 
FROM Wydarzenia 
WHERE Miejsce LIKE 'Wrocław%'

--Show sorted employees by last name
SELECT *
FROM Pracownik
ORDER BY Nazwisko

--Show sorted employees by last name
SELECT *
FROM Pracownik
ORDER BY Imie DESC

-- Show events sorted by name that took place in Wroclaw
SELECT *
FROM Wydarzenia
WHERE Miejsce LIKE 'Wrocław%'
ORDER BY Nazwa

--What is the price of the cheapest 'rodent'?
SELECT MIN(Cena)
FROM Asortyment
WHERE IdTypyAsortymentu = 1

--When was the last order?
SELECT MAX(DataZamowienia)
FROM Zamowienia

--Show the three most expensive products?
SELECT TOP 3 Nazwa
FROM Asortyment
ORDER BY Cena DESC

-- Show the employee earning the best ?
SELECT TOP 1 *
FROM Pracownicy
ORDER BY PensjaPodstawowa + (PensjaPodstawowa * Premia/100.0) DESC

-- What is the average salary ?
SELECT CAST(AVG(PensjaPodstawowa + (PensjaPodstawowa * Premia/100.0) AS
decimal (7,2))
FROM Pracownicy

-- What is the average age of clients?
SELECT AVG(Wiek)
FROM Klienci

-- How many assortments of a particular type?
SELECT IdTypyAsortymentu, COUNT(*) AS Ilosc 
FROM Asortyment
GROUP BY IdTypyAsortymentu

--What is the average price of each assortment group?
SELECT IdTypyAsortymentu, AVG(Cena) AS SredniaCena 
FROM Asortyment
GROUP BY IdTypyAsortymentu

-- What is the average purchase quantity of a specific assortment?

SELECT IdAsortyment, AVG(CAST(Ilosc AS decimal(1,0))) AS SredniaIloscZakupu 
FROM Zakupy
GROUP BY IdAsortyment

--  How much of a specific type of assortment was ordered?
SELECT IdAsortyment, SUM(Ilosc) AS Ilosc 
FROM ZamowieniaAsortyment
GROUP BY IdAsortyment

-- How many times was the specific type of assortment ordered?
SELECT IdAsortyment, COUNT(*) AS Ilosc 
FROM ZamowieniaAsortyment
GROUP BY IdAsortyment

-- In which month was the most assortment sold?
SELECT TOP 1 MONTH(DataZakupu) AS Miesiac 
FROM Zakupy
GROUP BY MONTH(DataZakupu)
ORDER BY SUM(Ilosc) DESC

--On which day in March were the most purchases made?
SELECT TOP 1 DAY(DataZakupu) AS Dzien 
FROM Zakupy
GROUP BY DAY(DataZakupu), MONTH(DataZakupu)
HAVING MONTH(DataZakupu) = 3
ORDER BY COUNT(*) DESC
zobacz moje szkolenia na geek-on.pl
Krystian Brożek © Wszelkie prawa zastrzeżone

-- Which month had the lowest average sales?
SELECT TOP 1 MONTH(DataZakupu) AS Miesiac, SUM(Ilosc) AS Ilosc 
FROM Zakupy
GROUP BY MONTH(DataZakupu)
ORDER BY Ilosc DESC

-- What is the average price of a hamster?
SELECT AVG(CAST(Cena AS decimal(3,0))) AS SredniaCena
FROM Asortyment
WHERE Nazwa LIKE 'Chomik%'

-- What type is the assortment?
SELECT a.Nazwa AS NazwaAsortymentu, 
 ta.Nazwa AS NazwaTypu 
FROM Asortyment a
 INNER JOIN TypyAsortymentu ta
 ON a.IdTypyAsortymentu= ta.IdTypyAsortymentu

-- What department do the employees are working in?
SELECT p.Imie, p.Nazwisko, d.NazwaDzialu 
FROM Pracownicy p
 INNER JOIN PracownicyDzialy pd 
 ON p.IdPracownicy = pd.IdPracownicy 
 INNER JOIN Dzialy d
 ON d.IdDzialy = pd.IdDzialy

-- What did the customers buy?
SELECT k.Imie, k.Wiek, a.Nazwa 
FROM Klienci k
 INNER JOIN Zakupy z
 ON k.IdKlienci = z.IdKlient 
 INNER JOIN Asortyment a
 ON a.IdAsortyment = z.IdAsortyment

--Connect purchases with returns
SELECT *
FROM Zakupy z
 INNER JOIN Zwroty zw 
 ON z.IdZakupy = zw.IdZakupy 
SELECT *
FROM Zakupy z
 LEFT JOIN Zwroty zw 
 ON z.IdZakupy = zw.IdZakupy

-- Who delivered the order?
SELECT z.*, d.Nazwa 
FROM Zamowienia z
 INNER JOIN Dostawcy d
 ON z.IdDostawcy = d.IdDostawcy

-- Add yourself as a new employee
INSERT INTO Pracownicy 
VALUES ('Natalia', 'Nowak', '1231231231', 2000, 10)
INSERT INTO PracownicyDzialy 
VALUES (SCOPE_IDENTITY(), 4)

-- Add three new customers (including yourself)
INSERT INTO Klienci 
VALUES ('Natalia', 18), ('Żalina', 23), ('Hanna', null)

-- Buy any pet you want
INSERT INTO Zakupy 
VALUES (1, 93, (SELECT GETDATE()), 1)

-- Give all employees a 5% raise  
UPDATE Pracownicy 
SET PensjaPodstawowa = PensjaPodstawowa * 1.05

-- Replace : świnkę morską with kawię domową
UPDATE Asortyment
SET Nazwa = 'Kawia domowa' 
WHERE Nazwa = 'Swinka morska'

-- Delete April purchases "siano"
DELETE FROM Zakupy 
WHERE IdAsortyment = (SELECT IdAsortyment
FROM Asortyment
WHERE Nazwa = 'Siano')
