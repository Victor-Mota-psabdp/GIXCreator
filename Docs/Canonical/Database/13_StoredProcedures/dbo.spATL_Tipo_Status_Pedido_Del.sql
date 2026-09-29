SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Status_Pedido
CREATE procedure [dbo].[spATL_Tipo_Status_Pedido_Del]
(
	@Cd_Tp_Status_Pedido varchar(3)
)
as
	--if exists(select Cd_Tp_Oper from Tipo_Status_Pedido where Cd_Tp_Oper= @Cd_Tp_Oper)
	--begin
	--	delete Tipo_Status_Pedido where Cd_Tp_Oper= @Cd_Tp_Oper
	--end

GO
