SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_De_Para
CREATE procedure [dbo].[spATL_Tipo_De_Para_Del]
(
	@Cd_Tipo int
)
as
	UPDATE Tipo_De_Para SET ATIVO= 0 where Cd_Tipo= @Cd_Tipo

GO
