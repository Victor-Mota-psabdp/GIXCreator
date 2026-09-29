SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_AXNFItem] --[spATL_AXNFItem]  '41415.A'
	@Nota_Fiscal	Varchar(17)
as

Declare @Ref_Acesso Varchar(1)

set @Ref_Acesso=right(@Nota_FIscal,1)
Set @Nota_Fiscal=left(@nota_Fiscal,len(@Nota_Fiscal)-2)


Select 
	'10001' Dimensao_1,
	 AX_GRUPO Dimensao_3,
		'BRSAO' Dimensao_4,
	(
	Case LEFT(i.num_proc_hia,2) 
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		else 999
	
	End
	) Dimensao_2,
	'' Dimensao_5,
	
	'BR1' Dimensao_6,
	Null Dimensao_7,

	
	0,
	I.Num_Proc_HIA Num_Proc,
	
	Isnull(cd_charge_AX,900) Cd_Tp_TX,
	dc_hia DC,
	Vlr_Pgto_NF_HIA Valor,
	'REL'  Moeda,
	HAWB_HIM Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	
		1 Paridade,
	'Ledger' AccountType,
	hou.MAWB_HIM MasterBOLNbr,
	Null MasterBookingNbr,
	Case
		When Nota_Fiscal is not null and ref_acesso<>'B' then 'CUS SER 02'
		When Nota_Fiscal is not null and ref_acesso='B' then 'CUS SER 03'

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
		CASE DC_hia 
				When 'D' then CC_Custo
				When 'C' then CC_Receita
		End	
	) Account_Number,
	1 Invoicing
	
	
	
 From vwcta_cte I
 Join Base_nota_fiscal nf on nf.nota_fiscal=num_nf_hia and ref_acesso=ref_acesso_NF_hia
 Join House_imp_mar Hou WITH(NOLOCK) on hou.num_proc_him=I.num_proc_hia
 Join Job_Imp_Mar Job WITH(NOLOCK)  on Job.Num_Proc_HIM=Hou.Num_Proc_HIM 
 Left Join Usuario US WITH(NOLOCK)  on US.Cd_Usuario = Job.cd_usuario 
-- Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = CONVERT(varchar(10),FatDtEmissao,103)
 Join Tipo_Taxa TT WITH(NOLOCK)  on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
 Left Join Tipo_Taxa_AX WITH(NOLOCK)  on Cd_Charge_AX = Cd_AX 
 --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
left  Join Pessoa_llp P WITH(NOLOCK) on p.cd_pes=nf.cd_pes
 Left Join Grupo GRP WITH(NOLOCK) on GRP.Cd_Pes_Grupo = P.Cd_Pes_Grupo 
 Left Join Pessoa_ATL_AX AX WITH(NOLOCK) on AX.Cd_Pes = P.Cd_Pes and Tipo='C'

 Where
	Nota_Fiscal=@Nota_Fiscal and ref_Acesso=@ref_Acesso
--	+'.'+ref_acesso=@Nota_Fiscal


Union all

Select 
	'10001' Dimensao_1,
	 AX_GRUPO Dimensao_3,
		'BRSAO' Dimensao_4,
	(
	Case LEFT(i.num_proc_hia,2) 
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		else 999
	
	End
	) Dimensao_2,
	'' Dimensao_5,
	
	'BR1' Dimensao_6,
	Null Dimensao_7,

	
	0,
	I.Num_Proc_HIA Num_Proc,
	
	Isnull(cd_charge_AX,900) Cd_Tp_TX,
	dc_hia DC,
	Vlr_Pgto_NF_HIA Valor,
	'REL'  Moeda,
	HAWB_hem Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	
		1 Paridade,
	'Ledger' AccountType,
	hou.MAWB_hem MasterBOLNbr,
	Null MasterBookingNbr,
	Case
		When Nota_Fiscal is not null and ref_acesso<>'B' then 'CUS SER 02'
		When Nota_Fiscal is not null and ref_acesso='B' then 'CUS SER 03'

		When Nota_Fiscal is null then 'Exempt'

	End,
	Obs_hem Notes,
	(
		Case Num_Proc_MeM
			when  'JOB' then ''
			else num_proc_mEm
		end
	)
	 Num_PRoc_MAster,
	


	
	(
		CASE DC_hia 
				When 'D' then CC_Custo
				When 'C' then CC_Receita
		End	
	) Account_Number,
	1 Invoicing
	
	
	
 From vwcta_cte I WITH(NOLOCK)
 Join Base_nota_fiscal nf WITH(NOLOCK) on nf.nota_fiscal=num_nf_hia and ref_acesso=ref_acesso_NF_hia
 Join House_exp_mar Hou WITH(NOLOCK) on hou.num_proc_hem=I.num_proc_hia
 Join Job_exp_Mar Job WITH(NOLOCK) on Job.Num_Proc_hem=Hou.Num_Proc_hem 
 Left Join Usuario US WITH(NOLOCK) on US.Cd_Usuario = Job.cd_usuario 
-- Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = CONVERT(varchar(10),FatDtEmissao,103)
 Join Tipo_Taxa TT WITH(NOLOCK) on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
 Left Join Tipo_Taxa_AX WITH(NOLOCK) on Cd_Charge_AX = Cd_AX 
 --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
left  Join Pessoa_llp P WITH(NOLOCK) on p.cd_pes=nf.cd_pes
 Left Join Grupo GRP WITH(NOLOCK) on GRP.Cd_Pes_Grupo = P.Cd_Pes_Grupo 
 Left Join Pessoa_ATL_AX AX WITH(NOLOCK) on AX.Cd_Pes = P.Cd_Pes and Tipo='C'

 Where
	Nota_Fiscal=@Nota_Fiscal and ref_Acesso=@ref_Acesso
	
UNION ALL

Select 
	'10001' Dimensao_1,
	 AX_GRUPO Dimensao_3,
		'BRSAO' Dimensao_4,
	(
	Case LEFT(i.num_proc_hia,2) 
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		else 999
	
	End
	) Dimensao_2,
	'' Dimensao_5,
	
	'BR1' Dimensao_6,
	Null Dimensao_7,

	
	0,
	I.Num_Proc_HIA Num_Proc,
	
	Isnull(cd_charge_AX,900) Cd_Tp_TX,
	dc_hia DC,
	Vlr_Pgto_NF_HIA Valor,
	'REL'  Moeda,
	HAWB_HIA Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	
		1 Paridade,
	'Ledger' AccountType,
	hou.MAWB_HIA MasterBOLNbr,
	Null MasterBookingNbr,
		Case
		When Nota_Fiscal is not null and ref_acesso<>'B' then 'CUS SER 02'
		When Nota_Fiscal is not null and ref_acesso='B' then 'CUS SER 03'

		When Nota_Fiscal is null then 'Exempt'

	End
	 TaxGroup,
	Obs_HIA Notes,
	(
		Case Num_Proc_MIA
			when  'JOB' then ''
			else num_proc_MIA
		end
	)
	 Num_PRoc_MAster,
	


	
	(
		CASE DC_hia 
				When 'D' then CC_Custo
				When 'C' then CC_Receita
		End	
	) Account_Number,
	1 Invoicing
	
	
	
 From vwcta_cte I WITH(NOLOCK)
 Join Base_nota_fiscal nf WITH(NOLOCK) on nf.nota_fiscal=num_nf_hia and ref_acesso=ref_acesso_NF_hia
 Join House_imp_AER Hou WITH(NOLOCK) on hou.num_proc_HIA=I.num_proc_hia
 Join Job_Imp_AER Job WITH(NOLOCK) on Job.Num_Proc_HIA=Hou.Num_Proc_HIA 
 Left Join Usuario US WITH(NOLOCK) on US.Cd_Usuario = Job.cd_usuario 
-- Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = CONVERT(varchar(10),FatDtEmissao,103)
 Join Tipo_Taxa TT WITH(NOLOCK) on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
 Left Join Tipo_Taxa_AX WITH(NOLOCK) on Cd_Charge_AX = Cd_AX 
 --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
left  Join Pessoa_llp P WITH(NOLOCK) on p.cd_pes=nf.cd_pes
 Left Join Grupo GRP WITH(NOLOCK) on GRP.Cd_Pes_Grupo = P.Cd_Pes_Grupo 
 Left Join Pessoa_ATL_AX AX WITH(NOLOCK) on AX.Cd_Pes = P.Cd_Pes and Tipo='C'

 Where
	Nota_Fiscal=@Nota_Fiscal and ref_Acesso=@ref_Acesso


Union all

Select 
	'10001' Dimensao_1,
	 AX_GRUPO Dimensao_3,
		'BRSAO' Dimensao_4,
	(
	Case LEFT(i.num_proc_hia,2) 
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		else 999
	
	End
	) Dimensao_2,
	'' Dimensao_5,
	
	'BR1' Dimensao_6,
	Null Dimensao_7,

	
	0,
	I.Num_Proc_HIA Num_Proc,
	
	Isnull(cd_charge_AX,900) Cd_Tp_TX,
	dc_hia DC,
	Vlr_Pgto_NF_HIA Valor,
	'REL'  Moeda,
	HAWB_HEA Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	
		1 Paridade,
	'Ledger' AccountType,
	hou.MAWB_HEA MasterBOLNbr,
	Null MasterBookingNbr,
		Case
		When Nota_Fiscal is not null and ref_acesso<>'B' then 'CUS SER 02'
		When Nota_Fiscal is not null and ref_acesso='B' then 'CUS SER 03'

		When Nota_Fiscal is null then 'Exempt'

	End
	 TaxGroup,
	Obs_HEA Notes,
	(
		Case Num_Proc_MEa
			when  'JOB' then ''
			else num_proc_MEA
		end
	)
	 Num_PRoc_MAster,
	


	
	(
		CASE DC_hia 
				When 'D' then CC_Custo
				When 'C' then CC_Receita
		End	
	) Account_Number,
	1 Invoicing
	
	
	
 From vwcta_cte I WITH(NOLOCK)
 Join Base_nota_fiscal nf WITH(NOLOCK) on nf.nota_fiscal=num_nf_hia and ref_acesso=ref_acesso_NF_hia
 Join House_exp_AER Hou WITH(NOLOCK) on hou.num_proc_HEA=I.num_proc_hia
 Join Job_exp_AER Job WITH(NOLOCK) on Job.Num_Proc_HEA=Hou.Num_Proc_HEA 
 Left Join Usuario US WITH(NOLOCK) on US.Cd_Usuario = Job.cd_usuario 
-- Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = CONVERT(varchar(10),FatDtEmissao,103)
 Join Tipo_Taxa TT WITH(NOLOCK) on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
 Left Join Tipo_Taxa_AX WITH(NOLOCK) on Cd_Charge_AX = Cd_AX 
 --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
left  Join Pessoa_llp P WITH(NOLOCK) on p.cd_pes=nf.cd_pes
 Left Join Grupo GRP WITH(NOLOCK) on GRP.Cd_Pes_Grupo = P.Cd_Pes_Grupo 
 Left Join Pessoa_ATL_AX AX WITH(NOLOCK) on AX.Cd_Pes = P.Cd_Pes and Tipo='C'

 Where
	Nota_Fiscal=@Nota_Fiscal and ref_Acesso=@ref_Acesso
	
	
UNION ALL

Select 
	'10001' Dimensao_1,
	 AX_GRUPO Dimensao_3,
		'BRSAO' Dimensao_4,
	(
	Case LEFT(i.num_proc_hia,2) 
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		else 999
	
	End
	) Dimensao_2,
	'' Dimensao_5,
	
	'BR1' Dimensao_6,
	Null Dimensao_7,

	
	0,
	I.Num_Proc_HIA Num_Proc,
	
	Isnull(cd_charge_AX,900) Cd_Tp_TX,
	dc_hia DC,
	Vlr_Pgto_NF_HIA Valor,
	'REL'  Moeda,
	HAWB_HIO Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	
		1 Paridade,
	'Ledger' AccountType,
	hou.MAWB_HIo MasterBOLNbr,
	Null MasterBookingNbr,
		Case
		When Nota_Fiscal is not null and ref_acesso<>'B' then 'CUS SER 02'
		When Nota_Fiscal is not null and ref_acesso='B' then 'CUS SER 03'

		When Nota_Fiscal is null then 'Exempt'

	End
 TaxGroup,
	Obs_HIo Notes,
	'' Num_PRoc_MAster,
	


	
	(
		CASE DC_hia 
				When 'D' then CC_Custo
				When 'C' then CC_Receita
		End	
	) Account_Number,
	1 Invoicing
	
	
	
 From vwcta_cte I WITH(NOLOCK)
 Join Base_nota_fiscal nf WITH(NOLOCK) on nf.nota_fiscal=num_nf_hia and ref_acesso=ref_acesso_NF_hia
 Join House_imp_OUT Hou WITH(NOLOCK) on hou.num_proc_hiO=I.num_proc_hia
 Join llp_iMP_OUT Job WITH(NOLOCK) on Job.Num_Proc_LIO=Hou.Num_Proc_HIO 
 Left Join Usuario US WITH(NOLOCK) on US.Cd_Usuario = Job.cd_usuario 
-- Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = CONVERT(varchar(10),FatDtEmissao,103)
 Join Tipo_Taxa TT WITH(NOLOCK) on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
 Left Join Tipo_Taxa_AX WITH(NOLOCK) on Cd_Charge_AX = Cd_AX 
 --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
left  Join Pessoa_llp P WITH(NOLOCK) on p.cd_pes=nf.cd_pes
 Left Join Grupo GRP WITH(NOLOCK) on GRP.Cd_Pes_Grupo = P.Cd_Pes_Grupo 
 Left Join Pessoa_ATL_AX AX WITH(NOLOCK) on AX.Cd_Pes = P.Cd_Pes and Tipo='C'

 Where
	Nota_Fiscal=@Nota_Fiscal and ref_Acesso=@ref_Acesso


UNION ALL



Select 
	'10001' Dimensao_1,
	 AX_GRUPO Dimensao_3,
		'BRSAO' Dimensao_4,
	(
	Case LEFT(i.num_proc_hia,2) 
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		else 999
	
	End
	) Dimensao_2,
	'' Dimensao_5,
	
	'BR1' Dimensao_6,
	Null Dimensao_7,

	
	0,
	I.Num_Proc_HIA Num_Proc,
	
	Isnull(cd_charge_AX,900) Cd_Tp_TX,
	dc_hia DC,
	Vlr_Pgto_NF_HIA Valor,
	'REL'  Moeda,
	HAWB_HEO Numero_House,
	US.Email CSREmail ,
	US.Nome_Usuario CSRName,
	
		1 Paridade,
	'Ledger' AccountType,
	hou.MAWB_HEO MasterBOLNbr,
	Null MasterBookingNbr,
		Case
		When Nota_Fiscal is not null and ref_acesso<>'B' then 'CUS SER 02'
		When Nota_Fiscal is not null and ref_acesso='B' then 'CUS SER 03'

		When Nota_Fiscal is null then 'Exempt'

	End
	 TaxGroup,
	Obs_HEO Notes,
	'' Num_PRoc_MAster,
	


	
	(
		CASE DC_hia 
				When 'D' then CC_Custo
				When 'C' then CC_Receita
		End	
	) Account_Number,
	1 Invoicing
	
	
	
 From vwcta_cte I WITH(NOLOCK)
 Join Base_nota_fiscal nf WITH(NOLOCK) on nf.nota_fiscal=num_nf_hia and ref_acesso=ref_acesso_NF_hia
 Join House_EXP_OUT Hou WITH(NOLOCK) on hou.num_proc_HEO=I.num_proc_hia
 Join llp_EXP_OUT Job WITH(NOLOCK) on Job.Num_Proc_LEO=Hou.Num_Proc_HEO 
 Left Join Usuario US WITH(NOLOCK) on US.Cd_Usuario = Job.cd_usuario 
-- Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = CONVERT(varchar(10),FatDtEmissao,103)
 Join Tipo_Taxa TT WITH(NOLOCK) on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
 Left Join Tipo_Taxa_AX WITH(NOLOCK) on Cd_Charge_AX = Cd_AX 
 --Join AX_Doc AX on AX.Invoice_Number = F.FAtcod
left  Join Pessoa_llp P WITH(NOLOCK) on p.cd_pes=nf.cd_pes
 Left Join Grupo GRP WITH(NOLOCK) on GRP.Cd_Pes_Grupo = P.Cd_Pes_Grupo 
 Left Join Pessoa_ATL_AX AX WITH(NOLOCK) on AX.Cd_Pes = P.Cd_Pes and Tipo='C'

 Where
	Nota_Fiscal=@Nota_Fiscal and ref_Acesso=@ref_Acesso

GO
