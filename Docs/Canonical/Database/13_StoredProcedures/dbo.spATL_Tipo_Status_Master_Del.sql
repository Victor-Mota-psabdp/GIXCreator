SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Status_Master
CREATE procedure [dbo].[spATL_Tipo_Status_Master_Del]
(
	@Cd_Tp_Status_Master varchar(3)
)
as
	--if exists(select Cd_Tp_Oper from Tipo_Status_Master where Cd_Tp_Oper= @Cd_Tp_Oper)
	--begin
	--	delete Tipo_Status_Master where Cd_Tp_Oper= @Cd_Tp_Oper
	--end

GO
