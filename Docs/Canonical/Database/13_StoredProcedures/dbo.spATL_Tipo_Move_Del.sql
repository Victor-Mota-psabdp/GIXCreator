SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Move
CREATE procedure [dbo].[spATL_Tipo_Move_Del]
(
	@Cd_Tp_Move varchar(2)
)
as
	UPDATE Tipo_Move SET Status= 0 where Cd_Tp_Move= @Cd_Tp_Move

GO
