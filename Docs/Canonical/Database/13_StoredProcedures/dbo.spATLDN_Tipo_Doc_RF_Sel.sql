SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Doc_RF
CREATE procedure [dbo].[spATLDN_Tipo_Doc_RF_Sel]--'CSR','Faturamento','z'
(
	@Cd_Tipo_Doc_RF		varchar(1),
	@Descricao_Tp_Doc	varchar(50),
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
Z /// Verifica Nome X Codigo

*/

if @Tipo = 'A' 
	Begin
		select 
			Cd_Tipo_Doc_RF		[Code],
			Descricao_Tp_Doc	[Doc Type],
			Ativo				[Enabled],
			Debito				[Debit],
			Credito				[Credit]
		from 
			Tipo_Doc_RF with(nolock)
	End
	
if  @Tipo = 'B'
	Begin
		select 
			Cd_Tipo_Doc_RF		[Code],
			Descricao_Tp_Doc	[Doc Type],
			Ativo				[Enabled],
			Debito				[Debit],
			Credito				[Credit]
		from 
			Tipo_Doc_RF with(nolock)
		where 
			Ativo ='S'
	End

if @Tipo = 'C' 
	Begin
		select 
			Cd_Tipo_Doc_RF		[Code],
			Descricao_Tp_Doc	[Doc Type],
			Ativo				[Enabled],
			Debito				[Debit],
			Credito				[Credit]
		from 
			Tipo_Doc_RF with(nolock)
		where 
			Cd_Tipo_Doc_RF = @Cd_Tipo_Doc_RF
	End
if @Tipo = 'D'
	Begin
		select 
			Cd_Tipo_Doc_RF		[Code],
			Descricao_Tp_Doc	[Doc Type],
			Ativo				[Enabled],
			Debito				[Debit],
			Credito				[Credit]
		from 
			Tipo_Doc_RF with(nolock)
		where 
			Cd_Tipo_Doc_RF = @Cd_Tipo_Doc_RF AND Ativo ='S'
	End
if @Tipo = 'N' 
	Begin
		select 
			Cd_Tipo_Doc_RF		[Code],
			Descricao_Tp_Doc	[Doc Type],
			Ativo				[Enabled],
			Debito				[Debit],
			Credito				[Credit]
		from 
			Tipo_Doc_RF with(nolock)
		where 
			Descricao_Tp_Doc = @Descricao_Tp_Doc
	End

if  @Tipo = 'O'
	Begin
		select 
			Cd_Tipo_Doc_RF		[Code],
			Descricao_Tp_Doc	[Doc Type],
			Ativo				[Enabled],
			Debito				[Debit],
			Credito				[Credit]
		from 
			Tipo_Doc_RF with(nolock)
		where 
			Descricao_Tp_Doc = @Descricao_Tp_Doc 
			AND Ativo ='S'
	End
	
if @Tipo = 'Z'-- or @Tipo = 'O'
	Begin
		select 
			Cd_Tipo_Doc_RF		[Code],
			Descricao_Tp_Doc	[Doc Type],
			Ativo				[Enabled],
			Debito				[Debit],
			Credito				[Credit]
		from 
			Tipo_Doc_RF with(nolock)
		where 
			Descricao_Tp_Doc = @Descricao_Tp_Doc
			 and Cd_Tipo_Doc_RF <> @Cd_Tipo_Doc_RF		
	End

GO
