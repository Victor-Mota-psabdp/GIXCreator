SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Function  fReportConsolidado
	(
		@Ano	Int,
		@Mes	Int,
		@Cliente	Varchar(60),
		@modal		Varchar(10)
		)
Returns @Resultado TABLE(
		NetRevenue Float,
		Shipment   Float,
		Cash	   Float
)
AS

BEGIN
Declare @NetRevenue Float
Declare @Shipment  Float
Declare @Cash	Float

SET @NetRevenue =(
			select 
				sum(valor) Valor 
			from 
				cml.dbo.clientes_bkp 
			where 
				month(convert(datetime,dt_ins,105))=@Mes and year(convert(datetime,dt_ins,104))=@Ano and cliente like @Cliente and modal=@modal and cd_tp_tx not in (select cd_tp_tx from Taxas_Despacho)
			)

SET @Cash =(
			select 
				sum(valor) Valor 
			from 
				cml.dbo.clientes_totalCC 
			where 
				month(convert(datetime,dt_ins,105))=@Mes and year(convert(datetime,dt_ins,104))=@Ano and cliente like @Cliente and modal=@modal and cd_tp_tx not in (select cd_tp_tx from Taxas_Despacho)
			)

Set @shipment=
		(

			select 
				count(num_proc) Valor 
			from 
				cml.dbo.clientes_ship 
			where 
				month(convert(datetime,Data_Ship,105))=@Mes  and 
				year(convert(datetime,Data_Ship,104))=@Ano
				and cliente like @cliente and modal like @modal
		)

Insert into @Resultado
select @NetRevenue, @Cash, @Shipment
RETURN

END
GO
