SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spHEA_Teste_Rel]--'EAATL202510023BR','administrador','O' 
		@Processo 	VarChar(16),
		@User		varchar(50),
		@Tipo		char(1)

AS



		Declare @Vlr_Agt_HEA	float
		Declare @Vlr_Crr_HEA 	float		
		Declare @Vlr_Tx_Tot_HEA float
		Declare @Vlr_frete		float
		
		Declare @Vlr_AgtPP_HEA	float
		Declare @Vlr_CrrPP_HEA 	float	
		
		Declare @Peso_Cubado decimal(9, 3)

		Set @Vlr_Agt_HEA=isnull((select sum(vlr_org_HEA)from cta_cte_HOU_exp_aer where num_proc_HEA = @Processo and Comp_Job_HEA = 'A' and contab_mes_ano = 'C'),0)
		Set @Vlr_Crr_HEA=isnull((select sum(vlr_org_HEA)from cta_cte_HOU_exp_aer where num_proc_HEA = @Processo and Comp_Job_HEA = 'C' and contab_mes_ano = 'C'),0)
		
		Set @Vlr_AgtPP_HEA=isnull((select sum(vlr_org_HEA)from cta_cte_HOU_exp_aer where num_proc_HEA = @Processo and Comp_Job_HEA = 'A' and contab_mes_ano = 'P'),0)
		Set @Vlr_CrrPP_HEA=isnull((select sum(vlr_org_HEA)from cta_cte_HOU_exp_aer where num_proc_HEA = @Processo and Comp_Job_HEA = 'C' and contab_mes_ano = 'P'),0)
		
		set @Vlr_frete = isnull((select vlr_frete_tot_hea from house_exp_Aer where num_proc_hea = @Processo),0)

		Set @Vlr_Tx_Tot_HEA = (@Vlr_Agt_HEA + @Vlr_Crr_HEA + @Vlr_frete)

		Set @Peso_Cubado = (select Convert([decimal](9, 3),[dbo].[fBusca_Volumes_M3] (@Processo)))
		
----Antonio 15-10-2024 - LocICS2 verificar a região ------------------------------------------
		declare @LocICS2 bit
        declare @NatureGoods varchar(4000)
        declare @NatureGoodsICS varchar(4000)
	    set @LocICS2 =(select  reg.LocICS2 from vwHouse_Exp hea with(nolock) 
					   join Localidade loc with(nolock) on loc.Cd_Local = hea.Cd_DstFinal	 
					   join Regiao reg with(nolock) on reg.Cd_Regiao = loc.Cd_Regiao
						        					 and reg.LocICS2 = 1  
					    where hea.Num_Proc =@Processo		
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
			HOU.Num_Proc_Hea,
			MAWB_HEA, 
			HAWB_HEA,
			right(SH.Num_CPF_CNPJ,14) RUT_Shipper,
			sh.Nome_raz_soc Shipper,
			ENDS.RUA RUA_S, 
			ends.numero NUMERO_S,
			ends.CEP CEP_S,
			ENDS.Bairro BAIRRO_S, 
			ENDS.Cidade CIDADE_S,
			ends.uf UF_S, 
			UPPER(ENDS.Pais) Pais_S,
			COMS.contato Contato_S,
			COMS.cd_int TEL_cdIntl_S,
			COMS.cd_area_fone TEL_cdArea_S,
			COMS.prefixo TEL_Prefixo_S,
			COMS.num_fone TEL_num_fone_S,
			cs.Nome_Raz_Soc Consignee,
			ENDC.RUA RUA_C, 
			endc.numero NUMERO_C,
			endc.cep CEP_C,
			ENDC.Bairro BAIRRO_C, 
			ENDC.Cidade CIDADE_C,
			endc.uf UF_C, 
			UPPER(ENDC.Pais) Pais_C,
			COMC.contato Contato_C,
			COMC.cd_int TEL_cdIntl_C,
			COMC.cd_area_fone TEL_cdArea_C,
			COMC.prefixo TEL_Prefixo_C,
			COMC.num_fone TEL_num_fone_C,

			AG.Nome_raz_soc Agente, 
			ENDA.RUA RUA_A, 
			ENDA.Bairro BAIRRO_A, 
			ENDA.Cidade CIDADE_A, 
			UPPER(ENDA.Pais) Pais_A,
			AG.num_cpf_cnpj	cnpj_A,	
 			( 'FILE: ' + upper(@Processo)) Accounting ,
			UPPER(LCO.Nome_Local) Origem, 
			LCO.cd_local CD_Origem, 
			CA.Nome_cia_aer Cia_Aer,	
			UPPER(LCD.cd_local) CD_Destino,
			--CA.Cd_cia_aer CD_CIA_AER,
			upper(isnull(lcd.iatacode,lcd.cd_local)) cd_cia_aer,
			hou.Voo_hEA Voo_mea,
			MEA.cd_tp_moeda,
			tx_refer_hea exchangeRate,
			tp_frete_hea, 
			llp.selling_rates_lea selling_rates,
			UPPER(LCD.Nome_Local) Destino,  
			--LLP.ATD_Lea DATA_SAIDA,
			LLP.ETD_Lea DATA_SAIDA,
			HN.Hand_HEA_1,
			Qtd_Tot_Vol_hea,
			Peso_Bruto_hea PESO_BRUTO,
			--LLP.Peso_Cubado_Lea PESO_CUBADO, 
			--isnull([dbo].[fBusca_Volumes_M3](HOU.num_proc_hea),LLP.Peso_Cubado_Lea) PESO_CUBADO, 
			--(case when isnull([dbo].[fBusca_Volumes_M3](HOU.num_proc_hea),0) > HOU.Peso_Cubado_Lea then 
			--	[dbo].[fBusca_Volumes_M3](HOU.num_proc_hea)
			--else
			--	Peso_Cubado_Lea end) PESO_CUBADO,

			(case when HOU.Peso_Bruto_hea > isnull(@Peso_Cubado,LLP.Peso_Cubado_Lea) then 
				HOU.Peso_Bruto_hea
			else
				 isnull(@Peso_Cubado,LLP.Peso_Cubado_Lea) end) PESO_CUBADO,

			vlr_frete_tot_hea VALOR_FRETE,
			--NG.Descr NATURES_GOODS,
/* 15-10-2024  
			isnull(NG.Descr,'')															+ '|' +
			'INV. # ' + isnull([dbo].[fBusca_Docs_PO_Modal](HOU.num_proc_hea,2),'')		+ '|' +
			'DUE ' +  isnull([dbo].[fBusca_Docs_PO_Modal](HOU.num_proc_hea,204),'')		+ '|' +
			'PO '+ isnull([dbo].[fBusca_Docs_PO_Modal](HOU.num_proc_hea,1),'')	+ '|' +
			isnull([dbo].[fBusca_Volumes_Dimensao](HOU.num_proc_hea),'') NATURES_GOODS,
*/
----------------------Antonio 15-10-2024 -----------------------------------------------------------
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
--------------------------------------------------------------------------------------------------------------
			left(HOU.MAWB_HEA,3) COMECO,
			right(HOU.MAWB_HEA,8) FIM,
			@Vlr_Agt_HEA Valor_Agente,
			@Vlr_Crr_HEA Valor_Carrier,
			@Vlr_Tx_Tot_HEA Total_Taxa,
			dbo.spTaxasHouseEA(@Processo) Taxas,
			Obs_hea,
			llp.dt_impres_lea dt_impressao,
			llp.dt_ImpressDraft_lea dt_draft,
			isnull(dbo.fBusca_CampoCliente(hou.Num_Proc_hea,88),'2') AsAgreed,
			isnull(dbo.fBusca_CampoCliente(hou.Num_Proc_hea,89),'2') FreteMinimo,
			isnull(US.nome_usuario,@User) Nome_usuario,
			dbo.fBusca_CampoCliente (@processo, 39)ref_accountinginfo,
	
			@Vlr_AgtPP_HEA Valor_AgentePP,
			@Vlr_CrrPP_HEA Valor_CarrierPP,
			TA.Nome_tp_AWB Tipo_AWB
		from 
			house_exp_Aer HOU
			Left Join Master_Exp_Aer MEA on HOU.num_proc_mea = MEA.num_proc_mea
			Left Outer Join LLP_Exp_Aer LLP on HOU.Num_Proc_Hea = LLP.Num_Proc_Lea
			Left Join Pessoa AG on MEA.cd_export_mea = AG.cd_pes
			Left Join Endereco ENDA on MEA.cd_export_mea = ENDA.cd_pes and ENDA.cd_tp_end = 'COM'
			--Left Join Pais PSA on ENDA.UF = PSA.cd_pais
			Left Join Cia_Aerea CA on LLP.cd_ciaAerea_lea = CA.cd_cia_aer
			Left Join Pessoa NF on NF.cd_pes=cd_export_hea
			Left Join Pessoa CS on CS.cd_pes=cd_consig_hea
			Left Join Endereco ENDC on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
			left join comunicacao COMC on CS.cd_pes = COMC.cd_pes and comc.cd_tp_com = 'TC1'
			--Left Join Pais PSC on ENDC.UF = PSC.cd_pais 
			Left Join Pessoa Sh on SH.cd_pes=cd_export_hea
			Left Join Endereco ENDS on SH.cd_pes=ENDS.cd_pes and ENDS.cd_tp_end = 'COM'
			left join comunicacao COMS on SH.cd_pes = COMS.cd_pes AND COMS.cd_tp_com = 'TC1'
			--Left Join Pais PSS on ENDS.UF = PSS.cd_pais 
			Join Tipo_Moeda TM on TM.cd_tp_moeda=HOU.cd_tp_moeda
			Left Join nature_goods NG on HOU.num_proc_hea=NG.Num_Proc
			Left Join Handling_HEA HN on Hou.num_proc_hea = HN.Num_proc_hea 
			Left Join PESSOA DSP on cd_dsp_hea=DSP.cd_pes
			Left Join Localidade LCO on HOU.cd_org_hea = LCO.cd_local
			Left Join Localidade LCD on Hou.cd_dst_hea = LCD.cd_local
			left join Usuario US on US.cd_usuario = LLP.cd_User_Impres_Lea
			join Tipo_AWB TA on TA.Status = 1
		Where
			hou.Num_Proc_hea=@Processo
	End
Else
	BEGIN
		select 
			HOU.Num_Proc_Hea,
			MAWB_HEA, 
			HAWB_HEA,
			right(SH.Num_CPF_CNPJ,14) RUT_Shipper,
			sh.Nome_raz_soc Shipper,
			ENDS.RUA RUA_S, 
			ends.numero NUMERO_S,
			ends.CEP CEP_S,
			ENDS.Bairro BAIRRO_S, 
			ENDS.Cidade CIDADE_S,
			ends.uf UF_S, 
			UPPER(ENDS.Pais) Pais_S,
			COMS.contato Contato_S,
			COMS.cd_int TEL_cdIntl_S,
			COMS.cd_area_fone TEL_cdArea_S,
			COMS.prefixo TEL_Prefixo_S,
			COMS.num_fone TEL_num_fone_S,
			cs.Nome_Raz_Soc Consignee,
			ENDC.RUA RUA_C, 
			endc.numero NUMERO_C,
			endc.cep CEP_C,
			ENDC.Bairro BAIRRO_C, 
			ENDC.Cidade CIDADE_C,
			endc.uf UF_C, 
			UPPER(ENDC.Pais) Pais_C,
			COMC.contato Contato_C,
			COMC.cd_int TEL_cdIntl_C,
			COMC.cd_area_fone TEL_cdArea_C,
			COMC.prefixo TEL_Prefixo_C,
			COMC.num_fone TEL_num_fone_C,

			AG.Nome_raz_soc Agente, 
			ENDA.RUA RUA_A, 
			ENDA.Bairro BAIRRO_A, 
			ENDA.Cidade CIDADE_A, 
			UPPER(ENDA.Pais) Pais_A,
			AG.num_cpf_cnpj	cnpj_A,	
 			( 'FILE: ' + upper(@Processo)) Accounting ,
			UPPER(LCO.Nome_Local) Origem, 
			LCO.cd_local CD_Origem, 
			CA.Nome_cia_aer Cia_Aer,	
			UPPER(LCD.cd_local) CD_Destino,
			--CA.Cd_cia_aer CD_CIA_AER,
			upper(isnull(lcd.iatacode,lcd.cd_local)) cd_cia_aer,
			hou.Voo_hEA Voo_mea,
			MEA.cd_tp_moeda,
			tx_refer_hea exchangeRate,
			tp_frete_hea, 
			llp.selling_rates_lea selling_rates,
			UPPER(LCD.Nome_Local) Destino,  
			--LLP.ATD_Lea DATA_SAIDA,
			LLP.ETD_Lea DATA_SAIDA,
			HN.Hand_HEA_1,
			Qtd_Tot_Vol_hea,
			Peso_Bruto_hea PESO_BRUTO,
			--LLP.Peso_Cubado_Lea PESO_CUBADO, 
			--isnull([dbo].[fBusca_Volumes_M3](HOU.num_proc_hea),LLP.Peso_Cubado_Lea) PESO_CUBADO, 
			--(case when isnull([dbo].[fBusca_Volumes_M3](HOU.num_proc_hea),0) > LLP.Peso_Cubado_Lea then 
			--	[dbo].[fBusca_Volumes_M3](HOU.num_proc_hea)
			--else
			--	LLP.Peso_Cubado_Lea end) PESO_CUBADO,

			--(case when HOU.Peso_Bruto_hea > LLP.Peso_Cubado_Lea then 
			--	HOU.Peso_Bruto_hea
			--else
			--	LLP.Peso_Cubado_Lea end) PESO_CUBADO,

			--(case when HOU.Peso_Bruto_hea > @Peso_Cubado then 
			--	HOU.Peso_Bruto_hea
			--else
			--	@Peso_Cubado end) PESO_CUBADO,

			(case when HOU.Peso_Bruto_hea > isnull(@Peso_Cubado,LLP.Peso_Cubado_Lea) then 
				HOU.Peso_Bruto_hea
			else
				 isnull(@Peso_Cubado,LLP.Peso_Cubado_Lea) end) PESO_CUBADO,

			vlr_frete_tot_hea VALOR_FRETE,
			--NG.Descr NATURES_GOODS,
/* 15-11-2024
			isnull(NG.Descr,'')															+ '|' +
			'INV. # ' + isnull([dbo].[fBusca_Docs_PO_Modal](HOU.num_proc_hea,2),'')		+ '|' +
			'DUE ' +  isnull([dbo].[fBusca_Docs_PO_Modal](HOU.num_proc_hea,204),'')		+ '|' +
			'PO '+ isnull([dbo].[fBusca_Docs_PO_Modal](HOU.num_proc_hea,1),'')	+ '|' +
			isnull([dbo].[fBusca_Volumes_Dimensao](HOU.num_proc_hea),'') NATURES_GOODS,
*/			
------------------------Antonio 15-10-2024-----------------------------------------------------------------
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
			left(HOU.MAWB_HEA,3) COMECO,
			right(HOU.MAWB_HEA,8) FIM,
			@Vlr_Agt_HEA Valor_Agente,
			@Vlr_Crr_HEA Valor_Carrier,
			@Vlr_Tx_Tot_HEA Total_Taxa,
			dbo.spTaxasHouseEA(@Processo) Taxas,
			Obs_hea,
			llp.dt_impres_lea dt_impressao,
			llp.dt_ImpressDraft_lea dt_draft,
			isnull(dbo.fBusca_CampoCliente(hou.Num_Proc_hea,88),'2') AsAgreed,
			isnull(dbo.fBusca_CampoCliente(hou.Num_Proc_hea,89),'2') FreteMinimo,
			isnull(US.nome_usuario,@User) Nome_usuario,
			dbo.fBusca_CampoCliente (@processo, 39)ref_accountinginfo,
	
			@Vlr_AgtPP_HEA Valor_AgentePP,
			@Vlr_CrrPP_HEA Valor_CarrierPP,
			'' [Tipo_AWB]
		from 
			house_exp_Aer HOU
			Left Join Master_Exp_Aer MEA on HOU.num_proc_mea = MEA.num_proc_mea
			Left Outer Join LLP_Exp_Aer LLP on HOU.Num_Proc_Hea = LLP.Num_Proc_Lea
			Left Join Pessoa AG on MEA.cd_export_mea = AG.cd_pes
			Left Join Endereco ENDA on MEA.cd_export_mea = ENDA.cd_pes and ENDA.cd_tp_end = 'COM'
			--Left Join Pais PSA on ENDA.UF = PSA.cd_pais
			Left Join Cia_Aerea CA on LLP.cd_ciaAerea_lea = CA.cd_cia_aer
			Left Join Pessoa NF on NF.cd_pes=cd_export_hea
			Left Join Pessoa CS on CS.cd_pes=cd_consig_hea
			Left Join Endereco ENDC on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
			left join comunicacao COMC on CS.cd_pes = COMC.cd_pes and comc.cd_tp_com = 'TC1'
			--Left Join Pais PSC on ENDC.UF = PSC.cd_pais 
			Left Join Pessoa Sh on SH.cd_pes=cd_export_hea
			Left Join Endereco ENDS on SH.cd_pes=ENDS.cd_pes and ENDS.cd_tp_end = 'COM'
			left join comunicacao COMS on SH.cd_pes = COMS.cd_pes AND COMS.cd_tp_com = 'TC1'
			--Left Join Pais PSS on ENDS.UF = PSS.cd_pais 
			Join Tipo_Moeda TM on TM.cd_tp_moeda=HOU.cd_tp_moeda
			Left Join nature_goods NG on HOU.num_proc_hea=NG.Num_Proc
			Left Join Handling_HEA HN on Hou.num_proc_hea = HN.Num_proc_hea 
			Left Join PESSOA DSP on cd_dsp_hea=DSP.cd_pes
			Left Join Localidade LCO on HOU.cd_org_hea = LCO.cd_local
			Left Join Localidade LCD on Hou.cd_dst_hea = LCD.cd_local
			left join Usuario US on US.cd_usuario = LLP.cd_User_Impres_Lea			
		Where
			hou.Num_Proc_hea=@Processo
	END





--antiga stored
---------------------------------------------------------------------------------------------------------------------------------------------------

--		Declare @Vlr_Agt_HEA	float
--		Declare @Vlr_Crr_HEA 	float
--		Declare @Vlr_Tx_Tot_HEA float
--		Declare @Vlr_frete		float

--		Set @Vlr_Agt_HEA=isnull((select sum(vlr_org_HEA)from cta_cte_HOU_exp_aer where num_proc_HEA = @Processo and Comp_Job_HEA = 'A'),0)
--		Set @Vlr_Crr_HEA=isnull((select sum(vlr_org_HEA)from cta_cte_HOU_exp_aer where num_proc_HEA = @Processo and Comp_Job_HEA = 'C'),0)
		
--		set @Vlr_frete = isnull((select vlr_frete_tot_hea from house_exp_Aer where num_proc_hea = @Processo),0)

--		Set @Vlr_Tx_Tot_HEA = (@Vlr_Agt_HEA + @Vlr_Crr_HEA + @Vlr_frete)

--select 
--	HOU.Num_Proc_Hea,
--	MAWB_HEA, 
--	HAWB_HEA,

--	SH.Num_CPF_CNPJ RUT_Shipper,
--	sh.Nome_raz_soc Shipper,
--	ENDS.RUA RUA_S, 
--	ends.numero NUMERO_S,
--	ends.CEP CEP_S,
--	ENDS.Bairro BAIRRO_S, 
--	ENDS.Cidade CIDADE_S,
--	ends.uf UF_S, 
--	UPPER(ENDS.Pais) Pais_S,
--	COMS.contato Contato_S,
--	COMS.cd_int TEL_cdIntl_S,
--	COMS.cd_area_fone TEL_cdArea_S,
--	COMS.prefixo TEL_Prefixo_S,
--	COMS.num_fone TEL_num_fone_S,

--	cs.Nome_Raz_Soc Consignee,
--	ENDC.RUA RUA_C, 
--	endc.numero NUMERO_C,
--	endc.cep CEP_C,
--	ENDC.Bairro BAIRRO_C, 
--	ENDC.Cidade CIDADE_C,
--	endc.uf UF_C, 
--	UPPER(ENDC.Pais) Pais_C,
--	COMC.contato Contato_C,
--	COMC.cd_int TEL_cdIntl_C,
--	COMC.cd_area_fone TEL_cdArea_C,
--	COMC.prefixo TEL_Prefixo_C,
--	COMC.num_fone TEL_num_fone_C,

--	AG.Nome_raz_soc Agente, 
--	ENDA.RUA RUA_A, 
--	ENDA.Bairro BAIRRO_A, 
--	ENDA.Cidade CIDADE_A, 
--	UPPER(ENDA.Pais) Pais_A,
--	AG.num_cpf_cnpj	cnpj_A,	
-- 	( 'FILE: ' + upper(@Processo)) Accounting ,
--	UPPER(LCO.Nome_Local) Origem, 
--	LCO.cd_local CD_Origem, 
--	CA.Nome_cia_aer Cia_Aer,	
--	UPPER(LCD.cd_local) CD_Destino,
--	--CA.Cd_cia_aer CD_CIA_AER,
--	upper(isnull(lcd.iatacode,lcd.cd_local)) cd_cia_aer,
--	hou.Voo_hEA Voo_mea,
--	MEA.cd_tp_moeda,
--	tx_refer_hea exchangeRate,
--	tp_frete_hea, 
--	llp.selling_rates_lea selling_rates,
--	UPPER(LCD.Nome_Local) Destino,  
--	--LLP.ATD_Lea DATA_SAIDA,
--	LLP.ETD_Lea DATA_SAIDA,
--	HN.Hand_HEA_1,
--	Qtd_Tot_Vol_hea,
--	Peso_Bruto_hea PESO_BRUTO,
--	LLP.Peso_Cubado_Lea PESO_CUBADO, 
--	vlr_frete_tot_hea VALOR_FRETE,
--	NG.Descr NATURES_GOODS,
--	left(HOU.MAWB_HEA,3) COMECO,
--	right(HOU.MAWB_HEA,8) FIM,
--	@Vlr_Agt_HEA Valor_Agente,
--	@Vlr_Crr_HEA Valor_Carrier,
--	@Vlr_Tx_Tot_HEA Total_Taxa,
--	dbo.spTaxasHouseEA(@Processo) Taxas,
--	Obs_hea,
--	llp.dt_impres_lea dt_impressao,
--	llp.dt_ImpressDraft_lea dt_draft,
--	isnull(dbo.fBusca_CampoCliente(hou.Num_Proc_hea,88),'2') AsAgreed,
--	isnull(dbo.fBusca_CampoCliente(hou.Num_Proc_hea,89),'2') FreteMinimo,
--	isnull(US.nome_usuario,@User) Nome_usuario,
--	'' ref_accountinginfo
--from 
--	house_exp_Aer HOU
--	Left Join Master_Exp_Aer MEA on HOU.num_proc_mea = MEA.num_proc_mea
--	Left Outer Join LLP_Exp_Aer LLP on HOU.Num_Proc_Hea = LLP.Num_Proc_Lea
--	Left Join Pessoa AG on MEA.cd_export_mea = AG.cd_pes
--	Left Join Endereco ENDA on MEA.cd_export_mea = ENDA.cd_pes and ENDA.cd_tp_end = 'COM'
--	--Left Join Pais PSA on ENDA.UF = PSA.cd_pais
--	Left Join Cia_Aerea CA on LLP.cd_ciaAerea_lea = CA.cd_cia_aer
--	Left Join Pessoa NF on NF.cd_pes=cd_export_hea
--	Left Join Pessoa CS on CS.cd_pes=cd_consig_hea
--	Left Join Endereco ENDC on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
--	left join comunicacao COMC on CS.cd_pes = COMC.cd_pes and comc.cd_tp_com = 'TC1'
--	--Left Join Pais PSC on ENDC.UF = PSC.cd_pais 
--	Left Join Pessoa Sh on SH.cd_pes=cd_export_hea
--	Left Join Endereco ENDS on SH.cd_pes=ENDS.cd_pes and ENDS.cd_tp_end = 'COM'
--	left join comunicacao COMS on SH.cd_pes = COMS.cd_pes AND COMS.cd_tp_com = 'TC1'
--	--Left Join Pais PSS on ENDS.UF = PSS.cd_pais 
--	Join Tipo_Moeda TM on TM.cd_tp_moeda=HOU.cd_tp_moeda
--	Left Join nature_goods NG on HOU.num_proc_hea=NG.Num_Proc
--	Left Join Handling_HEA HN on Hou.num_proc_hea = HN.Num_proc_hea 
--	Left Join PESSOA DSP on cd_dsp_hea=DSP.cd_pes
--	Left Join Localidade LCO on HOU.cd_org_hea = LCO.cd_local
--	Left Join Localidade LCD on Hou.cd_dst_hea = LCD.cd_local
--	left join Usuario US on US.cd_usuario = LLP.cd_User_Impres_Lea
--Where
--	hou.Num_Proc_hea=@Processo


GO
