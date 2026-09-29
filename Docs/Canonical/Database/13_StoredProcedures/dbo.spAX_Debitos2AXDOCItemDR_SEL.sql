SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  Procedure [dbo].[spAX_Debitos2AXDOCItemDR_SEL] --[dbo].[spAX_Debitos2AXDOCItem_SEL]  'IMOXT201304002BR','P20982'
	@Num_proc	Varchar(16),
	@Cd_PEs		Varchar(10),
	@DtIns	datetime
as

Select 
	0,
	I.num_proc_him Num_Proc,
	AXPT.cd_charge_AX Cd_Tp_TX,
	I.dc_him DC,
	Vlr_Org_him Valor,
	I.Cd_Tp_Moeda Moeda,
	HAWB_HIM Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	Case
		When upper(I.cd_tp_moeda)='REL' then 1.0000
		else  ISNULL(PAR.Par_Moeda,1) 
	End	 Paridade,
	'Ledger' AccountType,
	hou.MAWB_HIM MasterBOLNbr,
	Null MasterBookingNbr,
	(
		CASE  
				When DC_HIM='D' and RFI.num_registro is null then 'Exempt'
				When DC_HIM='C' and RFI.num_registro is null then 'Exempt'
				When DC_HIM='D' and RFI.num_registro is Not null then AV.TaxGroup  
				When DC_HIM='C' and RFI.num_registro is Not null then AV.TaxGroup  
		End	
	)
	  TaxGroup,
	Obs_HIM Notes,
	(
		Case Num_Proc_MIM
			when  'JOB' then ''
			else num_proc_mim
		end
	)
	 Num_PRoc_MAster,


	(
		CASE  
				When DC_HIM='D' and RFI.num_registro is null then AXPT.CC_Custo
				When DC_HIM='C' and RFI.num_registro is null then AXPT.CC_Receita
				When DC_HIM='D' and RFI.num_registro is Not null then AX.CC_Custo
				When DC_HIM='C' and RFI.num_registro is Not null then AX.CC_Receita
		End	
	) Account_Number,
	
	1 Invoicing,
	(
		Case 
			When cd_servico is not null then cd_servico
			else Null
		End
	) citCityHallServiceCode,
	
	
	Null citCityHallServiceDesc,
	(
		Case 
			When cd_servico is not null then Dt_Ins
			else Null
		End
	) CitTransDateNF,
	
	Null [07Invoice],
	
	(
		Case 
			When cd_servico is not null then Doc_Number
			else Null
		End
	) DocumentNum,
	
	
	
	I.cd_tp_Tx Codigo_TX_ATL
	
	
	
 From cta_Cte_hou_Imp_Mar I
 --Join Fatura F on F.FatCod = I.FatCod 
		Join House_imp_mar Hou on hou.num_proc_him=I.num_proc_him
		Join Job_Imp_Mar Job on Job.Num_Proc_HIM=Hou.Num_Proc_HIM 
		Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
		Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_him
		Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
		Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_AX 
		Left Join Tipo_TAxa_AX AXPT on AX.CD_Charge_AX_PT=AXPT.cd_Charge_AX
		LEft Join registro_financeiro_item RFI on I.num_proc_him=rfi.num_proc and I.dc_him=rfi.dc and I.cd_Tp_tx=RFI.cd_tp_tx
		Left Join Registro_Financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
		Join Pessoa PP on PP.cd_pes=cd_Cred_dev_him 
		Left Join Pessoa_ATL_AX AXPP on (cd_tp_ativ <> 'AGT' and AXPP.Cd_Pes = PP.Cd_Pes  or cd_tp_Ativ='AGT' and left(AXPP.cd_pes,len(axPP.cd_pes)-1)=PP.cd_pes) and Tipo='F'
		Join dbo.AX_XML_Vendor_Recebido AV on accountnum=axpp.cd_ax
		Left Join Ax_Doc_ITem IC on IC.num_proc=I.num_proc_him and IC.cd_tp_Tx_ATL=I.cd_Tp_Tx and IC.Dc=I.dc_him
 Where
	I.num_proc_him = @num_proc and I.dc_him='D' and cd_Cred_Dev_him=@cd_pes
	and  desp_org_him='N'
	and convert(datetime,dt_ins_him,105)=@DtIns	
--and RFI.num_registro is not null
	and IC.num_proc is null
/*
Union all


Select 
	0,
	HOU.num_proc_him Num_Proc,
	AXPT.cd_charge_AX Cd_Tp_TX,
	I.dc_mim DC,
	Vlr_Org_mim*[dbo].[spRateio_Mas](hou.num_proc_him) Valor,
	I.Cd_Tp_Moeda Moeda,
	HAWB_HIM Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	
	Case
		When upper(I.cd_tp_moeda)='REL' then 1.0000
		else  ISNULL(PAR.Par_Moeda,1) 
	End	 Paridade,
	'Ledger' AccountType,
	hou.MAWB_HIM MasterBOLNbr,
	Null MasterBookingNbr,
	TaxGroup  TaxGroup,
	Obs_HIM Notes,
	(
		Case hou.Num_Proc_MIM
			when  'JOB' then ''
			else hou.num_proc_mim
		end
	)
	 Num_PRoc_MAster,


	(
		CASE  
				When DC_MIM='D' and RFI.num_registro is null then AXPT.CC_Custo
				When DC_MIM='C' and RFI.num_registro is null then AXPT.CC_Receita
				When DC_MIM='D' and RFI.num_registro is Not null then AX.CC_Custo
				When DC_MIM='C' and RFI.num_registro is Not null then AX.CC_Receita
		End	
	) Account_Number,
	
	1 Invoicing,
	(
		Case 
			When cd_servico is not null then cd_servico
			else Null
		End
	) citCityHallServiceCode,
	
	
	Null citCityHallServiceDesc,
	(
		Case 
			When cd_servico is not null then Dt_Ins
			else Null
		End
	) CitTransDateNF,
	
	Null [07Invoice],
	
	(
		Case 
			When cd_servico is not null then Doc_Number
			else Null
		End
	) DocumentNum,
	
	
	
	I.cd_tp_Tx Codigo_TX_ATL
	
	
	
 From cta_Cte_mas_Imp_Mar I
 --Join Fatura F on F.FatCod = I.FatCod 
		Join House_imp_mar Hou on hou.num_proc_mim=I.num_proc_mim
		Join Job_Imp_Mar Job on Job.Num_Proc_HIM=Hou.Num_Proc_HIM 
		Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
		Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_mim
		Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
		Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_AX 
		Left Join Tipo_TAxa_AX AXPT on AX.CD_Charge_AX_PT=AXPT.cd_Charge_AX
		LEft Join registro_financeiro_item RFI on I.num_proc_mim=rfi.num_proc and I.dc_mim=rfi.dc and I.cd_Tp_tx=RFI.cd_tp_tx
		Left Join Registro_Financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
		Join Pessoa PP on PP.cd_pes=cd_Cred_dev_mim 
		Left Join Pessoa_ATL_AX AXPP on (cd_tp_ativ <> 'AGT' and AXPP.Cd_Pes = PP.Cd_Pes  or cd_tp_Ativ='AGT' and left(AXPP.cd_pes,len(axPP.cd_pes)-1)=PP.cd_pes) and Tipo='F'
		Join dbo.AX_XML_Vendor_Recebido AV on accountnum=axpp.cd_ax
 Where
	I.num_proc_mim = @num_proc and I.dc_mim='D' and cd_Cred_Dev_mim=@cd_pes
	and  desp_org_mim='N'
	and convert(datetime,dt_ins_mim,105)=@DtIns	


Union all


Select 
	0,
	I.num_proc_hia Num_Proc,
	AXPT.cd_charge_AX Cd_Tp_TX,
	I.dc_hia DC,
	Vlr_Org_hia Valor,
	I.Cd_Tp_Moeda Moeda,
	HAWB_HIA Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	
	Case
		When upper(I.cd_tp_moeda)='REL' then 1.0000
		else  ISNULL(PAR.Par_Moeda,1) 
	End	 Paridade,
	'Ledger' AccountType,
	hou.MAWB_HIA MasterBOLNbr,
	Null MasterBookingNbr,
	TaxGroup  TaxGroup,
	Obs_HIA Notes,
	(
		Case Num_Proc_MIA
			when  'JOB' then ''
			else num_proc_miA
		end
	)
	 Num_PRoc_MAster,


	(
		CASE  
				When DC_HIA='D' and RFI.num_registro is null then AXPT.CC_Custo
				When DC_HIA='C' and RFI.num_registro is null then AXPT.CC_Receita
				When DC_HIA='D' and RFI.num_registro is Not null then AX.CC_Custo
				When DC_HIA='C' and RFI.num_registro is Not null then AX.CC_Receita
		End	
	) Account_Number,
	
	1 Invoicing,
	(
		Case 
			When cd_servico is not null then cd_servico
			else Null
		End
	) citCityHallServiceCode,
	
	
	Null citCityHallServiceDesc,
	(
		Case 
			When cd_servico is not null then Dt_Ins
			else Null
		End
	) CitTransDateNF,
	
	Null [07Invoice],
	
	(
		Case 
			When cd_servico is not null then Doc_Number
			else Null
		End
	) DocumentNum,
	
	
	
	I.cd_tp_Tx Codigo_TX_ATL
	
	
	
 From cta_Cte_hou_Imp_Aer I
 --Join Fatura F on F.FatCod = I.FatCod 
		Join House_imp_aer Hou on hou.num_proc_hia=I.num_proc_hia
		Join Job_Imp_aer Job on Job.Num_Proc_HIa=Hou.Num_Proc_HIa 
		Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
		Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_hia
		Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
		Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_AX 
		Left Join Tipo_TAxa_AX AXPT on AX.CD_Charge_AX_PT=AXPT.cd_Charge_AX
		LEft Join registro_financeiro_item RFI on I.num_proc_hia=rfi.num_proc and I.dc_hia=rfi.dc and I.cd_Tp_tx=RFI.cd_tp_tx
		Left Join Registro_Financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
		Join Pessoa PP on PP.cd_pes=cd_Cred_dev_hia 
		Left Join Pessoa_ATL_AX AXPP on (cd_tp_ativ <> 'AGT' and AXPP.Cd_Pes = PP.Cd_Pes  or cd_tp_Ativ='AGT' and left(AXPP.cd_pes,len(axPP.cd_pes)-1)=PP.cd_pes) and Tipo='F'
		Join dbo.AX_XML_Vendor_Recebido AV on accountnum=axpp.cd_ax
 Where
	I.num_proc_hia = @num_proc and I.dc_hia='D' and cd_Cred_Dev_hia=@cd_pes
	and desp_org_hia='N'
	and convert(datetime,dt_ins_hia,105)=@DtIns	


Union all


Select 
	0,
	HOU.num_proc_hia Num_Proc,
	AXPT.cd_charge_AX Cd_Tp_TX,
	I.dc_mia DC,
	Vlr_Org_mia*[dbo].[spRateio_Mas](hou.num_proc_hia) Valor,
	I.Cd_Tp_Moeda Moeda,
	HAWB_HIa Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	Case
		When upper(I.cd_tp_moeda)='REL' then 1.0000
		else  ISNULL(PAR.Par_Moeda,1) 
	End	 Paridade,
	'Ledger' AccountType,
	hou.MAWB_HIa MasterBOLNbr,
	Null MasterBookingNbr,
	TaxGroup  TaxGroup,
	Obs_HIa Notes,
	(
		Case hou.Num_Proc_MIa
			when  'JOB' then ''
			else hou.num_proc_mia
		end
	)
	 Num_PRoc_MAster,


	(
		CASE  
				When DC_MIA='D' and RFI.num_registro is null then AXPT.CC_Custo
				When DC_MIA='C' and RFI.num_registro is null then AXPT.CC_Receita
				When DC_MIA='D' and RFI.num_registro is Not null then AX.CC_Custo
				When DC_MIA='C' and RFI.num_registro is Not null then AX.CC_Receita
		End	
	) Account_Number,
	
	1 Invoicing,
	(
		Case 
			When cd_servico is not null then cd_servico
			else Null
		End
	) citCityHallServiceCode,
	
	
	Null citCityHallServiceDesc,
	(
		Case 
			When cd_servico is not null then Dt_Ins
			else Null
		End
	) CitTransDateNF,
	
	Null [07Invoice],
	
	(
		Case 
			When cd_servico is not null then Doc_Number
			else Null
		End
	) DocumentNum,
	
	
	
	I.cd_tp_Tx Codigo_TX_ATL
	
	
	
 From cta_Cte_mas_Imp_aer I
 --Join Fatura F on F.FatCod = I.FatCod 
		Join House_imp_aer Hou on hou.num_proc_mia=I.num_proc_mia
		Join Job_Imp_aer Job on Job.Num_Proc_HIa=Hou.Num_Proc_HIa 
		Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
		Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_mia
		Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
		Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_AX 
		Left Join Tipo_TAxa_AX AXPT on AX.CD_Charge_AX_PT=AXPT.cd_Charge_AX
		LEft Join registro_financeiro_item RFI on I.num_proc_mia=rfi.num_proc and I.dc_mia=rfi.dc and I.cd_Tp_tx=RFI.cd_tp_tx
		Left Join Registro_Financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
		Join Pessoa PP on PP.cd_pes=cd_Cred_dev_mia 
		Left Join Pessoa_ATL_AX AXPP on (cd_tp_ativ <> 'AGT' and AXPP.Cd_Pes = PP.Cd_Pes  or cd_tp_Ativ='AGT' and left(AXPP.cd_pes,len(axPP.cd_pes)-1)=PP.cd_pes) and Tipo='F'
		Join dbo.AX_XML_Vendor_Recebido AV on accountnum=axpp.cd_ax
 Where
	I.num_proc_mia = @num_proc and I.dc_mia='D' and cd_Cred_Dev_mia=@cd_pes
	and desp_org_mia='N'
	and convert(datetime,dt_ins_mia,105)=@DtIns	



Union all


Select 
	0,
	I.num_proc_hem Num_Proc,
	AXPT.cd_charge_AX Cd_Tp_TX,
	I.dc_hem DC,
	Vlr_Org_hem Valor,
	I.Cd_Tp_Moeda Moeda,
	HAWB_Hem Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	
	Case
		When upper(I.cd_tp_moeda)='REL' then 1.0000
		else  ISNULL(PAR.Par_Moeda,1) 
	End	 Paridade,
	'Ledger' AccountType,
	hou.MAWB_Hem MasterBOLNbr,
	Null MasterBookingNbr,
	TaxGroup  TaxGroup,
	Obs_Hem Notes,
	(
		Case Num_Proc_Mem
			when  'JOB' then ''
			else num_proc_mem
		end
	)
	 Num_PRoc_MAster,


	(
		CASE  
				When DC_HeM='D' and RFI.num_registro is null then AXPT.CC_Custo
				When DC_HEM='C' and RFI.num_registro is null then AXPT.CC_Receita
				When DC_HEM='D' and RFI.num_registro is Not null then AX.CC_Custo
				When DC_HEM='C' and RFI.num_registro is Not null then AX.CC_Receita
		End	
	) Account_Number,
	
	1 Invoicing,
	(
		Case 
			When cd_servico is not null then cd_servico
			else Null
		End
	) citCityHallServiceCode,
	
	
	Null citCityHallServiceDesc,
	(
		Case 
			When cd_servico is not null then Dt_Ins
			else Null
		End
	) CitTransDateNF,
	
	Null [07Invoice],
	
	(
		Case 
			When cd_servico is not null then Doc_Number
			else Null
		End
	) DocumentNum,
	
	
	
	I.cd_tp_Tx Codigo_TX_ATL
	
	
	
 From cta_Cte_hou_Exp_Mar I
 --Join Fatura F on F.FatCod = I.FatCod 
		Join House_exp_mar Hou on hou.num_proc_hem=I.num_proc_hem
		Join Job_exp_Mar Job on Job.Num_Proc_HeM=Hou.Num_Proc_HeM 
		Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
		Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_hem
		Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
		Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_AX 
		Left Join Tipo_TAxa_AX AXPT on AX.CD_Charge_AX_PT=AXPT.cd_Charge_AX
		LEft Join registro_financeiro_item RFI on I.num_proc_hem=rfi.num_proc and I.dc_hem=rfi.dc and I.cd_Tp_tx=RFI.cd_tp_tx
		Left Join Registro_Financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
		Join Pessoa PP on PP.cd_pes=cd_Cred_dev_hem 
		Left Join Pessoa_ATL_AX AXPP on (cd_tp_ativ <> 'AGT' and AXPP.Cd_Pes = PP.Cd_Pes  or cd_tp_Ativ='AGT' and left(AXPP.cd_pes,len(axPP.cd_pes)-1)=PP.cd_pes) and Tipo='F'
		Join dbo.AX_XML_Vendor_Recebido AV on accountnum=axpp.cd_ax
 Where
	I.num_proc_hem = @num_proc and I.dc_hem='D' and cd_Cred_Dev_hem=@cd_pes
	and desp_dst_hem='N'
	and convert(datetime,dt_ins_hem,105)=@DtIns	


Union all


Select 
	0,
	HOU.num_proc_hem Num_Proc,
	AXPT.cd_charge_AX Cd_Tp_TX,
	I.dc_mem DC,
	Vlr_Org_mem*[dbo].[spRateio_Mas](hou.num_proc_hem) Valor,
	I.Cd_Tp_Moeda Moeda,
	HAWB_HEM Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	
	Case
		When upper(I.cd_tp_moeda)='REL' then 1.0000
		else  ISNULL(PAR.Par_Moeda,1) 
	End	 Paridade,
	'Ledger' AccountType,
	hou.MAWB_HEM MasterBOLNbr,
	Null MasterBookingNbr,
	TaxGroup  TaxGroup,
	Obs_HEM Notes,
	(
		Case hou.Num_Proc_MEM
			when  'JOB' then ''
			else hou.num_proc_mEM
		end
	)
	 Num_PRoc_MAster,


	(
		CASE  
				When DC_MEM='D' and RFI.num_registro is null then AXPT.CC_Custo
				When DC_MEM='C' and RFI.num_registro is null then AXPT.CC_Receita
				When DC_MEM='D' and RFI.num_registro is Not null then AX.CC_Custo
				When DC_MEM='C' and RFI.num_registro is Not null then AX.CC_Receita
		End	
	) Account_Number,
	
	1 Invoicing,
	(
		Case 
			When cd_servico is not null then cd_servico
			else Null
		End
	) citCityHallServiceCode,
	
	
	Null citCityHallServiceDesc,
	(
		Case 
			When cd_servico is not null then Dt_Ins
			else Null
		End
	) CitTransDateNF,
	
	Null [07Invoice],
	
	(
		Case 
			When cd_servico is not null then Doc_Number
			else Null
		End
	) DocumentNum,
	
	
	
	I.cd_tp_Tx Codigo_TX_ATL
	
	
	
 From cta_Cte_mas_exp_mar I
 --Join Fatura F on F.FatCod = I.FatCod 
		Join House_exp_mar Hou on hou.num_proc_mem=I.num_proc_mem
		Join Job_exp_mar Job on Job.Num_Proc_Hem=Hou.Num_Proc_HEM
		Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
		Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_mEM
		Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
		Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_AX 
		Left Join Tipo_TAxa_AX AXPT on AX.CD_Charge_AX_PT=AXPT.cd_Charge_AX
		LEft Join registro_financeiro_item RFI on I.num_proc_mem=rfi.num_proc and I.dc_mem=rfi.dc and I.cd_Tp_tx=RFI.cd_tp_tx
		Left Join Registro_Financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
		Join Pessoa PP on PP.cd_pes=cd_Cred_dev_mem 
		Left Join Pessoa_ATL_AX AXPP on (cd_tp_ativ <> 'AGT' and AXPP.Cd_Pes = PP.Cd_Pes  or cd_tp_Ativ='AGT' and left(AXPP.cd_pes,len(axPP.cd_pes)-1)=PP.cd_pes) and Tipo='F'
		Join dbo.AX_XML_Vendor_Recebido AV on accountnum=axpp.cd_ax
 Where
	I.num_proc_mem = @num_proc and I.dc_mem='D' and cd_Cred_Dev_mem=@cd_pes
	and desp_dst_mem='N'
	and convert(datetime,dt_ins_mem,105)=@DtIns	


Union all


Select 
	0,
	I.num_proc_hea Num_Proc,
	AXPT.cd_charge_AX Cd_Tp_TX,
	I.dc_hea DC,
	Vlr_Org_hea Valor,
	I.Cd_Tp_Moeda Moeda,
	HAWB_Hea Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	
	Case
		When upper(I.cd_tp_moeda)='REL' then 1.0000
		else  ISNULL(PAR.Par_Moeda,1) 
	End	 Paridade,
	'Ledger' AccountType,
	hou.MAWB_Hea MasterBOLNbr,
	Null MasterBookingNbr,
	TaxGroup  TaxGroup,
	Obs_Hea Notes,
	(
		Case Num_Proc_Mea
			when  'JOB' then ''
			else num_proc_mea
		end
	)
	 Num_PRoc_MAster,


	(
		CASE  
				When DC_HeA='D' and RFI.num_registro is null then AXPT.CC_Custo
				When DC_HEA='C' and RFI.num_registro is null then AXPT.CC_Receita
				When DC_HEA='D' and RFI.num_registro is Not null then AX.CC_Custo
				When DC_HEA='C' and RFI.num_registro is Not null then AX.CC_Receita
		End	
	) Account_Number,
	
	1 Invoicing,
	(
		Case 
			When cd_servico is not null then cd_servico
			else Null
		End
	) citCityHallServiceCode,
	
	
	Null citCityHallServiceDesc,
	(
		Case 
			When cd_servico is not null then Dt_Ins
			else Null
		End
	) CitTransDateNF,
	
	Null [07Invoice],
	
	(
		Case 
			When cd_servico is not null then Doc_Number
			else Null
		End
	) DocumentNum,
	
	
	
	I.cd_tp_Tx Codigo_TX_ATL
	
	
	
 From cta_Cte_hou_Exp_Aer I
 --Join Fatura F on F.FatCod = I.FatCod 
		Join House_exp_aer Hou on hou.num_proc_hea=I.num_proc_hea
		Join Job_exp_aer Job on Job.Num_Proc_Hea=Hou.Num_Proc_Hea 
		Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
		Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_hea
		Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
		Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_AX 
		Left Join Tipo_TAxa_AX AXPT on AX.CD_Charge_AX_PT=AXPT.cd_Charge_AX
		LEft Join registro_financeiro_item RFI on I.num_proc_hea=rfi.num_proc and I.dc_hea=rfi.dc and I.cd_Tp_tx=RFI.cd_tp_tx
		Left Join Registro_Financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
		Join Pessoa PP on PP.cd_pes=cd_Cred_dev_hea 
		Left Join Pessoa_ATL_AX AXPP on (cd_tp_ativ <> 'AGT' and AXPP.Cd_Pes = PP.Cd_Pes  or cd_tp_Ativ='AGT' and left(AXPP.cd_pes,len(axPP.cd_pes)-1)=PP.cd_pes) and Tipo='F'
		Join dbo.AX_XML_Vendor_Recebido AV on accountnum=axpp.cd_ax
 Where
	I.num_proc_hea = @num_proc and I.dc_hea='D' and cd_Cred_Dev_hea=@cd_pes
	and desp_dst_hea='N'
	and convert(datetime,dt_ins_hea,105)=@DtIns	
union all
Select 
	0,
	HOU.num_proc_hea Num_Proc,
	AXPT.cd_charge_AX Cd_Tp_TX,
	I.dc_mea DC,
	Vlr_Org_mea*[dbo].[spRateio_Mas](hou.num_proc_hea) Valor,
	I.Cd_Tp_Moeda Moeda,
	HAWB_HEa Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	
	Case
		When upper(I.cd_tp_moeda)='REL' then 1.0000
		else  ISNULL(PAR.Par_Moeda,1) 
	End	 Paridade,
	'Ledger' AccountType,
	hou.MAWB_HEa MasterBOLNbr,
	Null MasterBookingNbr,
	TaxGroup  TaxGroup,
	Obs_HEA Notes,
	(
		Case hou.Num_Proc_MEA
			when  'JOB' then ''
			else hou.num_proc_mEA
		end
	)
	 Num_PRoc_MAster,


	(
		CASE  
				When DC_MEa='D' and RFI.num_registro is null then AXPT.CC_Custo
				When DC_MEa='C' and RFI.num_registro is null then AXPT.CC_Receita
				When DC_MEA='D' and RFI.num_registro is Not null then AX.CC_Custo
				When DC_MEA='C' and RFI.num_registro is Not null then AX.CC_Receita
		End	
	) Account_Number,
	
	1 Invoicing,
	(
		Case 
			When cd_servico is not null then cd_servico
			else Null
		End
	) citCityHallServiceCode,
	
	
	Null citCityHallServiceDesc,
	(
		Case 
			When cd_servico is not null then Dt_Ins
			else Null
		End
	) CitTransDateNF,
	
	Null [07Invoice],
	
	(
		Case 
			When cd_servico is not null then Doc_Number
			else Null
		End
	) DocumentNum,
	
	
	
	I.cd_tp_Tx Codigo_TX_ATL
	
	
	
 From cta_Cte_mas_exp_aer I
 --Join Fatura F on F.FatCod = I.FatCod 
		Join House_exp_aer Hou on hou.num_proc_mea=I.num_proc_mea
		Join Job_exp_aer Job on Job.Num_Proc_Hea=Hou.Num_Proc_HEa
		Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
		Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_mEa
		Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
		Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_AX 
		Left Join Tipo_TAxa_AX AXPT on AX.CD_Charge_AX_PT=AXPT.cd_Charge_AX
		LEft Join registro_financeiro_item RFI on I.num_proc_mea=rfi.num_proc and I.dc_mea=rfi.dc and I.cd_Tp_tx=RFI.cd_tp_tx
		Left Join Registro_Financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
		Join Pessoa PP on PP.cd_pes=cd_Cred_dev_mea 
		Left Join Pessoa_ATL_AX AXPP on (cd_tp_ativ <> 'AGT' and AXPP.Cd_Pes = PP.Cd_Pes  or cd_tp_Ativ='AGT' and left(AXPP.cd_pes,len(axPP.cd_pes)-1)=PP.cd_pes) and Tipo='F'
		Join dbo.AX_XML_Vendor_Recebido AV on accountnum=axpp.cd_ax
 Where
	I.num_proc_mea = @num_proc and I.dc_mea='D' and cd_Cred_Dev_mea=@cd_pes
	and desp_dst_mea='N'
	and convert(datetime,dt_ins_mea,105)=@DtIns	


Union all

Select 
	0,
	I.num_proc_hio Num_Proc,
	AXPT.cd_charge_AX Cd_Tp_TX,
	I.dc_hio DC,
	Vlr_Org_hio Valor,
	I.Cd_Tp_Moeda Moeda,
	HAWB_HIo Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	
	Case
		When upper(I.cd_tp_moeda)='REL' then 1.0000
		else  ISNULL(PAR.Par_Moeda,1) 
	End	 Paridade,
	'Ledger' AccountType,
	Null MasterBOLNbr,
	Null MasterBookingNbr,
	TaxGroup  TaxGroup,
	Obs_HIo Notes,
	Null 
	 Num_PRoc_MAster,


	(
		CASE  
				When DC_HIO='D' and RFI.num_registro is null then AXPT.CC_Custo
				When DC_HIO='C' and RFI.num_registro is null then AXPT.CC_Receita
				When DC_HIO='D' and RFI.num_registro is Not null then AX.CC_Custo
				When DC_HIO='C' and RFI.num_registro is Not null then AX.CC_Receita
		End	
	) Account_Number,
	
	1 Invoicing,
	(
		Case 
			When cd_servico is not null then cd_servico
			else Null
		End
	) citCityHallServiceCode,
	
	
	Null citCityHallServiceDesc,
	(
		Case 
			When cd_servico is not null then Dt_Ins
			else Null
		End
	) CitTransDateNF,
	
	Null [07Invoice],
	
	(
		Case 
			When cd_servico is not null then Doc_Number
			else Null
		End
	) DocumentNum,
	
	
	
	I.cd_tp_Tx Codigo_TX_ATL
	
	
	
 From cta_Cte_hou_Imp_Out I
 --Join Fatura F on F.FatCod = I.FatCod 
		Join House_imp_out Hou on hou.num_proc_hio=I.num_proc_hio
		Join LLP_Imp_out Job on Job.Num_Proc_lio=Hou.Num_Proc_HIo
		Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
		Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_hio
		Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
		Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_AX 
		Left Join Tipo_TAxa_AX AXPT on AX.CD_Charge_AX_PT=AXPT.cd_Charge_AX
		LEft Join registro_financeiro_item RFI on I.num_proc_hio=rfi.num_proc and I.dc_hio=rfi.dc and I.cd_Tp_tx=RFI.cd_tp_tx
		Left Join Registro_Financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
		Join Pessoa PP on PP.cd_pes=cd_Cred_dev_hio 
		Left Join Pessoa_ATL_AX AXPP on (cd_tp_ativ <> 'AGT' and AXPP.Cd_Pes = PP.Cd_Pes  or cd_tp_Ativ='AGT' and left(AXPP.cd_pes,len(axPP.cd_pes)-1)=PP.cd_pes) and Tipo='F'
		Join dbo.AX_XML_Vendor_Recebido AV on accountnum=axpp.cd_ax
 Where
	I.num_proc_hio = @num_proc and I.dc_hio='D' and cd_Cred_Dev_hio=@cd_pes
	and desp_org_hio='N'
	and convert(datetime,dt_ins_hio,105)=@DtIns	


Union all

Select 
	0,
	I.num_proc_heo Num_Proc,
	AXPT.cd_charge_AX Cd_Tp_TX,
	I.dc_heo DC,
	Vlr_Org_heo Valor,
	I.Cd_Tp_Moeda Moeda,
	HAWB_Heo Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	
	Case
		When upper(I.cd_tp_moeda)='REL' then 1.0000
		else  ISNULL(PAR.Par_Moeda,1) 
	End	 Paridade,
	'Ledger' AccountType,
	Null MasterBOLNbr,
	Null MasterBookingNbr,
	TaxGroup  TaxGroup,
	Obs_Heo Notes,
	Null 
	 Num_PRoc_MAster,


	(
		CASE  
				When DC_HeO='D' and RFI.num_registro is null then AXPT.CC_Custo
				When DC_HeO='C' and RFI.num_registro is null then AXPT.CC_Receita
				When DC_HeO='D' and RFI.num_registro is Not null then AX.CC_Custo
				When DC_HeO='C' and RFI.num_registro is Not null then AX.CC_Receita
		End	
	) Account_Number,
	
	1 Invoicing,
	(
		Case 
			When cd_servico is not null then cd_servico
			else Null
		End
	) citCityHallServiceCode,
	
	
	Null citCityHallServiceDesc,
	(
		Case 
			When cd_servico is not null then Dt_Ins
			else Null
		End
	) CitTransDateNF,
	
	Null [07Invoice],
	
	(
		Case 
			When cd_servico is not null then Doc_Number
			else Null
		End
	) DocumentNum,
	
	
	
	I.cd_tp_Tx Codigo_TX_ATL
	
	
	
 From cta_Cte_hou_Exp_Out I
 --Join Fatura F on F.FatCod = I.FatCod 
		Join House_exp_out Hou on hou.num_proc_heo=I.num_proc_heo
		Join LLP_exp_out Job on Job.Num_Proc_leo=Hou.Num_Proc_Heo
		Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
		Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_heo
		Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
		Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_AX 
		Left Join Tipo_TAxa_AX AXPT on AX.CD_Charge_AX_PT=AXPT.cd_Charge_AX
		LEft Join registro_financeiro_item RFI on I.num_proc_heo=rfi.num_proc and I.dc_heo=rfi.dc and I.cd_Tp_tx=RFI.cd_tp_tx
		Left Join Registro_Financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
		Join Pessoa PP on PP.cd_pes=cd_Cred_dev_heo 
		Left Join Pessoa_ATL_AX AXPP on (cd_tp_ativ <> 'AGT' and AXPP.Cd_Pes = PP.Cd_Pes  or cd_tp_Ativ='AGT' and left(AXPP.cd_pes,len(axPP.cd_pes)-1)=PP.cd_pes) and Tipo='F'
		Join dbo.AX_XML_Vendor_Recebido AV on accountnum=axpp.cd_ax
 Where
	I.num_proc_heo = @num_proc and I.dc_heo='D' and cd_Cred_Dev_heo=@cd_pes
	and desp_org_heo='N'
	and convert(datetime,dt_ins_heo,105)=@DtIns	

*/
GO
