SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from TEMP_ResuladoJob where consolidada='EABHZ200804001'
CREATE Procedure [dbo].[spInsTempResultado]--  'EABHZ200804001'
 @Job Varchar(16)
 
 as

Delete TEMP_ResuladoJob where consolidada=@Job
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


Declare @Resultado Table
	(
	
		Num_Proc			Varchar(16),
		cd_tp_tx			Varchar(3),
		Nome_Taxa			Varchar(50),
		Moeda				Char(3),
		Vlr_Moeda_Forte		Decimal(10,2),
		DC					Char(1),
		Valor_NF			Decimal(10,2),
		Valor_Caixa			Decimal(10,2),
		Valor_BDPCharges	Decimal(10,2),
		Valor_Contabil		Decimal(10,2),
		Num_NF				Varchar(19),
		Tipo				Varchar(10)
		
	
	
	)
insert @Resultado (num_proc,cd_Tp_tx,nome_taxa,Moeda,Vlr_moeda_Forte,dc,Valor_NF,Valor_Caixa,Valor_BDPCharges,Num_NF,Tipo)

select CTA.num_proc_hia,  cta.cd_Tp_Tx,nome_tp_tx,cta.cd_Tp_moeda, cta.vlr_org_hia, cta.dc_hia, Cta.vlr_pgto_nf_hia, cxa.vlr_pgto_Rcto_hia, cta.vlr_org_hia*[dbo].[FConverterMoeda](CTA.cd_tp_moeda,'REL') CTA,Nota_Fiscal,'CTA' from vwcta_Cte CTA with(nolock)
Left Join vwcxas CXA with(nolock) on CTA.num_proc_hia=CXA.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_Tx and CTA.dc_hia=cxa.dc_hia
Left Join vwcta_cte CTO with(nolock) on cta.vlr_org_hia=cto.vlr_org_hia and CTa.num_proc_hia=cto.num_proc_hia and Cta.cd_tp_tx=cto.cd_tp_tx and cta.dc_hia <> cto.dc_hia and cto.desp_org_hia='N'
Join Tipo_Taxa TT with(nolock) on tt.cd_tp_Tx=cta.cd_Tp_Tx 
Join @Table T on T.num_proc=cta.num_proc_hia
Left Join Base_Nota_Fiscal NF with(nolock) on NF.nota_fiscal=cta.num_nf_hia and nf.ref_acesso=cta.ref_acesso_nf_hia

Where  cto.num_proc_hia is null and cta.desp_org_hia='N'
	
Union All

select CTA.num_proc_hia,  cta.cd_Tp_Tx, nome_tp_tx,cta.cd_Tp_moeda, cta.vlr_org_hia, cta.dc_hia, Cta.vlr_pgto_nf_hia, 0 , cta.vlr_org_hia*[dbo].[FConverterMoeda](CTA.cd_tp_moeda,'REL') CTA,Nota_Fiscal,'CTO' from vwcta_Cte CTA with(nolock)
Left Join vwcxas CXA with(nolock) on CTA.num_proc_hia=CXA.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_Tx and CTA.dc_hia=cxa.dc_hia
Left Join vwcta_cte CTO with(nolock) on cta.vlr_org_hia=cto.vlr_org_hia and CTa.num_proc_hia=cto.num_proc_hia and Cta.cd_tp_tx=cto.cd_tp_tx and cta.dc_hia <> cto.dc_hia and cto.desp_org_hia='N'
Join Tipo_Taxa TT with(nolock) on tt.cd_tp_Tx=cta.cd_Tp_Tx 
Join @Table T on T.num_proc=cta.num_proc_hia
Left Join Base_Nota_Fiscal NF with(nolock) on NF.nota_fiscal=cta.num_nf_hia and nf.ref_acesso=cta.ref_acesso_nf_hia
Where cto.num_proc_hia is NOT null
and cta.desp_org_hia='N'

Union All

select CTA.num_proc_hia,  cta.cd_Tp_Tx, nome_tp_tx,cta.cd_Tp_moeda, cta.vlr_org_hia, cta.dc_hia, Cta.vlr_pgto_nf_hia, 0 , cta.vlr_org_hia*[dbo].[FConverterMoeda](CTA.cd_tp_moeda,'REL') CTA,Nota_Fiscal,'N' from vwcta_Cte CTA with(nolock)
Left Join vwcxas CXA with(nolock) on CTA.num_proc_hia=CXA.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_Tx and CTA.dc_hia=cxa.dc_hia
--Left Join vwcta_cte CTO with(nolock)on cta.vlr_org_hia=cto.vlr_org_hia and CTa.num_proc_hia=cto.num_proc_hia and Cta.cd_tp_tx=cto.cd_tp_tx and cta.dc_hia <> cto.dc_hia
Join Tipo_Taxa TT with(nolock) on tt.cd_tp_Tx=cta.cd_Tp_Tx 
Join @Table T on T.num_proc=cta.num_proc_hia
Left Join Base_Nota_Fiscal NF with(nolock) on NF.nota_fiscal=cta.num_nf_hia and nf.ref_acesso=cta.ref_acesso_nf_hia
Where emissao is not null
and cta.desp_org_hia='S'

Union All 

select Num_PRoc,RFI.cd_Tp_Tx,Nome_TP_Tx,cd_tp_moeda,Valor_Total,DC,isnull(rfi.valor_Total_Moeda_Local,Valor_Total),0,Isnull(rfi.valor_Total_Moeda_Local,Valor_Total),rf.Num_Registro,'R' from registro_financeiro RF
Join registro_financeiro_item RFI on RFI.mes=RF.mes and RFI.ano=RF.ano and rf.num_registro=rfi.num_registro
Join Tipo_Taxa TT on TT.cd_tp_Tx=RFI.cd_tp_TX
Where num_proc=@JOB and ativo='1' 

Update @Resultado set Valor_Contabil=Valor_NF
where Valor_NF is not null and Valor_NF >0
and num_nf is not null


Update @Resultado set Valor_Contabil=Valor_Caixa
where Valor_Caixa is not null and Valor_Caixa >0
and Valor_Contabil is null

Update @Resultado set Valor_Contabil=Valor_BDPCharges
where Valor_BDPCharges is not null and Valor_BDPCharges >0
and Valor_Contabil is null

insert TEMP_ResuladoJob
select @JOb Job,Num_Proc,nome_taxa,cd_Tp_tx,moeda,vlr_Moeda_Forte,dc,dbo.valor(Isnull(Valor_NF,0),dc) Valor_NF,Valor_Caixa,Valor_BDPCharges,dbo.valor(valor_contabil,dc) Valor_Contabil,num_nf,Tipo,null from @Resultado
--TEMP_ResuladoJob
Update TEmp_Resultado set Em_Aberto=dbo.spVerificaItensEmAberto_Sel(@Job)
where consolidada=@Job



GO
