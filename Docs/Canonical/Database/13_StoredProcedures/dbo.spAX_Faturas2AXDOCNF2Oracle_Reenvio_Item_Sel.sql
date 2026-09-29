SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure [dbo].[spAX_Faturas2AXDOCNF2Oracle_Reenvio_Item_Sel]
(
	@Fatura	Varchar(20)
)
as

set @Fatura = left(@Fatura,17)

--Declare @Fatura	Varchar(17) = 'IMSWB202512061BRA'

--importação maritima
Select 	
	0,
	Num_Proc,
	Case
		When NF.Nota_Fiscal is null then AXPT.Cd_Charge_AX 
		When NF.Nota_Fiscal is not null then  AX.cd_charge_ax
	End Cd_Tp_TX,
	I.dc,
	Case when E.cd_pais = 'BR' then I.Vlr_RS else Vlr_Org End		Valor,
	Case when E.cd_pais = 'BR' then 'REL' else I.cd_tp_Moeda  End	Moeda,
	--Vlr_Org	 Valor,
	--I.cd_tp_Moeda 	Moeda,
	HAWB_HIM Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,	
	Case
		when E.cd_pais = 'BR' then 1.000
		When Upper(I.cd_tp_moeda)='REL' then 1.000
		When Paridade is not null and isnull(Paridade,0) <> 1 and I.Cd_Tp_Moeda <>'REL' and Par_NF_HIA is null then Paridade
		else Isnull(Par_NF_HIA,par_moeda)	
	End	Paridade,
	'Ledger' AccountType,
	hou.MAWB_HIM MasterBOLNbr,
	
	Null MasterBookingNbr,
	Case
		When Tax_Group is not null then Tax_Group
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 12'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 12'
		else 'Exempt'
	End	 TaxGroupOld,

	C.TaxGroup  [TaxGroupHeader],
	Case
		--when C.TaxGroup = 'CUS SER 20' and Tax_Group is not null then Tax_Group 
		when isnull(NF.ref_acesso,'0') = 'I' and NF.Item_lei='10.05' then 'CUS SER 06' 
		when isnull(NF.ref_acesso,'0') = 'I' and NF.Item_lei='10.06' then 'CUS SER 15' 
		when isnull(NF.ref_acesso,'0') = 'K' and NF.Item_lei='10.05' then 'CUS SER 11' 
		when isnull(NF.ref_acesso,'0') = 'K' and NF.Item_lei='10.06' then 'CUS SER 16' 
		When Tax_Group is not null then Tax_Group
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 12'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 12'
		else 'Exempt'
	End	 TaxGroup,

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
				When DC='D' and NF.Nota_Fiscal is null then AXPT.CC_Custo
				When DC='C' and NF.Nota_Fiscal is null then AXPT.CC_Receita
				When DC='D' and NF.Nota_Fiscal is Not null then AX.CC_Custo
				When DC='C' and NF.Nota_Fiscal is Not null then AX.CC_Receita
		End	
	) Account_Number,
	1 Invoicing,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else NF.Descricao -- 'Servicos de desembaraco aduaneiro, comissarios, despachantes e congeneres'
	 End
	) citCityHallServiceDesc,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else NF.Item_lei -- '6637'
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
	End) DocumentNum,
	TT.cd_ax,TT.cd_tp_Tx Codigo_TX_ATL,
	(Case when TT.Tipo_Prod_Code = 1 then '850' else
	(
	Case LEFT(I.fatcod,2) 
	
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		when 'EO' then 411
		when 'IO' then 421
	End
	)End)Dimensao_2

 From Item_Fat I
	Join Fatura F on F.FatCod = I.FatCod 
	Join Pessoa PP with (nolock) on PP.Cd_Pes=F.cd_pes
	Join Endereco E with (nolock) on E.Cd_Pes=PP.Cd_Pes and E.cd_tp_end = 'COM'
	Left Join Pessoa_ATL_AX ATL_AX with (nolock) on ATL_AX.Cd_Pes = PP.Cd_Pes  and ATL_AX.Tipo='C'
	Left Join dbo.AX_XML_Customer_Recebido C with (nolock) on C.accountnum =ATL_AX.Cd_AX

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
	left join referencia RF on RF.ref_Acesso=NF.ref_Acesso
	LEft Join dbo.Base_Nota_Fiscal_AX_TAX_GROUP BNFAT on BNFAT.Nota_Fiscal=NF.Nota_Fiscal and BNFAT.ref_acesso=NF.ref_acesso
	
 Where
	f.FAtCod = @Fatura

Union all

--importação aerea
Select 
	
	0,
	Num_Proc,
	Case
		When NF.Nota_Fiscal is null then AXPT.Cd_Charge_AX 
		ELSE AX.cd_charge_ax
---		When NF.Nota_Fiscal is not null then  AX.cd_charge_ax
	End 
	Cd_Tp_TX,
	I.dc,
	Case when E.cd_pais = 'BR' then I.Vlr_RS else Vlr_Org End		Valor,
	Case when E.cd_pais = 'BR' then 'REL' else I.cd_tp_Moeda  End	Moeda,
	--Vlr_Org	 Valor,
	--I.cd_tp_Moeda Moeda,
	HAWB_HIA Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,	
	Case
		when E.cd_pais = 'BR' then 1.000
		When Upper(I.cd_tp_moeda)='REL' then 1.000
		When Paridade is not null and isnull(Paridade,0) <> 1 and I.Cd_Tp_Moeda <>'REL' and Par_NF_HIA is null then Paridade
		else Isnull(Par_NF_HIA,par_moeda)	
	End	Paridade,

	'Ledger' AccountType,
	hou.MAWB_HIA MasterBOLNbr,
	
	Null MasterBookingNbr,
	Case
		When Tax_Group is not null then Tax_Group
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 12'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 12'
		else 'Exempt'
	End	 TaxGroupOld,	

	C.TaxGroup  [TaxGroupHeader],
	Case
		--when C.TaxGroup = 'CUS SER 20' and Tax_Group is not null then Tax_Group 
		when isnull(NF.ref_acesso,'0') = 'I' and NF.Item_lei='10.05' then 'CUS SER 06' 
		when isnull(NF.ref_acesso,'0') = 'I' and NF.Item_lei='10.06' then 'CUS SER 15' 
		when isnull(NF.ref_acesso,'0') = 'K' and NF.Item_lei='10.05' then 'CUS SER 11' 
		when isnull(NF.ref_acesso,'0') = 'K' and NF.Item_lei='10.06' then 'CUS SER 16' 
		When Tax_Group is not null then Tax_Group
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 12'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 12'
		else 'Exempt'
	End	 TaxGroup,

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
				When DC='D' and NF.Nota_Fiscal is null then AXPT.CC_Custo
				When DC='C' and NF.Nota_Fiscal is null then AXPT.CC_Receita
				When DC='D' and NF.Nota_Fiscal is Not null then AX.CC_Custo
				When DC='C' and NF.Nota_Fiscal is Not null then AX.CC_Receita
		End	
	) Account_Number,
	1 Invoicing,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else NF.Descricao -- 'Servicos de desembaraco aduaneiro, comissarios, despachantes e congeneres'
	 End
	) citCityHallServiceDesc,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else NF.Item_lei -- '6637'
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
	End) DocumentNum,
	TT.cd_ax,TT.cd_tp_Tx Codigo_TX_ATL,
	(Case when TT.Tipo_Prod_Code = 1 then '850' else
	(
	Case LEFT(I.fatcod,2) 
	
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		when 'EO' then 411
		when 'IO' then 421
	End
	)End)Dimensao_2
	
 From Item_Fat I
 Join Fatura F on F.FatCod = I.FatCod 
 Join Pessoa PP with (nolock) on PP.Cd_Pes=F.cd_pes
 Join Endereco E with (nolock) on E.Cd_Pes=PP.Cd_Pes and E.cd_tp_end = 'COM'
	Left Join Pessoa_ATL_AX ATL_AX with (nolock) on ATL_AX.Cd_Pes = PP.Cd_Pes  and ATL_AX.Tipo='C'
	Left Join dbo.AX_XML_Customer_Recebido C with (nolock) on C.accountnum =ATL_AX.Cd_AX
 Join House_imp_aer Hou on hou.num_proc_hia=I.num_proc
 Join Job_Imp_aer Job on Job.Num_Proc_HIa=Hou.Num_Proc_HIa 
 Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
 Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = CONVERT(varchar(10),FatDtEmissao,103)
 Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx and ISNULL(Cd_Ax_Resultado,'') <> '000.1'
 
Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_Ax_Resultado
Left Join Tipo_TAxa_AX AXPT on AXPT.cd_Charge_AX=cd_Ax_Repasse

 Left Join vwcta_cte cta on cta.num_proc_hia=I.num_proc and cta.dc_hia=I.dc and cta.cd_tp_tx=I.cd_tp_Tx
 Left Join Base_Nota_Fiscal NF on nota_fiscal=num_nf_hia and NF.ref_acesso=ref_acesso_nf_hia  and emissao <= FatDtEmissao
 --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
 left join referencia RF on RF.ref_Acesso=NF.ref_Acesso
	LEft Join dbo.Base_Nota_Fiscal_AX_TAX_GROUP BNFAT on BNFAT.Nota_Fiscal=NF.Nota_Fiscal and BNFAT.ref_acesso=NF.ref_acesso

 Where
	f.FAtCod = @Fatura


Union all

--exportação maritima
Select 
	
	0,
	Num_Proc,
	Case
		When NF.Nota_Fiscal is null then AXPT.Cd_Charge_AX 
		ELSE AX.cd_charge_ax
	--	When NF.Nota_Fiscal is not null then  AX.cd_charge_ax

	End 
	Cd_Tp_TX,
	I.dc,
	Case when E.cd_pais = 'BR' then I.Vlr_RS else Vlr_Org End		Valor,
	Case when E.cd_pais = 'BR' then 'REL' else I.cd_tp_Moeda  End	Moeda,
	--Vlr_Org	 Valor,
	--	I.cd_tp_Moeda 	Moeda,
	HAWB_HEM Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,	
	Case
		when E.cd_pais = 'BR' then 1.000
		When Upper(I.cd_tp_moeda)='REL' then 1.000
		When Paridade is not null and isnull(Paridade,0) <> 1 and I.Cd_Tp_Moeda <>'REL' and Par_NF_HIA is null then Paridade
		else Isnull(Par_NF_HIA,par_moeda)	
	End	Paridade,

	
	'Ledger' AccountType,
	hou.MAWB_HEM MasterBOLNbr,
	
	Null MasterBookingNbr,
	Case
		When Tax_Group is not null then Tax_Group
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 12'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 12'
		else 'Exempt'
	End	 TaxGroupOld,
	
	C.TaxGroup  [TaxGroupHeader],
	Case
		--when C.TaxGroup = 'CUS SER 20' and Tax_Group is not null then Tax_Group 
		when isnull(NF.ref_acesso,'0') = 'I' and NF.Item_lei='10.05' then 'CUS SER 06' 
		when isnull(NF.ref_acesso,'0') = 'I' and NF.Item_lei='10.06' then 'CUS SER 15' 
		when isnull(NF.ref_acesso,'0') = 'K' and NF.Item_lei='10.05' then 'CUS SER 11' 
		when isnull(NF.ref_acesso,'0') = 'K' and NF.Item_lei='10.06' then 'CUS SER 16' 
		When Tax_Group is not null then Tax_Group
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 12'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 12'
		else 'Exempt'
	End	 TaxGroup,

	

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
				When DC='D' and NF.Nota_Fiscal is null then AXPT.CC_Custo
				When DC='C' and NF.Nota_Fiscal is null then AXPT.CC_Receita
				When DC='D' and NF.Nota_Fiscal is Not null then AX.CC_Custo
				When DC='C' and NF.Nota_Fiscal is Not null then AX.CC_Receita
		End	
	) Account_Number,
	1 Invoicing,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else NF.Descricao -- 'Servicos de desembaraco aduaneiro, comissarios, despachantes e congeneres'
	 End
	) citCityHallServiceDesc,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else NF.Item_lei -- '6637'
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
	End) DocumentNum,
	TT.cd_ax,TT.cd_tp_Tx Codigo_TX_ATL,
	(Case when TT.Tipo_Prod_Code = 1 then '850' else
	(
	Case LEFT(I.fatcod,2) 
	
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		when 'EO' then 411
		when 'IO' then 421
	End
	)End)Dimenssao_2
	
 From Item_Fat I
	Join Fatura F on F.FatCod = I.FatCod 
	Join Pessoa PP with (nolock) on PP.Cd_Pes=F.cd_pes
	Join Endereco E with (nolock) on E.Cd_Pes=PP.Cd_Pes and E.cd_tp_end = 'COM'
	Left Join Pessoa_ATL_AX ATL_AX with (nolock) on ATL_AX.Cd_Pes = PP.Cd_Pes  and ATL_AX.Tipo='C'
	Left Join dbo.AX_XML_Customer_Recebido C with (nolock) on C.accountnum =ATL_AX.Cd_AX
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
	Left Join Base_NotA_Fiscal NF on nota_fiscal=num_nf_hia and NF.ref_acesso=ref_acesso_nf_hia  and emissao <= FatDtEmissao
 --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
	left join referencia RF on RF.ref_Acesso=NF.ref_Acesso
 	LEft Join dbo.Base_Nota_Fiscal_AX_TAX_GROUP BNFAT on BNFAT.Nota_Fiscal=NF.Nota_Fiscal and BNFAT.ref_acesso=NF.ref_acesso
  Where
	f.FAtCod = @Fatura


Union all

--exportação aerea
Select 
	
	0,
	Num_Proc,
	Case
		When NF.Nota_Fiscal is null then AXPT.Cd_Charge_AX 
		When NF.Nota_Fiscal is not null then  AX.cd_charge_ax

	End 
	Cd_Tp_TX,
	I.dc,
	Case when E.cd_pais = 'BR' then I.Vlr_RS else Vlr_Org End		Valor,
	Case when E.cd_pais = 'BR' then 'REL' else I.cd_tp_Moeda  End	Moeda,
	--Vlr_Org	 Valor,
	--I.cd_tp_Moeda 	Moeda,
	HAWB_HEA Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,	
	Case
		when E.cd_pais = 'BR' then 1.000
		When Upper(I.cd_tp_moeda)='REL' then 1.000
		When Paridade is not null and isnull(Paridade,0) <> 1 and I.Cd_Tp_Moeda <>'REL' and Par_NF_HIA is null then Paridade
		else Isnull(Par_NF_HIA,par_moeda)	
	End	Paridade,

	'Ledger' AccountType,
	hou.MAWB_HEA MasterBOLNbr,
	
	Null MasterBookingNbr,
	Case
		When Tax_Group is not null then Tax_Group
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 12'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 12'
		else 'Exempt'
	End	 TaxGroupOld,
	
	C.TaxGroup  [TaxGroupHeader],
	Case
		--when C.TaxGroup = 'CUS SER 20' and Tax_Group is not null then Tax_Group 
		when isnull(NF.ref_acesso,'0') = 'I' and NF.Item_lei='10.05' then 'CUS SER 06' 
		when isnull(NF.ref_acesso,'0') = 'I' and NF.Item_lei='10.06' then 'CUS SER 15' 
		when isnull(NF.ref_acesso,'0') = 'K' and NF.Item_lei='10.05' then 'CUS SER 11' 
		when isnull(NF.ref_acesso,'0') = 'K' and NF.Item_lei='10.06' then 'CUS SER 16' 
		When Tax_Group is not null then Tax_Group
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 12'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 12'
		else 'Exempt'
	End	 TaxGroup,

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
				When DC='D' and NF.Nota_Fiscal is null then AXPT.CC_Custo
				When DC='C' and NF.Nota_Fiscal is null then AXPT.CC_Receita
				When DC='D' and NF.Nota_Fiscal is Not null then AX.CC_Custo
				When DC='C' and NF.Nota_Fiscal is Not null then AX.CC_Receita
		End	
	) Account_Number,
	1 Invoicing,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else NF.Descricao -- 'Servicos de desembaraco aduaneiro, comissarios, despachantes e congeneres'
	 End
	) citCityHallServiceDesc,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else NF.Item_lei -- '6637'
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
	End) DocumentNum,
	TT.cd_ax,TT.cd_tp_Tx Codigo_TX_ATL,
	(Case when TT.Tipo_Prod_Code = 1 then '850' else
	(
	Case LEFT(I.fatcod,2) 
	
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		when 'EO' then 411
		when 'IO' then 421
	End
	)End)Dimenssao_2
	
 From Item_Fat I
 Join Fatura F on F.FatCod = I.FatCod
 Join Pessoa PP with (nolock) on PP.Cd_Pes=F.cd_pes
 Join Endereco E with (nolock) on E.Cd_Pes=PP.Cd_Pes and E.cd_tp_end = 'COM'
	Left Join Pessoa_ATL_AX ATL_AX with (nolock) on ATL_AX.Cd_Pes = PP.Cd_Pes  and ATL_AX.Tipo='C'
	Left Join dbo.AX_XML_Customer_Recebido C with (nolock) on C.accountnum =ATL_AX.Cd_AX

 Join House_exp_aer Hou on hou.num_proc_hea=I.num_proc
 Join Job_exp_aer Job on Job.Num_Proc_Hea=Hou.Num_Proc_Hea 
 Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
 Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = CONVERT(varchar(10),FatDtEmissao,103)
	Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx and ISNULL(Cd_Ax_Resultado,'') <> '000.1'
		Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_Ax_Resultado
		Left Join Tipo_TAxa_AX AXPT on AXPT.cd_Charge_AX=cd_Ax_Repasse
 Left Join vwcta_cte cta on cta.num_proc_hia=I.num_proc and cta.dc_hia=I.dc and cta.cd_tp_tx=I.cd_tp_Tx
 Left Join Base_Nota_Fiscal NF on nota_fiscal=num_nf_hia and NF.ref_acesso=ref_acesso_nf_hia  and emissao <= FatDtEmissao
 --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
 left join referencia RF on RF.ref_Acesso=NF.ref_Acesso
 	LEft Join dbo.Base_Nota_Fiscal_AX_TAX_GROUP BNFAT on BNFAT.Nota_Fiscal=NF.Nota_Fiscal and BNFAT.ref_acesso=NF.ref_acesso
 Where
	f.FAtCod = @Fatura

Union all

--exportação outros
Select 
	0,
	Num_Proc,
	Case
		When NF.Nota_Fiscal is null then AXPT.Cd_Charge_AX 
		When NF.Nota_Fiscal is not null then  AX.cd_charge_ax

	End 
	Cd_Tp_TX,
	I.dc,
	Case when E.cd_pais = 'BR' then I.Vlr_RS else Vlr_Org End		Valor,
	Case when E.cd_pais = 'BR' then 'REL' else I.cd_tp_Moeda  End	Moeda,
	--Vlr_Org	 Valor,
	--I.cd_tp_Moeda Moeda,
	HAWB_HEO Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,	
	Case
		when E.cd_pais = 'BR' then 1.000
		When Upper(I.cd_tp_moeda)='REL' then 1.000
		When Paridade is not null and isnull(Paridade,0) <> 1 and I.Cd_Tp_Moeda <>'REL' and Par_NF_HIA is null then Paridade
		else Isnull(Par_NF_HIA,par_moeda)	
	End	Paridade,

	'Ledger' AccountType,
	Null MasterBOLNbr,
	
	Null MasterBookingNbr,
	Case
		When Tax_Group is not null then Tax_Group
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 12'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 12'
		else 'Exempt'
	End	 TaxGroupOld,
	
	C.TaxGroup  [TaxGroupHeader],
	Case
		--when C.TaxGroup = 'CUS SER 20' and Tax_Group is not null then Tax_Group 
		when isnull(NF.ref_acesso,'0') = 'I' and NF.Item_lei='10.05' then 'CUS SER 06' 
		when isnull(NF.ref_acesso,'0') = 'I' and NF.Item_lei='10.06' then 'CUS SER 15' 
		when isnull(NF.ref_acesso,'0') = 'K' and NF.Item_lei='10.05' then 'CUS SER 11' 
		when isnull(NF.ref_acesso,'0') = 'K' and NF.Item_lei='10.06' then 'CUS SER 16' 
		When Tax_Group is not null then Tax_Group
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 12'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 12'
		else 'Exempt'
	End	 TaxGroup,

	Obs_HEO Notes,
	Null 
	 Num_PRoc_MAster,
	(
		CASE  
				When DC='D' and NF.Nota_Fiscal is null then AXPT.CC_Custo
				When DC='C' and NF.Nota_Fiscal is null then AXPT.CC_Receita
				When DC='D' and NF.Nota_Fiscal is Not null then AX.CC_Custo
				When DC='C' and NF.Nota_Fiscal is Not null then AX.CC_Receita
		End	
	) Account_Number,
	1 Invoicing,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else NF.Descricao -- 'Servicos de desembaraco aduaneiro, comissarios, despachantes e congeneres'
	 End
	) citCityHallServiceDesc,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else NF.Item_lei -- '6637'
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
	End) DocumentNum,
	TT.cd_ax,TT.cd_tp_Tx Codigo_TX_ATL,
	(Case when TT.Tipo_Prod_Code = 1 then '850' else
	(
	Case LEFT(I.fatcod,2) 
	
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		when 'EO' then 411
		when 'IO' then 421
	End
	)End)Dimenssao_2
	
 From Item_Fat I
 Join Fatura F on F.FatCod = I.FatCod
 Join Pessoa PP with (nolock) on PP.Cd_Pes=F.cd_pes
 Join Endereco E with (nolock) on E.Cd_Pes=PP.Cd_Pes and E.cd_tp_end = 'COM'
	Left Join Pessoa_ATL_AX ATL_AX with (nolock) on ATL_AX.Cd_Pes = PP.Cd_Pes  and ATL_AX.Tipo='C'
	Left Join dbo.AX_XML_Customer_Recebido C with (nolock) on C.accountnum =ATL_AX.Cd_AX
 Join House_exp_out Hou on hou.num_proc_heo=I.num_proc
 Join LLP_exp_out Job on Job.Num_Proc_leo=Hou.Num_Proc_Heo 
 Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
 Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = CONVERT(varchar(10),FatDtEmissao,103)
 Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx and ISNULL(Cd_Ax_Resultado,'') <> '000.1'
		Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_Ax_Resultado
		Left Join Tipo_TAxa_AX AXPT on AXPT.cd_Charge_AX=cd_Ax_Repasse
 Left Join vwcta_cte cta on cta.num_proc_hia=I.num_proc and cta.dc_hia=I.dc and cta.cd_tp_tx=I.cd_tp_Tx
 Left Join Base_Nota_Fiscal NF on nota_fiscal=num_nf_hia and NF.ref_acesso=ref_acesso_nf_hia  and emissao <= FatDtEmissao
-- Join AX_Doc AXD on AXD.Invoice_Number = F.FAtcod
 left join referencia RF on RF.ref_Acesso=NF.ref_Acesso
 	LEft Join dbo.Base_Nota_Fiscal_AX_TAX_GROUP BNFAT on BNFAT.Nota_Fiscal=NF.Nota_Fiscal and BNFAT.ref_acesso=NF.ref_acesso
 Where
	f.FAtCod = @Fatura


Union all


--importação outros
Select 
	
	0,
	Num_Proc,
	Case
		When NF.Nota_Fiscal is null then AXPT.Cd_Charge_AX 
		When NF.Nota_Fiscal is not null then  AX.cd_charge_ax

	End 
	Cd_Tp_TX,
	I.dc,
	Case when E.cd_pais = 'BR' then I.Vlr_RS else Vlr_Org End		Valor,
	Case when E.cd_pais = 'BR' then 'REL' else I.cd_tp_Moeda  End	Moeda,
	--Vlr_Org	 Valor,
	--I.cd_tp_Moeda Moeda,
	HAWB_Hio Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,	
	Case
		when E.cd_pais = 'BR' then 1.000
		When Upper(I.cd_tp_moeda)='REL' then 1.000
		When Paridade is not null and isnull(Paridade,0) <> 1 and I.Cd_Tp_Moeda <>'REL' and Par_NF_HIA is null then Paridade
		else Isnull(Par_NF_HIA,par_moeda)	
	End	Paridade,

	
	'Ledger' AccountType,
	Null MasterBOLNbr,
	
	Null MasterBookingNbr,
	Case
		When Tax_Group is not null then Tax_Group
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 12'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 12'
		else 'Exempt'
	End	 TaxGroupOld,
	
	C.TaxGroup  [TaxGroupHeader],
	Case
		--when C.TaxGroup = 'CUS SER 20' and Tax_Group is not null then Tax_Group 
		when isnull(NF.ref_acesso,'0') = 'I' and NF.Item_lei='10.05' then 'CUS SER 06' 
		when isnull(NF.ref_acesso,'0') = 'I' and NF.Item_lei='10.06' then 'CUS SER 15' 
		when isnull(NF.ref_acesso,'0') = 'K' and NF.Item_lei='10.05' then 'CUS SER 11' 
		when isnull(NF.ref_acesso,'0') = 'K' and NF.Item_lei='10.06' then 'CUS SER 16' 
		When Tax_Group is not null then Tax_Group
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 12'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 12'
		else 'Exempt'
	End	 TaxGroup,

	

	Obs_HiO Notes,
	Null 
	 Num_PRoc_MAster,
	
	(
		CASE  
				When DC='D' and NF.Nota_Fiscal is null then AXPT.CC_Custo
				When DC='C' and NF.Nota_Fiscal is null then AXPT.CC_Receita
				When DC='D' and NF.Nota_Fiscal is Not null then AX.CC_Custo
				When DC='C' and NF.Nota_Fiscal is Not null then AX.CC_Receita
		End	
	) Account_Number,
	1 Invoicing,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else NF.Descricao -- 'Servicos de desembaraco aduaneiro, comissarios, despachantes e congeneres'
	 End
	) citCityHallServiceDesc,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else NF.Item_lei -- '6637'
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
	End) DocumentNum,
	TT.cd_ax,TT.cd_tp_Tx Codigo_TX_ATL,
	(Case when TT.Tipo_Prod_Code = 1 then '850' else
	(
	Case LEFT(I.fatcod,2) 
	
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		when 'EO' then 411
		when 'IO' then 421
	End
	)End)Dimenssao_2
	
 From Item_Fat I
 Join Fatura F on F.FatCod = I.FatCod 
 Join Pessoa PP with (nolock) on PP.Cd_Pes=F.cd_pes
 Join Endereco E with (nolock) on E.Cd_Pes=PP.Cd_Pes and E.cd_tp_end = 'COM'
	Left Join Pessoa_ATL_AX ATL_AX with (nolock) on ATL_AX.Cd_Pes = PP.Cd_Pes  and ATL_AX.Tipo='C'
	Left Join dbo.AX_XML_Customer_Recebido C with (nolock) on C.accountnum =ATL_AX.Cd_AX
 Join House_imp_out Hou on hou.num_proc_hio=I.num_proc
 Join LLP_imp_out Job on Job.Num_Proc_lio=Hou.Num_Proc_Hio 
 Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
 Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = CONVERT(varchar(10),FatDtEmissao,103)
	Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx and ISNULL(Cd_Ax_Resultado,'') <> '000.1'
		Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_Ax_Resultado
		Left Join Tipo_TAxa_AX AXPT on AXPT.cd_Charge_AX=cd_Ax_Repasse
 Left Join vwcta_cte cta on cta.num_proc_hia=I.num_proc and cta.dc_hia=I.dc and cta.cd_tp_tx=I.cd_tp_Tx
 Left Join Base_Nota_Fiscal NF on nota_fiscal=num_nf_hia and NF.ref_acesso=ref_acesso_nf_hia  and emissao <= FatDtEmissao
 --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
 left join referencia RF on RF.ref_Acesso=NF.ref_Acesso
 	LEft Join dbo.Base_Nota_Fiscal_AX_TAX_GROUP BNFAT on BNFAT.Nota_Fiscal=NF.Nota_Fiscal and BNFAT.ref_acesso=NF.ref_acesso
 Where
	f.FAtCod = @Fatura


Union all

--exportação aerea
Select 
	
	0,
	hou.num_proc_hea Num_Proc,
	Case
		When NF.Nota_Fiscal is null then AXPT.Cd_Charge_AX 
		When NF.Nota_Fiscal is not null then  AX.cd_charge_ax

	End 
	Cd_Tp_TX,
	I.dc,
	Case when E.cd_pais = 'BR' then I.Vlr_RS else Vlr_Org*[dbo].[spRateio_Mas](hou.num_proc_hea) End		Valor,
	Case when E.cd_pais = 'BR' then 'REL' else I.cd_tp_Moeda  End	Moeda,
	--Vlr_Org*[dbo].[spRateio_Mas](hou.num_proc_hea)	 Valor,
	--I.cd_tp_Moeda 	Moeda,
	HAWB_HEA Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,	
	Case
		when E.cd_pais = 'BR' then 1.000
		When Upper(I.cd_tp_moeda)='REL' then 1.000
		When Paridade is not null and isnull(Paridade,0) <> 1 and I.Cd_Tp_Moeda <>'REL' and Par_NF_HIA is null then Paridade
		else Isnull(Par_NF_HIA,par_moeda)	
	End	Paridade,

	'Ledger' AccountType,
	hou.MAWB_HEA MasterBOLNbr,
	
	Null MasterBookingNbr,
	Case
		When Tax_Group is not null then Tax_Group
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 12'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 12'
		else 'Exempt'
	End	 TaxGroupOld,
	
	C.TaxGroup  [TaxGroupHeader],
	Case
		--when C.TaxGroup = 'CUS SER 20' and Tax_Group is not null then Tax_Group 
		when isnull(NF.ref_acesso,'0') = 'I' and NF.Item_lei='10.05' then 'CUS SER 06' 
		when isnull(NF.ref_acesso,'0') = 'I' and NF.Item_lei='10.06' then 'CUS SER 15' 
		when isnull(NF.ref_acesso,'0') = 'K' and NF.Item_lei='10.05' then 'CUS SER 11' 
		when isnull(NF.ref_acesso,'0') = 'K' and NF.Item_lei='10.06' then 'CUS SER 16' 
		When Tax_Group is not null then Tax_Group
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 12'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 12'
		else 'Exempt'
	End	 TaxGroup,
	
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
				When DC='D' and NF.Nota_Fiscal is null then AXPT.CC_Custo
				When DC='C' and NF.Nota_Fiscal is null then AXPT.CC_Receita
				When DC='D' and NF.Nota_Fiscal is Not null then AX.CC_Custo
				When DC='C' and NF.Nota_Fiscal is Not null then AX.CC_Receita
		End	
	) Account_Number,
	1 Invoicing,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else NF.Descricao -- 'Servicos de desembaraco aduaneiro, comissarios, despachantes e congeneres'
	 End
	) citCityHallServiceDesc,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else NF.Item_lei -- '6637'
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
	End) DocumentNum,
	TT.cd_ax,TT.cd_tp_Tx Codigo_TX_ATL,
	(Case when TT.Tipo_Prod_Code = 1 then '850' else
	(
	Case LEFT(I.fatcod,2) 
	
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		when 'EO' then 411
		when 'IO' then 421
	End
	)End)Dimenssao_2
	
 From Item_Fat I
 Join Fatura F on F.FatCod = I.FatCod 
 Join Pessoa PP with (nolock) on PP.Cd_Pes=F.cd_pes
 Join Endereco E with (nolock) on E.Cd_Pes=PP.Cd_Pes and E.cd_tp_end = 'COM'
	Left Join Pessoa_ATL_AX ATL_AX with (nolock) on ATL_AX.Cd_Pes = PP.Cd_Pes  and ATL_AX.Tipo='C'
	Left Join dbo.AX_XML_Customer_Recebido C with (nolock) on C.accountnum =ATL_AX.Cd_AX
 Join House_exp_aer Hou on hou.num_proc_mea=I.num_proc
 Join Job_exp_aer Job on Job.Num_Proc_Hea=Hou.Num_Proc_Hea 
 Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
 Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = CONVERT(varchar(10),FatDtEmissao,103)
	Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx and ISNULL(Cd_Ax_Resultado,'') <> '000.1'
		Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_Ax_Resultado
		Left Join Tipo_TAxa_AX AXPT on AXPT.cd_Charge_AX=cd_Ax_Repasse
 Left Join vwcta_cte cta on cta.num_proc_hia=I.num_proc and cta.dc_hia=I.dc and cta.cd_tp_tx=I.cd_tp_Tx
 Left Join Base_Nota_Fiscal NF on nota_fiscal=num_nf_hia and NF.ref_acesso=ref_acesso_nf_hia  and emissao <= FatDtEmissao
 --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
 left join referencia RF on RF.ref_Acesso=NF.ref_Acesso
 	LEft Join dbo.Base_Nota_Fiscal_AX_TAX_GROUP BNFAT on BNFAT.Nota_Fiscal=NF.Nota_Fiscal and BNFAT.ref_acesso=NF.ref_acesso
 Where
	f.FAtCod = @Fatura


Union all

--importação maritima
Select 
	
	0,
	hou.num_proc_him Num_Proc,
	Case
		When NF.Nota_Fiscal is null then AXPT.Cd_Charge_AX 
		When NF.Nota_Fiscal is not null then  AX.cd_charge_ax
	End Cd_Tp_TX,
	I.dc,
	Case when E.cd_pais = 'BR' then I.Vlr_RS else Vlr_Org*[dbo].[spRateio_Mas](hou.num_proc_him) End		Valor,
	Case when E.cd_pais = 'BR' then 'REL' else I.cd_tp_Moeda  End	Moeda,
	--Vlr_Org*[dbo].[spRateio_Mas](hou.num_proc_him) 	 Valor,
	--I.cd_tp_Moeda 	Moeda,
	HAWB_HIM Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,	
	Case
		when E.cd_pais = 'BR' then 1.000
		When Upper(I.cd_tp_moeda)='REL' then 1.000
		When Paridade is not null and isnull(Paridade,0) <> 1 and I.Cd_Tp_Moeda <>'REL' and Par_NF_HIA is null then Paridade
		else Isnull(Par_NF_HIA,par_moeda)	
	End	Paridade,
	'Ledger' AccountType,
	hou.MAWB_HIM MasterBOLNbr,
	
	Null MasterBookingNbr,
	Case
		When Tax_Group is not null then Tax_Group
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 12'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 12'
		else 'Exempt'
	End	 TaxGroupOld,
	
	C.TaxGroup  [TaxGroupHeader],
	Case
		--when C.TaxGroup = 'CUS SER 20' and Tax_Group is not null then Tax_Group 
		when isnull(NF.ref_acesso,'0') = 'I' and NF.Item_lei='10.05' then 'CUS SER 06' 
		when isnull(NF.ref_acesso,'0') = 'I' and NF.Item_lei='10.06' then 'CUS SER 15' 
		when isnull(NF.ref_acesso,'0') = 'K' and NF.Item_lei='10.05' then 'CUS SER 11' 
		when isnull(NF.ref_acesso,'0') = 'K' and NF.Item_lei='10.06' then 'CUS SER 16' 
		When Tax_Group is not null then Tax_Group
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 12'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 12'
		else 'Exempt'
	End	 TaxGroup,
	 
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
				When DC='D' and NF.Nota_Fiscal is null then AXPT.CC_Custo
				When DC='C' and NF.Nota_Fiscal is null then AXPT.CC_Receita
				When DC='D' and NF.Nota_Fiscal is Not null then AX.CC_Custo
				When DC='C' and NF.Nota_Fiscal is Not null then AX.CC_Receita
		End	
	) Account_Number,
	1 Invoicing,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else NF.Descricao -- 'Servicos de desembaraco aduaneiro, comissarios, despachantes e congeneres'
	 End
	) citCityHallServiceDesc,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else NF.Item_lei -- '6637'
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
	End) DocumentNum,
	TT.cd_ax,TT.cd_tp_Tx Codigo_TX_ATL,
	(Case when TT.Tipo_Prod_Code = 1 then '850' else
	(
	Case LEFT(I.fatcod,2) 
	
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		when 'EO' then 411
		when 'IO' then 421
	End
	)End)Dimenssao_2
	
 From Item_Fat I
	Join Fatura F on F.FatCod = I.FatCod 
	Join Pessoa PP with (nolock) on PP.Cd_Pes=F.cd_pes
	Join Endereco E with (nolock) on E.Cd_Pes=PP.Cd_Pes and E.cd_tp_end = 'COM'
	Left Join Pessoa_ATL_AX ATL_AX with (nolock) on ATL_AX.Cd_Pes = PP.Cd_Pes  and ATL_AX.Tipo='C'
	Left Join dbo.AX_XML_Customer_Recebido C with (nolock) on C.accountnum =ATL_AX.Cd_AX
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
	left join referencia RF on RF.ref_Acesso=NF.ref_Acesso
	LEft Join dbo.Base_Nota_Fiscal_AX_TAX_GROUP BNFAT on BNFAT.Nota_Fiscal=NF.Nota_Fiscal and BNFAT.ref_acesso=NF.ref_acesso
 Where
	f.FAtCod = @Fatura

Union all

--BDP Outros sem JOB Amarrado
Select 
	
	0,
	I.Num_Proc,
	Case
		When NF.Nota_Fiscal is null then AXPT.Cd_Charge_AX 
		ELSE AX.cd_charge_ax
		--When NF.Nota_Fiscal is not null then  AX.cd_charge_ax

	End 
	Cd_Tp_TX,
	I.dc,
	Case when E.cd_pais = 'BR' then I.Vlr_RS else Vlr_Org End		Valor,
	Case when E.cd_pais = 'BR' then 'REL' else I.cd_tp_Moeda  End	Moeda,
	--Vlr_Org	 Valor,
	--I.cd_tp_Moeda Moeda,
	'' Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,	
	Case
		when E.cd_pais = 'BR' then 1.000
		When Upper(I.cd_tp_moeda)='REL' then 1.000
		When Paridade is not null and isnull(Paridade,0) <> 1 and I.Cd_Tp_Moeda <>'REL' and Par_NF_HIA is null then Paridade
		else Isnull(Par_NF_HIA,par_moeda)	
	End	Paridade,

	
	'Ledger' AccountType,
	Null MasterBOLNbr,
	
	Null MasterBookingNbr,
	Case
		When Tax_Group is not null then Tax_Group
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 12'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 12'
		else 'Exempt'
	End	 TaxGroupOld,	

	C.TaxGroup  [TaxGroupHeader],
	Case
		--when C.TaxGroup = 'CUS SER 20' and Tax_Group is not null then Tax_Group 
		when isnull(NF.ref_acesso,'0') = 'I' and NF.Item_lei='10.05' then 'CUS SER 06' 
		when isnull(NF.ref_acesso,'0') = 'I' and NF.Item_lei='10.06' then 'CUS SER 15' 
		when isnull(NF.ref_acesso,'0') = 'K' and NF.Item_lei='10.05' then 'CUS SER 11' 
		when isnull(NF.ref_acesso,'0') = 'K' and NF.Item_lei='10.06' then 'CUS SER 16' 
		When Tax_Group is not null then Tax_Group
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 12'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 12'
		else 'Exempt'
	End	 TaxGroup,
	

	'' Notes,
	Null 
	 Num_PRoc_MAster,
	
	(
		CASE  
				When DC='D' and NF.Nota_Fiscal is null then AXPT.CC_Custo
				When DC='C' and NF.Nota_Fiscal is null then AXPT.CC_Receita
				When DC='D' and NF.Nota_Fiscal is Not null then AX.CC_Custo
				When DC='C' and NF.Nota_Fiscal is Not null then AX.CC_Receita
		End	
	) Account_Number,
	1 Invoicing,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else NF.Descricao -- 'Servicos de desembaraco aduaneiro, comissarios, despachantes e congeneres'
	 End
	) citCityHallServiceDesc,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else NF.Item_lei -- '6637'
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
	End) DocumentNum,
	TT.cd_ax,TT.cd_tp_Tx Codigo_TX_ATL,
	(Case when TT.Tipo_Prod_Code = 1 then '850' else
		'800'		
	End)Dimensao_2
	
 From Item_Fat I
 Join Fatura F on F.FatCod = I.FatCod 
 Join Pessoa PP with (nolock) on PP.Cd_Pes=F.cd_pes
 Join Endereco E with (nolock) on E.Cd_Pes=PP.Cd_Pes and E.cd_tp_end = 'COM'
	Left Join Pessoa_ATL_AX ATL_AX with (nolock) on ATL_AX.Cd_Pes = PP.Cd_Pes  and ATL_AX.Tipo='C'
	Left Join dbo.AX_XML_Customer_Recebido C with (nolock) on C.accountnum =ATL_AX.Cd_AX
 Join House_BDP_OUT Hou on hou.Num_Proc_HBO=I.num_proc
 left join JOB_HBO J on J.Num_Proc_HBO = I.num_proc
 Join LLP_BDP_OUT Job on Job.Num_Proc_LBO=Hou.Num_Proc_HBO 
 Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
 Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = CONVERT(varchar(10),FatDtEmissao,103)
	Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx and ISNULL(Cd_Ax_Resultado,'') <> '000.1'
		Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_Ax_Resultado
		Left Join Tipo_TAxa_AX AXPT on AXPT.cd_Charge_AX=cd_Ax_Repasse
 Left Join vwcta_cte cta on cta.num_proc_hia=I.num_proc and cta.dc_hia=I.dc and cta.cd_tp_tx=I.cd_tp_Tx
 Left Join Base_Nota_Fiscal NF on nota_fiscal=num_nf_hia and NF.ref_acesso=ref_acesso_nf_hia  and emissao <= FatDtEmissao
 --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
 left join referencia RF on RF.ref_Acesso=NF.ref_Acesso
 	LEft Join dbo.Base_Nota_Fiscal_AX_TAX_GROUP BNFAT on BNFAT.Nota_Fiscal=NF.Nota_Fiscal and BNFAT.ref_acesso=NF.ref_acesso
 Where
	f.FAtCod = @Fatura
	and J.Num_Proc is null
	and Job.Id_TP_Servico > 1
	
	
UNION ALL

--BDP Outros com JOB Amarrado

Select	
	0,
	I.Num_Proc,
	Case
		When NF.Nota_Fiscal is null then AXPT.Cd_Charge_AX 
		ELSE AX.cd_charge_ax
		--When NF.Nota_Fiscal is not null then  AX.cd_charge_ax
	End Cd_Tp_TX,
	I.dc,
	Case when E.cd_pais = 'BR' then I.Vlr_RS else Vlr_Org End		Valor,
	Case when E.cd_pais = 'BR' then 'REL' else I.cd_tp_Moeda  End	Moeda,
	--Vlr_Org	 Valor,
	--I.cd_tp_Moeda 	Moeda,
	HOU.HAWB Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,	
	Case
		when E.cd_pais = 'BR' then 1.000
		When Upper(I.cd_tp_moeda)='REL' then 1.000
		When Paridade is not null and isnull(Paridade,0) <> 1 and I.Cd_Tp_Moeda <>'REL' and Par_NF_HIA is null then Paridade
		else Isnull(Par_NF_HIA,par_moeda)	
	End	Paridade,
	'Ledger' AccountType,
	HOU.MAWB MasterBOLNbr,
	
	Null MasterBookingNbr,
	Case
		When Tax_Group is not null then Tax_Group
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 12'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 12'
		else 'Exempt'
	End	 TaxGroupOld,

	C.TaxGroup  [TaxGroupHeader],
	Case
		--when C.TaxGroup = 'CUS SER 20' and Tax_Group is not null then Tax_Group 
		when isnull(NF.ref_acesso,'0') = 'I' and NF.Item_lei='10.05' then 'CUS SER 06' 
		when isnull(NF.ref_acesso,'0') = 'I' and NF.Item_lei='10.06' then 'CUS SER 15' 
		when isnull(NF.ref_acesso,'0') = 'K' and NF.Item_lei='10.05' then 'CUS SER 11' 
		when isnull(NF.ref_acesso,'0') = 'K' and NF.Item_lei='10.06' then 'CUS SER 16' 
		When Tax_Group is not null then Tax_Group
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='B' then 'CUS SER 12'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 13'
		When NF.Nota_Fiscal is Not null and NF.ref_Acesso='I' then 'CUS SER 12'
		else 'Exempt'
	End	 TaxGroup,

	HOU.OBS Notes,
	(
		Case HOU.Master
			when  'JOB' then ''
			else HOU.Master
		end
	)
	 Num_PRoc_MAster,
	(
		CASE  
				When DC='D' and NF.Nota_Fiscal is null then AXPT.CC_Custo
				When DC='C' and NF.Nota_Fiscal is null then AXPT.CC_Receita
				When DC='D' and NF.Nota_Fiscal is Not null then AX.CC_Custo
				When DC='C' and NF.Nota_Fiscal is Not null then AX.CC_Receita
		End	
	) Account_Number,
	1 Invoicing,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else NF.Descricao -- 'Servicos de desembaraco aduaneiro, comissarios, despachantes e congeneres'
	 End
	) citCityHallServiceDesc,
	(Case 
		When NF.Nota_Fiscal is null then ''
		else NF.Item_lei -- '6637'
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
	End) DocumentNum,
	TT.cd_ax,TT.cd_tp_Tx Codigo_TX_ATL	,
	
	(Case when TT.Tipo_Prod_Code = 1 then '850' else
		(
			Case LEFT(I.fatcod,2)			
				when 'BO' then 
					(case LEFT(JBO.Num_Proc,2) 
						when 'IM' then 221
						when 'IA' then 122 
						when 'EA' then 112
						when 'EM' then 216
						when 'EO' then 411
						when 'IO' then 421
						else 800
					End)
			End)
	End)Dimensao_2
 From Item_Fat I
	Join Fatura F on F.FatCod = I.FatCod 
	Join Pessoa PP with (nolock) on PP.Cd_Pes=F.cd_pes
	Join Endereco E with (nolock) on E.Cd_Pes=PP.Cd_Pes and E.cd_tp_end = 'COM'
	Left Join Pessoa_ATL_AX ATL_AX with (nolock) on ATL_AX.Cd_Pes = PP.Cd_Pes  and ATL_AX.Tipo='C'
	Left Join dbo.AX_XML_Customer_Recebido C with (nolock) on C.accountnum =ATL_AX.Cd_AX

	Join House_BDP_OUT HBO on HBO.Num_Proc_HBO=I.num_proc
	Join LLP_BDP_OUT LBO on LBO.Num_Proc_LBO=HBO.Num_Proc_HBO 
	join JOB_HBO JBO on JBO.Num_Proc_HBO = I.num_proc
	
	join vwAX_Interface HOU on HOU.Num_Proc = JBO.Num_Proc		
	
	--Join House_imp_mar Hou on hou.num_proc_him=J.num_proc
	--Join Job_Imp_Mar Job on Job.Num_Proc_HIM=Hou.Num_Proc_HIM 
	Left Join Usuario US on US.Cd_Usuario = HOU.cd_usuario 
	Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = CONVERT(varchar(10),FatDtEmissao,103)
	Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx and Cd_Ax_Resultado  <> '000.1'
	Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_Ax_Resultado
	Left Join Tipo_TAxa_AX AXPT on AXPT.cd_Charge_AX=cd_Ax_Repasse
	Left Join vwcta_cte cta on cta.num_proc_hia=I.num_proc and cta.dc_hia=I.dc and cta.cd_tp_tx=I.cd_tp_Tx
	Left Join Base_Nota_Fiscal NF on nota_fiscal=num_nf_hia and NF.ref_acesso=ref_acesso_nf_hia and emissao <= FatDtEmissao
 --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
	left join referencia RF on RF.ref_Acesso=NF.ref_Acesso
	LEft Join dbo.Base_Nota_Fiscal_AX_TAX_GROUP BNFAT on BNFAT.Nota_Fiscal=NF.Nota_Fiscal and BNFAT.ref_acesso=NF.ref_acesso	
 Where
	f.FAtCod = @Fatura
	and LBO.Id_TP_Servico = 1
GO
