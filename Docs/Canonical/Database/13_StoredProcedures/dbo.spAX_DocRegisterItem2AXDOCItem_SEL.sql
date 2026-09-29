SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spAX_DocRegisterItem2AXDOCItem_SEL] --'',''
	@Num_Registro varchar(20),
	@mes int,
	@ano int

as
Select 
	'10001' Dimensao_1,
	 '' Dimensao_3,
		'BRSAO' Dimensao_4,
	(
	Case LEFT(Num_Proc,2) 
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		else 999
	
	End
	) Dimensao_2,
	'' Dimensao_5,
	
	'BR1' Dimensao_6,
	'OTH-None' Dimensao_7,

	0,
	RFI.num_proc Num_Proc,
	
	cd_charge_AX Cd_Tp_TX,
	RFI.DC DC,
	RFI.Valor_Total Valor,
	RF.Cd_Tp_Moeda Moeda,
	HAWB_HIM Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	
		ISNULL(par.Par_Moeda,1) Paridade,
	'Ledger' AccountType,
	hou.MAWB_HIM MasterBOLNbr,
	Null MasterBookingNbr,
	'VEN SER 01' TaxGroup,
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
				When 'D' then CC_Custo
				When 'C' then CC_Receita
		End	
	) Account_Number,
	1 Invoicing,
		Null citCityHallServiceCode,
			Null citCityHallServiceDesc,
			Null CitTransDateNF,
			Null [07Invoice],
			Null DocumentNum
			
	
	
	
 From Registro_Financeiro RF
 --Join Fatura F on F.FatCod = I.FatCod 
 Join registro_financeiro_item RFI on RFI.num_registro=RF.num_registro and RFI.ano=RF.ano and RFI.mes=RF.mes
 Join House_imp_mar Hou on hou.num_proc_him=RFI.num_proc
 Join Job_Imp_Mar Job on Job.Num_Proc_HIM=Hou.Num_Proc_HIM 
 Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
 Left Join Paridade PAR on PAR.Cd_Tp_Moeda = RF.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and convert(Datetime,dt_par,105)=convert(datetime,convert(varchar(10),dt_ins,105),105)
 Join Tipo_Taxa TT on TT.Cd_Tp_Tx = RFI.Cd_Tp_Tx
 Join Tipo_Taxa_AX on Cd_Charge_AX = Cd_AX 
 --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
 Where
	rf.Num_Registro=@num_registro and rf.ano=@ano and rf.mes=@mes
	
	
Union all

Select 
	'10001' Dimensao_1,
	 '' Dimensao_3,
		'BRSAO' Dimensao_4,
	(
	Case LEFT(Num_Proc,2) 
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		else 999
	
	End
	) Dimensao_2,
	'' Dimensao_5,
	
	'BR1' Dimensao_6,
	'OTH-None' Dimensao_7,

	0,
	RFI.num_proc Num_Proc,
	
	cd_charge_AX Cd_Tp_TX,
	RFI.DC DC,
	RFI.Valor_Total Valor,
	RF.Cd_Tp_Moeda Moeda,
	HAWB_hem Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	
		ISNULL(par.Par_Moeda,1) Paridade,
	'Ledger' AccountType,
	hou.MAWB_hem MasterBOLNbr,
	Null MasterBookingNbr,
	'VEN SER 01' TaxGroup,
	Obs_hem Notes,
	(
		Case Num_Proc_MEM
			when  'JOB' then ''
			else num_proc_mEm
		end
	)
	 Num_PRoc_MAster,
	


	
	(
		CASE DC 
				When 'D' then CC_Custo
				When 'C' then CC_Receita
		End	
	) Account_Number,
	1 Invoicing,
		Null citCityHallServiceCode,
			Null citCityHallServiceDesc,
			Null CitTransDateNF,
			Null [07Invoice],
			Null DocumentNum


	
	
	
 From Registro_Financeiro RF
 --Join Fatura F on F.FatCod = I.FatCod 
 Join registro_financeiro_item RFI on RFI.num_registro=RF.num_registro and RFI.ano=RF.ano and RFI.mes=RF.mes
 Join House_Exp_mar Hou on hou.num_proc_hem=RFI.num_proc
 Join Job_Exp_Mar Job on Job.Num_Proc_hem=Hou.Num_Proc_hem 
 Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
 Left Join Paridade PAR on PAR.Cd_Tp_Moeda = RF.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and convert(Datetime,dt_par,105)=convert(datetime,convert(varchar(10),dt_ins,105),105)
 Join Tipo_Taxa TT on TT.Cd_Tp_Tx = RFI.Cd_Tp_Tx
 Join Tipo_Taxa_AX on Cd_Charge_AX = Cd_AX 
 --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
 Where
	rf.Num_Registro=@num_registro and rf.ano=@ano and rf.mes=@mes
	
	
	
Union all


Select 
	'10001' Dimensao_1,
	 '' Dimensao_3,
		'BRSAO' Dimensao_4,
	(
	Case LEFT(Num_Proc,2) 
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		else 999
	
	End
	) Dimensao_2,
	'' Dimensao_5,
	
	'BR1' Dimensao_6,
	'OTH-None' Dimensao_7,

	0,
	RFI.num_proc Num_Proc,
	
	cd_charge_AX Cd_Tp_TX,
	RFI.DC DC,
	RFI.Valor_Total Valor,
	RF.Cd_Tp_Moeda Moeda,
	HAWB_hia Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	
		ISNULL(par.Par_Moeda,1) Paridade,
	'Ledger' AccountType,
	hou.MAWB_hia MasterBOLNbr,
	Null MasterBookingNbr,
	'VEN SER 01' TaxGroup,
	Obs_hia Notes,
	(
		Case Num_Proc_mia
			when  'JOB' then ''
			else num_proc_mia
		end
	)
	 Num_PRoc_MAster,
	


	
	(
		CASE DC 
				When 'D' then CC_Custo
				When 'C' then CC_Receita
		End	
	) Account_Number,
	
	1 Invoicing,
	Null citCityHallServiceCode,
			Null citCityHallServiceDesc,
			Null CitTransDateNF	,
						Null [07Invoice],
									Null DocumentNum


	
	
 From Registro_Financeiro RF
 --Join Fatura F on F.FatCod = I.FatCod 
 Join registro_financeiro_item RFI on RFI.num_registro=RF.num_registro and RFI.ano=RF.ano and RFI.mes=RF.mes
 Join House_imp_aer Hou on hou.num_proc_hia=RFI.num_proc
 Join Job_Imp_aer Job on Job.Num_Proc_hia=Hou.Num_Proc_hia 
 Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
 Left Join Paridade PAR on PAR.Cd_Tp_Moeda = RF.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and convert(Datetime,dt_par,105)=convert(datetime,convert(varchar(10),dt_ins,105),105)
 Join Tipo_Taxa TT on TT.Cd_Tp_Tx = RFI.Cd_Tp_Tx
 Join Tipo_Taxa_AX on Cd_Charge_AX = Cd_AX 
 --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
 Where
	rf.Num_Registro=@num_registro and rf.ano=@ano and rf.mes=@mes
	
	
Union all

Select 
	'10001' Dimensao_1,
	 '' Dimensao_3,
		'BRSAO' Dimensao_4,
	(
	Case LEFT(Num_Proc,2) 
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		else 999
	
	End
	) Dimensao_2,
	'' Dimensao_5,
	
	'BR1' Dimensao_6,
	'OTH-None' Dimensao_7,

	0,
	RFI.num_proc Num_Proc,
	
	cd_charge_AX Cd_Tp_TX,
	RFI.DC DC,
	RFI.Valor_Total Valor,
	RF.Cd_Tp_Moeda Moeda,
	HAWB_hea Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	
		ISNULL(par.Par_Moeda,1) Paridade,
	'Ledger' AccountType,
	hou.MAWB_hea MasterBOLNbr,
	Null MasterBookingNbr,
	'VEN SER 01' TaxGroup,
	Obs_hea Notes,
	(
		Case Num_Proc_mea
			when  'JOB' then ''
			else num_proc_mea
		end
	)
	 Num_PRoc_MAster,
	


	
	(
		CASE DC 
				When 'D' then CC_Custo
				When 'C' then CC_Receita
		End	
	) Account_Number,
	1 Invoicing,
		Null citCityHallServiceCode,
			Null citCityHallServiceDesc,
			Null CitTransDateNF,
						Null [07Invoice],
									Null DocumentNum


	
	
	
 From Registro_Financeiro RF
 --Join Fatura F on F.FatCod = I.FatCod 
 Join registro_financeiro_item RFI on RFI.num_registro=RF.num_registro and RFI.ano=RF.ano and RFI.mes=RF.mes
 Join House_Exp_aer Hou on hou.num_proc_hea=RFI.num_proc
 Join Job_Exp_aer Job on Job.Num_Proc_hea=Hou.Num_Proc_hea 
 Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
 Left Join Paridade PAR on PAR.Cd_Tp_Moeda = RF.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and convert(Datetime,dt_par,105)=convert(datetime,convert(varchar(10),dt_ins,105),105)
 Join Tipo_Taxa TT on TT.Cd_Tp_Tx = RFI.Cd_Tp_Tx
 Join Tipo_Taxa_AX on Cd_Charge_AX = Cd_AX 
 --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
 Where
	rf.Num_Registro=@num_registro and rf.ano=@ano and rf.mes=@mes
	
Union all

Select 
	'10001' Dimensao_1,
	 '' Dimensao_3,
		'BRSAO' Dimensao_4,
	(
	Case LEFT(Num_Proc,2) 
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		else 999
	
	End
	) Dimensao_2,
	'' Dimensao_5,
	
	'BR1' Dimensao_6,
	'OTH-None' Dimensao_7,

	0,
	RFI.num_proc Num_Proc,
	
	cd_charge_AX Cd_Tp_TX,
	RFI.DC DC,
	RFI.Valor_Total Valor,
	RF.Cd_Tp_Moeda Moeda,
	HAWB_hio Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	
		ISNULL(par.Par_Moeda,1) Paridade,
	'Ledger' AccountType,
	hou.MAWB_hio MasterBOLNbr,
	Null MasterBookingNbr,
	'VEN SER 01' TaxGroup,
	Obs_hio Notes,
	''
	 Num_PRoc_MAster,
	


	
	(
		CASE DC 
				When 'D' then CC_Custo
				When 'C' then CC_Receita
		End	
	) Account_Number,
	1 Invoicing,
		Null citCityHallServiceCode,
			Null citCityHallServiceDesc,
			Null CitTransDateNF,
						Null [07Invoice],
									Null DocumentNum


	
	
	
 From Registro_Financeiro RF
 --Join Fatura F on F.FatCod = I.FatCod 
 Join registro_financeiro_item RFI on RFI.num_registro=RF.num_registro and RFI.ano=RF.ano and RFI.mes=RF.mes
 Join House_imp_out Hou on hou.num_proc_hio=RFI.num_proc
 Join llp_Imp_out Job on Job.Num_Proc_Lio=Hou.Num_Proc_hio 
 Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
 Left Join Paridade PAR on PAR.Cd_Tp_Moeda = RF.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and convert(Datetime,dt_par,105)=convert(datetime,convert(varchar(10),dt_ins,105),105)
 Join Tipo_Taxa TT on TT.Cd_Tp_Tx = RFI.Cd_Tp_Tx
 Join Tipo_Taxa_AX on Cd_Charge_AX = Cd_AX 
 --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
 Where
	rf.Num_Registro=@num_registro and rf.ano=@ano and rf.mes=@mes
	
	
Union all

Select 
	'10001' Dimensao_1,
	 '' Dimensao_3,
		'BRSAO' Dimensao_4,
	(
	Case LEFT(Num_Proc,2) 
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		else 999
	
	End
	) Dimensao_2,
	'' Dimensao_5,
	
	'BR1' Dimensao_6,
	'OTH-None' Dimensao_7,

	0,
	RFI.num_proc Num_Proc,
	
	cd_charge_AX Cd_Tp_TX,
	RFI.DC DC,
	RFI.Valor_Total Valor,
	RF.Cd_Tp_Moeda Moeda,
	HAWB_heo Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	
		ISNULL(par.Par_Moeda,1) Paridade,
	'Ledger' AccountType,
	hou.MAWB_heo MasterBOLNbr,
	Null MasterBookingNbr,
	'VEN SER 01' TaxGroup,
	Obs_heo Notes,
	''
	 Num_PRoc_MAster,
	


	
	(
		CASE DC 
				When 'D' then CC_Custo
				When 'C' then CC_Receita
		End	
	) Account_Number,
	1 Invoicing,
		Null citCityHallServiceCode,
			Null citCityHallServiceDesc,
			Null CitTransDateNF,
						Null [07Invoice],
									Null DocumentNum


	
	
	
 From Registro_Financeiro RF
 --Join Fatura F on F.FatCod = I.FatCod 
 Join registro_financeiro_item RFI on RFI.num_registro=RF.num_registro and RFI.ano=RF.ano and RFI.mes=RF.mes
 Join House_Exp_out Hou on hou.num_proc_heo=RFI.num_proc
 Join LLP_Exp_out Job on Job.Num_Proc_leo=Hou.Num_Proc_heo 
 Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
 Left Join Paridade PAR on PAR.Cd_Tp_Moeda = RF.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and convert(Datetime,dt_par,105)=convert(datetime,convert(varchar(10),dt_ins,105),105)
 Join Tipo_Taxa TT on TT.Cd_Tp_Tx = RFI.Cd_Tp_Tx
 Join Tipo_Taxa_AX on Cd_Charge_AX = Cd_AX 
 --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
 Where
	rf.Num_Registro=@num_registro and rf.ano=@ano and rf.mes=@mes
	

union all


Select 
	'10001' Dimensao_1,
	 '' Dimensao_3,
		'BRSAO' Dimensao_4,
	(
	Case LEFT(C.Num_Proc,2) 
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		else 999
	
	End
	) Dimensao_2,
	'' Dimensao_5,
	
	'BR1' Dimensao_6,
	'OTH-None' Dimensao_7,

	0,
	c.num_proc Num_Proc,
	
	cd_charge_AX Cd_Tp_TX,
	RFI.DC DC,
	RFI.Valor_Total Valor,
	RF.Cd_Tp_Moeda Moeda,
	HAWB_HIM Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	
		ISNULL(par.Par_Moeda,1) Paridade,
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
				When 'D' then CC_Custo
				When 'C' then CC_Receita
		End	
	) Account_Number,
	1 Invoicing,
		Null citCityHallServiceCode,
			Null citCityHallServiceDesc,
			Null CitTransDateNF,
						Null [07Invoice],
									Null DocumentNum


	
	
	
 From Registro_Financeiro RF
 --Join Fatura F on F.FatCod = I.FatCod 
 Join registro_financeiro_item RFI on RFI.num_registro=RF.num_registro and RFI.ano=RF.ano and RFI.mes=RF.mes
 Join vwcliente C on master=rfi.num_proc
 Join House_imp_mar Hou on hou.num_proc_him=c.num_proc
 Join Job_Imp_Mar Job on Job.Num_Proc_HIM=Hou.Num_Proc_HIM 
 Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
 Left Join Paridade PAR on PAR.Cd_Tp_Moeda = RF.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and convert(Datetime,dt_par,105)=convert(datetime,convert(varchar(10),dt_ins,105),105)
 Join Tipo_Taxa TT on TT.Cd_Tp_Tx = RFI.Cd_Tp_Tx
 Join Tipo_Taxa_AX on Cd_Charge_AX = Cd_AX 
 --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
 Where
	rf.Num_Registro=@num_registro and rf.ano=@ano and rf.mes=@mes



GO
