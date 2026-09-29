SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from msdb.dbo.Alerta_Email where id = 63

--select * from Alerta_Email_Historico 

CREATE procedure [dbo].[spShipmentConfirmationMercosul_Alert]

AS

--select com o atd_lem - hoje menos 3 dias - Só para Paises do Mercosul
	select distinct
		GR.Nome_Raz_Soc Grupo, SO.Numero_PO_HEM [Order], SHIP.Nome_Raz_Soc Shipper, IMP.Nome_Raz_Soc Importer, HOU.Navio_HEM Vessel, ORG.Nome_Local Origem, 
		DST.Nome_Local Destino, convert(char(10),LLP.ETD_LEM,101) ETD, convert(char(10),LLP.ATD_LEM,101) ATD, convert(char(10),LLP.ETA_LEM,101) ETA, HOU.HAWB_HEM BL_Number, COU.Nome_Raz_Soc Courier_Name, LLP.Courier_Number_Lem Courier_Number,
		AE.ResponderPara, 
		--AE.DocAnexos, 
		HOU.Num_Proc_HEM JOB, AE.ID, AE.Destinatarios Email
--		'noreply@bdp.com.br' Email
	from
		House_Exp_Mar HOU
		join LLP_Exp_Mar LLP on LLP.Num_Proc_LEM = HOU.Num_Proc_HEM
		join Pessoa SHIP on SHIP.Cd_pes = HOU.cd_export_hem
		join Pessoa IMP on IMP.cd_pes = HOU.cd_consig_hem
		join Pessoa COU on LLP.Cd_Courier = COU.Cd_Pes
		join Localidade ORG on ORG.cd_local = HOU.cd_org_hem
		join Localidade DST on DST.cd_local = HOU.cd_dst_hem
		left join PO_HEM SO on SO.Num_Proc_HEM = HOU.Num_Proc_HEM and SO.ID_DC='3'
		join Pessoa_LLP PL on PL.cd_pes = HOU.cd_export_hem
		Join Pessoa GR on GR.Cd_Pes = PL.Cd_Pes_Grupo
		join Grupo GP on GP.Cd_Pes_Grupo = GR.Cd_Pes
		--join msdb.dbo.Alerta_Email AE on AE.Grupo COLLATE Latin1_General_CI_AI = GP.Grupo and AE.Nome_Alerta = 'SHIPMENT CONFIRMATION' 
		join dbo.Alerta_Email AE on AE.Grupo COLLATE Latin1_General_CI_AI = GP.Grupo and AE.Nome_Alerta = 'SHIPMENT CONFIRMATION' 
		left join Alerta_Email_Historico AEH on AEH.Id_Alerta_Email = AE.ID and AEH.Num_Proc = HOU.Num_Proc_HEM
	where
		AEH.Num_Proc IS NULL 
		and (LLP.ATD_LEM between (getdate()-4) and (getdate()-3))
		and dst.cd_pais in ('AR','UY','PY')

UNION ALL

--Select com o Atd_lem - hoje menos 4 excluidos - paises do Mercosul
select distinct
		GR.Nome_Raz_Soc Grupo, SO.Numero_PO_HEM [Order], SHIP.Nome_Raz_Soc Shipper, IMP.Nome_Raz_Soc Importer, HOU.Navio_HEM Vessel, ORG.Nome_Local Origem, 
		DST.Nome_Local Destino, convert(char(10),LLP.ETD_LEM,101) ETD, convert(char(10),LLP.ATD_LEM,101) ATD, convert(char(10),LLP.ETA_LEM,101) ETA, HOU.HAWB_HEM BL_Number, COU.Nome_Raz_Soc Courier_Name, LLP.Courier_Number_Lem Courier_Number,
		AE.ResponderPara, 
		--AE.DocAnexos, 
		HOU.Num_Proc_HEM JOB, AE.ID, AE.Destinatarios Email
--		'noreply@bdp.com.br' Email
	from
		House_Exp_Mar HOU
		join LLP_Exp_Mar LLP on LLP.Num_Proc_LEM = HOU.Num_Proc_HEM
		join Pessoa SHIP on SHIP.Cd_pes = HOU.cd_export_hem
		join Pessoa IMP on IMP.cd_pes = HOU.cd_consig_hem
		join Pessoa COU on LLP.Cd_Courier = COU.Cd_Pes
		join Localidade ORG on ORG.cd_local = HOU.cd_org_hem
		join Localidade DST on DST.cd_local = HOU.cd_dst_hem
		left join PO_HEM SO on SO.Num_Proc_HEM = HOU.Num_Proc_HEM and SO.ID_DC='3'
		join Pessoa_LLP PL on PL.cd_pes = HOU.cd_export_hem
		Join Pessoa GR on GR.Cd_Pes = PL.Cd_Pes_Grupo
		join Grupo GP on GP.Cd_Pes_Grupo = GR.Cd_Pes
		--join msdb.dbo.Alerta_Email AE on AE.Grupo COLLATE Latin1_General_CI_AI = GP.Grupo and AE.Nome_Alerta = 'SHIPMENT CONFIRMATION' 
		join dbo.Alerta_Email AE on AE.Grupo COLLATE Latin1_General_CI_AI = GP.Grupo and AE.Nome_Alerta = 'SHIPMENT CONFIRMATION' 
		left join Alerta_Email_Historico AEH on AEH.Id_Alerta_Email = AE.ID and AEH.Num_Proc = HOU.Num_Proc_HEM
	where
		AEH.Num_Proc IS NULL 
		and (LLP.ATD_LEM between (getdate()-5) and (getdate()-4))
		and dst.cd_pais not in ('AR','UY','PY')








GO
