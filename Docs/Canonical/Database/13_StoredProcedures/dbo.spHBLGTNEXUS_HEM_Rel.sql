SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--select * from job_exp_mar where num_proc_hem = 'EMROA201208001AR'
--select * from house_exp_mar where num_proc_hem = 'EMFLT201210001AR'
--select * from tipo_campo_cliente

--[spHBLGTNEXUS_HEM_Rel]'EMARG201604066AR','Admin','1'
create Procedure [dbo].[spHBLGTNEXUS_HEM_Rel]

		@Processo 	VarChar (16),
		@User		VarChar(50),
		@Tipo		Char(1)
As
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
	HOU.MAWB_HEM								MBL,
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
	(LCO.Nome_Local + ', ' + LCO.Pais_Local)				Port_Loading,
	LCD.Nome_Local											Port_Discharge,
	UPPER(LCD.Pais_Local)									Pais_Discharge,
	(DstFinal.Nome_Local + ', ' + DstFinal.Pais_Local)		Place_Delivery,	

	HOU.Num_Proc_HEM			Num_Proc,
	HOU.Navio_HEM				Navio1,
	HOU.Viagem_HEM				Viagem,
	TC.Nome_Tp_Carga			Tipo_Carga,
	--HOU.Obs_HEM				Marks_Numbers,
	HOU.Peso_Bruto_HEM			Gross_Weight,
	HOU.Peso_Liquido_HEM		Net_Weight,
	HOU.Vol_Tot_hem				Measupement,
	HOU.Qtd_Tot_Vol_HeM			qtd_Pieces,

	JOB.nr_reserva				Booking,
	[dbo].[fBusca_CampoCliente](@Processo,51) ExpressRelease,
	dbo.fBusca_Docs_PO_Modal(@Processo,4) [Permiso],
	 NG.Descr					Packages_GOODS
from
	house_exp_mar Hou
	Left Outer Join	Master_exp_mar		MAS with(nolock)		on MAS.num_proc_mem = HOU.num_proc_mem
	Left Outer Join LLP_exp_mar			LLP	with(nolock)	on HOU.Num_Proc_HEM = LLP.Num_Proc_LEM
	left outer join job_exp_mar			job	with(nolock)	on Hou.num_proc_hem = Job.num_proc_hem

	Left Outer Join Pessoa				SH	with(nolock)	on SH.cd_pes = cd_export_hem 
	Left Outer Join Endereco			ENDS with(nolock)	on SH.cd_pes = ENDS.cd_pes and ENDS.cd_tp_end = 'COM' 
	Left Outer Join comunicacao			CMCS with(nolock)	on SH.cd_pes = CMCS.cd_pes and CMCS.cd_tp_com = 'HBL'
	
	Left Outer Join Pessoa				CS with(nolock)		on CS.cd_pes=cd_consig_hem
	Left Outer Join Endereco			ENDC with(nolock)	on CS.cd_pes=ENDC.cd_pes  and ENDC.cd_tp_end = 'COM'	
	Left Outer Join comunicacao			CMC with(nolock)		on CS.cd_pes = CMC.cd_pes and CMC.cd_tp_com = 'HBL'	
 
	Left Outer Join Pessoa				NF with(nolock)		on NF.cd_pes = HOU.cd_notify_hem
	Left Outer Join Endereco			ENDN with(nolock)	on NF.cd_pes = ENDN.cd_pes  and ENDN.cd_tp_end = 'COM' 
	Left Outer Join comunicacao			CMCN with(nolock)	on NF.cd_pes = CMCN.cd_pes and CMC.cd_tp_com = 'HBL'
  
	Left Outer Join Localidade			LCO with(nolock)		on HOU.cd_org_Hem = LCO.cd_local
	Left Outer Join Localidade			LCD with(nolock)		on HOU.cd_dst_hem = LCD.cd_local
	Left Outer Join Localidade			Origin with(nolock)	on LLP.Cd_Planta_Lem	= Origin.Cd_Local
	Left Outer Join Localidade			DstFinal with(nolock) on LLP.cd_dstfinal_lem	= Dstfinal.cd_local
	Left Outer Join Tipo_Carga			TC with(nolock)		on LLP.Cd_Tp_Carga = TC.Cd_Tp_Carga and TC.Ativo_TP = 'S'	
	--Left Outer Join Pessoa			NM		on NM.Cd_Pes		= Cd_Import_hem		
--	Left outer Join Pessoa				CSNM	on CSNM.Cd_Pes		= MAS.cd_consig_mem
	Left outer Join Pessoa				CSNM with(nolock)	on CSNM.Cd_Pes		= JOB.cd_agente
	Left outer Join Endereco			EndNM with(nolock)	on CSNM.Cd_Pes		= EndNM.Cd_Pes AND EndNM.cd_tp_end='COM'
	Left outer Join Comunicacao			CttNM with(nolock)	on CttNM.Cd_Pes		= CSNM.Cd_Pes and CttNM.cd_tp_com = 'HBL'
	LEFT join Nature_Goods					NG with(nolock) on HOU.num_proc_hem = NG.Num_proc
	
where

	HOU.num_proc_hem = @Processo

group by
	SH.Nome_raz_soc,
	SH.num_cpf_cnpj,	
	ENDS.RUA,
	ENDS.BAIRRO,
	ENDS.CIDADE,
	ENDS.PAIS,	
	ENDS.NUMERO,	
	ENDS.UF,	
	ENDS.CEP,	
	cmcs.cd_int,
	cmcs.cd_area_fone,
	cmcs.prefixo,
	cmcs.num_fone,
	cmcs.compl_fone,

	CS.Nome_raz_soc,
	cS.Num_CPF_CNPJ,
	ENDC.RUA,
	ENDC.NUMERO,
	ENDC.COMPL_END,
	ENDC.BAIRRO,
	ENDC.CIDADE,
	ENDC.PAIS,
	ENDC.CEP,
	CMC.contato,
	CMC.Depto_Ctt,
	CMC.cd_int,
	CMC.cd_area_fone,
	CMC.prefixo,
	CMC.num_fone,
	CMC.compl_fone,
	
	NF.Nome_raz_Soc,
	NF.Num_CPF_CNPJ,
	ENDN.RUA,
	ENDN.BAIRRO,
	ENDN.CIDADE,
	ENDN.COMPL_END,
	ENDN.NUMERO,
	ENDN.CEP,
	ENDN.PAIS,
	CMCN.contato,
	CMCN.Depto_Ctt,
	CMCN.cd_int,
	CMCN.cd_area_fone,
	CMCN.prefixo,
	CMCN.num_fone,
	CMCN.compl_fone,
	
	HOU.Num_Proc_Hem,
	HOU.HAWB_HEM,	
	LLP.Dt_Impres_LEM,
	--dbo.fBusca_Docs_PO_Modal(@Processo,1)		PO,
	LLP.Intl_Ref_Lem,
	HOU.MAWB_HEM,
	LCO.Pais_Local,

	CSNM.Nome_Raz_Soc,
	CSNM.Num_CPF_CNPJ,
	EndNM.Rua,
	EndNM.Numero,
	EndNM.Compl_End	,
	EndNM.Bairro,
	EndNM.CEP,
	EndNM.Cidade,
	EndNM.UF,
	EndNM.Pais,
	CttNM.Contato,
	('+' + CttNM.Cd_Int + ' ' + CttNM.Cd_Area_Fone + ' ' + CttNM.Prefixo + ' ' + CttNM.Num_Fone),
	CttNM.Compl_Fone,
	Origin.Nome_Local,
	Origin.Pais_Local,	
	LCO.Nome_Local,
	LCO.Pais_Local,
	LCD.Nome_Local,
	UPPER(LCD.Pais_Local),
	(DstFinal.Nome_Local + ', ' + DstFinal.Pais_Local),

	HOU.Num_Proc_HEM,
	HOU.Navio_HEM,
	HOU.Viagem_HEM,
	TC.Nome_Tp_Carga,
	HOU.Peso_Bruto_HEM,
	HOU.Peso_Liquido_HEM,
	HOU.Vol_Tot_hem,
	HOU.Qtd_Tot_Vol_HeM,
	JOB.nr_reserva,
	NG.Descr
	







































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
