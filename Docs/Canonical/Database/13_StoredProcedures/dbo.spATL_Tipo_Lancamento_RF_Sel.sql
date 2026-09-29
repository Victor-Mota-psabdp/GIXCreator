SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Lancamento_RF
CREATE procedure [dbo].[spATL_Tipo_Lancamento_RF_Sel]--'CSR','Faturamento','z'
(
	@Cd_Tipo_Lanc				varchar(1),
	@Descricao_Tp_Lancamento	varchar(30),
	@Tipo char(1)
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
			Cd_Tipo_Lanc			[Code],
			Descricao_Tp_Lancamento	[Register Type],
			Ativo				[Enabled] 
		from 
			Tipo_Lancamento_RF with(nolock)
	End
	
if  @Tipo = 'B'
	Begin
		select 
			Cd_Tipo_Lanc			[Code],
			Descricao_Tp_Lancamento	[Register Type],
			Ativo				[Enabled] 
		from 
			Tipo_Lancamento_RF with(nolock)
		where 
			Ativo ='S'
	End

if @Tipo = 'C' 
	Begin
		select 
			Cd_Tipo_Lanc			[Code],
			Descricao_Tp_Lancamento	[Register Type],
			Ativo				[Enabled] 
		from 
			Tipo_Lancamento_RF with(nolock)
		where 
			Cd_Tipo_Lanc = @Cd_Tipo_Lanc
	End
if @Tipo = 'D'
	Begin
		select 
			Cd_Tipo_Lanc			[Code],
			Descricao_Tp_Lancamento	[Register Type],
			Ativo				[Enabled] 
		from 
			Tipo_Lancamento_RF with(nolock)
		where 
			Cd_Tipo_Lanc = @Cd_Tipo_Lanc AND Ativo ='S'
	End
if @Tipo = 'N' 
	Begin
		select 
			Cd_Tipo_Lanc			[Code],
			Descricao_Tp_Lancamento	[Register Type],
			Ativo				[Enabled] 
		from 
			Tipo_Lancamento_RF with(nolock)
		where 
			Descricao_Tp_Lancamento = @Descricao_Tp_Lancamento
	End

if  @Tipo = 'O'
	Begin
		select 
			Cd_Tipo_Lanc			[Code],
			Descricao_Tp_Lancamento	[Register Type],
			Ativo				[Enabled] 
		from 
			Tipo_Lancamento_RF with(nolock)
		where 
			Descricao_Tp_Lancamento = @Descricao_Tp_Lancamento 
			AND Ativo ='S'
	End
	
if @Tipo = 'Z'-- or @Tipo = 'O'
	Begin
		select 
			Cd_Tipo_Lanc			[Code],
			Descricao_Tp_Lancamento	[Register Type],
			Ativo				[Enabled] 
		from 
			Tipo_Lancamento_RF with(nolock)
		where 
			Descricao_Tp_Lancamento = @Descricao_Tp_Lancamento
			 and Cd_Tipo_Lanc <> @Cd_Tipo_Lanc		
	End

GO
