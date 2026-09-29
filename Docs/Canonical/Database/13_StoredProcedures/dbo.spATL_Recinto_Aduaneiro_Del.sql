SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Recinto_Aduaneiro
CREATE procedure [dbo].[spATL_Recinto_Aduaneiro_Del]
(
	@Cd_Recinto varchar(10)
)
as
	if exists(select Cd_Recinto from Recinto_Aduaneiro where Cd_Recinto= @Cd_Recinto)
	begin
		UPDATE Recinto_Aduaneiro SET Ativo= 0 where Cd_Recinto= @Cd_Recinto
	end

GO
