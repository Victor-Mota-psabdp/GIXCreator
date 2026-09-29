SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--incluido os selects do BO -02/04/2018 - 09:47
CREATE  Procedure [dbo].[spAX_AdtoITem2AX_SEL] 
	@Num_proc	Varchar(16),
	@Cd_PEs		Varchar(10),
	@DtIns	datetime,
	@cd_tp_Tx	Varchar(3)
as

--Importação Maritima
Select 
	0,
	I.num_proc_him Num_Proc,
	Case 
		When RFI.num_registro is null then AXPT.cd_charge_Ax
		else AX.cd_charge_ax
	End	Cd_Tp_TX,	I.dc_him DC,
	Vlr_Org_him Valor,
	I.Cd_Tp_Moeda Moeda,
	HAWB_HIM Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	ISNULL(PAR.Par_Moeda,1) Paridade,
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
		Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
		Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_Ax_Resultado
		Left Join Tipo_TAxa_AX AXPT on AXPT.cd_Charge_AX=cd_Ax_Repasse
		LEft Join registro_financeiro_item RFI on I.num_proc_him=rfi.num_proc and I.dc_him=rfi.dc and I.cd_Tp_tx=RFI.cd_tp_tx
		Left Join Registro_Financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
		Join Pessoa PP on PP.cd_pes=cd_Cred_dev_him 
		Left Join Pessoa_ATL_AX AXPP on (AXPP.Cd_Pes = PP.Cd_Pes  ) and Tipo='C'
		Join dbo.AX_XML_Customer_Recebido AV on accountnum=axpp.cd_ax
 Where
	I.dc_him='C' and left(I.cd_Tp_Tx,1) = 'X'
	And cd_Cred_Dev_him=@cd_pes
	And desp_org_him='N'
	And convert(datetime,dt_ins_him,105)=@DtIns	
	and i.cd_tp_tx=@cd_tp_Tx
	and hou.num_proc_him=@num_proc

Union all


--Exportação Maritima
Select 
	0,
	I.num_proc_hem Num_Proc,
	Case 
		When RFI.num_registro is null then AXPT.cd_charge_Ax
		else AX.cd_charge_ax
	End	Cd_Tp_TX,	I.dc_hem DC,
	Vlr_Org_hem Valor,
	I.Cd_Tp_Moeda Moeda,
	HAWB_hem Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	ISNULL(PAR.Par_Moeda,1) Paridade,
	'Ledger' AccountType,
	hou.MAWB_hem MasterBOLNbr,
	Null MasterBookingNbr,
	(
		CASE  
			When DC_hem='D' and RFI.num_registro is null then 'Exempt'
			When DC_hem='C' and RFI.num_registro is null then 'Exempt'
			When DC_hem='D' and RFI.num_registro is Not null then TaxGroup  
			When DC_hem='C' and RFI.num_registro is Not null then TaxGroup  
		End	
	)
	 TaxGroup,
	Obs_hem Notes,
	(
		Case Num_Proc_mem
			when  'JOB' then ''
			else num_proc_mem
		end
	)
	 Num_PRoc_MAster,
	(
		CASE  
			When DC_hem='D' and RFI.num_registro is null then AXPT.CC_Custo
			When DC_hem='C' and RFI.num_registro is null then AXPT.CC_Receita
			When DC_hem='D' and RFI.num_registro is Not null then AX.CC_Custo
			When DC_hem='C' and RFI.num_registro is Not null then AX.CC_Receita
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
	
 From cta_Cte_hou_exp_Mar I
		Join House_exp_mar Hou on hou.num_proc_hem=I.num_proc_hem
		Join Job_exp_Mar Job on Job.Num_Proc_hem=Hou.Num_Proc_hem 
		Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
		Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_hem
		Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
		Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_Ax_Resultado
		Left Join Tipo_TAxa_AX AXPT on AXPT.cd_Charge_AX=cd_Ax_Repasse
		LEft Join registro_financeiro_item RFI on I.num_proc_hem=rfi.num_proc and I.dc_hem=rfi.dc and I.cd_Tp_tx=RFI.cd_tp_tx
		Left Join Registro_Financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
		Join Pessoa PP on PP.cd_pes=cd_Cred_dev_hem 
		Left Join Pessoa_ATL_AX AXPP on (AXPP.Cd_Pes = PP.Cd_Pes  ) and Tipo='C'
		Join dbo.AX_XML_Customer_Recebido AV on accountnum=axpp.cd_ax
 Where
	I.dc_hem='C' and left(I.cd_Tp_Tx,1) = 'X'
	And cd_Cred_Dev_hem=@cd_pes
	And desp_dst_hem='N'
	And convert(datetime,dt_ins_hem,105)=@DtIns	
	and i.cd_tp_tx=@cd_tp_Tx
	and hou.num_proc_hem=@num_proc

Union all


--Importação Aerea
Select 
	0,
	I.num_proc_hia Num_Proc,
	Case 
		When RFI.num_registro is null then AXPT.cd_charge_Ax
		else AX.cd_charge_ax
	End	Cd_Tp_TX,	I.dc_hia DC,
	Vlr_Org_hia Valor,
	I.Cd_Tp_Moeda Moeda,
	HAWB_hia Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	ISNULL(PAR.Par_Moeda,1) Paridade,
	'Ledger' AccountType,
	hou.MAWB_hia MasterBOLNbr,
	Null MasterBookingNbr,
	(
		CASE  
			When DC_hia='D' and RFI.num_registro is null then 'Exempt'
			When DC_hia='C' and RFI.num_registro is null then 'Exempt'
			When DC_hia='D' and RFI.num_registro is Not null then TaxGroup  
			When DC_hia='C' and RFI.num_registro is Not null then TaxGroup  
		End	
	) TaxGroup,
	Obs_hia Notes,
	(
		Case Num_Proc_mia
			when  'JOB' then ''
			else num_proc_mia
		end
	)
	 Num_PRoc_MAster,
	(
		CASE  
				When DC_hia='D' and RFI.num_registro is null then AXPT.CC_Custo
				When DC_hia='C' and RFI.num_registro is null then AXPT.CC_Receita
				When DC_hia='D' and RFI.num_registro is Not null then AX.CC_Custo
				When DC_hia='C' and RFI.num_registro is Not null then AX.CC_Receita
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
 From cta_Cte_hou_Imp_aer I 
		Join House_imp_aer Hou on hou.num_proc_hia=I.num_proc_hia
		Join Job_Imp_aer Job on Job.Num_Proc_hia=Hou.Num_Proc_hia 
		Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
		Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_hia
		Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
		Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_Ax_Resultado
		Left Join Tipo_TAxa_AX AXPT on AXPT.cd_Charge_AX=cd_Ax_Repasse
		LEft Join registro_financeiro_item RFI on I.num_proc_hia=rfi.num_proc and I.dc_hia=rfi.dc and I.cd_Tp_tx=RFI.cd_tp_tx
		Left Join Registro_Financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
		Join Pessoa PP on PP.cd_pes=cd_Cred_dev_hia 
		Left Join Pessoa_ATL_AX AXPP on (AXPP.Cd_Pes = PP.Cd_Pes  ) and Tipo='C'
		Join dbo.AX_XML_Customer_Recebido AV on accountnum=axpp.cd_ax
 Where
	I.dc_hia='C' and left(I.cd_Tp_Tx,1) = 'X'
	And cd_Cred_Dev_hia=@cd_pes
	And desp_org_hia='N'
	And convert(datetime,dt_ins_hia,105)=@DtIns	
	and i.cd_tp_tx=@cd_tp_Tx
	and hou.num_proc_hia=@num_proc

Union all


--Exportação Aerea
Select 
	0,
	I.num_proc_hea Num_Proc,
	Case 
		When RFI.num_registro is null then AXPT.cd_charge_Ax
		else AX.cd_charge_ax
	End	Cd_Tp_TX,	I.dc_hea DC,
	Vlr_Org_hea Valor,
	I.Cd_Tp_Moeda Moeda,
	HAWB_hea Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	ISNULL(PAR.Par_Moeda,1) Paridade,
	'Ledger' AccountType,
	hou.MAWB_hea MasterBOLNbr,
	Null MasterBookingNbr,
	(
		CASE  
			When DC_hea='D' and RFI.num_registro is null then 'Exempt'
			When DC_hea='C' and RFI.num_registro is null then 'Exempt'
			When DC_hea='D' and RFI.num_registro is Not null then TaxGroup  
			When DC_hea='C' and RFI.num_registro is Not null then TaxGroup  
		End	
	) TaxGroup,
	Obs_hea Notes,
	(
		Case Num_Proc_mea
			when  'JOB' then ''
			else num_proc_mea
		end
	)
	 Num_PRoc_MAster,
	(
		CASE  
				When DC_hea='D' and RFI.num_registro is null then AXPT.CC_Custo
				When DC_hea='C' and RFI.num_registro is null then AXPT.CC_Receita
				When DC_hea='D' and RFI.num_registro is Not null then AX.CC_Custo
				When DC_hea='C' and RFI.num_registro is Not null then AX.CC_Receita
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
 From cta_Cte_hou_exp_aer I
	Join House_exp_aer Hou on hou.num_proc_hea=I.num_proc_hea
	Join Job_exp_aer Job on Job.Num_Proc_hea=Hou.Num_Proc_hea 
	Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
	Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_hea
	Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
	Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_Ax_Resultado
	Left Join Tipo_TAxa_AX AXPT on AXPT.cd_Charge_AX=cd_Ax_Repasse
	LEft Join registro_financeiro_item RFI on I.num_proc_hea=rfi.num_proc and I.dc_hea=rfi.dc and I.cd_Tp_tx=RFI.cd_tp_tx
	Left Join Registro_Financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
	Join Pessoa PP on PP.cd_pes=cd_Cred_dev_hea 
	Left Join Pessoa_ATL_AX AXPP on (AXPP.Cd_Pes = PP.Cd_Pes  ) and Tipo='C'
	Join dbo.AX_XML_Customer_Recebido AV on accountnum=axpp.cd_ax
 Where
	I.dc_hea='C' and left(I.cd_Tp_Tx,1) = 'X'
	And cd_Cred_Dev_hea=@cd_pes
	And desp_dst_hea='N'
	And convert(datetime,dt_ins_hea,105)=@DtIns	
	and i.cd_tp_tx=@cd_tp_Tx
	and hou.num_proc_hea=@num_proc

union all


--Importação Others
Select 
	0,
	I.num_proc_hio Num_Proc,
	Case 
		When RFI.num_registro is null then AXPT.cd_charge_Ax
		else AX.cd_charge_ax
	End	Cd_Tp_TX,	I.dc_hio DC,
	Vlr_Org_hio Valor,
	I.Cd_Tp_Moeda Moeda,
	HAWB_hio Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	ISNULL(PAR.Par_Moeda,1) Paridade,
	'Ledger' AccountType,
	hou.MAWB_hio MasterBOLNbr,
	Null MasterBookingNbr,
	(
		CASE  
			When DC_hio='D' and RFI.num_registro is null then 'Exempt'
			When DC_hio='C' and RFI.num_registro is null then 'Exempt'
			When DC_hio='D' and RFI.num_registro is Not null then TaxGroup  
			When DC_hio='C' and RFI.num_registro is Not null then TaxGroup  
		End	
	)
	TaxGroup,
	Obs_hio Notes,
	''	 Num_PRoc_MAster,
	(
		CASE  
				When DC_hio='D' and RFI.num_registro is null then AXPT.CC_Custo
				When DC_hio='C' and RFI.num_registro is null then AXPT.CC_Receita
				When DC_hio='D' and RFI.num_registro is Not null then AX.CC_Custo
				When DC_hio='C' and RFI.num_registro is Not null then AX.CC_Receita
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
 From cta_Cte_hou_Imp_out I
	Join House_imp_out Hou on hou.num_proc_hio=I.num_proc_hio
	Join llp_imp_out Job on Job.Num_Proc_lio=Hou.Num_Proc_hio 
	Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
	Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_hio
	Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
	Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_Ax_Resultado
	Left Join Tipo_TAxa_AX AXPT on AXPT.cd_Charge_AX=cd_Ax_Repasse
	LEft Join registro_financeiro_item RFI on I.num_proc_hio=rfi.num_proc and I.dc_hio=rfi.dc and I.cd_Tp_tx=RFI.cd_tp_tx
	Left Join Registro_Financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
	Join Pessoa PP on PP.cd_pes=cd_Cred_dev_hio 
	Left Join Pessoa_ATL_AX AXPP on (AXPP.Cd_Pes = PP.Cd_Pes  ) and Tipo='C'
	Join dbo.AX_XML_Customer_Recebido AV on accountnum=axpp.cd_ax
 Where
	I.dc_hio='C' and left(I.cd_Tp_Tx,1) = 'X'
	And cd_Cred_Dev_hio=@cd_pes
	And desp_org_hio='N'
	And convert(datetime,dt_ins_hio,105)=@DtIns	
	and i.cd_tp_tx=@cd_tp_Tx
	and hou.num_proc_hio=@num_proc

Union all

--Exportação Others
Select 
	0,
	I.num_proc_heo Num_Proc,
	Case 
		When RFI.num_registro is null then AXPT.cd_charge_Ax
		else AX.cd_charge_ax
	End	Cd_Tp_TX,	I.dc_heo DC,
	Vlr_Org_heo Valor,
	I.Cd_Tp_Moeda Moeda,
	HAWB_heo Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	ISNULL(PAR.Par_Moeda,1) Paridade,
	'Ledger' AccountType,
	hou.MAWB_heo MasterBOLNbr,
	Null MasterBookingNbr,
	(
		CASE  
			When DC_heo='D' and RFI.num_registro is null then 'Exempt'
			When DC_heo='C' and RFI.num_registro is null then 'Exempt'
			When DC_heo='D' and RFI.num_registro is Not null then TaxGroup  
			When DC_heo='C' and RFI.num_registro is Not null then TaxGroup  
		End	
	)
	  TaxGroup,
	Obs_heo Notes,
	''
	 Num_PRoc_MAster,
	(
		CASE  
				When DC_heo='D' and RFI.num_registro is null then AXPT.CC_Custo
				When DC_heo='C' and RFI.num_registro is null then AXPT.CC_Receita
				When DC_heo='D' and RFI.num_registro is Not null then AX.CC_Custo
				When DC_heo='C' and RFI.num_registro is Not null then AX.CC_Receita
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
 From cta_Cte_hou_exp_out I
	Join House_exp_out Hou on hou.num_proc_heo=I.num_proc_heo
	Join llp_Exp_out Job on Job.Num_Proc_leo=Hou.Num_Proc_heo 
	Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
	Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_heo
	Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
	Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_Ax_Resultado
	Left Join Tipo_TAxa_AX AXPT on AXPT.cd_Charge_AX=cd_Ax_Repasse
	LEft Join registro_financeiro_item RFI on I.num_proc_heo=rfi.num_proc and I.dc_heo=rfi.dc and I.cd_Tp_tx=RFI.cd_tp_tx
	Left Join Registro_Financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
	Join Pessoa PP on PP.cd_pes=cd_Cred_dev_heo 
	Left Join Pessoa_ATL_AX AXPP on (AXPP.Cd_Pes = PP.Cd_Pes  ) and Tipo='C'
	Join dbo.AX_XML_Customer_Recebido AV on accountnum=axpp.cd_ax
 Where
	I.dc_heo='C' and left(I.cd_Tp_Tx,1) = 'X'
	And cd_Cred_Dev_heo=@cd_pes
	And desp_org_heo='N'
	And convert(datetime,dt_ins_heo,105)=@DtIns	
	and i.cd_tp_tx=@cd_tp_Tx
	and hou.num_proc_heo=@num_proc


----BDP Others
--BDP Outros sem JOB Amarrado

Union all


Select 
	0,
	I.Num_Proc_HBO Num_Proc,
	Case 
		When RFI.num_registro is null then AXPT.cd_charge_Ax
		else AX.cd_charge_ax
	End	Cd_Tp_TX,	
	I.DC_HBO DC,
	Vlr_Org_HBO Valor,
	I.Cd_Tp_Moeda Moeda,
	'' Numero_House,  ---HAWB_heo Numero_House, --??
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	ISNULL(PAR.Par_Moeda,1) Paridade,
	'Ledger' AccountType,
	Null MasterBOLNbr,  --hou.MAWB_heo MasterBOLNbr --??
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
	HOU.Descr_Serv_HBO Notes, --Obs_heo Notes, ??
	NULL
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
			When cd_servico is not null then cd_servico
			else Null
		End
	) citCityHallServiceCode,
	Null citCityHallServiceDesc,
	(
		Case 
			When cd_servico is not null then RF.Dt_Ins
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
	Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
	Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_Ax_Resultado
	Left Join Tipo_TAxa_AX AXPT on AXPT.cd_Charge_AX=cd_Ax_Repasse
	LEft Join registro_financeiro_item RFI on I.Num_Proc_HBO=rfi.num_proc and I.DC_HBO=rfi.dc and I.cd_Tp_tx=RFI.cd_tp_tx
	Left Join Registro_Financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
	Join Pessoa PP on PP.cd_pes=Cd_Cred_Dev_HBO 
	Left Join Pessoa_ATL_AX AXPP on (AXPP.Cd_Pes = PP.Cd_Pes  ) and Tipo='C'
	Join dbo.AX_XML_Customer_Recebido AV on accountnum=axpp.cd_ax
 Where
	I.dc_hbo='C' and left(I.cd_Tp_Tx,1) = 'X'
	And cd_Cred_Dev_hbo=@cd_pes
	And desp_org_hbo='N'
	And convert(datetime,dt_ins_hbo,105)=@DtIns	
	and i.cd_tp_tx=@cd_tp_Tx
	and hou.Num_Proc_HBO=@num_proc
	and J.Num_Proc is null
	and JOB.Id_TP_Servico > 1


--BDP Outros com JOB Amarrado

Union all

Select 
	0,
	I.Num_Proc_HBO Num_Proc,
	Case 
		When RFI.num_registro is null then AXPT.cd_charge_Ax
		else AX.cd_charge_ax
	End	Cd_Tp_TX,	
	I.DC_HBO DC,
	Vlr_Org_HBO Valor,
	I.Cd_Tp_Moeda Moeda,
	HOU.HAWB Numero_House, 
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	ISNULL(PAR.Par_Moeda,1) Paridade,
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
	NULL
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
			When cd_servico is not null then cd_servico
			else Null
		End
	) citCityHallServiceCode,
	Null citCityHallServiceDesc,
	(
		Case 
			When cd_servico is not null then RF.Dt_Ins
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
	Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
	Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_Ax_Resultado
	Left Join Tipo_TAxa_AX AXPT on AXPT.cd_Charge_AX=cd_Ax_Repasse
	LEft Join registro_financeiro_item RFI on I.Num_Proc_HBO=rfi.num_proc and I.DC_HBO=rfi.dc and I.cd_Tp_tx=RFI.cd_tp_tx
	Left Join Registro_Financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
	Join Pessoa PP on PP.cd_pes=Cd_Cred_Dev_HBO 
	Left Join Pessoa_ATL_AX AXPP on (AXPP.Cd_Pes = PP.Cd_Pes  ) and Tipo='C'
	Join dbo.AX_XML_Customer_Recebido AV on accountnum=axpp.cd_ax
 Where
	I.dc_hbo='C' and left(I.cd_Tp_Tx,1) = 'X'
	And cd_Cred_Dev_hbo=@cd_pes
	And desp_org_hbo='N'
	And convert(datetime,dt_ins_hbo,105)=@DtIns	
	and i.cd_tp_tx=@cd_tp_Tx
	and I.Num_Proc_HBO=@num_proc
	and LBO.Id_TP_Servico = 1
GO
