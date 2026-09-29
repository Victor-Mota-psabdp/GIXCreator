SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Sol_Pgto_Cta_Cte
CREATE PROCEDURE [dbo].[spATL_Sol_Pgto_Cta_Cte_Sel]
(
	@ID			bigint,
	@Doc_Number varchar(60),
	@Tipo		char(1)
)
AS

	if @tipo = 'A' or @Tipo = 'B'
		BEGIN
			Select 
				SOL.ID					[Code],
				SOL.Cd_Cred_Dev			[Client Code],
				Client.Apelido			[Client Name],
				SOL.Dt_Pgto_Rcto		[Payment Date],
				SOL.Vlr_Doc				[Value],
				SOL.Dt_Vcto				[Due Date],			
				SOL.Cd_Tp_Doc			[Method Type Code],
				DOC.Nome_Tp_Doc			[Method Type Name],
		SOL.Cd_Solicitante		[Requester Code],
		Requester.Nome_Usuario	[Requester Name],
		SOL.Cd_Gerente			[Manager Code],
		Manager.Nome_Usuario	[Manager Name],
		SOL.Cd_Diretor			[Director Code],	
		Director.Nome_Usuario	[Director Name],
				SOL.Dt_Ins				[Insert Date],
				(CASE	WHEN (SOL.Status_Aprovacao IS NULL or SOL.Status_Aprovacao = 'C') AND SOL.Status = 1 THEN 'Created' 
						WHEN (SOL.Status_Aprovacao IS NULL or SOL.Status_Aprovacao = 'C') AND SOL.Status = 0 THEN 'Canceled' 
						WHEN SOL.Status_Aprovacao = 'A' AND SOL.Status = 1 THEN 'Approved'
						WHEN SOL.Status_Aprovacao = 'A' AND SOL.Status = 0 THEN 'Canceled' 
						WHEN (SOL.Status_Aprovacao = 'D' Or SOL.Status_Aprovacao = 'E')
						AND SOL.Status = 1 or SOL.Status = 0 THEN 'Rejected' END) AS [Status], 

				SOL.Status				[Enabled],
				SOL.Status_Aprovacao	[Approval Status],
				SOL.Dt_Aprovacao		[Approval Date],
				SOL.Doc_Register		[Doc Register?],
				SOL.Mes					[Month],
				SOL.Ano					[Year],
				SOL.Num_Registro		[Register Number],
				SOL.Dt_IssueDate		[Register Issue Date],
				SOL.cd_Tipo_Lanc			[Register Type Code],
				TRF.Descricao_Tp_lancamento [Register Type Name], 
				SOL.Isento				[Exempt],
				SOL.Cd_Tp_Moeda			[Currency Code],
				Currency.Nome_Tp_Moeda	[Currency Name],
				SOL.Par_Moeda			[Exchange Rates],
				SOL.Cd_Regra			[Type Adm or Oper], 
				SOL.cd_Tp_fatura		[Type Normal or Electronic], 
				SOL.Cd_Tp_doc			[Type Doc Code],
				DRF.Descricao_Tp_Doc 	[Type Doc Name],
				SOL.Doc_Number			[Doc Number],
				SOL.Total				[Total],
				SOL.IVA_Retencoes		[IVA],
				SOL.Total_Doc			[Total Doc],
				SOL.Cd_pes_seguro		[Customer Code], 
				sg.Apelido 				[Customer Name],
				SOL.NUM_CNPJ_Seguro		[Customer Number],
				SOL.Valor_Total_Moeda_Local	[Valor_Total_Moeda_Local],
				SOL.Habilita_Impostos	[Enabled Taxes],			
				SOL.Ref_Acesso			[Invoice Type Code],
				SI.Nome_Site			[Invoice Type Name],			
				SOL.cd_servico			[Service Code],
				SOL.Item_lei			[Item Lei],
				S.Descricao				[Service Description],
				(convert(varchar(50),S.cd_servico) + ' - ' + S.Item_lei + ' - ' + S.Descricao) [Service Full Name],
				SOL.InfBanco			[Bank Info]
			From Sol_Pgto_Cta_Cte SOL
				Left Join Pessoa				Client				with(nolock)	on Client.Cd_pes		= SOL.Cd_Cred_Dev 
				Left Join Tipo_Documento		Doc					with(nolock)	on Doc.Cd_Tp_Doc		= SOL.Cd_Tp_Doc
				Left Join Usuario				Requester			with(nolock)	on Requester.cd_usuario = SOL.Cd_Solicitante
				Left Join Usuario				Manager				with(nolock)	on Manager.cd_usuario	= SOL.Cd_Gerente
				Left Join Usuario				Director			with(nolock)	on Director.cd_usuario	= SOL.Cd_Diretor
				Left Join Tipo_Moeda			Currency			with(nolock)	on Currency.Cd_tp_Moeda	= SOL.Cd_tp_Moeda
				left join Tipo_Lancamento_RF	TRF					with(nolock)	on TRF.Cd_Tipo_Lanc		= SOL.Cd_Tipo_Lanc
				left join Tipo_Doc_RF			DRF					with(nolock)	on DRF.Cd_Tipo_Doc_RF	= SOL.Cd_Tp_doc
				Left Join Pessoa				SG					with(nolock)	on SG.cd_pes			= Cd_pes_seguro
				left Join Site					SI					with(nolock)	on SI.Cd_Site			= SOL.Ref_Acesso
				left join Tipo_NF_Doc_Register	S					with(nolock)	on S.cd_servico			= SOL.cd_servico and S.Item_lei = SOL.Item_lei			
			Where
				SOL.ID = @ID				
		END

	if @tipo = 'C' or @Tipo = 'D'
	BEGIN
		Select 
			SOL.ID					[Code],
			SOL.Cd_Cred_Dev			[Client Code],
			Client.Apelido			[Client Name],
			SOL.Dt_Pgto_Rcto		[Payment Date],
			SOL.Vlr_Doc				[Value],
			SOL.Dt_Vcto				[Due Date],			
			SOL.Cd_Tp_Doc			[Method Type Code],
			DOC.Nome_Tp_Doc			[Method Type Name],
		SOL.Cd_Solicitante		[Requester Code],
		Requester.Nome_Usuario	[Requester Name],
		SOL.Cd_Gerente			[Manager Code],
		Manager.Nome_Usuario	[Manager Name],
		SOL.Cd_Diretor			[Director Code],	
		Director.Nome_Usuario	[Director Name],
			SOL.Dt_Ins				[Insert Date],
			(CASE	WHEN (SOL.Status_Aprovacao IS NULL or SOL.Status_Aprovacao = 'C') AND SOL.Status = 1 THEN 'Created' 
						WHEN (SOL.Status_Aprovacao IS NULL or SOL.Status_Aprovacao = 'C') AND SOL.Status = 0 THEN 'Canceled' 
						WHEN SOL.Status_Aprovacao = 'A' AND SOL.Status = 1 THEN 'Approved'
						WHEN SOL.Status_Aprovacao = 'A' AND SOL.Status = 0 THEN 'Canceled' 
						WHEN (SOL.Status_Aprovacao = 'D' Or SOL.Status_Aprovacao = 'E')
						AND SOL.Status = 1 or SOL.Status = 0 THEN 'Rejected' END) AS [Status], 

			SOL.Status				[Enabled],
			SOL.Status_Aprovacao	[Approval Status],
			SOL.Dt_Aprovacao		[Approval Date],
			SOL.Doc_Register		[Doc Register?],
			SOL.Mes					[Month],
			SOL.Ano					[Year],
			SOL.Num_Registro		[Register Number],
			SOL.Dt_IssueDate		[Register Issue Date],
			SOL.cd_Tipo_Lanc			[Register Type Code],
			TRF.Descricao_Tp_lancamento [Register Type Name], 
			SOL.Isento				[Exempt],
			SOL.Cd_Tp_Moeda			[Currency Code],
			Currency.Nome_Tp_Moeda	[Currency Name],
			SOL.Par_Moeda			[Exchange Rates],
			SOL.Cd_Regra			[Type Adm or Oper], 
			SOL.cd_Tp_fatura		[Type Normal or Electronic], 
			SOL.Cd_Tp_doc			[Type Doc Code],
			DRF.Descricao_Tp_Doc 	[Type Doc Name],
			SOL.Doc_Number			[Doc Number],
			SOL.Total				[Total],
			SOL.IVA_Retencoes		[IVA],
			SOL.Total_Doc			[Total Doc],
			SOL.Cd_pes_seguro		[Customer Code], 
			sg.Apelido 				[Customer Name],
			SOL.NUM_CNPJ_Seguro		[Customer Number],
			SOL.Valor_Total_Moeda_Local	[Valor_Total_Moeda_Local],
			SOL.Habilita_Impostos	[Enabled Taxes],			
			SOL.Ref_Acesso			[Invoice Type Code],
			SI.Nome_Site			[Invoice Type Name],			
			SOL.cd_servico			[Service Code],
			SOL.Item_lei			[Item Lei],
			S.Descricao				[Service Description],
			(convert(varchar(50),S.cd_servico) + ' - ' + S.Item_lei + ' - ' + S.Descricao) [Service Full Name],
			SOL.InfBanco			[Bank Info]
		From Sol_Pgto_Cta_Cte SOL
			Left Join Pessoa				Client				with(nolock)	on Client.Cd_pes		= SOL.Cd_Cred_Dev 
			Left Join Tipo_Documento		Doc					with(nolock)	on Doc.Cd_Tp_Doc		= SOL.Cd_Tp_Doc
			Left Join Usuario				Requester			with(nolock)	on Requester.cd_usuario = SOL.Cd_Solicitante
			Left Join Usuario				Manager				with(nolock)	on Manager.cd_usuario	= SOL.Cd_Gerente
			Left Join Usuario				Director			with(nolock)	on Director.cd_usuario	= SOL.Cd_Diretor
			Left Join Tipo_Moeda			Currency			with(nolock)	on Currency.Cd_tp_Moeda	= SOL.Cd_tp_Moeda
			left join Tipo_Lancamento_RF	TRF					with(nolock)	on TRF.Cd_Tipo_Lanc		= SOL.Cd_Tipo_Lanc
			left join Tipo_Doc_RF			DRF					with(nolock)	on DRF.Cd_Tipo_Doc_RF	= SOL.Cd_Tp_doc
			Left Join Pessoa				SG					with(nolock)	on SG.cd_pes			= Cd_pes_seguro
			left Join Site					SI					with(nolock)	on SI.Cd_Site			= SOL.Ref_Acesso
			left join Tipo_NF_Doc_Register	S					with(nolock)	on S.cd_servico			= SOL.cd_servico and S.Item_lei = SOL.Item_lei			
		Where
			SOL.ID = @ID
	END

	if @tipo = 'N' or @Tipo = 'O'
	BEGIN
		Select 
			SOL.ID					[Code],
			SOL.Cd_Cred_Dev			[Client Code],
			Client.Apelido			[Client Name],
			SOL.Dt_Pgto_Rcto		[Payment Date],
			SOL.Vlr_Doc				[Value],
			SOL.Dt_Vcto				[Due Date],			
			SOL.Cd_Tp_Doc			[Method Type Code],
			DOC.Nome_Tp_Doc			[Method Type Name],
		SOL.Cd_Solicitante		[Requester Code],
		Requester.Nome_Usuario	[Requester Name],
		SOL.Cd_Gerente			[Manager Code],
		Manager.Nome_Usuario	[Manager Name],
		SOL.Cd_Diretor			[Director Code],	
		Director.Nome_Usuario	[Director Name],
			SOL.Dt_Ins				[Insert Date],
			(CASE	WHEN (SOL.Status_Aprovacao IS NULL or SOL.Status_Aprovacao = 'C') AND SOL.Status = 1 THEN 'Created' 
						WHEN (SOL.Status_Aprovacao IS NULL or SOL.Status_Aprovacao = 'C') AND SOL.Status = 0 THEN 'Canceled' 
						WHEN SOL.Status_Aprovacao = 'A' AND SOL.Status = 1 THEN 'Approved'
						WHEN SOL.Status_Aprovacao = 'A' AND SOL.Status = 0 THEN 'Canceled' 
						WHEN (SOL.Status_Aprovacao = 'D' Or SOL.Status_Aprovacao = 'E')
						AND SOL.Status = 1 or SOL.Status = 0 THEN 'Rejected' END) AS [Status], 

			SOL.Status				[Enabled],
			SOL.Status_Aprovacao	[Approval Status],
			SOL.Dt_Aprovacao		[Approval Date],
			SOL.Doc_Register		[Doc Register?],
			SOL.Mes					[Month],
			SOL.Ano					[Year],
			SOL.Num_Registro		[Register Number],
			SOL.Dt_IssueDate		[Register Issue Date],
			SOL.cd_Tipo_Lanc			[Register Type Code],
			TRF.Descricao_Tp_lancamento [Register Type Name], 
			SOL.Isento				[Exempt],
			SOL.Cd_Tp_Moeda			[Currency Code],
			Currency.Nome_Tp_Moeda	[Currency Name],
			SOL.Par_Moeda			[Exchange Rates],
			SOL.Cd_Regra			[Type Adm or Oper], 
			SOL.cd_Tp_fatura		[Type Normal or Electronic], 
			SOL.Cd_Tp_doc			[Type Doc Code],
			DRF.Descricao_Tp_Doc 	[Type Doc Name],
			SOL.Doc_Number			[Doc Number],
			SOL.Total				[Total],
			SOL.IVA_Retencoes		[IVA],
			SOL.Total_Doc			[Total Doc],
			SOL.Cd_pes_seguro		[Customer Code], 
			sg.Apelido 				[Customer Name],
			SOL.NUM_CNPJ_Seguro		[Customer Number],
			SOL.Valor_Total_Moeda_Local	[Valor_Total_Moeda_Local],
			SOL.Habilita_Impostos	[Enabled Taxes],			
			SOL.Ref_Acesso			[Invoice Type Code],
			SI.Nome_Site			[Invoice Type Name],			
			SOL.cd_servico			[Service Code],
			SOL.Item_lei			[Item Lei],
			S.Descricao				[Service Description],
			(convert(varchar(50),S.cd_servico) + ' - ' + S.Item_lei + ' - ' + S.Descricao) [Service Full Name],
			SOL.InfBanco			[Bank Info]
		From Sol_Pgto_Cta_Cte SOL
			Left Join Pessoa				Client				with(nolock)	on Client.Cd_pes		= SOL.Cd_Cred_Dev 
			Left Join Tipo_Documento		Doc					with(nolock)	on Doc.Cd_Tp_Doc		= SOL.Cd_Tp_Doc
			Left Join Usuario				Requester			with(nolock)	on Requester.cd_usuario = SOL.Cd_Solicitante
			Left Join Usuario				Manager				with(nolock)	on Manager.cd_usuario	= SOL.Cd_Gerente
			Left Join Usuario				Director			with(nolock)	on Director.cd_usuario	= SOL.Cd_Diretor
			Left Join Tipo_Moeda			Currency			with(nolock)	on Currency.Cd_tp_Moeda	= SOL.Cd_tp_Moeda
			left join Tipo_Lancamento_RF	TRF					with(nolock)	on TRF.Cd_Tipo_Lanc		= SOL.Cd_Tipo_Lanc
			left join Tipo_Doc_RF			DRF					with(nolock)	on DRF.Cd_Tipo_Doc_RF	= SOL.Cd_Tp_doc
			Left Join Pessoa				SG					with(nolock)	on SG.cd_pes			= Cd_pes_seguro
			left Join Site					SI					with(nolock)	on SI.Cd_Site			= SOL.Ref_Acesso
			left join Tipo_NF_Doc_Register	S					with(nolock)	on S.cd_servico			= SOL.cd_servico and S.Item_lei = SOL.Item_lei			
		Where
			SOL.ID = @ID
	END


	if @tipo = 'P'
	BEGIN
		Select 
			SOL.ID					[Code],
			SOL.Cd_Cred_Dev			[Client Code],
			Client.Apelido			[Client Name],
			SOL.Dt_Pgto_Rcto		[Payment Date],
			SOL.Vlr_Doc				[Value],
			SOL.Dt_Vcto				[Due Date],			
			SOL.Cd_Tp_Doc			[Method Type Code],
			DOC.Nome_Tp_Doc			[Method Type Name],
		SOL.Cd_Solicitante		[Requester Code],
		Requester.Nome_Usuario	[Requester Name],
		SOL.Cd_Gerente			[Manager Code],
		Manager.Nome_Usuario	[Manager Name],
		SOL.Cd_Diretor			[Director Code],	
		Director.Nome_Usuario	[Director Name],
			SOL.Dt_Ins				[Insert Date],
			(CASE	WHEN (SOL.Status_Aprovacao IS NULL or SOL.Status_Aprovacao = 'C') AND SOL.Status = 1 THEN 'Created' 
						WHEN (SOL.Status_Aprovacao IS NULL or SOL.Status_Aprovacao = 'C') AND SOL.Status = 0 THEN 'Canceled' 
						WHEN SOL.Status_Aprovacao = 'A' AND SOL.Status = 1 THEN 'Approved'
						WHEN SOL.Status_Aprovacao = 'A' AND SOL.Status = 0 THEN 'Canceled' 
						WHEN (SOL.Status_Aprovacao = 'D' Or SOL.Status_Aprovacao = 'E')
						AND SOL.Status = 1 or SOL.Status = 0 THEN 'Rejected' END) AS [Status], 

			SOL.Status				[Enabled],
			SOL.Status_Aprovacao	[Approval Status],
			SOL.Dt_Aprovacao		[Approval Date],
			SOL.Doc_Register		[Doc Register?],
			SOL.Mes					[Month],
			SOL.Ano					[Year],
			SOL.Num_Registro		[Register Number],
			SOL.Dt_IssueDate		[Register Issue Date],
			SOL.cd_Tipo_Lanc			[Register Type Code],
			TRF.Descricao_Tp_lancamento [Register Type Name], 
			SOL.Isento				[Exempt],
			SOL.Cd_Tp_Moeda			[Currency Code],
			Currency.Nome_Tp_Moeda	[Currency Name],
			SOL.Par_Moeda			[Exchange Rates],
			SOL.Cd_Regra			[Type Adm or Oper], 
			SOL.cd_Tp_fatura		[Type Normal or Electronic], 
			SOL.Cd_Tp_doc			[Type Doc Code],
			DRF.Descricao_Tp_Doc 	[Type Doc Name],
			SOL.Doc_Number			[Doc Number],
			SOL.Total				[Total],
			SOL.IVA_Retencoes		[IVA],
			SOL.Total_Doc			[Total Doc],
			SOL.Cd_pes_seguro		[Customer Code], 
			sg.Apelido 				[Customer Name],
			SOL.NUM_CNPJ_Seguro		[Customer Number],
			SOL.Valor_Total_Moeda_Local	[Valor_Total_Moeda_Local],
			SOL.Habilita_Impostos	[Enabled Taxes],			
			SOL.Ref_Acesso			[Invoice Type Code],
			SI.Nome_Site			[Invoice Type Name],			
			SOL.cd_servico			[Service Code],
			SOL.Item_lei			[Item Lei],
			S.Descricao				[Service Description],
			(convert(varchar(50),S.cd_servico) + ' - ' + S.Item_lei + ' - ' + S.Descricao) [Service Full Name],
			SOL.InfBanco			[Bank Info]
		From Sol_Pgto_Cta_Cte SOL
			Left Join Pessoa				Client				with(nolock)	on Client.Cd_pes		= SOL.Cd_Cred_Dev 
			Left Join Tipo_Documento		Doc					with(nolock)	on Doc.Cd_Tp_Doc		= SOL.Cd_Tp_Doc
			Left Join Usuario				Requester			with(nolock)	on Requester.cd_usuario = SOL.Cd_Solicitante
			Left Join Usuario				Manager				with(nolock)	on Manager.cd_usuario	= SOL.Cd_Gerente
			Left Join Usuario				Director			with(nolock)	on Director.cd_usuario	= SOL.Cd_Diretor
			Left Join Tipo_Moeda			Currency			with(nolock)	on Currency.Cd_tp_Moeda	= SOL.Cd_tp_Moeda
			left join Tipo_Lancamento_RF	TRF					with(nolock)	on TRF.Cd_Tipo_Lanc		= SOL.Cd_Tipo_Lanc
			left join Tipo_Doc_RF			DRF					with(nolock)	on DRF.Cd_Tipo_Doc_RF	= SOL.Cd_Tp_doc
			Left Join Pessoa				SG					with(nolock)	on SG.cd_pes			= Cd_pes_seguro
			left Join Site					SI					with(nolock)	on SI.Cd_Site			= SOL.Ref_Acesso
			left join Tipo_NF_Doc_Register	S					with(nolock)	on S.cd_servico			= SOL.cd_servico and S.Item_lei = SOL.Item_lei			
		Where
			SOL.Doc_Number = @Doc_Number and SOL.Status_Aprovacao <> 'A' and SOL.Status = 1
	END

--spATL_SeExiste_DocNumber_Sel	


GO
