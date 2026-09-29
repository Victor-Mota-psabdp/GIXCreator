SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure spCampoProcesso_Sel
		(
			@Num_Proc	Varchar(16),
			@ID_Campo	Int
		)
AS

select * from campo_processo

where id_campo=@id_Campo and num_proc=@num_proc

GO
