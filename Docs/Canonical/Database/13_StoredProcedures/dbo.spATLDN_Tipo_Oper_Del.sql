SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Oper
CREATE procedure [dbo].[spATLDN_Tipo_Oper_Del]
(
	@Cd_Tp_Oper varchar(3)
)
as
	--if exists(select Cd_Tp_Oper from Tipo_Oper where Cd_Tp_Oper= @Cd_Tp_Oper)
	--begin
	--	delete Tipo_Oper where Cd_Tp_Oper= @Cd_Tp_Oper
	--end

GO
