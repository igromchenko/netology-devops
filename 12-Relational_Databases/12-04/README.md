# Домашнее задание к занятию 12.4. «SQL. Часть 2» - Громченко Иван

Задание можно выполнить как в любом IDE, так и в командной строке.

### Задание 1

Одним запросом получите информацию о магазине, в котором обслуживается более 300 покупателей, и выведите в результат следующую информацию: 
- фамилия и имя сотрудника из этого магазина;
- город нахождения магазина;
- количество пользователей, закреплённых в этом магазине.

```sql
SELECT CONCAT_WS(' ', s2.first_name, s2.last_name) AS 'Менеджер:',
ca.city AS 'Филиал:', COUNT(c.customer_id) AS 'Кол-во клиентов:'
FROM store s
JOIN customer c ON c.store_id = s.store_id
JOIN staff s2 ON s2.staff_id = s.manager_staff_id
JOIN (SELECT address_id, city FROM address a JOIN city c ON c.city_id = a.city_id) AS ca ON ca.address_id = s.address_id
GROUP BY s.store_id HAVING COUNT(c.customer_id) > 300;
```

---

### Задание 2

Получите количество фильмов, продолжительность которых больше средней продолжительности всех фильмов.
```sql
SELECT COUNT(film_id)
FROM film
WHERE length > (SELECT AVG(length) FROM film);
```

---

### Задание 3

Получите информацию, за какой месяц была получена наибольшая сумма платежей, и добавьте информацию по количеству аренд за этот месяц. 

**Быстрый запрос, на случай, если максимальная сумма может быть только за однин месяц:**
```sql
SELECT DATE_FORMAT(payment_date, '%M-%Y') MonthYear, SUM(amount) Sum, COUNT(rental_id) Qty FROM payment GROUP BY MonthYear ORDER BY Sum DESC LIMIT 1;
```
**Либо, более медленный запрос, на случай, если максимальная сумма может быть одновременно за несколько месяцев:** 
```sql
SELECT DATE_FORMAT(payment_date, '%M-%Y') MonthYear, SUM(amount) Sum, COUNT(rental_id) Qty FROM payment GROUP BY MonthYear
HAVING Sum >= ALL(SELECT SUM(amount) FROM payment GROUP BY DATE_FORMAT(payment_date, '%M-%Y'));
```

---

### Задание 4*

Посчитайте количество продаж, выполненных каждым продавцом. Добавьте вычисляемую колонку «Премия». Если количество продаж превышает 8000, то значение в колонке будет «Да», иначе должно быть значение «Нет».
```sql
SELECT CONCAT(' ', s.first_name, s.last_name) AS 'Сотрудник:', COUNT(r.rental_id) AS 'Продажи:',
CASE WHEN COUNT(r.rental_id) > 8000 THEN 'красавчик' ELSE 'лопух' END AS 'Статус:'
FROM rental r JOIN staff s ON s.staff_id = r.staff_id GROUP BY s.staff_id;
```

---

### Задание 5*

Найдите фильмы, которые ни разу не брали в аренду.
```sql
SELECT title AS 'Фильм:'
FROM film f LEFT JOIN inventory i ON i.film_id = f.film_id
WHERE i.film_id IS NULL; 
```
---