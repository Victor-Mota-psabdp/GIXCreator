SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[spATL_Termo_Pagamento_Sel]null,'Teste 4','z'

--Alter Table Termo_Pagamento Add [Dt_Ins] Datetime Default getdate()
--alter table Termo_Pagamento add [Ativo] [bit] NULL
--alter table Termo_Pagamento add [Cd_Usuario] [varchar](10) NULL
CREATE procedure [dbo].[spATL_Termo_Pagamento_Sel](
	@Cd_Termo			varchar(10),
	@Descricao_Termo	varchar(200),
	@Tipo				char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
*/

if @Tipo = 'A'
	Begin
		select Cd_Termo AS [Code],Descricao_Termo AS [Type Payments], 
		Dias [Days],Dt_Base [Base Date],
		--Mapa_ATL [ATL Map],
		Dt_Ins [Insert Date],
		Ativo [Enabled],
		T.Cd_Usuario [User Code], 
		U.Nome_Usuario [User Name]
		from Termo_Pagamento T with(nolock)
		left join usuario U with(nolock) on U.Cd_Usuario = T.Cd_Usuario
	End
if @Tipo = 'B'
	Begin
		select Cd_Termo AS [Code],Descricao_Termo AS [Type Payments], 
		Dias [Days],Dt_Base [Base Date],
		--Mapa_ATL [ATL Map],
		Dt_Ins [Insert Date],
		Ativo [Enabled],
		T.Cd_Usuario [User Code], 
		U.Nome_Usuario [User Name]
		from Termo_Pagamento T with(nolock)
		left join usuario U with(nolock) on U.Cd_Usuario = T.Cd_Usuario
		where
			ativo = 1
	End

if @Tipo = 'C'
	Begin
		select Cd_Termo AS [Code],Descricao_Termo AS [Type Payments], 
		Dias [Days],Dt_Base [Base Date],
		--Mapa_ATL [ATL Map],
		Dt_Ins [Insert Date],
		Ativo [Enabled],
		T.Cd_Usuario [User Code], 
		U.Nome_Usuario [User Name]
		from Termo_Pagamento T with(nolock)
		left join usuario U with(nolock) on U.Cd_Usuario = T.Cd_Usuario
		where Cd_Termo = @Cd_Termo
	End
if @Tipo = 'D'
	Begin
		select Cd_Termo AS [Code],Descricao_Termo AS [Type Payments], 
		Dias [Days],Dt_Base [Base Date],
		--Mapa_ATL [ATL Map],
		Dt_Ins [Insert Date],
		Ativo [Enabled],
		T.Cd_Usuario [User Code], 
		U.Nome_Usuario [User Name]
		from Termo_Pagamento T with(nolock)
		left join usuario U with(nolock) on U.Cd_Usuario = T.Cd_Usuario
		where Cd_Termo = @Cd_Termo AND	ativo = 1
	End

if @Tipo = 'N'
	Begin
		select Cd_Termo AS [Code],Descricao_Termo AS [Type Payments], 
		Dias [Days],Dt_Base [Base Date],
		--Mapa_ATL [ATL Map],
		Dt_Ins [Insert Date],
		Ativo [Enabled],
		T.Cd_Usuario [User Code], 
		U.Nome_Usuario [User Name]
		from Termo_Pagamento T with(nolock)
		left join usuario U with(nolock) on U.Cd_Usuario = T.Cd_Usuario
		where Descricao_Termo = @Descricao_Termo
	End
	
if @Tipo = 'O'
	Begin
		select Cd_Termo AS [Code],Descricao_Termo AS [Type Payments], 
		Dias [Days],Dt_Base [Base Date],
		--Mapa_ATL [ATL Map],
		Dt_Ins [Insert Date],
		Ativo [Enabled],
		T.Cd_Usuario [User Code], 
		U.Nome_Usuario [User Name]
		from Termo_Pagamento T with(nolock)
		left join usuario U with(nolock) on U.Cd_Usuario = T.Cd_Usuario
		where Descricao_Termo = @Descricao_Termo AND	ativo = 1
	End

if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select Cd_Termo AS [Code],Descricao_Termo AS [Type Payments], 
		Dias [Days],Dt_Base [Base Date],
		--Mapa_ATL [ATL Map],
		Dt_Ins [Insert Date],
		Ativo [Enabled],
		T.Cd_Usuario [User Code], 
		U.Nome_Usuario [User Name]
		from Termo_Pagamento T with(nolock)
		left join usuario U with(nolock) on U.Cd_Usuario = T.Cd_Usuario
		where Descricao_Termo = @Descricao_Termo 
		AND (Cd_Termo <> isnull(@Cd_Termo,'')) 
	End

GO
