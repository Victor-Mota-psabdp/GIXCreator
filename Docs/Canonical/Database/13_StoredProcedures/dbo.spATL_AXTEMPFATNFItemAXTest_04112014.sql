SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[spATL_AXTEMPFATNFItemAXTest_04112014]  'EOFMC201408008BRA'
--[spATL_AXTEMPFATNFItemAXTest]  'EOFMC201408008BRA'
--Pra reenviar na data, tem q ver se precisa altera a data do CitTransDateNF,
CREATE Procedure [dbo].[spATL_AXTEMPFATNFItemAXTest_04112014] --'EMMTE201310012BRA'
	@Fatura	Varchar(17)
as
Select 
	
	0,
	I.Num_Proc,
	Case
		When NF.Nota_Fiscal is null then AXPT.Cd_Charge_AX 
		When NF.Nota_Fiscal is not null then  AX.cd_charge_ax

	End 
	Cd_Tp_TX,
	I.dc,
		Vlr_Org	 Valor,
	I.cd_tp_Moeda Moeda,
	HAWB_Him Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,	
	Case
		When Upper(I.cd_tp_moeda)='REL' then 1.000
		When I.Paridade is not null and isnull(I.Paridade,0) <> 1 and I.Cd_Tp_Moeda <>'REL' and Par_NF_HIA is null then I.Paridade
		else Isnull(Par_NF_HIA,par_moeda)	
	End	Paridade,

	
	'Ledger' AccountType,
	Null MasterBOLNbr,
	
	Null MasterBookingNbr,
	Case
		When BNFAT.Tax_Group is not null then BNFAT.Tax_Group
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 12'
		else 'Exempt'
	End	 TaxGroup,		

	

	Obs_Him Notes,
	Null 
	 Num_PRoc_MAster,
	
	(
		CASE  
				When I.DC='D' and NF.Nota_Fiscal is null then AXPT.CC_Custo
				When I.DC='C' and NF.Nota_Fiscal is null then AXPT.CC_Receita
				When I.DC='D' and NF.Nota_Fiscal is Not null then AX.CC_Custo
				When I.DC='C' and NF.Nota_Fiscal is Not null then AX.CC_Receita
		End	
	) Account_Number,
	1 Invoicing,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else 'Servicos de desembaraco aduaneiro, comissarios, despachantes e congeneres'
	 End
	) citCityHallServiceDesc,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else '6637'
	 End
	) citCityHallServiceCode,
			(Case
		When NF.RPS_NFE is NULL Then NF.Emissao
		else NF.RPS_DATA
	End) CitTransDateNF,
	--getdate() CitTransDateNF,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else substring(ref_cnpj,9,4)
	 End
	) [07Invoice],
		(Case
		When NF.RPS_NFE is NULL Then NF.Nota_Fiscal 
		else NF.RPS_NFE
	End) DocumentNum,cd_ax,TT.cd_tp_Tx Codigo_TX_ATL
	
 From Item_Fat I
	Join Fatura F on F.FatCod = I.FatCod 
	Join House_imp_mar Hou on hou.num_proc_him=I.num_proc
	Join Job_Imp_Mar Job on Job.Num_Proc_HIM=Hou.Num_Proc_HIM 
	Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
	Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = CONVERT(varchar(10),FatDtEmissao,103)
	Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx and Cd_Ax_Resultado  <> '000.1'
	Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_Ax_Resultado
	Left Join Tipo_TAxa_AX AXPT on AXPT.cd_Charge_AX=cd_Ax_Repasse
	Left Join vwcta_cte cta on cta.num_proc_hia=I.num_proc and cta.dc_hia=I.dc and cta.cd_tp_tx=I.cd_tp_Tx
	Left Join Base_Nota_Fiscal NF on nota_fiscal=num_nf_hia and NF.ref_acesso=ref_acesso_nf_hia and emissao <= FatDtEmissao
 --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
	left Join vwAXDocs AXI on I.num_proc=AXI.num_proc and I.dc=AXI.dc and I.cd_tp_Tx =AXI.cd_tp_tx_ATL
	left join referencia RF on RF.ref_Acesso=NF.ref_Acesso
	LEft Join dbo.Base_Nota_Fiscal_AX_TAX_GROUP BNFAT on BNFAT.Nota_Fiscal=NF.Nota_Fiscal and BNFAT.ref_acesso=NF.ref_acesso
	
 Where
	f.FAtCod = @Fatura and AXI.ID_AX is null

Union all

Select 
	
	0,
	I.Num_Proc,
	Case
		When NF.Nota_Fiscal is null then AXPT.Cd_Charge_AX 
		When NF.Nota_Fiscal is not null then  AX.cd_charge_ax

	End 
	Cd_Tp_TX,
	I.dc,
		Vlr_Org	 Valor,
	I.cd_tp_Moeda Moeda,
	HAWB_Hia Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,	
	Case
		When Upper(I.cd_tp_moeda)='REL' then 1.000
		When I.Paridade is not null and isnull(I.Paridade,0) <> 1 and I.Cd_Tp_Moeda <>'REL' and Par_NF_HIA is null then I.Paridade
		else Isnull(Par_NF_HIA,par_moeda)	
	End	Paridade,

	
	'Ledger' AccountType,
	Null MasterBOLNbr,
	
	Null MasterBookingNbr,
	Case
		When BNFAT.Tax_Group is not null then BNFAT.Tax_Group
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 12'
		else 'Exempt'
	End	 TaxGroup,		

	

	Obs_Hia Notes,
	Null 
	 Num_PRoc_MAster,
	
	(
		CASE  
				When I.DC='D' and NF.Nota_Fiscal is null then AXPT.CC_Custo
				When I.DC='C' and NF.Nota_Fiscal is null then AXPT.CC_Receita
				When I.DC='D' and NF.Nota_Fiscal is Not null then AX.CC_Custo
				When I.DC='C' and NF.Nota_Fiscal is Not null then AX.CC_Receita
		End	
	) Account_Number,
	1 Invoicing,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else 'Servicos de desembaraco aduaneiro, comissarios, despachantes e congeneres'
	 End
	) citCityHallServiceDesc,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else '6637'
	 End
	) citCityHallServiceCode,
			(Case
		When NF.RPS_NFE is NULL Then NF.Emissao
		else NF.RPS_DATA
	End) CitTransDateNF,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else substring(ref_cnpj,9,4)
	 End
	) [07Invoice],
		(Case
		When NF.RPS_NFE is NULL Then NF.Nota_Fiscal 
		else NF.RPS_NFE
	End) DocumentNum,cd_ax,TT.cd_tp_Tx Codigo_TX_ATL
	
 From Item_Fat I
 Join Fatura F on F.FatCod = I.FatCod 
 Join House_imp_aer Hou on hou.num_proc_hia=I.num_proc
 Join Job_Imp_aer Job on Job.Num_Proc_HIa=Hou.Num_Proc_HIa 
 Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
 Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = CONVERT(varchar(10),FatDtEmissao,103)
 Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx and ISNULL(Cd_Ax_Resultado,'') <> '000.1'
 
Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_Ax_Resultado
Left Join Tipo_TAxa_AX AXPT on AXPT.cd_Charge_AX=cd_Ax_Repasse

 Left Join vwcta_cte cta on cta.num_proc_hia=I.num_proc and cta.dc_hia=I.dc and cta.cd_tp_tx=I.cd_tp_Tx
 Left Join Base_Nota_Fiscal NF on nota_fiscal=num_nf_hia and NF.ref_acesso=ref_acesso_nf_hia
 --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
  left Join vwAXDocs AXI on I.num_proc=AXI.num_proc and I.dc=AXI.dc and I.cd_tp_Tx =AXI.cd_tp_tx_ATL
 left join referencia RF on RF.ref_Acesso=NF.ref_Acesso
	LEft Join dbo.Base_Nota_Fiscal_AX_TAX_GROUP BNFAT on BNFAT.Nota_Fiscal=NF.Nota_Fiscal and BNFAT.ref_acesso=NF.ref_acesso

 Where
	f.FAtCod = @Fatura and AXI.ID_AX is null


Union all

Select 
	
	0,
	I.Num_Proc,
	Case
		When NF.Nota_Fiscal is null then AXPT.Cd_Charge_AX 
		When NF.Nota_Fiscal is not null then  AX.cd_charge_ax

	End 
	Cd_Tp_TX,
	I.dc,
		Vlr_Org	 Valor,
	I.cd_tp_Moeda Moeda,
	HAWB_Hem Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,	
	Case
		When Upper(I.cd_tp_moeda)='REL' then 1.000
		When I.Paridade is not null and isnull(I.Paridade,0) <> 1 and I.Cd_Tp_Moeda <>'REL' and Par_NF_HIA is null then I.Paridade
		else Isnull(Par_NF_HIA,par_moeda)	
	End	Paridade,

	
	'Ledger' AccountType,
	Null MasterBOLNbr,
	
	Null MasterBookingNbr,
	Case
		When BNFAT.Tax_Group is not null then BNFAT.Tax_Group
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 12'
		else 'Exempt'
	End	 TaxGroup,		

	

	Obs_Hem Notes,
	Null 
	 Num_PRoc_MAster,
	
	(
		CASE  
				When I.DC='D' and NF.Nota_Fiscal is null then AXPT.CC_Custo
				When I.DC='C' and NF.Nota_Fiscal is null then AXPT.CC_Receita
				When I.DC='D' and NF.Nota_Fiscal is Not null then AX.CC_Custo
				When I.DC='C' and NF.Nota_Fiscal is Not null then AX.CC_Receita
		End	
	) Account_Number,
	1 Invoicing,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else 'Servicos de desembaraco aduaneiro, comissarios, despachantes e congeneres'
	 End
	) citCityHallServiceDesc,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else '6637'
	 End
	) citCityHallServiceCode,
			(Case
		When NF.RPS_NFE is NULL Then NF.Emissao
		else NF.RPS_DATA
	End) CitTransDateNF,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else substring(ref_cnpj,9,4)
	 End
	) [07Invoice],
		(Case
		When NF.RPS_NFE is NULL Then NF.Nota_Fiscal 
		else NF.RPS_NFE
	End) DocumentNum,cd_ax,TT.cd_tp_Tx Codigo_TX_ATL
	
 From Item_Fat I
	Join Fatura F on F.FatCod = I.FatCod 
	Join House_exp_mar Hou on hou.num_proc_hem=I.num_proc
	Join Job_exp_mar Job on Job.Num_Proc_Hem=Hou.Num_Proc_Hem 
	Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
	Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = CONVERT(varchar(10),FatDtEmissao,103)
	Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx and isnull(TT.Cd_Ax_Resultado,'') <> '000.1'
	---Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_Ax_Resultado
	--Left Join Tipo_TAxa_AX AXPT on AXPT.cd_Charge_AX=cd_Ax_Repasse
	LEft Join Tipo_Taxa_AX AX on AX.cd_charge_ax=cd_ax_resultado
	LEft Join Tipo_Taxa_AX AXPT on AXPT.cd_charge_ax=cd_ax_repasse
	
	Left Join vwcta_cte cta on cta.num_proc_hia=I.num_proc and cta.dc_hia=I.dc and cta.cd_tp_tx=I.cd_tp_Tx
	Left Join Base_NotA_Fiscal NF on nota_fiscal=num_nf_hia and NF.ref_acesso=ref_acesso_nf_hia
 --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
  left Join vwAXDocs AXI on I.num_proc=AXI.num_proc and I.dc=AXI.dc and I.cd_tp_Tx =AXI.cd_tp_tx_ATL
	left join referencia RF on RF.ref_Acesso=NF.ref_Acesso
 	LEft Join dbo.Base_Nota_Fiscal_AX_TAX_GROUP BNFAT on BNFAT.Nota_Fiscal=NF.Nota_Fiscal and BNFAT.ref_acesso=NF.ref_acesso
 	

 Where
	f.FAtCod = @Fatura and AXI.ID_AX is null


Union all


Select 
	
	0,
	I.Num_Proc,
	Case
		When NF.Nota_Fiscal is null then AXPT.Cd_Charge_AX 
		When NF.Nota_Fiscal is not null then  AX.cd_charge_ax

	End 
	Cd_Tp_TX,
	I.dc,
		Vlr_Org	 Valor,
	I.cd_tp_Moeda Moeda,
	HAWB_Hea Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,	
	Case
		When Upper(I.cd_tp_moeda)='REL' then 1.000
		When I.Paridade is not null and isnull(I.Paridade,0) <> 1 and I.Cd_Tp_Moeda <>'REL' and Par_NF_HIA is null then I.Paridade
		else Isnull(Par_NF_HIA,par_moeda)	
	End	Paridade,

	
	'Ledger' AccountType,
	Null MasterBOLNbr,
	
	Null MasterBookingNbr,
	Case
		When BNFAT.Tax_Group is not null then BNFAT.Tax_Group
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 12'
		else 'Exempt'
	End	 TaxGroup,		

	

	Obs_Hea Notes,
	Null 
	 Num_PRoc_MAster,
	
	(
		CASE  
				When I.DC='D' and NF.Nota_Fiscal is null then AXPT.CC_Custo
				When I.DC='C' and NF.Nota_Fiscal is null then AXPT.CC_Receita
				When I.DC='D' and NF.Nota_Fiscal is Not null then AX.CC_Custo
				When I.DC='C' and NF.Nota_Fiscal is Not null then AX.CC_Receita
		End	
	) Account_Number,
	1 Invoicing,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else 'Servicos de desembaraco aduaneiro, comissarios, despachantes e congeneres'
	 End
	) citCityHallServiceDesc,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else '6637'
	 End
	) citCityHallServiceCode,
			(Case
		When NF.RPS_NFE is NULL Then NF.Emissao
		else NF.RPS_DATA
	End) CitTransDateNF,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else substring(ref_cnpj,9,4)
	 End
	) [07Invoice],
		(Case
		When NF.RPS_NFE is NULL Then NF.Nota_Fiscal 
		else NF.RPS_NFE
	End) DocumentNum,cd_ax,TT.cd_tp_Tx Codigo_TX_ATL
 From Item_Fat I
 Join Fatura F on F.FatCod = I.FatCod 
 Join House_exp_aer Hou on hou.num_proc_hea=I.num_proc
 Join Job_exp_aer Job on Job.Num_Proc_Hea=Hou.Num_Proc_Hea 
 Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
 Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = CONVERT(varchar(10),FatDtEmissao,103)
	Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx and ISNULL(Cd_Ax_Resultado,'') <> '000.1'
		Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_Ax_Resultado
		Left Join Tipo_TAxa_AX AXPT on AXPT.cd_Charge_AX=cd_Ax_Repasse
 Left Join vwcta_cte cta on cta.num_proc_hia=I.num_proc and cta.dc_hia=I.dc and cta.cd_tp_tx=I.cd_tp_Tx
 Left Join Base_Nota_Fiscal NF on nota_fiscal=num_nf_hia and NF.ref_acesso=ref_acesso_nf_hia
 --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
  left Join vwAXDocs AXI on I.num_proc=AXI.num_proc and I.dc=AXI.dc and I.cd_tp_Tx =AXI.cd_tp_tx_ATL
 left join referencia RF on RF.ref_Acesso=NF.ref_Acesso
 	LEft Join dbo.Base_Nota_Fiscal_AX_TAX_GROUP BNFAT on BNFAT.Nota_Fiscal=NF.Nota_Fiscal and BNFAT.ref_acesso=NF.ref_acesso
 Where
	f.FAtCod = @Fatura and AXI.ID_AX is null

Union all

Select 
	
	0,
	I.Num_Proc,
	Case
		When NF.Nota_Fiscal is null then AXPT.Cd_Charge_AX 
		When NF.Nota_Fiscal is not null then  AX.cd_charge_ax

	End 
	Cd_Tp_TX,
	I.dc,
		Vlr_Org	 Valor,
	I.cd_tp_Moeda Moeda,
	HAWB_Heo Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,	
	Case
		When Upper(I.cd_tp_moeda)='REL' then 1.000
		When I.Paridade is not null and isnull(I.Paridade,0) <> 1 and I.Cd_Tp_Moeda <>'REL' and Par_NF_HIA is null then I.Paridade
		else Isnull(Par_NF_HIA,par_moeda)	
	End	Paridade,

	
	'Ledger' AccountType,
	Null MasterBOLNbr,
	
	Null MasterBookingNbr,
	Case
		When BNFAT.Tax_Group is not null then BNFAT.Tax_Group
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 12'
		else 'Exempt'
	End	 TaxGroup,		

	

	Obs_HeO Notes,
	Null 
	 Num_PRoc_MAster,
	
	(
		CASE  
				When I.DC='D' and NF.Nota_Fiscal is null then AXPT.CC_Custo
				When I.DC='C' and NF.Nota_Fiscal is null then AXPT.CC_Receita
				When I.DC='D' and NF.Nota_Fiscal is Not null then AX.CC_Custo
				When I.DC='C' and NF.Nota_Fiscal is Not null then AX.CC_Receita
		End	
	) Account_Number,
	1 Invoicing,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else 'Servicos de desembaraco aduaneiro, comissarios, despachantes e congeneres'
	 End
	) citCityHallServiceDesc,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else '6637'
	 End
	) citCityHallServiceCode,
			(Case
		When NF.RPS_NFE is NULL Then NF.Emissao
		else NF.RPS_DATA
	End) CitTransDateNF,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else substring(ref_cnpj,9,4)
	 End
	) [07Invoice],
		(Case
		When NF.RPS_NFE is NULL Then NF.Nota_Fiscal 
		else NF.RPS_NFE
	End) DocumentNum,cd_ax,TT.cd_tp_Tx Codigo_TX_ATL
 From Item_Fat I
 Join Fatura F on F.FatCod = I.FatCod 
 Join House_exp_out Hou on hou.num_proc_heo=I.num_proc
 Join LLP_exp_out Job on Job.Num_Proc_leo=Hou.Num_Proc_Heo 
 Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
 Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = CONVERT(varchar(10),FatDtEmissao,103)
 Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx and ISNULL(Cd_Ax_Resultado,'') <> '000.1'
		Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_Ax_Resultado
		Left Join Tipo_TAxa_AX AXPT on AXPT.cd_Charge_AX=cd_Ax_Repasse
 Left Join vwcta_cte cta on cta.num_proc_hia=I.num_proc and cta.dc_hia=I.dc and cta.cd_tp_tx=I.cd_tp_Tx
 Left Join Base_Nota_Fiscal NF on nota_fiscal=num_nf_hia and NF.ref_acesso=ref_acesso_nf_hia
-- Join AX_Doc AXD on AXD.Invoice_Number = F.FAtcod
 left Join vwAXDocs AXI on I.num_proc=AXI.num_proc and I.dc=AXI.dc and I.cd_tp_Tx =AXI.cd_tp_tx_ATL
 left join referencia RF on RF.ref_Acesso=NF.ref_Acesso
 	LEft Join dbo.Base_Nota_Fiscal_AX_TAX_GROUP BNFAT on BNFAT.Nota_Fiscal=NF.Nota_Fiscal and BNFAT.ref_acesso=NF.ref_acesso
 Where
	f.FAtCod = @Fatura and AXI.ID_AX is null


Union all


Select 
	
	0,
	I.Num_Proc,
	Case
		When NF.Nota_Fiscal is null then AXPT.Cd_Charge_AX 
		When NF.Nota_Fiscal is not null then  AX.cd_charge_ax

	End 
	Cd_Tp_TX,
	I.dc,
		Vlr_Org	 Valor,
	I.cd_tp_Moeda Moeda,
	HAWB_Hio Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,	
	Case
		When Upper(I.cd_tp_moeda)='REL' then 1.000
		When I.Paridade is not null and isnull(I.Paridade,0) <> 1 and I.Cd_Tp_Moeda <>'REL' and Par_NF_HIA is null then I.Paridade
		else Isnull(Par_NF_HIA,par_moeda)	
	End	Paridade,

	
	'Ledger' AccountType,
	Null MasterBOLNbr,
	
	Null MasterBookingNbr,
	Case
		When BNFAT.Tax_Group is not null then BNFAT.Tax_Group
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 12'
		else 'Exempt'
	End	 TaxGroup,		

	

	Obs_Hio Notes,
	Null 
	 Num_PRoc_MAster,
	
	(
		CASE  
				When I.DC='D' and NF.Nota_Fiscal is null then AXPT.CC_Custo
				When I.DC='C' and NF.Nota_Fiscal is null then AXPT.CC_Receita
				When I.DC='D' and NF.Nota_Fiscal is Not null then AX.CC_Custo
				When I.DC='C' and NF.Nota_Fiscal is Not null then AX.CC_Receita
		End	
	) Account_Number,
	1 Invoicing,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else 'Servicos de desembaraco aduaneiro, comissarios, despachantes e congeneres'
	 End
	) citCityHallServiceDesc,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else '6637'
	 End
	) citCityHallServiceCode,
			(Case
		When NF.RPS_NFE is NULL Then NF.Emissao
		else NF.RPS_DATA
	End) CitTransDateNF,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else substring(ref_cnpj,9,4)
	 End
	) [07Invoice],
		(Case
		When NF.RPS_NFE is NULL Then NF.Nota_Fiscal 
		else NF.RPS_NFE
	End) DocumentNum,cd_ax,TT.cd_tp_Tx Codigo_TX_ATL
 From Item_Fat I
 Join Fatura F on F.FatCod = I.FatCod 
 Join House_imp_out Hou on hou.num_proc_hio=I.num_proc
 Join LLP_imp_out Job on Job.Num_Proc_lio=Hou.Num_Proc_Hio 
 Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
 Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = CONVERT(varchar(10),FatDtEmissao,103)
	Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx and ISNULL(Cd_Ax_Resultado,'') <> '000.1'
		Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_Ax_Resultado
		Left Join Tipo_TAxa_AX AXPT on AXPT.cd_Charge_AX=cd_Ax_Repasse
 Left Join vwcta_cte cta on cta.num_proc_hia=I.num_proc and cta.dc_hia=I.dc and cta.cd_tp_tx=I.cd_tp_Tx
 Left Join Base_Nota_Fiscal NF on nota_fiscal=num_nf_hia and NF.ref_acesso=ref_acesso_nf_hia
 --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
  left Join vwAXDocs AXI on I.num_proc=AXI.num_proc and I.dc=AXI.dc and I.cd_tp_Tx =AXI.cd_tp_tx_ATL
 left join referencia RF on RF.ref_Acesso=NF.ref_Acesso
 	LEft Join dbo.Base_Nota_Fiscal_AX_TAX_GROUP BNFAT on BNFAT.Nota_Fiscal=NF.Nota_Fiscal and BNFAT.ref_acesso=NF.ref_acesso
 Where
	f.FAtCod = @Fatura and AXI.ID_AX is null


Union all

Select 
	
	0,
	I.Num_Proc,
	Case
		When NF.Nota_Fiscal is null then AXPT.Cd_Charge_AX 
		When NF.Nota_Fiscal is not null then  AX.cd_charge_ax

	End 
	Cd_Tp_TX,
	I.dc,
		Vlr_Org	 Valor,
	I.cd_tp_Moeda Moeda,
	HAWB_Hea Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,	
	Case
		When Upper(I.cd_tp_moeda)='REL' then 1.000
		When I.Paridade is not null and isnull(I.Paridade,0) <> 1 and I.Cd_Tp_Moeda <>'REL' and Par_NF_HIA is null then I.Paridade
		else Isnull(Par_NF_HIA,par_moeda)	
	End	Paridade,

	
	'Ledger' AccountType,
	Null MasterBOLNbr,
	
	Null MasterBookingNbr,
	Case
		When BNFAT.Tax_Group is not null then BNFAT.Tax_Group
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 12'
		else 'Exempt'
	End	 TaxGroup,		

	

	Obs_Hea Notes,
	Null 
	 Num_PRoc_MAster,
	
	(
		CASE  
				When I.DC='D' and NF.Nota_Fiscal is null then AXPT.CC_Custo
				When I.DC='C' and NF.Nota_Fiscal is null then AXPT.CC_Receita
				When I.DC='D' and NF.Nota_Fiscal is Not null then AX.CC_Custo
				When I.DC='C' and NF.Nota_Fiscal is Not null then AX.CC_Receita
		End	
	) Account_Number,
	1 Invoicing,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else 'Servicos de desembaraco aduaneiro, comissarios, despachantes e congeneres'
	 End
	) citCityHallServiceDesc,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else '6637'
	 End
	) citCityHallServiceCode,
			(Case
		When NF.RPS_NFE is NULL Then NF.Emissao
		else NF.RPS_DATA
	End) CitTransDateNF,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else substring(ref_cnpj,9,4)
	 End
	) [07Invoice],
		(Case
		When NF.RPS_NFE is NULL Then NF.Nota_Fiscal 
		else NF.RPS_NFE
	End) DocumentNum,cd_ax,TT.cd_tp_Tx Codigo_TX_ATL
	
 From Item_Fat I
 Join Fatura F on F.FatCod = I.FatCod 
 Join House_exp_aer Hou on hou.num_proc_mea=I.num_proc
 Join Job_exp_aer Job on Job.Num_Proc_Hea=Hou.Num_Proc_Hea 
 Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
 Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = CONVERT(varchar(10),FatDtEmissao,103)
	Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx and ISNULL(Cd_Ax_Resultado,'') <> '000.1'
		Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_Ax_Resultado
		Left Join Tipo_TAxa_AX AXPT on AXPT.cd_Charge_AX=cd_Ax_Repasse
 Left Join vwcta_cte cta on cta.num_proc_hia=I.num_proc and cta.dc_hia=I.dc and cta.cd_tp_tx=I.cd_tp_Tx
 Left Join Base_Nota_Fiscal NF on nota_fiscal=num_nf_hia and NF.ref_acesso=ref_acesso_nf_hia
 --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
  left Join vwAXDocs AXI on I.num_proc=AXI.num_proc and I.dc=AXI.dc and I.cd_tp_Tx =AXI.cd_tp_tx_ATL
 left join referencia RF on RF.ref_Acesso=NF.ref_Acesso
 	LEft Join dbo.Base_Nota_Fiscal_AX_TAX_GROUP BNFAT on BNFAT.Nota_Fiscal=NF.Nota_Fiscal and BNFAT.ref_acesso=NF.ref_acesso
 Where
	f.FAtCod = @Fatura and AXI.ID_AX is null


Union all


Select 
	
	
	0,
	I.Num_Proc,
	Case
		When NF.Nota_Fiscal is null then AXPT.Cd_Charge_AX 
		When NF.Nota_Fiscal is not null then  AX.cd_charge_ax

	End 
	Cd_Tp_TX,
	I.dc,
		Vlr_Org	 Valor,
	I.cd_tp_Moeda Moeda,
	HAWB_Him Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,	
	Case
		When Upper(I.cd_tp_moeda)='REL' then 1.000
		When I.Paridade is not null and isnull(I.Paridade,0) <> 1 and I.Cd_Tp_Moeda <>'REL' and Par_NF_HIA is null then I.Paridade
		else Isnull(Par_NF_HIA,par_moeda)	
	End	Paridade,

	
	'Ledger' AccountType,
	Null MasterBOLNbr,
	
	Null MasterBookingNbr,
	Case
		When BNFAT.Tax_Group is not null then BNFAT.Tax_Group
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 12'
		else 'Exempt'
	End	 TaxGroup,		

	

	Obs_Him Notes,
	Null 
	 Num_PRoc_MAster,
	
	(
		CASE  
				When I.DC='D' and NF.Nota_Fiscal is null then AXPT.CC_Custo
				When I.DC='C' and NF.Nota_Fiscal is null then AXPT.CC_Receita
				When I.DC='D' and NF.Nota_Fiscal is Not null then AX.CC_Custo
				When I.DC='C' and NF.Nota_Fiscal is Not null then AX.CC_Receita
		End	
	) Account_Number,
	1 Invoicing,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else 'Servicos de desembaraco aduaneiro, comissarios, despachantes e congeneres'
	 End
	) citCityHallServiceDesc,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else '6637'
	 End
	) citCityHallServiceCode,
			(Case
		When NF.RPS_NFE is NULL Then NF.Emissao
		else NF.RPS_DATA
	End) CitTransDateNF,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else substring(ref_cnpj,9,4)
	 End
	) [07Invoice],
		(Case
		When NF.RPS_NFE is NULL Then NF.Nota_Fiscal 
		else NF.RPS_NFE
	End) DocumentNum,cd_ax,TT.cd_tp_Tx Codigo_TX_ATL
 From Item_Fat I
	Join Fatura F on F.FatCod = I.FatCod 
	Join House_imp_mar Hou on hou.num_proc_mim=I.num_proc
	Join Job_Imp_Mar Job on Job.Num_Proc_HIM=Hou.Num_Proc_HIM 
	Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
	Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = CONVERT(varchar(10),FatDtEmissao,103)
	Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx and ISNULL(Cd_Ax_Resultado,'') <> '000.1'
		Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_Ax_Resultado
		Left Join Tipo_TAxa_AX AXPT on AXPT.cd_Charge_AX=cd_Ax_Repasse
	Left Join vwcta_cte cta on cta.num_proc_hia=I.num_proc and cta.dc_hia=I.dc and cta.cd_tp_tx=I.cd_tp_Tx
	Left Join Base_Nota_Fiscal NF on nota_fiscal=num_nf_hia and NF.ref_acesso=ref_acesso_nf_hia and emissao <= FatDtEmissao
 --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
  left Join vwAXDocs AXI on I.num_proc=AXI.num_proc and I.dc=AXI.dc and I.cd_tp_Tx =AXI.cd_tp_tx_ATL
	left join referencia RF on RF.ref_Acesso=NF.ref_Acesso
	LEft Join dbo.Base_Nota_Fiscal_AX_TAX_GROUP BNFAT on BNFAT.Nota_Fiscal=NF.Nota_Fiscal and BNFAT.ref_acesso=NF.ref_acesso
 Where
	f.FAtCod = @Fatura and AXI.ID_AX is null

GO
