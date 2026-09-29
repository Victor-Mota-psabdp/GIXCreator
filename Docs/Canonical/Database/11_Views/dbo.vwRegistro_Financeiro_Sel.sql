SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwRegistro_Financeiro_Sel]
AS
	select
		RF.ID						[Code],
		RF.Num_Registro				[Register Number],
		RF.Mes						[Month], 
		RF.Ano						[Year],
		RF.cd_pes					[Company Code], 
		P.Apelido					[Company Name], 
		RF.Num_CNPJ					[Company Number],
		TRF.cd_Tipo_Lanc			[Register Type Code],
		TRF.Descricao_Tp_lancamento [Register Type Name], 
		RF.Dt_Ins					[Issue Date], 
		RF.Dt_Venc					[Due Date], 
		RF.Isento					[Exempt],
		RF.Cd_Tp_moeda				[Currency Code],
		TM.Nome_Tp_Moeda			[Currency Name],
		RF.Par_Moeda				[Exchange Rate],
		Cd_Regra					[Type Adm or Oper], 
		cd_Tp_fatura				[Type Normal or Electronic], 
		Rf.Cd_Tp_doc				[Type Doc Code],
		DRF.Descricao_Tp_Doc 		[Type Doc Name],
		RF.Doc_Number				[Doc Number],
		RF.Total					[Total],
		RF.IVA_Retencoes			[IVA],
		RF.Total_Doc				[Total Doc],
		RF.Cd_pes_seguro			[Customer Code], 
		sg.Apelido 					[Customer Name],
		RF.NUM_CNPJ_Seguro			[Customer Number],
		RF.Valor_Total_Moeda_Local	[Valor_Total_Moeda_Local],
		RF.Habilita_Impostos		[Enabled Taxes],
		RF.Ativo					[Enabled],
		RF.Ref_Acesso				[Invoice Type Code],
		SI.Nome_Site					[Invoice Type Name],
		--isnull(Ref_Acesso,'N') Ref_Acesso,
		RF.cd_servico				[Service Code],
		RF.Item_lei					[Item Lei],
		S.Descricao					[Service Description],
		(convert(varchar(50),S.cd_servico) + ' - ' + S.Item_lei + ' - ' + S.Descricao) [Service Full Name]
	from Registro_Financeiro RF
		left join pessoa P					with(nolock) on P.Cd_pes = RF.cd_pes
		left join Tipo_lancamento_RF TRF	with(nolock) on TRF.Cd_Tipo_Lanc = RF.Cd_Tipo_Lanc
		left join Tipo_moeda TM				with(nolock) on TM.CD_Tp_Moeda = RF.Cd_Tp_moeda
		left join Tipo_Doc_RF DRF			with(nolock) on DRF.Cd_Tipo_Doc_RF = Rf.Cd_Tp_doc
		Left Join Pessoa SG					with(nolock) on SG.cd_pes=Cd_pes_seguro
		left Join Site SI					with(nolock) on SI.Cd_Site = RF.Ref_Acesso
		left join Tipo_NF_Doc_Register S	with(nolock) on S.cd_servico = RF.cd_servico and S.Item_lei = RF.Item_lei


GO
