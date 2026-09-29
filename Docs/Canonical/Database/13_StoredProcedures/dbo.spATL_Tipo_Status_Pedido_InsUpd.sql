SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Status_Pedido
CREATE PROCEDURE [dbo].[spATL_Tipo_Status_Pedido_InsUpd]
(
	@Cd_Tp_Status_Pedido	VARchar(3),
	@Nome_Tp_Status_Pedido	varchar(20)
)

AS

Begin Transaction

	If  exists (select Cd_Tp_Status_Pedido from Tipo_Status_Pedido where Cd_Tp_Status_Pedido=@Cd_Tp_Status_Pedido)
		Begin
			Update
				Tipo_Status_Pedido
			Set
				Nome_Tp_Status_Pedido=@Nome_Tp_Status_Pedido
			Where
				Cd_Tp_Status_Pedido=@Cd_Tp_Status_Pedido
		End
	Else
		Insert
			Tipo_Status_Pedido(Cd_Tp_Status_Pedido,Nome_Tp_Status_Pedido)
		Values
			(@Cd_Tp_Status_Pedido,@Nome_Tp_Status_Pedido)
	

Commit Transaction

GO
