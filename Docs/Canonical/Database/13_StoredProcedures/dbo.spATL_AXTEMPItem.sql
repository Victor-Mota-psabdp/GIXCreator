SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_AXTEMPItem] --[spATL_AXTEMPItem]  ''
	@Fatura	Varchar(17)
as
Select 
	
	0,
	Num_Proc,
	
	Isnull(AXPT.cd_charge_AX,900) Cd_Tp_TX,
	dc,
	Vlr_Org Valor,
	I.Cd_Tp_Moeda Moeda,
	HAWB_HIM Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,	
	ISNULL(Par_Moeda,1) Paridade,
	'Ledger' AccountType,
	hou.MAWB_HIM MasterBOLNbr,
	Null MasterBookingNbr,
	'Exempt' TaxGroup,
	Obs_HIM Notes,
	(
		Case Num_Proc_MIM
			when  'JOB' then ''
			else num_proc_mim
		end
	)
	 Num_PRoc_MAster,
	


	
	(
		CASE DC 
				When 'D' then AXPT.CC_Custo
				When 'C' then AXPT.CC_Receita
		End	
	) Account_Number,
	1 Invoicing
	
	
	
 From Item_Fat I
 Join Fatura F on F.FatCod = I.FatCod 
 Join House_imp_mar Hou on hou.num_proc_him=I.num_proc
 Join Job_Imp_Mar Job on Job.Num_Proc_HIM=Hou.Num_Proc_HIM 
 Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
 Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = CONVERT(varchar(10),FatDtEmissao,103)
 Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
 Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_AX 
 Left Join Tipo_TAxa_AX AXPT on AX.CD_Charge_AX_PT=AXPT.cd_Charge_AX
 --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
 Where
	f.FAtCod = @Fatura


Union all


Select 
	
	0,
	Num_Proc,
	
	Isnull(AXPT.cd_charge_AX,900) Cd_Tp_TX,
	dc,
	Vlr_Org Valor,
	I.Cd_Tp_Moeda Moeda,
	HAWB_HIA Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	
		ISNULL(Par_Moeda,1) Paridade,
	'Ledger' AccountType,
	hou.MAWB_HIA MasterBOLNbr,
	Null MasterBookingNbr,
	'Exempt' TaxGroup,
	Obs_HIA Notes,
	(
		Case Num_Proc_MIA
			when  'JOB' then ''
			else num_proc_mia
		end
	)
	 Num_PRoc_MAster,
	


	
	(
		CASE DC 
				When 'D' then AXPT.CC_Custo
				When 'C' then AXPT.CC_Receita
		End	
	) Account_Number,
	1 Invoicing
	
	
	
 From Item_Fat I
 Join Fatura F on F.FatCod = I.FatCod 
 Join House_imp_aer Hou on hou.num_proc_hia=I.num_proc
 Join Job_Imp_aer Job on Job.Num_Proc_HIA=Hou.Num_Proc_HIA
 Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
 Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = CONVERT(varchar(10),FatDtEmissao,103)
 Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
 Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_AX 
 Left Join Tipo_TAxa_AX AXPT on AX.CD_Charge_AX_PT=AXPT.cd_Charge_AX
  --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
 Where
	f.FAtCod = @Fatura


Union All

Select 
	
	0,
	Num_Proc,
	
	isnull(AXPT.cd_charge_AX,900) Cd_Tp_TX,
	dc,
	Vlr_Org Valor,
	I.Cd_Tp_Moeda Moeda,
	HAWB_HEA Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	
		ISNULL(Par_Moeda,1) Paridade,
	'Ledger' AccountType,
	hou.MAWB_HEA MasterBOLNbr,
	Null MasterBookingNbr,
	'Exempt' TaxGroup,
	Obs_HEA Notes,
	(
		Case Num_Proc_MEA
			when  'JOB' then ''
			else num_proc_MEA
		end
	)
	 Num_PRoc_MAster,
	


	
	(
		CASE DC 
				When 'D' then AXPT.CC_Custo
				When 'C' then AXPT.CC_Receita
		End	
	) Account_Number,
	1 Invoicing
	
	
	
 From Item_Fat I
 Join Fatura F on F.FatCod = I.FatCod 
 Join House_EXp_aer Hou on hou.num_proc_HEA=I.num_proc
 Join Job_EXp_aer Job on Job.Num_Proc_HEA=Hou.Num_Proc_HEA
 Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
 Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = CONVERT(varchar(10),FatDtEmissao,103)
 Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
 Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_AX 
 Left Join Tipo_TAxa_AX AXPT on AX.CD_Charge_AX_PT=AXPT.cd_Charge_AX
  --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
 Where
	f.FAtCod = @Fatura

Union all

Select 
	
	0,
	Num_Proc,
	
	AXPT.cd_charge_AX Cd_Tp_TX,
	dc,
	Vlr_Org Valor,
	I.Cd_Tp_Moeda Moeda,
	HAWB_hem Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	
		ISNULL(Par_Moeda,1) Paridade,
	'Ledger' AccountType,
	hou.MAWB_hem MasterBOLNbr,
	Null MasterBookingNbr,
	'Exempt' TaxGroup,
	Obs_hem Notes,
	(
		Case Num_Proc_MEM
			when  'JOB' then ''
			else num_proc_MEM
		end
	)
	 Num_PRoc_MAster,
	


	
	(
		CASE DC 
				When 'D' then AXPT.CC_Custo
				When 'C' then AXPT.CC_Receita
		End	
	) Account_Number,
	1 Invoicing
	
	
	
 From Item_Fat I
 Join Fatura F on F.FatCod = I.FatCod 
 Join House_EXp_mar Hou on hou.num_proc_hem=I.num_proc
 Join Job_EXp_mar Job on Job.Num_Proc_hem=Hou.Num_Proc_hem
 Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
 Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = CONVERT(varchar(10),FatDtEmissao,103)
 Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
 Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_AX 
 Left Join Tipo_TAxa_AX AXPT on AX.CD_Charge_AX_PT=AXPT.cd_Charge_AX
 
 --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
 Where
	f.FAtCod = @Fatura


Union all

Select 
	
	0,
	Num_Proc,
	
	Isnull(AXPT.cd_charge_AX ,900) Cd_Tp_TX,
	dc,
	Vlr_Org Valor,
	I.Cd_Tp_Moeda Moeda,
	HAWB_heo Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	
		ISNULL(Par_Moeda,1) Paridade,
	'Ledger' AccountType,
	Null MasterBOLNbr,
	Null MasterBookingNbr,
	'Exempt' TaxGroup,
	Obs_heo Notes,
	''
	 Num_PRoc_MAster,
	


	
	(
		CASE DC 
				When 'D' then AXPT.CC_Custo
				When 'C' then AXPT.CC_Receita
		End	
	) Account_Number,
	1 Invoicing
	
	
	
 From Item_Fat I
 Join Fatura F on F.FatCod = I.FatCod 
 Join House_EXp_out Hou on hou.num_proc_heo=I.num_proc
 Join LLP_EXP_Out Job on Job.Num_Proc_leo=Hou.Num_Proc_heo
 Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
 Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = CONVERT(varchar(10),FatDtEmissao,103)
 Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
 Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_AX 
 Left Join Tipo_TAxa_AX AXPT on AX.CD_Charge_AX_PT=AXPT.cd_Charge_AX
 --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
 Where
	f.FAtCod = @Fatura


Union all

Select 
	
	0,
	Num_Proc,
	
	AxPT.cd_charge_AX Cd_Tp_TX,
	dc,
	Vlr_Org Valor,
	I.Cd_Tp_Moeda Moeda,
	HAWB_hio Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	
		ISNULL(Par_Moeda,1) Paridade,
	'Ledger' AccountType,
	Null MasterBOLNbr,
	Null MasterBookingNbr,
	'Exempt' TaxGroup,
	Obs_hio Notes,
	''
	 Num_PRoc_MAster,
	


	
	(
		CASE DC 
				When 'D' then AXPT.CC_Custo
				When 'C' then AXPT.CC_Receita
		End	
	) Account_Number,
	1 Invoicing
	
	
	
 From Item_Fat I
 Join Fatura F on F.FatCod = I.FatCod 
 Join House_imp_out Hou on hou.num_proc_hio=I.num_proc
 Join LLP_imp_Out Job on Job.Num_Proc_lio=Hou.Num_Proc_hio
 Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
 Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = CONVERT(varchar(10),FatDtEmissao,103)
 Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_AX 
 Left Join Tipo_TAxa_AX AXPT on AX.CD_Charge_AX_PT=AXPT.cd_Charge_AX
 --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
 Where
	f.FAtCod = @Fatura

GO
