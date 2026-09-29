SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_VerificacaoNFxDN_Rel]
(	
	@dtInicial	datetime
--	@dtFinal	datetime
)
AS

	select 
		'DN s/ NF'								[Tipo], 
		F.FatCod								[Ref.:],
		num_proc								[JOB],
		convert(varchar(10),fatdtemissao,105)	[Data Emissão],
		nome_Tp_Tx								[Nome Taxa],
		cta.cd_tp_moeda							[Moeda],
		vlr_org_hia								[Valor]
	From item_fat I with(nolock)
		Join fAtura f with(nolock) on F.fatcod=I.fatcod and fatstatus <> 0
		Join vwcta_Cte cta with(nolock) on num_proc_hia=num_proc and cta.cd_Tp_Tx=i.cd_tp_Tx and dc_hia=dc
		Left Join base_nota_Fiscal NF with(nolock) on nota_fiscal=num_nf_hia and ref_acesso=ref_Acesso_nf_hia
		Join Tipo_taxa T with(nolock) on T.cd_tp_Tx=I.cd_tp_Tx and Repasse_Tx='N'
	Where 
--		fatdtemissao >='07-01-2013'
		fatdtEmissao >= @dtInicial
		and ref_Acesso is null
		and dc='C'

Union all

	select 
		'NF s/ DN'								[Tipo], 
		Nota_Fiscal								[Ref.:],
		num_proc_hia							[JOB],
		convert(varchar(10),emissao,105)		[Data Emissão],
		nome_Tp_Tx								[Taxa],
		cta.cd_tp_moeda							[Moeda],
		vlr_org_hia								[Valor] 
	from vwcta_cte cta with(nolock)
		Left Join base_nota_Fiscal NF with(nolock) on nota_fiscal=num_nf_hia and ref_acesso=ref_Acesso_nf_hia
		Join Tipo_taxa T with(nolock) on T.cd_tp_Tx=cta.cd_tp_Tx and Repasse_Tx='N'
		Left Join item_Fat I with(nolock) on num_proc_hia=num_proc and cta.cd_Tp_Tx=i.cd_tp_Tx and dc_hia=dc
	where 
--		emissao >='06-01-2013'
		emissao >= @dtInicial
		and I.num_proc is null
GO
