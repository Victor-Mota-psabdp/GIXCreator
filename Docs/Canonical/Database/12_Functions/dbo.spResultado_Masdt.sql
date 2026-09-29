SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








--select dbo.spResultado_Masdt('EMSSZ20100200301','02-28-2010')


CREATE   function [dbo].[spResultado_Masdt]
			(@processo Char(16),@Data Char(10))

returns
	float
as
	Begin
		--FLOAT
		Declare @Peso_Mas Float
		Declare @Qty Int
		Declare @Real Float		
		Declare @Caixa Float
		Declare @Cta Float			
		Declare @Num_Master Varchar(14)
		
		SET @PEso_mas=0
		set @Qty=0
		SEt @Real=0
		Set @Caixa=0
		Set @Cta=0
	
--IMPORTAÇÃO AÉREA		
	IF LEFT(@PROCESSO,2)='IA' 
		BEGIN
		set @Num_Master=(select num_proc_mia from house_imp_aer where num_proc_hia=@processo)
		Set @Qty=(
	   		select count(num_proc_hia) from house_imp_aer where num_proc_mia=left(@Num_Master,14)
			)

		if @Qty=0 or @qty is null
			begin
				Set @peso_mas=1
				Set @Qty=1
			end
		else
		   BEGIN
			Set @Peso_mas=(
		  			select sum(peso_bruto_hia) from house_imp_aer where num_proc_mia=left(@Num_Master,14)
					)
			if @peso_mas=0 
				BEGIN
					set @peso_mas=1
				end			
			Set @peso_mas=(
					select peso_bruto_hia from house_imp_aer where num_proc_hia=@processo
					)/@peso_mas		
		   END

	--RATEIO POR PESO		
				Set @Real = IsNull((
						Select sum(dbo.valor(vlr_org_mia,DC_mia)) from cta_cte_mas_imp_aer CTA
						Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
						Where num_proc_mia=left(@num_master,14) and cta.cd_tp_moeda='REL' and
						cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)
						and desp_org_mia='N'
						and Rateio_tx='K'
						and month(convert(datetime,dt_ins_Mia,105))=month(@data) and year(convert(datetime,dt_ins_Mia,105))=year(@Data)	
				),0)*@peso_mas
	--RATEIO POR HOUSE						
				Set @Real = @Real + IsNull((
						Select sum(dbo.valor(vlr_org_mia,DC_mia)) from cta_cte_mas_imp_aer CTA
						Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
						Where num_proc_mia=left(@num_master,14) and cta.cd_tp_moeda='REL' and
						cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)
						and desp_org_mia='N'
						and Rateio_tx<>'K'
						and month(convert(datetime,dt_ins_Mia,105))=month(@data) and year(convert(datetime,dt_ins_Mia,105))=year(@Data)
					),0)/@QTY

	--RATEIO POR PESO
				Set @Caixa=isnull((
						Select sum(dbo.valor(vlr_pgto_rcto_mia,cxa.dc_mia)) from Caixa_mas_imp_Aer CXA
						JOIN Cta_ctE_mas_imp_aer CTA on CTA.num_proc_mia=CXA.num_proc_mia and CTa.cd_tp_Tx=CXA.cd_tp_Tx and CTA.dc_mia=CXA.dc_mia
						Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
						Where cd_tp_moeda <> 'REL' and num_lcto <> 'PROVISÓRIO' and cxa.num_proc_mia=left(@num_master,14)
						and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)	
						and Rateio_tx='K'
						and month(convert(datetime,dt_ins_mia,105))=month(@data) and year(convert(datetime,dt_ins_mia,105))=year(@Data)
					),0)*@peso_mas
	--Rateio por QTY

				Set @Caixa=@Caixa+isnull((
						Select sum(dbo.valor(vlr_pgto_rcto_mia,cxa.dc_mia)) from Caixa_mas_imp_Aer CXA
						JOIN Cta_ctE_mas_imp_aer CTA on CTA.num_proc_mia=CXA.num_proc_mia and CTa.cd_tp_Tx=CXA.cd_tp_Tx and CTA.dc_mia=CXA.dc_mia
						Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
						Where cd_tp_moeda <> 'REL' and num_lcto <> 'PROVISÓRIO' and cxa.num_proc_mia=left(@num_master,14)
						and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)	
						and Rateio_tx<>'K'
						and month(convert(datetime,dt_ins_mia,105))=month(@data) and year(convert(datetime,dt_ins_mia,105))=year(@Data)
					),0)/@QTY


	--RATEIO POR PESO
			Set @Cta= isnull((
				select sum(dbo.valor(vlr_org_mia*isnull(par.par_moeda,ofc.par_moeda),cta.dc_mia)) from cta_ctE_mas_imp_aer CTA
				LEFT JOIN Caixa_mas_imp_aer CXA on CtA.num_proc_mia=CxA.num_proC_mia and cta.cd_tp_tx=CXA.cd_tp_Tx and CTa.dc_mia=CXA.dc_mia and num_lcto <> 'PROVISÓRIO'
				left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,PAR.dt_par,105)=convert(datetime,cta.dt_ins_mia,105) and par.cd_tp_par='IMA'
				Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
				left Join Paridade OFC on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,OFC.dt_par,105)=convert(datetime,cta.dt_ins_mia,105) and OFC.cd_tp_par='OFC'
				Where cxa.num_proc_mia is null and cta.cd_tp_moeda <> 'REL' and desp_org_mia='N'
				and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)					
				and Rateio_tx='K'
				and cta.num_proc_mia=left(@num_master,14)  
				and month(convert(datetime,dt_ins_mia,105))=month(@data) and year(convert(datetime,dt_ins_mia,105))=year(@Data)
			),0)*@Peso_mas

	--RATEIO POR QTY
			Set @Cta= @cta+isnull((
				select sum(dbo.valor(vlr_org_mia*isnull(par.par_moeda,ofc.par_moeda),cta.dc_mia)) from cta_ctE_mas_imp_aer CTA
				LEFT JOIN Caixa_mas_imp_aer CXA on CtA.num_proc_mia=CxA.num_proC_mia and cta.cd_tp_tx=CXA.cd_tp_Tx and CTa.dc_mia=CXA.dc_mia and num_lcto <> 'PROVISÓRIO'
				left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,PAR.dt_par,105)=convert(datetime,cta.dt_ins_mia,105) and par.cd_tp_par='IMA'
				Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
				left Join Paridade OFC on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,OFC.dt_par,105)=convert(datetime,cta.dt_ins_mia,105) and OFC.cd_tp_par='OFC'
				Where cxa.num_proc_mia is null and cta.cd_tp_moeda <> 'REL' and desp_org_mia='N'
				and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)					
				and Rateio_tx<>'K'
				and cta.num_proc_mia=left(@num_master,14)  
				and month(convert(datetime,dt_ins_mia,105))=month(@data) and year(convert(datetime,dt_ins_mia,105))=year(@Data)
			),0)/@Qty

		END
		
--EXPORTAÇÃO AÉREA

	IF LEFT(@PROCESSO,2)='EA' 
		BEGIN

				set @Num_Master=(select num_proc_mea from house_exp_aer where num_proc_hea=@processo)

				Set @Qty=(
			   		select count(num_proc_hea) from house_exp_aer where num_proc_mea=left(@num_master,14)
					)
				if @Qty=0
					begin
						Set @Peso_mas=1
						Set @Qty=1
					end
				ELSE
				    BEGIN
					Set @Peso_mas=(
			  			select sum(peso_tax) from house_exp_aer where num_proc_mea=left(@num_master,14)
						)
				
				if @peso_mas=0 
					BEGIN
						set @peso_mas=1
					end			

					
					Set @peso_mas=(
						select peso_Tax from house_exp_aer where num_proc_hea=@processo
						)/@peso_mas		
				    END
	--RATEIO POR PESO		
				Set @Real = IsNull((
						Select sum(dbo.valor(vlr_org_mea,DC_mea)) from cta_cte_mas_exp_aer CTA
						Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
						Where num_proc_mea=left(@num_master,14) and cta.cd_tp_moeda='REL' and
						cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)
						and desp_dst_mea='N'
						and Rateio_tx='K'
						and month(convert(datetime,dt_ins_mea,105))=month(@data) and year(convert(datetime,dt_ins_mea,105))=year(@Data)
					),0)*@peso_mas
	--RATEIO POR HOUSE						
				Set @Real = @Real + IsNull((
						Select sum(dbo.valor(vlr_org_mea,DC_mea)) from cta_cte_mas_exp_aer CTA
						Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
						Where num_proc_mea=left(@num_master,14) and cta.cd_tp_moeda='REL' and
						cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)
						and desp_dst_mea='N'
						and Rateio_tx<>'K'
						and month(convert(datetime,dt_ins_mea,105))=month(@data) and year(convert(datetime,dt_ins_mea,105))=year(@Data)
					),0)/@QTY

	--RATEIO POR PESO
				Set @Caixa=isnull((
						Select sum(dbo.valor(vlr_pgto_rcto_mea,cxa.dc_mea)) from Caixa_mas_exp_Aer CXA
						JOIN Cta_ctE_mas_exp_aer CTA on CTA.num_proc_mea=CXA.num_proc_mea and CTa.cd_tp_Tx=CXA.cd_tp_Tx and CTA.dc_mea=CXA.dc_mea
						Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
						Where cd_tp_moeda <> 'REL' and num_lcto <> 'PROVISÓRIO' and cxa.num_proc_mea=left(@num_master,14)
						and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)	
						and Rateio_tx='K'
						and month(convert(datetime,dt_ins_mea,105))=month(@data) and year(convert(datetime,dt_ins_mea,105))=year(@Data)
					),0)*@peso_mas
	--Rateio por QTY

				Set @Caixa=@Caixa+isnull((
						Select sum(dbo.valor(vlr_pgto_rcto_mea,cxa.dc_mea)) from Caixa_mas_exp_Aer CXA
						JOIN Cta_ctE_mas_exp_aer CTA on CTA.num_proc_mea=CXA.num_proc_mea and CTa.cd_tp_Tx=CXA.cd_tp_Tx and CTA.dc_mea=CXA.dc_mea
						Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
						Where cd_tp_moeda <> 'REL' and num_lcto <> 'PROVISÓRIO' and cxa.num_proc_mea=left(@num_master,14)
						and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)	
						and Rateio_tx<>'K'
						and month(convert(datetime,dt_ins_mea,105))=month(@data) and year(convert(datetime,dt_ins_mea,105))=year(@Data)
					),0)/@QTY


	--RATEIO POR PESO
			Set @Cta= isnull((
				select sum(dbo.valor(vlr_org_mea*isnull(par.par_moeda,ofc.par_moeda),cta.dc_mea)) from cta_ctE_mas_exp_aer CTA
				LEFT JOIN Caixa_mas_exp_aer CXA on CtA.num_proc_mea=CxA.num_proC_mea and cta.cd_tp_tx=CXA.cd_tp_Tx and CTa.dc_mea=CXA.dc_mea and num_lcto <> 'PROVISÓRIO'
				left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,PAR.dt_par,105)=convert(datetime,cta.dt_ins_mea,105) and par.cd_tp_par='EXA'
				Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
				left Join Paridade OFC on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,OFC.dt_par,105)=convert(datetime,cta.dt_ins_mea,105) and OFC.cd_tp_par='OFC'
				Where cxa.num_proc_mea is null and cta.cd_tp_moeda <> 'REL' and desp_dst_mea='N'
				and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)					
				and Rateio_tx='K'
				and cta.num_proc_mea=left(@num_master,14)  
				and month(convert(datetime,dt_ins_mea,105))=month(@data) and year(convert(datetime,dt_ins_mea,105))=year(@Data)
			),0)*@Peso_mas

	--RATEIO POR QTY
			Set @Cta= @cta+isnull((
				select sum(dbo.valor(vlr_org_mea*isnull(par.par_moeda,ofc.par_moeda),cta.dc_mea)) from cta_ctE_mas_exp_aer CTA
				LEFT JOIN Caixa_mas_exp_aer CXA on CtA.num_proc_mea=CxA.num_proC_mea and cta.cd_tp_tx=CXA.cd_tp_Tx and CTa.dc_mea=CXA.dc_mea and num_lcto <> 'PROVISÓRIO'
				left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,PAR.dt_par,105)=convert(datetime,cta.dt_ins_mea,105) and par.cd_tp_par='EXA'
				Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
				left Join Paridade OFC on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,OFC.dt_par,105)=convert(datetime,cta.dt_ins_mea,105) and OFC.cd_tp_par='OFC'
				Where cxa.num_proc_mea is null and cta.cd_tp_moeda <> 'REL' and desp_dst_mea='N'
				and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)					
				and Rateio_tx<>'K'
				and cta.num_proc_mea=left(@num_master,14)  
				and month(convert(datetime,dt_ins_mea,105))=month(@data) and year(convert(datetime,dt_ins_mea,105))=year(@Data)
			),0)/@Qty
		END

--IMPORTAÇÃO MARITIMA
	IF LEFT(@PROCESSO,2)='IM' 
		BEGIN
		
				Set @Num_Master=(select top 1 num_proc_mim from house_imp_mar where num_proc_him=@processo)
				Set @Qty=(
			   		select count(num_proc_hiM) from house_imp_MAr where num_proc_miM=left(@Num_Master,14)
					)
				if @Qty=0 or @Qty is null or @qty=0
					Begin
						set @peso_mas=1
						Set @qty=1
					End
				else
				   BEGIN
					Set @Peso_mas=(
			  			select sum(peso_BRUTO_hiM) from house_imp_MAr where num_proc_miM=left(@Num_Master,14)
						)
					if @peso_mas=0 or @peso_mas is null 
						BEGIN
							set @peso_mas=1
						end			
				Set @peso_mas=(
						select peso_BRUTO_hiM from house_imp_MAr where num_proc_hiM=@processo
						)/@peso_mas		
				   END
			
		--RATEIO POR PESO		
				Set @Real = IsNull((
						Select sum(dbo.valor(vlr_org_miM,DC_miM)) from cta_cte_mas_imp_MAr CTA
						Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
						Where num_proc_miM=left(@num_master,14) and cta.cd_tp_moeda='REL' and
						cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)
						and desp_org_miM='N'
						and Rateio_tx='K'
						and month(convert(datetime,dt_ins_mim,105))=month(@data) and year(convert(datetime,dt_ins_mim,105))=year(@Data)
					),0)*@peso_mas	
		--RATEIO POR HOUSE						
				Set @Real = @Real + IsNull((
						Select sum(dbo.valor(vlr_org_miM,DC_miM)) from cta_cte_mas_imp_MAR CTA
						Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
						Where num_proc_miM=left(@num_master,14) and cta.cd_tp_moeda='REL' and
						cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)
						and desp_org_miM='N'
						and Rateio_tx<>'K'
						and month(convert(datetime,dt_ins_mim,105))=month(@data) and year(convert(datetime,dt_ins_mim,105))=year(@Data)
					),0)/@QTY

		--RATEIO POR PESO
				Set @Caixa=isnull((
						Select sum(dbo.valor(vlr_pgto_rcto_miM,cxa.dc_miM)) from Caixa_mas_imp_MAR CXA
						JOIN Cta_ctE_mas_imp_MAR CTA on CTA.num_proc_miM=CXA.num_proc_miM and CTa.cd_tp_Tx=CXA.cd_tp_Tx and CTA.dc_miM=CXA.dc_miM
						Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
						Where cd_tp_moeda <> 'REL' and num_lcto <> 'PROVISÓRIO' and cxa.num_proc_miM=left(@num_master,14)
						and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)	
						and Rateio_tx='K'
						and month(convert(datetime,dt_ins_mim,105))=month(@data) and year(convert(datetime,dt_ins_mim,105))=year(@Data)
					),0)*@peso_mas
		--Rateio por QTY

				Set @Caixa=@Caixa+isnull((
						Select sum(dbo.valor(vlr_pgto_rcto_miM,cxa.dc_miM)) from Caixa_mas_imp_MAR CXA
						JOIN Cta_ctE_mas_imp_MAR CTA on CTA.num_proc_miM=CXA.num_proc_miM and CTa.cd_tp_Tx=CXA.cd_tp_Tx and CTA.dc_mIM=CXA.dc_miM
						Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
						Where cd_tp_moeda <> 'REL' and num_lcto <> 'PROVISÓRIO' and cxa.num_proc_miM=left(@num_master,14)
						and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)	
						and Rateio_tx<>'K'
						and month(convert(datetime,dt_ins_mim,105))=month(@data) and year(convert(datetime,dt_ins_mim,105))=year(@Data)
					),0)/@QTY

		--RATEIO POR PESO
				Set @Cta= isnull((
						select sum(dbo.valor(vlr_org_miM*isnull(par.par_moeda,ofc.par_moeda),cta.dc_miM)) from cta_ctE_mas_imp_MAr CTA
						LEFT JOIN Caixa_mas_imp_MAr CXA on CtA.num_proc_miM=CxA.num_proC_miM and cta.cd_tp_tx=CXA.cd_tp_Tx and CTa.dc_miM=CXA.dc_miM and num_lcto <> 'PROVISÓRIO'
						left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,PAR.dt_par,105)=convert(datetime,cta.dt_ins_miM,105) and par.cd_tp_par='IMM'
						Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
						left Join Paridade OFC on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,OFC.dt_par,105)=convert(datetime,cta.dt_ins_miM,105) and OFC.cd_tp_par='OFC'
						Where cxa.num_proc_miM is null and cta.cd_tp_moeda <> 'REL' and desp_org_miM='N'
						and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)					
						and Rateio_tx='K'
						and cta.num_proc_miM=left(@num_master,14)  
						and month(convert(datetime,dt_ins_mim,105))=month(@data) and year(convert(datetime,dt_ins_mim,105))=year(@Data)
					),0)*@Peso_mas

--RATEIO POR QTY
			Set @Cta= @cta+isnull((
				select sum(dbo.valor(vlr_org_miM*isnull(par.par_moeda,ofc.par_moeda),cta.dc_miM)) from cta_ctE_mas_imp_MAR CTA
				LEFT JOIN Caixa_mas_imp_MAR CXA on CtA.num_proc_miM=CxA.num_proC_miM and cta.cd_tp_tx=CXA.cd_tp_Tx and CTa.dc_miM=CXA.dc_miM and num_lcto <> 'PROVISÓRIO'
				left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,PAR.dt_par,105)=convert(datetime,cta.dt_ins_miM,105) and par.cd_tp_par='IMM'
				Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
				left Join Paridade OFC on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,OFC.dt_par,105)=convert(datetime,cta.dt_ins_miM,105) and OFC.cd_tp_par='OFC'
				Where cxa.num_proc_miM is null and cta.cd_tp_moeda <> 'REL' and desp_org_miM='N'
				and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)					
				and Rateio_tx<>'K'
				and cta.num_proc_miM=left(@num_master,14)  
				and month(convert(datetime,dt_ins_mim,105))=month(@data) and year(convert(datetime,dt_ins_mim,105))=year(@Data)
			),0)/@Qty

		END

--EXPORTAÇÃO MARITIMA

	IF LEFT(@PROCESSO,2)='EM' 
		BEGIN
				set @Num_Master=(select num_proc_mem from house_exp_mar where num_proc_Hem=@processo)
				Set @Qty=(
			   		select count(num_proc_hem) from house_exp_mar where num_proc_mem=left(@num_master,14)
					)
				if @Qty=1 or  @Qty=0
					Begin
						Set @peso_mas=1
						Set @Qty=1
					end
				else
				  BEGIN
					Set @Peso_mas=(
			  			select sum(Peso_Bruto_Hem) from house_exp_mar where num_proc_mem=left(@num_master,14)
						)		
						if @peso_mas=0 
						BEGIN
							set @peso_mas=1
						END
						Set @peso_mas=(
						select Peso_Bruto_Hem from house_exp_MAR where num_proc_hem=@processo
						)/@peso_mas		
				  END
				IF @PESO_MAS=0
					BEGIN
						SET @PESO_MAS=1
					END
	--RATEIO POR PESO
						
				Set @Real = IsNull((
						Select sum(dbo.valor(vlr_org_mem,DC_mem)) from cta_cte_mas_exp_MAR CTA
						Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
						Where num_proc_mem=left(@num_master,14) and cta.cd_tp_moeda='REL' and
						cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)
						and desp_dst_mem='N'
						and Rateio_tx='K'
						and month(convert(datetime,dt_ins_mem,105))=month(@data) and year(convert(datetime,dt_ins_mem,105))=year(@Data)
					),0)*@peso_mas
	--RATEIO POR HOUSE						
				
					Set @Real = @Real + IsNull((
						Select sum(dbo.valor(vlr_org_mem,DC_mem)) from cta_cte_mas_exp_MAR CTA
						Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
						Where num_proc_mem=left(@num_master,14) and cta.cd_tp_moeda='REL' and
						cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)
						and desp_dst_meM='N'
						and Rateio_tx<>'K'
						and month(convert(datetime,dt_ins_mem,105))=month(@data) and year(convert(datetime,dt_ins_mem,105))=year(@Data)
					),0)/@QTY
	--RATEIO POR PESO
				Set @Caixa=isnull((
						Select sum(dbo.valor(vlr_pgto_rcto_meM,cxa.dc_meM)) from Caixa_mas_exp_MAR CXA
						JOIN Cta_ctE_mas_exp_MAR CTA on CTA.num_proc_meM=CXA.num_proc_meM and CTa.cd_tp_Tx=CXA.cd_tp_Tx and CTA.dc_meM=CXA.dc_meM
						Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
						Where cd_tp_moeda <> 'REL' and num_lcto <> 'PROVISÓRIO' and cxa.num_proc_meM=left(@num_master,14)
						and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)	
						and Rateio_tx='K'
						and month(convert(datetime,dt_ins_mem,105))=month(@data) and year(convert(datetime,dt_ins_mem,105))=year(@Data)
					),0)*@peso_mas
	--Rateio por QTY

				Set @Caixa=@Caixa+isnull((
						Select sum(dbo.valor(vlr_pgto_rcto_meM,cxa.dc_meM)) from Caixa_mas_exp_MAR CXA
						JOIN Cta_ctE_mas_exp_MAR CTA on CTA.num_proc_meM=CXA.num_proc_meM and CTa.cd_tp_Tx=CXA.cd_tp_Tx and CTA.dc_meM=CXA.dc_meM
						Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
						Where cd_tp_moeda <> 'REL' and num_lcto <> 'PROVISÓRIO' and cxa.num_proc_meM=left(@num_master,14)
						and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)	
						and Rateio_tx<>'K'
						and month(convert(datetime,dt_ins_mem,105))=month(@data) and year(convert(datetime,dt_ins_mem,105))=year(@Data)
					),0)/@QTY


	--RATEIO POR PESO
			Set @Cta= isnull((
				select sum(dbo.valor(vlr_org_meM*isnull(par.par_moeda,ofc.par_moeda),cta.dc_meM)) from cta_ctE_mas_exp_MAR CTA
				LEFT JOIN Caixa_mas_exp_MAR CXA on CtA.num_proc_meM=CxA.num_proC_meM and cta.cd_tp_tx=CXA.cd_tp_Tx and CTa.dc_meM=CXA.dc_meM and num_lcto <> 'PROVISÓRIO'
				left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,PAR.dt_par,105)=convert(datetime,cta.dt_ins_meM,105) and par.cd_tp_par='EXA'
				Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
				left Join Paridade OFC on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,OFC.dt_par,105)=convert(datetime,cta.dt_ins_meM,105) and OFC.cd_tp_par='OFC'
				Where cxa.num_proc_meM is null and cta.cd_tp_moeda <> 'REL' and desp_dst_meM='N'
				and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)					
				and Rateio_tx='K'
				and cta.num_proc_meM=left(@num_master,14)  
				and month(convert(datetime,dt_ins_mem,105))=month(@data) and year(convert(datetime,dt_ins_mem,105))=year(@Data)
			),0)*@Peso_mas

	--RATEIO POR QTY
			Set @Cta= @cta+isnull((
				select sum(dbo.valor(vlr_org_meM*isnull(par.par_moeda,ofc.par_moeda),cta.dc_meM)) from cta_ctE_mas_exp_MAR CTA
				LEFT JOIN Caixa_mas_exp_MAR CXA on CtA.num_proc_meM=CxA.num_proC_meM and cta.cd_tp_tx=CXA.cd_tp_Tx and CTa.dc_meM=CXA.dc_meM and num_lcto <> 'PROVISÓRIO'
				left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,PAR.dt_par,105)=convert(datetime,cta.dt_ins_meM,105) and par.cd_tp_par='EXA'
				Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
				left Join Paridade OFC on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,OFC.dt_par,105)=convert(datetime,cta.dt_ins_meM,105) and OFC.cd_tp_par='OFC'
				Where cxa.num_proc_meM is null and cta.cd_tp_moeda <> 'REL' and desp_dst_meM='N'
				and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)					
				and Rateio_tx<>'K'
				and cta.num_proc_meM=left(@num_master,14)  
				and month(convert(datetime,dt_ins_mem,105))=month(@data) and year(convert(datetime,dt_ins_mem,105))=year(@Data)
			),0)/@Qty
		END





	
		Return
			cast((@real+@Caixa+@Cta) as money)

	END























GO
