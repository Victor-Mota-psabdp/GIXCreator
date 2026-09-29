SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE Procedure	[dbo].[spCHB_FUDescarga_Rel] --'IMCLI200907014'
(
	@Processo	varchar(16)
)

--29/11/2011 - Inclusão de nolock - Anderson Oliveira
As
	select 
		HOU.Num_Proc_HIM			Processo,
		PO.Numero_PO_HIM				PO,
		Consig.Apelido 				Importador,
		TERM.Nome_Terminal			Terminal,
		HOU.Navio_HIM				Navio,	
		isnull(HOU.HAWB_HIM,HOU.MAWB_HIM)	BL,
		LLP.ETA_LIM					ETA,
		LLP.ETD_LIM					ETD,
		ORG.Nome_Local				Origem
	from
		House_Imp_Mar				HOU with (nolock)
		Left Join LLP_Imp_Mar		LLP	with (nolock) on LLP.Num_Proc_LIM = @Processo
		Left Join PO_HIM			PO	with (nolock) on PO.Num_Proc_HIM = @Processo and PO.ID_DC='1'
		Left Join Pessoa		Consig	with (nolock) on HOU.Cd_Consig_HIM = Consig.Cd_Pes
		Left Join Localidade		ORG	with (nolock) on HOU.Cd_Org_Him = ORG.Cd_Local
		Left Join Terminal			TERM with (nolock) on TERM.cd_terminal = LLP.cd_terminal
	where 
		HOU.Num_Proc_HIM = @Processo

UNION All

	select 
		MAS.Num_Proc_MIM			Processo,
		PO.Numero_PO				PO,
		Consig.Apelido 				Importador,
		TERM.Nome_Terminal			Terminal,
		MAS.Navio_MIM				Navio,	
		MAS.MAWB_MIM				BL,
		LLP.ETA_Master				ETA,
		LLP.ETD_Master				ETD,
		ORG.Nome_Local				Origem
	from
		Master_Imp_Mar				MAS with (nolock)
		Left Join LLP_Master		LLP	with (nolock) on LLP.Num_Proc_Master = @Processo
		Left Join PO_Master			PO	with (nolock)on PO.Num_Proc_Master = @Processo and PO.ID_DC='1'
		Left Join Pessoa		Consig	with (nolock) on Consig.Cd_Pes = MAS.Cd_Consig_MIM
		Left Join Localidade		ORG	with (nolock) on MAS.Cd_Org_mim = ORG.Cd_Local
		Left Join Campo_Processo TE		with (nolock) on TE.Num_Proc = @Processo and TE.ID_Campo = '33'
		Left Join Terminal		TERM	with (nolock) on TERM.cd_terminal = TE.Campo_Dados
	where 
		MAS.Num_Proc_MIM = @Processo








GO
