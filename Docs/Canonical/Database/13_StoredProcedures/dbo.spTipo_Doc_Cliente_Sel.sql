SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Doc_Cliente
--select * from Tipo_Doc_Cliente
CREATE procedure [dbo].[spTipo_Doc_Cliente_Sel]
(
	@ID_DC as int,
	@Nome_DC as Varchar(25),
	@Tipo as char
)
as
if @Tipo = 'A'
Begin
	if @ID_DC = '' or @ID_DC is null
		Begin
			
			select right('000' + Convert(varchar(3),ID_DC),3) ID_DC, Nome_DC,
				right('000' + Convert(varchar(3),ID_DC),3) + '-' + Nome_DC AS [Documento]
			from Tipo_Doc_Cliente
			where Nome_DC = @Nome_DC 
		End
	else
		Begin
			select right('000' + Convert(varchar(3),ID_DC),3) ID_DC, Nome_DC ,
				right('000' + Convert(varchar(3),ID_DC),3) + '-' + Nome_DC AS [Documento]
			from Tipo_Doc_Cliente
			where  ID_DC = @ID_DC 
		End
End
If @Tipo = 'B'
	Begin
		if @ID_DC = '' or @ID_DC is null
			Begin
				select right('000' + Convert(varchar(3),ID_DC),3) ID_DC, Nome_DC,
					right('000' + Convert(varchar(3),ID_DC),3) + '-' + Nome_DC AS [Documento]
				from Tipo_Doc_Cliente
				where Nome_DC = @Nome_DC
			End
		else
			Begin
				select right('000' + Convert(varchar(3),ID_DC),3) ID_DC, Nome_DC,
					right('000' + Convert(varchar(3),ID_DC),3) + '-' + Nome_DC AS [Documento] 
				from Tipo_Doc_Cliente
				where  ID_DC = @ID_DC 
			End
	End

GO
