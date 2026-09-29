SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--select * from vwcta_cte where num_proc_hia = 'IMATL20100201601'

CREATE Function  [dbo].[spBuscaResultadoFechamento_Sel]--[dbo].[spContabilidadeJOB2_Sel] 'IMATL20100201601','N'
	(
	@Job varchar(16),
	@tipo char(1)
)
Returns Decimal(10,2) As 
Begin
Declare @dcTemp Decimal(10,2)

if len(@Job)=16
	Begin
		if @tipo = 'N'
	  
			BEGIN
				select 
						@dcTemp= Sum(dbo.valor(cast(Isnull(vlr_pgto_nf_hia,cta.vlr_org_hia*[dbo].[FConverterMoeda](CTA.cd_tp_moeda,'REL')) as Decimal(10,2)),dc_hia)) 
				from 
					vwcta_cte CTA
					join tipo_taxa TT with(nolock) on TT.cd_tp_tx = cta.cd_tp_tx					
					
				where 
					cta.num_proc_hia = @JOB
					and desp_org_hia='N'
			END
		
		else
			BEGIN
				select 
					@dcTemp=sum(dbo.valor(cta.vlr_pgto_nf_hia,dc_hia) )
				from 
					vwcta_cte CTA	
					Join Base_Nota_Fiscal NF with(nolock) on NF.Nota_Fiscal=cta.num_nf_hia and NF.ref_acesso=CTA.ref_Acesso_nf_hia
					join tipo_taxa TT with(nolock) on TT.cd_tp_tx = cta.cd_tp_tx
				where cta.num_proc_hia = @JOB and cta.num_nf_hia is not null
			END
	End
Else
	Begin
		Declare @Table Table
			(
				Num_Proc Varchar(16)
				
			)
		insert @table values(@Job)
		

		if left(@Job,2)='IM'
			Begin			
				Insert @table		
				select num_proc_him from house_imp_mar with(nolock) where num_proc_mim=@Job
			End			
		if left(@Job,2)='EM'
			Begin			
				Insert @table		
				select num_proc_hem from house_exp_mar with(nolock) where num_proc_mem=@Job
			End
		if left(@Job,2)='IA'
			Begin			
				Insert @table		
				select num_proc_hia from house_imp_aer with(nolock) where num_proc_mia=@Job
			End
		if left(@Job,2)='EA'
			Begin			
				Insert @table		
				select num_proc_hea from house_exp_aer with(nolock) where num_proc_mea=@Job
			End
			
		if @tipo = 'N'
	  
			BEGIN
				set @dcTemp=
					Isnull((
						select 
							sum(dbo.valor(cast(Isnull(cta.vlr_pgto_nf_hia,cta.vlr_org_hia*[dbo].[FConverterMoeda](CTA.cd_tp_moeda,'REL')) as Decimal(10,2)),cta.dc_hia)) 
						from 
							vwcta_cte CTA
							join tipo_taxa TT with(nolock) on TT.cd_tp_tx = cta.cd_tp_tx					
							Join @Table T on T.num_proc=cta.num_proc_hia
							Left Join vwcta_Cte CTO on CTA.num_proc_hia=CTO.num_proc_hia and cta.cd_tp_tx=CTO.cd_tp_Tx and CTA.dc_hia<>CTO.dc_hia
						where 
							cta.desp_org_hia='N'
							and cto.num_proc_hia is not null
					),0)
				
				Set @dcTemp= @dcTemp+
					(
						
						select 
							sum(dbo.valor(cast(Isnull(cta.vlr_pgto_nf_hia,isnull(cxa.vlr_pgto_Rcto_hia,cta.vlr_org_hia*[dbo].[FConverterMoeda](CTA.cd_tp_moeda,'REL'))) as Decimal(10,2)),cta.dc_hia)) 
						from 
							vwcta_cte CTA
							Left Join vwcxas CXA on CTa.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_Tx and cta.dc_hia=cxa.dc_hia
							join tipo_taxa TT with(nolock) on TT.cd_tp_tx = cta.cd_tp_tx					
							Join @Table T on T.num_proc=cta.num_proc_hia
							Left Join vwcta_Cte CTO on CTA.num_proc_hia=CTO.num_proc_hia and cta.cd_tp_tx=CTO.cd_tp_Tx and CTA.dc_hia<>CTO.dc_hia
						where 
							cta.desp_org_hia='N'
							and cto.num_proc_hia is null
										
					)
								

			END
		
		else
			BEGIN
				select 
					@dcTemp=sum(dbo.valor(cta.vlr_pgto_nf_hia,dc_hia)) 
				from 
					vwcta_cte CTA	
					Join Base_Nota_Fiscal NF with(nolock) on NF.Nota_Fiscal=cta.num_nf_hia and NF.ref_acesso=CTA.ref_Acesso_nf_hia
					join tipo_taxa TT with(nolock) on TT.cd_tp_tx = cta.cd_tp_tx
					Join @Table T on T.num_proc=cta.num_proc_hia
				where 
					cta.num_nf_hia is not null
			END
	End

return @dcTemp

End
GO
