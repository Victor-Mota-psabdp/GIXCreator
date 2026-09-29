SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Taxa
CREATE procedure [dbo].[spATL_Tipo_Taxa_Del]
(
	@Cd_Tp_Tx		varchar(3)
)
as
	update Tipo_Taxa set Desat_Tx = 'S' where Cd_Tp_Tx= @Cd_Tp_Tx

GO
