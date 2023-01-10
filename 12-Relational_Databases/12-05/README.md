# Домашнее задание к занятию 12.5. «Индексы» - Громченко Иван

### Задание 1

Напишите запрос к учебной базе данных, который вернёт процентное отношение общего размера всех индексов к общему размеру всех таблиц.
```sql
SELECT CONCAT(SUM(index_length)/SUM(data_length)*100, '%') AS 'Объём индексов:'
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = "sakila" AND TABLE_TYPE = "BASE TABLE";
```

---

### Задание 2

Выполните explain analyze следующего запроса:
```sql
select distinct concat(c.last_name, ' ', c.first_name), sum(p.amount) over (partition by c.customer_id, f.title)
from payment p, rental r, customer c, inventory i, film f
where date(p.payment_date) = '2005-07-30' and p.payment_date = r.rental_date and r.customer_id = c.customer_id and i.inventory_id = r.inventory_id
```
- перечислите узкие места;
- оптимизируйте запрос: внесите корректировки по использованию операторов, при необходимости добавьте индексы.

**В приведенном выше SQL-запросе (выполняется за 2,8 с.) присутствуют следующие проблемы:**
1. Неоправданное использование непонятной конструкции из DISTINCT и оконной фунции вместо GROUP BY
2. Поиск по нескольким таблицам с критерием равенства нескольких полей вместо объединения таблиц по ключу
3. Использование функции DATE в выражении WHERE, не позволяющей применить индекс по столбцу payment_date

**Оптимизированный запрос выполняется за 8 мс.:**
```sql
SELECT CONCAT(c.last_name, ' ', c.first_name), SUM(p.amount)
FROM payment p JOIN customer c ON c.customer_id = p.customer_id
WHERE DATE(p.payment_date) = '2005-07-30'
GROUP BY p.customer_id;
```
**При этом, попытка дальнейшей оптимизации запроса с использованием индекса по столбцу "payment_date" в таблице "payment" дает обратный результат - индекс почему то не используется. Запрос выполняется за 16 мс.**
```sql
SELECT CONCAT(c.last_name, ' ', c.first_name), SUM(p.amount)
FROM payment p JOIN customer c ON c.customer_id = p.customer_id
WHERE p.payment_date BETWEEN '2005-07-30' AND '2005-07-31'
GROUP BY p.customer_id;
```

---

### Задание 3*

Самостоятельно изучите, какие типы индексов используются в PostgreSQL. Перечислите те индексы, которые используются в PostgreSQL, а в MySQL — нет.

*Приведите ответ в свободной форме.*

**В PostgreSQL используются индексы:**
1. B-tree (есть в MySQL)
2. HASH (есть в MySQL)
3. GIST (аналог R-tree в MySQL)
4. SP-GIST (аналог R-tree в MySQL)
5. GIN (аналог INVERTED в MySQL)
6. BRIN (нет аналога в MySQL)

---