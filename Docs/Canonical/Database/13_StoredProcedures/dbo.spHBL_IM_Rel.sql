SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE Procedure [dbo].[spHBL_IM_Rel]--'IMVPF201104007BR','calves','O'
	@Processo 	VarChar (16),
	@User		VarChar(50),
	@Tipo		Char(1)
As
	Select
		HOU.Num_Proc_HIM	Num_Proc,
		HOU.HAWB_HIM		Num_BL,
		SH.Nome_raz_soc		Shipper,
		ENDS.RUA				RUA_S,
		ENDS.Numero				Numero_S,
		ENDS.BAIRRO				BAIRRO_S,
		ENDS.CIDADE				CIDADE_S,
		UPPER(ENDS.PAIS)		PAIS_S,
		CS.Nome_raz_soc		Consignee,
		RIGHT(CS.Num_CPF_CNPJ,14)	CNPJ_C,
		ENDC.RUA				RUA_C,
		ENDC.NUMERO				NUM_C,
		ENDC.COMPL_END			COMPL_C,
		ENDC.BAIRRO				BAIRRO_C,
		ENDC.CIDADE				CIDADE_C,
		UPPER(ENDC.PAIS)		PAIS_C,
		ENDC.CEP				CEP_C,
		CMC.contato				CONTATO_C,
		CMC.Depto_Ctt			DEPTO_C,
		CMC.num_fone			FONE_C,
		CMC.compl_fone			COMPL_FONE_C,
		NF.Nome_raz_Soc			Notify,
		(case when NF.cd_tp_grupo = 'PEF' then
			'CPF: ' + right(NF.Num_CPF_CNPJ,14) 
			else
			'CNPJ: ' + right(NF.Num_CPF_CNPJ,14) end) CNPJ_N,
--		RIGHT(NF.Num_CPF_CNPJ,14) CNPJ_N,
		ENDN.RUA				RUA_N,
		ENDN.BAIRRO				BAIRRO_N,
		ENDN.CIDADE				CIDADE_N,
		(case when NF.cd_tp_grupo = 'PEF' then
				'' 
			else
				UPPER(ENDN.PAIS) end) PAIS_N,
--		UPPER(ENDN.PAIS)		PAIS_N,
		ENDN.COMPL_END			COMPL_N,
		ENDN.NUMERO				NUMERO_N,
		(case when NF.cd_tp_grupo = 'PEF' then
			'' 
			else
			'CEP : ' + ENDN.CEP end) CEP_N,
--		ENDN.CEP				CEP_N,

--	Notify Master
		NM.Apelido			NotifyMaster,
		NM.Nome_Raz_Soc		NotM_Razao,
		right(NM.Num_CPF_CNPJ,14)NotM_CNPJ,
		EndNM.Rua			NotM_Rua,
		EndNM.Numero		NotM_Num,
		EndNM.Compl_End		NotM_Compl,
		EndNM.Bairro		NotM_Bairro,
		EndNM.CEP			NotM_CEP,
		EndNM.Cidade		NotM_Cidade,
		EndNM.UF			NotM_UF,
		EndNM.Pais			NotM_Pais,
		CttNM.Contato		NotM_Contato,
		('+' + CttNM.Cd_Int + ' ' + CttNM.Cd_Area_Fone + ' ' + CttNM.Prefixo + ' ' + CttNM.Num_Fone) NotM_Fone,
		CttNM.Compl_Fone	NotM_Email,

		HOU.Navio_HIM		Navio,
		HOU.Viagem_HIM		Viagem,
		(LCO.Nome_Local + ', ' + LCO.Pais_Local) Port_Loading,
		LCD.Nome_Local		Port_Discharge,
		UPPER(LCD.Pais_Local) Pais_Discharge,

		(Origin.Nome_Local + ', ' + Origin.Pais_Local) Place_Receipt,
		(DstFinal.Nome_Local + ', ' + DstFinal.Pais_Local) Place_Delivery,

		TC.Nome_Tp_Carga	Tipo_Carga,
		NG.Descr			Packages_GOODS,
		HOU.Obs_HIM			Marks_Numbers,
		hou.qtd_tot_vol_him	qtde,
		HOU.Peso_Bruto_HIM	Gross_Weight,
		HOU.Peso_Liquido_HIM Net_Weight,
		HOU.Vol_Tot_HIM		Measupement,
		HOU.tp_frete_HIM	Tipo_Frete,
		dbo.fBusca_Docs_PO_Modal(@Processo,1) PO,
		convert(varchar(10),LLP.Dt_Impres_LIM,103) Dated_At,
		LLP.Intl_Ref_Lim	JOB_Ref,
		HOU.MAWB_HIM		MBL,
		LCO.Pais_Local		Country_Origin,
		dbo.fBusca_CampoCliente(@Processo,'84') Navio1,
		NF.cd_tp_grupo
	from
		house_imp_mar Hou
		Left Outer Join LLP_imp_mar LLP on HOU.Num_Proc_HIM = LLP.Num_Proc_LIM
		Left Outer Join Job_Imp_Mar	JOB	on HOU.Num_Proc_HIM = JOB.Num_Proc_HIM
		Left Outer Join Pessoa SH on SH.cd_pes = cd_export_HIM 
		Left Outer Join Endereco ENDS on SH.cd_pes = ENDS.cd_pes and ENDS.cd_tp_end = 'COM' 
		Left Outer Join Pessoa CS on CS.cd_pes=cd_consig_HIM
		Left Outer Join Endereco ENDC on CS.cd_pes=ENDC.cd_pes  and ENDC.cd_tp_end = 'COM' 
		Left Outer Join comunicacao CMC on CS.cd_pes = CMC.cd_pes and CMC.cd_tp_com = 'HBL'  
		Left Outer Join Pessoa NF on NF.cd_pes = HOU.Cd_Import_HIM
		Left Outer Join Endereco ENDN on NF.cd_pes = ENDN.cd_pes  and ENDN.cd_tp_end = 'COM' 
		Left Outer Join Armador CR on JOB.Cd_Armador = CR.Cd_Armador
		Left Outer Join Localidade LCO on HOU.cd_org_HIM = LCO.cd_local
		Left Outer Join Localidade LCD on HOU.cd_dst_HIM = LCD.cd_local
		Left Outer Join Localidade	Origin		on LLP.Cd_Planta_Lim 	= Origin.Cd_Local
		Left Outer Join Localidade	DstFinal	on LLP.Cd_DstFinal_LIM 	= DstFinal.Cd_Local
		Left Outer Join Nature_Goods NG on HOU.num_proc_HIM = NG.Num_proc  
		Left Outer Join container_hou_imp_mar CHIM on HOU.num_proc_HIM = CHIM.Num_proc_HIM
		Left Outer Join Tipo_Carga TC on LLP.Cd_Tp_Carga = TC.Cd_Tp_Carga and TC.Ativo_TP = 'S'
		Left Outer Join Campo_Processo CPN	on CPN.Num_Proc		= HOU.Num_Proc_HIM and CPN.Id_Campo=33
		Left Outer Join Pessoa		NM		on NM.Cd_Pes		= CPN.Campo_Dados
		Left Outer Join Endereco	EndNM	on NM.Cd_Pes		= EndNM.Cd_Pes AND EndNM.cd_tp_end='COM'
		Left Outer Join Comunicacao	CttNM	on CttNM.Cd_Pes		= NM.Cd_Pes
	where
		HOU.num_proc_HIM = @Processo
	group by
		HOU.Num_Proc_HIM,
		HOU.HAWB_HIM, 
		SH.Nome_raz_soc,
		ENDS.RUA,
		ENDS.BAIRRO,
		ENDS.CIDADE,
		ENDS.PAIS,
		ENDS.Numero,
		CS.Nome_raz_soc,
		ENDC.RUA,
		ENDC.BAIRRO,
		ENDC.CIDADE,
		ENDC.PAIS,
		CMC.contato,
		CMC.Depto_Ctt,
		CMC.num_fone,
		CMC.compl_fone,
		NF.Nome_raz_Soc,
		ENDN.RUA,
		ENDN.BAIRRO,
		ENDN.CIDADE,
		ENDN.PAIS,
--		Dt_Impres_LIM,
		HOU.Navio_HIM,
		HOU.Viagem_HIM,
		LCO.Nome_Local,
		LCD.Nome_Local,
		LCD.Pais_Local,
		TC.Nome_Tp_Carga,
		NG.Descr,
		HOU.Obs_HIM,
		HOU.Peso_Bruto_HIM,
		HOU.Peso_Liquido_HIM,
		HOU.Vol_Tot_HIM,
		HOU.tp_frete_HIM,
		CS.Num_CPF_CNPJ,
		LLP.Intl_Ref_Lim,
		HOU.MAWB_HIM,
		LCO.Pais_Local,
		NM.Apelido			,
		NM.Nome_Raz_Soc		,
		right(NM.Num_CPF_CNPJ,14),
		EndNM.Rua			,
		EndNM.Numero		,
		EndNM.Compl_End		,
		EndNM.Bairro		,
		EndNM.CEP			,
		EndNM.Cidade		,
		EndNM.UF			,
		EndNM.Pais			,
		CttNM.Contato		,
		('+' + CttNM.Cd_Int + ' ' + CttNM.Cd_Area_Fone + ' ' + CttNM.Prefixo + ' ' + CttNM.Num_Fone),
		CttNM.Compl_Fone,
		(Origin.Nome_Local + ', ' + Origin.Pais_Local),
		(DstFinal.Nome_Local + ', ' + DstFinal.Pais_Local),
		ENDC.CEP,
		ENDC.NUMERO,
		ENDC.COMPL_END,
		LLP.Dt_Impres_LIM,
		NF.Num_CPF_CNPJ,
		ENDN.COMPL_END,
		ENDN.NUMERO,
		ENDN.CEP,
		NF.cd_tp_grupo,
		hou.qtd_tot_vol_him





GO
