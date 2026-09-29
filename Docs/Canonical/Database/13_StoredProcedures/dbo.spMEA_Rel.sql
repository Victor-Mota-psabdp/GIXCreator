SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spMEA_Rel]--'EAGIG201805001','',''

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

		Declare @Peso_Cubado decimal(9, 3)
		Declare @Peso_Bruto decimal(9, 3)
		
		Set @Vlr_Agt_MEA=isnull((select sum(vlr_org_MEA)from cta_cte_MAS_exp_aer where num_proc_MEA = @Processo and Comp_MBL_MEA = 'A' and contab_mes_ano = 'C'),0)
		Set @Vlr_Crr_MEA=isnull((select sum(vlr_org_MEA)from cta_cte_MAS_exp_aer where num_proc_MEA = @Processo and Comp_MBL_MEA = 'C' and contab_mes_ano = 'C'),0)
		
		Set @Vlr_AgtPP_MEA=isnull((select sum(vlr_org_mEA)from cta_cte_MAS_exp_aer where Num_Proc_MEA = @Processo and Comp_MBL_MEA = 'A' and contab_mes_ano = 'P'),0)
		Set @Vlr_CrrPP_MEA=isnull((select sum(vlr_org_mEA)from cta_cte_MAS_exp_aer where Num_Proc_MEA = @Processo and Comp_MBL_MEA = 'C' and contab_mes_ano = 'P'),0)
				
		set @Vlr_frete = isnull((select vlr_frete_mea from master_exp_Aer where num_proc_mea = @Processo),0)
		
		Set @Vlr_Tx_Tot_MEA= (@Vlr_Agt_MEA + @Vlr_Crr_MEA + @Vlr_frete)

		Set @Peso_Bruto = (select Sum(Peso_Bruto) from vwHouse_exp where Master =@Processo)
		Set @Peso_Cubado = (select Sum(Peso_Cubado) from vwHouse_exp where Master =@Processo)


--------------Antonio 14-11-2024 - LocICS2 verificar a região ------------------------------------------
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
			MAWB_MEA,	
			SH.Num_CPF_CNPJ			RUT_Shipper,
			sh.Nome_raz_soc			Shipper,
			ENDS.RUA				RUA_S, 
			ENDS.Bairro				BAIRRO_S, 
			ENDS.Cidade				CIDADE_S,
			ends.numero				NUMERO_S,
			ends.CEP				CEP_S,
			ends.uf					UF_S,
			UPPER(ENDS.Pais)		Pais_S,
			cs.Nome_Raz_Soc			Consignee,
			ENDC.RUA				RUA_C, 
			ENDC.Bairro				BAIRRO_C, 
			ENDC.Cidade				CIDADE_C,
			endc.numero				NUMERO_C,
			endc.cep				CEP_C,
			ENDC.Bairro				BAIRRO_C, 
			ENDC.Cidade				CIDADE_C,
			endc.uf					UF_C, 
			UPPER(ENDC.Pais)		Pais_C,
			CS.Num_CPF_CNPJ			RUT_C,
			AG.Nome_raz_soc			Agente, 
			ENDA.RUA				RUA_A, 
			ENDA.Bairro				BAIRRO_A, 
			ENDA.Cidade				CIDADE_A, 
			UPPER(ENDA.Pais)		Pais_A,
			AG.num_cpf_cnpj			cnpj_A,	
 			( 'FILE: ' + upper(@Processo)) Accounting ,
			UPPER(LCO.Nome_Local)	Origem, 
			LCO.cd_local			CD_Origem, 
			CA.Nome_cia_aer			Cia_Aer,
			UPPER(LCD.IataCODE)		CD_Destino,
			--CA.Cd_cia_aer			CD_CIA_AER,
			upper(lcd.iatacode)		cd_cia_aer,
			mea.Voo_mEA				Voo_mea,
			MEA.cd_tp_moeda,
			dbo.fBusca_CampoCliente (@processo, 47) exchangeRate,
			dbo.fBusca_CampoCliente (@processo, 39) ref_accountinginfo,
			--hou.tx_refer_hea		exchangeRate,
			--'0'						exchangeRate,
			tp_frete_mea, 
			--llp.selling_rates_lea	selling_rates,
			'0'						selling_rates,
			UPPER(LCD.Nome_Local)	Destino,  
			--LLP.ATD_Lea				DATA_SAIDA,
			LLP.ETD_Master				DATA_SAIDA,
			HN.Hand_mEA_1,
			HN.Hand_MEA_2,
			HN.Hand_MEA_3,
			Qtd_Tot_Vol_mea,
			--Peso_Bruto_mea			PESO_BRUTO,
			@Peso_Bruto					PESO_BRUTO,

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

----------------------Antonio 14-11-2024----------------------------------------------------------------
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
-------------------------------------------------------------------------------------------------------

			left(MEA.MAWB_mEA,3)	COMECO,
			right(MEA.MAWB_mEA,8)	FIM,
			@Vlr_Agt_MEA			Valor_Agente,
			@Vlr_Crr_MEA			Valor_Carrier,
			@Vlr_Tx_Tot_MEA			Total_Taxa,
			dbo.spTaxasMasterEA(@Processo) Taxas,
			dbo.spHouseEA(@Processo)Houses,
			Obs_mea,
		--	dbo.fBusca_CampoCliente(MEA.Num_Proc_mea,89) FreteMinimo,
			isnull(dbo.fBusca_CampoCliente(hou.Num_Proc_hea,89),'2') FreteMinimo,
			ENDI.Rua				Rua_CiaAer,
			ENDI.Numero				Numero_CiaAer,
			ENDI.Compl_End			Compl_CiaAer,
			ENDI.Bairro				Bairro_CiaAer,
			ENDI.Cidade				Ciade_CiaAer,
			ENDI.Pais				Pais_CiaAer,
	
			@Vlr_AgtPP_MEA Valor_AgentePP,
			@Vlr_CrrPP_MEA Valor_CarrierPP,
	
			'+' + CM.Cd_Int + ' ' + CM.Cd_Area_Fone + ' '+ CM.prefixo +'-'+ CM.Num_Fone Telefone,
	
			isnull(US.nome_usuario,@User) Nome_usuario,
			MEA.Dt_Impres_MEA dt_impressao,
			MEA.dt_ImpressDraft_mea dt_draft,
			--BDP= "EIN23-1878776" e qdo for SilverBirch  = "EIN20-8141384" - vwArmador_HBL_EM
	
			--(case when UPPER(ENDC.CD_pais) = 'CN' THEN
			--(case when UPPER(LCD.Cd_Pais) in ('CN','ID','MY')THEN
			--	(case when isnull(dbo.fBusca_CampoCliente(MEA.num_proc_mea,178),'BDP') = 'BDP' then 
			--		'Contact: ' + isnull(CMSH.Contato,'') + ' - EIN23-1878776'
			--	ELSE
			--		'Contact: ' + isnull(CMSH.Contato,'') + ' - EIN20-8141384'	
			--	end) 
			--ELSE
			--	'' end)	EIN_Number,
			--select * from tipo_campo_cliente where id_campo=178
			(case when P.HTS = 1 THEN 
				(case when isnull(dbo.fBusca_CampoCliente(MEA.num_proc_mea,178),'BDP') = 'BDP' then 
					'Contact: ' + isnull(CMSH.Contato,'') + ' - EIN23-1878776'
				ELSE
					'Contact: ' + isnull(CMSH.Contato,'') + ' - EIN20-8141384'	
				end) 
			ELSE
				'' end)	EIN_Number,
		
			--(case when UPPER(ENDC.CD_pais) = 'CN' THEN
			--(case when UPPER(LCD.Cd_Pais) in ('CN','ID','MY')THEN
			--	'Contact: ' + isnull(CMSH.Contato,'') + ' - ' + CP.Campo_Dados ELSE
			--	'' END) USCI

			(case when P.HTS = 1 THEN
				'Contact: ' + isnull(CMSH.Contato,'') + ' - ' + CP.Campo_Dados ELSE
				'' END) USCI
				,TA.Nome_tp_AWB Tipo_AWB

			--- ticket 100-540020 - Kaique - Adicionado
			,CMSH.contato Contato_S,
			CMSH.cd_int TEL_cdIntl_S,
			CMSH.cd_area_fone TEL_cdArea_S,
			CMSH.prefixo TEL_Prefixo_S,
			CMSH.num_fone TEL_num_fone_S,
			CM.contato Contato_C,
			CM.cd_int TEL_cdIntl_C,
			CM.cd_area_fone TEL_cdArea_C,
			CM.prefixo TEL_Prefixo_C,
			CM.num_fone TEL_num_fone_C,
			--- ticket 100-540020 ---

			--- ticket 100-540020 - Kaique - Adicionado
			UPPER(LCE.nome_local) [Embarque],
			LCE.cd_local	[CD_Embarque],
			--- ticket 100-540020 ---

					--- ticket 100-540020 - Kaique - Adicionado
			--campos do hbl alterado
			--Shipper
				ABL.txtShipper				Shipper1,
		
			--Consignee
				ABL.txtConsignee			Consignee1,		

			--Notify
				ABL.txtNotify				Notify,
	
			--novos campos do hbl alterado
			ABL.cmbIssuing,
			ABL.txtIssuing,
			ABL.txtCarriage,
			ABL.txtCustoms,
			ABL.txtAmount,
			ABL.txtSignatureShipper,
			ABL.txtSignatureCarrier
			--- ticket 100-540020 ---


		from 
			Master_Exp_Aer MEA
			Join house_exp_Aer HOU with(nolock) on MEA.num_proc_mea = HOU.num_proc_mea
			Left Outer Join LLP_Master LLP with(nolock) on MEA.num_proc_mea = LLP.Num_Proc_master
			Left Outer Join LLP_Exp_Aer LLPH with(nolock) on HOU.Num_Proc_Hea = LLPH.Num_Proc_Lea --- ticket 100-540020 - Kaique - Adicionado
			Left Join Pessoa AG with(nolock) on MEA.cd_export_mea = AG.cd_pes
			Left Join Endereco ENDA with(nolock) on MEA.cd_export_mea = ENDA.cd_pes and ENDA.cd_tp_end = 'COM'
			--Left Join Pais PSA on ENDA.UF = PSA.cd_pais
			Left Join Cia_Aerea CA with(nolock) on MEA.cd_cia_aer = CA.cd_cia_aer
			Left Join Pessoa NF with(nolock) on NF.cd_pes=cd_export_mea
			Left Join Pessoa CS with(nolock) on CS.cd_pes=cd_consig_mea
			Left Join Endereco ENDC with(nolock) on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
			Left Join Endereco ENDI with(nolock) on CS.cd_pes=ENDI.cd_pes and ENDC.cd_tp_end = 'INT'
			--Left Join Pais PSC on ENDC.UF = PSC.cd_pais 
			Left Join Pessoa Sh with(nolock) on SH.cd_pes=cd_export_mea
			Left Join Endereco ENDS with(nolock) on SH.cd_pes=ENDS.cd_pes and ENDS.cd_tp_end = 'COM'
			Left Join Comunicacao CMSH with(nolock) on CMSH.cd_pes=SH.cd_pes and CMSH.Cd_Tp_Com='TC1'	
	
			--Left Join Pais PSS on ENDS.UF = PSS.cd_pais 
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=mea.cd_tp_moeda
			Left Join nature_goods NG with(nolock) on MEA.num_proc_mea =NG.Num_Proc
			Left Join Handling_MEA HN with(nolock) on MEA.num_proc_mea = HN.Num_proc_mea 
			Left Join PESSOA DSP with(nolock) on cd_dsp_hea=DSP.cd_pes
			Left Join Localidade LCO with(nolock) on LLPH.Cd_Planta_lea = LCO.cd_local  --- ticket 100-540020 - Kaique - Alterado
			Left Join Localidade LCE with(nolock) on MEA.cd_org_mea = LCE.cd_local --- ticket 100-540020 - Kaique - Adicionado
			Left Join Localidade LCD with(nolock) on MEA.cd_dst_mea = LCD.cd_local
			left Join Pais P with(nolock)on P.Cd_Pais = LCD.Cd_Pais
			Left Join Comunicacao CM with(nolock) on CM.cd_pes=cs.cd_pes and CM.Cd_Tp_Com='TC1' -- CM.Cd_Tp_Com='HBL' --- ticket 100-540020 - Kaique - Alteração
	
			left join Usuario US with(nolock) on US.cd_usuario = MEA.cd_User_Impres_mea
	
			left join Campo_Pessoa CP with(nolock) on CP.Cd_Pes = CS.Cd_Pes and cp.Id_Campo = '18'

			join Tipo_AWB TA on TA.Status = 1
			left outer join	Altera_bl ABL with(nolock) on ABL.num_proc = Hou.num_proc_mea and ABL.status = 1 --- ticket 100-540020 - Kaique - Adicionado
	
		Where
			MEA.Num_Proc_mea=@Processo
	End
Else
	BEGIN
				select 
			MAWB_MEA,	
			SH.Num_CPF_CNPJ			RUT_Shipper,
			sh.Nome_raz_soc			Shipper,
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
			UPPER(LCO.Nome_Local)	Origem, 
			LCO.cd_local			CD_Origem, 
			CA.Nome_cia_aer			Cia_Aer,
			UPPER(LCD.IataCODE)		CD_Destino,
			--CA.Cd_cia_aer			CD_CIA_AER,
			upper(lcd.iatacode)		cd_cia_aer,
			mea.Voo_mEA				Voo_mea,
			MEA.cd_tp_moeda,
			dbo.fBusca_CampoCliente (@processo, 47) exchangeRate,
			dbo.fBusca_CampoCliente (@processo, 39) ref_accountinginfo,
			--hou.tx_refer_hea		exchangeRate,
			--'0'						exchangeRate,
			tp_frete_mea, 
			--llp.selling_rates_lea	selling_rates,
			'0'						selling_rates,
			UPPER(LCD.Nome_Local)	Destino,  
			--LLP.ATD_Lea				DATA_SAIDA,
			LLP.ETD_Master				DATA_SAIDA,
			HN.Hand_mEA_1,
			HN.Hand_MEA_2,
			HN.Hand_MEA_3,
			Qtd_Tot_Vol_mea,
			--Peso_Bruto_mea			PESO_BRUTO,
			@Peso_Bruto			PESO_BRUTO,

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

			(case when @Peso_Bruto > @Peso_Cubado then 
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
----------------------Antonio 14-11-2024----------------------------------------------------------------
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
----------------------------------------------------------------------------------------------------------
	
			
			left(MEA.MAWB_mEA,3)	COMECO,
			right(MEA.MAWB_mEA,8)	FIM,
			@Vlr_Agt_MEA			Valor_Agente,
			@Vlr_Crr_MEA			Valor_Carrier,
			@Vlr_Tx_Tot_MEA			Total_Taxa,
			dbo.spTaxasMasterEA(@Processo) Taxas,
			dbo.spHouseEA(@Processo)Houses,
			Obs_mea,
		--	dbo.fBusca_CampoCliente(MEA.Num_Proc_mea,89) FreteMinimo,
			isnull(dbo.fBusca_CampoCliente(hou.Num_Proc_hea,89),'2') FreteMinimo,
			ENDI.Rua				Rua_CiaAer,
			ENDI.Numero				Numero_CiaAer,
			ENDI.Compl_End			Compl_CiaAer,
			ENDI.Bairro				Bairro_CiaAer,
			ENDI.Cidade				Ciade_CiaAer,
			ENDI.Pais				Pais_CiaAer,
	
			@Vlr_AgtPP_MEA Valor_AgentePP,
			@Vlr_CrrPP_MEA Valor_CarrierPP,
	
			--'+' + CM.Cd_Int + ' ' + CM.Cd_Area_Fone + ' '+ CM.prefixo +'-'+ CM.Num_Fone Telefone, --- ticket 100-540020 - Kaique - Alteração
	
			isnull(US.nome_usuario,@User) Nome_usuario,
			MEA.Dt_Impres_MEA dt_impressao,
			MEA.dt_ImpressDraft_mea dt_draft,
			--BDP= "EIN23-1878776" e qdo for SilverBirch  = "EIN20-8141384" - vwArmador_HBL_EM
	
			--(case when UPPER(ENDC.CD_pais) = 'CN' THEN
			--(case when UPPER(LCD.Cd_Pais) in ('CN','ID','MY')THEN
			--	(case when isnull(dbo.fBusca_CampoCliente(MEA.num_proc_mea,178),'BDP') = 'BDP' then 
			--		'Contact: ' + isnull(CMSH.Contato,'') + ' - EIN23-1878776'
			--	ELSE
			--		'Contact: ' + isnull(CMSH.Contato,'') + ' - EIN20-8141384'	
			--	end) 
			--ELSE
			--	'' end)	EIN_Number,
			--select * from tipo_campo_cliente where id_campo=178
			(case when P.HTS = 1 THEN 
				(case when isnull(dbo.fBusca_CampoCliente(MEA.num_proc_mea,178),'BDP') = 'BDP' then 
					'Contact: ' + isnull(CMSH.Contato,'') + ' - EIN23-1878776'
				ELSE
					'Contact: ' + isnull(CMSH.Contato,'') + ' - EIN20-8141384'	
				end) 
			ELSE
				'' end)	EIN_Number,
		
			--(case when UPPER(ENDC.CD_pais) = 'CN' THEN
			--(case when UPPER(LCD.Cd_Pais) in ('CN','ID','MY')THEN
			--	'Contact: ' + isnull(CMSH.Contato,'') + ' - ' + CP.Campo_Dados ELSE
			--	'' END) USCI

			(case when P.HTS = 1 THEN
				'Contact: ' + isnull(CMSH.Contato,'') + ' - ' + CP.Campo_Dados ELSE
				'' END) USCI
			,'' [Tipo_AWB]

			--- ticket 100-540020 - Kaique - Adicionado
			,CMSH.contato Contato_S,
			CMSH.cd_int TEL_cdIntl_S,
			CMSH.cd_area_fone TEL_cdArea_S,
			CMSH.prefixo TEL_Prefixo_S,
			CMSH.num_fone TEL_num_fone_S,
			CM.contato Contato_C,
			CM.cd_int TEL_cdIntl_C,
			CM.cd_area_fone TEL_cdArea_C,
			CM.prefixo TEL_Prefixo_C,
			CM.num_fone TEL_num_fone_C,
			--- ticket 100-540020 ---
			--- ticket 100-540020 - Kaique - Adicionado
			UPPER(LCE.nome_local) [Embarque],
			LCE.cd_local	[CD_Embarque]
			--- ticket 100-540020 ---
		from 
			Master_Exp_Aer MEA
			Join house_exp_Aer HOU with(nolock) on MEA.num_proc_mea = HOU.num_proc_mea
			Left Outer Join LLP_Master LLP with(nolock) on MEA.num_proc_mea = LLP.Num_Proc_master
			Left Outer Join LLP_Exp_Aer LLPH with(nolock) on HOU.Num_Proc_Hea = LLPH.Num_Proc_Lea --- ticket 100-540020 - Kaique - Adicionado
			Left Join Pessoa AG with(nolock) on MEA.cd_export_mea = AG.cd_pes
			Left Join Endereco ENDA with(nolock) on MEA.cd_export_mea = ENDA.cd_pes and ENDA.cd_tp_end = 'COM'
			--Left Join Pais PSA on ENDA.UF = PSA.cd_pais
			Left Join Cia_Aerea CA with(nolock) on MEA.cd_cia_aer = CA.cd_cia_aer
			Left Join Pessoa NF with(nolock) on NF.cd_pes=cd_export_mea
			Left Join Pessoa CS with(nolock) on CS.cd_pes=cd_consig_mea
			Left Join Endereco ENDC with(nolock) on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
			Left Join Endereco ENDI with(nolock) on CS.cd_pes=ENDI.cd_pes and ENDC.cd_tp_end = 'INT'
			--Left Join Pais PSC on ENDC.UF = PSC.cd_pais 
			Left Join Pessoa Sh with(nolock) on SH.cd_pes=cd_export_mea
			Left Join Endereco ENDS with(nolock) on SH.cd_pes=ENDS.cd_pes and ENDS.cd_tp_end = 'COM'
			Left Join Comunicacao CMSH with(nolock) on CMSH.cd_pes=SH.cd_pes and CMSH.Cd_Tp_Com='TC1'	
	
			--Left Join Pais PSS on ENDS.UF = PSS.cd_pais 
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=mea.cd_tp_moeda
			Left Join nature_goods NG with(nolock) on MEA.num_proc_mea =NG.Num_Proc
			Left Join Handling_MEA HN with(nolock) on MEA.num_proc_mea = HN.Num_proc_mea 
			Left Join PESSOA DSP with(nolock) on cd_dsp_hea=DSP.cd_pes
			Left Join Localidade LCO with(nolock) on LLPH.Cd_Planta_lea = LCO.cd_local  --- ticket 100-540020 - Kaique - Alterado
			Left Join Localidade LCE with(nolock) on MEA.cd_org_mea = LCE.cd_local --- ticket 100-540020 - Kaique - Adicionado
			Left Join Localidade LCD with(nolock) on MEA.cd_dst_mea = LCD.cd_local
			left Join Pais P with(nolock)on P.Cd_Pais = LCD.Cd_Pais
			Left Join Comunicacao CM with(nolock) on CM.cd_pes=cs.cd_pes and CM.Cd_Tp_Com='TC1' -- CM.Cd_Tp_Com='HBL' --- ticket 100-540020 - Kaique - Alteração
	
			left join Usuario US with(nolock) on US.cd_usuario = MEA.cd_User_Impres_mea
	
			left join Campo_Pessoa CP with(nolock) on CP.Cd_Pes = CS.Cd_Pes and cp.Id_Campo = '18'
	
		Where
			MEA.Num_Proc_mea=@Processo
	END

GO
