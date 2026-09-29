SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--sp_help Tipo_Documento
CREATE procedure [dbo].[spATL_Tipo_Documento_Del]
(
	@Cd_Tp_Doc		varchar(3)
)
as
	if exists(select Cd_Tp_Doc from Tipo_Documento where Cd_Tp_Doc= @Cd_Tp_Doc) 
		begin
			UPDATE Tipo_Documento SET Status = 'N' where Cd_Tp_Doc= @Cd_Tp_Doc
		end

GO
