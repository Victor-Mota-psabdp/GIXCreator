SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spCHB_DesistVistAduaneira] --'IMCSR20090504701','Claudio Alves'
(
	@Processo	varchar(16),
	@Usuario	varchar(30)
)
As
	Select
		TERM.Nome_Terminal	,
		HOU.HAWB_HIM		BL,
		HOU.Dt_Emis_HIM		Emissao,
		ORG.Nome_Local		Porto_Origem,
		HOU.Navio_HIM		Navio,
		LLP.ETA_LIM			ETA,
		dbo.fBusca_DescrContainers(HOU.Num_Proc_HIM) Containers,
		Consig.Nome_Raz_Soc	Importador,
		PO.Numero_PO_HIM	PO,
		CE.Numero_PO_HIM	CE_Mercante,
		USU.Email			E_Mail

	from
		House_Imp_Mar			HOU
		Left Join LLP_Imp_Mar	LLP		on HOU.Num_Proc_HIM = LLP.Num_Proc_LIM
		Left Join Pessoa		Consig	on HOU.Cd_Consig_HIM = Consig.Cd_Pes
		Left Join Localidade	ORG		on HOU.Cd_Org_Him = ORG.Cd_Local
		Left Join Terminal		TERM	on TERM.cd_terminal = LLP.cd_terminal
		Left Join PO_HIM		CE		on CE.Num_Proc_HIM = HOU.Num_proc_HIM and CE.ID_DC='29'
		Left Join PO_HIM		PO		on PO.Num_Proc_HIM = HOU.Num_proc_HIM and PO.ID_DC='1'
		Left Join Usuario		USU		on USU.Nome_Usuario = @Usuario
	where 
		HOU.Num_Proc_HIM = @Processo

--MASTER----------------------------------
UNION

	Select
		TERM.Nome_Terminal	,
		MAS.MAWB_MIM		BL,
		MAS.Dt_Emis_MIM		Emissao,
		ORG.Nome_Local		Porto_Origem,
		MAS.Navio_MIM		Navio,
		LLP.ETA_Master		ETA,
		dbo.fBusca_DescrContainers(@Processo) Containers,
		Consig.Nome_Raz_Soc	Importador,
		PO.Numero_PO		PO,
		CE.Numero_PO		CE_Mercante,
		USU.Email			E_Mail
	from
		Master_Imp_Mar			MAS
		Left Join LLP_Master	LLP		on LLP.Num_Proc_Master = @Processo
		Left Join Pessoa		Consig	on MAS.Cd_Consig_MIM = Consig.Cd_Pes
		Left Join Localidade	ORG		on MAS.Cd_Org_Mim = ORG.Cd_Local
		Left Join Campo_Processo CP		on CP.Num_Proc = @Processo and CP.ID_Campo = '33'
		Left Join Terminal		TERM	on TERM.cd_terminal = CP.Campo_Dados
		Left Join PO_Master		CE		on CE.Num_Proc_Master = @Processo and CE.ID_DC='29'
		Left Join PO_Master		PO		on PO.Num_Proc_Master = @Processo and PO.ID_DC='1'
		Left Join Usuario		USU		on USU.Nome_Usuario = @Usuario
	where 
		MAS.Num_Proc_MIM = @Processo

GO
