SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================
-- Author: Rafael Lindenberg
-- Create date:	22/08/2016
-- Revisão:		
-- Description: Job Sem Taxa de Divisão de Lucro
-- =================================================

CREATE PROCEDURE [dbo].[spSemTaxaDivisao_Sel] --'ALL'

@all varchar(3)

AS	

	select distinct 
		HOU.Num_Proc	[JOB], 
		Hou.Master		[Master],
		HOU.ETD			[ETD],
		HOU.ATD			[ATD],
		HOU.ETA			[ETA],
		HOU.ATA			[ATA],
		PS.Apelido		[Shipper],
		PC.Apelido		[Consignee]
	from ATLANTIS.dbo.vwHouse_Exp HOU with(nolock)
	Join Campo_Processo TP	with(nolock)on HOU.Num_Proc = TP.Num_Proc and TP.Id_Campo ='143'
	Join Pessoa			PC	with(nolock)on Hou.Cd_Consig = PC.Cd_Pes
	Join Pessoa			PS	with(nolock)on Hou.Cd_Export = PS.Cd_Pes
	where (HOU.Master <>'JOB') 
	and (TP.Campo_Dados in ('2','3'))
	and (HOU.ATD >= '2016-01-01')
	and (ID_Status <> '9')
	and (HOU.Modal <> 'Other Export')
	and HOU.Num_Proc not in (
	select distinct Num_Proc_HIA from ATLANTIS.dbo.vwcta_Cte CTA with(nolock)
	Join Tipo_Taxa TT with(nolock)on  CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx and TT.CD_AX_Resultado = '324.2')

	Union ALL

	select distinct 
		HOU.Num_Proc	[JOB], 
		Hou.Master		[Master],
		HOU.ETD			[ETD],
		HOU.ATD			[ATD],
		HOU.ETA			[ETA],
		HOU.ATA			[ATA],
		PS.Apelido		[Shipper],
		PC.Apelido		[Consignee]
	from ATLANTIS.dbo.vwHouse_Imp HOU with(nolock)
	join Campo_Processo TP with(nolock)on  HOU.Num_Proc = TP.Num_Proc and TP.Id_Campo ='143'
	Join Pessoa			PC	with(nolock)on Hou.Cd_Consig = PC.Cd_Pes
	Join Pessoa			PS	with(nolock)on Hou.Cd_Export = PS.Cd_Pes
	where (HOU.Master <> 'JOB')
	and (TP.Campo_Dados in ('2','3')) 
	and (HOU.ATA >= '2016-01-01')
	and (ID_Status <> '9')
	and (HOU.Modal <> 'Other Import')
	and HOU.Num_Proc not in (
	select distinct Num_Proc_HIA from ATLANTIS.dbo.vwcta_Cte CTA with(nolock)
	Join Tipo_Taxa TT with(nolock)on  CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx and TT.CD_AX_Resultado = '324.2')
	order by Hou.Num_Proc
GO
