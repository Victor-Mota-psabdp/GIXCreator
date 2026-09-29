SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_TipoLancamentoRF_Sel]
@cd_tipo_Lanc  varchar(1),
@Descricao_Tp_Lancamento varchar(40),
@Tipo char(1)
as

if @Tipo = 'A'
	Begin
		if @cd_tipo_Lanc  <> '' or @cd_tipo_Lanc  is not NULL
			Begin
				select cd_tipo_Lanc , Descricao_Tp_Lancamento from dbo.Tipo_Lancamento_RF
				where cd_tipo_Lanc  = @cd_tipo_Lanc  
			End
		else
			Begin
				select cd_tipo_Lanc, Descricao_Tp_Lancamento from dbo.Tipo_Lancamento_RF
				where Descricao_Tp_Lancamento = @Descricao_Tp_Lancamento
			End
	End
else if @Tipo = 'B' 
	Begin
		if @cd_tipo_Lanc <> '' or @cd_tipo_Lanc is not NULL
			Begin
				select cd_tipo_Lanc, Descricao_Tp_Lancamento from dbo.Tipo_Lancamento_RF
				where cd_tipo_Lanc = @cd_tipo_Lanc and Ativo = 'S'
			End
		else
			Begin
				select cd_tipo_Lanc, Descricao_Tp_Lancamento from dbo.Tipo_Lancamento_RF
				where Descricao_Tp_Lancamento = @Descricao_Tp_Lancamento and Ativo = 'S'
			End	
	End


GO
