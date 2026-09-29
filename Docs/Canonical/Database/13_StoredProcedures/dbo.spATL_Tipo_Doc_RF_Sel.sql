SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_Tipo_Doc_RF_Sel]
@cd_tipo_doc_RF  varchar(1),
@Descricao_tp_doc varchar(40),
@Tipo char(1)
as

if @Tipo = 'A'
	Begin
		if @cd_tipo_doc_RF  <> '' or @cd_tipo_doc_RF  is not NULL
			Begin
				select cd_tipo_doc_RF , Descricao_tp_doc from dbo.Tipo_Doc_RF
				where cd_tipo_doc_RF  = @cd_tipo_doc_RF 
			End
		else
			Begin
				select cd_tipo_doc_RF, Descricao_tp_doc from dbo.Tipo_Doc_RF
				where Descricao_tp_doc = @Descricao_tp_doc
			End
	End
else if @Tipo = 'B' 
	Begin
		if @cd_tipo_doc_RF <> '' or @cd_tipo_doc_RF is not NULL
			Begin
				select cd_tipo_doc_RF, Descricao_tp_doc from dbo.Tipo_Doc_RF
				where cd_tipo_doc_RF = @cd_tipo_doc_RF and Ativo = 'S'
			End
		else
			Begin
				select cd_tipo_doc_RF, Descricao_tp_doc from dbo.Tipo_Doc_RF
				where Descricao_tp_doc = @Descricao_tp_doc and Ativo = 'S'
			End	
	End


GO
