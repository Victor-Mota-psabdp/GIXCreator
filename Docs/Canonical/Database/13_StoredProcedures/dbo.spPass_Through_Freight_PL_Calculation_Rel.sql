SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[spPass_Through_Freight_PL_Calculation_Rel] --'2016-09-01','2016-09-30'

	@DtInicial datetime,
	@DtFinal datetime
				
AS

select  
	I.Num_Proc_HIA				[JOB NUMBER],	
	V.Modal						[Modal],
	M.Tipo_Frete_Master			[Master Term],
	V.Tipo_Frete				[House Term],
	'PASSTHRU COST'				[PASSTHRU COST],
	convert(datetime,A.Dt_Envio,103)		[DATE],
	'16.1-INLAND FREIGHT'		[CHARGE NAME],
	TX.Nome_Tp_Tx				[CHARGE NAME ATL],
	X.ID_AX						[AX_DOC],
	I.Vlr_Org_HIA				[CURRENCY AMOUNT],
	I.Cd_Tp_Moeda				[CURRENCY],
	dbo.VerParidade(Convert(varchar(10),convert(datetime,A.Dt_Envio,103),103),I.cd_Tp_Moeda,'OFC')[EXCHANGE RATE],
	dbo.valor(I.Vlr_Org_HIA*dbo.VerParidade(Convert(varchar(10),convert(datetime,A.Dt_Envio,103),103),I.Cd_Tp_Moeda,'OFC'),I.DC_HIA) [BRL AMOUNT],	
	'PASSTHRU REVENUE'			[PASSTHRU REVENUE],
	convert(datetime,A.Dt_Envio,103) [DATE],
	'16.1-INLAND FREIGHT'		[CHARGE NAME],
	TX.Nome_Tp_Tx				[CHARGE NAME ATL],
	X.ID_AX						[AX_DOC],
	I.Vlr_Org_HIA * -1			[CURRENCY AMOUNT],
	I.Cd_Tp_Moeda				[CURRENCY],
	dbo.VerParidade(Convert(varchar(10),convert(datetime,A.Dt_Envio,103),103),I.cd_Tp_Moeda,'OFC')[EXCHANGE RATE],
	dbo.valor(I.Vlr_Org_HIA*dbo.VerParidade(Convert(varchar(10),convert(datetime,A.Dt_Envio,103),103),I.Cd_Tp_Moeda,'OFC'),I.DC_HIA) * -1 [BRL AMOUNT],
	(dbo.valor(I.Vlr_Org_HIA*dbo.VerParidade(Convert(varchar(10),convert(datetime,A.Dt_Envio,103),103),I.cd_Tp_Moeda,'OFC'),I.DC_HIA)) + 
	(dbo.valor(I.Vlr_Org_HIA*dbo.VerParidade(Convert(varchar(10),convert(datetime,A.Dt_Envio,103),103),I.cd_Tp_Moeda,'OFC'),I.DC_HIA) * -1)
	[FX EXCHAGE VARIATION]	
from vwcta_Cte I with(nolock)
	join vwHouse_Imp V with(nolock) on V.num_proc = I.Num_Proc_HIA
	join vwMaster_Imp_Completo M with(nolock) on M.Num_Proc_Master = V.Master
	join Tipo_Taxa TX with(nolock) on I.cd_tp_Tx = TX.Cd_Tp_Tx
	left join AX_DOC_XML A with(nolock)  on I.Num_Proc_Hia = A.Num_Proc and I.Cd_Tp_Tx = A.Cd_tp_Tx_ATL and I.DC_HIA = A.DC 
	left join vwAXDocs X with(nolock)  on I.Num_Proc_Hia = X.Num_Proc and I.Cd_Tp_Tx = X.Cd_tp_Tx_ATL and I.DC_HIA = X.DC 
where 
	--I.Num_Proc_HIA = 'IMATL201609001BR' and 	
	--X.id_Ax is null	and 
	(TX.Cd_AX_Repasse = '16.1')
	and V.Master <> 'JOB'	
	and convert(datetime,V.Dt_Emis,105) between @DtInicial and @DtFinal

GO
