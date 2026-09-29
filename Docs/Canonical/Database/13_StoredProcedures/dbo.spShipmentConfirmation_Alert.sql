SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--chamado 19056
--Por gentileza, excluir os e-mails abaixo dos alertas enviado por este e-mail: noreply@bdp.com.br 
--com cópia dos documentos de embarque:
--
--bdp.adriana@oxiteno.com
--bdp.tatiana@oxiteno.com
--luciana.nahssen@oxiteno.com
--danila.silva@oxiteno.com
--flavia.soares@oxiteno.com


--select ResponderPara, DocAnexos, Destinatarios   from msdb.dbo.Alerta_Email where Nome_Alerta = 'SHIPMENT CONFIRMATION' 
--select * from Alerta_Email_Historico 

CREATE procedure [dbo].[spShipmentConfirmation_Alert]

AS

	declare @ResponderPara varchar(50)
	declare @DocAnexos varchar(100)
	declare @Destinatarios varchar(500)

	set @ResponderPara = 'oxiteno.exp@bdp.com.br'
	set @DocAnexos = '2;11;13;16;20;22;21;103;65;27'
	set @Destinatarios = 'oxiteno.exp@bdp.com.br;bdp.juliana@oxiteno.com;carlos.eduardo@bdp.com.br;juliana.otsubo@oxiteno.com;dayane.jesse@oxiteno.com;luciana.nahssen@oxiteno.com'

--select com o atd_lem - hoje menos 3 dias - Só para Paises do Mercosul
	select distinct --top 5
		GR.Nome_Raz_Soc Grupo, SO.Numero_PO_HEM [Order], SHIP.Nome_Raz_Soc Shipper, IMP.Nome_Raz_Soc Importer, HOU.Navio_HEM Vessel, ORG.Nome_Local Origem, 
		DST.Nome_Local Destino, convert(char(10),LLP.ETD_LEM,101) ETD, convert(char(10),LLP.ATD_LEM,101) ATD, convert(char(10),LLP.ETA_LEM,101) ETA, HOU.HAWB_HEM BL_Number, COU.Nome_Raz_Soc Courier_Name, LLP.Courier_Number_Lem Courier_Number,
		@ResponderPara ResponderPara, @DocAnexos DocAnexos, HOU.Num_Proc_HEM JOB, 63 ID, @Destinatarios Email
--		'noreply@bdp.com.br' Email
	from
		House_Exp_Mar HOU with(nolock)
		join LLP_Exp_Mar LLP with(nolock) on LLP.Num_Proc_LEM = HOU.Num_Proc_HEM
		join Pessoa SHIP with(nolock) on SHIP.Cd_pes = HOU.cd_export_hem
		join Pessoa IMP with(nolock) on IMP.cd_pes = HOU.cd_consig_hem
		left join Pessoa COU with(nolock) on LLP.Cd_Courier = COU.Cd_Pes
		join Localidade ORG with(nolock) on ORG.cd_local = HOU.cd_org_hem
		join Localidade DST with(nolock) on DST.cd_local = HOU.cd_dst_hem
		left join PO_HEM SO with(nolock) on SO.Num_Proc_HEM = HOU.Num_Proc_HEM and SO.ID_DC=3
		join Pessoa_LLP PL with(nolock) on PL.cd_pes = HOU.cd_export_hem and PL.cd_pes_grupo = 'P21128'
		Join Pessoa GR with(nolock) on GR.Cd_Pes = PL.Cd_Pes_Grupo
		join Grupo GP with(nolock) on GP.Cd_Pes_Grupo = GR.Cd_Pes
--		join msdb.dbo.Alerta_Email AE with(nolock) on AE.id = 63 --Grupo COLLATE Latin1_General_CI_AI = GP.Grupo and AE.Nome_Alerta = 'SHIPMENT CONFIRMATION' 
		left join Alerta_Email_Historico AEH with(nolock) on AEH.Id_Alerta_Email = 63 and AEH.Num_Proc = HOU.Num_Proc_HEM
		Left Join Hist_Geral HST with(nolock) on HST.hsgprocesso=num_proc_lem and cd_tp_ocor=-2
	where
		AEH.Num_Proc IS NULL 
		AND HSGDATA <=GETDATE()-2
		and (dst.cd_pais = 'AR' or dst.cd_pais = 'UY' or dst.cd_pais = 'PY')
		and HSGDATA >='09-01-2011'

UNION ALL

--Select com o Atd_lem - hoje menos 4 excluidos - paises do Mercosul
select distinct --top 5
		GR.Nome_Raz_Soc Grupo, SO.Numero_PO_HEM [Order], SHIP.Nome_Raz_Soc Shipper, IMP.Nome_Raz_Soc Importer, HOU.Navio_HEM Vessel, ORG.Nome_Local Origem, 
		DST.Nome_Local Destino, convert(char(10),LLP.ETD_LEM,101) ETD, convert(char(10),LLP.ATD_LEM,101) ATD, convert(char(10),LLP.ETA_LEM,101) ETA, HOU.HAWB_HEM BL_Number, COU.Nome_Raz_Soc Courier_Name, LLP.Courier_Number_Lem Courier_Number,
		@ResponderPara ResponderPara, @DocAnexos DocAnexos, HOU.Num_Proc_HEM JOB, 63 ID, @Destinatarios Email
--		'noreply@bdp.com.br' Email
	from
		House_Exp_Mar HOU with(nolock) 
		join LLP_Exp_Mar LLP with(nolock) on LLP.Num_Proc_LEM = HOU.Num_Proc_HEM
		join Pessoa SHIP with(nolock) on SHIP.Cd_pes = HOU.cd_export_hem
		join Pessoa IMP with(nolock) on IMP.cd_pes = HOU.cd_consig_hem
		Left join Pessoa COU with(nolock) on LLP.Cd_Courier = COU.Cd_Pes
		join Localidade ORG with(nolock) on ORG.cd_local = HOU.cd_org_hem
		join Localidade DST with(nolock) on DST.cd_local = HOU.cd_dst_hem
		left join PO_HEM SO with(nolock) on SO.Num_Proc_HEM = HOU.Num_Proc_HEM and SO.ID_DC=3
		join Pessoa_LLP PL with(nolock) on PL.cd_pes = HOU.cd_export_hem and PL.cd_pes_grupo = 'P21128'
		Join Pessoa GR with(nolock) on GR.Cd_Pes = PL.Cd_Pes_Grupo
		join Grupo GP with(nolock) on GP.Cd_Pes_Grupo = GR.Cd_Pes
--		join msdb.dbo.Alerta_Email AE with(nolock) on AE.id=63 --Grupo COLLATE Latin1_General_CI_AI = GP.Grupo and AE.Nome_Alerta = 'SHIPMENT CONFIRMATION' 
		left join Alerta_Email_Historico AEH with(nolock) on AEH.Id_Alerta_Email = 63 and AEH.Num_Proc = HOU.Num_Proc_HEM
		Left Join Hist_Geral HST with(nolock) on HST.hsgprocesso=num_proc_lem and cd_tp_ocor=-2
	where
		AEH.Num_Proc IS NULL 
--		and (LLP.ATD_LEM between (getdate()-5) and (getdate()-4))
		AND HSGDATA <=GETDATE()-4
		and not(dst.cd_pais = 'AR')
		and not(dst.cd_pais = 'UY') 
		and not(dst.cd_pais = 'PY')
			and HSGDATA >='09-01-2011'


UNION ALL

	select distinct --top 5
		GR.Nome_Raz_Soc Grupo, SO.Numero_PO_HEO [Order], SHIP.Nome_Raz_Soc Shipper, IMP.Nome_Raz_Soc Importer, 'N/A' Vessel, ORG.Nome_Local Origem, 
		DST.Nome_Local Destino, convert(char(10),LLP.ETD_LEO,101) ETD, convert(char(10),LLP.ATD_LEO,101) ATD, convert(char(10),LLP.ETA_LEO,101) ETA, HOU.HAWB_HEO BL_Number, COU.Nome_Raz_Soc Courier_Name, LLP.Courier_Number_LEO Courier_Number,
		@ResponderPara ResponderPara, @DocAnexos DocAnexos, HOU.Num_Proc_HEO JOB, 63 ID, @Destinatarios Email
--		'noreply@bdp.com.br' Email
	from
		House_Exp_OUT HOU with(nolock) 
		join LLP_Exp_OUT LLP with(nolock) on LLP.Num_Proc_LEO = HOU.Num_Proc_HEO
		join Pessoa SHIP with(nolock) on SHIP.Cd_pes = HOU.cd_export_HEO
		join Pessoa IMP with(nolock) on IMP.cd_pes = HOU.cd_consig_HEO
		left join Pessoa COU with(nolock) on LLP.Cd_Courier = COU.Cd_Pes
		join Localidade ORG with(nolock) on ORG.cd_local = HOU.cd_org_HEO
		join Localidade DST with(nolock) on DST.cd_local = HOU.cd_dst_HEO
		left join PO_HEO SO with(nolock) on SO.Num_Proc_HEO = HOU.Num_Proc_HEO and SO.ID_DC=3
		join Pessoa_LLP PL with(nolock) on PL.cd_pes = HOU.cd_export_HEO and PL.cd_pes_grupo = 'P21128'
		Join Pessoa GR with(nolock) on GR.Cd_Pes = PL.Cd_Pes_Grupo
		join Grupo GP with(nolock) on GP.Cd_Pes_Grupo = GR.Cd_Pes
--		join msdb.dbo.Alerta_Email AE with(nolock) on AE.id=63 --Grupo COLLATE Latin1_General_CI_AI = GP.Grupo and AE.Nome_Alerta = 'SHIPMENT CONFIRMATION' 
		left join Alerta_Email_Historico AEH with(nolock) on AEH.Id_Alerta_Email = 63 and AEH.Num_Proc = HOU.Num_Proc_HEO
		Left Join Hist_Geral HST with(nolock) on HST.hsgprocesso=num_proc_LEO and cd_tp_ocor=-2
	where
		AEH.Num_Proc IS NULL 
		AND HSGDATA <=GETDATE()-2 
		--and (dst.cd_pais = 'AR' or dst.cd_pais = 'UY' or dst.cd_pais = 'PY')
		and HSGDATA >='09-01-2011'




-------------------Antigo - mudou dia 28/07/2011
--ALTER procedure [dbo].[spShipmentConfirmation_Alert]
--
--AS
--	select distinct
--		GR.Nome_Raz_Soc Grupo, SO.Numero_PO_HEM [Order], SHIP.Nome_Raz_Soc Shipper, IMP.Nome_Raz_Soc Importer, HOU.Navio_HEM Vessel, ORG.Nome_Local Origem, 
--		DST.Nome_Local Destino, convert(char(10),LLP.ETD_LEM,101) ETD, convert(char(10),LLP.ATD_LEM,101) ATD, convert(char(10),LLP.ETA_LEM,101) ETA, HOU.HAWB_HEM BL_Number, COU.Nome_Raz_Soc Courier_Name, LLP.Courier_Number_Lem Courier_Number,
--		@ResponderPara ResponderPara, @DocAnexos DocAnexos, HOU.Num_Proc_HEM JOB, AE.ID, @Destinatarios Destinatarios Email
----		'sistemas@bdp.com.br' Email
--	from
--		House_Exp_Mar HOU
--		join LLP_Exp_Mar LLP on LLP.Num_Proc_LEM = HOU.Num_Proc_HEM
--		join Pessoa SHIP on SHIP.Cd_pes = HOU.cd_export_hem
--		join Pessoa IMP on IMP.cd_pes = HOU.cd_consig_hem
--		join Pessoa COU on LLP.Cd_Courier = COU.Cd_Pes
--		join Localidade ORG on ORG.cd_local = HOU.cd_org_hem
--		join Localidade DST on DST.cd_local = HOU.cd_dst_hem
--		left join PO_HEM SO on SO.Num_Proc_HEM = HOU.Num_Proc_HEM and SO.ID_DC='3'
--		join Pessoa_LLP PL on PL.cd_pes = HOU.cd_export_hem
--		Join Pessoa GR on GR.Cd_Pes = PL.Cd_Pes_Grupo
--		join Grupo GP on GP.Cd_Pes_Grupo = GR.Cd_Pes
--		join msdb.dbo.Alerta_Email AE on AE.Grupo COLLATE Latin1_General_CI_AI = GP.Grupo and AE.Nome_Alerta = 'SHIPMENT CONFIRMATION' 
--		left join Alerta_Email_Historico AEH on AEH.Id_Alerta_Email = AE.ID and AEH.Num_Proc = HOU.Num_Proc_HEM
--	where
--		AEH.Num_Proc IS NULL and (LLP.ATD_LEM between (getdate()-5) and (getdate()-4))
----		AEH.Num_Proc = 'EMOXT20101218601'



GO
