SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from job_exp_mar where num_proc_hem = 'EMARC201711002BR '
CREATE Procedure [dbo].[spHBL_HEM_Rel]--[spHBL_HEM_Rel]'EMOXT201808001BR','Admin','1'

		@Processo 	VarChar (16),
		@User		VarChar(50),
		@Tipo		Char(1)
As

----Antonio 17-10-2024 - LocICS2 verificar a região ------------------------------------------
		declare @LocICS2 bit
 	    set @LocICS2 =(select  reg.LocICS2 from vwHouse_Exp hea with(nolock) 
					   join Localidade loc with(nolock) on loc.Cd_Local = hea.Cd_DstFinal	 
					   join Regiao reg with(nolock) on reg.Cd_Regiao = loc.Cd_Regiao
						        					 and reg.LocICS2 = 1  
					    where hea.Num_Proc =@Processo		
         		)
 -----------------------------------------------------------------------------------------------


	Select
		--Shipper
		SH.Nome_raz_soc					Shipper,
		SH.num_cpf_cnpj					cnpj_S,	
		ENDS.RUA						RUA_S,
		ENDS.BAIRRO						BAIRRO_S,
		ENDS.CIDADE						CIDADE_S,
		UPPER(ENDS.PAIS)				PAIS_S,	
		ENDS.NUMERO						NUMERO_S,	
		UPPER(ENDS.UF)					UF_S,	
		ENDS.CEP						CEP_S,	
		cmcs.cd_int						cd_int_S,
		cmcs.cd_area_fone				cd_areafone_S,
		cmcs.prefixo					prefixo_S,
		cmcs.num_fone					num_fone_S,
		cmcs.compl_fone					compl_fone_S,
	--Consignee
		CS.Nome_raz_soc					Consignee,
		RIGHT(CS.Num_CPF_CNPJ,14)		CNPJ_C,
		ENDC.RUA						RUA_C,
		ENDC.NUMERO						NUM_C,
		ENDC.COMPL_END					COMPL_C,
		ENDC.BAIRRO						BAIRRO_C,
		ENDC.CIDADE						CIDADE_C,
		UPPER(ENDC.PAIS)				PAIS_C,
		ENDC.CEP						CEP_C,
		CMC.contato						CONTATO_C,
		CMC.Depto_Ctt					DEPTO_C,
		CMC.cd_int						cd_int_C,
		CMC.cd_area_fone				cd_areafone_C,
		CMC.prefixo						prefixo_C,
		CMC.num_fone					FONE_C,
		CMC.compl_fone					COMPL_FONE_C,

---------------------Antonio 17-10-2024--------------------------------------------------
			(case when @LocICS2=1 then 
			      'EORIConsignee: ' + isnull([dbo].[fBusca_CampoPessoa](CS.cd_pes,28),'') 
			 else
				  '  '
			 end) EORIConsignee,
-----------------------------------------------------------------------------------------

	--Notify	
		NF.Nome_raz_Soc					Notify,
		RIGHT(NF.Num_CPF_CNPJ,14)		CNPJ_N,
		ENDN.RUA						RUA_N,
		ENDN.BAIRRO						BAIRRO_N,
		ENDN.CIDADE						CIDADE_N,
		ENDN.COMPL_END					COMPL_N,
		ENDN.NUMERO						NUMERO_N,
		ENDN.CEP						CEP_N,
		UPPER(ENDN.PAIS)				PAIS_N,
		CMCN.contato					CONTATO_N,
		CMCN.Depto_Ctt					DEPTO_N,
		CMCN.cd_int						cd_int_N,
		CMCN.cd_area_fone				cd_areafone_N,
		CMCN.prefixo					prefixo_N,
		CMCN.num_fone					FONE_N,
		CMCN.compl_fone					COMPL_FONE_N,

		--Bl
		HOU.Num_Proc_Hem							Num_Proc,
		HOU.HAWB_HEM								Num_BL,	
		convert(varchar(10),LLP.Dt_Impres_LEM,103)	Dated_At,
		dbo.fBusca_Docs_PO_Modal(@Processo,1)		PO,
		LLP.Intl_Ref_Lem							JOB_Ref,
		
		LCO.Pais_Local								Country_Origin,

	--Consignee Master	
		CSNM.Nome_Raz_Soc							ConsigM_Razao,
		right(CSNM.Num_CPF_CNPJ,14)					ConsM_CNPJ,
		EndNM.Rua									ConsM_Rua,
		EndNM.Numero								ConsM_Num,
		EndNM.Compl_End								ConsM_Compl,
		EndNM.Bairro								ConsM_Bairro,
		EndNM.CEP									ConsM_CEP,
		EndNM.Cidade								ConsM_Cidade,
		EndNM.UF									ConsM_UF,
		EndNM.Pais									ConsM_Pais,
		CttNM.Contato								ConsM_Contato,
		('+' + CttNM.Cd_Int + ' ' + CttNM.Cd_Area_Fone + ' ' + CttNM.Prefixo + ' ' + CttNM.Num_Fone) ConsM_Fone,
		CttNM.Compl_Fone							ConsM_Email,

		(Origin.Nome_Local + ', ' + Origin.Pais_Local)			Place_Receipt,	
		(LCO.Nome_Local + ', ' + LCO.Cd_Pais)					Port_Loading,
		--LCD.Nome_Local											Port_Discharge,
		(LCD.Nome_Local	+ ', ' + LCD.Cd_Pais)					Port_Discharge,
		UPPER(LCD.Pais_Local)									Pais_Discharge,
		(DstFinal.Nome_Local + ', ' + DstFinal.Cd_Pais)		Place_Delivery,	

		HOU.Num_Proc_HEM			Num_Proc,
		HOU.Navio_HEM				Navio1,
		HOU.Viagem_HEM				Viagem,
		TC.Nome_Tp_Carga			Tipo_Carga,
		--HOU.Obs_HEM				Marks_Numbers,
		HOU.Peso_Bruto_HEM			Gross_Weight,
		HOU.Peso_Liquido_HEM		Net_Weight,
		HOU.Vol_Tot_hem				Measupement,
		

		(case when dbo.fBusca_Docs_PO_Modal(@Processo,2) is not null then
			'INVOICE: ' + dbo.fBusca_Docs_PO_Modal(@Processo,2)
		else
			null end)				Invoice, 
		'BOOKING: ' + nr_reserva	Booking,
		'MBL: ' + HOU.MAWB_HEM		MBL,
	--	HOU.Qtd_Tot_Vol_HeM			qtd_Pieces,
		--convert(varchar,[dbo].[Qty_Container](@processo))+ ' X ' +
		-- [dbo].[fBusca_Containers_TP](@processo) qtd_Pieces,

	--15/09/2016 - Rafael 
		-- (Case when LLP.Cd_Tp_Carga = 1 then
		--	convert(varchar,[dbo].[Qty_Container](@processo))+ ' X ' + [dbo].[fBusca_Containers_TP](@processo)
		--else
		--	dbo.[fBusca_Volumes_QtdTipo] (@processo)	
		--end) qtd_Pieces,
		dbo.[fBusca_Volumes_QtyEmbal] (@Processo) qtd_Pieces,

		isnull([dbo].[fBusca_CampoCliente](@processo,132),0) NumberOriginals,
		
		ARMADOR_BL.Nome_Armador  ARMADOR_BL,
		--BDP= "EIN23-1878776" e qdo for SilverBirch  = "EIN20-8141384" - vwArmador_HBL_EM
		
		--(case when UPPER(ENDC.CD_pais) = 'CN' THEN
		(case when UPPER(LCD.Cd_Pais) in ('CN','ID','MY')THEN
			CP180.Campo_Dados ELSE
			'' END) 	EIN_Number,
					
		--(case when UPPER(ENDC.CD_pais) = 'CN' THEN
		(case when UPPER(LCD.Cd_Pais) in ('CN','ID','MY')THEN
			CP.Campo_Dados ELSE
			'' END) USCI			
	from
		house_exp_mar Hou with(nolock)
		Left Outer Join	Master_exp_mar		MAS with(nolock)		on MAS.num_proc_mem = HOU.num_proc_mem
		Left Outer Join LLP_exp_mar			LLP with(nolock)		on HOU.Num_Proc_HEM = LLP.Num_Proc_LEM
		Left Outer Join JOB_exp_mar			JOB with(nolock)		on HOU.Num_Proc_HEM = JOB.Num_Proc_HEM

		Left Outer Join Pessoa				SH with(nolock)		on SH.cd_pes = cd_export_hem 
		Left Outer Join Endereco			ENDS with(nolock)	on SH.cd_pes = ENDS.cd_pes and ENDS.cd_tp_end = 'COM' 
		Left Outer Join comunicacao			CMCS with(nolock)	on SH.cd_pes = CMCS.cd_pes and CMCS.cd_tp_com = 'HBL'
		
		Left Outer Join Pessoa				CS with(nolock)		on CS.cd_pes=cd_consig_hem
		Left Outer Join Endereco			ENDC with(nolock)	on CS.cd_pes=ENDC.cd_pes  and ENDC.cd_tp_end = 'COM'	
		Left Outer Join comunicacao			CMC	with(nolock)	on CS.cd_pes = CMC.cd_pes and CMC.cd_tp_com = 'HBL'	
	 
		Left Outer Join Pessoa				NF with(nolock)		on NF.cd_pes = HOU.cd_notify_hem
		Left Outer Join Endereco			ENDN with(nolock)	on NF.cd_pes = ENDN.cd_pes  and ENDN.cd_tp_end = 'COM' 
		Left Outer Join comunicacao			CMCN with(nolock)	on NF.cd_pes = CMCN.cd_pes and CMC.cd_tp_com = 'HBL'
	  
		Left Outer Join Localidade			LCO with(nolock)		on HOU.cd_org_Hem = LCO.cd_local
		Left Outer Join Localidade			LCD with(nolock)		on HOU.cd_dst_hem = LCD.cd_local
		Left Outer Join Localidade			Origin with(nolock)	on LLP.Cd_Planta_Lem	= Origin.Cd_Local
		Left Outer Join Localidade			DstFinal with(nolock) on LLP.cd_dstfinal_lem	= Dstfinal.cd_local
		Left Outer Join Tipo_Carga			TC with(nolock)		on LLP.Cd_Tp_Carga = TC.Cd_Tp_Carga and TC.Ativo_TP = 'S'	
		--Left Outer Join Pessoa			NM		on NM.Cd_Pes		= Cd_Import_hem		
		Left outer Join Pessoa				CSNM with(nolock)	on CSNM.Cd_Pes		= MAS.cd_consig_mem
		Left outer Join Endereco			EndNM with(nolock)	on CSNM.Cd_Pes		= EndNM.Cd_Pes AND EndNM.cd_tp_end='COM'
		Left outer Join Comunicacao			CttNM with(nolock)	on CttNM.Cd_Pes		= CSNM.Cd_Pes and CttNM.Cd_Tp_Com = 'HBL'	

		Left outer Join Campo_Processo		CP179 with(nolock)	on HOU.Num_Proc_HEM = CP179.Num_Proc and CP179.Id_Campo = 179	
		Left Outer Join Armador				ARMADOR_BL with(nolock)	on isnull(CP179.Campo_Dados,'BDP') = ARMADOR_BL.Cd_Armador
		left join Campo_Pessoa				CP on CP.Cd_Pes = CS.Cd_Pes and cp.Id_Campo = '18'
		Left outer Join Campo_Processo		CP180 with(nolock)	on HOU.Num_Proc_HEM = CP180.Num_Proc and CP180.Id_Campo = 180
	where

		HOU.num_proc_hem = @Processo

	group by
		SH.Nome_raz_soc,	SH.num_cpf_cnpj,		ENDS.RUA,	ENDS.BAIRRO,	ENDS.CIDADE,
		ENDS.PAIS,		ENDS.NUMERO,		ENDS.UF,		ENDS.CEP,		cmcs.cd_int,
		cmcs.cd_area_fone,	cmcs.prefixo,	cmcs.num_fone,	cmcs.compl_fone,
		CS.Nome_raz_soc,	cS.Num_CPF_CNPJ,	ENDC.RUA,	ENDC.NUMERO,	ENDC.COMPL_END,
		ENDC.BAIRRO,	ENDC.CIDADE,	ENDC.PAIS,	ENDC.CEP,	CMC.contato,	CMC.Depto_Ctt,
		CMC.cd_int,	CMC.cd_area_fone,	CMC.prefixo,	CMC.num_fone,	CMC.compl_fone,
		NF.Nome_raz_Soc,	NF.Num_CPF_CNPJ,	ENDN.RUA,	ENDN.BAIRRO,	ENDN.CIDADE,
		ENDN.COMPL_END,	ENDN.NUMERO,	ENDN.CEP,	ENDN.PAIS,	CMCN.contato,	CMCN.Depto_Ctt,
		CMCN.cd_int,	CMCN.cd_area_fone,	CMCN.prefixo,	CMCN.num_fone,	CMCN.compl_fone,
		HOU.Num_Proc_Hem,	HOU.HAWB_HEM,		LLP.Dt_Impres_LEM,	--dbo.fBusca_Docs_PO_Modal(@Processo,1)		PO,
		LLP.Intl_Ref_Lem,	HOU.MAWB_HEM,	LCO.Pais_Local,	CSNM.Nome_Raz_Soc,	CSNM.Num_CPF_CNPJ,
		EndNM.Rua,	EndNM.Numero,	EndNM.Compl_End	,	EndNM.Bairro,	EndNM.CEP,	EndNM.Cidade,	EndNM.UF,
		EndNM.Pais,	CttNM.Contato,	('+' + CttNM.Cd_Int + ' ' + CttNM.Cd_Area_Fone + ' ' + CttNM.Prefixo + ' ' + CttNM.Num_Fone),
		CttNM.Compl_Fone,	Origin.Nome_Local,	Origin.Pais_Local,		LCO.Nome_Local,	LCO.Pais_Local,
		LCD.Nome_Local	+ ', ' + LCD.Cd_Pais,	UPPER(LCD.Pais_Local),	(DstFinal.Nome_Local + ', ' + DstFinal.Cd_Pais),
		LCO.Cd_Pais,HOU.Num_Proc_HEM,	HOU.Navio_HEM,	HOU.Viagem_HEM,	TC.Nome_Tp_Carga,	HOU.Peso_Bruto_HEM,
		HOU.Peso_Liquido_HEM,	HOU.Vol_Tot_hem,	HOU.Qtd_Tot_Vol_HeM,	nr_reserva,
		LLP.Cd_Tp_Carga,	ARMADOR_BL.Nome_Armador,	
		ENDC.CD_pais,
		CP180.Campo_Dados,
		CP.Campo_Dados,
		LCD.Cd_Pais,
---------------------Antonio 17-10-2024 ----------------------------------------------------------------------------
		CS.cd_pes
--------------------------------------------------------------------------------------------------------------------

--	-- ALESSANDRA 30/12/2019 - CRIO UM REGISTRO FALSO PARA TER UMA QUEBRA NO RELATÓRIO E PODER EXIBIR A FOLHA A MAIS
--	UNION
	
--	Select
--		--Shipper
--		null					Shipper,
--		null					cnpj_S,	
--		null						RUA_S,
--		null						BAIRRO_S,
--		null						CIDADE_S,
--		null				PAIS_S,	
--		null						NUMERO_S,	
--		null					UF_S,	
--		null						CEP_S,	
--		null						cd_int_S,
--		null				cd_areafone_S,
--		null					prefixo_S,
--		null					num_fone_S,
--		null					compl_fone_S,
--	--Consignee
--		null					Consignee,
--		'wertw'		CNPJ_C,
--		null						RUA_C,
--		null						NUM_C,
--		null					COMPL_C,
--		null						BAIRRO_C,
--		null						CIDADE_C,
--		null				PAIS_C,
--		null						CEP_C,
--		null						CONTATO_C,
--		null					DEPTO_C,
--		null						cd_int_C,
--		null				cd_areafone_C,
--		null						prefixo_C,
--		null					FONE_C,
--		null					COMPL_FONE_C,

--	--Notify	
--		null					Notify,
--		null		CNPJ_N,
--		null						RUA_N,
--		null						BAIRRO_N,
--		null						CIDADE_N,
--		null					COMPL_N,
--		null						NUMERO_N,
--		null						CEP_N,
--		null				PAIS_N,
--		null					CONTATO_N,
--		null					DEPTO_N,
--		null						cd_int_N,
--		null				cd_areafone_N,
--		null					prefixo_N,
--		null					FONE_N,
--		null					COMPL_FONE_N,

--		--Bl
--		null							Num_Proc,
--		null								Num_BL,	
--		null	Dated_At,
--		null		PO,
--		null							JOB_Ref,
		
--		null								Country_Origin,

--	--Consignee Master	
--		null							ConsigM_Razao,
--		null					ConsM_CNPJ,
--		null									ConsM_Rua,
--		null								ConsM_Num,
--		null								ConsM_Compl,
--		null								ConsM_Bairro,
--		null									ConsM_CEP,
--		null								ConsM_Cidade,
--		null									ConsM_UF,
--		null									ConsM_Pais,
--		null								ConsM_Contato,
--		null ConsM_Fone,
--		null							ConsM_Email,

--		null			Place_Receipt,	
--		null					Port_Loading,
--		--LCD.Nome_Local											Port_Discharge,
--		null					Port_Discharge,
--		null									Pais_Discharge,
--		null		Place_Delivery,	

--		null			Num_Proc,
--		null				Navio1,
--		null				Viagem,
--		null			Tipo_Carga,
--		--HOU.Obs_HEM				Marks_Numbers,
--		null			Gross_Weight,
--		null		Net_Weight,
--		null				Measupement,
		

--		null				Invoice, 
--		null	Booking,
--		null		MBL,
	
--		null qtd_Pieces,

--		null NumberOriginals,
		
--		null  ARMADOR_BL,
--		null 	EIN_Number,

--		null USCI			


--	-- ALESSANDRA 30/12/2019 - CRIO UM REGISTRO FALSO PARA TER UMA QUEBRA NO RELATÓRIO E PODER EXIBIR A FOLHA A MAIS
--	UNION
	
--	Select
--		--Shipper
--		null					Shipper,
--		null					cnpj_S,	
--		null						RUA_S,
--		null						BAIRRO_S,
--		null						CIDADE_S,
--		null				PAIS_S,	
--		null						NUMERO_S,	
--		null					UF_S,	
--		null						CEP_S,	
--		null						cd_int_S,
--		null				cd_areafone_S,
--		null					prefixo_S,
--		null					num_fone_S,
--		null					compl_fone_S,
--	--Consignee
--		null					Consignee,
--		'eryjfhj,f'		CNPJ_C,
--		null						RUA_C,
--		null						NUM_C,
--		null					COMPL_C,
--		null						BAIRRO_C,
--		null						CIDADE_C,
--		null				PAIS_C,
--		null						CEP_C,
--		null						CONTATO_C,
--		null					DEPTO_C,
--		null						cd_int_C,
--		null				cd_areafone_C,
--		null						prefixo_C,
--		null					FONE_C,
--		null					COMPL_FONE_C,

--	--Notify	
--		null					Notify,
--		null		CNPJ_N,
--		null						RUA_N,
--		null						BAIRRO_N,
--		null						CIDADE_N,
--		null					COMPL_N,
--		null						NUMERO_N,
--		null						CEP_N,
--		null				PAIS_N,
--		null					CONTATO_N,
--		null					DEPTO_N,
--		null						cd_int_N,
--		null				cd_areafone_N,
--		null					prefixo_N,
--		null					FONE_N,
--		null					COMPL_FONE_N,

--		--Bl
--		null							Num_Proc,
--		null								Num_BL,	
--		null	Dated_At,
--		null		PO,
--		null							JOB_Ref,
		
--		null								Country_Origin,

--	--Consignee Master	
--		null							ConsigM_Razao,
--		null					ConsM_CNPJ,
--		null									ConsM_Rua,
--		null								ConsM_Num,
--		null								ConsM_Compl,
--		null								ConsM_Bairro,
--		null									ConsM_CEP,
--		null								ConsM_Cidade,
--		null									ConsM_UF,
--		null									ConsM_Pais,
--		null								ConsM_Contato,
--		null ConsM_Fone,
--		null							ConsM_Email,

--		null			Place_Receipt,	
--		null					Port_Loading,
--		--LCD.Nome_Local											Port_Discharge,
--		null					Port_Discharge,
--		null									Pais_Discharge,
--		null		Place_Delivery,	

--		null			Num_Proc,
--		null				Navio1,
--		null				Viagem,
--		null			Tipo_Carga,
--		--HOU.Obs_HEM				Marks_Numbers,
--		null			Gross_Weight,
--		null		Net_Weight,
--		null				Measupement,
		

--		null				Invoice, 
--		null	Booking,
--		null		MBL,
	
--		null qtd_Pieces,

--		null NumberOriginals,
		
--		null  ARMADOR_BL,
--		null 	EIN_Number,

--		null USCI		
		
--			-- ALESSANDRA 30/12/2019 - CRIO UM REGISTRO FALSO PARA TER UMA QUEBRA NO RELATÓRIO E PODER EXIBIR A FOLHA A MAIS
--	UNION
	
--	Select
--		--Shipper
--		null					Shipper,
--		null					cnpj_S,	
--		null						RUA_S,
--		null						BAIRRO_S,
--		null						CIDADE_S,
--		null				PAIS_S,	
--		null						NUMERO_S,	
--		null					UF_S,	
--		null						CEP_S,	
--		null						cd_int_S,
--		null				cd_areafone_S,
--		null					prefixo_S,
--		null					num_fone_S,
--		null					compl_fone_S,
--	--Consignee
--		null					Consignee,
--		'jdfjdgfjd'		CNPJ_C,
--		null						RUA_C,
--		null						NUM_C,
--		null					COMPL_C,
--		null						BAIRRO_C,
--		null						CIDADE_C,
--		null				PAIS_C,
--		null						CEP_C,
--		null						CONTATO_C,
--		null					DEPTO_C,
--		null						cd_int_C,
--		null				cd_areafone_C,
--		null						prefixo_C,
--		null					FONE_C,
--		null					COMPL_FONE_C,

--	--Notify	
--		null					Notify,
--		null		CNPJ_N,
--		null						RUA_N,
--		null						BAIRRO_N,
--		null						CIDADE_N,
--		null					COMPL_N,
--		null						NUMERO_N,
--		null						CEP_N,
--		null				PAIS_N,
--		null					CONTATO_N,
--		null					DEPTO_N,
--		null						cd_int_N,
--		null				cd_areafone_N,
--		null					prefixo_N,
--		null					FONE_N,
--		null					COMPL_FONE_N,

--		--Bl
--		null							Num_Proc,
--		null								Num_BL,	
--		null	Dated_At,
--		null		PO,
--		null							JOB_Ref,
		
--		null								Country_Origin,

--	--Consignee Master	
--		null							ConsigM_Razao,
--		null					ConsM_CNPJ,
--		null									ConsM_Rua,
--		null								ConsM_Num,
--		null								ConsM_Compl,
--		null								ConsM_Bairro,
--		null									ConsM_CEP,
--		null								ConsM_Cidade,
--		null									ConsM_UF,
--		null									ConsM_Pais,
--		null								ConsM_Contato,
--		null ConsM_Fone,
--		null							ConsM_Email,

--		null			Place_Receipt,	
--		null					Port_Loading,
--		--LCD.Nome_Local											Port_Discharge,
--		null					Port_Discharge,
--		null									Pais_Discharge,
--		null		Place_Delivery,	

--		null			Num_Proc,
--		null				Navio1,
--		null				Viagem,
--		null			Tipo_Carga,
--		--HOU.Obs_HEM				Marks_Numbers,
--		null			Gross_Weight,
--		null		Net_Weight,
--		null				Measupement,
		

--		null				Invoice, 
--		null	Booking,
--		null		MBL,
	
--		null qtd_Pieces,

--		null NumberOriginals,
		
--		null  ARMADOR_BL,
--		null 	EIN_Number,

--		null USCI		
		
--			-- ALESSANDRA 30/12/2019 - CRIO UM REGISTRO FALSO PARA TER UMA QUEBRA NO RELATÓRIO E PODER EXIBIR A FOLHA A MAIS
--	UNION
	
--	Select
--		--Shipper
--		null					Shipper,
--		null					cnpj_S,	
--		null						RUA_S,
--		null						BAIRRO_S,
--		null						CIDADE_S,
--		null				PAIS_S,	
--		null						NUMERO_S,	
--		null					UF_S,	
--		null						CEP_S,	
--		null						cd_int_S,
--		null				cd_areafone_S,
--		null					prefixo_S,
--		null					num_fone_S,
--		null					compl_fone_S,
--	--Consignee
--		null					Consignee,
--		'hgsfgghkdtyk'		CNPJ_C,
--		null						RUA_C,
--		null						NUM_C,
--		null					COMPL_C,
--		null						BAIRRO_C,
--		null						CIDADE_C,
--		null				PAIS_C,
--		null						CEP_C,
--		null						CONTATO_C,
--		null					DEPTO_C,
--		null						cd_int_C,
--		null				cd_areafone_C,
--		null						prefixo_C,
--		null					FONE_C,
--		null					COMPL_FONE_C,

--	--Notify	
--		null					Notify,
--		null		CNPJ_N,
--		null						RUA_N,
--		null						BAIRRO_N,
--		null						CIDADE_N,
--		null					COMPL_N,
--		null						NUMERO_N,
--		null						CEP_N,
--		null				PAIS_N,
--		null					CONTATO_N,
--		null					DEPTO_N,
--		null						cd_int_N,
--		null				cd_areafone_N,
--		null					prefixo_N,
--		null					FONE_N,
--		null					COMPL_FONE_N,

--		--Bl
--		null							Num_Proc,
--		null								Num_BL,	
--		null	Dated_At,
--		null		PO,
--		null							JOB_Ref,
		
--		null								Country_Origin,

--	--Consignee Master	
--		null							ConsigM_Razao,
--		null					ConsM_CNPJ,
--		null									ConsM_Rua,
--		null								ConsM_Num,
--		null								ConsM_Compl,
--		null								ConsM_Bairro,
--		null									ConsM_CEP,
--		null								ConsM_Cidade,
--		null									ConsM_UF,
--		null									ConsM_Pais,
--		null								ConsM_Contato,
--		null ConsM_Fone,
--		null							ConsM_Email,

--		null			Place_Receipt,	
--		null					Port_Loading,
--		--LCD.Nome_Local											Port_Discharge,
--		null					Port_Discharge,
--		null									Pais_Discharge,
--		null		Place_Delivery,	

--		null			Num_Proc,
--		null				Navio1,
--		null				Viagem,
--		null			Tipo_Carga,
--		--HOU.Obs_HEM				Marks_Numbers,
--		null			Gross_Weight,
--		null		Net_Weight,
--		null				Measupement,
		

--		null				Invoice, 
--		null	Booking,
--		null		MBL,
	
--		null qtd_Pieces,

--		null NumberOriginals,
		
--		null  ARMADOR_BL,
--		null 	EIN_Number,

--		null USCI		
		
--			-- ALESSANDRA 30/12/2019 - CRIO UM REGISTRO FALSO PARA TER UMA QUEBRA NO RELATÓRIO E PODER EXIBIR A FOLHA A MAIS
--	UNION
	
--	Select
--		--Shipper
--		null					Shipper,
--		null					cnpj_S,	
--		null						RUA_S,
--		null						BAIRRO_S,
--		null						CIDADE_S,
--		null				PAIS_S,	
--		null						NUMERO_S,	
--		null					UF_S,	
--		null						CEP_S,	
--		null						cd_int_S,
--		null				cd_areafone_S,
--		null					prefixo_S,
--		null					num_fone_S,
--		null					compl_fone_S,
--	--Consignee
--		null					Consignee,
--		'ghdgkduke'		CNPJ_C,
--		null						RUA_C,
--		null						NUM_C,
--		null					COMPL_C,
--		null						BAIRRO_C,
--		null						CIDADE_C,
--		null				PAIS_C,
--		null						CEP_C,
--		null						CONTATO_C,
--		null					DEPTO_C,
--		null						cd_int_C,
--		null				cd_areafone_C,
--		null						prefixo_C,
--		null					FONE_C,
--		null					COMPL_FONE_C,

--	--Notify	
--		null					Notify,
--		null		CNPJ_N,
--		null						RUA_N,
--		null						BAIRRO_N,
--		null						CIDADE_N,
--		null					COMPL_N,
--		null						NUMERO_N,
--		null						CEP_N,
--		null				PAIS_N,
--		null					CONTATO_N,
--		null					DEPTO_N,
--		null						cd_int_N,
--		null				cd_areafone_N,
--		null					prefixo_N,
--		null					FONE_N,
--		null					COMPL_FONE_N,

--		--Bl
--		null							Num_Proc,
--		null								Num_BL,	
--		null	Dated_At,
--		null		PO,
--		null							JOB_Ref,
		
--		null								Country_Origin,

--	--Consignee Master	
--		null							ConsigM_Razao,
--		null					ConsM_CNPJ,
--		null									ConsM_Rua,
--		null								ConsM_Num,
--		null								ConsM_Compl,
--		null								ConsM_Bairro,
--		null									ConsM_CEP,
--		null								ConsM_Cidade,
--		null									ConsM_UF,
--		null									ConsM_Pais,
--		null								ConsM_Contato,
--		null ConsM_Fone,
--		null							ConsM_Email,

--		null			Place_Receipt,	
--		null					Port_Loading,
--		--LCD.Nome_Local											Port_Discharge,
--		null					Port_Discharge,
--		null									Pais_Discharge,
--		null		Place_Delivery,	

--		null			Num_Proc,
--		null				Navio1,
--		null				Viagem,
--		null			Tipo_Carga,
--		--HOU.Obs_HEM				Marks_Numbers,
--		null			Gross_Weight,
--		null		Net_Weight,
--		null				Measupement,
		

--		null				Invoice, 
--		null	Booking,
--		null		MBL,
	
--		null qtd_Pieces,

--		null NumberOriginals,
		
--		null  ARMADOR_BL,
--		null 	EIN_Number,

--		null USCI		
		
--			-- ALESSANDRA 30/12/2019 - CRIO UM REGISTRO FALSO PARA TER UMA QUEBRA NO RELATÓRIO E PODER EXIBIR A FOLHA A MAIS
--	UNION
	
--	Select
--		--Shipper
--		null					Shipper,
--		null					cnpj_S,	
--		null						RUA_S,
--		null						BAIRRO_S,
--		null						CIDADE_S,
--		null				PAIS_S,	
--		null						NUMERO_S,	
--		null					UF_S,	
--		null						CEP_S,	
--		null						cd_int_S,
--		null				cd_areafone_S,
--		null					prefixo_S,
--		null					num_fone_S,
--		null					compl_fone_S,
--	--Consignee
--		null					Consignee,
--		'sdfgsfgsds'		CNPJ_C,
--		null						RUA_C,
--		null						NUM_C,
--		null					COMPL_C,
--		null						BAIRRO_C,
--		null						CIDADE_C,
--		null				PAIS_C,
--		null						CEP_C,
--		null						CONTATO_C,
--		null					DEPTO_C,
--		null						cd_int_C,
--		null				cd_areafone_C,
--		null						prefixo_C,
--		null					FONE_C,
--		null					COMPL_FONE_C,

--	--Notify	
--		null					Notify,
--		null		CNPJ_N,
--		null						RUA_N,
--		null						BAIRRO_N,
--		null						CIDADE_N,
--		null					COMPL_N,
--		null						NUMERO_N,
--		null						CEP_N,
--		null				PAIS_N,
--		null					CONTATO_N,
--		null					DEPTO_N,
--		null						cd_int_N,
--		null				cd_areafone_N,
--		null					prefixo_N,
--		null					FONE_N,
--		null					COMPL_FONE_N,

--		--Bl
--		null							Num_Proc,
--		null								Num_BL,	
--		null	Dated_At,
--		null		PO,
--		null							JOB_Ref,
		
--		null								Country_Origin,

--	--Consignee Master	
--		null							ConsigM_Razao,
--		null					ConsM_CNPJ,
--		null									ConsM_Rua,
--		null								ConsM_Num,
--		null								ConsM_Compl,
--		null								ConsM_Bairro,
--		null									ConsM_CEP,
--		null								ConsM_Cidade,
--		null									ConsM_UF,
--		null									ConsM_Pais,
--		null								ConsM_Contato,
--		null ConsM_Fone,
--		null							ConsM_Email,

--		null			Place_Receipt,	
--		null					Port_Loading,
--		--LCD.Nome_Local											Port_Discharge,
--		null					Port_Discharge,
--		null									Pais_Discharge,
--		null		Place_Delivery,	

--		null			Num_Proc,
--		null				Navio1,
--		null				Viagem,
--		null			Tipo_Carga,
--		--HOU.Obs_HEM				Marks_Numbers,
--		null			Gross_Weight,
--		null		Net_Weight,
--		null				Measupement,
		

--		null				Invoice, 
--		null	Booking,
--		null		MBL,
	
--		null qtd_Pieces,

--		null NumberOriginals,
		
--		null  ARMADOR_BL,
--		null 	EIN_Number,

--		null USCI		
		
--			-- ALESSANDRA 30/12/2019 - CRIO UM REGISTRO FALSO PARA TER UMA QUEBRA NO RELATÓRIO E PODER EXIBIR A FOLHA A MAIS
--	UNION
	
--	Select
--		--Shipper
--		null					Shipper,
--		null					cnpj_S,	
--		null						RUA_S,
--		null						BAIRRO_S,
--		null						CIDADE_S,
--		null				PAIS_S,	
--		null						NUMERO_S,	
--		null					UF_S,	
--		null						CEP_S,	
--		null						cd_int_S,
--		null				cd_areafone_S,
--		null					prefixo_S,
--		null					num_fone_S,
--		null					compl_fone_S,
--	--Consignee
--		null					Consignee,
--		'dfgasdfa'		CNPJ_C,
--		null						RUA_C,
--		null						NUM_C,
--		null					COMPL_C,
--		null						BAIRRO_C,
--		null						CIDADE_C,
--		null				PAIS_C,
--		null						CEP_C,
--		null						CONTATO_C,
--		null					DEPTO_C,
--		null						cd_int_C,
--		null				cd_areafone_C,
--		null						prefixo_C,
--		null					FONE_C,
--		null					COMPL_FONE_C,

--	--Notify	
--		null					Notify,
--		null		CNPJ_N,
--		null						RUA_N,
--		null						BAIRRO_N,
--		null						CIDADE_N,
--		null					COMPL_N,
--		null						NUMERO_N,
--		null						CEP_N,
--		null				PAIS_N,
--		null					CONTATO_N,
--		null					DEPTO_N,
--		null						cd_int_N,
--		null				cd_areafone_N,
--		null					prefixo_N,
--		null					FONE_N,
--		null					COMPL_FONE_N,

--		--Bl
--		null							Num_Proc,
--		null								Num_BL,	
--		null	Dated_At,
--		null		PO,
--		null							JOB_Ref,
		
--		null								Country_Origin,

--	--Consignee Master	
--		null							ConsigM_Razao,
--		null					ConsM_CNPJ,
--		null									ConsM_Rua,
--		null								ConsM_Num,
--		null								ConsM_Compl,
--		null								ConsM_Bairro,
--		null									ConsM_CEP,
--		null								ConsM_Cidade,
--		null									ConsM_UF,
--		null									ConsM_Pais,
--		null								ConsM_Contato,
--		null ConsM_Fone,
--		null							ConsM_Email,

--		null			Place_Receipt,	
--		null					Port_Loading,
--		--LCD.Nome_Local											Port_Discharge,
--		null					Port_Discharge,
--		null									Pais_Discharge,
--		null		Place_Delivery,	

--		null			Num_Proc,
--		null				Navio1,
--		null				Viagem,
--		null			Tipo_Carga,
--		--HOU.Obs_HEM				Marks_Numbers,
--		null			Gross_Weight,
--		null		Net_Weight,
--		null				Measupement,
		

--		null				Invoice, 
--		null	Booking,
--		null		MBL,
	
--		null qtd_Pieces,

--		null NumberOriginals,
		
--		null  ARMADOR_BL,
--		null 	EIN_Number,

--		null USCI		
		
--			-- ALESSANDRA 30/12/2019 - CRIO UM REGISTRO FALSO PARA TER UMA QUEBRA NO RELATÓRIO E PODER EXIBIR A FOLHA A MAIS
--	UNION
	
--	Select
--		--Shipper
--		null					Shipper,
--		null					cnpj_S,	
--		null						RUA_S,
--		null						BAIRRO_S,
--		null						CIDADE_S,
--		null				PAIS_S,	
--		null						NUMERO_S,	
--		null					UF_S,	
--		null						CEP_S,	
--		null						cd_int_S,
--		null				cd_areafone_S,
--		null					prefixo_S,
--		null					num_fone_S,
--		null					compl_fone_S,
--	--Consignee
--		null					Consignee,
--		'sdfaqw4t'		CNPJ_C,
--		null						RUA_C,
--		null						NUM_C,
--		null					COMPL_C,
--		null						BAIRRO_C,
--		null						CIDADE_C,
--		null				PAIS_C,
--		null						CEP_C,
--		null						CONTATO_C,
--		null					DEPTO_C,
--		null						cd_int_C,
--		null				cd_areafone_C,
--		null						prefixo_C,
--		null					FONE_C,
--		null					COMPL_FONE_C,

--	--Notify	
--		null					Notify,
--		null		CNPJ_N,
--		null						RUA_N,
--		null						BAIRRO_N,
--		null						CIDADE_N,
--		null					COMPL_N,
--		null						NUMERO_N,
--		null						CEP_N,
--		null				PAIS_N,
--		null					CONTATO_N,
--		null					DEPTO_N,
--		null						cd_int_N,
--		null				cd_areafone_N,
--		null					prefixo_N,
--		null					FONE_N,
--		null					COMPL_FONE_N,

--		--Bl
--		null							Num_Proc,
--		null								Num_BL,	
--		null	Dated_At,
--		null		PO,
--		null							JOB_Ref,
		
--		null								Country_Origin,

--	--Consignee Master	
--		null							ConsigM_Razao,
--		null					ConsM_CNPJ,
--		null									ConsM_Rua,
--		null								ConsM_Num,
--		null								ConsM_Compl,
--		null								ConsM_Bairro,
--		null									ConsM_CEP,
--		null								ConsM_Cidade,
--		null									ConsM_UF,
--		null									ConsM_Pais,
--		null								ConsM_Contato,
--		null ConsM_Fone,
--		null							ConsM_Email,

--		null			Place_Receipt,	
--		null					Port_Loading,
--		--LCD.Nome_Local											Port_Discharge,
--		null					Port_Discharge,
--		null									Pais_Discharge,
--		null		Place_Delivery,	

--		null			Num_Proc,
--		null				Navio1,
--		null				Viagem,
--		null			Tipo_Carga,
--		--HOU.Obs_HEM				Marks_Numbers,
--		null			Gross_Weight,
--		null		Net_Weight,
--		null				Measupement,
		

--		null				Invoice, 
--		null	Booking,
--		null		MBL,
	
--		null qtd_Pieces,

--		null NumberOriginals,
		
--		null  ARMADOR_BL,
--		null 	EIN_Number,

--		null USCI		
		
--			-- ALESSANDRA 30/12/2019 - CRIO UM REGISTRO FALSO PARA TER UMA QUEBRA NO RELATÓRIO E PODER EXIBIR A FOLHA A MAIS
--	UNION
	
--	Select
--		--Shipper
--		null					Shipper,
--		null					cnpj_S,	
--		null						RUA_S,
--		null						BAIRRO_S,
--		null						CIDADE_S,
--		null				PAIS_S,	
--		null						NUMERO_S,	
--		null					UF_S,	
--		null						CEP_S,	
--		null						cd_int_S,
--		null				cd_areafone_S,
--		null					prefixo_S,
--		null					num_fone_S,
--		null					compl_fone_S,
--	--Consignee
--		null					Consignee,
--		'w34sdfbs'		CNPJ_C,
--		null						RUA_C,
--		null						NUM_C,
--		null					COMPL_C,
--		null						BAIRRO_C,
--		null						CIDADE_C,
--		null				PAIS_C,
--		null						CEP_C,
--		null						CONTATO_C,
--		null					DEPTO_C,
--		null						cd_int_C,
--		null				cd_areafone_C,
--		null						prefixo_C,
--		null					FONE_C,
--		null					COMPL_FONE_C,

--	--Notify	
--		null					Notify,
--		null		CNPJ_N,
--		null						RUA_N,
--		null						BAIRRO_N,
--		null						CIDADE_N,
--		null					COMPL_N,
--		null						NUMERO_N,
--		null						CEP_N,
--		null				PAIS_N,
--		null					CONTATO_N,
--		null					DEPTO_N,
--		null						cd_int_N,
--		null				cd_areafone_N,
--		null					prefixo_N,
--		null					FONE_N,
--		null					COMPL_FONE_N,

--		--Bl
--		null							Num_Proc,
--		null								Num_BL,	
--		null	Dated_At,
--		null		PO,
--		null							JOB_Ref,
		
--		null								Country_Origin,

--	--Consignee Master	
--		null							ConsigM_Razao,
--		null					ConsM_CNPJ,
--		null									ConsM_Rua,
--		null								ConsM_Num,
--		null								ConsM_Compl,
--		null								ConsM_Bairro,
--		null									ConsM_CEP,
--		null								ConsM_Cidade,
--		null									ConsM_UF,
--		null									ConsM_Pais,
--		null								ConsM_Contato,
--		null ConsM_Fone,
--		null							ConsM_Email,

--		null			Place_Receipt,	
--		null					Port_Loading,
--		--LCD.Nome_Local											Port_Discharge,
--		null					Port_Discharge,
--		null									Pais_Discharge,
--		null		Place_Delivery,	

--		null			Num_Proc,
--		null				Navio1,
--		null				Viagem,
--		null			Tipo_Carga,
--		--HOU.Obs_HEM				Marks_Numbers,
--		null			Gross_Weight,
--		null		Net_Weight,
--		null				Measupement,
		

--		null				Invoice, 
--		null	Booking,
--		null		MBL,
	
--		null qtd_Pieces,

--		null NumberOriginals,
		
--		null  ARMADOR_BL,
--		null 	EIN_Number,

--		null USCI		
		
--			-- ALESSANDRA 30/12/2019 - CRIO UM REGISTRO FALSO PARA TER UMA QUEBRA NO RELATÓRIO E PODER EXIBIR A FOLHA A MAIS
--	UNION
	
--	Select
--		--Shipper
--		null					Shipper,
--		null					cnpj_S,	
--		null						RUA_S,
--		null						BAIRRO_S,
--		null						CIDADE_S,
--		null				PAIS_S,	
--		null						NUMERO_S,	
--		null					UF_S,	
--		null						CEP_S,	
--		null						cd_int_S,
--		null				cd_areafone_S,
--		null					prefixo_S,
--		null					num_fone_S,
--		null					compl_fone_S,
--	--Consignee
--		null					Consignee,
--		'xsgbxstusr5tg'		CNPJ_C,
--		null						RUA_C,
--		null						NUM_C,
--		null					COMPL_C,
--		null						BAIRRO_C,
--		null						CIDADE_C,
--		null				PAIS_C,
--		null						CEP_C,
--		null						CONTATO_C,
--		null					DEPTO_C,
--		null						cd_int_C,
--		null				cd_areafone_C,
--		null						prefixo_C,
--		null					FONE_C,
--		null					COMPL_FONE_C,

--	--Notify	
--		null					Notify,
--		null		CNPJ_N,
--		null						RUA_N,
--		null						BAIRRO_N,
--		null						CIDADE_N,
--		null					COMPL_N,
--		null						NUMERO_N,
--		null						CEP_N,
--		null				PAIS_N,
--		null					CONTATO_N,
--		null					DEPTO_N,
--		null						cd_int_N,
--		null				cd_areafone_N,
--		null					prefixo_N,
--		null					FONE_N,
--		null					COMPL_FONE_N,

--		--Bl
--		null							Num_Proc,
--		null								Num_BL,	
--		null	Dated_At,
--		null		PO,
--		null							JOB_Ref,
		
--		null								Country_Origin,

--	--Consignee Master	
--		null							ConsigM_Razao,
--		null					ConsM_CNPJ,
--		null									ConsM_Rua,
--		null								ConsM_Num,
--		null								ConsM_Compl,
--		null								ConsM_Bairro,
--		null									ConsM_CEP,
--		null								ConsM_Cidade,
--		null									ConsM_UF,
--		null									ConsM_Pais,
--		null								ConsM_Contato,
--		null ConsM_Fone,
--		null							ConsM_Email,

--		null			Place_Receipt,	
--		null					Port_Loading,
--		--LCD.Nome_Local											Port_Discharge,
--		null					Port_Discharge,
--		null									Pais_Discharge,
--		null		Place_Delivery,	

--		null			Num_Proc,
--		null				Navio1,
--		null				Viagem,
--		null			Tipo_Carga,
--		--HOU.Obs_HEM				Marks_Numbers,
--		null			Gross_Weight,
--		null		Net_Weight,
--		null				Measupement,
		

--		null				Invoice, 
--		null	Booking,
--		null		MBL,
	
--		null qtd_Pieces,

--		null NumberOriginals,
		
--		null  ARMADOR_BL,
--		null 	EIN_Number,

--		null USCI		
		
--			-- ALESSANDRA 30/12/2019 - CRIO UM REGISTRO FALSO PARA TER UMA QUEBRA NO RELATÓRIO E PODER EXIBIR A FOLHA A MAIS
--	UNION
	
--	Select
--		--Shipper
--		null					Shipper,
--		null					cnpj_S,	
--		null						RUA_S,
--		null						BAIRRO_S,
--		null						CIDADE_S,
--		null				PAIS_S,	
--		null						NUMERO_S,	
--		null					UF_S,	
--		null						CEP_S,	
--		null						cd_int_S,
--		null				cd_areafone_S,
--		null					prefixo_S,
--		null					num_fone_S,
--		null					compl_fone_S,
--	--Consignee
--		null					Consignee,
--		'dfbn dfhsdf'		CNPJ_C,
--		null						RUA_C,
--		null						NUM_C,
--		null					COMPL_C,
--		null						BAIRRO_C,
--		null						CIDADE_C,
--		null				PAIS_C,
--		null						CEP_C,
--		null						CONTATO_C,
--		null					DEPTO_C,
--		null						cd_int_C,
--		null				cd_areafone_C,
--		null						prefixo_C,
--		null					FONE_C,
--		null					COMPL_FONE_C,

--	--Notify	
--		null					Notify,
--		null		CNPJ_N,
--		null						RUA_N,
--		null						BAIRRO_N,
--		null						CIDADE_N,
--		null					COMPL_N,
--		null						NUMERO_N,
--		null						CEP_N,
--		null				PAIS_N,
--		null					CONTATO_N,
--		null					DEPTO_N,
--		null						cd_int_N,
--		null				cd_areafone_N,
--		null					prefixo_N,
--		null					FONE_N,
--		null					COMPL_FONE_N,

--		--Bl
--		null							Num_Proc,
--		null								Num_BL,	
--		null	Dated_At,
--		null		PO,
--		null							JOB_Ref,
		
--		null								Country_Origin,

--	--Consignee Master	
--		null							ConsigM_Razao,
--		null					ConsM_CNPJ,
--		null									ConsM_Rua,
--		null								ConsM_Num,
--		null								ConsM_Compl,
--		null								ConsM_Bairro,
--		null									ConsM_CEP,
--		null								ConsM_Cidade,
--		null									ConsM_UF,
--		null									ConsM_Pais,
--		null								ConsM_Contato,
--		null ConsM_Fone,
--		null							ConsM_Email,

--		null			Place_Receipt,	
--		null					Port_Loading,
--		--LCD.Nome_Local											Port_Discharge,
--		null					Port_Discharge,
--		null									Pais_Discharge,
--		null		Place_Delivery,	

--		null			Num_Proc,
--		null				Navio1,
--		null				Viagem,
--		null			Tipo_Carga,
--		--HOU.Obs_HEM				Marks_Numbers,
--		null			Gross_Weight,
--		null		Net_Weight,
--		null				Measupement,
		

--		null				Invoice, 
--		null	Booking,
--		null		MBL,
	
--		null qtd_Pieces,

--		null NumberOriginals,
		
--		null  ARMADOR_BL,
--		null 	EIN_Number,

--		null USCI		
		
--			-- ALESSANDRA 30/12/2019 - CRIO UM REGISTRO FALSO PARA TER UMA QUEBRA NO RELATÓRIO E PODER EXIBIR A FOLHA A MAIS
--	UNION
	
--	Select
--		--Shipper
--		null					Shipper,
--		null					cnpj_S,	
--		null						RUA_S,
--		null						BAIRRO_S,
--		null						CIDADE_S,
--		null				PAIS_S,	
--		null						NUMERO_S,	
--		null					UF_S,	
--		null						CEP_S,	
--		null						cd_int_S,
--		null				cd_areafone_S,
--		null					prefixo_S,
--		null					num_fone_S,
--		null					compl_fone_S,
--	--Consignee
--		null					Consignee,
--		'dfhwejusrk'		CNPJ_C,
--		null						RUA_C,
--		null						NUM_C,
--		null					COMPL_C,
--		null						BAIRRO_C,
--		null						CIDADE_C,
--		null				PAIS_C,
--		null						CEP_C,
--		null						CONTATO_C,
--		null					DEPTO_C,
--		null						cd_int_C,
--		null				cd_areafone_C,
--		null						prefixo_C,
--		null					FONE_C,
--		null					COMPL_FONE_C,

--	--Notify	
--		null					Notify,
--		null		CNPJ_N,
--		null						RUA_N,
--		null						BAIRRO_N,
--		null						CIDADE_N,
--		null					COMPL_N,
--		null						NUMERO_N,
--		null						CEP_N,
--		null				PAIS_N,
--		null					CONTATO_N,
--		null					DEPTO_N,
--		null						cd_int_N,
--		null				cd_areafone_N,
--		null					prefixo_N,
--		null					FONE_N,
--		null					COMPL_FONE_N,

--		--Bl
--		null							Num_Proc,
--		null								Num_BL,	
--		null	Dated_At,
--		null		PO,
--		null							JOB_Ref,
		
--		null								Country_Origin,

--	--Consignee Master	
--		null							ConsigM_Razao,
--		null					ConsM_CNPJ,
--		null									ConsM_Rua,
--		null								ConsM_Num,
--		null								ConsM_Compl,
--		null								ConsM_Bairro,
--		null									ConsM_CEP,
--		null								ConsM_Cidade,
--		null									ConsM_UF,
--		null									ConsM_Pais,
--		null								ConsM_Contato,
--		null ConsM_Fone,
--		null							ConsM_Email,

--		null			Place_Receipt,	
--		null					Port_Loading,
--		--LCD.Nome_Local											Port_Discharge,
--		null					Port_Discharge,
--		null									Pais_Discharge,
--		null		Place_Delivery,	

--		null			Num_Proc,
--		null				Navio1,
--		null				Viagem,
--		null			Tipo_Carga,
--		--HOU.Obs_HEM				Marks_Numbers,
--		null			Gross_Weight,
--		null		Net_Weight,
--		null				Measupement,
		

--		null				Invoice, 
--		null	Booking,
--		null		MBL,
	
--		null qtd_Pieces,

--		null NumberOriginals,
		
--		null  ARMADOR_BL,
--		null 	EIN_Number,

--		null USCI		
		
		
--			-- ALESSANDRA 30/12/2019 - CRIO UM REGISTRO FALSO PARA TER UMA QUEBRA NO RELATÓRIO E PODER EXIBIR A FOLHA A MAIS
--	UNION
	
--	Select
--		--Shipper
--		null					Shipper,
--		null					cnpj_S,	
--		null						RUA_S,
--		null						BAIRRO_S,
--		null						CIDADE_S,
--		null				PAIS_S,	
--		null						NUMERO_S,	
--		null					UF_S,	
--		null						CEP_S,	
--		null						cd_int_S,
--		null				cd_areafone_S,
--		null					prefixo_S,
--		null					num_fone_S,
--		null					compl_fone_S,
--	--Consignee
--		null					Consignee,
--		'zdfnsrjsrt'		CNPJ_C,
--		null						RUA_C,
--		null						NUM_C,
--		null					COMPL_C,
--		null						BAIRRO_C,
--		null						CIDADE_C,
--		null				PAIS_C,
--		null						CEP_C,
--		null						CONTATO_C,
--		null					DEPTO_C,
--		null						cd_int_C,
--		null				cd_areafone_C,
--		null						prefixo_C,
--		null					FONE_C,
--		null					COMPL_FONE_C,

--	--Notify	
--		null					Notify,
--		null		CNPJ_N,
--		null						RUA_N,
--		null						BAIRRO_N,
--		null						CIDADE_N,
--		null					COMPL_N,
--		null						NUMERO_N,
--		null						CEP_N,
--		null				PAIS_N,
--		null					CONTATO_N,
--		null					DEPTO_N,
--		null						cd_int_N,
--		null				cd_areafone_N,
--		null					prefixo_N,
--		null					FONE_N,
--		null					COMPL_FONE_N,

--		--Bl
--		null							Num_Proc,
--		null								Num_BL,	
--		null	Dated_At,
--		null		PO,
--		null							JOB_Ref,
		
--		null								Country_Origin,

--	--Consignee Master	
--		null							ConsigM_Razao,
--		null					ConsM_CNPJ,
--		null									ConsM_Rua,
--		null								ConsM_Num,
--		null								ConsM_Compl,
--		null								ConsM_Bairro,
--		null									ConsM_CEP,
--		null								ConsM_Cidade,
--		null									ConsM_UF,
--		null									ConsM_Pais,
--		null								ConsM_Contato,
--		null ConsM_Fone,
--		null							ConsM_Email,

--		null			Place_Receipt,	
--		null					Port_Loading,
--		--LCD.Nome_Local											Port_Discharge,
--		null					Port_Discharge,
--		null									Pais_Discharge,
--		null		Place_Delivery,	

--		null			Num_Proc,
--		null				Navio1,
--		null				Viagem,
--		null			Tipo_Carga,
--		--HOU.Obs_HEM				Marks_Numbers,
--		null			Gross_Weight,
--		null		Net_Weight,
--		null				Measupement,
		

--		null				Invoice, 
--		null	Booking,
--		null		MBL,
	
--		null qtd_Pieces,

--		null NumberOriginals,
		
--		null  ARMADOR_BL,
--		null 	EIN_Number,

--		null USCI		
		
		
--			-- ALESSANDRA 30/12/2019 - CRIO UM REGISTRO FALSO PARA TER UMA QUEBRA NO RELATÓRIO E PODER EXIBIR A FOLHA A MAIS
--	UNION
	
--	Select
--		--Shipper
--		null					Shipper,
--		null					cnpj_S,	
--		null						RUA_S,
--		null						BAIRRO_S,
--		null						CIDADE_S,
--		null				PAIS_S,	
--		null						NUMERO_S,	
--		null					UF_S,	
--		null						CEP_S,	
--		null						cd_int_S,
--		null				cd_areafone_S,
--		null					prefixo_S,
--		null					num_fone_S,
--		null					compl_fone_S,
--	--Consignee
--		null					Consignee,
--		'zcnzdgjzsdtr'		CNPJ_C,
--		null						RUA_C,
--		null						NUM_C,
--		null					COMPL_C,
--		null						BAIRRO_C,
--		null						CIDADE_C,
--		null				PAIS_C,
--		null						CEP_C,
--		null						CONTATO_C,
--		null					DEPTO_C,
--		null						cd_int_C,
--		null				cd_areafone_C,
--		null						prefixo_C,
--		null					FONE_C,
--		null					COMPL_FONE_C,

--	--Notify	
--		null					Notify,
--		null		CNPJ_N,
--		null						RUA_N,
--		null						BAIRRO_N,
--		null						CIDADE_N,
--		null					COMPL_N,
--		null						NUMERO_N,
--		null						CEP_N,
--		null				PAIS_N,
--		null					CONTATO_N,
--		null					DEPTO_N,
--		null						cd_int_N,
--		null				cd_areafone_N,
--		null					prefixo_N,
--		null					FONE_N,
--		null					COMPL_FONE_N,

--		--Bl
--		null							Num_Proc,
--		null								Num_BL,	
--		null	Dated_At,
--		null		PO,
--		null							JOB_Ref,
		
--		null								Country_Origin,

--	--Consignee Master	
--		null							ConsigM_Razao,
--		null					ConsM_CNPJ,
--		null									ConsM_Rua,
--		null								ConsM_Num,
--		null								ConsM_Compl,
--		null								ConsM_Bairro,
--		null									ConsM_CEP,
--		null								ConsM_Cidade,
--		null									ConsM_UF,
--		null									ConsM_Pais,
--		null								ConsM_Contato,
--		null ConsM_Fone,
--		null							ConsM_Email,

--		null			Place_Receipt,	
--		null					Port_Loading,
--		--LCD.Nome_Local											Port_Discharge,
--		null					Port_Discharge,
--		null									Pais_Discharge,
--		null		Place_Delivery,	

--		null			Num_Proc,
--		null				Navio1,
--		null				Viagem,
--		null			Tipo_Carga,
--		--HOU.Obs_HEM				Marks_Numbers,
--		null			Gross_Weight,
--		null		Net_Weight,
--		null				Measupement,
		

--		null				Invoice, 
--		null	Booking,
--		null		MBL,
	
--		null qtd_Pieces,

--		null NumberOriginals,
		
--		null  ARMADOR_BL,
--		null 	EIN_Number,

--		null USCI		
		
		
--			-- ALESSANDRA 30/12/2019 - CRIO UM REGISTRO FALSO PARA TER UMA QUEBRA NO RELATÓRIO E PODER EXIBIR A FOLHA A MAIS
--	UNION
	
--	Select
--		--Shipper
--		null					Shipper,
--		null					cnpj_S,	
--		null						RUA_S,
--		null						BAIRRO_S,
--		null						CIDADE_S,
--		null				PAIS_S,	
--		null						NUMERO_S,	
--		null					UF_S,	
--		null						CEP_S,	
--		null						cd_int_S,
--		null				cd_areafone_S,
--		null					prefixo_S,
--		null					num_fone_S,
--		null					compl_fone_S,
--	--Consignee
--		null					Consignee,
--		'zdfmdstyks'		CNPJ_C,
--		null						RUA_C,
--		null						NUM_C,
--		null					COMPL_C,
--		null						BAIRRO_C,
--		null						CIDADE_C,
--		null				PAIS_C,
--		null						CEP_C,
--		null						CONTATO_C,
--		null					DEPTO_C,
--		null						cd_int_C,
--		null				cd_areafone_C,
--		null						prefixo_C,
--		null					FONE_C,
--		null					COMPL_FONE_C,

--	--Notify	
--		null					Notify,
--		null		CNPJ_N,
--		null						RUA_N,
--		null						BAIRRO_N,
--		null						CIDADE_N,
--		null					COMPL_N,
--		null						NUMERO_N,
--		null						CEP_N,
--		null				PAIS_N,
--		null					CONTATO_N,
--		null					DEPTO_N,
--		null						cd_int_N,
--		null				cd_areafone_N,
--		null					prefixo_N,
--		null					FONE_N,
--		null					COMPL_FONE_N,

--		--Bl
--		null							Num_Proc,
--		null								Num_BL,	
--		null	Dated_At,
--		null		PO,
--		null							JOB_Ref,
		
--		null								Country_Origin,

--	--Consignee Master	
--		null							ConsigM_Razao,
--		null					ConsM_CNPJ,
--		null									ConsM_Rua,
--		null								ConsM_Num,
--		null								ConsM_Compl,
--		null								ConsM_Bairro,
--		null									ConsM_CEP,
--		null								ConsM_Cidade,
--		null									ConsM_UF,
--		null									ConsM_Pais,
--		null								ConsM_Contato,
--		null ConsM_Fone,
--		null							ConsM_Email,

--		null			Place_Receipt,	
--		null					Port_Loading,
--		--LCD.Nome_Local											Port_Discharge,
--		null					Port_Discharge,
--		null									Pais_Discharge,
--		null		Place_Delivery,	

--		null			Num_Proc,
--		null				Navio1,
--		null				Viagem,
--		null			Tipo_Carga,
--		--HOU.Obs_HEM				Marks_Numbers,
--		null			Gross_Weight,
--		null		Net_Weight,
--		null				Measupement,
		

--		null				Invoice, 
--		null	Booking,
--		null		MBL,
	
--		null qtd_Pieces,

--		null NumberOriginals,
		
--		null  ARMADOR_BL,
--		null 	EIN_Number,

--		null USCI		
		
		
--			-- ALESSANDRA 30/12/2019 - CRIO UM REGISTRO FALSO PARA TER UMA QUEBRA NO RELATÓRIO E PODER EXIBIR A FOLHA A MAIS
--	UNION
	
--	Select
--		--Shipper
--		null					Shipper,
--		null					cnpj_S,	
--		null						RUA_S,
--		null						BAIRRO_S,
--		null						CIDADE_S,
--		null				PAIS_S,	
--		null						NUMERO_S,	
--		null					UF_S,	
--		null						CEP_S,	
--		null						cd_int_S,
--		null				cd_areafone_S,
--		null					prefixo_S,
--		null					num_fone_S,
--		null					compl_fone_S,
--	--Consignee
--		null					Consignee,
--		'sfhsedf'		CNPJ_C,
--		null						RUA_C,
--		null						NUM_C,
--		null					COMPL_C,
--		null						BAIRRO_C,
--		null						CIDADE_C,
--		null				PAIS_C,
--		null						CEP_C,
--		null						CONTATO_C,
--		null					DEPTO_C,
--		null						cd_int_C,
--		null				cd_areafone_C,
--		null						prefixo_C,
--		null					FONE_C,
--		null					COMPL_FONE_C,

--	--Notify	
--		null					Notify,
--		null		CNPJ_N,
--		null						RUA_N,
--		null						BAIRRO_N,
--		null						CIDADE_N,
--		null					COMPL_N,
--		null						NUMERO_N,
--		null						CEP_N,
--		null				PAIS_N,
--		null					CONTATO_N,
--		null					DEPTO_N,
--		null						cd_int_N,
--		null				cd_areafone_N,
--		null					prefixo_N,
--		null					FONE_N,
--		null					COMPL_FONE_N,

--		--Bl
--		null							Num_Proc,
--		null								Num_BL,	
--		null	Dated_At,
--		null		PO,
--		null							JOB_Ref,
		
--		null								Country_Origin,

--	--Consignee Master	
--		null							ConsigM_Razao,
--		null					ConsM_CNPJ,
--		null									ConsM_Rua,
--		null								ConsM_Num,
--		null								ConsM_Compl,
--		null								ConsM_Bairro,
--		null									ConsM_CEP,
--		null								ConsM_Cidade,
--		null									ConsM_UF,
--		null									ConsM_Pais,
--		null								ConsM_Contato,
--		null ConsM_Fone,
--		null							ConsM_Email,

--		null			Place_Receipt,	
--		null					Port_Loading,
--		--LCD.Nome_Local											Port_Discharge,
--		null					Port_Discharge,
--		null									Pais_Discharge,
--		null		Place_Delivery,	

--		null			Num_Proc,
--		null				Navio1,
--		null				Viagem,
--		null			Tipo_Carga,
--		--HOU.Obs_HEM				Marks_Numbers,
--		null			Gross_Weight,
--		null		Net_Weight,
--		null				Measupement,
		

--		null				Invoice, 
--		null	Booking,
--		null		MBL,
	
--		null qtd_Pieces,

--		null NumberOriginals,
		
--		null  ARMADOR_BL,
--		null 	EIN_Number,

--		null USCI		
		
		
--			-- ALESSANDRA 30/12/2019 - CRIO UM REGISTRO FALSO PARA TER UMA QUEBRA NO RELATÓRIO E PODER EXIBIR A FOLHA A MAIS
--	UNION
	
--	Select
--		--Shipper
--		null					Shipper,
--		null					cnpj_S,	
--		null						RUA_S,
--		null						BAIRRO_S,
--		null						CIDADE_S,
--		null				PAIS_S,	
--		null						NUMERO_S,	
--		null					UF_S,	
--		null						CEP_S,	
--		null						cd_int_S,
--		null				cd_areafone_S,
--		null					prefixo_S,
--		null					num_fone_S,
--		null					compl_fone_S,
--	--Consignee
--		null					Consignee,
--		'zfbzdh'		CNPJ_C,
--		null						RUA_C,
--		null						NUM_C,
--		null					COMPL_C,
--		null						BAIRRO_C,
--		null						CIDADE_C,
--		null				PAIS_C,
--		null						CEP_C,
--		null						CONTATO_C,
--		null					DEPTO_C,
--		null						cd_int_C,
--		null				cd_areafone_C,
--		null						prefixo_C,
--		null					FONE_C,
--		null					COMPL_FONE_C,

--	--Notify	
--		null					Notify,
--		null		CNPJ_N,
--		null						RUA_N,
--		null						BAIRRO_N,
--		null						CIDADE_N,
--		null					COMPL_N,
--		null						NUMERO_N,
--		null						CEP_N,
--		null				PAIS_N,
--		null					CONTATO_N,
--		null					DEPTO_N,
--		null						cd_int_N,
--		null				cd_areafone_N,
--		null					prefixo_N,
--		null					FONE_N,
--		null					COMPL_FONE_N,

--		--Bl
--		null							Num_Proc,
--		null								Num_BL,	
--		null	Dated_At,
--		null		PO,
--		null							JOB_Ref,
		
--		null								Country_Origin,

--	--Consignee Master	
--		null							ConsigM_Razao,
--		null					ConsM_CNPJ,
--		null									ConsM_Rua,
--		null								ConsM_Num,
--		null								ConsM_Compl,
--		null								ConsM_Bairro,
--		null									ConsM_CEP,
--		null								ConsM_Cidade,
--		null									ConsM_UF,
--		null									ConsM_Pais,
--		null								ConsM_Contato,
--		null ConsM_Fone,
--		null							ConsM_Email,

--		null			Place_Receipt,	
--		null					Port_Loading,
--		--LCD.Nome_Local											Port_Discharge,
--		null					Port_Discharge,
--		null									Pais_Discharge,
--		null		Place_Delivery,	

--		null			Num_Proc,
--		null				Navio1,
--		null				Viagem,
--		null			Tipo_Carga,
--		--HOU.Obs_HEM				Marks_Numbers,
--		null			Gross_Weight,
--		null		Net_Weight,
--		null				Measupement,
		

--		null				Invoice, 
--		null	Booking,
--		null		MBL,
	
--		null qtd_Pieces,

--		null NumberOriginals,
		
--		null  ARMADOR_BL,
--		null 	EIN_Number,

--		null USCI		
		
		
--			-- ALESSANDRA 30/12/2019 - CRIO UM REGISTRO FALSO PARA TER UMA QUEBRA NO RELATÓRIO E PODER EXIBIR A FOLHA A MAIS
--	UNION
	
--	Select
--		--Shipper
--		null					Shipper,
--		null					cnpj_S,	
--		null						RUA_S,
--		null						BAIRRO_S,
--		null						CIDADE_S,
--		null				PAIS_S,	
--		null						NUMERO_S,	
--		null					UF_S,	
--		null						CEP_S,	
--		null						cd_int_S,
--		null				cd_areafone_S,
--		null					prefixo_S,
--		null					num_fone_S,
--		null					compl_fone_S,
--	--Consignee
--		null					Consignee,
--		'zdfhsdfhs'		CNPJ_C,
--		null						RUA_C,
--		null						NUM_C,
--		null					COMPL_C,
--		null						BAIRRO_C,
--		null						CIDADE_C,
--		null				PAIS_C,
--		null						CEP_C,
--		null						CONTATO_C,
--		null					DEPTO_C,
--		null						cd_int_C,
--		null				cd_areafone_C,
--		null						prefixo_C,
--		null					FONE_C,
--		null					COMPL_FONE_C,

--	--Notify	
--		null					Notify,
--		null		CNPJ_N,
--		null						RUA_N,
--		null						BAIRRO_N,
--		null						CIDADE_N,
--		null					COMPL_N,
--		null						NUMERO_N,
--		null						CEP_N,
--		null				PAIS_N,
--		null					CONTATO_N,
--		null					DEPTO_N,
--		null						cd_int_N,
--		null				cd_areafone_N,
--		null					prefixo_N,
--		null					FONE_N,
--		null					COMPL_FONE_N,

--		--Bl
--		null							Num_Proc,
--		null								Num_BL,	
--		null	Dated_At,
--		null		PO,
--		null							JOB_Ref,
		
--		null								Country_Origin,

--	--Consignee Master	
--		null							ConsigM_Razao,
--		null					ConsM_CNPJ,
--		null									ConsM_Rua,
--		null								ConsM_Num,
--		null								ConsM_Compl,
--		null								ConsM_Bairro,
--		null									ConsM_CEP,
--		null								ConsM_Cidade,
--		null									ConsM_UF,
--		null									ConsM_Pais,
--		null								ConsM_Contato,
--		null ConsM_Fone,
--		null							ConsM_Email,

--		null			Place_Receipt,	
--		null					Port_Loading,
--		--LCD.Nome_Local											Port_Discharge,
--		null					Port_Discharge,
--		null									Pais_Discharge,
--		null		Place_Delivery,	

--		null			Num_Proc,
--		null				Navio1,
--		null				Viagem,
--		null			Tipo_Carga,
--		--HOU.Obs_HEM				Marks_Numbers,
--		null			Gross_Weight,
--		null		Net_Weight,
--		null				Measupement,
		

--		null				Invoice, 
--		null	Booking,
--		null		MBL,
	
--		null qtd_Pieces,

--		null NumberOriginals,
		
--		null  ARMADOR_BL,
--		null 	EIN_Number,

--		null USCI		
		
		
--			-- ALESSANDRA 30/12/2019 - CRIO UM REGISTRO FALSO PARA TER UMA QUEBRA NO RELATÓRIO E PODER EXIBIR A FOLHA A MAIS
--	UNION
	
--	Select
--		--Shipper
--		null					Shipper,
--		null					cnpj_S,	
--		null						RUA_S,
--		null						BAIRRO_S,
--		null						CIDADE_S,
--		null				PAIS_S,	
--		null						NUMERO_S,	
--		null					UF_S,	
--		null						CEP_S,	
--		null						cd_int_S,
--		null				cd_areafone_S,
--		null					prefixo_S,
--		null					num_fone_S,
--		null					compl_fone_S,
--	--Consignee
--		null					Consignee,
--		'zdfhzdfh'		CNPJ_C,
--		null						RUA_C,
--		null						NUM_C,
--		null					COMPL_C,
--		null						BAIRRO_C,
--		null						CIDADE_C,
--		null				PAIS_C,
--		null						CEP_C,
--		null						CONTATO_C,
--		null					DEPTO_C,
--		null						cd_int_C,
--		null				cd_areafone_C,
--		null						prefixo_C,
--		null					FONE_C,
--		null					COMPL_FONE_C,

--	--Notify	
--		null					Notify,
--		null		CNPJ_N,
--		null						RUA_N,
--		null						BAIRRO_N,
--		null						CIDADE_N,
--		null					COMPL_N,
--		null						NUMERO_N,
--		null						CEP_N,
--		null				PAIS_N,
--		null					CONTATO_N,
--		null					DEPTO_N,
--		null						cd_int_N,
--		null				cd_areafone_N,
--		null					prefixo_N,
--		null					FONE_N,
--		null					COMPL_FONE_N,

--		--Bl
--		null							Num_Proc,
--		null								Num_BL,	
--		null	Dated_At,
--		null		PO,
--		null							JOB_Ref,
		
--		null								Country_Origin,

--	--Consignee Master	
--		null							ConsigM_Razao,
--		null					ConsM_CNPJ,
--		null									ConsM_Rua,
--		null								ConsM_Num,
--		null								ConsM_Compl,
--		null								ConsM_Bairro,
--		null									ConsM_CEP,
--		null								ConsM_Cidade,
--		null									ConsM_UF,
--		null									ConsM_Pais,
--		null								ConsM_Contato,
--		null ConsM_Fone,
--		null							ConsM_Email,

--		null			Place_Receipt,	
--		null					Port_Loading,
--		--LCD.Nome_Local											Port_Discharge,
--		null					Port_Discharge,
--		null									Pais_Discharge,
--		null		Place_Delivery,	

--		null			Num_Proc,
--		null				Navio1,
--		null				Viagem,
--		null			Tipo_Carga,
--		--HOU.Obs_HEM				Marks_Numbers,
--		null			Gross_Weight,
--		null		Net_Weight,
--		null				Measupement,
		

--		null				Invoice, 
--		null	Booking,
--		null		MBL,
	
--		null qtd_Pieces,

--		null NumberOriginals,
		
--		null  ARMADOR_BL,
--		null 	EIN_Number,

--		null USCI		
		
		
--			-- ALESSANDRA 30/12/2019 - CRIO UM REGISTRO FALSO PARA TER UMA QUEBRA NO RELATÓRIO E PODER EXIBIR A FOLHA A MAIS
--	UNION
	
--	Select
--		--Shipper
--		null					Shipper,
--		null					cnpj_S,	
--		null						RUA_S,
--		null						BAIRRO_S,
--		null						CIDADE_S,
--		null				PAIS_S,	
--		null						NUMERO_S,	
--		null					UF_S,	
--		null						CEP_S,	
--		null						cd_int_S,
--		null				cd_areafone_S,
--		null					prefixo_S,
--		null					num_fone_S,
--		null					compl_fone_S,
--	--Consignee
--		null					Consignee,
--		'zdfgaeyrr'		CNPJ_C,
--		null						RUA_C,
--		null						NUM_C,
--		null					COMPL_C,
--		null						BAIRRO_C,
--		null						CIDADE_C,
--		null				PAIS_C,
--		null						CEP_C,
--		null						CONTATO_C,
--		null					DEPTO_C,
--		null						cd_int_C,
--		null				cd_areafone_C,
--		null						prefixo_C,
--		null					FONE_C,
--		null					COMPL_FONE_C,

--	--Notify	
--		null					Notify,
--		null		CNPJ_N,
--		null						RUA_N,
--		null						BAIRRO_N,
--		null						CIDADE_N,
--		null					COMPL_N,
--		null						NUMERO_N,
--		null						CEP_N,
--		null				PAIS_N,
--		null					CONTATO_N,
--		null					DEPTO_N,
--		null						cd_int_N,
--		null				cd_areafone_N,
--		null					prefixo_N,
--		null					FONE_N,
--		null					COMPL_FONE_N,

--		--Bl
--		null							Num_Proc,
--		null								Num_BL,	
--		null	Dated_At,
--		null		PO,
--		null							JOB_Ref,
		
--		null								Country_Origin,

--	--Consignee Master	
--		null							ConsigM_Razao,
--		null					ConsM_CNPJ,
--		null									ConsM_Rua,
--		null								ConsM_Num,
--		null								ConsM_Compl,
--		null								ConsM_Bairro,
--		null									ConsM_CEP,
--		null								ConsM_Cidade,
--		null									ConsM_UF,
--		null									ConsM_Pais,
--		null								ConsM_Contato,
--		null ConsM_Fone,
--		null							ConsM_Email,

--		null			Place_Receipt,	
--		null					Port_Loading,
--		--LCD.Nome_Local											Port_Discharge,
--		null					Port_Discharge,
--		null									Pais_Discharge,
--		null		Place_Delivery,	

--		null			Num_Proc,
--		null				Navio1,
--		null				Viagem,
--		null			Tipo_Carga,
--		--HOU.Obs_HEM				Marks_Numbers,
--		null			Gross_Weight,
--		null		Net_Weight,
--		null				Measupement,
		

--		null				Invoice, 
--		null	Booking,
--		null		MBL,
	
--		null qtd_Pieces,

--		null NumberOriginals,
		
--		null  ARMADOR_BL,
--		null 	EIN_Number,

--		null USCI		
		
		
--			-- ALESSANDRA 30/12/2019 - CRIO UM REGISTRO FALSO PARA TER UMA QUEBRA NO RELATÓRIO E PODER EXIBIR A FOLHA A MAIS
--	UNION
	
--	Select
--		--Shipper
--		null					Shipper,
--		null					cnpj_S,	
--		null						RUA_S,
--		null						BAIRRO_S,
--		null						CIDADE_S,
--		null				PAIS_S,	
--		null						NUMERO_S,	
--		null					UF_S,	
--		null						CEP_S,	
--		null						cd_int_S,
--		null				cd_areafone_S,
--		null					prefixo_S,
--		null					num_fone_S,
--		null					compl_fone_S,
--	--Consignee
--		null					Consignee,
--		'dfhsdfher'		CNPJ_C,
--		null						RUA_C,
--		null						NUM_C,
--		null					COMPL_C,
--		null						BAIRRO_C,
--		null						CIDADE_C,
--		null				PAIS_C,
--		null						CEP_C,
--		null						CONTATO_C,
--		null					DEPTO_C,
--		null						cd_int_C,
--		null				cd_areafone_C,
--		null						prefixo_C,
--		null					FONE_C,
--		null					COMPL_FONE_C,

--	--Notify	
--		null					Notify,
--		null		CNPJ_N,
--		null						RUA_N,
--		null						BAIRRO_N,
--		null						CIDADE_N,
--		null					COMPL_N,
--		null						NUMERO_N,
--		null						CEP_N,
--		null				PAIS_N,
--		null					CONTATO_N,
--		null					DEPTO_N,
--		null						cd_int_N,
--		null				cd_areafone_N,
--		null					prefixo_N,
--		null					FONE_N,
--		null					COMPL_FONE_N,

--		--Bl
--		null							Num_Proc,
--		null								Num_BL,	
--		null	Dated_At,
--		null		PO,
--		null							JOB_Ref,
		
--		null								Country_Origin,

--	--Consignee Master	
--		null							ConsigM_Razao,
--		null					ConsM_CNPJ,
--		null									ConsM_Rua,
--		null								ConsM_Num,
--		null								ConsM_Compl,
--		null								ConsM_Bairro,
--		null									ConsM_CEP,
--		null								ConsM_Cidade,
--		null									ConsM_UF,
--		null									ConsM_Pais,
--		null								ConsM_Contato,
--		null ConsM_Fone,
--		null							ConsM_Email,

--		null			Place_Receipt,	
--		null					Port_Loading,
--		--LCD.Nome_Local											Port_Discharge,
--		null					Port_Discharge,
--		null									Pais_Discharge,
--		null		Place_Delivery,	

--		null			Num_Proc,
--		null				Navio1,
--		null				Viagem,
--		null			Tipo_Carga,
--		--HOU.Obs_HEM				Marks_Numbers,
--		null			Gross_Weight,
--		null		Net_Weight,
--		null				Measupement,
		

--		null				Invoice, 
--		null	Booking,
--		null		MBL,
	
--		null qtd_Pieces,

--		null NumberOriginals,
		
--		null  ARMADOR_BL,
--		null 	EIN_Number,

--		null USCI		
		
		
--			-- ALESSANDRA 30/12/2019 - CRIO UM REGISTRO FALSO PARA TER UMA QUEBRA NO RELATÓRIO E PODER EXIBIR A FOLHA A MAIS
--	UNION
	
--	Select
--		--Shipper
--		null					Shipper,
--		null					cnpj_S,	
--		null						RUA_S,
--		null						BAIRRO_S,
--		null						CIDADE_S,
--		null				PAIS_S,	
--		null						NUMERO_S,	
--		null					UF_S,	
--		null						CEP_S,	
--		null						cd_int_S,
--		null				cd_areafone_S,
--		null					prefixo_S,
--		null					num_fone_S,
--		null					compl_fone_S,
--	--Consignee
--		null					Consignee,
--		'dfhsethy'		CNPJ_C,
--		null						RUA_C,
--		null						NUM_C,
--		null					COMPL_C,
--		null						BAIRRO_C,
--		null						CIDADE_C,
--		null				PAIS_C,
--		null						CEP_C,
--		null						CONTATO_C,
--		null					DEPTO_C,
--		null						cd_int_C,
--		null				cd_areafone_C,
--		null						prefixo_C,
--		null					FONE_C,
--		null					COMPL_FONE_C,

--	--Notify	
--		null					Notify,
--		null		CNPJ_N,
--		null						RUA_N,
--		null						BAIRRO_N,
--		null						CIDADE_N,
--		null					COMPL_N,
--		null						NUMERO_N,
--		null						CEP_N,
--		null				PAIS_N,
--		null					CONTATO_N,
--		null					DEPTO_N,
--		null						cd_int_N,
--		null				cd_areafone_N,
--		null					prefixo_N,
--		null					FONE_N,
--		null					COMPL_FONE_N,

--		--Bl
--		null							Num_Proc,
--		null								Num_BL,	
--		null	Dated_At,
--		null		PO,
--		null							JOB_Ref,
		
--		null								Country_Origin,

--	--Consignee Master	
--		null							ConsigM_Razao,
--		null					ConsM_CNPJ,
--		null									ConsM_Rua,
--		null								ConsM_Num,
--		null								ConsM_Compl,
--		null								ConsM_Bairro,
--		null									ConsM_CEP,
--		null								ConsM_Cidade,
--		null									ConsM_UF,
--		null									ConsM_Pais,
--		null								ConsM_Contato,
--		null ConsM_Fone,
--		null							ConsM_Email,

--		null			Place_Receipt,	
--		null					Port_Loading,
--		--LCD.Nome_Local											Port_Discharge,
--		null					Port_Discharge,
--		null									Pais_Discharge,
--		null		Place_Delivery,	

--		null			Num_Proc,
--		null				Navio1,
--		null				Viagem,
--		null			Tipo_Carga,
--		--HOU.Obs_HEM				Marks_Numbers,
--		null			Gross_Weight,
--		null		Net_Weight,
--		null				Measupement,
		

--		null				Invoice, 
--		null	Booking,
--		null		MBL,
	
--		null qtd_Pieces,

--		null NumberOriginals,
		
--		null  ARMADOR_BL,
--		null 	EIN_Number,

--		null USCI		
		
		
--			-- ALESSANDRA 30/12/2019 - CRIO UM REGISTRO FALSO PARA TER UMA QUEBRA NO RELATÓRIO E PODER EXIBIR A FOLHA A MAIS
--	UNION
	
--	Select
--		--Shipper
--		null					Shipper,
--		null					cnpj_S,	
--		null						RUA_S,
--		null						BAIRRO_S,
--		null						CIDADE_S,
--		null				PAIS_S,	
--		null						NUMERO_S,	
--		null					UF_S,	
--		null						CEP_S,	
--		null						cd_int_S,
--		null				cd_areafone_S,
--		null					prefixo_S,
--		null					num_fone_S,
--		null					compl_fone_S,
--	--Consignee
--		null					Consignee,
--		'sdfhswery'		CNPJ_C,
--		null						RUA_C,
--		null						NUM_C,
--		null					COMPL_C,
--		null						BAIRRO_C,
--		null						CIDADE_C,
--		null				PAIS_C,
--		null						CEP_C,
--		null						CONTATO_C,
--		null					DEPTO_C,
--		null						cd_int_C,
--		null				cd_areafone_C,
--		null						prefixo_C,
--		null					FONE_C,
--		null					COMPL_FONE_C,

--	--Notify	
--		null					Notify,
--		null		CNPJ_N,
--		null						RUA_N,
--		null						BAIRRO_N,
--		null						CIDADE_N,
--		null					COMPL_N,
--		null						NUMERO_N,
--		null						CEP_N,
--		null				PAIS_N,
--		null					CONTATO_N,
--		null					DEPTO_N,
--		null						cd_int_N,
--		null				cd_areafone_N,
--		null					prefixo_N,
--		null					FONE_N,
--		null					COMPL_FONE_N,

--		--Bl
--		null							Num_Proc,
--		null								Num_BL,	
--		null	Dated_At,
--		null		PO,
--		null							JOB_Ref,
		
--		null								Country_Origin,

--	--Consignee Master	
--		null							ConsigM_Razao,
--		null					ConsM_CNPJ,
--		null									ConsM_Rua,
--		null								ConsM_Num,
--		null								ConsM_Compl,
--		null								ConsM_Bairro,
--		null									ConsM_CEP,
--		null								ConsM_Cidade,
--		null									ConsM_UF,
--		null									ConsM_Pais,
--		null								ConsM_Contato,
--		null ConsM_Fone,
--		null							ConsM_Email,

--		null			Place_Receipt,	
--		null					Port_Loading,
--		--LCD.Nome_Local											Port_Discharge,
--		null					Port_Discharge,
--		null									Pais_Discharge,
--		null		Place_Delivery,	

--		null			Num_Proc,
--		null				Navio1,
--		null				Viagem,
--		null			Tipo_Carga,
--		--HOU.Obs_HEM				Marks_Numbers,
--		null			Gross_Weight,
--		null		Net_Weight,
--		null				Measupement,
		

--		null				Invoice, 
--		null	Booking,
--		null		MBL,
	
--		null qtd_Pieces,

--		null NumberOriginals,
		
--		null  ARMADOR_BL,
--		null 	EIN_Number,

--		null USCI		
		
		
--			-- ALESSANDRA 30/12/2019 - CRIO UM REGISTRO FALSO PARA TER UMA QUEBRA NO RELATÓRIO E PODER EXIBIR A FOLHA A MAIS
--	UNION
	
--	Select
--		--Shipper
--		null					Shipper,
--		null					cnpj_S,	
--		null						RUA_S,
--		null						BAIRRO_S,
--		null						CIDADE_S,
--		null				PAIS_S,	
--		null						NUMERO_S,	
--		null					UF_S,	
--		null						CEP_S,	
--		null						cd_int_S,
--		null				cd_areafone_S,
--		null					prefixo_S,
--		null					num_fone_S,
--		null					compl_fone_S,
--	--Consignee
--		null					Consignee,
--		'eyweryw5'		CNPJ_C,
--		null						RUA_C,
--		null						NUM_C,
--		null					COMPL_C,
--		null						BAIRRO_C,
--		null						CIDADE_C,
--		null				PAIS_C,
--		null						CEP_C,
--		null						CONTATO_C,
--		null					DEPTO_C,
--		null						cd_int_C,
--		null				cd_areafone_C,
--		null						prefixo_C,
--		null					FONE_C,
--		null					COMPL_FONE_C,

--	--Notify	
--		null					Notify,
--		null		CNPJ_N,
--		null						RUA_N,
--		null						BAIRRO_N,
--		null						CIDADE_N,
--		null					COMPL_N,
--		null						NUMERO_N,
--		null						CEP_N,
--		null				PAIS_N,
--		null					CONTATO_N,
--		null					DEPTO_N,
--		null						cd_int_N,
--		null				cd_areafone_N,
--		null					prefixo_N,
--		null					FONE_N,
--		null					COMPL_FONE_N,

--		--Bl
--		null							Num_Proc,
--		null								Num_BL,	
--		null	Dated_At,
--		null		PO,
--		null							JOB_Ref,
		
--		null								Country_Origin,

--	--Consignee Master	
--		null							ConsigM_Razao,
--		null					ConsM_CNPJ,
--		null									ConsM_Rua,
--		null								ConsM_Num,
--		null								ConsM_Compl,
--		null								ConsM_Bairro,
--		null									ConsM_CEP,
--		null								ConsM_Cidade,
--		null									ConsM_UF,
--		null									ConsM_Pais,
--		null								ConsM_Contato,
--		null ConsM_Fone,
--		null							ConsM_Email,

--		null			Place_Receipt,	
--		null					Port_Loading,
--		--LCD.Nome_Local											Port_Discharge,
--		null					Port_Discharge,
--		null									Pais_Discharge,
--		null		Place_Delivery,	

--		null			Num_Proc,
--		null				Navio1,
--		null				Viagem,
--		null			Tipo_Carga,
--		--HOU.Obs_HEM				Marks_Numbers,
--		null			Gross_Weight,
--		null		Net_Weight,
--		null				Measupement,
		

--		null				Invoice, 
--		null	Booking,
--		null		MBL,
	
--		null qtd_Pieces,

--		null NumberOriginals,
		
--		null  ARMADOR_BL,
--		null 	EIN_Number,

--		null USCI		
		
		
		
--			-- ALESSANDRA 30/12/2019 - CRIO UM REGISTRO FALSO PARA TER UMA QUEBRA NO RELATÓRIO E PODER EXIBIR A FOLHA A MAIS
--	UNION
	
--	Select
--		--Shipper
--		null					Shipper,
--		null					cnpj_S,	
--		null						RUA_S,
--		null						BAIRRO_S,
--		null						CIDADE_S,
--		null				PAIS_S,	
--		null						NUMERO_S,	
--		null					UF_S,	
--		null						CEP_S,	
--		null						cd_int_S,
--		null				cd_areafone_S,
--		null					prefixo_S,
--		null					num_fone_S,
--		null					compl_fone_S,
--	--Consignee
--		null					Consignee,
--		'y56324576234'		CNPJ_C,
--		null						RUA_C,
--		null						NUM_C,
--		null					COMPL_C,
--		null						BAIRRO_C,
--		null						CIDADE_C,
--		null				PAIS_C,
--		null						CEP_C,
--		null						CONTATO_C,
--		null					DEPTO_C,
--		null						cd_int_C,
--		null				cd_areafone_C,
--		null						prefixo_C,
--		null					FONE_C,
--		null					COMPL_FONE_C,

--	--Notify	
--		null					Notify,
--		null		CNPJ_N,
--		null						RUA_N,
--		null						BAIRRO_N,
--		null						CIDADE_N,
--		null					COMPL_N,
--		null						NUMERO_N,
--		null						CEP_N,
--		null				PAIS_N,
--		null					CONTATO_N,
--		null					DEPTO_N,
--		null						cd_int_N,
--		null				cd_areafone_N,
--		null					prefixo_N,
--		null					FONE_N,
--		null					COMPL_FONE_N,

--		--Bl
--		null							Num_Proc,
--		null								Num_BL,	
--		null	Dated_At,
--		null		PO,
--		null							JOB_Ref,
		
--		null								Country_Origin,

--	--Consignee Master	
--		null							ConsigM_Razao,
--		null					ConsM_CNPJ,
--		null									ConsM_Rua,
--		null								ConsM_Num,
--		null								ConsM_Compl,
--		null								ConsM_Bairro,
--		null									ConsM_CEP,
--		null								ConsM_Cidade,
--		null									ConsM_UF,
--		null									ConsM_Pais,
--		null								ConsM_Contato,
--		null ConsM_Fone,
--		null							ConsM_Email,

--		null			Place_Receipt,	
--		null					Port_Loading,
--		--LCD.Nome_Local											Port_Discharge,
--		null					Port_Discharge,
--		null									Pais_Discharge,
--		null		Place_Delivery,	

--		null			Num_Proc,
--		null				Navio1,
--		null				Viagem,
--		null			Tipo_Carga,
--		--HOU.Obs_HEM				Marks_Numbers,
--		null			Gross_Weight,
--		null		Net_Weight,
--		null				Measupement,
		

--		null				Invoice, 
--		null	Booking,
--		null		MBL,
	
--		null qtd_Pieces,

--		null NumberOriginals,
		
--		null  ARMADOR_BL,
--		null 	EIN_Number,

--		null USCI		
		
		
		
--			-- ALESSANDRA 30/12/2019 - CRIO UM REGISTRO FALSO PARA TER UMA QUEBRA NO RELATÓRIO E PODER EXIBIR A FOLHA A MAIS
--	UNION
	
--	Select
--		--Shipper
--		null					Shipper,
--		null					cnpj_S,	
--		null						RUA_S,
--		null						BAIRRO_S,
--		null						CIDADE_S,
--		null				PAIS_S,	
--		null						NUMERO_S,	
--		null					UF_S,	
--		null						CEP_S,	
--		null						cd_int_S,
--		null				cd_areafone_S,
--		null					prefixo_S,
--		null					num_fone_S,
--		null					compl_fone_S,
--	--Consignee
--		null					Consignee,
--		'ert3452352'		CNPJ_C,
--		null						RUA_C,
--		null						NUM_C,
--		null					COMPL_C,
--		null						BAIRRO_C,
--		null						CIDADE_C,
--		null				PAIS_C,
--		null						CEP_C,
--		null						CONTATO_C,
--		null					DEPTO_C,
--		null						cd_int_C,
--		null				cd_areafone_C,
--		null						prefixo_C,
--		null					FONE_C,
--		null					COMPL_FONE_C,

--	--Notify	
--		null					Notify,
--		null		CNPJ_N,
--		null						RUA_N,
--		null						BAIRRO_N,
--		null						CIDADE_N,
--		null					COMPL_N,
--		null						NUMERO_N,
--		null						CEP_N,
--		null				PAIS_N,
--		null					CONTATO_N,
--		null					DEPTO_N,
--		null						cd_int_N,
--		null				cd_areafone_N,
--		null					prefixo_N,
--		null					FONE_N,
--		null					COMPL_FONE_N,

--		--Bl
--		null							Num_Proc,
--		null								Num_BL,	
--		null	Dated_At,
--		null		PO,
--		null							JOB_Ref,
		
--		null								Country_Origin,

--	--Consignee Master	
--		null							ConsigM_Razao,
--		null					ConsM_CNPJ,
--		null									ConsM_Rua,
--		null								ConsM_Num,
--		null								ConsM_Compl,
--		null								ConsM_Bairro,
--		null									ConsM_CEP,
--		null								ConsM_Cidade,
--		null									ConsM_UF,
--		null									ConsM_Pais,
--		null								ConsM_Contato,
--		null ConsM_Fone,
--		null							ConsM_Email,

--		null			Place_Receipt,	
--		null					Port_Loading,
--		--LCD.Nome_Local											Port_Discharge,
--		null					Port_Discharge,
--		null									Pais_Discharge,
--		null		Place_Delivery,	

--		null			Num_Proc,
--		null				Navio1,
--		null				Viagem,
--		null			Tipo_Carga,
--		--HOU.Obs_HEM				Marks_Numbers,
--		null			Gross_Weight,
--		null		Net_Weight,
--		null				Measupement,
		

--		null				Invoice, 
--		null	Booking,
--		null		MBL,
	
--		null qtd_Pieces,

--		null NumberOriginals,
		
--		null  ARMADOR_BL,
--		null 	EIN_Number,

--		null USCI		
		
		
		
--			-- ALESSANDRA 30/12/2019 - CRIO UM REGISTRO FALSO PARA TER UMA QUEBRA NO RELATÓRIO E PODER EXIBIR A FOLHA A MAIS
--	UNION
	
--	Select
--		--Shipper
--		null					Shipper,
--		null					cnpj_S,	
--		null						RUA_S,
--		null						BAIRRO_S,
--		null						CIDADE_S,
--		null				PAIS_S,	
--		null						NUMERO_S,	
--		null					UF_S,	
--		null						CEP_S,	
--		null						cd_int_S,
--		null				cd_areafone_S,
--		null					prefixo_S,
--		null					num_fone_S,
--		null					compl_fone_S,
--	--Consignee
--		null					Consignee,
--		'3452q3472h'		CNPJ_C,
--		null						RUA_C,
--		null						NUM_C,
--		null					COMPL_C,
--		null						BAIRRO_C,
--		null						CIDADE_C,
--		null				PAIS_C,
--		null						CEP_C,
--		null						CONTATO_C,
--		null					DEPTO_C,
--		null						cd_int_C,
--		null				cd_areafone_C,
--		null						prefixo_C,
--		null					FONE_C,
--		null					COMPL_FONE_C,

--	--Notify	
--		null					Notify,
--		null		CNPJ_N,
--		null						RUA_N,
--		null						BAIRRO_N,
--		null						CIDADE_N,
--		null					COMPL_N,
--		null						NUMERO_N,
--		null						CEP_N,
--		null				PAIS_N,
--		null					CONTATO_N,
--		null					DEPTO_N,
--		null						cd_int_N,
--		null				cd_areafone_N,
--		null					prefixo_N,
--		null					FONE_N,
--		null					COMPL_FONE_N,

--		--Bl
--		null							Num_Proc,
--		null								Num_BL,	
--		null	Dated_At,
--		null		PO,
--		null							JOB_Ref,
		
--		null								Country_Origin,

--	--Consignee Master	
--		null							ConsigM_Razao,
--		null					ConsM_CNPJ,
--		null									ConsM_Rua,
--		null								ConsM_Num,
--		null								ConsM_Compl,
--		null								ConsM_Bairro,
--		null									ConsM_CEP,
--		null								ConsM_Cidade,
--		null									ConsM_UF,
--		null									ConsM_Pais,
--		null								ConsM_Contato,
--		null ConsM_Fone,
--		null							ConsM_Email,

--		null			Place_Receipt,	
--		null					Port_Loading,
--		--LCD.Nome_Local											Port_Discharge,
--		null					Port_Discharge,
--		null									Pais_Discharge,
--		null		Place_Delivery,	

--		null			Num_Proc,
--		null				Navio1,
--		null				Viagem,
--		null			Tipo_Carga,
--		--HOU.Obs_HEM				Marks_Numbers,
--		null			Gross_Weight,
--		null		Net_Weight,
--		null				Measupement,
		

--		null				Invoice, 
--		null	Booking,
--		null		MBL,
	
--		null qtd_Pieces,

--		null NumberOriginals,
		
--		null  ARMADOR_BL,
--		null 	EIN_Number,

--		null USCI		
		
		
		
--			-- ALESSANDRA 30/12/2019 - CRIO UM REGISTRO FALSO PARA TER UMA QUEBRA NO RELATÓRIO E PODER EXIBIR A FOLHA A MAIS
--	UNION
	
--	Select
--		--Shipper
--		null					Shipper,
--		null					cnpj_S,	
--		null						RUA_S,
--		null						BAIRRO_S,
--		null						CIDADE_S,
--		null				PAIS_S,	
--		null						NUMERO_S,	
--		null					UF_S,	
--		null						CEP_S,	
--		null						cd_int_S,
--		null				cd_areafone_S,
--		null					prefixo_S,
--		null					num_fone_S,
--		null					compl_fone_S,
--	--Consignee
--		null					Consignee,
--		'wtryw346234'		CNPJ_C,
--		null						RUA_C,
--		null						NUM_C,
--		null					COMPL_C,
--		null						BAIRRO_C,
--		null						CIDADE_C,
--		null				PAIS_C,
--		null						CEP_C,
--		null						CONTATO_C,
--		null					DEPTO_C,
--		null						cd_int_C,
--		null				cd_areafone_C,
--		null						prefixo_C,
--		null					FONE_C,
--		null					COMPL_FONE_C,

--	--Notify	
--		null					Notify,
--		null		CNPJ_N,
--		null						RUA_N,
--		null						BAIRRO_N,
--		null						CIDADE_N,
--		null					COMPL_N,
--		null						NUMERO_N,
--		null						CEP_N,
--		null				PAIS_N,
--		null					CONTATO_N,
--		null					DEPTO_N,
--		null						cd_int_N,
--		null				cd_areafone_N,
--		null					prefixo_N,
--		null					FONE_N,
--		null					COMPL_FONE_N,

--		--Bl
--		null							Num_Proc,
--		null								Num_BL,	
--		null	Dated_At,
--		null		PO,
--		null							JOB_Ref,
		
--		null								Country_Origin,

--	--Consignee Master	
--		null							ConsigM_Razao,
--		null					ConsM_CNPJ,
--		null									ConsM_Rua,
--		null								ConsM_Num,
--		null								ConsM_Compl,
--		null								ConsM_Bairro,
--		null									ConsM_CEP,
--		null								ConsM_Cidade,
--		null									ConsM_UF,
--		null									ConsM_Pais,
--		null								ConsM_Contato,
--		null ConsM_Fone,
--		null							ConsM_Email,

--		null			Place_Receipt,	
--		null					Port_Loading,
--		--LCD.Nome_Local											Port_Discharge,
--		null					Port_Discharge,
--		null									Pais_Discharge,
--		null		Place_Delivery,	

--		null			Num_Proc,
--		null				Navio1,
--		null				Viagem,
--		null			Tipo_Carga,
--		--HOU.Obs_HEM				Marks_Numbers,
--		null			Gross_Weight,
--		null		Net_Weight,
--		null				Measupement,
		

--		null				Invoice, 
--		null	Booking,
--		null		MBL,
	
--		null qtd_Pieces,

--		null NumberOriginals,
		
--		null  ARMADOR_BL,
--		null 	EIN_Number,

--		null USCI		
		
		
		
--			-- ALESSANDRA 30/12/2019 - CRIO UM REGISTRO FALSO PARA TER UMA QUEBRA NO RELATÓRIO E PODER EXIBIR A FOLHA A MAIS
--	UNION
	
--	Select
--		--Shipper
--		null					Shipper,
--		null					cnpj_S,	
--		null						RUA_S,
--		null						BAIRRO_S,
--		null						CIDADE_S,
--		null				PAIS_S,	
--		null						NUMERO_S,	
--		null					UF_S,	
--		null						CEP_S,	
--		null						cd_int_S,
--		null				cd_areafone_S,
--		null					prefixo_S,
--		null					num_fone_S,
--		null					compl_fone_S,
--	--Consignee
--		null					Consignee,
--		'ert34523'		CNPJ_C,
--		null						RUA_C,
--		null						NUM_C,
--		null					COMPL_C,
--		null						BAIRRO_C,
--		null						CIDADE_C,
--		null				PAIS_C,
--		null						CEP_C,
--		null						CONTATO_C,
--		null					DEPTO_C,
--		null						cd_int_C,
--		null				cd_areafone_C,
--		null						prefixo_C,
--		null					FONE_C,
--		null					COMPL_FONE_C,

--	--Notify	
--		null					Notify,
--		null		CNPJ_N,
--		null						RUA_N,
--		null						BAIRRO_N,
--		null						CIDADE_N,
--		null					COMPL_N,
--		null						NUMERO_N,
--		null						CEP_N,
--		null				PAIS_N,
--		null					CONTATO_N,
--		null					DEPTO_N,
--		null						cd_int_N,
--		null				cd_areafone_N,
--		null					prefixo_N,
--		null					FONE_N,
--		null					COMPL_FONE_N,

--		--Bl
--		null							Num_Proc,
--		null								Num_BL,	
--		null	Dated_At,
--		null		PO,
--		null							JOB_Ref,
		
--		null								Country_Origin,

--	--Consignee Master	
--		null							ConsigM_Razao,
--		null					ConsM_CNPJ,
--		null									ConsM_Rua,
--		null								ConsM_Num,
--		null								ConsM_Compl,
--		null								ConsM_Bairro,
--		null									ConsM_CEP,
--		null								ConsM_Cidade,
--		null									ConsM_UF,
--		null									ConsM_Pais,
--		null								ConsM_Contato,
--		null ConsM_Fone,
--		null							ConsM_Email,

--		null			Place_Receipt,	
--		null					Port_Loading,
--		--LCD.Nome_Local											Port_Discharge,
--		null					Port_Discharge,
--		null									Pais_Discharge,
--		null		Place_Delivery,	

--		null			Num_Proc,
--		null				Navio1,
--		null				Viagem,
--		null			Tipo_Carga,
--		--HOU.Obs_HEM				Marks_Numbers,
--		null			Gross_Weight,
--		null		Net_Weight,
--		null				Measupement,
		

--		null				Invoice, 
--		null	Booking,
--		null		MBL,
	
--		null qtd_Pieces,

--		null NumberOriginals,
		
--		null  ARMADOR_BL,
--		null 	EIN_Number,

--		null USCI		

--		order by CNPJ_C
		
		
--end
--else
--begin
--	Select
--		--Shipper
--		SH.Nome_raz_soc					Shipper,
--		SH.num_cpf_cnpj					cnpj_S,	
--		ENDS.RUA						RUA_S,
--		ENDS.BAIRRO						BAIRRO_S,
--		ENDS.CIDADE						CIDADE_S,
--		UPPER(ENDS.PAIS)				PAIS_S,	
--		ENDS.NUMERO						NUMERO_S,	
--		UPPER(ENDS.UF)					UF_S,	
--		ENDS.CEP						CEP_S,	
--		cmcs.cd_int						cd_int_S,
--		cmcs.cd_area_fone				cd_areafone_S,
--		cmcs.prefixo					prefixo_S,
--		cmcs.num_fone					num_fone_S,
--		cmcs.compl_fone					compl_fone_S,
--	--Consignee
--		CS.Nome_raz_soc					Consignee,
--		RIGHT(CS.Num_CPF_CNPJ,14)		CNPJ_C,
--		ENDC.RUA						RUA_C,
--		ENDC.NUMERO						NUM_C,
--		ENDC.COMPL_END					COMPL_C,
--		ENDC.BAIRRO						BAIRRO_C,
--		ENDC.CIDADE						CIDADE_C,
--		UPPER(ENDC.PAIS)				PAIS_C,
--		ENDC.CEP						CEP_C,
--		CMC.contato						CONTATO_C,
--		CMC.Depto_Ctt					DEPTO_C,
--		CMC.cd_int						cd_int_C,
--		CMC.cd_area_fone				cd_areafone_C,
--		CMC.prefixo						prefixo_C,
--		CMC.num_fone					FONE_C,
--		CMC.compl_fone					COMPL_FONE_C,

--	--Notify	
--		NF.Nome_raz_Soc					Notify,
--		RIGHT(NF.Num_CPF_CNPJ,14)		CNPJ_N,
--		ENDN.RUA						RUA_N,
--		ENDN.BAIRRO						BAIRRO_N,
--		ENDN.CIDADE						CIDADE_N,
--		ENDN.COMPL_END					COMPL_N,
--		ENDN.NUMERO						NUMERO_N,
--		ENDN.CEP						CEP_N,
--		UPPER(ENDN.PAIS)				PAIS_N,
--		CMCN.contato					CONTATO_N,
--		CMCN.Depto_Ctt					DEPTO_N,
--		CMCN.cd_int						cd_int_N,
--		CMCN.cd_area_fone				cd_areafone_N,
--		CMCN.prefixo					prefixo_N,
--		CMCN.num_fone					FONE_N,
--		CMCN.compl_fone					COMPL_FONE_N,

--		--Bl
--		HOU.Num_Proc_Hem							Num_Proc,
--		HOU.HAWB_HEM								Num_BL,	
--		convert(varchar(10),LLP.Dt_Impres_LEM,103)	Dated_At,
--		dbo.fBusca_Docs_PO_Modal(@Processo,1)		PO,
--		LLP.Intl_Ref_Lem							JOB_Ref,
		
--		LCO.Pais_Local								Country_Origin,

--	--Consignee Master	
--		CSNM.Nome_Raz_Soc							ConsigM_Razao,
--		right(CSNM.Num_CPF_CNPJ,14)					ConsM_CNPJ,
--		EndNM.Rua									ConsM_Rua,
--		EndNM.Numero								ConsM_Num,
--		EndNM.Compl_End								ConsM_Compl,
--		EndNM.Bairro								ConsM_Bairro,
--		EndNM.CEP									ConsM_CEP,
--		EndNM.Cidade								ConsM_Cidade,
--		EndNM.UF									ConsM_UF,
--		EndNM.Pais									ConsM_Pais,
--		CttNM.Contato								ConsM_Contato,
--		('+' + CttNM.Cd_Int + ' ' + CttNM.Cd_Area_Fone + ' ' + CttNM.Prefixo + ' ' + CttNM.Num_Fone) ConsM_Fone,
--		CttNM.Compl_Fone							ConsM_Email,

--		(Origin.Nome_Local + ', ' + Origin.Pais_Local)			Place_Receipt,	
--		(LCO.Nome_Local + ', ' + LCO.Cd_Pais)					Port_Loading,
--		--LCD.Nome_Local											Port_Discharge,
--		(LCD.Nome_Local	+ ', ' + LCD.Cd_Pais)					Port_Discharge,
--		UPPER(LCD.Pais_Local)									Pais_Discharge,
--		(DstFinal.Nome_Local + ', ' + DstFinal.Cd_Pais)		Place_Delivery,	

--		HOU.Num_Proc_HEM			Num_Proc,
--		HOU.Navio_HEM				Navio1,
--		HOU.Viagem_HEM				Viagem,
--		TC.Nome_Tp_Carga			Tipo_Carga,
--		--HOU.Obs_HEM				Marks_Numbers,
--		HOU.Peso_Bruto_HEM			Gross_Weight,
--		HOU.Peso_Liquido_HEM		Net_Weight,
--		HOU.Vol_Tot_hem				Measupement,
		

--		(case when dbo.fBusca_Docs_PO_Modal(@Processo,2) is not null then
--			'INVOICE: ' + dbo.fBusca_Docs_PO_Modal(@Processo,2)
--		else
--			null end)				Invoice, 
--		'BOOKING: ' + nr_reserva	Booking,
--		'MBL: ' + HOU.MAWB_HEM		MBL,
--	--	HOU.Qtd_Tot_Vol_HeM			qtd_Pieces,
--		--convert(varchar,[dbo].[Qty_Container](@processo))+ ' X ' +
--		-- [dbo].[fBusca_Containers_TP](@processo) qtd_Pieces,

--	--15/09/2016 - Rafael 
--		-- (Case when LLP.Cd_Tp_Carga = 1 then
--		--	convert(varchar,[dbo].[Qty_Container](@processo))+ ' X ' + [dbo].[fBusca_Containers_TP](@processo)
--		--else
--		--	dbo.[fBusca_Volumes_QtdTipo] (@processo)	
--		--end) qtd_Pieces,
--		dbo.[fBusca_Volumes_QtyEmbal] (@Processo) qtd_Pieces,

--		isnull([dbo].[fBusca_CampoCliente](@processo,132),0) NumberOriginals,
		
--		ARMADOR_BL.Nome_Armador  ARMADOR_BL,
--		--BDP= "EIN23-1878776" e qdo for SilverBirch  = "EIN20-8141384" - vwArmador_HBL_EM
		
--		--(case when UPPER(ENDC.CD_pais) = 'CN' THEN
--		(case when UPPER(LCD.Cd_Pais) in ('CN','ID','MY')THEN
--			CP180.Campo_Dados ELSE
--			'' END) 	EIN_Number,
					
--		--(case when UPPER(ENDC.CD_pais) = 'CN' THEN
--		(case when UPPER(LCD.Cd_Pais) in ('CN','ID','MY')THEN
--			CP.Campo_Dados ELSE
--			'' END) USCI			
--	from
--		house_exp_mar Hou with(nolock)
--		Left Outer Join	Master_exp_mar		MAS with(nolock)		on MAS.num_proc_mem = HOU.num_proc_mem
--		Left Outer Join LLP_exp_mar			LLP with(nolock)		on HOU.Num_Proc_HEM = LLP.Num_Proc_LEM
--		Left Outer Join JOB_exp_mar			JOB with(nolock)		on HOU.Num_Proc_HEM = JOB.Num_Proc_HEM

--		Left Outer Join Pessoa				SH with(nolock)		on SH.cd_pes = cd_export_hem 
--		Left Outer Join Endereco			ENDS with(nolock)	on SH.cd_pes = ENDS.cd_pes and ENDS.cd_tp_end = 'COM' 
--		Left Outer Join comunicacao			CMCS with(nolock)	on SH.cd_pes = CMCS.cd_pes and CMCS.cd_tp_com = 'HBL'
		
--		Left Outer Join Pessoa				CS with(nolock)		on CS.cd_pes=cd_consig_hem
--		Left Outer Join Endereco			ENDC with(nolock)	on CS.cd_pes=ENDC.cd_pes  and ENDC.cd_tp_end = 'COM'	
--		Left Outer Join comunicacao			CMC	with(nolock)	on CS.cd_pes = CMC.cd_pes and CMC.cd_tp_com = 'HBL'	
	 
--		Left Outer Join Pessoa				NF with(nolock)		on NF.cd_pes = HOU.cd_notify_hem
--		Left Outer Join Endereco			ENDN with(nolock)	on NF.cd_pes = ENDN.cd_pes  and ENDN.cd_tp_end = 'COM' 
--		Left Outer Join comunicacao			CMCN with(nolock)	on NF.cd_pes = CMCN.cd_pes and CMC.cd_tp_com = 'HBL'
	  
--		Left Outer Join Localidade			LCO with(nolock)		on HOU.cd_org_Hem = LCO.cd_local
--		Left Outer Join Localidade			LCD with(nolock)		on HOU.cd_dst_hem = LCD.cd_local
--		Left Outer Join Localidade			Origin with(nolock)	on LLP.Cd_Planta_Lem	= Origin.Cd_Local
--		Left Outer Join Localidade			DstFinal with(nolock) on LLP.cd_dstfinal_lem	= Dstfinal.cd_local
--		Left Outer Join Tipo_Carga			TC with(nolock)		on LLP.Cd_Tp_Carga = TC.Cd_Tp_Carga and TC.Ativo_TP = 'S'	
--		--Left Outer Join Pessoa			NM		on NM.Cd_Pes		= Cd_Import_hem		
--		Left outer Join Pessoa				CSNM with(nolock)	on CSNM.Cd_Pes		= MAS.cd_consig_mem
--		Left outer Join Endereco			EndNM with(nolock)	on CSNM.Cd_Pes		= EndNM.Cd_Pes AND EndNM.cd_tp_end='COM'
--		Left outer Join Comunicacao			CttNM with(nolock)	on CttNM.Cd_Pes		= CSNM.Cd_Pes and CttNM.Cd_Tp_Com = 'HBL'	

--		Left outer Join Campo_Processo		CP179 with(nolock)	on HOU.Num_Proc_HEM = CP179.Num_Proc and CP179.Id_Campo = 179	
--		Left Outer Join Armador				ARMADOR_BL with(nolock)	on isnull(CP179.Campo_Dados,'BDP') = ARMADOR_BL.Cd_Armador
--		left join Campo_Pessoa				CP on CP.Cd_Pes = CS.Cd_Pes and cp.Id_Campo = '18'
--		Left outer Join Campo_Processo		CP180 with(nolock)	on HOU.Num_Proc_HEM = CP180.Num_Proc and CP180.Id_Campo = 180
--	where

--		HOU.num_proc_hem = @Processo

--	group by
--		SH.Nome_raz_soc,	SH.num_cpf_cnpj,		ENDS.RUA,	ENDS.BAIRRO,	ENDS.CIDADE,
--		ENDS.PAIS,		ENDS.NUMERO,		ENDS.UF,		ENDS.CEP,		cmcs.cd_int,
--		cmcs.cd_area_fone,	cmcs.prefixo,	cmcs.num_fone,	cmcs.compl_fone,
--		CS.Nome_raz_soc,	cS.Num_CPF_CNPJ,	ENDC.RUA,	ENDC.NUMERO,	ENDC.COMPL_END,
--		ENDC.BAIRRO,	ENDC.CIDADE,	ENDC.PAIS,	ENDC.CEP,	CMC.contato,	CMC.Depto_Ctt,
--		CMC.cd_int,	CMC.cd_area_fone,	CMC.prefixo,	CMC.num_fone,	CMC.compl_fone,
--		NF.Nome_raz_Soc,	NF.Num_CPF_CNPJ,	ENDN.RUA,	ENDN.BAIRRO,	ENDN.CIDADE,
--		ENDN.COMPL_END,	ENDN.NUMERO,	ENDN.CEP,	ENDN.PAIS,	CMCN.contato,	CMCN.Depto_Ctt,
--		CMCN.cd_int,	CMCN.cd_area_fone,	CMCN.prefixo,	CMCN.num_fone,	CMCN.compl_fone,
--		HOU.Num_Proc_Hem,	HOU.HAWB_HEM,		LLP.Dt_Impres_LEM,	--dbo.fBusca_Docs_PO_Modal(@Processo,1)		PO,
--		LLP.Intl_Ref_Lem,	HOU.MAWB_HEM,	LCO.Pais_Local,	CSNM.Nome_Raz_Soc,	CSNM.Num_CPF_CNPJ,
--		EndNM.Rua,	EndNM.Numero,	EndNM.Compl_End	,	EndNM.Bairro,	EndNM.CEP,	EndNM.Cidade,	EndNM.UF,
--		EndNM.Pais,	CttNM.Contato,	('+' + CttNM.Cd_Int + ' ' + CttNM.Cd_Area_Fone + ' ' + CttNM.Prefixo + ' ' + CttNM.Num_Fone),
--		CttNM.Compl_Fone,	Origin.Nome_Local,	Origin.Pais_Local,		LCO.Nome_Local,	LCO.Pais_Local,
--		LCD.Nome_Local	+ ', ' + LCD.Cd_Pais,	UPPER(LCD.Pais_Local),	(DstFinal.Nome_Local + ', ' + DstFinal.Cd_Pais),
--		LCO.Cd_Pais,HOU.Num_Proc_HEM,	HOU.Navio_HEM,	HOU.Viagem_HEM,	TC.Nome_Tp_Carga,	HOU.Peso_Bruto_HEM,
--		HOU.Peso_Liquido_HEM,	HOU.Vol_Tot_hem,	HOU.Qtd_Tot_Vol_HeM,	nr_reserva,
--		LLP.Cd_Tp_Carga,	ARMADOR_BL.Nome_Armador,	
--		ENDC.CD_pais,
--		CP180.Campo_Dados,
--		CP.Campo_Dados,
--		LCD.Cd_Pais
		
		




	
	
----select * from job_exp_mar where num_proc_hem = 'EMARC201711002BR '

----SELECT * FROM Tipo_Campo_Pessoa  WHERE Id_Campo = 18
----UPDATE Tipo_Campo_Pessoa SET Descr_Campo = 'USCI/NPWP Code' WHERE Id_Campo = 18

--ALTER Procedure [dbo].[spHBL_HEM_Rel]--[spHBL_HEM_Rel]'EMARC201711002BR','Admin','1'

--		@Processo 	VarChar (16),
--		@User		VarChar(50),
--		@Tipo		Char(1)
--As
--Select
--	--Shipper
--	SH.Nome_raz_soc					Shipper,
--	SH.num_cpf_cnpj					cnpj_S,	
--	ENDS.RUA						RUA_S,
--	ENDS.BAIRRO						BAIRRO_S,
--	ENDS.CIDADE						CIDADE_S,
--	UPPER(ENDS.PAIS)				PAIS_S,	
--	ENDS.NUMERO						NUMERO_S,	
--	UPPER(ENDS.UF)					UF_S,	
--	ENDS.CEP						CEP_S,	
--	cmcs.cd_int						cd_int_S,
--	cmcs.cd_area_fone				cd_areafone_S,
--	cmcs.prefixo					prefixo_S,
--	cmcs.num_fone					num_fone_S,
--	cmcs.compl_fone					compl_fone_S,
----Consignee
--	CS.Nome_raz_soc					Consignee,
--	RIGHT(CS.Num_CPF_CNPJ,14)		CNPJ_C,
--	ENDC.RUA						RUA_C,
--	ENDC.NUMERO						NUM_C,
--	ENDC.COMPL_END					COMPL_C,
--	ENDC.BAIRRO						BAIRRO_C,
--	ENDC.CIDADE						CIDADE_C,
--	UPPER(ENDC.PAIS)				PAIS_C,
--	ENDC.CEP						CEP_C,
--	CMC.contato						CONTATO_C,
--	CMC.Depto_Ctt					DEPTO_C,
--	CMC.cd_int						cd_int_C,
--	CMC.cd_area_fone				cd_areafone_C,
--	CMC.prefixo						prefixo_C,
--	CMC.num_fone					FONE_C,
--	CMC.compl_fone					COMPL_FONE_C,

----Notify	
--	NF.Nome_raz_Soc					Notify,
--	RIGHT(NF.Num_CPF_CNPJ,14)		CNPJ_N,
--	ENDN.RUA						RUA_N,
--	ENDN.BAIRRO						BAIRRO_N,
--	ENDN.CIDADE						CIDADE_N,
--	ENDN.COMPL_END					COMPL_N,
--	ENDN.NUMERO						NUMERO_N,
--	ENDN.CEP						CEP_N,
--	UPPER(ENDN.PAIS)				PAIS_N,
--	CMCN.contato					CONTATO_N,
--	CMCN.Depto_Ctt					DEPTO_N,
--	CMCN.cd_int						cd_int_N,
--	CMCN.cd_area_fone				cd_areafone_N,
--	CMCN.prefixo					prefixo_N,
--	CMCN.num_fone					FONE_N,
--	CMCN.compl_fone					COMPL_FONE_N,

--	--Bl
--	HOU.Num_Proc_Hem							Num_Proc,
--	HOU.HAWB_HEM								Num_BL,	
--	convert(varchar(10),LLP.Dt_Impres_LEM,103)	Dated_At,
--	dbo.fBusca_Docs_PO_Modal(@Processo,1)		PO,
--	LLP.Intl_Ref_Lem							JOB_Ref,
	
--	LCO.Pais_Local								Country_Origin,

----Consignee Master	
--	CSNM.Nome_Raz_Soc							ConsigM_Razao,
--	right(CSNM.Num_CPF_CNPJ,14)					ConsM_CNPJ,
--	EndNM.Rua									ConsM_Rua,
--	EndNM.Numero								ConsM_Num,
--	EndNM.Compl_End								ConsM_Compl,
--	EndNM.Bairro								ConsM_Bairro,
--	EndNM.CEP									ConsM_CEP,
--	EndNM.Cidade								ConsM_Cidade,
--	EndNM.UF									ConsM_UF,
--	EndNM.Pais									ConsM_Pais,
--	CttNM.Contato								ConsM_Contato,
--	('+' + CttNM.Cd_Int + ' ' + CttNM.Cd_Area_Fone + ' ' + CttNM.Prefixo + ' ' + CttNM.Num_Fone) ConsM_Fone,
--	CttNM.Compl_Fone							ConsM_Email,

--	(Origin.Nome_Local + ', ' + Origin.Pais_Local)			Place_Receipt,	
--	(LCO.Nome_Local + ', ' + LCO.Cd_Pais)					Port_Loading,
--	--LCD.Nome_Local											Port_Discharge,
--	(LCD.Nome_Local	+ ', ' + LCD.Cd_Pais)					Port_Discharge,
--	UPPER(LCD.Pais_Local)									Pais_Discharge,
--	(DstFinal.Nome_Local + ', ' + DstFinal.Cd_Pais)		Place_Delivery,	

--	HOU.Num_Proc_HEM			Num_Proc,
--	HOU.Navio_HEM				Navio1,
--	HOU.Viagem_HEM				Viagem,
--	TC.Nome_Tp_Carga			Tipo_Carga,
--	--HOU.Obs_HEM				Marks_Numbers,
--	HOU.Peso_Bruto_HEM			Gross_Weight,
--	HOU.Peso_Liquido_HEM		Net_Weight,
--	HOU.Vol_Tot_hem				Measupement,
	

--	(case when dbo.fBusca_Docs_PO_Modal(@Processo,2) is not null then
--		'INVOICE: ' + dbo.fBusca_Docs_PO_Modal(@Processo,2)
--	else
--		null end)				Invoice, 
--	'BOOKING: ' + nr_reserva	Booking,
--	'MBL: ' + HOU.MAWB_HEM		MBL,
----	HOU.Qtd_Tot_Vol_HeM			qtd_Pieces,
--	--convert(varchar,[dbo].[Qty_Container](@processo))+ ' X ' +
--	-- [dbo].[fBusca_Containers_TP](@processo) qtd_Pieces,

----15/09/2016 - Rafael 
--	-- (Case when LLP.Cd_Tp_Carga = 1 then
--	--	convert(varchar,[dbo].[Qty_Container](@processo))+ ' X ' + [dbo].[fBusca_Containers_TP](@processo)
--	--else
--	--	dbo.[fBusca_Volumes_QtdTipo] (@processo)	
--	--end) qtd_Pieces,
--	dbo.[fBusca_Volumes_QtyEmbal] (@Processo) qtd_Pieces,

--	isnull([dbo].[fBusca_CampoCliente](@processo,132),0) NumberOriginals,
	
--	ARMADOR_BL.Nome_Armador  ARMADOR_BL,
--	--BDP= "EIN23-1878776" e qdo for SilverBirch  = "EIN20-8141384" - vwArmador_HBL_EM
	
--	--(case when UPPER(ENDC.CD_pais) = 'CN' THEN	
--	--	CP180.Campo_Dados ELSE
--	--	'' END) 	EIN_Number,
--	--(case when UPPER(ENDC.CD_pais) = 'CN' THEN
--	--	CP.Campo_Dados ELSE
--	--	'' END) USCI	
		
--	--(case when UPPER(ENDC.CD_pais) = 'CN' THEN
--	(case when UPPER(LCD.Cd_Pais) in ('CN','ID')THEN
--		CP180.Campo_Dados ELSE
--		'' END) 	EIN_Number,
				
--	--(case when UPPER(ENDC.CD_pais) = 'CN' THEN
--	(case when UPPER(LCD.Cd_Pais) in ('CN','ID')THEN
--		CP.Campo_Dados ELSE
--		'' END) USCI		
		
--from
--	house_exp_mar Hou with(nolock)
--	Left Outer Join	Master_exp_mar		MAS with(nolock)		on MAS.num_proc_mem = HOU.num_proc_mem
--	Left Outer Join LLP_exp_mar			LLP with(nolock)		on HOU.Num_Proc_HEM = LLP.Num_Proc_LEM
--	Left Outer Join JOB_exp_mar			JOB with(nolock)		on HOU.Num_Proc_HEM = JOB.Num_Proc_HEM

--	Left Outer Join Pessoa				SH with(nolock)		on SH.cd_pes = cd_export_hem 
--	Left Outer Join Endereco			ENDS with(nolock)	on SH.cd_pes = ENDS.cd_pes and ENDS.cd_tp_end = 'COM' 
--	Left Outer Join comunicacao			CMCS with(nolock)	on SH.cd_pes = CMCS.cd_pes and CMCS.cd_tp_com = 'HBL'
	
--	Left Outer Join Pessoa				CS with(nolock)		on CS.cd_pes=cd_consig_hem
--	Left Outer Join Endereco			ENDC with(nolock)	on CS.cd_pes=ENDC.cd_pes  and ENDC.cd_tp_end = 'COM'	
--	Left Outer Join comunicacao			CMC	with(nolock)	on CS.cd_pes = CMC.cd_pes and CMC.cd_tp_com = 'HBL'	
 
--	Left Outer Join Pessoa				NF with(nolock)		on NF.cd_pes = HOU.cd_notify_hem
--	Left Outer Join Endereco			ENDN with(nolock)	on NF.cd_pes = ENDN.cd_pes  and ENDN.cd_tp_end = 'COM' 
--	Left Outer Join comunicacao			CMCN with(nolock)	on NF.cd_pes = CMCN.cd_pes and CMC.cd_tp_com = 'HBL'
  
--	Left Outer Join Localidade			LCO with(nolock)		on HOU.cd_org_Hem = LCO.cd_local
--	Left Outer Join Localidade			LCD with(nolock)		on HOU.cd_dst_hem = LCD.cd_local
--	Left Outer Join Localidade			Origin with(nolock)	on LLP.Cd_Planta_Lem	= Origin.Cd_Local
--	Left Outer Join Localidade			DstFinal with(nolock) on LLP.cd_dstfinal_lem	= Dstfinal.cd_local
--	Left Outer Join Tipo_Carga			TC with(nolock)		on LLP.Cd_Tp_Carga = TC.Cd_Tp_Carga and TC.Ativo_TP = 'S'	
--	--Left Outer Join Pessoa			NM		on NM.Cd_Pes		= Cd_Import_hem		
--	Left outer Join Pessoa				CSNM with(nolock)	on CSNM.Cd_Pes		= MAS.cd_consig_mem
--	Left outer Join Endereco			EndNM with(nolock)	on CSNM.Cd_Pes		= EndNM.Cd_Pes AND EndNM.cd_tp_end='COM'
--	Left outer Join Comunicacao			CttNM with(nolock)	on CttNM.Cd_Pes		= CSNM.Cd_Pes and CttNM.Cd_Tp_Com = 'HBL'	

--	Left outer Join Campo_Processo		CP179 with(nolock)	on HOU.Num_Proc_HEM = CP179.Num_Proc and CP179.Id_Campo = 179	
--	Left Outer Join Armador				ARMADOR_BL with(nolock)	on isnull(CP179.Campo_Dados,'BDP') = ARMADOR_BL.Cd_Armador
--	left join Campo_Pessoa				CP on CP.Cd_Pes = CS.Cd_Pes and cp.Id_Campo = '18'
--	Left outer Join Campo_Processo		CP180 with(nolock)	on HOU.Num_Proc_HEM = CP180.Num_Proc and CP180.Id_Campo = 180
	
--where

--	HOU.num_proc_hem = @Processo

--group by
--	SH.Nome_raz_soc,
--	SH.num_cpf_cnpj,	
--	ENDS.RUA,
--	ENDS.BAIRRO,
--	ENDS.CIDADE,
--	ENDS.PAIS,	
--	ENDS.NUMERO,	
--	ENDS.UF,	
--	ENDS.CEP,	
--	cmcs.cd_int,
--	cmcs.cd_area_fone,
--	cmcs.prefixo,
--	cmcs.num_fone,
--	cmcs.compl_fone,

--	CS.Nome_raz_soc,
--	cS.Num_CPF_CNPJ,
--	ENDC.RUA,
--	ENDC.NUMERO,
--	ENDC.COMPL_END,
--	ENDC.BAIRRO,
--	ENDC.CIDADE,
--	ENDC.PAIS,
--	ENDC.CEP,
--	CMC.contato,
--	CMC.Depto_Ctt,
--	CMC.cd_int,
--	CMC.cd_area_fone,
--	CMC.prefixo,
--	CMC.num_fone,
--	CMC.compl_fone,
	
--	NF.Nome_raz_Soc,
--	NF.Num_CPF_CNPJ,
--	ENDN.RUA,
--	ENDN.BAIRRO,
--	ENDN.CIDADE,
--	ENDN.COMPL_END,
--	ENDN.NUMERO,
--	ENDN.CEP,
--	ENDN.PAIS,
--	CMCN.contato,
--	CMCN.Depto_Ctt,
--	CMCN.cd_int,
--	CMCN.cd_area_fone,
--	CMCN.prefixo,
--	CMCN.num_fone,
--	CMCN.compl_fone,
	
--	HOU.Num_Proc_Hem,
--	HOU.HAWB_HEM,	
--	LLP.Dt_Impres_LEM,
--	--dbo.fBusca_Docs_PO_Modal(@Processo,1)		PO,
--	LLP.Intl_Ref_Lem,
--	HOU.MAWB_HEM,
--	LCO.Pais_Local,

--	CSNM.Nome_Raz_Soc,
--	CSNM.Num_CPF_CNPJ,
--	EndNM.Rua,
--	EndNM.Numero,
--	EndNM.Compl_End	,
--	EndNM.Bairro,
--	EndNM.CEP,
--	EndNM.Cidade,
--	EndNM.UF,
--	EndNM.Pais,
--	CttNM.Contato,
--	('+' + CttNM.Cd_Int + ' ' + CttNM.Cd_Area_Fone + ' ' + CttNM.Prefixo + ' ' + CttNM.Num_Fone),
--	CttNM.Compl_Fone,
--	Origin.Nome_Local,
--	Origin.Pais_Local,	
--	LCO.Nome_Local,
--	LCO.Pais_Local,
--	LCD.Nome_Local	+ ', ' + LCD.Cd_Pais,
--	UPPER(LCD.Pais_Local),
--	(DstFinal.Nome_Local + ', ' + DstFinal.Cd_Pais),
--	LCO.Cd_Pais,

--	HOU.Num_Proc_HEM,
--	HOU.Navio_HEM,
--	HOU.Viagem_HEM,
--	TC.Nome_Tp_Carga,
--	HOU.Peso_Bruto_HEM,
--	HOU.Peso_Liquido_HEM,
--	HOU.Vol_Tot_hem,
--	HOU.Qtd_Tot_Vol_HeM,
--	nr_reserva,
--	LLP.Cd_Tp_Carga,
--	ARMADOR_BL.Nome_Armador,
	
--	ENDC.CD_pais,
--	CP180.Campo_Dados,
--	CP.Campo_Dados,
--	LCD.Cd_Pais

	
----------------------------------------Bl antigo - antes do dia 20/05/2011 - cadu
--ALTER      Procedure [dbo].[spHEM_Rel]--'EMATL20101103001','Admin','1'
--
--		@Processo 	VarChar (16),
--		@User		VarChar(50),
--		@Tipo		Char(1)
--
--As
--
--Select
--	HOU.Num_Proc_Hem,
--	HOU.HAWB_HEM,
--
--	--Shipper
--	SH.Nome_raz_soc Shipper,
--	SH.num_cpf_cnpj cnpj_S,
--	ENDS.RUA RUA_S,
--	ENDS.NUMERO NUMERO_S,
--	UPPER(ENDS.BAIRRO) BAIRRO_S,
--	UPPER(ENDS.CIDADE) CIDADE_S,
--	UPPER(ENDS.UF) UF_S,
--	UPPER(ENDS.PAIS) PAIS_S,
--	ENDS.CEP CEP_S,	
--	cmcs.cd_int cd_int_S,
--	cmcs.cd_area_fone cd_areafone_S,
--	cmcs.prefixo prefixo_S,
--	cmcs.num_fone num_fone_S,
--	cmcs.compl_fone compl_fone_S,
--
--	cmcsF.cd_int cd_int_SF,
--	cmcsF.cd_area_fone cd_areafone_SF,
--	cmcsF.prefixo prefixo_SF,
--	cmcsF.num_fone num_fone_SF,
--	--cmcsF.compl_fone compl_fone_SF,	
--
--	--Consignee
--	CS.Nome_raz_soc Consignee,
--	ENDC.RUA RUA_C,
--	ENDC.BAIRRO BAIRRO_C,
--	ENDC.CIDADE CIDADE_C,
--	UPPER(ENDC.PAIS) PAIS_C,
--	CMC.contato CONTATO_C,
--	CMC.Depto_Ctt DEPTO_C,
--	CMC.cd_int cd_int_C,
--	CMC.cd_area_fone cd_areafone_C,
--	CMC.prefixo prefixo_C,
--	CMC.num_fone FONE_C,
--	CMC.compl_fone COMPL_FONE_C,
--	
--	CMCF.cd_int cd_int_CF,
--	CMCF.cd_area_fone cd_areafone_CF,
--	CMCF.prefixo prefixo_CF,
--	CMCF.num_fone FONE_CF,
--	--CMCF.compl_fone COMPL_FONE_CF,
--
--	--Notify	
--	NF.Nome_raz_Soc Notify,
--	ENDN.RUA RUA_N,
--	ENDN.BAIRRO BAIRRO_N,
--	ENDN.CIDADE CIDADE_N,
--	UPPER(ENDN.PAIS) PAIS_N,
--	CMCN.contato CONTATO_N,
--	CMCN.Depto_Ctt DEPTO_N,
--	CMCN.cd_int cd_int_N,
--	CMCN.cd_area_fone cd_areafone_N,
--	CMCN.prefixo prefixo_N,
--	CMCN.num_fone FONE_N,
--	CMCN.compl_fone COMPL_FONE_N,
--
--	CMCNF.cd_int cd_int_NF,
--	CMCNF.cd_area_fone cd_areafone_NF,
--	CMCNF.prefixo prefixo_NF,
--	CMCNF.num_fone FONE_NF,
--	--CMCNF.compl_fone COMPL_FONE_NF,
--
--	--ContactFF
--	CC.Nome_raz_soc Contact,
--	CC.num_cpf_cnpj cnpj_CC,
--	ENDCC.RUA RUA_CC,
--	ENDCC.NUMERO NUMERO_CC,
--	UPPER(ENDCC.BAIRRO) BAIRRO_CC,
--	UPPER(ENDCC.CIDADE) CIDADE_CC,
--	UPPER(ENDCC.UF) UF_CC,
--	UPPER(ENDCC.PAIS) PAIS_CC,
--	ENDCC.CEP CEP_CC,	
--	cmcC.cd_int cd_int_CC,
--	cmcC.cd_area_fone cd_areafone_CC,
--	cmcC.prefixo prefixo_CC,
--	cmcC.num_fone num_fone_CC,
--	cmcC.compl_fone compl_fone_CC,
--
--	hou.qtd_tot_vol_hem qtdade,
--
--	Dt_Impres_LEM DATA_ISSUE,
--	HOU.Navio_HEM Navio,
--	HOU.Viagem_HEM Viagem,
--	LCO.Nome_Local Port_Loading,
--	UPPER(LCO.Pais_Local) Pais_Loading,	
--	LCD.Nome_Local Port_Discharge,
--	UPPER(LCD.Pais_Local) Pais_Discharge,
--
--	Planta.nome_local 		Planta,
--	UPPER(Planta.Pais_Local) Planta_Pais,
--	DstFinal.Nome_Local 	DstFinal,
--	UPPER(DstFinal.Pais_Local) DstFinal_Pais,
--
--	TC.Nome_Tp_Carga Tipo_Carga,
--	NG.Descr Packages_GOODS,
--	dbo.fBusca_Containers (@Processo) container,	
--	dbo.fBusca_TipoContainers (@Processo) TipoContainer,
--	--CHEM.Num_cont_hem Num_Container,
--	--CHEM.Num_Lacre_hem Num_Lacre,
--	--Cast('TARE: ' + Cast(CHEM.Peso_Tare as varchar(20)) + ' KGS' as Varchar(20)) Peso_Tare,
--	--dbo.fContainerEM (@Processo) NO_PKGS,
--	HOU.Obs_HEM Marks_Numbers,
--	HOU.Peso_Bruto_HEM Gross_Weight,
--	HOU.Peso_Liquido_HEM Net_Weight,
--	HOU.Vol_Tot_hem Measupement,
--	HOU.tp_frete_hem Tipo_Frete,
--	dbo.fPO_Exp(@Processo,1) PO
--
--from
--	house_exp_mar Hou
--	Left Outer Join Pessoa SH on SH.cd_pes = cd_export_hem 
--	Left Outer Join Endereco ENDS on SH.cd_pes = ENDS.cd_pes and ENDS.cd_tp_end = 'COM' 
--	Left Outer Join comunicacao CMCS on SH.cd_pes = CMCS.cd_pes and CMCS.cd_tp_com = 'HBL'
--	Left Outer Join comunicacao CMCSF on SH.cd_pes = CMCSF.cd_pes and CMCSF.cd_tp_com = 'FC1'
--	--left join Pais PSS on ENDS.UF = PSS.cd_pais
--	Left Outer Join Pessoa CS on CS.cd_pes=cd_consig_hem
--	Left Outer Join Endereco ENDC on CS.cd_pes=ENDC.cd_pes  and ENDC.cd_tp_end = 'COM' 	
--	--left join PAIS PSC on ENDC.UF = PSC.cd_pais
--	Left Outer Join comunicacao CMC on CS.cd_pes = CMC.cd_pes and CMC.cd_tp_com = 'HBL'
--	Left Outer Join comunicacao CMCF on CS.cd_pes = CMCF.cd_pes and CMCF.cd_tp_com = 'FC1'
-- 
--	Left Outer Join Pessoa NF on NF.cd_pes = HOU.cd_notify_hem
--	Left Outer Join Endereco ENDN on NF.cd_pes = ENDN.cd_pes  and ENDN.cd_tp_end = 'COM' 
--	Left Outer Join comunicacao CMCN on NF.cd_pes = CMCN.cd_pes and CMC.cd_tp_com = 'HBL'
--	Left Outer Join comunicacao CMCNF on NF.cd_pes = CMCNF.cd_pes and CMCNF.cd_tp_com = 'FC1'
--  
--	--left join Pais PSN on ENDN.UF = PSN.cd_pais
--	Left Outer Join LLP_exp_mar LLP on HOU.Num_Proc_HEM = LLP.Num_Proc_LEM
--	Left Outer Join Localidade	Planta on LLP.cd_Planta_Lem = Planta.cd_local
--	Left Outer Join Localidade	DstFinal on LLP.cd_dstfinal_lem = Dstfinal.cd_local
--	Left Outer Join Armador CR on LLP.Cd_Armador_Lem = CR.Cd_Armador
--	Left Outer Join Localidade LCO on HOU.cd_org_Hem = LCO.cd_local
--	Left Outer Join Localidade LCD on HOU.cd_dst_hem = LCD.cd_local
--	--left join Pais PSD on LCD.cd_pais = PSD.cd_pais
--	Left Outer Join Nature_Goods NG on HOU.num_proc_hem = NG.Num_proc  
--	Left Outer Join container_hou_exp_mar CHEM on HOU.num_proc_hem = CHEM.Num_proc_hem
--	--left join PO_HEM PO on HOU.num_proc_hem = PO.Num_proc_hem
--	Left Outer Join Tipo_Carga TC on LLP.Cd_Tp_Carga = TC.Cd_Tp_Carga and TC.Ativo_TP = 'S'
--
--	left outer join master_exp_mar MEM on HOU.num_proc_mem = MEM.num_proc_mem
--	Left Outer Join Pessoa CC on CC.cd_pes = MEM.cd_consig_mem 
--	Left Outer Join Endereco ENDCC on CC.cd_pes = ENDCC.cd_pes and ENDCC.cd_tp_end = 'COM' 
--	Left Outer Join comunicacao CMCC on CC.cd_pes = CMCC.cd_pes --and CMC.cd_tp_com = 'HBL'
--	
--	
--where
--
--	HOU.num_proc_hem = @Processo
--
--group by
--	HOU.Num_Proc_Hem,
--	HOU.HAWB_HEM, 
--	SH.Nome_raz_soc,
--	SH.num_cpf_cnpj,
--	ENDS.RUA,
--	ENDS.NUMERO,
--	ENDS.BAIRRO,
--	ENDS.CIDADE,
--	ENDS.UF,
--	ENDS.PAIS,ENDS.CEP,
--
--	CS.Nome_raz_soc,		
--	cmcs.cd_int,
--	cmcs.cd_area_fone,
--	cmcs.prefixo,
--	cmcs.num_fone,
--	cmcs.compl_fone,
--	cmcsF.cd_int,
--	cmcsF.cd_area_fone,
--	cmcsF.prefixo,
--	cmcsF.num_fone,
--	
--	ENDC.RUA,
--	ENDC.BAIRRO,
--	ENDC.CIDADE,
--	ENDC.PAIS,
--	CMC.contato,
--	CMC.Depto_Ctt,
--	CMC.cd_int,
--	CMC.cd_area_fone,
--	CMC.prefixo,
--	CMC.num_fone,
--	CMC.compl_fone,
--	CMCF.cd_int,
--	CMCF.cd_area_fone,
--	CMCF.prefixo,
--	CMCF.num_fone,
--
--	NF.Nome_raz_Soc,
--	ENDN.RUA,
--	ENDN.BAIRRO,
--	ENDN.CIDADE,
--	ENDN.PAIS,
--	CMCN.contato,
--	CMCN.Depto_Ctt,
--	CMCN.cd_int,
--	CMCN.cd_area_fone,
--	CMCN.prefixo,
--	CMCN.num_fone,
--	CMCN.compl_fone,
--	CMCNF.cd_int,
--	CMCNF.cd_area_fone,
--	CMCNF.prefixo,
--	CMCNF.num_fone,
--
--	CC.Nome_raz_soc,
--	CC.num_cpf_cnpj,
--	ENDCC.RUA,
--	ENDCC.NUMERO,
--	ENDCC.BAIRRO,
--	ENDCC.CIDADE,
--	ENDCC.UF,
--	ENDCC.PAIS,
--	ENDCC.CEP,	
--	cmcC.cd_int,
--	cmcC.cd_area_fone,
--	cmcC.prefixo,
--	cmcC.num_fone,
--	cmcC.compl_fone,
--	
--	hou.qtd_tot_vol_hem,
--	
--	Dt_Impres_LEM,
--	HOU.Navio_HEM,
--	HOU.Viagem_HEM,
--	LCO.Nome_Local,
--	LCO.Pais_Local,
--	LCD.Nome_Local,
--	LCD.Pais_Local,
--	
--	Planta.nome_local,
--	Planta.Pais_Local,
--	DstFinal.Nome_Local,
--	DstFinal.Pais_Local,
--
--	TC.Nome_Tp_Carga,
--	NG.Descr,
--	--CHEM.Num_cont_hem Num_Container,
--	--CHEM.Num_Lacre_hem Num_Lacre,
--	--Cast('TARE: ' + Cast(CHEM.Peso_Tare as varchar(20)) + ' KGS' as Varchar(20)) Peso_Tare,
--	--dbo.fContainerEM (@Processo) NO_PKGS,
--	HOU.Obs_HEM,
--	HOU.Peso_Bruto_HEM,
--	HOU.Peso_Liquido_HEM,
--	HOU.Vol_Tot_hem,
--	HOU.tp_frete_hem
--	--dbo.fPO_Exp(@Processo,1) PO




GO
