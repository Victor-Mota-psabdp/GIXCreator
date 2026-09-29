SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spAX_NFFaturas2AXDOCNF_Reenvio_Item_SEL
CREATE Procedure [dbo].[spAX_Debitos2AXDOC2Oracle_Reenvio_Item_SEL]
(
	@Num_proc	Varchar(16),
	@Cd_PEs		Varchar(10),
	@DtIns	datetime,
	@Cd_Tp_TX_ATL	varchar(3),
	@DC				Varchar(1)
)
as

--Importacao maritima - House
Select 
	0,
	I.num_proc_him Num_Proc,
	Case 
		When RFI.num_registro is null then AXPT.cd_charge_Ax
		else AX.cd_charge_ax
	End	Cd_Tp_TX,
	I.dc_him DC,
	Vlr_Org_him Valor,
	I.Cd_Tp_Moeda Moeda,
	HAWB_HIM Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	Case
		When upper(I.cd_tp_moeda)='REL' then 1.0000
		else  ISNULL(PAR.Par_Moeda,ULT.Par_Moeda)  
	End	 Paridade,
	'Ledger' AccountType,
	hou.MAWB_HIM MasterBOLNbr,
	Null MasterBookingNbr,
	(
		CASE  
			When DC_HIM='D' and RFI.num_registro is null then 'Exempt'
			When DC_HIM='C' and RFI.num_registro is null then 'Exempt'
			When DC_HIM='D' and RFI.num_registro is Not null then TaxGroup  
			When DC_HIM='C' and RFI.num_registro is Not null then TaxGroup  
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
			When RF.cd_servico is not null then RF.cd_servico
			else Null
		End
	) citCityHallServiceCode,
	(
		Case 
			When RF.cd_servico is not null then RF.Item_lei + ' - ' + dbo.FRemoveAcentuacao(TNDR.Descricao)
			else Null
		End
	)citCityHallServiceDesc,
	(
		Case 
			When RF.cd_servico is not null then RF.Dt_Ins
			else Null
		End
	) CitTransDateNF,
	
	(Case 
		When RF.cd_servico is null then ''
		else substring(ref_cnpj,9,4)
	 End
	) [07Invoice],
	(
		Case 
			When RF.cd_servico is not null then Doc_Number
			else Null
		End
	) DocumentNum,
	I.cd_tp_Tx Codigo_TX_ATL,
	(Case when TT.Tipo_Prod_Code = 1 then '850' else
	(
	Case LEFT(I.num_proc_him,2) 
	
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		when 'EO' then 411
		when 'IO' then 421
	End
	)End)Dimensao_2
 From cta_Cte_hou_Imp_Mar I
		Join House_imp_mar Hou on hou.num_proc_him=I.num_proc_him
		Join Job_Imp_Mar Job on Job.Num_Proc_HIM=Hou.Num_Proc_HIM 
		Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
		Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_him
		Left Join vwUltimaParidade ULT on ULT.Cd_Tp_Moeda = I.Cd_Tp_Moeda and ULT.Cd_Tp_Par = 'OFC'
		Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
		Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_Ax_Resultado
		Left Join Tipo_TAxa_AX AXPT on AXPT.cd_Charge_AX=cd_Ax_Repasse
		LEft Join registro_financeiro_item RFI on I.num_proc_him=rfi.num_proc and I.dc_him=rfi.dc and I.cd_Tp_tx=RFI.cd_tp_tx
		Left Join Registro_Financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
		Join Pessoa PP on PP.cd_pes=cd_Cred_dev_him 
		Left Join Pessoa_ATL_AX AXPP on (AXPP.Cd_Pes = PP.Cd_Pes  ) and Tipo='F'
		Join dbo.AX_XML_Vendor_Recebido AV on accountnum=axpp.cd_ax
		Left Join vwAXDocs IC on (IC.num_proc=I.num_proc_him and len(numerointernoax)=16 or I.num_proc_him=numerointernoAx and len(numerointernoAx)=14)and IC.cd_tp_Tx_ATL=I.cd_Tp_Tx and IC.Dc=I.dc_him
		Left Join referencia R on R.ref_acesso=RF.ref_acesso
		Left Join Tipo_NF_Doc_Register TNDR on RF.cd_servico = 	TNDR.cd_servico and RF.Item_lei = TNDR.Item_lei and RF.Ref_Acesso = TNDR.cd_site
 Where
	I.num_proc_him = @num_proc and 
	(I.dc_him='D' or I.DC_HIM='C' and I.Cd_Tp_Tx in ('XY0','XY1','D2D','XIN'))	
	and cd_Cred_Dev_him=@cd_pes
	and  desp_org_him='N'
	and convert(datetime,dt_ins_him,105)=@DtIns	
	--and IC.num_proc is null
	and I.cd_tp_Tx=@Cd_Tp_TX_ATL
	and I.dc_him=@DC

Union all

--Importacao maritima - master
Select 
	0,
	HOU.num_proc_him Num_Proc,
	Case 
		When RFI.num_registro is null then AXPT.cd_charge_Ax
		else AX.cd_charge_ax
	End	Cd_Tp_TX,
	I.dc_mim DC,
	Vlr_Org_mim*[dbo].[spRateio_Mas](hou.num_proc_him) Valor,
	I.Cd_Tp_Moeda Moeda,
	HAWB_HIM Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	Case
		When upper(I.cd_tp_moeda)='REL' then 1.0000
		else  ISNULL(PAR.Par_Moeda,ULT.Par_Moeda) 
	End	 Paridade,
	'Ledger' AccountType,
	hou.MAWB_HIM MasterBOLNbr,
	Null MasterBookingNbr,
	(
		CASE  
				When DC_MIM='D' and RFI.num_registro is null then 'Exempt'
				When DC_MIM='C' and RFI.num_registro is null then 'Exempt'
				When DC_MIM='D' and RFI.num_registro is Not null then TaxGroup  
				When DC_MIM='C' and RFI.num_registro is Not null then TaxGroup  
		End	
	)
	  TaxGroup,
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
			When RF.cd_servico is not null then RF.cd_servico
			else Null
		End
	) citCityHallServiceCode,
	(
		Case 
			When RF.cd_servico is not null then RF.Item_lei + ' - ' + dbo.FRemoveAcentuacao(TNDR.Descricao)
			else Null
		End
	)citCityHallServiceDesc,
	(
		Case 
			When RF.cd_servico is not null then RF.Dt_Ins
			else Null
		End
	) CitTransDateNF,
	(Case 
		When RF.cd_servico is null then ''
		else substring(ref_cnpj,9,4)
	 End
	)  [07Invoice],
	(
		Case 
			When RF.cd_servico is not null then Doc_Number
			else Null
		End
	) DocumentNum,
	I.cd_tp_Tx Codigo_TX_ATL,
	(Case when TT.Tipo_Prod_Code = 1 then '850' else
	(
	Case LEFT(I.num_proc_mim,2) 
	
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		when 'EO' then 411
		when 'IO' then 421
	End
	)End)Dimensao_2
 From cta_Cte_mas_Imp_Mar I 
		Join House_imp_mar Hou on hou.num_proc_mim=I.num_proc_mim
		Join Job_Imp_Mar Job on Job.Num_Proc_HIM=Hou.Num_Proc_HIM 
		Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
		Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_mim
		Left Join vwUltimaParidade ULT on ULT.Cd_Tp_Moeda = I.Cd_Tp_Moeda and ULT.Cd_Tp_Par = 'OFC'
		Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
		Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_Ax_Resultado
		Left Join Tipo_TAxa_AX AXPT on AXPT.cd_Charge_AX=cd_Ax_Repasse
		LEft Join registro_financeiro_item RFI on I.num_proc_mim=rfi.num_proc and I.dc_mim=rfi.dc and I.cd_Tp_tx=RFI.cd_tp_tx
		Left Join Registro_Financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
		Join Pessoa PP on PP.cd_pes=cd_Cred_dev_mim 
		Left Join Pessoa_ATL_AX AXPP on (AXPP.Cd_Pes = PP.Cd_Pes  ) and Tipo='F'
		Join dbo.AX_XML_Vendor_Recebido AV on accountnum=axpp.cd_ax
		Left Join vwAXDocs IC on (IC.num_proc=I.num_proc_mim and len(numerointernoax)=16 or I.num_proc_mim=numerointernoAx and len(numerointernoAx)=14)and IC.cd_tp_Tx_ATL=I.cd_Tp_Tx and IC.Dc=I.dc_mim
		Left Join referencia R on R.ref_acesso=RF.ref_acesso	
		Left Join Tipo_NF_Doc_Register TNDR on RF.cd_servico = 	TNDR.cd_servico and RF.Item_lei = TNDR.Item_lei and RF.Ref_Acesso = TNDR.cd_site
 Where
	I.num_proc_mim = @num_proc 
	and 
	(I.dc_mim='D' or I.DC_mIM='C' and I.Cd_Tp_Tx in ('XY0','XY1','D2D','XIN'))	
	
	and cd_Cred_Dev_mim=@cd_pes
	and  desp_org_mim='N'
	and convert(datetime,dt_ins_mim,105)=@DtIns	
	--and IC.num_proc is null
	and I.cd_tp_Tx=@Cd_Tp_TX_ATL
	and I.dc_mim=@DC

Union all

--Importacao aerea - House
Select 
	0,
	I.num_proc_hia Num_Proc,
	Case 
		When RFI.num_registro is null then AXPT.cd_charge_Ax
		else AX.cd_charge_ax
	End	Cd_Tp_TX,
	I.dc_hia DC,
	Vlr_Org_hia Valor,
	I.Cd_Tp_Moeda Moeda,
	HAWB_HIA Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	Case
		When upper(I.cd_tp_moeda)='REL' then 1.0000
		else  ISNULL(PAR.Par_Moeda,ULT.Par_Moeda) 
	End	 Paridade,
	'Ledger' AccountType,
	hou.MAWB_HIA MasterBOLNbr,
	Null MasterBookingNbr,
	(
		CASE  
			When DC_HIA='D' and RFI.num_registro is null then 'Exempt'
			When DC_HIA='C' and RFI.num_registro is null then 'Exempt'
			When DC_HIA='D' and RFI.num_registro is Not null then TaxGroup  
			When DC_HIA='C' and RFI.num_registro is Not null then TaxGroup  
		End	
	) TaxGroup,
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
			When RF.cd_servico is not null then RF.cd_servico
			else Null
		End
	) citCityHallServiceCode,	
	(
		Case 
			When RF.cd_servico is not null then RF.Item_lei + ' - ' + dbo.FRemoveAcentuacao(TNDR.Descricao)
			else Null
		End
	)citCityHallServiceDesc,
	(
		Case 
			When RF.cd_servico is not null then RF.Dt_Ins
			else Null
		End
	) CitTransDateNF,
	
	(Case 
		When RF.cd_servico is null then ''
		else substring(ref_cnpj,9,4)
	 End
	) [07Invoice],
	(
		Case 
			When RF.cd_servico is not null then Doc_Number
			else Null
		End
	) DocumentNum,
	I.cd_tp_Tx Codigo_TX_ATL,
	(Case when TT.Tipo_Prod_Code = 1 then '850' else
	(
	Case LEFT(I.num_proc_hia,2) 
	
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		when 'EO' then 411
		when 'IO' then 421
	End
	)End)Dimensao_2
 From cta_Cte_hou_Imp_Aer I
		Join House_imp_aer Hou on hou.num_proc_hia=I.num_proc_hia
		Join Job_Imp_aer Job on Job.Num_Proc_HIa=Hou.Num_Proc_HIa 
		Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
		Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_hia
		Left Join vwUltimaParidade ULT on ULT.Cd_Tp_Moeda = I.Cd_Tp_Moeda and ULT.Cd_Tp_Par = 'OFC'
		Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
		Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_Ax_Resultado
		Left Join Tipo_TAxa_AX AXPT on AXPT.cd_Charge_AX=cd_Ax_Repasse
		LEft Join registro_financeiro_item RFI on I.num_proc_hia=rfi.num_proc and I.dc_hia=rfi.dc and I.cd_Tp_tx=RFI.cd_tp_tx
		Left Join Registro_Financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
		Join Pessoa PP on PP.cd_pes=cd_Cred_dev_hia 
		Left Join Pessoa_ATL_AX AXPP on (AXPP.Cd_Pes = PP.Cd_Pes  ) and Tipo='F'
		Join dbo.AX_XML_Vendor_Recebido AV on accountnum=axpp.cd_ax
		Left Join vwAXDocs IC on (IC.num_proc=I.num_proc_hia and len(numerointernoax)=16 or I.num_proc_hia=numerointernoAx and len(numerointernoAx)=14)and IC.cd_tp_Tx_ATL=I.cd_Tp_Tx and IC.Dc=I.dc_hia
		Left Join referencia R on R.ref_acesso=RF.ref_acesso
		Left Join Tipo_NF_Doc_Register TNDR on RF.cd_servico = 	TNDR.cd_servico and RF.Item_lei = TNDR.Item_lei and RF.Ref_Acesso = TNDR.cd_site
 Where
	I.num_proc_hia = @num_proc and 
	(I.dc_hiA='D' or I.DC_HIA='C' and I.Cd_Tp_Tx in ('XY0','XY1','D2D','XIN'))		
	and cd_Cred_Dev_hia=@cd_pes
	and desp_org_hia='N'
	and convert(datetime,dt_ins_hia,105)=@DtIns	
	--and IC.num_proc is null
	and I.cd_tp_Tx=@Cd_Tp_TX_ATL
	and I.dc_hia=@DC

Union all

--Importacao aerea - master
Select 
	0,
	HOU.num_proc_hia Num_Proc,
	Case 
		When RFI.num_registro is null then AXPT.cd_charge_Ax
		else AX.cd_charge_ax
	End	Cd_Tp_TX,
	I.dc_mia DC,
	Vlr_Org_mia*[dbo].[spRateio_Mas](hou.num_proc_hia) Valor,
	I.Cd_Tp_Moeda Moeda,
	HAWB_HIa Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	Case
		When upper(I.cd_tp_moeda)='REL' then 1.0000
		else  ISNULL(PAR.Par_Moeda,ULT.Par_Moeda)  
	End	 Paridade,
	'Ledger' AccountType,
	hou.MAWB_HIa MasterBOLNbr,
	Null MasterBookingNbr,
	(
		CASE  
			When DC_MIA='D' and RFI.num_registro is null then 'Exempt'
			When DC_MIA='C' and RFI.num_registro is null then 'Exempt'
			When DC_MIA='D' and RFI.num_registro is Not null then TaxGroup  
			When DC_MIA='C' and RFI.num_registro is Not null then TaxGroup  
		End	
	) TaxGroup,
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
			When RF.cd_servico is not null then RF.cd_servico
			else Null
		End
	) citCityHallServiceCode,
	(
		Case 
			When RF.cd_servico is not null then RF.Item_lei + ' - ' + dbo.FRemoveAcentuacao(TNDR.Descricao)
			else Null
		End
	)citCityHallServiceDesc,
	(
		Case 
			When RF.cd_servico is not null then RF.Dt_Ins
			else Null
		End
	) CitTransDateNF,
	
	(Case 
		When RF.cd_servico is null then ''
		else substring(ref_cnpj,9,4)
	 End
	) [07Invoice],
	(
		Case 
			When RF.cd_servico is not null then Doc_Number
			else Null
		End
	) DocumentNum,
	I.cd_tp_Tx Codigo_TX_ATL,
	(Case when TT.Tipo_Prod_Code = 1 then '850' else
	(
	Case LEFT(I.num_proc_mia,2) 
	
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		when 'EO' then 411
		when 'IO' then 421
	End
	)End)Dimensao_2
 From cta_Cte_mas_Imp_aer I
		Join House_imp_aer Hou on hou.num_proc_mia=I.num_proc_mia
		Join Job_Imp_aer Job on Job.Num_Proc_HIa=Hou.Num_Proc_HIa 
		Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
		Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_mia
		Left Join vwUltimaParidade ULT on ULT.Cd_Tp_Moeda = I.Cd_Tp_Moeda and ULT.Cd_Tp_Par = 'OFC'
		Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
		Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_Ax_Resultado
		Left Join Tipo_TAxa_AX AXPT on AXPT.cd_Charge_AX=cd_Ax_Repasse
		LEft Join registro_financeiro_item RFI on I.num_proc_mia=rfi.num_proc and I.dc_mia=rfi.dc and I.cd_Tp_tx=RFI.cd_tp_tx
		Left Join Registro_Financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
		Join Pessoa PP on PP.cd_pes=cd_Cred_dev_mia 
		Left Join Pessoa_ATL_AX AXPP on (AXPP.Cd_Pes = PP.Cd_Pes  ) and Tipo='F'
		Join dbo.AX_XML_Vendor_Recebido AV on accountnum=axpp.cd_ax
		Left Join vwAXDocs IC on (IC.num_proc=I.num_proc_mia and len(numerointernoax)=16 or I.num_proc_mia=numerointernoAx and len(numerointernoAx)=14)and IC.cd_tp_Tx_ATL=I.cd_Tp_Tx and IC.Dc=I.dc_mia
		Left Join referencia R on R.ref_acesso=RF.ref_acesso
		Left Join Tipo_NF_Doc_Register TNDR on RF.cd_servico = 	TNDR.cd_servico and RF.Item_lei = TNDR.Item_lei and RF.Ref_Acesso = TNDR.cd_site
 Where
	I.num_proc_mia = @num_proc and 
	(I.dc_mia='D' or I.DC_MIA='C' and I.Cd_Tp_Tx in ('XY0','XY1','D2D','XIN'))	
	and 
	cd_Cred_Dev_mia=@cd_pes
	and desp_org_mia='N'
	and convert(datetime,dt_ins_mia,105)=@DtIns	
	and IC.num_proc  is null
	and I.cd_tp_Tx=@Cd_Tp_TX_ATL
	and I.dc_mia=@DC

Union all


--exportacao maritima - House
Select 
	0,
	I.num_proc_hem Num_Proc,
	Case 
		When RFI.num_registro is null then AXPT.cd_charge_Ax
		else AX.cd_charge_ax
	End	Cd_Tp_TX,
	I.dc_hem DC,
	Vlr_Org_hem Valor,
	I.Cd_Tp_Moeda Moeda,
	HAWB_Hem Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	Case
		When upper(I.cd_tp_moeda)='REL' then 1.0000
		else  ISNULL(PAR.Par_Moeda,ULT.Par_Moeda) 
	End	 Paridade,
	'Ledger' AccountType,
	hou.MAWB_Hem MasterBOLNbr,
	Null MasterBookingNbr,
	(
		CASE  
			When DC_HEM='D' and RFI.num_registro is null then 'Exempt'
			When DC_HEM='C' and RFI.num_registro is null then 'Exempt'
			When DC_HEM='D' and RFI.num_registro is Not null then TaxGroup  
			When DC_HEM='C' and RFI.num_registro is Not null then TaxGroup  
		End	
	) TaxGroup,
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
			When RF.cd_servico is not null then RF.cd_servico
			else Null
		End
	) citCityHallServiceCode,
	(
		Case 
			When RF.cd_servico is not null then RF.Item_lei + ' - ' + dbo.FRemoveAcentuacao(TNDR.Descricao)
			else Null
		End
	)citCityHallServiceDesc,
	(
		Case 
			When RF.cd_servico is not null then RF.Dt_Ins
			else Null
		End
	) CitTransDateNF,
	(Case 
		When RF.cd_servico is null then ''
		else substring(ref_cnpj,9,4)
	 End
	) [07Invoice],
	(
		Case 
			When RF.cd_servico is not null then Doc_Number
			else Null
		End
	) DocumentNum,
	I.cd_tp_Tx Codigo_TX_ATL,
	(Case when TT.Tipo_Prod_Code = 1 then '850' else
	(
	Case LEFT(I.num_proc_hem,2) 
	
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		when 'EO' then 411
		when 'IO' then 421
	End
	)End)Dimensao_2
 From cta_Cte_hou_Exp_Mar I
		Join House_exp_mar Hou on hou.num_proc_hem=I.num_proc_hem
		Join Job_exp_Mar Job on Job.Num_Proc_HeM=Hou.Num_Proc_HeM 
		Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
		Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_hem
		Left Join vwUltimaParidade ULT on ULT.Cd_Tp_Moeda = I.Cd_Tp_Moeda and ULT.Cd_Tp_Par = 'OFC'
		Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
		Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_Ax_Resultado
		Left Join Tipo_TAxa_AX AXPT on AXPT.cd_Charge_AX=cd_Ax_Repasse
		LEft Join registro_financeiro_item RFI on I.num_proc_hem=rfi.num_proc and I.dc_hem=rfi.dc and I.cd_Tp_tx=RFI.cd_tp_tx
		Left Join Registro_Financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
		Join Pessoa PP on PP.cd_pes=cd_Cred_dev_hem 
		Left Join Pessoa_ATL_AX AXPP on (AXPP.Cd_Pes = PP.Cd_Pes  ) and Tipo='F'
		Join dbo.AX_XML_Vendor_Recebido AV on accountnum=axpp.cd_ax
		Left Join vwAXDocs IC on (IC.num_proc=I.num_proc_hem and len(numerointernoax)=16 or I.num_proc_hem=numerointernoAx and len(numerointernoAx)=14)and IC.cd_tp_Tx_ATL=I.cd_Tp_Tx and IC.Dc=I.dc_hem
		Left Join referencia R on R.ref_acesso=RF.ref_acesso
		Left Join Tipo_NF_Doc_Register TNDR on RF.cd_servico = 	TNDR.cd_servico and RF.Item_lei = TNDR.Item_lei and RF.Ref_Acesso = TNDR.cd_site
 Where
	I.num_proc_hem = @num_proc 
	and 
	(I.dc_hem='D' or I.DC_HeM='C' and I.Cd_Tp_Tx in ('XY0','XY1','D2D','XIN'))	
	and cd_Cred_Dev_hem=@cd_pes
	and desp_dst_hem='N'
	and convert(datetime,dt_ins_hem,105)=@DtIns	
	--and IC.num_proc is null
	and I.cd_tp_Tx=@Cd_Tp_TX_ATL
	and I.dc_hem=@DC

Union all


--exportacao maritima - master
Select 
	0,
	HOU.num_proc_hem Num_Proc,
	Case 
		When RFI.num_registro is null then AXPT.cd_charge_Ax
		else AX.cd_charge_ax
	End	Cd_Tp_TX,
	I.dc_mem DC,
	Vlr_Org_mem*[dbo].[spRateio_Mas](hou.num_proc_hem) Valor,
	I.Cd_Tp_Moeda Moeda,
	HAWB_HEM Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	Case
		When upper(I.cd_tp_moeda)='REL' then 1.0000
		else  ISNULL(PAR.Par_Moeda,ULT.Par_Moeda) 
	End	 Paridade,
	'Ledger' AccountType,
	hou.MAWB_HEM MasterBOLNbr,
	Null MasterBookingNbr,
	(
		CASE  
			When DC_MEM='D' and RFI.num_registro is null then 'Exempt'
			When DC_MEM='C' and RFI.num_registro is null then 'Exempt'
			When DC_MEM='D' and RFI.num_registro is Not null then TaxGroup  
			When DC_MEM='C' and RFI.num_registro is Not null then TaxGroup  
		End	
	) TaxGroup,
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
			When RF.cd_servico is not null then RF.cd_servico
			else Null
		End
	) citCityHallServiceCode,
	(
		Case 
			When RF.cd_servico is not null then RF.Item_lei + ' - ' + dbo.FRemoveAcentuacao(TNDR.Descricao)
			else Null
		End
	)citCityHallServiceDesc,
	(
		Case 
			When RF.cd_servico is not null then RF.Dt_Ins
			else Null
		End
	) CitTransDateNF,
	(Case 
		When RF.cd_servico is null then ''
		else substring(ref_cnpj,9,4)
	 End
	)  [07Invoice],
	(
		Case 
			When RF.cd_servico is not null then Doc_Number
			else Null
		End
	) DocumentNum,
	I.cd_tp_Tx Codigo_TX_ATL,
	(Case when TT.Tipo_Prod_Code = 1 then '850' else
	(
	Case LEFT(I.num_proc_mem,2) 
	
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		when 'EO' then 411
		when 'IO' then 421
	End
	)End)Dimensao_2
 From cta_Cte_mas_exp_mar I
		Join House_exp_mar Hou on hou.num_proc_mem=I.num_proc_mem
		Join Job_exp_mar Job on Job.Num_Proc_Hem=Hou.Num_Proc_HEM
		Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
		Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_mEM
		Left Join vwUltimaParidade ULT on ULT.Cd_Tp_Moeda = I.Cd_Tp_Moeda and ULT.Cd_Tp_Par = 'OFC'
		Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
		Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_Ax_Resultado
		Left Join Tipo_TAxa_AX AXPT on AXPT.cd_Charge_AX=cd_Ax_Repasse
		LEft Join registro_financeiro_item RFI on I.num_proc_mem=rfi.num_proc and I.dc_mem=rfi.dc and I.cd_Tp_tx=RFI.cd_tp_tx
		Left Join Registro_Financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
		Join Pessoa PP on PP.cd_pes=cd_Cred_dev_mem 
		Left Join Pessoa_ATL_AX AXPP on (AXPP.Cd_Pes = PP.Cd_Pes  ) and Tipo='F'
		Join dbo.AX_XML_Vendor_Recebido AV on accountnum=axpp.cd_ax
		Left Join vwAXDocs IC on (IC.num_proc=I.num_proc_mem and len(numerointernoax)=16 or I.num_proc_mem=numerointernoAx and len(numerointernoAx)=14)and IC.cd_tp_Tx_ATL=I.cd_Tp_Tx and IC.Dc=I.dc_mem
		Left Join referencia R on R.ref_acesso=RF.ref_acesso	
		Left Join Tipo_NF_Doc_Register TNDR on RF.cd_servico = 	TNDR.cd_servico and RF.Item_lei = TNDR.Item_lei and RF.Ref_Acesso = TNDR.cd_site
 Where
	I.num_proc_mem = @num_proc and 
	(I.dc_mem='D' or I.DC_mem='C' and I.Cd_Tp_Tx in ('XY0','XY1','D2D','XIN'))	
	and cd_Cred_Dev_mem=@cd_pes
	and desp_dst_mem='N'
	and convert(datetime,dt_ins_mem,105)=@DtIns	
	--and IC.num_proc is null
	and I.cd_tp_Tx=@Cd_Tp_TX_ATL
	and I.dc_mem=@DC
	
Union all

--exportacao aerea - House
Select 
	0,
	I.num_proc_hea Num_Proc,
	Case 
		When RFI.num_registro is null then AXPT.cd_charge_Ax
		else AX.cd_charge_ax
	End	Cd_Tp_TX,
	I.dc_hea DC,
	Vlr_Org_hea Valor,
	I.Cd_Tp_Moeda Moeda,
	HAWB_Hea Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	Case
		When upper(I.cd_tp_moeda)='REL' then 1.0000
		else  ISNULL(PAR.Par_Moeda,ULT.Par_Moeda)  
	End	 Paridade,
	'Ledger' AccountType,
	hou.MAWB_Hea MasterBOLNbr,
	Null MasterBookingNbr,
	(
		CASE  
			When DC_HEA='D' and RFI.num_registro is null then 'Exempt'
			When DC_HEA='C' and RFI.num_registro is null then 'Exempt'
			When DC_HEA='D' and RFI.num_registro is Not null then TaxGroup  
			When DC_HEA='C' and RFI.num_registro is Not null then TaxGroup  
		End	
	) TaxGroup,
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
			When RF.cd_servico is not null then RF.cd_servico
			else Null
		End
	) citCityHallServiceCode,
	(
		Case 
			When RF.cd_servico is not null then RF.Item_lei + ' - ' + dbo.FRemoveAcentuacao(TNDR.Descricao)
			else Null
		End
	)citCityHallServiceDesc,
	(
		Case 
			When RF.cd_servico is not null then RF.Dt_Ins
			else Null
		End
	) CitTransDateNF,
	(Case 
		When Rf.cd_servico is null then ''
		else substring(ref_cnpj,9,4)
	 End
	) [07Invoice],
	(
		Case 
			When RF.cd_servico is not null then Doc_Number
			else Null
		End
	) DocumentNum,
	I.cd_tp_Tx Codigo_TX_ATL,
	(Case when TT.Tipo_Prod_Code = 1 then '850' else
	(
	Case LEFT(I.num_proc_hea,2) 
	
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		when 'EO' then 411
		when 'IO' then 421
	End
	)End)Dimensao_2
 From cta_Cte_hou_Exp_Aer I
		Join House_exp_aer Hou on hou.num_proc_hea=I.num_proc_hea
		Join Job_exp_aer Job on Job.Num_Proc_Hea=Hou.Num_Proc_Hea 
		Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
		Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_hea
		Left Join vwUltimaParidade ULT on ULT.Cd_Tp_Moeda = I.Cd_Tp_Moeda and ULT.Cd_Tp_Par = 'OFC'
		Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
		Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_Ax_Resultado
		Left Join Tipo_TAxa_AX AXPT on AXPT.cd_Charge_AX=cd_Ax_Repasse
		LEft Join registro_financeiro_item RFI on I.num_proc_hea=rfi.num_proc and I.dc_hea=rfi.dc and I.cd_Tp_tx=RFI.cd_tp_tx
		Left Join Registro_Financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
		Join Pessoa PP on PP.cd_pes=cd_Cred_dev_hea 
		Left Join Pessoa_ATL_AX AXPP on (AXPP.Cd_Pes = PP.Cd_Pes  ) and Tipo='F'
		Join dbo.AX_XML_Vendor_Recebido AV on accountnum=axpp.cd_ax
		Left Join vwAXDocs IC on (IC.num_proc=I.num_proc_hea and len(numerointernoax)=16 or I.num_proc_hea=numerointernoAx and len(numerointernoAx)=14)and IC.cd_tp_Tx_ATL=I.cd_Tp_Tx and IC.Dc=I.dc_hea
		Left Join referencia R on R.ref_acesso=RF.ref_acesso	
		Left Join Tipo_NF_Doc_Register TNDR on RF.cd_servico = 	TNDR.cd_servico and RF.Item_lei = TNDR.Item_lei and RF.Ref_Acesso = TNDR.cd_site
 Where
	I.num_proc_hea = @num_proc and 
	(I.dc_hea='D' or I.DC_hea='C' and I.Cd_Tp_Tx in ('XY0','XY1','D2D','XIN'))	
	and cd_Cred_Dev_hea=@cd_pes
	and desp_dst_hea='N'
	and convert(datetime,dt_ins_hea,105)=@DtIns	
	--and IC.num_proc is null
	and I.cd_tp_Tx=@Cd_Tp_TX_ATL
	and I.dc_hea=@DC
	
union all


--exportacao aerea - master
Select 
	0,
	HOU.num_proc_hea Num_Proc,
	Case 
		When RFI.num_registro is null then AXPT.cd_charge_Ax
		else AX.cd_charge_ax
	End	Cd_Tp_TX,
	I.dc_mea DC,
	Vlr_Org_mea*[dbo].[spRateio_Mas](hou.num_proc_hea) Valor,
	I.Cd_Tp_Moeda Moeda,
	HAWB_HEa Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	Case
		When upper(I.cd_tp_moeda)='REL' then 1.0000
		else  ISNULL(PAR.Par_Moeda,ULT.Par_Moeda)  
	End	 Paridade,
	'Ledger' AccountType,
	hou.MAWB_HEa MasterBOLNbr,
	Null MasterBookingNbr,
	(
		CASE  
			When DC_MEA='D' and RFI.num_registro is null then 'Exempt'
			When DC_MEA='C' and RFI.num_registro is null then 'Exempt'
			When DC_MEA='D' and RFI.num_registro is Not null then TaxGroup  
			When DC_MEA='C' and RFI.num_registro is Not null then TaxGroup  
		End	
	) TaxGroup,
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
			When RF.cd_servico is not null then RF.cd_servico
			else Null
		End
	) citCityHallServiceCode,
	(
		Case 
			When RF.cd_servico is not null then RF.Item_lei + ' - ' + dbo.FRemoveAcentuacao(TNDR.Descricao)
			else Null
		End
	)citCityHallServiceDesc,
	(
		Case 
			When RF.cd_servico is not null then RF.Dt_Ins
			else Null
		End
	) CitTransDateNF,
	(Case 
		When RF.cd_servico is null then ''
		else substring(ref_cnpj,9,4)
	 End
	)  [07Invoice],
	(
		Case 
			When RF.cd_servico is not null then Doc_Number
			else Null
		End
	) DocumentNum,
	I.cd_tp_Tx Codigo_TX_ATL,
	(Case when TT.Tipo_Prod_Code = 1 then '850' else
	(
	Case LEFT(I.num_proc_mea,2) 
	
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		when 'EO' then 411
		when 'IO' then 421
	End
	)End)Dimensao_2
 From cta_Cte_mas_exp_aer I
		Join House_exp_aer Hou on hou.num_proc_mea=I.num_proc_mea
		Join Job_exp_aer Job on Job.Num_Proc_Hea=Hou.Num_Proc_HEa
		Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
		Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_mEa
		Left Join vwUltimaParidade ULT on ULT.Cd_Tp_Moeda = I.Cd_Tp_Moeda and ULT.Cd_Tp_Par = 'OFC'
		Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
		Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_Ax_Resultado
		Left Join Tipo_TAxa_AX AXPT on AXPT.cd_Charge_AX=cd_Ax_Repasse
		LEft Join registro_financeiro_item RFI on I.num_proc_mea=rfi.num_proc and I.dc_mea=rfi.dc and I.cd_Tp_tx=RFI.cd_tp_tx
		Left Join Registro_Financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
		Join Pessoa PP on PP.cd_pes=cd_Cred_dev_mea 
		Left Join Pessoa_ATL_AX AXPP on (AXPP.Cd_Pes = PP.Cd_Pes  ) and Tipo='F'
		Join dbo.AX_XML_Vendor_Recebido AV on accountnum=axpp.cd_ax
		Left Join vwAXDocs IC on (IC.num_proc=I.num_proc_mea and len(numerointernoax)=16 or I.num_proc_mea=numerointernoAx and len(numerointernoAx)=14)and IC.cd_tp_Tx_ATL=I.cd_Tp_Tx and IC.Dc=I.dc_mea
		Left Join referencia R on R.ref_acesso=RF.ref_acesso	
		Left Join Tipo_NF_Doc_Register TNDR on RF.cd_servico = 	TNDR.cd_servico and RF.Item_lei = TNDR.Item_lei and RF.Ref_Acesso = TNDR.cd_site
 Where
	I.num_proc_mea = @num_proc and 
	(I.dc_mea='D' or I.dc_mea='C' and I.Cd_Tp_Tx in ('XY0','XY1','D2D','XIN'))	
	and cd_Cred_Dev_mea=@cd_pes
	and desp_dst_mea='N'
	and convert(datetime,dt_ins_mea,105)=@DtIns	
	--and IC.num_proc is null
	and I.cd_tp_Tx=@Cd_Tp_TX_ATL
	and I.dc_mea=@DC

Union all


--importacao outros - House
Select 
	0,
	I.num_proc_hio Num_Proc,
	Case 
		When RFI.num_registro is null then AXPT.cd_charge_Ax
		else AX.cd_charge_ax
	End	Cd_Tp_TX,
	I.dc_hio DC,
	Vlr_Org_hio Valor,
	I.Cd_Tp_Moeda Moeda,
	HAWB_HIO Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	Case
		When upper(I.cd_tp_moeda)='REL' then 1.0000
		else  ISNULL(PAR.Par_Moeda,ULT.Par_Moeda) 
	End	 Paridade,
	'Ledger' AccountType,
	Null MasterBOLNbr,
	Null MasterBookingNbr,
	(
		CASE  
			When DC_HIO='D' and RFI.num_registro is null then 'Exempt'
			When DC_HIO='C' and RFI.num_registro is null then 'Exempt'
			When DC_HIO='D' and RFI.num_registro is Not null then TaxGroup  
			When DC_HIO='C' and RFI.num_registro is Not null then TaxGroup  
		End	
	)
	  TaxGroup,
	Obs_HIO Notes,
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
			When RF.cd_servico is not null then RF.cd_servico
			else Null
		End
	) citCityHallServiceCode,
	(
		Case 
			When RF.cd_servico is not null then RF.Item_lei + ' - ' + dbo.FRemoveAcentuacao(TNDR.Descricao)
			else Null
		End
	)citCityHallServiceDesc,
	(
		Case 
			When RF.cd_servico is not null then RF.Dt_Ins
			else Null
		End
	) CitTransDateNF,
	(Case 
		When Rf.cd_servico is null then ''
		else substring(ref_cnpj,9,4)
	 End
	) [07Invoice],
	(
		Case 
			When Rf.cd_servico is not null then Doc_Number
			else Null
		End
	) DocumentNum,
	I.cd_tp_Tx Codigo_TX_ATL,
	(Case when TT.Tipo_Prod_Code = 1 then '850' else
	(
	Case LEFT(I.num_proc_hio,2) 
	
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		when 'EO' then 411
		when 'IO' then 421
	End
	)End)Dimensao_2
 From cta_Cte_hou_Imp_Out I
		Join House_imp_out Hou on hou.num_proc_hio=I.num_proc_hio
		Join LLP_Imp_out Job on Job.Num_Proc_lio=Hou.Num_Proc_HIo
		Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
		Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_hio
		Left Join vwUltimaParidade ULT on ULT.Cd_Tp_Moeda = I.Cd_Tp_Moeda and ULT.Cd_Tp_Par = 'OFC'
		Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
		Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_Ax_Resultado
		Left Join Tipo_TAxa_AX AXPT on AXPT.cd_Charge_AX=cd_Ax_Repasse
		LEft Join registro_financeiro_item RFI on I.num_proc_hio=rfi.num_proc and I.dc_hio=rfi.dc and I.cd_Tp_tx=RFI.cd_tp_tx
		Left Join Registro_Financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
		Join Pessoa PP on PP.cd_pes=cd_Cred_dev_hio 
		Left Join Pessoa_ATL_AX AXPP on (AXPP.Cd_Pes = PP.Cd_Pes  ) and Tipo='F'
		Join dbo.AX_XML_Vendor_Recebido AV on accountnum=axpp.cd_ax
		Left Join vwAXDocs IC on (IC.num_proc=I.num_proc_hio and len(numerointernoax)=16 or I.num_proc_hio=numerointernoAx and len(numerointernoAx)=14)and IC.cd_tp_Tx_ATL=I.cd_Tp_Tx and IC.Dc=I.dc_hio
		Left Join referencia R on R.ref_acesso=RF.ref_acesso	
		Left Join Tipo_NF_Doc_Register TNDR on RF.cd_servico = 	TNDR.cd_servico and RF.Item_lei = TNDR.Item_lei and RF.Ref_Acesso = TNDR.cd_site
 Where
	I.num_proc_hio = @num_proc 
	and (I.dc_hio='D' or I.dc_hio='C' and I.Cd_Tp_Tx in ('XY0','XY1','D2D','XIN'))	
	and cd_Cred_Dev_hio=@cd_pes
	and desp_org_hio='N'
	and convert(datetime,dt_ins_hio,105)=@DtIns	
	--and IC.num_proc is null 
	and I.cd_tp_Tx=@Cd_Tp_TX_ATL
	and I.dc_hio=@DC

Union all

--exportacao outros - House
Select 
	0,
	I.num_proc_heo Num_Proc,
	Case 
		When RFI.num_registro is null then AXPT.cd_charge_Ax
		else AX.cd_charge_ax
	End	Cd_Tp_TX,
	I.dc_heo DC,
	Vlr_Org_heo Valor,
	I.Cd_Tp_Moeda Moeda,
	HAWB_Heo Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	Case
		When upper(I.cd_tp_moeda)='REL' then 1.0000
		else  ISNULL(PAR.Par_Moeda,ULT.Par_Moeda) 
	End	 Paridade,
	'Ledger' AccountType,
	Null MasterBOLNbr,
	Null MasterBookingNbr,
	(
		CASE  
			When DC_HEO='D' and RFI.num_registro is null then 'Exempt'
			When DC_HEO='C' and RFI.num_registro is null then 'Exempt'
			When DC_HEO='D' and RFI.num_registro is Not null then TaxGroup  
			When DC_HEO='C' and RFI.num_registro is Not null then TaxGroup  
		End	
	)
	  TaxGroup,
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
			When RF.cd_servico is not null then RF.cd_servico
			else Null
		End
	) citCityHallServiceCode,
	(
		Case 
			When RF.cd_servico is not null then RF.Item_lei + ' - ' + dbo.FRemoveAcentuacao(TNDR.Descricao)
			else Null
		End
	)citCityHallServiceDesc,
	(
		Case 
			When RF.cd_servico is not null then RF.Dt_Ins
			else Null
		End
	) CitTransDateNF,
	(Case 
		When RF.cd_servico is null then ''
		else substring(ref_cnpj,9,4)
	 End
	) [07Invoice],
	(
		Case 
			When RF.cd_servico is not null then Doc_Number
			else Null
		End
	) DocumentNum,
	I.cd_tp_Tx Codigo_TX_ATL,
		(Case when TT.Tipo_Prod_Code = 1 then '850' else
	(
	Case LEFT(I.num_proc_heo,2) 
	
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		when 'EO' then 411
		when 'IO' then 421
	End
	)End)Dimensao_2
 From cta_Cte_hou_Exp_Out I
		Join House_exp_out Hou on hou.num_proc_heo=I.num_proc_heo
		Join LLP_exp_out Job on Job.Num_Proc_leo=Hou.Num_Proc_Heo
		Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
		Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_heo
		Left Join vwUltimaParidade ULT on ULT.Cd_Tp_Moeda = I.Cd_Tp_Moeda and ULT.Cd_Tp_Par = 'OFC'
		Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
		Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_Ax_Resultado
		Left Join Tipo_TAxa_AX AXPT on AXPT.cd_Charge_AX=cd_Ax_Repasse
		LEft Join registro_financeiro_item RFI on I.num_proc_heo=rfi.num_proc and I.dc_heo=rfi.dc and I.cd_Tp_tx=RFI.cd_tp_tx
		Left Join Registro_Financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
		Join Pessoa PP on PP.cd_pes=cd_Cred_dev_heo 
		Left Join Pessoa_ATL_AX AXPP on (AXPP.Cd_Pes = PP.Cd_Pes  ) and Tipo='F'
		Join dbo.AX_XML_Vendor_Recebido AV on accountnum=axpp.cd_ax
		Left Join vwAXDocs IC on (IC.num_proc=I.num_proc_heo and len(numerointernoax)=16 or I.num_proc_heo=numerointernoAx and len(numerointernoAx)=14)and IC.cd_tp_Tx_ATL=I.cd_Tp_Tx and IC.Dc=I.dc_heo
		Left Join referencia R on R.ref_acesso=RF.ref_acesso
		Left Join Tipo_NF_Doc_Register TNDR on RF.cd_servico = 	TNDR.cd_servico and RF.Item_lei = TNDR.Item_lei and RF.Ref_Acesso = TNDR.cd_site
 Where
	I.num_proc_heo = @num_proc 
	and(I.dc_heo='D' or I.dc_heo='C' and I.Cd_Tp_Tx in ('XY0','XY1','D2D','XIN'))	
	and cd_Cred_Dev_heo=@cd_pes
	and desp_org_heo='N'
	and convert(datetime,dt_ins_heo,105)=@DtIns	
	--and IC.num_proc is null
	and I.cd_tp_Tx=@Cd_Tp_TX_ATL
	and I.dc_heo=@DC
	
Union all

	
--BDP Outros
Select 
	0,
	I.num_proc_hbo Num_Proc,
	Case 
		When RFI.num_registro is null then AXPT.cd_charge_Ax
		else AX.cd_charge_ax
	End	Cd_Tp_TX,
	I.dc_hbo DC,
	Vlr_Org_hbo Valor,
	I.Cd_Tp_Moeda Moeda,
	'' Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	Case
		When upper(I.cd_tp_moeda)='REL' then 1.0000
		else  ISNULL(PAR.Par_Moeda,ULT.Par_Moeda) 
	End	 Paridade,
	'Ledger' AccountType,
	Null MasterBOLNbr,
	Null MasterBookingNbr,
	(
		CASE  
			When DC_HBO='D' and RFI.num_registro is null then 'Exempt'
			When DC_HBO='C' and RFI.num_registro is null then 'Exempt'
			When DC_HBO='D' and RFI.num_registro is Not null then TaxGroup  
			When DC_HBO='C' and RFI.num_registro is Not null then TaxGroup  
		End	
	)
	  TaxGroup,
	HOU.Descr_Serv_HBO Notes,
	Null 
	Num_PRoc_MAster,
	(
		CASE  
			When DC_HBO='D' and RFI.num_registro is null then AXPT.CC_Custo
			When DC_HBO='C' and RFI.num_registro is null then AXPT.CC_Receita
			When DC_HBO='D' and RFI.num_registro is Not null then AX.CC_Custo
			When DC_HBO='C' and RFI.num_registro is Not null then AX.CC_Receita
		End	
	) Account_Number,
	1 Invoicing,
	(
		Case 
			When RF.cd_servico is not null then RF.cd_servico
			else Null
		End
	) citCityHallServiceCode,
	(
		Case 
			When RF.cd_servico is not null then RF.Item_lei + ' - ' + dbo.FRemoveAcentuacao(TNDR.Descricao)
			else Null
		End
	)citCityHallServiceDesc,
	(
		Case 
			When RF.cd_servico is not null then RF.Dt_Ins
			else Null
		End
	) CitTransDateNF,
	(Case 
		When RF.cd_servico is null then ''
		else substring(ref_cnpj,9,4)
	 End
	) [07Invoice],
	(
		Case 
			When RF.cd_servico is not null then Doc_Number
			else Null
		End
	) DocumentNum,
	I.cd_tp_Tx Codigo_TX_ATL,
	
	(Case when TT.Tipo_Prod_Code = 1 then '850' else
		'800'
	End)Dimensao_2
 From Cta_Cte_HOU_BDP_OUT I
		Join House_BDP_OUT Hou on hou.num_proc_hbo=I.num_proc_hbo
		Left join JOB_HBO J on J.Num_Proc_HBO = I.num_proc_hbo
		Join LLP_BDP_OUT Job on Job.Num_Proc_lbo=Hou.Num_Proc_hbo 		
		Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
		Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = Dt_Ins_HBO
		Left Join vwUltimaParidade ULT on ULT.Cd_Tp_Moeda = I.Cd_Tp_Moeda and ULT.Cd_Tp_Par = 'OFC'
		Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
		Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_Ax_Resultado
		Left Join Tipo_TAxa_AX AXPT on AXPT.cd_Charge_AX=cd_Ax_Repasse
		LEft Join registro_financeiro_item RFI on I.Num_Proc_HBO=rfi.num_proc and I.DC_HBO=rfi.dc and I.cd_Tp_tx=RFI.cd_tp_tx
		Left Join Registro_Financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
		Join Pessoa PP on PP.cd_pes=Cd_Cred_Dev_HBO 
		Left Join Pessoa_ATL_AX AXPP on (AXPP.Cd_Pes = PP.Cd_Pes  ) and Tipo='F'
		Join dbo.AX_XML_Vendor_Recebido AV on accountnum=axpp.cd_ax
		Left Join vwAXDocs IC on (IC.num_proc=I.Num_Proc_HBO and len(numerointernoax)=16 or I.Num_Proc_HBO=numerointernoAx and len(numerointernoAx)=14)and IC.cd_tp_Tx_ATL=I.cd_Tp_Tx and IC.Dc=I.DC_HBO
		Left Join referencia R on R.ref_acesso=RF.ref_acesso
		Left Join Tipo_NF_Doc_Register TNDR on RF.cd_servico = 	TNDR.cd_servico and RF.Item_lei = TNDR.Item_lei and RF.Ref_Acesso = TNDR.cd_site
 Where
	I.Num_Proc_HBO = @num_proc 
	and(I.DC_HBO='D' or I.DC_HBO='C' and I.Cd_Tp_Tx in ('XY0','XY1','D2D','XIN'))	
	and cd_Cred_Dev_hbo=@cd_pes
	and Desp_Org_HBO='N'
	and convert(datetime,Dt_Ins_HBO,105)=@DtIns	
	--and IC.num_proc is null
	and I.cd_tp_Tx=@Cd_Tp_TX_ATL
	and I.DC_HBO=@DC
	and J.Num_Proc is null
	and Job.Id_TP_Servico > 1

Union all	

--BDP Outros com JOB Amarrado
Select 
	0,
	I.num_proc_hbo Num_Proc,
	Case 
		When RFI.num_registro is null then AXPT.cd_charge_Ax
		else AX.cd_charge_ax
	End	Cd_Tp_TX,
	I.dc_hbo DC,
	Vlr_Org_hbo Valor,
	I.Cd_Tp_Moeda Moeda,
	HOU.HAWB Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	Case
		When upper(I.cd_tp_moeda)='REL' then 1.0000
		else  ISNULL(PAR.Par_Moeda,ULT.Par_Moeda) 
	End	 Paridade,
	'Ledger' AccountType,
	HOU.MAWB MasterBOLNbr,
	Null MasterBookingNbr,
	(
		CASE  
			When DC_HBO='D' and RFI.num_registro is null then 'Exempt'
			When DC_HBO='C' and RFI.num_registro is null then 'Exempt'
			When DC_HBO='D' and RFI.num_registro is Not null then TaxGroup  
			When DC_HBO='C' and RFI.num_registro is Not null then TaxGroup  
		End	
	)
	  TaxGroup,
	HOU.OBS Notes,
	Null 
	Num_PRoc_MAster,
	(
		CASE  
			When DC_HBO='D' and RFI.num_registro is null then AXPT.CC_Custo
			When DC_HBO='C' and RFI.num_registro is null then AXPT.CC_Receita
			When DC_HBO='D' and RFI.num_registro is Not null then AX.CC_Custo
			When DC_HBO='C' and RFI.num_registro is Not null then AX.CC_Receita
		End	
	) Account_Number,
	1 Invoicing,
	(
		Case 
			When RF.cd_servico is not null then RF.cd_servico
			else Null
		End
	) citCityHallServiceCode,
	(
		Case 
			When RF.cd_servico is not null then RF.Item_lei + ' - ' + dbo.FRemoveAcentuacao(TNDR.Descricao)
			else Null
		End
	)citCityHallServiceDesc,
	(
		Case 
			When RF.cd_servico is not null then RF.Dt_Ins
			else Null
		End
	) CitTransDateNF,
	(Case 
		When RF.cd_servico is null then ''
		else substring(ref_cnpj,9,4)
	 End
	) [07Invoice],
	(
		Case 
			When RF.cd_servico is not null then Doc_Number
			else Null
		End
	) DocumentNum,
	I.cd_tp_Tx Codigo_TX_ATL,
	
	(Case when TT.Tipo_Prod_Code = 1 then '850' else
		(
			Case LEFT(I.Num_Proc_HBO,2)			
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
 From Cta_Cte_HOU_BDP_OUT I
		Join House_BDP_OUT HBO on HBO.num_proc_hbo=I.num_proc_hbo	
		Join LLP_BDP_OUT LBO on LBO.Num_Proc_lbo=HBO.Num_Proc_hbo 
		
		join JOB_HBO JBO on JBO.Num_Proc_HBO = I.num_proc_hbo
		
		join vwAX_Interface HOU on HOU.Num_Proc = JBO.Num_Proc		
	
		Left Join Usuario US on US.Cd_Usuario = HOU.cd_usuario 
		Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = Dt_Ins_HBO
		Left Join vwUltimaParidade ULT on ULT.Cd_Tp_Moeda = I.Cd_Tp_Moeda and ULT.Cd_Tp_Par = 'OFC'
		Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
		Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_Ax_Resultado
		Left Join Tipo_TAxa_AX AXPT on AXPT.cd_Charge_AX=cd_Ax_Repasse
		LEft Join registro_financeiro_item RFI on I.Num_Proc_HBO=rfi.num_proc and I.DC_HBO=rfi.dc and I.cd_Tp_tx=RFI.cd_tp_tx
		Left Join Registro_Financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
		Join Pessoa PP on PP.cd_pes=Cd_Cred_Dev_HBO 
		Left Join Pessoa_ATL_AX AXPP on (AXPP.Cd_Pes = PP.Cd_Pes  ) and Tipo='F'
		Join dbo.AX_XML_Vendor_Recebido AV on accountnum=axpp.cd_ax
		Left Join vwAXDocs IC on (IC.num_proc=I.Num_Proc_HBO and len(numerointernoax)=16 or I.Num_Proc_HBO=numerointernoAx and len(numerointernoAx)=14)and IC.cd_tp_Tx_ATL=I.cd_Tp_Tx and IC.Dc=I.DC_HBO
		Left Join referencia R on R.ref_acesso=RF.ref_acesso
		Left Join Tipo_NF_Doc_Register TNDR on RF.cd_servico = 	TNDR.cd_servico and RF.Item_lei = TNDR.Item_lei and RF.Ref_Acesso = TNDR.cd_site
 Where
	I.Num_Proc_HBO = @num_proc 
	and(I.DC_HBO='D' or I.DC_HBO='C' and I.Cd_Tp_Tx in ('XY0','XY1','D2D','XIN'))	
	and cd_Cred_Dev_hbo=@cd_pes
	and Desp_Org_HBO='N'
	and convert(datetime,Dt_Ins_HBO,105)=@DtIns	
	--and IC.num_proc is null
	and I.cd_tp_Tx=@Cd_Tp_TX_ATL
	and I.DC_HBO=@DC
	and LBO.Id_TP_Servico = 1
GO
