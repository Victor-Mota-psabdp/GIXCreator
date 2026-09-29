SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spRecibo_New_Rel] --19

	@ID bigint 

AS
	select 
		ID,
		HOU.Num_Proc_Hem [Num_Proc],
		CONVERT(varchar,Dt_Recibo,103)Dt_Recibo,
		Total,
		HOU.MAWB_Hem MASTER,
		HOU.HAWB_Hem HOUSE,
		P.Apelido,
		EPT.Nome_Raz_Soc,
		EPT.Num_CPF_CNPJ EXP_CNPJ,
		EPT.Num_RG_IE EXP_IE,
		EDR.Rua EXP_Rua,   
		EDR.Numero	EXP_Numero,
		EDR.Bairro	EXP_Bairro,
		EDR.Cidade	EXP_Cidade,
		EDR.UF		EXP_UF,
		'Maritimo'		Tipo_Frete,
		dbo.fBusca_Docs_PO_Modal(REC.Num_Proc,'1') PO,
		dbo.fBusca_Docs_PO_Modal(REC.Num_Proc,'9') [Customer PO]
	from Recibo REC With(nolock)
	join house_exp_mar HOU With(nolock) on REC.Num_Proc = HOU.Num_proc_hem
	left outer join Pessoa P With(nolock) on REC.Cd_Cred_Dev = P.cd_pes
	left outer join Pessoa EPT With(nolock) on REC.Cd_Cred_Dev = EPT.cd_pes
	left outer join Endereco EDR With(nolock) on REC.Cd_Cred_Dev = EDR.cd_pes and cd_tp_end = 'COM'
	where
		REC.ID = @ID
	
Union All

	select 
		ID,
		HOU.Num_Proc_HIM [Num_Proc],
		CONVERT(varchar,Dt_Recibo,103)Dt_Recibo,
		Total,
		HOU.MAWB_HIM MASTER,
		HOU.HAWB_HIM HOUSE,
		P.Apelido,
		EPT.Nome_Raz_Soc,
		EPT.Num_CPF_CNPJ EXP_CNPJ,
		EPT.Num_RG_IE EXP_IE,
		EDR.Rua EXP_Rua,   
		EDR.Numero	EXP_Numero,
		EDR.Bairro	EXP_Bairro,
		EDR.Cidade	EXP_Cidade,
		EDR.UF		EXP_UF,
		'Maritimo'		Tipo_Frete,
		dbo.fBusca_Docs_PO_Modal(REC.Num_Proc,'1') PO,
		dbo.fBusca_Docs_PO_Modal(REC.Num_Proc,'9') [Customer PO]
	from Recibo REC With(nolock)
	join House_Imp_Mar HOU With(nolock) on REC.Num_Proc = HOU.Num_Proc_HIM
	left outer join Pessoa P With(nolock) on REC.Cd_Cred_Dev = P.cd_pes
	left outer join Pessoa EPT With(nolock) on REC.Cd_Cred_Dev = EPT.cd_pes
	left outer join Endereco EDR With(nolock) on REC.Cd_Cred_Dev = EDR.cd_pes and cd_tp_end = 'COM'
	where
		REC.ID = @ID
		
Union All

	select 
		ID,
		HOU.Num_Proc_HIA [Num_Proc],
		CONVERT(varchar,Dt_Recibo,103)Dt_Recibo,
		Total,
		HOU.MAWB_HIA MASTER,
		HOU.HAWB_HIA HOUSE,
		P.Apelido,
		EPT.Nome_Raz_Soc,
		EPT.Num_CPF_CNPJ EXP_CNPJ,
		EPT.Num_RG_IE EXP_IE,
		EDR.Rua EXP_Rua,   
		EDR.Numero	EXP_Numero,
		EDR.Bairro	EXP_Bairro,
		EDR.Cidade	EXP_Cidade,
		EDR.UF		EXP_UF,
		'Aéreo'		Tipo_Frete,
		dbo.fBusca_Docs_PO_Modal(REC.Num_Proc,'1') PO,
		dbo.fBusca_Docs_PO_Modal(REC.Num_Proc,'9') [Customer PO]
	from Recibo REC With(nolock)
	join House_Imp_Aer HOU With(nolock) on REC.Num_Proc = HOU.Num_Proc_HIA
	left outer join Pessoa P With(nolock) on REC.Cd_Cred_Dev = P.cd_pes
	left outer join Pessoa EPT With(nolock) on REC.Cd_Cred_Dev = EPT.cd_pes
	left outer join Endereco EDR With(nolock) on REC.Cd_Cred_Dev = EDR.cd_pes and cd_tp_end = 'COM'
	where
		REC.ID = @ID
		
Union All

	select 
		ID,
		HOU.Num_Proc_Hea [Num_Proc],
		CONVERT(varchar,Dt_Recibo,103)Dt_Recibo,
		Total,
		HOU.MAWB_HEA MASTER,
		HOU.HAWB_HEA HOUSE,
		P.Apelido,
		EPT.Nome_Raz_Soc,
		EPT.Num_CPF_CNPJ EXP_CNPJ,
		EPT.Num_RG_IE EXP_IE,
		EDR.Rua EXP_Rua,   
		EDR.Numero	EXP_Numero,
		EDR.Bairro	EXP_Bairro,
		EDR.Cidade	EXP_Cidade,
		EDR.UF		EXP_UF,
		'Aéreo'		Tipo_Frete,
		dbo.fBusca_Docs_PO_Modal(REC.Num_Proc,'1') PO,
		dbo.fBusca_Docs_PO_Modal(REC.Num_Proc,'9') [Customer PO]
	from Recibo REC With(nolock)
	join House_Exp_Aer HOU With(nolock) on REC.Num_Proc = HOU.Num_Proc_HEA
	left outer join Pessoa P With(nolock) on REC.Cd_Cred_Dev = P.cd_pes
	left outer join Pessoa EPT With(nolock) on REC.Cd_Cred_Dev = EPT.cd_pes
	left outer join Endereco EDR With(nolock) on REC.Cd_Cred_Dev = EDR.cd_pes and cd_tp_end = 'COM'
	where
		REC.ID = @ID
		
Union All

	select 
		ID,
		HOU.Num_Proc_HEO [Num_Proc],
		CONVERT(varchar,Dt_Recibo,103)Dt_Recibo,
		Total,
		HOU.MAWB_HEO MASTER,
		HOU.HAWB_HEO HOUSE,
		P.Apelido,
		EPT.Nome_Raz_Soc,
		EPT.Num_CPF_CNPJ EXP_CNPJ,
		EPT.Num_RG_IE EXP_IE,
		EDR.Rua EXP_Rua,   
		EDR.Numero	EXP_Numero,
		EDR.Bairro	EXP_Bairro,
		EDR.Cidade	EXP_Cidade,
		EDR.UF		EXP_UF,
		LLP.Tipo_Leo	Tipo_Frete,
		dbo.fBusca_Docs_PO_Modal(REC.Num_Proc,'1') PO,
		dbo.fBusca_Docs_PO_Modal(REC.Num_Proc,'9') [Customer PO]
	from Recibo REC With(nolock)
	join House_Exp_Out HOU With(nolock) on REC.Num_Proc = HOU.Num_Proc_HEO
	join llp_exp_out LLP With(nolock) on HOU.Num_proc_heo = LLP.Num_proc_leo
	left outer join Pessoa P With(nolock) on REC.Cd_Cred_Dev = P.cd_pes
	left outer join Pessoa EPT With(nolock) on REC.Cd_Cred_Dev = EPT.cd_pes
	left outer join Endereco EDR With(nolock) on REC.Cd_Cred_Dev = EDR.cd_pes and cd_tp_end = 'COM'
	where
		REC.ID = @ID

Union All

	select 
		ID,
		HOU.Num_Proc_Hio [Num_Proc],
		CONVERT(varchar,Dt_Recibo,103)Dt_Recibo,
		Total,
		HOU.MAWB_HIO MASTER,
		HOU.HAWB_HIO HOUSE,
		P.Apelido,
		EPT.Nome_Raz_Soc,
		EPT.Num_CPF_CNPJ EXP_CNPJ,
		EPT.Num_RG_IE EXP_IE,
		EDR.Rua EXP_Rua,   
		EDR.Numero	EXP_Numero,
		EDR.Bairro	EXP_Bairro,
		EDR.Cidade	EXP_Cidade,
		EDR.UF		EXP_UF,
		LLP.Tipo_Lio	Tipo_Frete,
		dbo.fBusca_Docs_PO_Modal(REC.Num_Proc,'1') PO,
		dbo.fBusca_Docs_PO_Modal(REC.Num_Proc,'9') [Customer PO]
	from Recibo REC With(nolock)
	join House_Imp_Out HOU With(nolock) on REC.Num_Proc = HOU.Num_Proc_HIO
	join LLP_Imp_Out LLP With(nolock) on HOU.Num_Proc_HIO = LLP.Num_Proc_Lio
	left outer join Pessoa P With(nolock) on REC.Cd_Cred_Dev = P.cd_pes
	left outer join Pessoa EPT With(nolock) on REC.Cd_Cred_Dev = EPT.cd_pes
	left outer join Endereco EDR With(nolock) on REC.Cd_Cred_Dev = EDR.cd_pes and cd_tp_end = 'COM'
	where
		REC.ID = @ID
GO
