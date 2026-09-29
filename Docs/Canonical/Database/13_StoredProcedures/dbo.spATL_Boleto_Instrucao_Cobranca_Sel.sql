SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--sp_help Boleto_Instrucao_Cobranca
CREATE procedure [dbo].[spATL_Boleto_Instrucao_Cobranca_Sel]--'','','','A'
(
	@Cd_Instrucao	varchar(2),
	@Nome_Instrucao varchar(100),
	@Cd_Banco		varchar(3),
	@Tipo char(1)
)
as

if @Tipo = 'A' 
	Begin
		select 
			T.Cd_Instrucao		[Code],
			T.Nome_Instrucao	[Instruction Name],
			T.Cd_Banco			[Bank Code],
			B.Nome_Banco		[Bank Name],
			T.Ativo				[Enabled],
			T.Cd_Usuario		[User Code],
			U.Nome_Usuario		[User Name],
			T.dt_ins				[Insert Date]
		from Boleto_Instrucao_Cobranca T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
			join Banco B with(nolock) on B.Cd_Banco=T.Cd_Banco
	End
	
if  @Tipo = 'B'
	Begin
		select 
			T.Cd_Instrucao		[Code],
			T.Nome_Instrucao	[Instruction Name],
			T.Cd_Banco			[Bank Code],
			B.Nome_Banco		[Bank Name],
			T.Ativo				[Enabled],
			T.Cd_Usuario		[User Code],
			U.Nome_Usuario		[User Name],
			T.dt_ins				[Insert Date]
		from Boleto_Instrucao_Cobranca T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
			join Banco B with(nolock) on B.Cd_Banco=T.Cd_Banco
		where
			T.Ativo = 1
	End

if @Tipo = 'C'
	Begin
		select 
			T.Cd_Instrucao		[Code],
			T.Nome_Instrucao	[Instruction Name],
			T.Cd_Banco			[Bank Code],
			B.Nome_Banco		[Bank Name],
			T.Ativo				[Enabled],
			T.Cd_Usuario		[User Code],
			U.Nome_Usuario		[User Name],
			T.dt_ins				[Insert Date]
		from Boleto_Instrucao_Cobranca T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
			join Banco B with(nolock) on B.Cd_Banco=T.Cd_Banco
		where
			T.Cd_Instrucao = @Cd_Instrucao			
	End
	
if @Tipo = 'D'
	Begin
		select 
			T.Cd_Instrucao		[Code],
			T.Nome_Instrucao	[Instruction Name],
			T.Cd_Banco			[Bank Code],
			B.Nome_Banco		[Bank Name],
			T.Ativo				[Enabled],
			T.Cd_Usuario		[User Code],
			U.Nome_Usuario		[User Name],
			T.dt_ins				[Insert Date]
		from Boleto_Instrucao_Cobranca T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
			join Banco B with(nolock) on B.Cd_Banco=T.Cd_Banco
		where
			T.Cd_Instrucao = @Cd_Instrucao
			and T.ativo = 1
	End
	
if @Tipo = 'N'
	Begin
		select 
			T.Cd_Instrucao		[Code],
			T.Nome_Instrucao	[Instruction Name],
			T.Cd_Banco			[Bank Code],
			B.Nome_Banco		[Bank Name],
			T.Ativo				[Enabled],
			T.Cd_Usuario		[User Code],
			U.Nome_Usuario		[User Name],
			T.dt_ins				[Insert Date]
		from Boleto_Instrucao_Cobranca T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
			join Banco B with(nolock) on B.Cd_Banco=T.Cd_Banco	
		where
			T.Nome_Instrucao = @Nome_Instrucao
	End
	
if @Tipo = 'O'
	Begin
		select 
			T.Cd_Instrucao		[Code],
			T.Nome_Instrucao	[Instruction Name],
			T.Cd_Banco			[Bank Code],
			B.Nome_Banco		[Bank Name],
			T.Ativo				[Enabled],
			T.Cd_Usuario		[User Code],
			U.Nome_Usuario		[User Name],
			T.dt_ins				[Insert Date]
		from Boleto_Instrucao_Cobranca T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
			join Banco B with(nolock) on B.Cd_Banco=T.Cd_Banco	
		where
			T.Nome_Instrucao = @Nome_Instrucao
			and T.ativo = 1
	End
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			T.Cd_Instrucao		[Code],
			T.Nome_Instrucao	[Instruction Name],
			T.Cd_Banco			[Bank Code],
			B.Nome_Banco		[Bank Name],
			T.Ativo				[Enabled],
			T.Cd_Usuario		[User Code],
			U.Nome_Usuario		[User Name],
			T.dt_ins				[Insert Date]
		from Boleto_Instrucao_Cobranca T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
			join Banco B with(nolock) on B.Cd_Banco=T.Cd_Banco	
		where
			T.Nome_Instrucao = @Nome_Instrucao		
			AND T.Cd_Instrucao <> isnull(@Cd_Instrucao,0)
	End

if @Tipo = 'P'
	Begin
		select 
			T.Cd_Instrucao		[Code],
			T.Nome_Instrucao	[Instruction Name],
			T.Cd_Banco			[Bank Code],
			B.Nome_Banco		[Bank Name],
			T.Ativo				[Enabled],
			T.Cd_Usuario		[User Code],
			U.Nome_Usuario		[User Name],
			T.dt_ins				[Insert Date]
		from Boleto_Instrucao_Cobranca T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
			join Banco B with(nolock) on B.Cd_Banco=T.Cd_Banco	
		where
			T.Cd_Banco = @Cd_Banco			
	End

GO
