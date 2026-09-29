SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spMEA_Alterado_Rel]--'EAVCP201803016','',''

		@Processo 	VarChar(14),
		@User		varchar(50),
		@Tipo		char(1)

AS

		Declare @Vlr_Agt_MEA	float
		Declare @Vlr_Crr_MEA 	float
		Declare @Vlr_Tx_Tot_MEA float
		Declare @Vlr_frete		float
		
		Declare @Vlr_AgtPP_MEA	float
		Declare @Vlr_CrrPP_MEA 	float	
		
		Set @Vlr_Agt_MEA=isnull((select sum(vlr_org_MEA)from cta_cte_MAS_exp_aer where num_proc_MEA = @Processo and Comp_MBL_MEA = 'A' and contab_mes_ano = 'C'),0)
		Set @Vlr_Crr_MEA=isnull((select sum(vlr_org_MEA)from cta_cte_MAS_exp_aer where num_proc_MEA = @Processo and Comp_MBL_MEA = 'C' and contab_mes_ano = 'C'),0)
		
		Set @Vlr_AgtPP_MEA=isnull((select sum(vlr_org_mEA)from cta_cte_MAS_exp_aer where Num_Proc_MEA = @Processo and Comp_MBL_MEA = 'A' and contab_mes_ano = 'P'),0)
		Set @Vlr_CrrPP_MEA=isnull((select sum(vlr_org_mEA)from cta_cte_MAS_exp_aer where Num_Proc_MEA = @Processo and Comp_MBL_MEA = 'C' and contab_mes_ano = 'P'),0)
				
		set @Vlr_frete = isnull((select vlr_frete_mea from master_exp_Aer where num_proc_mea = @Processo),0)
		
		Set @Vlr_Tx_Tot_MEA= (@Vlr_Agt_MEA + @Vlr_Crr_MEA + @Vlr_frete)

		Declare @Peso_Cubado decimal(9, 3)
		Declare @Peso_Bruto decimal(9, 3) 
		Set @Peso_Bruto = (select Sum(Peso_Bruto) from vwHouse_exp where Master =@Processo)
		Set @Peso_Cubado = (select Sum(Peso_Cubado) from vwHouse_exp where Master =@Processo)

	
----Antonio 12-11-2024 - LocICS2 verificar a região ------------------------------------------
		declare @LocICS2 bit
        declare @NatureGoods varchar(4000)
        declare @NatureGoodsICS varchar(4000)
	    set @LocICS2 =(select  reg.LocICS2 from vwMaster_Exp_Completo hea with(nolock) 
					   join Localidade loc with(nolock) on loc.Cd_Local = hea.Cd_Dst_Master	 
					   join Regiao reg with(nolock) on reg.Cd_Regiao = loc.Cd_Regiao
						        					 and reg.LocICS2 = 1  
					    where hea.Num_Proc_Master =@Processo		
         		)
        if @LocICS2=1
		   Begin 
				 set @NatureGoodsICS = (select dbo.fBusca_Proc_Ncm_References(@Processo))
				 set @NatureGoods = '|' + (select isnull(Descr,'|')  as [Hand] 
  				 from Nature_Goods with(nolock) where num_proc=@Processo)
                 set @NatureGoods =(select @NatureGoodsICS + ' | ' + isnull(@NatureGoods,''))
		   End 
-----------------------------------------------------------------------------------------------

	
if @Tipo = 'T'
	BEGIN
		select 
			--Shipper
				ABL.txtShipper				Shipper,

				SH.Num_CPF_CNPJ				RUT_Shipper,
		
			--Consignee
				ABL.txtConsignee			Consignee,		

			--Notify
				ABL.txtNotify				Notify,

			--novos campos do hbl alterado
			cmbIssuing,
			txtIssuing,
			txtCarriage,
			txtCustoms,
			txtAmount,
			txtSignatureShipper,
			txtSignatureCarrier,
	
			HOU.Num_Proc_Hea,
			MAWB_HEA, 
			HAWB_HEA,


			MAWB_MEA,	
			--SH.Num_CPF_CNPJ			RUT_Shipper,
			--sh.Nome_raz_soc			Shipper,
			ENDS.RUA				RUA_S, 
			ENDS.Bairro				BAIRRO_S, 
			ENDS.Cidade				CIDADE_S, 
			UPPER(ENDS.Pais)		Pais_S,
	
			cs.Nome_Raz_Soc			Consignee,
			ENDC.RUA				RUA_C, 
			ENDC.Bairro				BAIRRO_C, 
			ENDC.Cidade				CIDADE_C, 
			UPPER(ENDC.Pais)		Pais_C,
			CS.Num_CPF_CNPJ			RUT_C,
	
			AG.Nome_raz_soc			Agente, 
			ENDA.RUA				RUA_A, 
			ENDA.Bairro				BAIRRO_A, 
			ENDA.Cidade				CIDADE_A, 
			UPPER(ENDA.Pais)		Pais_A,
			AG.num_cpf_cnpj			cnpj_A,	
 			( 'FILE: ' + upper(@Processo)) Accounting ,
 	
			--UPPER(LCO.Nome_Local)	Origem, 
			ABL.CmbOrigin		Origem,
			LCO.cd_local		CD_Origem,
	
			CA.Nome_cia_aer			Cia_Aer,
			ABL.cmbCiaAerea Cia_Aer,	
			--UPPER(LCD.cd_local)		CD_Destino,
			UPPER(LCD.IataCODE)		CD_Destino,
			--CA.Cd_cia_aer			CD_CIA_AER,
			ABL.cmbDelivery			Destino,
			upper(lcd.iatacode)		cd_cia_aer,
	
			mea.Voo_mEA				Voo_mea,
			ABL.txtVoo				Voo_mea,
	
			MEA.cd_tp_moeda,
			dbo.fBusca_CampoCliente (@processo, 47) exchangeRate,
			dbo.fBusca_CampoCliente (@processo, 39) ref_accountinginfo,
			--hou.tx_refer_hea		exchangeRate,
			--'0'					exchangeRate,
			tp_frete_mea, 
			--llp.selling_rates_lea	selling_rates,
			'0'						selling_rates,
			--UPPER(LCD.Nome_Local)	Destino,  
			--LLP.ATD_Lea				DATA_SAIDA,
			LLP.ETD_Master				DATA_SAIDA,
			HN.Hand_mEA_1,
			HN.Hand_MEA_2,
			HN.Hand_MEA_3,
			Qtd_Tot_Vol_mea,
			Peso_Bruto_mea			PESO_BRUTO,
			--LLP.Peso_Cubado			PESO_CUBADO, 
			--isnull([dbo].[fBusca_Volumes_M3](HOU.num_proc_hea),LLP.Peso_Cubado) PESO_CUBADO, 
			--(case when isnull([dbo].[fBusca_Volumes_M3](HOU.num_proc_hea),0) > LLP.Peso_Cubado then 
			--	[dbo].[fBusca_Volumes_M3](HOU.num_proc_hea)
			--else
			--	LLP.Peso_Cubado end) PESO_CUBADO,

			--(case when MEA.Peso_Bruto_mea > LLP.Peso_Cubado then 
			--	MEA.Peso_Bruto_mea
			--else
			--	LLP.Peso_Cubado end) PESO_CUBADO,

			(case when @Peso_Bruto	> @Peso_Cubado then 
				@Peso_Bruto
			else
				@Peso_Cubado end) PESO_CUBADO,


			vlr_frete_mea			VALOR_FRETE,
/*
			--NG.Descr				NATURES_GOODS,
			isnull(NG.Descr,'')															+ '|' +
			'INV. # ' + isnull([dbo].[fBusca_Docs_PO_Modal](HOU.num_proc_hea,2),'')		+ '|' +
			'DUE ' +  isnull([dbo].[fBusca_Docs_PO_Modal](HOU.num_proc_hea,204),'')		+ '|' +
			'PO '+ isnull([dbo].[fBusca_Docs_PO_Modal](HOU.num_proc_hea,1),'')	+ '|' +
			isnull([dbo].[fBusca_Volumes_Dimensao](HOU.num_proc_hea),'') NATURES_GOODS,
*/			
			
---------------------Antonio 11-11-2024-----------------------------------------------------------
			(case when @LocICS2=1 then 
			      @NatureGoods															+ '|' +
					'INV. # ' + isnull([dbo].[fBusca_Docs_PO_Modal](HOU.num_proc_hea,2),'')		+ '|' +
					'DUE ' +  isnull([dbo].[fBusca_Docs_PO_Modal](HOU.num_proc_hea,204),'')		+ '|' +
					'PO '+ isnull([dbo].[fBusca_Docs_PO_Modal](HOU.num_proc_hea,1),'')	+ '|' +
					isnull([dbo].[fBusca_Volumes_Dimensao](HOU.num_proc_hea),'')
			 else
					isnull(NG.Descr,'')															+ '|' +
					'INV. # ' + isnull([dbo].[fBusca_Docs_PO_Modal](HOU.num_proc_hea,2),'')		+ '|' +
					'DUE ' +  isnull([dbo].[fBusca_Docs_PO_Modal](HOU.num_proc_hea,204),'')		+ '|' +
					'PO '+ isnull([dbo].[fBusca_Docs_PO_Modal](HOU.num_proc_hea,1),'')	+ '|' +
					isnull([dbo].[fBusca_Volumes_Dimensao](HOU.num_proc_hea),'') 
			 end) NATURES_GOODS,

			(case when @LocICS2=1 then 
			      'EORIConsignee: ' + isnull([dbo].[fBusca_CampoPessoa](CS.cd_pes,28),'') 
			 else
				  '  '
			 end) EORIConsignee,
----------------------------------------------------------------------------------------------------


			left(MEA.MAWB_mEA,3)	COMECO,
			right(MEA.MAWB_mEA,8)	FIM,
			@Vlr_Agt_MEA			Valor_Agente,
			@Vlr_Crr_MEA			Valor_Carrier,
			@Vlr_Tx_Tot_MEA			Total_Taxa,
			dbo.spTaxasMasterEA(@Processo) Taxas,
			dbo.spHouseEA(@Processo)Houses,
			Obs_mea,
			--dbo.fBusca_CampoCliente(MEA.Num_Proc_mea,89) FreteMinimo,
			isnull(dbo.fBusca_CampoCliente(hou.Num_Proc_hea,89),'2') FreteMinimo,
			ENDI.Rua				Rua_CiaAer,
			ENDI.Numero				Numero_CiaAer,
			ENDI.Compl_End			Compl_CiaAer,
			ENDI.Bairro				Bairro_CiaAer,
			ENDI.Cidade				Ciade_CiaAer,
			ENDI.Pais				Pais_CiaAer,
	
			@Vlr_AgtPP_MEA Valor_AgentePP,
			@Vlr_CrrPP_MEA Valor_CarrierPP	,
			isnull(US.nome_usuario,@User) Nome_usuario,
			MEA.Dt_Impres_MEA dt_impressao,
			MEA.dt_ImpressDraft_mea dt_draft
			,TA.Nome_tp_AWB Tipo_AWB
		from 
			Master_Exp_Aer MEA
			Join house_exp_Aer HOU on MEA.num_proc_mea = HOU.num_proc_mea
			Left Outer Join LLP_Master LLP on MEA.num_proc_mea = LLP.Num_Proc_master
			Left Join Pessoa AG on MEA.cd_export_mea = AG.cd_pes
			Left Join Endereco ENDA on MEA.cd_export_mea = ENDA.cd_pes and ENDA.cd_tp_end = 'COM'
			--Left Join Pais PSA on ENDA.UF = PSA.cd_pais
			Left Join Cia_Aerea CA on MEA.cd_cia_aer = CA.cd_cia_aer
			Left Join Pessoa NF on NF.cd_pes=cd_export_mea
			Left Join Pessoa CS on CS.cd_pes=cd_consig_mea
			Left Join Endereco ENDC on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
			Left Join Endereco ENDI on CS.cd_pes=ENDI.cd_pes and ENDC.cd_tp_end = 'INT'
			--Left Join Pais PSC on ENDC.UF = PSC.cd_pais 
			Left Join Pessoa Sh on SH.cd_pes=cd_export_mea
			Left Join Endereco ENDS on SH.cd_pes=ENDS.cd_pes and ENDS.cd_tp_end = 'COM'
			--Left Join Pais PSS on ENDS.UF = PSS.cd_pais 
			Join Tipo_Moeda TM on TM.cd_tp_moeda=mea.cd_tp_moeda
			Left Join nature_goods NG on MEA.num_proc_mea =NG.Num_Proc
			Left Join Handling_MEA HN on MEA.num_proc_mea = HN.Num_proc_mea 
			Left Join PESSOA DSP on cd_dsp_hea=DSP.cd_pes
			--Left Join Localidade LCO on MEA.cd_org_mea = LCO.cd_local
			--Left Join Localidade LCD on MEA.cd_dst_mea = LCD.cd_local
	
	
			left outer join	Altera_bl ABL		on ABL.num_proc = MEA.num_proc_mea and ABL.status = 1
			Left Outer Join Localidade Origin	on ABL.cmbOrigin = Origin.Nome_Local
			Left Outer Join Localidade LCO		on ABL.CmbLoading = LCO.Nome_Local
			Left Outer Join Localidade LCD		on ABL.cmbDelivery = LCD.Nome_Local
			Left Outer Join Localidade DstFinal	on ABL.cmbFinalDestination 	= DstFinal.Nome_Local
	
			left join Usuario US on US.cd_usuario = MEA.cd_User_Impres_mea
			join Tipo_AWB TA on TA.Status = 1
		Where
			MEA.Num_Proc_mea=@Processo
	END
else
	BEGIN
		select 
			--Shipper
				ABL.txtShipper				Shipper,

				SH.Num_CPF_CNPJ				RUT_Shipper,
		
			--Consignee
				ABL.txtConsignee			Consignee,		

			--Notify
				ABL.txtNotify				Notify,

			--novos campos do hbl alterado
			cmbIssuing,
			txtIssuing,
			txtCarriage,
			txtCustoms,
			txtAmount,
			txtSignatureShipper,
			txtSignatureCarrier,
	
			HOU.Num_Proc_Hea,
			MAWB_HEA, 
			HAWB_HEA,


			MAWB_MEA,	
			--SH.Num_CPF_CNPJ			RUT_Shipper,
			--sh.Nome_raz_soc			Shipper,
			ENDS.RUA				RUA_S, 
			ENDS.Bairro				BAIRRO_S, 
			ENDS.Cidade				CIDADE_S, 
			UPPER(ENDS.Pais)		Pais_S,
	
			cs.Nome_Raz_Soc			Consignee,
			ENDC.RUA				RUA_C, 
			ENDC.Bairro				BAIRRO_C, 
			ENDC.Cidade				CIDADE_C, 
			UPPER(ENDC.Pais)		Pais_C,
			CS.Num_CPF_CNPJ			RUT_C,
	
			AG.Nome_raz_soc			Agente, 
			ENDA.RUA				RUA_A, 
			ENDA.Bairro				BAIRRO_A, 
			ENDA.Cidade				CIDADE_A, 
			UPPER(ENDA.Pais)		Pais_A,
			AG.num_cpf_cnpj			cnpj_A,	
 			( 'FILE: ' + upper(@Processo)) Accounting ,
 	
			--UPPER(LCO.Nome_Local)	Origem, 
			ABL.CmbOrigin		Origem,
			LCO.cd_local		CD_Origem,
	
			CA.Nome_cia_aer			Cia_Aer,
			ABL.cmbCiaAerea Cia_Aer,	
			--UPPER(LCD.cd_local)		CD_Destino,
			UPPER(LCD.IataCODE)		CD_Destino,
			--CA.Cd_cia_aer			CD_CIA_AER,
			ABL.cmbDelivery			Destino,
			upper(lcd.iatacode)		cd_cia_aer,
	
			mea.Voo_mEA				Voo_mea,
			ABL.txtVoo				Voo_mea,
	
			MEA.cd_tp_moeda,
			dbo.fBusca_CampoCliente (@processo, 47) exchangeRate,
			dbo.fBusca_CampoCliente (@processo, 39) ref_accountinginfo,
			--hou.tx_refer_hea		exchangeRate,
			--'0'					exchangeRate,
			tp_frete_mea, 
			--llp.selling_rates_lea	selling_rates,
			'0'						selling_rates,
			--UPPER(LCD.Nome_Local)	Destino,  
			--LLP.ATD_Lea				DATA_SAIDA,
			LLP.ETD_Master				DATA_SAIDA,
			HN.Hand_mEA_1,
			HN.Hand_MEA_2,
			HN.Hand_MEA_3,
			Qtd_Tot_Vol_mea,
			Peso_Bruto_mea			PESO_BRUTO,
			--LLP.Peso_Cubado			PESO_CUBADO, 
			--isnull([dbo].[fBusca_Volumes_M3](HOU.num_proc_hea),LLP.Peso_Cubado) PESO_CUBADO, 
			--(case when isnull([dbo].[fBusca_Volumes_M3](HOU.num_proc_hea),0) > LLP.Peso_Cubado then 
			--	[dbo].[fBusca_Volumes_M3](HOU.num_proc_hea)
			--else
			--	LLP.Peso_Cubado end) PESO_CUBADO,

			--(case when MEA.Peso_Bruto_mea > LLP.Peso_Cubado then 
			--	MEA.Peso_Bruto_mea
			--else
			--	LLP.Peso_Cubado end) PESO_CUBADO,

			(case when @Peso_Bruto	> @Peso_Cubado then 
				@Peso_Bruto
			else
				@Peso_Cubado end) PESO_CUBADO,

			vlr_frete_mea			VALOR_FRETE,
/*
			--NG.Descr				NATURES_GOODS,
			isnull(NG.Descr,'')															+ '|' +
			'INV. # ' + isnull([dbo].[fBusca_Docs_PO_Modal](HOU.num_proc_hea,2),'')		+ '|' +
			'DUE ' +  isnull([dbo].[fBusca_Docs_PO_Modal](HOU.num_proc_hea,204),'')		+ '|' +
			'PO '+ isnull([dbo].[fBusca_Docs_PO_Modal](HOU.num_proc_hea,1),'')	+ '|' +
			isnull([dbo].[fBusca_Volumes_Dimensao](HOU.num_proc_hea),'') NATURES_GOODS,
			
*/
----------------------Antonio 11-11-2024--------------------------------------------------------------
			(case when @LocICS2=1 then 
			      @NatureGoods															+ '|' +
					'INV. # ' + isnull([dbo].[fBusca_Docs_PO_Modal](HOU.num_proc_hea,2),'')		+ '|' +
					'DUE ' +  isnull([dbo].[fBusca_Docs_PO_Modal](HOU.num_proc_hea,204),'')		+ '|' +
					'PO '+ isnull([dbo].[fBusca_Docs_PO_Modal](HOU.num_proc_hea,1),'')	+ '|' +
					isnull([dbo].[fBusca_Volumes_Dimensao](HOU.num_proc_hea),'')
			 else
					isnull(NG.Descr,'')															+ '|' +
					'INV. # ' + isnull([dbo].[fBusca_Docs_PO_Modal](HOU.num_proc_hea,2),'')		+ '|' +
					'DUE ' +  isnull([dbo].[fBusca_Docs_PO_Modal](HOU.num_proc_hea,204),'')		+ '|' +
					'PO '+ isnull([dbo].[fBusca_Docs_PO_Modal](HOU.num_proc_hea,1),'')	+ '|' +
					isnull([dbo].[fBusca_Volumes_Dimensao](HOU.num_proc_hea),'') 
			 end) NATURES_GOODS,

			(case when @LocICS2=1 then 
			      'EORIConsignee: ' + isnull([dbo].[fBusca_CampoPessoa](CS.cd_pes,28),'') 
			 else
				  '  '
			 end) EORIConsignee,
---------------------------------------------------------------------------------------------------------

			
			left(MEA.MAWB_mEA,3)	COMECO,
			right(MEA.MAWB_mEA,8)	FIM,
			@Vlr_Agt_MEA			Valor_Agente,
			@Vlr_Crr_MEA			Valor_Carrier,
			@Vlr_Tx_Tot_MEA			Total_Taxa,
			dbo.spTaxasMasterEA(@Processo) Taxas,
			dbo.spHouseEA(@Processo)Houses,
			Obs_mea,
			--dbo.fBusca_CampoCliente(MEA.Num_Proc_mea,89) FreteMinimo,
			isnull(dbo.fBusca_CampoCliente(hou.Num_Proc_hea,89),'2') FreteMinimo,
			ENDI.Rua				Rua_CiaAer,
			ENDI.Numero				Numero_CiaAer,
			ENDI.Compl_End			Compl_CiaAer,
			ENDI.Bairro				Bairro_CiaAer,
			ENDI.Cidade				Ciade_CiaAer,
			ENDI.Pais				Pais_CiaAer,
	
			@Vlr_AgtPP_MEA Valor_AgentePP,
			@Vlr_CrrPP_MEA Valor_CarrierPP	,
			isnull(US.nome_usuario,@User) Nome_usuario,
			MEA.Dt_Impres_MEA dt_impressao,
			MEA.dt_ImpressDraft_mea dt_draft
				,'' [Tipo_AWB]
		from 
			Master_Exp_Aer MEA
			Join house_exp_Aer HOU on MEA.num_proc_mea = HOU.num_proc_mea
			Left Outer Join LLP_Master LLP on MEA.num_proc_mea = LLP.Num_Proc_master
			Left Join Pessoa AG on MEA.cd_export_mea = AG.cd_pes
			Left Join Endereco ENDA on MEA.cd_export_mea = ENDA.cd_pes and ENDA.cd_tp_end = 'COM'
			--Left Join Pais PSA on ENDA.UF = PSA.cd_pais
			Left Join Cia_Aerea CA on MEA.cd_cia_aer = CA.cd_cia_aer
			Left Join Pessoa NF on NF.cd_pes=cd_export_mea
			Left Join Pessoa CS on CS.cd_pes=cd_consig_mea
			Left Join Endereco ENDC on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
			Left Join Endereco ENDI on CS.cd_pes=ENDI.cd_pes and ENDC.cd_tp_end = 'INT'
			--Left Join Pais PSC on ENDC.UF = PSC.cd_pais 
			Left Join Pessoa Sh on SH.cd_pes=cd_export_mea
			Left Join Endereco ENDS on SH.cd_pes=ENDS.cd_pes and ENDS.cd_tp_end = 'COM'
			--Left Join Pais PSS on ENDS.UF = PSS.cd_pais 
			Join Tipo_Moeda TM on TM.cd_tp_moeda=mea.cd_tp_moeda
			Left Join nature_goods NG on MEA.num_proc_mea =NG.Num_Proc
			Left Join Handling_MEA HN on MEA.num_proc_mea = HN.Num_proc_mea 
			Left Join PESSOA DSP on cd_dsp_hea=DSP.cd_pes
			--Left Join Localidade LCO on MEA.cd_org_mea = LCO.cd_local
			--Left Join Localidade LCD on MEA.cd_dst_mea = LCD.cd_local
	
	
			left outer join	Altera_bl ABL		on ABL.num_proc = MEA.num_proc_mea and ABL.status = 1
			Left Outer Join Localidade Origin	on ABL.cmbOrigin = Origin.Nome_Local
			Left Outer Join Localidade LCO		on ABL.CmbLoading = LCO.Nome_Local
			Left Outer Join Localidade LCD		on ABL.cmbDelivery = LCD.Nome_Local
			Left Outer Join Localidade DstFinal	on ABL.cmbFinalDestination 	= DstFinal.Nome_Local
	
			left join Usuario US on US.cd_usuario = MEA.cd_User_Impres_mea
		Where
			MEA.Num_Proc_mea=@Processo
	END


GO
