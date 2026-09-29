SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO













CREATE    function spResultadoDT
			(
				@processo Char(16),
				@DataFinal Char(10), 
				@Tx Char(3), 
				@DC Char(2)
			)
	Returns

	Float
as
	Begin
		Declare @Reais as Float
		Declare @Caixa as Float
		Declare @Cta as float				
				
		Set @Reais= Isnull((
				select 	
					vlr_org_hea 
				from 
					cta_cte_hou_exp_aer 
				Where 
					num_proc_hea=@processo and
					cd_tp_Tx=@TX and
					dc_hea=@DC
					and cd_tp_moeda='REL'
				),0)					
		Set @Caixa= Isnull((
				Select
					vlr_pgto_rcto_hea
				From
					CaixA_hou_exp_Aer CXA
					Join Cta_ctE_hou_exp_Aer CTA on CTA.num_proc_hea=cxa.num_proc_hea and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hea=cxa.dc_hea
				Where 
					cxa.num_proc_hea=@processo and
					cxa.cd_tp_Tx=@tx and
					cxa.dc_hea=@dc and
					convert(datetime,dt_pgto_rcto_hea,105)<=@DataFinal
					and num_lcto <> 'PROVISÓRIO'
					and cd_tp_moeda <> 'REL'
					),0)
		Set @Cta=
				Isnull((
				Select
					Vlr_org_hea*dbo.prd_moeda('EA',cta.cd_tp_moeda,dt_ins_hea)
				from
					cta_ctE_hou_exp_aer CTA
					left Join Caixa_hou_exp_aer CXA on CTa.num_proc_hea=cxa.num_proc_hea and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hea=cxa.dc_hea and convert(datetime,dt_pgto_rcto_hea,105)<=@DataFinal and num_lcto <> 'PROVISÓRIO'
					--left join paridade par on cta.cd_tp_moeda=par.cd_tp_moeda and converT(datetime,par.dt_par,105)=convert(datetime,cta.dt_ins_hea,105) and par.cd_tp_par='EXA' 								
					--left join paridade OFC on cta.cd_tp_moeda=OFC.cd_tp_moeda and converT(datetime,OFC.dt_par,105)=convert(datetime,cta.dt_ins_hea,105) and par.cd_tp_par='OFC' 								
				Where
					cxa.num_proc_hea is null and 
					cta.num_proc_hea=@processo and
					cta.cd_tp_Tx=@TX and
					cta.dc_hea=@DC
					and cta.cd_tp_moeda<>'REL'
				),0)									

	return (@Caixa+@Cta+@Reais)
END












GO
