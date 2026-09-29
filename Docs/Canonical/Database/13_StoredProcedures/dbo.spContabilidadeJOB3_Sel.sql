SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select top 1 * from Base_Nota_Fiscal

--[spContabilidadeJOB2Valor_Sel] 'IMFMC20100100101','S'
--[spContabilidadeJOB3_Sel]'Grupo FMC','2010-01-01','2011-11-22'

CREATE Procedure [dbo].[spContabilidadeJOB3_Sel]

		@Grupo			Varchar(50),
		@DataInicial	Datetime,
		@DataFinal		Datetime	
	
As
	Declare @Cd_Grupo as varchar(10)
	Set @Cd_Grupo = (select top 1 Cd_Pes from pessoa where apelido=@Grupo)

	Select 
		CTA.num_proc_hia Job, sum(dbo.valor(cxa.vlr_pgto_rcto_hia,cxa.dc_hia)) ValorCaixa,
		sum(dbo.valor(cta.vlr_pgto_nf_hia,cta.dc_hia)) ValorNF, sum(dbo.valor(cxa.vlr_pgto_rcto_hia,cxa.dc_hia)) - sum(dbo.valor(cta.vlr_pgto_nf_hia,cta.dc_hia)) Diferença
	From
		vwcta_cte CTA
		Left join vwcxas as cxa on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
		Join House_Imp_MAr hou on hou.num_proc_him=cta.num_proc_hia
		Join Pessoa_LLP PPL on PPL.cd_pes=HOU.Cd_Consig_Him and PPL.Cd_Pes_Grupo=@Cd_Grupo		
--		Join Base_Nota_Fiscal NF on NF.Nota_Fiscal=cta.num_nf_hia and NF.ref_acesso=CTA.ref_Acesso_nf_hia
	Where		
		convert(datetime,Dt_Emis_HIm,105) between @DataInicial and @DataFinal			
	Group by 
		CTA.num_proc_hia 
	Having
		sum(vlr_org_hia)=sum(vlr_ref_hia)

UNION ALL

	Select 
		CTA.num_proc_hia Job,sum(dbo.valor(cxa.vlr_pgto_rcto_hia,cxa.dc_hia)) ValorCaixa,
		sum(dbo.valor(cta.vlr_pgto_nf_hia,cta.dc_hia)) ValorNF,sum(dbo.valor(cxa.vlr_pgto_rcto_hia,cxa.dc_hia)) - sum(dbo.valor(cta.vlr_pgto_nf_hia,cta.dc_hia)) Diferença
	From	
		vwcta_cte CTA
		Left join vwcxas as cxa on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
		Join House_Imp_aer hou on hou.num_proc_hia=cta.num_proc_hia
		Join Pessoa_LLP PPL on PPL.cd_pes=HOU.Cd_Consig_Hia and PPL.Cd_Pes_Grupo=@Cd_Grupo		
	Where		
		convert(datetime,Dt_Emis_HIa,105) between @DataInicial and @DataFinal			
	Group by 
		CTA.num_proc_hia 
	Having
		sum(vlr_org_hia)=sum(vlr_ref_hia)

UNION ALL

	Select 
		CTA.num_proc_hia Job,sum(dbo.valor(cxa.vlr_pgto_rcto_hia,cxa.dc_hia)) ValorCaixa,
		sum(dbo.valor(cta.vlr_pgto_nf_hia,cta.dc_hia)) ValorNF,sum(dbo.valor(cxa.vlr_pgto_rcto_hia,cxa.dc_hia)) - sum(dbo.valor(cta.vlr_pgto_nf_hia,cta.dc_hia)) Diferença
	From	
		vwcta_cte CTA
		Left join vwcxas as cxa on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
		Join House_Imp_out hou on hou.num_proc_hio=cta.num_proc_hia
		Join Pessoa_LLP PPL on PPL.cd_pes=HOU.Cd_Consig_Hio and PPL.Cd_Pes_Grupo=@Cd_Grupo		
	Where		
		convert(datetime,Dt_Emis_HIo,105) between @DataInicial and @DataFinal			
	Group by 
		CTA.num_proc_hia 
	Having
		sum(vlr_org_hia)=sum(vlr_ref_hia)

UNION ALL

	Select 
		CTA.num_proc_hia Job,sum(dbo.valor(cxa.vlr_pgto_rcto_hia,cxa.dc_hia)) ValorCaixa,
		sum(dbo.valor(cta.vlr_pgto_nf_hia,cta.dc_hia)) ValorNF,sum(dbo.valor(cxa.vlr_pgto_rcto_hia,cxa.dc_hia)) - sum(dbo.valor(cta.vlr_pgto_nf_hia,cta.dc_hia)) Diferença
	From	
		vwcta_cte CTA
		Left join vwcxas as cxa on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
		Join House_exp_MAr hou on hou.num_proc_hem=cta.num_proc_hia
		Join Pessoa_LLP PPL on PPL.cd_pes=HOU.Cd_export_hem and PPL.Cd_Pes_Grupo=@Cd_Grupo		
	Where		
		convert(datetime,Dt_Emis_Hem,105) between @DataInicial and @DataFinal			
	Group by 
		CTA.num_proc_hia 
	Having
		sum(vlr_org_hia)=sum(vlr_ref_hia)

UNION ALL

	Select 
		CTA.num_proc_hia Job,sum(dbo.valor(cxa.vlr_pgto_rcto_hia,cxa.dc_hia)) ValorCaixa,
		sum(dbo.valor(cta.vlr_pgto_nf_hia,cta.dc_hia)) ValorNF,sum(dbo.valor(cxa.vlr_pgto_rcto_hia,cxa.dc_hia)) - sum(dbo.valor(cta.vlr_pgto_nf_hia,cta.dc_hia)) Diferença
	From	
		vwcta_cte CTA
		Left join vwcxas as cxa on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
		Join House_EXP_AER hou on hou.num_proc_hea=cta.num_proc_hia
		Join Pessoa_LLP PPL on PPL.cd_pes=HOU.Cd_export_hea and PPL.Cd_Pes_Grupo=@Cd_Grupo		
	Where		
		convert(datetime,Dt_Emis_Hea,105) between @DataInicial and @DataFinal			
	Group by 
		CTA.num_proc_hia 
	Having
		sum(vlr_org_hia)=sum(vlr_ref_hia)

UNION ALL

	Select 
		CTA.num_proc_hia Job,sum(dbo.valor(cxa.vlr_pgto_rcto_hia,cxa.dc_hia)) ValorCaixa,
		sum(dbo.valor(cta.vlr_pgto_nf_hia,cta.dc_hia)) ValorNF,sum(dbo.valor(cxa.vlr_pgto_rcto_hia,cxa.dc_hia)) - sum(dbo.valor(cta.vlr_pgto_nf_hia,cta.dc_hia)) Diferença
	From	
		vwcta_cte CTA
		Left join vwcxas as cxa on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
		Join House_EXP_OUT hou on hou.num_proc_heo=cta.num_proc_hia
		Join Pessoa_LLP PPL on PPL.cd_pes=HOU.Cd_export_heo and PPL.Cd_Pes_Grupo=@Cd_Grupo		
	Where		
		convert(datetime,Dt_Emis_Heo,105) between @DataInicial and @DataFinal			
	Group by 
		CTA.num_proc_hia 
	Having
		sum(vlr_org_hia)=sum(vlr_ref_hia)


GO
