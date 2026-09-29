SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure  [dbo].[spReportConsolidado_OUT] 
	(
		@Ano	Int,
		@Mes	Int,
		@Cliente	Varchar(60),
		@modal		Varchar(10)
		)

AS

BEGIN
Declare @NetRevenue Float
Declare @Shipment  Float
Declare @Cash	Float

SET @NetRevenue =Isnull((
			select 
				sum(valor) Valor 
			from 
				cml.dbo.clientes_bkp 
			where 
				month(convert(datetime,dt_ins,105))=@Mes and year(convert(datetime,dt_ins,104))=@Ano and cliente = @Cliente and modal=@modal and cd_tp_tx not in (select cd_tp_tx from Taxas_Despacho)
			),0)

SET @Cash =Isnull((
			select 
				sum(valor) Valor 
			from 
				cml.dbo.clientes_totalCC 
			where 
				month(convert(datetime,dt_ins,105))=@Mes and year(convert(datetime,dt_ins,104))=@Ano and cliente = @Cliente and modal=@modal and cd_tp_tx not in (select cd_tp_tx from Taxas_Despacho)
			),0)

Set @shipment=Isnull(
		(

			select 
				count(num_proc) Valor 
			from 
				cml.dbo.clientes_ship 
			where 
				month(convert(datetime,Data_Ship,105))=@Mes  and 
				year(convert(datetime,Data_Ship,104))=@Ano
				and cliente = @cliente and modal = @modal
		),0)

select @NetRevenue NetRevenue, @Cash CASH, @Shipment Shipment

END


GO
