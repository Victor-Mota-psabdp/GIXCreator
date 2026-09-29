SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE pEventoMaster_Ins
(
@Arquivo_EVE			varchar(25),
@Num_Proc			varchar(14)
) 
AS
	If Not Exists (Select Arquivo_EVE From Eventos_Master Where Arquivo_EVE= @Arquivo_EVE and Num_Proc = @Num_Proc)
	Insert Into 
		Eventos_Master
		(Arquivo_EVE, Num_Proc)
	Values 
		(@Arquivo_EVE, @Num_Proc)



GO
