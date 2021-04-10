

with rfm as
(
Select o.CustomerID,
datediff(DAY,MAX(o.OrderDate), GETDATE()) as recency,
count(distinct o.OrderDate) as frequency,
SUM((od.Quantity*od.UnitPrice)) AS monetary 
from Orders o inner join [Order Details] od on od.OrderID=o.OrderID
Group by o.CustomerID
)

Select rfm.CustomerID,
      ntile(5) over (order by rfm.recency) as r,
      ntile(5) over (order by rfm.frequency) as f,
      ntile(5) over (order by rfm.monetary) as m
	 
from rfm
Group by rfm.CustomerID,rfm.recency,rfm.frequency,rfm.monetary
Order by rfm.monetary

