SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from vwcta_cte where num_proc_hia = 'IMATL20100201601'

--spContabilidadeJOB2_Sel 'IMcsr201601010BR','S'
CREATE Procedure [dbo].[spContabilidadeJOB2_Sel]--[dbo].[spContabilidadeJOB2_Sel] 'IMCSR20080611101','N'
	
	@Job varchar(16),
	@tipo char(1)

As 

if len(@Job)<>15
	Begin
		if @tipo = 'N'
	  
			BEGIN
				select 
					Upper(cta.num_proc_hia) JOB,cast(dbo.valor(cast(Isnull(vlr_pgto_nf_hia,cta.vlr_org_hia*[dbo].[FConverterMoeda](CTA.cd_tp_moeda,'REL')) as Decimal(10,2)),dc_hia)as Decimal(10,2)) Valor,cta.dc_hia DC,TT.nome_tp_tx NomeTaxa
				from 
					vwcta_cte CTA
					join tipo_taxa TT on TT.cd_tp_tx = cta.cd_tp_tx					
					Left join Tipo_Taxa_Contabilidade_Impostos TTCI on TTCI.cd_tp_Tx=cta.cd_Tp_TX
				where 
					cta.num_proc_hia = @JOB
					and desp_org_hia='N' and 
					TTCI.cd_tp_Tx is null
			END
		
		else
			BEGIN
				select 
					Upper(cta.num_proc_hia) JOB,cast(dbo.valor(cta.vlr_pgto_nf_hia,dc_hia)as Decimal(10,2)) Valor,cta.dc_hia DC,TT.nome_tp_tx NomeTaxa	
				from 
					vwcta_cte CTA	
					Join Base_Nota_Fiscal NF on NF.Nota_Fiscal=cta.num_nf_hia and NF.ref_acesso=CTA.ref_Acesso_nf_hia
					join tipo_taxa TT on TT.cd_tp_tx = cta.cd_tp_tx
				where 
					cta.num_proc_hia = @JOB and cta.num_nf_hia is not null

				
				Union All
				
				Select 
					Upper(Num_Proc),cast(dbo.valor(isnull(rfi.valor_total_moeda_local,rfi.valor_Total),dc)as Decimal(10,2)),rfi.dc,TT.Nome_tp_Tx  
				from 
					registro_financeiro RF
					Join Registro_Financeiro_ITem RFI on RFI.mes=RF.mes and rfi.ano=rf.ano   and RF.Num_Registro = RFI.Num_Registro
					Join Tipo_Taxa TT on TT.cd_tp_Tx=RFI.cd_tp_Tx
				Where	
					num_proc=@Job
					and ativo='1'	
				
				Union All
				
				Select 
					Upper(Num_Proc),cast(Valor*-1 as Decimal(10,2)),'D',left(Descricao,50) 
				From 
					Custo_Contabilidade
				Where 
					Num_Proc=@Job
				
				
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
				select num_proc_him from house_imp_mar where num_proc_mim=@Job
			End			
		if left(@Job,2)='EM'
			Begin			
				Insert @table		
				select num_proc_hem from house_exp_mar where num_proc_mem=@Job
			End
		if left(@Job,2)='IA'
			Begin			
				Insert @table		
				select num_proc_hia from house_imp_aer where num_proc_mia=@Job
			End
		if left(@Job,2)='EA'
			Begin			
				Insert @table		
				select num_proc_hea from house_exp_aer where num_proc_mea=@Job
			End
			
		if @tipo = 'N'
	  
			BEGIN
				select 
						Upper(cta.num_proc_hia) JOB,dbo.valor(cast(Isnull(vlr_pgto_nf_hia,cta.vlr_org_hia*[dbo].[FConverterMoeda](CTA.cd_tp_moeda,'REL')) as Decimal(10,2)),dc_hia) Valor,cta.dc_hia DC,TT.nome_tp_tx NomeTaxa
				from 
					vwcta_cte CTA
					join tipo_taxa TT on TT.cd_tp_tx = cta.cd_tp_tx					
					Join @Table T on T.num_proc=cta.num_proc_hia
					Left join Tipo_Taxa_Contabilidade_Impostos TTCI on TTCI.cd_tp_Tx=cta.cd_Tp_TX
				where 
					TTCI.cd_tp_Tx is null and
					desp_org_hia='N'
			END
		
		else
			BEGIN
				select 
					Upper(cta.num_proc_hia) JOB,cast(dbo.valor(cta.vlr_pgto_nf_hia,dc_hia) as  Decimal(10,2)) Valor,cta.dc_hia DC,TT.nome_tp_tx NomeTaxa	
				from 
					vwcta_cte CTA	
					Join Base_Nota_Fiscal NF on NF.Nota_Fiscal=cta.num_nf_hia and NF.ref_acesso=CTA.ref_Acesso_nf_hia
					join tipo_taxa TT on TT.cd_tp_tx = cta.cd_tp_tx
					Join @Table T on T.num_proc=cta.num_proc_hia
				where 
					cta.num_nf_hia is not null
				Union all
				
				Select 
					Upper(RFI.Num_Proc),cast(dbo.valor(dc,isnull(rfi.valor_total_moeda_local,rfi.valor_Total))as Decimal(10,2)),rfi.dc,TT.Nome_tp_Tx  
				from 
					registro_financeiro RF
					Join Registro_Financeiro_ITem RFI on RFI.mes=RF.mes and rfi.ano=rf.ano
					Join Tipo_Taxa TT on TT.cd_tp_Tx=RFI.cd_tp_Tx
					Join @Table T on T.num_proc=RFI.num_proc

				
				Union All
				
				Select 
					Upper(C.Num_Proc),Valor*-1,'D',left(Descricao,50) 
				From 
					Custo_Contabilidade C
					Join @Table T on T.num_proc=C.num_proc
				
			END
	End

GO
