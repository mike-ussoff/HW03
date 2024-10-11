create or replace function warehouse.searchforstockitems (
	in searchtext varchar(1000),
	in maximumrowstoreturn int)
returns varchar
language plpgsql 
security definer
as $$
declare
  res text;
begin
select row_to_json(t)
from 
(
	select array_to_json(array_agg(row_to_json(d))) as stockitems
	from 
	(
		select stockitemid, stockitemname
		from warehouse.stockitems	
		where searchdetails ilike '%' || searchtext || '%'
		order by stockitemname
		limit maximumrowstoreturn
	) d
)t into res;
return res;
end;
$$;

select warehouse.searchforstockitems('JOKE', 100) as json;