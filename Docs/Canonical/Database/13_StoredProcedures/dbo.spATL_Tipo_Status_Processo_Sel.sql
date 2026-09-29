SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Status_Processo
CREATE procedure [dbo].[spATL_Tipo_Status_Processo_Sel]--'4','','C'
(
	@ID_Status as int,
	@Status_Descricao as Varchar(30),
	@Tipo as char
)
as
if @Tipo = 'A'
	Begin
		select 
			ID_Status			[Code], 
			Status_Descricao	[Status Description],
			Ativo				[Enabled],
			CtaCte_IUD			[CtaCte_IUD],
			Financeiro_IUD		[Financeiro_IUD],
			Faturamento_IUD		[Faturamento_IUD],
			Job_IUD				[Job_IUD],
			Historico_IUD		[Historico_IUD],
			Status_Descricao_Ingles	[Status Description EN],
			Ordem				[Sequence]
		from 
			Tipo_Status_Processo
	End

If @Tipo = 'B'
	Begin
		select 
			ID_Status			[Code], 
			Status_Descricao	[Status Description],
			Ativo				[Enabled],
			CtaCte_IUD			[CtaCte_IUD],
			Financeiro_IUD		[Financeiro_IUD],
			Faturamento_IUD		[Faturamento_IUD],
			Job_IUD				[Job_IUD],
			Historico_IUD		[Historico_IUD],
			Status_Descricao_Ingles	[Status Description EN],
			Ordem				[Sequence]
		from 
			Tipo_Status_Processo
		where
			 ativo = 'S'	
	End

If @Tipo = 'C'
	Begin	
		select 
			ID_Status			[Code], 
			Status_Descricao	[Status Description],
			Ativo				[Enabled],
			CtaCte_IUD			[CtaCte_IUD],
			Financeiro_IUD		[Financeiro_IUD],
			Faturamento_IUD		[Faturamento_IUD],
			Job_IUD				[Job_IUD],
			Historico_IUD		[Historico_IUD],
			Status_Descricao_Ingles	[Status Description EN],
			Ordem				[Sequence]
		from 
			Tipo_Status_Processo
		where
			ID_Status = @ID_Status		
	End
	
If @Tipo = 'D'
	Begin
		select 
			ID_Status			[Code], 
			Status_Descricao	[Status Description],
			Ativo				[Enabled],
			CtaCte_IUD			[CtaCte_IUD],
			Financeiro_IUD		[Financeiro_IUD],
			Faturamento_IUD		[Faturamento_IUD],
			Job_IUD				[Job_IUD],
			Historico_IUD		[Historico_IUD],
			Status_Descricao_Ingles	[Status Description EN],
			Ordem				[Sequence]
		from 
			Tipo_Status_Processo
		where
			ID_Status = @ID_Status	and
			ativo = 'S'			
	End

If @Tipo = 'N'
	Begin	
		select 
			ID_Status			[Code], 
			Status_Descricao	[Status Description],
			Ativo				[Enabled],
			CtaCte_IUD			[CtaCte_IUD],
			Financeiro_IUD		[Financeiro_IUD],
			Faturamento_IUD		[Faturamento_IUD],
			Job_IUD				[Job_IUD],
			Historico_IUD		[Historico_IUD],
			Status_Descricao_Ingles	[Status Description EN],
			Ordem				[Sequence]
		from 
			Tipo_Status_Processo
		where
			Status_Descricao = @Status_Descricao		
	End
	
If @Tipo = 'O'	
	Begin
		select 
			ID_Status			[Code], 
			Status_Descricao	[Status Description],
			Ativo				[Enabled],
			CtaCte_IUD			[CtaCte_IUD],
			Financeiro_IUD		[Financeiro_IUD],
			Faturamento_IUD		[Faturamento_IUD],
			Job_IUD				[Job_IUD],
			Historico_IUD		[Historico_IUD],
			Status_Descricao_Ingles	[Status Description EN],
			Ordem				[Sequence]
		from 
			Tipo_Status_Processo
		where
			Status_Descricao = @Status_Descricao	and
			ativo = 'S'			
	End


if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			ID_Status			[Code], 
			Status_Descricao	[Status Description],
			Ativo				[Enabled],
			CtaCte_IUD			[CtaCte_IUD],
			Financeiro_IUD		[Financeiro_IUD],
			Faturamento_IUD		[Faturamento_IUD],
			Job_IUD				[Job_IUD],
			Historico_IUD		[Historico_IUD],
			Status_Descricao_Ingles	[Status Description EN],
			Ordem				[Sequence]
		from 
			Tipo_Status_Processo
		where
			Status_Descricao = @Status_Descricao and ID_Status <> @ID_Status			
	End

GO
