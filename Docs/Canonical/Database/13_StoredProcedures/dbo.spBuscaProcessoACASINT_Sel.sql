SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spBuscaProcessoACASINT_Sel]



as

Select num_proc_hea Processo From House_exp_aer HOU with(nolock)
join llp_exp_aer LLP with(nolock) on  LLP.num_proc_lea=hou.num_proc_hea
Left Join Exchange_ACAS E with(nolock) on num_proc_hea=num_proc
Join Localidade DST with(nolock) on DST.cd_local=cd_dst_hea
where
	ETD_LEA >=getdate()-7
	and num_proc is null
	and num_proc_mea <>'JOB'
	and cd_pais='US'
	
	


GO
