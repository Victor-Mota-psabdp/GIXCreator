SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spPgtoRctoV2_Sel]
	@Num_Lcto varchar(12)
as
	Select PR.num_lcto txtNumLcto, 1 chkTest,
		PR.Dt_Pgto_Rcto txtDtPgRc, PR.DC cmbDC, isnull(CC.Titular,'') cmbTitular, isnull(CD.Apelido,'') cmbNamePes, isnull(PR.Num_Doc,'') txtNumDoc, isnull(PR.Forma_Pgto_Rcto,'') cmbForma, PR.Vlr_Doc txtVlrDoc, 'Balanço???' txtBalance, PR.Dt_Vcto txtDtVcto, isnull(CU.nome_centro_custo,'') cmbCentroCusto, isnull(BT.Nome_Banco,'') cmbBancoTerceros
	From 
		PGTO_RCTO PR with(nolock)
		left join Cta_Cte CC with(nolock) on PR.Num_Cta_Cte = CC.Num_Cta_Cte AND PR.CD_Banco = CC.CD_Banco AND PR.CD_Agencia = CC.CD_Agencia
		left join Pessoa CD with(nolock) on PR.Cd_Pes = CD.Cd_Pes
		left join Centro_Custo CU with(nolock) on CU.cd_centro_custo = PR.cd_centro_custo
		left join Banco_Terceros BT with(nolock) on PR.cd_bancoTerceros = BT.cd_banco
	where 
		PR.num_lcto = @Num_Lcto






GO
