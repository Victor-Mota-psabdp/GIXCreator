SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE            Function spVendas_Receita 
	(
		@DataInicial Datetime,
		@DataFinal Datetime,
		@cdpes varchar(10),
		@org varchar(3),
		@dst VarChar(3),
		@modal VarChar(10)
	)
RETURNS float

Begin
	Declare @Saida Float
	

Set @Saida=isnull((	select  'Resultado'=sum(
		CASE 
			When Par_nf_hia is NULL then (Vlr_Org_hia*Par_moeda)*2
			When cta.cd_Tp_moeda='REL' then vlr_org_hia
			ELSE (Vlr_org_hia*Par_nf_hia)*2
		END
		) 
	from cta_cte_hou_imp_aer CTA
	Join house_imp_aer hou on hou.num_proc_hia=cta.num_proc_hia
	Join Master_imp_aer mas on mas.num_proc_mia=hou.num_proc_mia
	Left Join Paridade par on dt_cheg_mia=dt_par and cta.cd_tp_moeda=par.cd_tp_moeda and cd_tp_par='OFC'
	Join Tipo_Taxa TT on TT.cd_tp_Tx=cta.cd_tp_tx
	Join Base_Nota_fiscal NF on NF.nota_fiscal=num_nf_hia and nf.ref_acesso=ref_acesso_nf_hia
	Where 
		cta.dc_hia='C' and ((pft_aer='S') and  Emissao between @datainicial and @datafinal 
		OR left(hou.num_proc_hia,5)='IAREM'and Emissao between @dataInicial and @dataFinal)
		and cd_import_hia=@cdpes and cd_org_hia=@org and cd_dst_hia=@dst
       	    
	)
,0.00)

Set @Saida=@Saida+ isnull((select  'Resultado'=sum(
		CASE 
			When Par_nf_hea is NULL then (Vlr_Org_hea*Par_moeda)
			ELSE (Vlr_org_hea*Par_nf_hea)
		END
		) 
	from cta_cte_hou_exp_aer CTA
	Join house_exp_aer hou on hou.num_proc_hea=cta.num_proc_hea
	Join Master_exp_aer mas on mas.num_proc_mea=hou.num_proc_mea
	Left Join Paridade par on dt_saida_mea=dt_par and par.cd_tp_moeda=cta.cd_tp_moeda and cd_tp_par='OFC'
	Join Tipo_Taxa TT on TT.cd_tp_Tx=cta.cd_tp_tx
	Join Base_Nota_Fiscal NF on NF.nota_fiscal=num_nf_hea and ref_acesso=ref_acesso_nf_hea
	Where 
		pft_aer='S' and cta.dc_hea='C' and Emissao between @datainicial and @datafinal
		and cd_export_hea=@cdpes and cd_org_hea=@org and cd_dst_hea=@dst
),0.00)

Set @Saida=@Saida+isnull((select  'Resultado'=sum(
		CASE 
			When Par_nf_him is NULL then (Vlr_Org_him*Par_moeda)*2
			ELSE (Vlr_Pgto_NF_HIM)*2
		END
		) 
	from cta_cte_hou_imp_mar CTA
	Join house_imp_mar hou on hou.num_proc_him=cta.num_proc_him
	Join Master_imp_mar mas on mas.num_proc_mim=hou.num_proc_mim
	Join Paridade par on dt_par=dt_atrac_mim and par.cd_tp_moeda=cta.cd_tp_moeda and cd_tp_par='OFC'
	Join Tipo_Taxa TT on TT.cd_tp_Tx=cta.cd_tp_tx
	Join Base_nota_fiscal NF on nf.nota_fiscal=num_nf_him and ref_acesso=ref_acesso_nf_him
	Where 
		pft_mar='S' and cta.dc_him='C' and Emissao between @datainicial and @datafinal
		and cd_import_him=@cdpes and cd_org_him=@org and cd_dst_him=@dst
),0.00)

Set @Saida=@Saida+isnull((select  'Resultado'=sum(
		CASE 
			When Par_nf_hem is NULL then (Vlr_Org_hem*Par_moeda)
			ELSE (Vlr_org_hem*Par_nf_hem)
		END
		) 
	from cta_cte_hou_exp_mar CTA
	Join house_exp_mar hou on hou.num_proc_hem=cta.num_proc_hem
	Join Master_exp_mar mas on mas.num_proc_mem=hou.num_proc_mem
	Join Paridade par on dt_par=dt_saida_mem and par.cd_tp_moeda=cta.cd_tp_moeda and cd_tp_par='OFC'
	Join Base_Nota_Fiscal NF on NF.nota_fiscal=num_nf_hem and ref_acesso=ref_acesso_nf_hem
	Join Tipo_Taxa TT on TT.cd_tp_Tx=cta.cd_tp_tx
	Where 
		pft_mar='S' and cta.dc_hem='C' and convert(datetime,dt_saida_mem,105) between @datainicial and @datafinal
		and cd_export_hem=@cdpes and cd_org_hem=@org and cd_dst_hem=@dst
),0.00)


Return @Saida
END













GO
