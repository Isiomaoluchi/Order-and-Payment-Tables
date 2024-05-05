SELECT TOP (1000) [order_id]
      ,[customer_id]
      ,[order_status]
      ,[order_purchase_timestamp]
      ,[order_approved_datetime]
      ,[order_delivered_carrier_date]
      ,[order_delivered_customer_date]
      ,[order_estimated_delivery_date]
  FROM [Oluchi's workbook].[dbo].[olist_orders_dataset#csv$]

  --data cleaning
select order_id, count (*) count_of_duplicates
from[Oluchi's workbook].[dbo].[olist_orders_dataset#csv$]
group by order_id
having count (*)>1 

select customer_id, count (*) count_of_duplicates
from[Oluchi's workbook].[dbo].[olist_orders_dataset#csv$]
group by customer_id
having count (*)>1 

  --data cleaning
select order_id, count (*) count_of_duplicates
from[dbo].[olist_orders_dataset#csv$]
group by order_id
having count (*)>1 

select customer_id, count (*) count_of_duplicates
from[dbo].[olist_orders_dataset#csv$]
group by customer_id
having count (*)>1 

--checking for null values
select order_id, count (*) Count_of_null_values
from [dbo].[olist_orders_dataset#csv$]
group by order_id
having order_id = Null


--checking for null values
select 'order_id' as column_name, count (*) Count_of_null_values
from [dbo].[olist_orders_dataset#csv$]
group by order_id
having order_id = Null
union
select 'order_approved_datetime', count (*) Count_of_null_values
from [dbo].[olist_orders_dataset#csv$]
group by order_approved_datetime
having order_approved_datetime is Null
union
select 'order_delivered_carrier_date', count (*) Count_of_null_values
from [dbo].[olist_orders_dataset#csv$]
group by order_delivered_carrier_date
having order_delivered_carrier_date is  Null
union
select 'order_delivered_customer_date', count (*) Count_of_null_values
from [dbo].[olist_orders_dataset#csv$]
group by order_delivered_customer_date
having order_delivered_customer_date is  Null
union
select  'order_estimated_delivery_date', count (*) Count_of_null_values
from [dbo].[olist_orders_dataset#csv$]
group by order_estimated_delivery_date
having order_estimated_delivery_date is  Null

--dated iff
select order_id, order_delivered_carrier_date,order_delivered_customer_date,order_status,
CONCAT(DATEDIFF(YEAR,order_delivered_carrier_date, order_delivered_customer_date)%12,'year', 
DATEDIFF(day,order_delivered_carrier_date, order_delivered_customer_date)%30,'day',
DATEDIFF(hour,order_delivered_carrier_date, order_delivered_customer_date)%24,'hours',
DATEDIFF(MINUTE,order_delivered_carrier_date, order_delivered_customer_date)%60,'minutes',
DATEDIFF(second, order_delivered_carrier_date, order_delivered_customer_date)%60,'seconds') time_difference
from [dbo].[olist_orders_dataset#csv$]
order by time_difference desc

--sub query
select order_status, time_difference
from 
(select order_id, order_delivered_carrier_date,order_delivered_customer_date,order_status,
CONCAT(DATEDIFF(YEAR,order_delivered_carrier_date, order_delivered_customer_date)%12,'year', 
DATEDIFF(day,order_delivered_carrier_date, order_delivered_customer_date)%30,'day',
DATEDIFF(hour,order_delivered_carrier_date, order_delivered_customer_date)%24,'hours',
DATEDIFF(MINUTE,order_delivered_carrier_date, order_delivered_customer_date)%60,'minutes',
DATEDIFF(second, order_delivered_carrier_date, order_delivered_customer_date)%60,'seconds') time_difference
from [dbo].[olist_orders_dataset#csv$]) as TD
group by  order_status, time_difference


 --orders that were cancelled and also delivered

SELECT order_status, customer_id,order_delivered_customer_date
FROM [dbo].[olist_orders_dataset#csv$]
WHERE order_status IN ('delivered', 'canceled')
GROUP BY order_status, customer_id, order_delivered_customer_date

--approved orders but customers did not get

SELECT order_status, customer_id, order_delivered_customer_date, COUNT(*) AS null_values
FROM  [dbo].[olist_orders_dataset#csv$]
WHERE order_status = 'approved' AND order_delivered_customer_date IS NULL
GROUP BY order_status, customer_id, order_delivered_customer_date

--cancelled, carrier got it but was not delivered
SELECT order_status, customer_id,order_delivered_carrier_date, order_delivered_customer_date, COUNT(*) AS null_values
FROM  [dbo].[olist_orders_dataset#csv$]
WHERE order_status = 'cancelled' AND order_delivered_customer_date IS NULL
GROUP BY order_status, customer_id,order_delivered_carrier_date, order_delivered_customer_date

  --orders paid for twice
  select order_id, COUNT(*) duplicate, payment_value
  from [dbo].[olist_order_payments_dataset#cs$]
  group by order_id, payment_value
  having COUNT(*)>1

  --find payment method having issues
  select payment_sequential,payment_type
  from[dbo].[olist_order_payments_dataset#cs$]
  where payment_sequential>1 
  order by payment_sequential desc
  
  --Assignment
  --count the different payment methods
  --try other joins


  --invoice paid for with full join
  select *
  from [dbo].[olist_order_payments_dataset#cs$] PD
  full join[dbo].[olist_orders_dataset#csv$] OD
  ON PD.order_id = OD.order_id
  WHERE order_status='invoiced'

  --count invoice that was paid
  select *
  from [dbo].[olist_order_payments_dataset#cs$] PD    
  left join [dbo].[olist_orders_dataset#csv$] OD
  ON PD.order_id = OD.order_id
  WHERE order_status = 'invoiced' and payment_value is not null
  
  select payment_type, COUNT(*) Duplicates 
  from [dbo].[olist_order_payments_dataset#cs$]
  group by payment_type
  having count(*) >1


   select *
  from [dbo].[olist_order_payments_dataset#cs$] PD    
 full join [dbo].[olist_orders_dataset#csv$] OD
  ON PD.order_id = OD.order_id
  
     select *
  from [dbo].[olist_order_payments_dataset#cs$] PD    
 full join [dbo].[olist_orders_dataset#csv$] OD
  ON PD.order_id = OD.order_id
  where order_status = 'delivered' and PD. payment_value is not null

 
select OD.order_id, PD.payment_type, OD. order_status, 
case 
when OD. order_status = 'invoiced' and PD. payment_type = 'credit_card' then 'invoiced paid'
when OD. order_status = 'invoiced' and PD. payment_type = 'boleto' then 'invoiced paid'
when OD. order_status = 'invoiced' and PD. payment_type = 'voucher' then 'invoiced paid'
when OD. order_status = 'invoiced' and PD. payment_type = 'debit_card' then 'invoiced paid'
when OD. order_status = 'invoiced' and PD. payment_type = 'not_defined' then 'invoiced paid'
else 'invoiced_not_paid'
end Invoice_Status
from [dbo].[olist_order_payments_dataset#cs$] PD
full join [dbo].[olist_orders_dataset#csv$] OD
on OD. order_id = PD. order_id
where Invoice_Status = 'invoiced paid'


with Invoice_table as (
select OD.order_id as info, PD.payment_type as payment, OD. order_status as status, 
case 
when OD. order_status = 'invoiced' and PD. payment_type = 'credit_card' then 'invoiced paid'
when OD. order_status = 'invoiced' and PD. payment_type = 'boleto' then 'invoiced paid'
when OD. order_status = 'invoiced' and PD. payment_type = 'voucher' then 'invoiced paid'
when OD. order_status = 'invoiced' and PD. payment_type = 'debit_card' then 'invoiced paid'
when OD. order_status = 'invoiced' and PD. payment_type = 'not_defined' then 'invoiced paid'
else 'invoiced_not_paid'
end Invoice_Status
from [dbo].[olist_order_payments_dataset#cs$] PD
full join [dbo].[olist_orders_dataset#csv$] OD
on OD. order_id = PD. order_id
)
select Invoice_Status,payment, info, status 
from Invoice_table
where status = 'invoiced'