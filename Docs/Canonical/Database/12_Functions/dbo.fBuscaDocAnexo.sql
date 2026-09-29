SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Function [dbo].[fBuscaDocAnexo]
		(
			@Num_Proc	Varchar(16),
			@ID_DC		Int
		)

returns bit
as
Begin
	if exists(select * from doc_anexos With(nolock) where num_proc=@Num_proc and id_dc=@ID_DC)
		Begin
			Return 1
		End
	Else
		Begin
			Return 0
		End
	Return 0
end

GO
