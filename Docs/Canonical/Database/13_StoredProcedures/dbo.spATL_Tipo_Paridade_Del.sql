SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--sp_help Tipo_Paridade
CREATE procedure [dbo].[spATL_Tipo_Paridade_Del]
(
	@Cd_Tp_Par varchar(3)			
)
as
	if exists(select Cd_Tp_Par from Tipo_Paridade where Cd_Tp_Par= @Cd_Tp_Par) 
	begin
		UPDATE Tipo_Paridade SET Status = 0  where Cd_Tp_Par= @Cd_Tp_Par
	end

GO
