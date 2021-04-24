--SQL ile RFM Analizi
Select o.CustomerID,
datediff(DAY,MAX(o.OrderDate), GETDATE()) as recency,
count(o.CustomerID) as frequency,
SUM((od.Quantity*od.UnitPrice)) AS monetary 
into #rfm --Bulunan değerlerin temp table'a kaydedilmesi
from Orders o inner join [Order Details] od on od.OrderID=o.OrderID
Group by o.CustomerID

Select #rfm.CustomerID,
      ntile(5) over (order by #rfm.recency) as r,--recency değerlerinin 5'e bölerek kümelendirilmesi
      ntile(5) over (order by #rfm.frequency) as f,--frequency değerlerinin 5'e bölerek kümelendirilmesi
      ntile(5) over (order by #rfm.monetary) as m --monetary değerlerinin 5'e bölerek kümelendirilmesi
	 
from #rfm
Group by #rfm.CustomerID,#rfm.recency,#rfm.frequency,#rfm.monetary
Order by #rfm.monetary
