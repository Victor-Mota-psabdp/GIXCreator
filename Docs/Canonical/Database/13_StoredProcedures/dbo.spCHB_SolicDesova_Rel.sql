SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spCHB_SolicDesova_Rel]
(
	@Processo	varchar(16)
)
As

--29/11/2011: inclusao Nolock Anderson Oliveira
	Select
		TERM.Nome_Terminal	Terminal,
		TRANS.Apelido		Transportadora,
		dbo.fBusca_DescrContainers(@Processo) Containers,
		HOU.Navio_HIM		Navio,
		HOU.HAWB_HIM		BL,
		ORG.Nome_Local		Porto,
		Consig.Nome_Raz_Soc	Importador,
		DI.Numero_PO_HIM	DI
	from
		House_Imp_Mar			HOU		with(nolock)
		Left Join LLP_Imp_Mar	LLP		with(nolock) on LLP.Num_Proc_LIM = @Processo
		Left Join Pessoa		Consig	with(nolock) on HOU.Cd_Consig_HIM = Consig.Cd_Pes
		Left Join Localidade	ORG		with(nolock) on HOU.Cd_Org_Him = ORG.Cd_Local
		Left Join Terminal		TERM	with(nolock) on TERM.cd_terminal = LLP.cd_terminal
		Left Join PO_HIM		DI		with(nolock) on DI.Num_Proc_HIM = HOU.Num_proc_HIM and ID_DC='5'
		Left Join Pessoa		TRANS	with(nolock) on TRANS.cd_pes = LLP.cd_transportadora
	where 
		HOU.Num_Proc_HIM = @Processo

UNION ALL

	Select
		TERM.Nome_Terminal	Terminal,
		TRANS.Apelido		Transportadora,
		dbo.fBusca_DescrContainers(@Processo) Containers,
		MAS.Navio_MIM		Navio,
		MAS.MAWB_MIM		BL,
		ORG.Nome_Local		Porto,
		Consig.Nome_Raz_Soc	Importador,
		DI.Numero_PO		DI
	from
		Master_Imp_Mar			MAS		with(nolock)
		Left Join LLP_Master	LLP		with(nolock) on LLP.Num_Proc_Master = @Processo
		Left Join Pessoa		Consig	with(nolock) on MAS.Cd_Consig_MIM = Consig.Cd_Pes
		Left Join Localidade	ORG		with(nolock) on MAS.Cd_Org_Mim = ORG.Cd_Local
		Left Join PO_Master		DI		with(nolock) on DI.Num_Proc_Master = @Processo and DI.ID_DC='5'
		Left Join Campo_Processo TE		with(nolock) on TE.Num_Proc = @Processo and TE.ID_Campo = '33'
		Left Join Campo_Processo TR		with(nolock) on TR.Num_Proc = @Processo and TR.ID_Campo = '34'
		Left Join Terminal		TERM	with(nolock) on TERM.cd_terminal = TE.Campo_Dados
		Left Join Pessoa		TRANS	with(nolock) on TRANS.cd_pes = TR.Campo_Dados

	where 
		MAS.Num_Proc_MIM = @Processo





GO
