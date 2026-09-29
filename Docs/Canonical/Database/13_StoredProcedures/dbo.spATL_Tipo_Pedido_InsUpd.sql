SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Pedido
CREATE PROCEDURE [dbo].[spATL_Tipo_Pedido_InsUpd]
(
	@cd_Tp_Pedido	varChar(1),
	@Nome_Tp_Pedido	varChar(50),
	@Nome_TP_Pedido_PT	varChar(50)
)
	
AS

Begin Transaction

	If  exists (select @cd_Tp_Pedido from Tipo_Pedido where @cd_Tp_Pedido=@cd_Tp_Pedido)
		Begin
			Update
				Tipo_Pedido
			Set
				Nome_Tp_Pedido=@Nome_Tp_Pedido,
				Nome_TP_Pedido_PT = @Nome_TP_Pedido_PT
			Where
				@cd_Tp_Pedido=@cd_Tp_Pedido
		End
	Else
		Insert
			Tipo_Pedido(cd_Tp_Pedido,Nome_Tp_Pedido,Nome_TP_Pedido_PT)
		Values
			(@cd_Tp_Pedido,@Nome_Tp_Pedido,@Nome_TP_Pedido_PT)
	

Commit Transaction

GO
