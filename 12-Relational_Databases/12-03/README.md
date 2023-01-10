# Домашнее задание к занятию 12.3. «SQL. Часть 1» - Громченко Иван

Задание можно выполнить как в любом IDE, так и в командной строке.

### Задание 1

Получите уникальные названия районов из таблицы с адресами, которые начинаются на “K” и заканчиваются на “a” и не содержат пробелов.
```sql
SELECT DISTINCT district FROM address where district LIKE 'K%a' AND district NOT LIKE '% %';
```

---

### Задание 2

Получите из таблицы платежей за прокат фильмов информацию по платежам, которые выполнялись в промежуток с 15 июня 2005 года по 18 июня 2005 года **включительно** и стоимость которых превышает 10.00.
```sql
SELECT * FROM payment WHERE amount > 10.00 AND CAST(payment_date AS date) BETWEEN '2005-06-15' AND '2005-06-18';
```

---

### Задание 3

Получите последние пять аренд фильмов.

**Конкретный SQL-запрос зависит от того, что именно имеется в виду под "последние пять аренд". Постановка задачи мне не понятна.**
```sql
SELECT * FROM rental WHERE rental_date = (SELECT MAX(rental_date) FROM rental) ORDER BY rental_id DESC LIMIT 5;
```

---

### Задание 4

Одним запросом получите активных покупателей, имена которых Kelly или Willie. 

Сформируйте вывод в результат таким образом:
- все буквы в фамилии и имени из верхнего регистра переведите в нижний регистр,
- замените буквы 'll' в именах на 'pp'.
```sql
SELECT customer_id, REPLACE (LOWER(first_name), 'll', 'pp'), LOWER(last_name)
FROM customer WHERE first_name IN ('Kelly', 'Willie') AND active = '1';
```

---

### Задание 5*

Выведите Email каждого покупателя, разделив значение Email на две отдельных колонки: в первой колонке должно быть значение, указанное до @, во второй — значение, указанное после @.
```sql
SELECT SUBSTRING_INDEX(email, '@', 1), SUBSTRING_INDEX(email, '@', -1) FROM customer;
```

---

### Задание 6*

Доработайте запрос из предыдущего задания, скорректируйте значения в новых колонках: первая буква должна быть заглавной, остальные — строчными.
```sql
SELECT
CONCAT(LEFT(UPPER(email), 1), lOWER(SUBSTR(email, 2, POSITION('@' IN email) - 2))),
CONCAT(LEFT(UPPER(SUBSTRING_INDEX(email, '@', -1)), 1), LOWER(RIGHT(email, LENGTH(email) - POSITION('@' IN email) - 1)))
FROM customer;
```

---