SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Localidade
CREATE procedure [dbo].[spATL_Localidade_Del]
(
	@Cd_Local varchar(3)
)
as
	if exists(select Cd_Local from Localidade where Cd_Local= @Cd_Local) 
	begin
		UPDATE Localidade SET Desat_loc = 'N' where Cd_Local= @Cd_Local
	end

GO
