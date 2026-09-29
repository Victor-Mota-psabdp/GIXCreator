SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_TipoDocumento_Sel]
@CdTpDoc  varchar(3),
@NomeTpDoc varchar(30),
@Tipo char(1)
as

if @Tipo = 'A'
Begin
	if @CdTpDoc <> '' or @CdTpDoc is not NULL
		Begin
			select Cd_Tp_Doc, Nome_Tp_Doc from Tipo_Documento
			where Cd_Tp_Doc = @CdTpDoc 
		End
	else
		Begin
			select Cd_Tp_Doc, Nome_Tp_Doc from Tipo_Documento
			where Nome_Tp_Doc = @NomeTpDoc
		End
End
else if @Tipo = 'B' 
	Begin
	if @CdTpDoc <> '' or @CdTpDoc is not NULL
		Begin
			select Cd_Tp_Doc, Nome_Tp_Doc from Tipo_Documento
			where Cd_Tp_Doc = @CdTpDoc and [Status] = 1
		End
	else
		Begin
			select Cd_Tp_Doc, Nome_Tp_Doc from Tipo_Documento
			where Nome_Tp_Doc = @NomeTpDoc and [Status] = 1
		End	
	End


GO
