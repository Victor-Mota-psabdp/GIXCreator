SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_AXTEMPFATNFItem] --[spATL_AXTEMPFATNFItem]  'IMSTH201305001BRB'
	@Fatura	Varchar(17)
as
Select 
	
	0,
	Num_Proc,
	Case
		When Nota_Fiscal is null then AXPT.Cd_Charge_AX 
		When Nota_Fiscal is not null then  TT.cd_Ax 

	End 
	Cd_Tp_TX,
	dc,
	Case
		When Nota_Fiscal is not null then Vlr_Pgto_nf_hia
		When Nota_Fiscal is null then Vlr_Org

	End
	 Valor,
	Case
		When Nota_Fiscal is not null then 'REL'
		When Nota_Fiscal is null then I.cd_tp_Moeda 

	End

	Moeda,
	HAWB_HIM Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,	
	Case
		When Nota_Fiscal is not null then 1
		When Nota_Fiscal is null then ISNULL(Par_Moeda,1) 

	End
	Paridade,
	'Ledger' AccountType,
	hou.MAWB_HIM MasterBOLNbr,
	
	Null MasterBookingNbr,
		Case
		When Nota_Fiscal is not null and NF.ref_acesso<>'B' then 'CUS SER 02'
		When Nota_Fiscal is not null and NF.ref_acesso='B' then 'CUS SER 03'

		When Nota_Fiscal is null then 'Exempt'

	End

	
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
				When DC='D' and Nota_Fiscal is null then AXPT.CC_Custo
				When DC='C' and Nota_Fiscal is null then AXPT.CC_Receita
				When DC='D' and Nota_Fiscal is Not null then AX.CC_Custo
				When DC='C' and Nota_Fiscal is Not null then AX.CC_Receita
		End	
	) Account_Number,
	1 Invoicing,
	(Case 
		When Nota_Fiscal is null then ''
		else 'Servicos de desembaraco aduaneiro, comissarios, despachantes e congeneres'
	 End
	) citCityHallServiceDesc,
	(Case 
		When Nota_Fiscal is null then ''
		else '6637'
	 End
	) citCityHallServiceCode,
	Emissao CitTransDateNF,
	(Case 
		When Nota_Fiscal is null then ''
		else substring(ref_cnpj,9,4)
	 End
	) [07Invoice],
	Nota_Fiscal DocumentNum,cd_ax,TT.cd_tp_Tx Codigo_TX_ATL
	
 From Item_Fat I
 Join Fatura F on F.FatCod = I.FatCod 
 Join House_imp_mar Hou on hou.num_proc_him=I.num_proc
 Join Job_Imp_Mar Job on Job.Num_Proc_HIM=Hou.Num_Proc_HIM 
 Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
 Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = CONVERT(varchar(10),FatDtEmissao,103)
 Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
 Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = TT.Cd_AX 
 Left Join Tipo_TAxa_AX AXPT on AX.CD_Charge_AX_PT=AXPT.cd_Charge_AX
 Left Join vwcta_cte cta on cta.num_proc_hia=I.num_proc and cta.dc_hia=I.dc and cta.cd_tp_tx=I.cd_tp_Tx
 Left Join Base_Nota_Fiscal NF on nota_fiscal=num_nf_hia and NF.ref_acesso=ref_acesso_nf_hia
 --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
 left join referencia RF on RF.ref_Acesso=NF.ref_Acesso
 Where
	f.FAtCod = @Fatura


Union all


Select 
	
	0,
	Num_Proc,
	Case
		When Nota_Fiscal is null then AXPT.Cd_Charge_AX 
		When Nota_Fiscal is not null then  TT.cd_Ax 

	End 
	Cd_Tp_TX,
	dc,
	Case
		When Nota_Fiscal is not null then Vlr_Pgto_nf_hia
		When Nota_Fiscal is null then Vlr_Org

	End
	 Valor,
	Case
		When Nota_Fiscal is not null then 'REL'
		When Nota_Fiscal is null then I.cd_tp_Moeda 

	End

	Moeda,
	HAWB_HIA Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,	
	Case
		When Nota_Fiscal is not null then 1
		When Nota_Fiscal is null then ISNULL(Par_Moeda,1) 

	End
	Paridade,
	'Ledger' AccountType,
	hou.MAWB_HIA MasterBOLNbr,
	
	Null MasterBookingNbr,
		Case
		When Nota_Fiscal is not null and NF.ref_acesso<>'B' then 'CUS SER 02'
		When Nota_Fiscal is not null and NF.ref_acesso='B' then 'CUS SER 03'

		When Nota_Fiscal is null then 'Exempt'

	End

	
	 TaxGroup,
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
				When DC='D' and Nota_Fiscal is null then AXPT.CC_Custo
				When DC='C' and Nota_Fiscal is null then AXPT.CC_Receita
				When DC='D' and Nota_Fiscal is Not null then AX.CC_Custo
				When DC='C' and Nota_Fiscal is Not null then AX.CC_Receita
		End	
	) Account_Number,
	1 Invoicing,
	(Case 
		When Nota_Fiscal is null then ''
		else 'Servicos de desembaraco aduaneiro, comissarios, despachantes e congeneres'
	 End
	) citCityHallServiceDesc,
	(Case 
		When Nota_Fiscal is null then ''
		else '6637'
	 End
	) citCityHallServiceCode,
	Emissao CitTransDateNF,
	(Case 
		When Nota_Fiscal is null then ''
		else substring(ref_cnpj,9,4)
	 End
	) [07Invoice],
	Nota_Fiscal DocumentNum,cd_ax,TT.cd_tp_Tx Codigo_TX_ATL
	
 From Item_Fat I
 Join Fatura F on F.FatCod = I.FatCod 
 Join House_imp_aer Hou on hou.num_proc_hia=I.num_proc
 Join Job_Imp_aer Job on Job.Num_Proc_HIa=Hou.Num_Proc_HIa 
 Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
 Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = CONVERT(varchar(10),FatDtEmissao,103)
 Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
 Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = TT.Cd_AX 
 Left Join Tipo_TAxa_AX AXPT on AX.CD_Charge_AX_PT=AXPT.cd_Charge_AX
 Left Join vwcta_cte cta on cta.num_proc_hia=I.num_proc and cta.dc_hia=I.dc and cta.cd_tp_tx=I.cd_tp_Tx
 Left Join Base_Nota_Fiscal NF on nota_fiscal=num_nf_hia and NF.ref_acesso=ref_acesso_nf_hia
 --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
 left join referencia RF on RF.ref_Acesso=NF.ref_Acesso
 Where
	f.FAtCod = @Fatura


Union all

Select 
	
	0,
	Num_Proc,
	Case
		When Nota_Fiscal is null then AXPT.Cd_Charge_AX 
		When Nota_Fiscal is not null then  TT.cd_Ax 

	End 
	Cd_Tp_TX,
	dc,
	Case
		When Nota_Fiscal is not null then Vlr_Pgto_nf_hia
		When Nota_Fiscal is null then Vlr_Org

	End
	 Valor,
	Case
		When Nota_Fiscal is not null then 'REL'
		When Nota_Fiscal is null then I.cd_tp_Moeda 

	End

	Moeda,
	HAWB_HEM Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,	
	Case
		When Nota_Fiscal is not null then 1
		When Nota_Fiscal is null then ISNULL(Par_Moeda,1) 

	End
	Paridade,
	'Ledger' AccountType,
	hou.MAWB_HEM MasterBOLNbr,
	
	Null MasterBookingNbr,
		Case
		When Nota_Fiscal is not null and NF.ref_acesso<>'B' then 'CUS SER 02'
		When Nota_Fiscal is not null and NF.ref_acesso='B' then 'CUS SER 03'

		When Nota_Fiscal is null then 'Exempt'

	End

	
	 TaxGroup,
	Obs_HEM Notes,
	(
		Case Num_Proc_MEM
			when  'JOB' then ''
			else num_proc_mEM
		end
	)
	 Num_PRoc_MAster,
	


	
	(
		CASE  
				When DC='D' and Nota_Fiscal is null then AXPT.CC_Custo
				When DC='C' and Nota_Fiscal is null then AXPT.CC_Receita
				When DC='D' and Nota_Fiscal is Not null then AX.CC_Custo
				When DC='C' and Nota_Fiscal is Not null then AX.CC_Receita
		End	
	) Account_Number,
	1 Invoicing,
	(Case 
		When Nota_Fiscal is null then ''
		else 'Servicos de desembaraco aduaneiro, comissarios, despachantes e congeneres'
	 End
	) citCityHallServiceDesc,
	(Case 
		When Nota_Fiscal is null then ''
		else '6637'
	 End
	) citCityHallServiceCode,
	Emissao CitTransDateNF,
	(Case 
		When Nota_Fiscal is null then ''
		else substring(ref_cnpj,9,4)
	 End
	) [07Invoice],
	Nota_Fiscal DocumentNum,cd_ax,TT.cd_tp_Tx Codigo_TX_ATL
	
 From Item_Fat I
 Join Fatura F on F.FatCod = I.FatCod 
 Join House_exp_mar Hou on hou.num_proc_hem=I.num_proc
 Join Job_exp_mar Job on Job.Num_Proc_Hem=Hou.Num_Proc_Hem 
 Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
 Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = CONVERT(varchar(10),FatDtEmissao,103)
 Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
 Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = TT.Cd_AX 
 Left Join Tipo_TAxa_AX AXPT on AX.CD_Charge_AX_PT=AXPT.cd_Charge_AX
 Left Join vwcta_cte cta on cta.num_proc_hia=I.num_proc and cta.dc_hia=I.dc and cta.cd_tp_tx=I.cd_tp_Tx
 Left Join Base_Nota_Fiscal NF on nota_fiscal=num_nf_hia and NF.ref_acesso=ref_acesso_nf_hia
 --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
 left join referencia RF on RF.ref_Acesso=NF.ref_Acesso
 Where
	f.FAtCod = @Fatura


Union all


Select 
	
	0,
	Num_Proc,
	Case
		When Nota_Fiscal is null then AXPT.Cd_Charge_AX 
		When Nota_Fiscal is not null then  TT.cd_Ax 

	End 
	Cd_Tp_TX,
	dc,
	Case
		When Nota_Fiscal is not null then Vlr_Pgto_nf_hia
		When Nota_Fiscal is null then Vlr_Org

	End
	 Valor,
	Case
		When Nota_Fiscal is not null then 'REL'
		When Nota_Fiscal is null then I.cd_tp_Moeda 

	End

	Moeda,
	HAWB_HEA Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,	
	Case
		When Nota_Fiscal is not null then 1
		When Nota_Fiscal is null then ISNULL(Par_Moeda,1) 

	End
	Paridade,
	'Ledger' AccountType,
	hou.MAWB_HEA MasterBOLNbr,
	
	Null MasterBookingNbr,
		Case
		When Nota_Fiscal is not null and NF.ref_acesso<>'B' then 'CUS SER 02'
		When Nota_Fiscal is not null and NF.ref_acesso='B' then 'CUS SER 03'

		When Nota_Fiscal is null then 'Exempt'

	End

	
	 TaxGroup,
	Obs_HEA Notes,
	(
		Case Num_Proc_MEA
			when  'JOB' then ''
			else num_proc_mEA
		end
	)
	 Num_PRoc_MAster,
	


	
	(
		CASE  
				When DC='D' and Nota_Fiscal is null then AXPT.CC_Custo
				When DC='C' and Nota_Fiscal is null then AXPT.CC_Receita
				When DC='D' and Nota_Fiscal is Not null then AX.CC_Custo
				When DC='C' and Nota_Fiscal is Not null then AX.CC_Receita
		End	
	) Account_Number,
	1 Invoicing,
	(Case 
		When Nota_Fiscal is null then ''
		else 'Servicos de desembaraco aduaneiro, comissarios, despachantes e congeneres'
	 End
	) citCityHallServiceDesc,
	(Case 
		When Nota_Fiscal is null then ''
		else '6637'
	 End
	) citCityHallServiceCode,
	Emissao CitTransDateNF,
	(Case 
		When Nota_Fiscal is null then ''
		else substring(ref_cnpj,9,4)
	 End
	) [07Invoice],
	Nota_Fiscal DocumentNum,cd_ax,TT.cd_tp_Tx Codigo_TX_ATL
	
 From Item_Fat I
 Join Fatura F on F.FatCod = I.FatCod 
 Join House_exp_aer Hou on hou.num_proc_hea=I.num_proc
 Join Job_exp_aer Job on Job.Num_Proc_Hea=Hou.Num_Proc_Hea 
 Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
 Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = CONVERT(varchar(10),FatDtEmissao,103)
 Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
 Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = TT.Cd_AX 
 Left Join Tipo_TAxa_AX AXPT on AX.CD_Charge_AX_PT=AXPT.cd_Charge_AX
 Left Join vwcta_cte cta on cta.num_proc_hia=I.num_proc and cta.dc_hia=I.dc and cta.cd_tp_tx=I.cd_tp_Tx
 Left Join Base_Nota_Fiscal NF on nota_fiscal=num_nf_hia and NF.ref_acesso=ref_acesso_nf_hia
 --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
 left join referencia RF on RF.ref_Acesso=NF.ref_Acesso
 Where
	f.FAtCod = @Fatura

Union all

Select 
	
	0,
	Num_Proc,
	Case
		When Nota_Fiscal is null then AXPT.Cd_Charge_AX 
		When Nota_Fiscal is not null then  TT.cd_Ax 

	End 
	Cd_Tp_TX,
	dc,
	Case
		When Nota_Fiscal is not null then Vlr_Pgto_nf_hia
		When Nota_Fiscal is null then Vlr_Org

	End
	 Valor,
	Case
		When Nota_Fiscal is not null then 'REL'
		When Nota_Fiscal is null then I.cd_tp_Moeda 

	End

	Moeda,
	HAWB_HEO Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,	
	Case
		When Nota_Fiscal is not null then 1
		When Nota_Fiscal is null then ISNULL(Par_Moeda,1) 

	End
	Paridade,
	'Ledger' AccountType,
	Null MasterBOLNbr,
	
	Null MasterBookingNbr,
		Case
		When Nota_Fiscal is not null and NF.ref_acesso<>'B' then 'CUS SER 02'
		When Nota_Fiscal is not null and NF.ref_acesso='B' then 'CUS SER 03'

		When Nota_Fiscal is null then 'Exempt'

	End

	
	 TaxGroup,
	Obs_HEO Notes,
	Null 
	 Num_PRoc_MAster,
	


	
	(
		CASE  
				When DC='D' and Nota_Fiscal is null then AXPT.CC_Custo
				When DC='C' and Nota_Fiscal is null then AXPT.CC_Receita
				When DC='D' and Nota_Fiscal is Not null then AX.CC_Custo
				When DC='C' and Nota_Fiscal is Not null then AX.CC_Receita
		End	
	) Account_Number,
	1 Invoicing,
	(Case 
		When Nota_Fiscal is null then ''
		else 'Servicos de desembaraco aduaneiro, comissarios, despachantes e congeneres'
	 End
	) citCityHallServiceDesc,
	(Case 
		When Nota_Fiscal is null then ''
		else '6637'
	 End
	) citCityHallServiceCode,
	Emissao CitTransDateNF,
	(Case 
		When Nota_Fiscal is null then ''
		else substring(ref_cnpj,9,4)
	 End
	) [07Invoice],
	Nota_Fiscal DocumentNum,cd_ax,TT.cd_tp_Tx Codigo_TX_ATL
	
 From Item_Fat I
 Join Fatura F on F.FatCod = I.FatCod 
 Join House_exp_out Hou on hou.num_proc_heo=I.num_proc
 Join LLP_exp_out Job on Job.Num_Proc_leo=Hou.Num_Proc_Heo 
 Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
 Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = CONVERT(varchar(10),FatDtEmissao,103)
 Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
 Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = TT.Cd_AX 
 Left Join Tipo_TAxa_AX AXPT on AX.CD_Charge_AX_PT=AXPT.cd_Charge_AX
 Left Join vwcta_cte cta on cta.num_proc_hia=I.num_proc and cta.dc_hia=I.dc and cta.cd_tp_tx=I.cd_tp_Tx
 Left Join Base_Nota_Fiscal NF on nota_fiscal=num_nf_hia and NF.ref_acesso=ref_acesso_nf_hia
 --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
 left join referencia RF on RF.ref_Acesso=NF.ref_Acesso
 Where
	f.FAtCod = @Fatura


Union all


Select 
	
	0,
	Num_Proc,
	Case
		When Nota_Fiscal is null then AXPT.Cd_Charge_AX 
		When Nota_Fiscal is not null then  TT.cd_Ax 

	End 
	Cd_Tp_TX,
	dc,
	Case
		When Nota_Fiscal is not null then Vlr_Pgto_nf_hia
		When Nota_Fiscal is null then Vlr_Org

	End
	 Valor,
	Case
		When Nota_Fiscal is not null then 'REL'
		When Nota_Fiscal is null then I.cd_tp_Moeda 

	End

	Moeda,
	HAWB_Hio Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,	
	Case
		When Nota_Fiscal is not null then 1
		When Nota_Fiscal is null then ISNULL(Par_Moeda,1) 

	End
	Paridade,
	'Ledger' AccountType,
	Null MasterBOLNbr,
	
	Null MasterBookingNbr,
		Case
		When Nota_Fiscal is not null and NF.ref_acesso<>'B' then 'CUS SER 02'
		When Nota_Fiscal is not null and NF.ref_acesso='B' then 'CUS SER 03'

		When Nota_Fiscal is null then 'Exempt'

	End

	
	 TaxGroup,
	Obs_HiO Notes,
	Null 
	 Num_PRoc_MAster,
	


	
	(
		CASE  
				When DC='D' and Nota_Fiscal is null then AXPT.CC_Custo
				When DC='C' and Nota_Fiscal is null then AXPT.CC_Receita
				When DC='D' and Nota_Fiscal is Not null then AX.CC_Custo
				When DC='C' and Nota_Fiscal is Not null then AX.CC_Receita
		End	
	) Account_Number,
	1 Invoicing,
	(Case 
		When Nota_Fiscal is null then ''
		else 'Servicos de desembaraco aduaneiro, comissarios, despachantes e congeneres'
	 End
	) citCityHallServiceDesc,
	(Case 
		When Nota_Fiscal is null then ''
		else '6637'
	 End
	) citCityHallServiceCode,
	Emissao CitTransDateNF,
	(Case 
		When Nota_Fiscal is null then ''
		else substring(ref_cnpj,9,4)
	 End
	) [07Invoice],
	Nota_Fiscal DocumentNum,cd_ax,TT.cd_tp_Tx Codigo_TX_ATL
	
 From Item_Fat I
 Join Fatura F on F.FatCod = I.FatCod 
 Join House_imp_out Hou on hou.num_proc_hio=I.num_proc
 Join LLP_imp_out Job on Job.Num_Proc_lio=Hou.Num_Proc_Hio 
 Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
 Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = CONVERT(varchar(10),FatDtEmissao,103)
 Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
 Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = TT.Cd_AX 
 Left Join Tipo_TAxa_AX AXPT on AX.CD_Charge_AX_PT=AXPT.cd_Charge_AX
 Left Join vwcta_cte cta on cta.num_proc_hia=I.num_proc and cta.dc_hia=I.dc and cta.cd_tp_tx=I.cd_tp_Tx
 Left Join Base_Nota_Fiscal NF on nota_fiscal=num_nf_hia and NF.ref_acesso=ref_acesso_nf_hia
 --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
 left join referencia RF on RF.ref_Acesso=NF.ref_Acesso
 Where
	f.FAtCod = @Fatura

GO
