SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO















CREATE         function [dbo].[spResultado_Mas]
			(@processo Char(16))

returns
	Float
as
	Begin
		Declare @Peso_Mas Float
		Declare @Qty Int
		Declare @Real Float		
		Declare @Caixa Float
		Declare @Cta Float			
		Declare @Num_Master Varchar(14)
		SET @PEso_mas=0
		set @Qty=1
		SEt @Real=0
		Set @Caixa=0
		Set @Cta=0
		Set @peso_mas=1
--IMPORTAÇÃO AÉREA		
	IF LEFT(@PROCESSO,2)='IA' 
		BEGIN
		Set @num_master=(select top 1 num_proc_mia from house_imp_aer where num_proc_hia = @processo)
		Set @Qty=(
	   		select Isnull(count(num_proc_hia),1) from house_imp_aer where num_proc_mia=left(@num_master,14)
			)

		if @Qty=1 or @qty is null
			Set @peso_mas=1
		
		else
		   BEGIN
			Set @Peso_mas=(
		  			select sum(peso_real_hia) from house_imp_aer where num_proc_mia=left(@num_master,14)
					)
			If @Peso_Mas=0 or @peso_mas is null 
				BEGIN
					SET @Peso_Mas=1
				END
			Set @peso_mas=(
					select peso_real_hia from house_imp_aer where num_proc_hia=@processo
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
					),0)*@peso_mas
	--RATEIO POR HOUSE						
				Set @Real = @Real + IsNull((
						Select sum(dbo.valor(vlr_org_mia,DC_mia)) from cta_cte_mas_imp_aer CTA
						Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
						Where num_proc_mia=left(@num_master,14) and cta.cd_tp_moeda='REL' and
						cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)
						and desp_org_mia='N'
						and Rateio_tx<>'K'
					),0)/@QTY

	--RATEIO POR PESO
				Set @Caixa=isnull((
						Select sum(dbo.valor(vlr_pgto_rcto_mia,cxa.dc_mia)) from Caixa_mas_imp_Aer CXA
						JOIN Cta_ctE_mas_imp_aer CTA on CTA.num_proc_mia=CXA.num_proc_mia and CTa.cd_tp_Tx=CXA.cd_tp_Tx and CTA.dc_mia=CXA.dc_mia
						Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
						Where cd_tp_moeda <> 'REL' and num_lcto <> 'PROVISÓRIO' and cxa.num_proc_mia=left(@num_master,14)
						and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)	
						and Rateio_tx='K'
					),0)*@peso_mas
	--Rateio por QTY

				Set @Caixa=@Caixa+isnull((
						Select sum(dbo.valor(vlr_pgto_rcto_mia,cxa.dc_mia)) from Caixa_mas_imp_Aer CXA
						JOIN Cta_ctE_mas_imp_aer CTA on CTA.num_proc_mia=CXA.num_proc_mia and CTa.cd_tp_Tx=CXA.cd_tp_Tx and CTA.dc_mia=CXA.dc_mia
						Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
						Where cd_tp_moeda <> 'REL' and num_lcto <> 'PROVISÓRIO' and cxa.num_proc_mia=left(@num_master,14)
						and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)	
						and Rateio_tx<>'K'
					),0)/@QTY


	--RATEIO POR PESO
			Set @Cta= isnull((
				select sum(dbo.valor(vlr_org_mia*dbo.fpar_m(dt_ins_mia,cta.cd_tp_moeda,'OFC'),cta.dc_mia)) from cta_ctE_mas_imp_aer CTA
				LEFT JOIN Caixa_mas_imp_aer CXA on CtA.num_proc_mia=CxA.num_proC_mia and cta.cd_tp_tx=CXA.cd_tp_Tx and CTa.dc_mia=CXA.dc_mia and num_lcto <> 'PROVISÓRIO'
				Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
				Where cxa.num_proc_mia is null and cta.cd_tp_moeda <> 'REL' and desp_org_mia='N'
				and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)					
				and Rateio_tx='K'
				and cta.num_proc_mia=left(@num_master,14)  

			),0)*@Peso_mas

	--RATEIO POR QTY
			Set @Cta= @cta+isnull((
				select sum(dbo.valor(vlr_org_mia*dbo.fpar_m(dt_ins_mia,cta.cd_tp_moeda,'OFC'),cta.dc_mia)) from cta_ctE_mas_imp_aer CTA
				LEFT JOIN Caixa_mas_imp_aer CXA on CtA.num_proc_mia=CxA.num_proC_mia and cta.cd_tp_tx=CXA.cd_tp_Tx and CTa.dc_mia=CXA.dc_mia and num_lcto <> 'PROVISÓRIO'
				Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
				Where cxa.num_proc_mia is null and cta.cd_tp_moeda <> 'REL' and desp_org_mia='N'
				and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)					
				and Rateio_tx<>'K'
				and cta.num_proc_mia=left(@num_master,14)  
			),0)/@Qty

		END
		
--EXPORTAÇÃO AÉREA

	IF LEFT(@PROCESSO,2)='EA' 
		BEGIN
				Set @num_master=(select top 1 num_proc_mem from house_exp_mar where num_proc_hem = @processo)


				Set @Qty=(
			   		select count(num_proc_hea) from house_exp_aer where num_proc_mea=left(@num_master,14)
					)
				if @Qty=1 or @qty is null or @qty=0
					Begin
						Set @Peso_mas=1
						Set @Qty=1
					End
				ELSE
				    BEGIN
					Set @Peso_mas=(
			  			select sum(peso_tax) from house_exp_aer where num_proc_mea=left(@num_master,14)
						)
					if @Peso_mas is null or @Peso_mas=0
						BEgin
							set @Peso_mas=1
						ENd
					Set @peso_mas=(
						select peso_Tax from house_exp_aer where num_proc_hea=@processo
						)/@peso_mas		
				    END
	--RATEIO POR PESO		
				Set @Real = IsNull((
						Select sum(dbo.valor(vlr_org_mea,DC_mea)) from cta_cte_mas_exp_aer CTA
						Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
						Where num_proc_mea=left(@processo,14) and cta.cd_tp_moeda='REL' and
						cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)
						and desp_dst_mea='N'
						and Rateio_tx='K'
					),0)*@peso_mas
	--RATEIO POR HOUSE						
				Set @Real = @Real + IsNull((
						Select sum(dbo.valor(vlr_org_mea,DC_mea)) from cta_cte_mas_exp_aer CTA
						Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
						Where num_proc_mea=left(@processo,14) and cta.cd_tp_moeda='REL' and
						cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)
						and desp_dst_mea='N'
						and Rateio_tx<>'K'
					),0)/@QTY

	--RATEIO POR PESO
				Set @Caixa=isnull((
						Select sum(dbo.valor(vlr_pgto_rcto_mea,cxa.dc_mea)) from Caixa_mas_exp_Aer CXA
						JOIN Cta_ctE_mas_exp_aer CTA on CTA.num_proc_mea=CXA.num_proc_mea and CTa.cd_tp_Tx=CXA.cd_tp_Tx and CTA.dc_mea=CXA.dc_mea
						Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
						Where cd_tp_moeda <> 'REL' and num_lcto <> 'PROVISÓRIO' and cxa.num_proc_mea=left(@PROCESSO,14)
						and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)	
						and Rateio_tx='K'
					),0)*@peso_mas
	--Rateio por QTY

				Set @Caixa=@Caixa+isnull((
						Select sum(dbo.valor(vlr_pgto_rcto_mea,cxa.dc_mea)) from Caixa_mas_exp_Aer CXA
						JOIN Cta_ctE_mas_exp_aer CTA on CTA.num_proc_mea=CXA.num_proc_mea and CTa.cd_tp_Tx=CXA.cd_tp_Tx and CTA.dc_mea=CXA.dc_mea
						Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
						Where cd_tp_moeda <> 'REL' and num_lcto <> 'PROVISÓRIO' and cxa.num_proc_mea=left(@PROCESSO,14)
						and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)	
						and Rateio_tx<>'K'
					),0)/@QTY


	--RATEIO POR PESO
			Set @Cta= isnull((
				select sum(dbo.valor(vlr_org_mea*dbo.fpar_m(dt_ins_mea,cta.cd_tp_moeda,'OFC'),cta.dc_mea)) from cta_ctE_mas_exp_aer CTA
				LEFT JOIN Caixa_mas_exp_aer CXA on CtA.num_proc_mea=CxA.num_proC_mea and cta.cd_tp_tx=CXA.cd_tp_Tx and CTa.dc_mea=CXA.dc_mea and num_lcto <> 'PROVISÓRIO'
				Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
				Where cxa.num_proc_mea is null and cta.cd_tp_moeda <> 'REL' and desp_dst_mea='N'
				and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)					
				and Rateio_tx='K'
				and cta.num_proc_mea=left(@processo,14)  
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
				and cta.num_proc_mea=left(@processo,14)  
			),0)/@Qty
		END

--IMPORTAÇÃO MARITIMA
	IF LEFT(@PROCESSO,2)='IM' 
		BEGIN
		
				Set @num_master=(select top 1 num_proc_mim from house_imp_mar where num_proc_him = @processo)

				Set @Qty=(
			   		select count(num_proc_hiM) from house_imp_MAr where num_proc_miM=left(@num_master,14)
					)
				if @Qty=1 or @qty is null or @qty=0
					Begin
						set @peso_mas=1
						set @qty=1
					end
				else
				   BEGIN
						Set @Peso_mas=(
			  				select sum(peso_BRUTO_hiM) from house_imp_MAr where num_proc_miM=left(@num_master,14)
							)

						if @Peso_mas = 0 or @peso_mas is null
							Begin
								Set @Peso_mas = 1
							end
						
						Set @peso_mas=(
							select isnull(peso_BRUTO_hiM,1) from house_imp_MAr where num_proc_hiM=@processo
							)/Isnull(@peso_mas,1)		
					END
				
		--RATEIO POR PESO		
				Set @Real = IsNull((
						Select sum(dbo.valor(vlr_org_miM,DC_miM)) from cta_cte_mas_imp_MAr CTA
						Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
						Where num_proc_miM=left(@num_master,14) and cta.cd_tp_moeda='REL' and
						cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)
						and desp_org_miM='N'
						and Rateio_tx='K'
					),0)*@peso_mas	
		--RATEIO POR HOUSE						
				Set @Real = @Real + IsNull((
						Select sum(dbo.valor(vlr_org_miM,DC_miM)) from cta_cte_mas_imp_MAR CTA
						Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
						Where num_proc_miM=left(@num_master,14) and cta.cd_tp_moeda='REL' and
						cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)
						and desp_org_miM='N'
						and Rateio_tx<>'K'
					),0)/@QTY

		--RATEIO POR PESO
				Set @Caixa=isnull((
						Select sum(dbo.valor(vlr_pgto_rcto_miM,cxa.dc_miM)) from Caixa_mas_imp_MAR CXA
						JOIN Cta_ctE_mas_imp_MAR CTA on CTA.num_proc_miM=CXA.num_proc_miM and CTa.cd_tp_Tx=CXA.cd_tp_Tx and CTA.dc_miM=CXA.dc_miM
						Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
						Where cd_tp_moeda <> 'REL' and num_lcto <> 'PROVISÓRIO' and cxa.num_proc_miM=left(@num_master,14)
						and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)	
						and Rateio_tx='K'
					),0)*@peso_mas
		--Rateio por QTY

				Set @Caixa=@Caixa+isnull((
						Select sum(dbo.valor(vlr_pgto_rcto_miM,cxa.dc_miM)) from Caixa_mas_imp_MAR CXA
						JOIN Cta_ctE_mas_imp_MAR CTA on CTA.num_proc_miM=CXA.num_proc_miM and CTa.cd_tp_Tx=CXA.cd_tp_Tx and CTA.dc_mIM=CXA.dc_miM
						Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
						Where cd_tp_moeda <> 'REL' and num_lcto <> 'PROVISÓRIO' and cxa.num_proc_miM=left(@num_master,14)
						and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)	
						and Rateio_tx<>'K'
					),0)/@QTY

		--RATEIO POR PESO
				Set @Cta= isnull((
						select sum(dbo.valor(vlr_org_miM*dbo.fpar_m(dt_ins_mim,cta.cd_tp_moeda,'OFC'),cta.dc_miM)) from cta_ctE_mas_imp_MAr CTA
						LEFT JOIN Caixa_mas_imp_MAr CXA on CtA.num_proc_miM=CxA.num_proC_miM and cta.cd_tp_tx=CXA.cd_tp_Tx and CTa.dc_miM=CXA.dc_miM and num_lcto <> 'PROVISÓRIO'
						Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
						Where cxa.num_proc_miM is null and cta.cd_tp_moeda <> 'REL' and desp_org_miM='N'
						and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)					
						and Rateio_tx='K'
						and cta.num_proc_miM=left(@num_master,14)  
					),0)*@Peso_mas

--RATEIO POR QTY
			Set @Cta= @cta+isnull((
				select sum(dbo.valor(vlr_org_miM*dbo.fpar_m(dt_ins_mim,cta.cd_tp_moeda,'OFC'),cta.dc_miM)) from cta_ctE_mas_imp_MAR CTA
				LEFT JOIN Caixa_mas_imp_MAR CXA on CtA.num_proc_miM=CxA.num_proC_miM and cta.cd_tp_tx=CXA.cd_tp_Tx and CTa.dc_miM=CXA.dc_miM and num_lcto <> 'PROVISÓRIO'
				Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
				Where cxa.num_proc_miM is null and cta.cd_tp_moeda <> 'REL' and desp_org_miM='N'
				and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)					
				and Rateio_tx<>'K'
				and cta.num_proc_miM=left(@num_master,14)  
			),0)/@Qty

		END

--EXPORTAÇÃO MARITIMA

	IF LEFT(@PROCESSO,2)='EM' 
		BEGIN
				Set @num_master=(select top 1 num_proc_mem from house_exp_mar where num_proc_hem = @processo)
				Set @Qty=(
			   		select count(num_proc_hem) from house_exp_mar where num_proc_mem=left(@num_master,14)
					)
				if @Qty=1 or @qty is null or @qty=0
					Set @peso_mas=1
				else
				  BEGIN
					Set @Peso_mas=(
			  			select Isnull(sum(Peso_Bruto_Hem),1) from house_exp_mar where num_proc_mem=left(@num_master,14)
						)
					if @Peso_mas = 0
						Begin
							Set @Peso_mas = 1
						end
					Set @peso_mas=(
						select Peso_Bruto_Hem from house_exp_MAR where num_proc_hem=@processo
						)/@peso_mas		
				  END
	--RATEIO POR PESO		
				Set @Real = IsNull((
						Select sum(dbo.valor(vlr_org_mem,DC_mem)) from cta_cte_mas_exp_MAR CTA
						Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
						Where num_proc_mem=left(@processo,14) and cta.cd_tp_moeda='REL' and
						cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)
						and desp_dst_mem='N'
						and Rateio_tx='K'
					),0)*@peso_mas
	--RATEIO POR HOUSE						
				Set @Real = @Real + IsNull((
						Select sum(dbo.valor(vlr_org_mem,DC_mem)) from cta_cte_mas_exp_MAR CTA
						Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
						Where num_proc_mem=left(@processo,14) and cta.cd_tp_moeda='REL' and
						cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)
						and desp_dst_meM='N'
						and Rateio_tx<>'K'
					),0)/@QTY

	--RATEIO POR PESO
				Set @Caixa=isnull((
						Select sum(dbo.valor(vlr_pgto_rcto_meM,cxa.dc_meM)) from Caixa_mas_exp_MAR CXA
						JOIN Cta_ctE_mas_exp_MAR CTA on CTA.num_proc_meM=CXA.num_proc_meM and CTa.cd_tp_Tx=CXA.cd_tp_Tx and CTA.dc_meM=CXA.dc_meM
						Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
						Where cd_tp_moeda <> 'REL' and num_lcto <> 'PROVISÓRIO' and cxa.num_proc_meM=left(@PROCESSO,14)
						and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)	
						and Rateio_tx='K'
					),0)*@peso_mas
	--Rateio por QTY

				Set @Caixa=@Caixa+isnull((
						Select sum(dbo.valor(vlr_pgto_rcto_meM,cxa.dc_meM)) from Caixa_mas_exp_MAR CXA
						JOIN Cta_ctE_mas_exp_MAR CTA on CTA.num_proc_meM=CXA.num_proc_meM and CTa.cd_tp_Tx=CXA.cd_tp_Tx and CTA.dc_meM=CXA.dc_meM
						Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
						Where cd_tp_moeda <> 'REL' and num_lcto <> 'PROVISÓRIO' and cxa.num_proc_meM=left(@PROCESSO,14)
						and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)	
						and Rateio_tx<>'K'
					),0)/@QTY


	--RATEIO POR PESO
			Set @Cta= isnull((
				select sum(dbo.valor(vlr_org_meM*dbo.fpar_m(dt_ins_mem,cta.cd_tp_moeda,'OFC'),cta.dc_meM)) from cta_ctE_mas_exp_MAR CTA
				LEFT JOIN Caixa_mas_exp_MAR CXA on CtA.num_proc_meM=CxA.num_proC_meM and cta.cd_tp_tx=CXA.cd_tp_Tx and CTa.dc_meM=CXA.dc_meM and num_lcto <> 'PROVISÓRIO'
				Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
				Where cxa.num_proc_meM is null and cta.cd_tp_moeda <> 'REL' and desp_dst_meM='N'
				and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)					
				and Rateio_tx='K'
				and cta.num_proc_meM=left(@processo,14)  
			),0)*@Peso_mas

	--RATEIO POR QTY
			Set @Cta= @cta+isnull((
				select sum(dbo.valor(vlr_org_meM*dbo.fpar_M(dt_ins_mem,cta.cd_tp_moeda,'OFC'),cta.dc_meM)) from cta_ctE_mas_exp_MAR CTA
				LEFT JOIN Caixa_mas_exp_MAR CXA on CtA.num_proc_meM=CxA.num_proC_meM and cta.cd_tp_tx=CXA.cd_tp_Tx and CTa.dc_meM=CXA.dc_meM and num_lcto <> 'PROVISÓRIO'
				Join Tipo_taxa TT on TT.cd_tp_Tx=Cta.cd_tp_Tx
				Where cxa.num_proc_meM is null and cta.cd_tp_moeda <> 'REL' and desp_dst_meM='N'
				and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)					
				and Rateio_tx<>'K'
				and cta.num_proc_meM=left(@processo,14)  
			),0)/@Qty
		END





	
		Return
			cast((@real+@Caixa+@Cta) as money)

	END






















GO
