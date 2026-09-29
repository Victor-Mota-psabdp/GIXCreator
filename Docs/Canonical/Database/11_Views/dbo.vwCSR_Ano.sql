SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view vwCSR_Ano

AS

--Exportação Aérea
select 
	month(convert(datetime,dt_emis_hea,105)) Mes, year(convert(datetime,dt_emis_hea,105)) Ano, 
	count(job_hea) Qty
from 
	house_exp_aer
Where 
	left(job_hea,2)='EA' and convert(datetime,dt_emis_hea,105)>='01-01-2004'
group by
	month(convert(datetime,dt_emis_hea,105)) , year(convert(datetime,dt_emis_hea,105)) 

Union All

--Importação Aérea
select 
	month(convert(datetime,dt_emis_hIa,105)) Mes, year(convert(datetime,dt_emis_hIa,105)) Ano, 
	count(job_hia) Qty
from 
	house_imp_aer
Where 
	left(job_hia,2)='IA' and convert(datetime,dt_emis_hia,105)>='01-01-2004'
group by
	month(convert(datetime,dt_emis_hia,105)) , year(convert(datetime,dt_emis_hia,105)) 

Union All

--Exportacao Maritima
select 
	month(convert(datetime,dt_emis_HEM,105)) Mes, year(convert(datetime,dt_emis_HEM,105)) Ano, 
	count(job_HEM) Qty
from 
	house_exp_mar
Where 
	left(job_HEM,2)='EM' and convert(datetime,dt_emis_HEM,105)>='01-01-2004'
group by
	month(convert(datetime,dt_emis_HEM,105)) , year(convert(datetime,dt_emis_HEM,105)) 

Union ALL

select 
	month(convert(datetime,dt_emis_HIM,105)) Mes, year(convert(datetime,dt_emis_HIM,105)) Ano, 
	count(job_HIM) Qty
from 
	house_imp_mar
Where 
	left(job_HIM,2)='IM' and convert(datetime,dt_emis_HIM,105)>='01-01-2004'
group by
	month(convert(datetime,dt_emis_HIM,105)) , year(convert(datetime,dt_emis_HIM,105)) 


GO
