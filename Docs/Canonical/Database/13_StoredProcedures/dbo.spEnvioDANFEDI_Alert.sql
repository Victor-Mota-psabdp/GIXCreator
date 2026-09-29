SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spEnvioDANFEDI_Alert]

AS

	declare @ResponderPara varchar(50)
	declare @DocAnexos varchar(100)
	declare @Destinatarios varchar(500)

	set @ResponderPara = 'rafael.matjas@bdpint.com'
	set @DocAnexos = '5;10'
	set @Destinatarios = 'rafael.matjas@bdpint.com'

	select distinct
		HOU.Num_Proc_HIM JOB, SO.Numero_PO_HIM [Order],CO.Numero_PO_HIM Customer_PO, SHIP.Nome_Raz_Soc Shipper, @ResponderPara ResponderPara, @DocAnexos DocAnexos, @Destinatarios Email
--		'noreply@bdp.com.br' Email
	from
		House_Imp_Mar HOU with(nolock)
		join LLP_imp_Mar LLP with(nolock) on LLP.Num_Proc_LiM = HOU.Num_Proc_HiM
		join Pessoa SHIP with(nolock) on SHIP.Cd_pes = HOU.cd_export_him
		left join PO_HIM SO with(nolock) on SO.Num_Proc_HiM = HOU.Num_Proc_HiM and SO.ID_DC=3
		left join PO_HIM CO with(nolock) on CO.Num_Proc_HiM = HOU.Num_Proc_HiM and CO.ID_DC=9
		join Pessoa_LLP PL with(nolock) on PL.cd_pes = HOU.cd_export_him and PL.cd_pes_grupo = '1'
		left join Alerta_Email_Historico AEH with(nolock) on AEH.Id_Alerta_Email = 63 and AEH.Num_Proc = HOU.Num_Proc_HIM
		--Left Join Hist_Geral HST with(nolock) on HST.hsgprocesso=num_proc_lim and cd_tp_ocor=-2

GO
