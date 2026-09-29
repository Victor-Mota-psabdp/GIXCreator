SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from altera_bl where  num_proc = 'EMHLB201209002AR'

CREATE Procedure [dbo].[spHBL_HEM_Alterado_Rel]--[spHBL_HEM_Alterado_Rel]'EMARC201711001BR','Admin','1'

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

Select distinct
	--Shipper
		ABL.txtShipper				Shipper,
		UPPER(ENDS.PAIS)				PAIS_S,
		SH.num_cpf_cnpj					cnpj_S,	
		
	--Consignee
		ABL.txtConsignee			Consignee,	
		UPPER(ENDC.PAIS)				PAIS_C,
		RIGHT(CS.Num_CPF_CNPJ,14)		CNPJ_C,	

---------------------Antonio 17-10-2024--------------------------------------------------
			(case when @LocICS2=1 then 
			      'EORIConsignee: ' + isnull([dbo].[fBusca_CampoPessoa](CS.cd_pes,28),'') 
			 else
				  '  '
			 end) EORIConsignee,
-----------------------------------------------------------------------------------------


	--Notify
		ABL.txtNotify				Notify,
		RIGHT(NF.Num_CPF_CNPJ,14)		CNPJ_N,
		UPPER(ENDN.PAIS)				PAIS_N,	

	--To Obtain
		ABL.txtIssuing				ConsigM_RazaoAlterado,


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

	--Bl
	HOU.Num_Proc_Hem							Num_Proc,
	HOU.HAWB_HEM								Num_BL,	
	convert(varchar(10),LLP.Dt_Impres_LEM,103)	Dated_At,
	dbo.fBusca_Docs_PO_Modal(@Processo,1)		PO,
	LLP.Intl_Ref_Lem							JOB_Ref,
	HOU.MAWB_HEM								MBL,
	LCO.Pais_Local								Country_Origin,

--	(ABL.CmbOrigin + ', ' + Origin.Pais_Local)				Place_Receipt,
	ABL.CmbOrigin											Place_Receipt,
--	(ABL.cmbLoading + ', ' + LCO.Pais_Local)				Port_Loading,
	(ABL.cmbLoading	+ ', ' + LCO.Cd_Pais)					Port_Loading,	
	(ABL.cmbDelivery + ', ' + LCD.Cd_Pais)					Port_Discharge,
	UPPER(LCD.Pais_Local)									Pais_Discharge,
	(cmbFinalDestination + ', ' + DstFinal.Cd_Pais)		Place_Delivery,
--	cmbFinalDestination										Place_Delivery,

	ABL.cmbVessel				Navio1,
	ABL.txtVoyage				Viagem,
	
	HOU.Num_Proc_HEM			Num_Proc,
	
	TC.Nome_Tp_Carga			Tipo_Carga,
	--HOU.Obs_HEM				Marks_Numbers,
	HOU.Peso_Bruto_HEM			Gross_Weight,
	HOU.Peso_Liquido_HEM		Net_Weight,
	HOU.Vol_Tot_hem				Measupement,
--	HOU.Qtd_Tot_Vol_HeM			qtd_Pieces,
	
	
	(case when dbo.fBusca_Docs_PO_Modal(@Processo,2) is not null then
		'INVOICE: ' + dbo.fBusca_Docs_PO_Modal(@Processo,2)
	else
		null end)				Invoice, 
	'BOOKING: ' + nr_reserva	Booking,
	'MBL: ' + HOU.MAWB_HEM		MBL,
--	HOU.Qtd_Tot_Vol_HeM			qtd_Pieces,
	dbo.[fBusca_Volumes_QtyEmbal] (@Processo) qtd_Pieces,
	--convert(varchar,[dbo].[Qty_Container](@processo))+ ' X ' + [dbo].[fBusca_Containers_TP](@processo) qtd_Pieces,
	isnull([dbo].[fBusca_CampoCliente](@processo,132),0) NumberOriginals	,
	
	ARMADOR_BL.Nome_Armador  ARMADOR_BL,
	--BDP= "EIN23-1878776" e qdo for SilverBirch  = "EIN20-8141384" - vwArmador_HBL_EM
	
	(case when UPPER(ENDC.CD_pais) = 'CN' THEN	
		CP180.Campo_Dados ELSE
		'' END) 	EIN_Number,
	(case when UPPER(ENDC.CD_pais) = 'CN' THEN
		CP.Campo_Dados ELSE
		'' END) USCI


from
	house_exp_mar Hou with(nolock)
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
  	
	Left Outer Join Tipo_Carga			TC with(nolock)		on LLP.Cd_Tp_Carga = TC.Cd_Tp_Carga and TC.Ativo_TP = 'S'	
	--Left Outer Join Pessoa			NM		on NM.Cd_Pes		= Cd_Import_hem		
	--Left outer Join Pessoa				CSNM with(nolock)	on CSNM.Cd_Pes		=JOB.cd_agente
	Left outer Join Pessoa				CSNM with(nolock)	on CSNM.Cd_Pes		= MAS.cd_consig_mem
	Left outer Join Endereco			EndNM with(nolock)	on CSNM.Cd_Pes		= EndNM.Cd_Pes AND EndNM.cd_tp_end='COM'
	Left outer Join Comunicacao			CttNM with(nolock)	on CttNM.Cd_Pes		= CSNM.Cd_Pes and CttNM.cd_tp_com = 'TC1'

	left outer join	Altera_bl ABL with(nolock)		on ABL.num_proc = Hou.num_proc_hem and status = 1
	Left Outer Join Localidade Origin with(nolock)	on ABL.cmbOrigin = Origin.Nome_Local
	Left Outer Join Localidade LCO with(nolock)		on ABL.CmbLoading = LCO.Nome_Local
	Left Outer Join Localidade LCD with(nolock)		on ABL.cmbDelivery = LCD.Nome_Local
	Left Outer Join Localidade DstFinal with(nolock)	on ABL.cmbFinalDestination 	= DstFinal.Nome_Local

	Left Join PO_HEM PE	with(nolock) on HOU.Num_Proc_HEM=PE.Num_Proc_HEM and PE.ID_DC = 4	
	
	Left outer Join Campo_Processo		CP179 with(nolock)	on HOU.Num_Proc_HEM = CP179.Num_Proc and CP179.Id_Campo = 179	
	Left Outer Join Armador				ARMADOR_BL with(nolock)	on isnull(CP179.Campo_Dados,'BDP') = ARMADOR_BL.Cd_Armador
	left join Campo_Pessoa				CP on CP.Cd_Pes = CS.Cd_Pes and cp.Id_Campo = '18'
	Left outer Join Campo_Processo		CP180 with(nolock)	on HOU.Num_Proc_HEM = CP180.Num_Proc and CP180.Id_Campo = 180
	
where

	HOU.num_proc_hem = @Processo
	and ABL.status = 1

group by

	UPPER(ENDS.PAIS),
	SH.num_cpf_cnpj,
	UPPER(ENDC.PAIS),
	RIGHT(CS.Num_CPF_CNPJ,14),
	RIGHT(NF.Num_CPF_CNPJ,14),
	UPPER(ENDN.PAIS),
	ABL.txtShipper,
	ABL.txtConsignee,
	ABL.txtNotify,
	ABL.CmbOrigin,
	ABL.txtVessel,
	ABL.cmbVoyage,	
	ABL.cmbLoading,
	ABL.cmbDelivery + ', ' + LCD.Cd_Pais,	
	cmbFinalDestination + ', ' + DstFinal.Cd_Pais,
	LCO.Pais_Local,	
	Origin.Pais_Local,
	ABL.cmbVessel,
	ABL.txtVoyage,
	LCD.Pais_Local,
	cmbFinalDestination,
	DstFinal.Pais_Local,
	HOU.Num_Proc_Hem,
	HOU.HAWB_HEM,	
	LLP.Dt_Impres_LEM,
	--dbo.fBusca_Docs_PO_Modal(@Processo,1)		PO,
	LLP.Intl_Ref_Lem,
	HOU.MAWB_HEM,
	LCO.Pais_Local,
	LCO.Cd_Pais,
	ABL.txtIssuing,
	HOU.Num_Proc_HEM,
	TC.Nome_Tp_Carga,
	HOU.Peso_Bruto_HEM,
	HOU.Peso_Liquido_HEM,
	HOU.Vol_Tot_hem,
	HOU.Qtd_Tot_Vol_HeM,
	JOB.nr_reserva,
	PE.Numero_PO_HEM,
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
	ARMADOR_BL.Nome_Armador,
	
	ENDC.CD_pais,
	CP180.Campo_Dados,
	CP.Campo_Dados,
---------------------Antonio 17-10-2024 ----------------------------------------------------------------------------
		CS.cd_pes
--------------------------------------------------------------------------------------------------------------------


	



































GO
