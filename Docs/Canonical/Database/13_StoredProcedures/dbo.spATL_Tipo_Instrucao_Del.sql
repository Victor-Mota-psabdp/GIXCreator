SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--sp_help Tipo_Instrucao
CREATE procedure [dbo].[spATL_Tipo_Instrucao_Del]
(
	@Cd_Tp_Instrucao varchar(2)
)
as
	UPDATE Tipo_Instrucao SET Status= 0 where Cd_Tp_Instrucao= @Cd_Tp_Instrucao

GO
