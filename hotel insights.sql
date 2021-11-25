
with hotel as(

select * from dbo.['2018']
union 
select* from dbo.['2019']
union 
select * from dbo.['2020']
)

select * from hotel
left join market_segment on market_segment.market_segment = hotel.market_segment
left join meal_cost on meal_cost.meal = hotel.meal;

--select * from hotel;
--select  hotel,arrival_date_year,Sum((stays_in_weekend_nights+stays_in_week_nights)*adr) as revenue from hotel 
--group by hotel,arrival_date_year