SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Terminal
CREATE procedure [dbo].[spATL_Terminal_Del]
(
	@cd_terminal varchar(3)
)
as
	UPDATE Terminal SET ATIVO = 0 where Cd_Terminal= @Cd_Terminal

GO
