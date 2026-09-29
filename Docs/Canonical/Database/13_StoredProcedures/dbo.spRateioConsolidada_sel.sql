SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spRateioConsolidada_sel]

AS


select distinct NC.cnpj,isnull(NC.cfop,'3101') CFOP,NC.emissao,NC.num_proc,NC.id_nf,NC.cd_cliente,NC.vlr_nf,NC.nota_fiscal from nota_cliente NC with(nolock)
Left Join hOUSE_IMP_MAR HOU with(nolock) ON HOU.NUM_PROC_MIM=HOU.NUM_PROC_MIM
lEFT jOIN nOTA_cLIENTE nhou with(nolock) ON nhou.num_proc=num_proc_him
where Nhou.num_proc is null
and NC.num_proc like 'IMCLI%'


Union all

select distinct NC.cnpj,isnull(NC.cfop,'3101') CFOP,NC.emissao,NC.num_proc,NC.id_nf,NC.cd_cliente,NC.vlr_nf,NC.nota_fiscal from nota_cliente NC with(nolock)
Left Join hOUSE_IMP_AER HOU with(nolock) ON HOU.NUM_PROC_MIA=HOU.NUM_PROC_MIA
lEFT jOIN nOTA_cLIENTE nhou with(nolock) ON nhou.num_proc=num_proc_hiA
where Nhou.num_proc is null
and NC.num_proc like 'IACLI%'
GO
