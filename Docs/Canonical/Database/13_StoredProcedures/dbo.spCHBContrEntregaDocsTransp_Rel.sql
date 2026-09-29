SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spCHBContrEntregaDocsTransp_Rel]--'IACSR201202018BR'
(
	@Processo	varchar(16)
)
As

if left(@Processo,2) = 'IM'
	Begin
		Select
			TRANS.Apelido			Transportadora,
			Consig.Apelido			Cliente,
			PO.Numero_PO_HIM		PO,
			DI.Numero_PO_HIM		DI,
			TERM.Nome_Terminal		Local
		from
			House_Imp_Mar			HOU		With(nolock)
			Left Join LLP_Imp_Mar	LLP		With(nolock) on HOU.Num_Proc_HIM = LLP.Num_Proc_LIM
			Left Join Pessoa		Consig	With(nolock) on HOU.Cd_Consig_HIM = Consig.Cd_Pes
			Left Join PO_HIM		DI		With(nolock) on DI.Num_Proc_HIM = HOU.Num_proc_HIM and DI.ID_DC='5'
			Left Join PO_HIM		PO		With(nolock) on PO.Num_Proc_HIM = HOU.Num_proc_HIM and PO.ID_DC='1'
			Left Join Terminal		TERM	With(nolock) on TERM.cd_terminal = LLP.cd_terminal
			Left Join Pessoa		TRANS	With(nolock) on TRANS.cd_pes = LLP.cd_transportadora
		where 
			HOU.Num_Proc_HIM = @Processo

	UNION

		Select
			TRANS.Apelido			Transportadora,
			Consig.Apelido			Cliente,
			PO.Numero_PO			PO,
			DI.Numero_PO			DI,
			TERM.Nome_Terminal		Local
		from
			Master_Imp_Mar			MAS		With(nolock)
			Left Join LLP_Master	LLP		With(nolock) on LLP.Num_Proc_Master = @Processo
			Left Join Pessoa		Consig	With(nolock) on Consig.Cd_Pes = MAS.Cd_Consig_MIM
			Left Join PO_Master		DI		With(nolock) on DI.Num_Proc_Master = @Processo and DI.ID_DC='5'
			Left Join PO_Master		PO		With(nolock) on PO.Num_Proc_Master = @Processo and DI.ID_DC='1'
			Left Join Campo_Processo TE		With(nolock) on TE.Num_Proc = @Processo and TE.ID_Campo = '33'
			Left Join Campo_Processo TR		With(nolock) on TR.Num_Proc = @Processo and TR.ID_Campo = '34'
			Left Join Terminal		TERM	With(nolock) on TERM.cd_terminal = TE.Campo_Dados
			Left Join Pessoa		TRANS	With(nolock) on TRANS.cd_pes = TR.Campo_Dados
		where 
			MAS.Num_Proc_MIM = @Processo
	END
else
	Begin
		Select
			TRANS.Apelido			Transportadora,
			Consig.Apelido			Cliente,
			PO.Numero_PO_HIA		PO,
			DI.Numero_PO_HIA		DI,
			LO.nome_local			Local
		from
			House_Imp_Aer			HOU		With(nolock)
			Left Join LLP_Imp_Aer	LLP		With(nolock) on HOU.Num_Proc_HIA = LLP.Num_Proc_LIA
			Left Join Pessoa		Consig	With(nolock) on HOU.Cd_Consig_HIA = Consig.Cd_Pes
			Left Join PO_HIA		DI		With(nolock) on DI.Num_Proc_HIA = HOU.Num_proc_HIA and DI.ID_DC='5'
			Left Join PO_HIA		PO		With(nolock) on PO.Num_Proc_HIA = HOU.Num_proc_HIA and PO.ID_DC='1'
			left join localidade	LO		With(nolock) on lo.cd_local = hou.cd_dst_hia
			Left Join Pessoa		TRANS	With(nolock) on TRANS.cd_pes = LLP.cd_transportadora
			
		where 
			HOU.Num_Proc_HIA = @Processo

	UNION

		Select
			TRANS.Apelido			Transportadora,
			Consig.Apelido			Cliente,
			PO.Numero_PO			PO,
			DI.Numero_PO			DI,
			LO.nome_local			Local
		from
			Master_Imp_Aer			MAS		With(nolock)
			Left Join LLP_Master	LLP		With(nolock) on LLP.Num_Proc_Master = @Processo
			Left Join Pessoa		Consig	With(nolock) on Consig.Cd_Pes = MAS.Cd_Consig_MIA
			Left Join PO_Master		DI		With(nolock) on DI.Num_Proc_Master = @Processo and DI.ID_DC='5'
			Left Join PO_Master		PO		With(nolock) on PO.Num_Proc_Master = @Processo and DI.ID_DC='1'
			Left Join Campo_Processo TE		With(nolock) on TE.Num_Proc = @Processo and TE.ID_Campo = '33'
			Left Join Campo_Processo TR		With(nolock) on TR.Num_Proc = @Processo and TR.ID_Campo = '34'
			Left Join Terminal		TERM	With(nolock) on TERM.cd_terminal = TE.Campo_Dados
			Left Join Pessoa		TRANS	With(nolock) on TRANS.cd_pes = TR.Campo_Dados
			left join localidade	LO		With(nolock) on lo.cd_local = mas.cd_dst_mia
		where 
			MAS.Num_Proc_MIA = @Processo
	END

GO
