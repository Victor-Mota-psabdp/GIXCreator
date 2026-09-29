SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spAjustaValorPedido_Update]

as

Begin Transaction
	
	BEGIN
		--fazer um ajusta Vlr_Pedido depois q já incluiu os valores
		Begin
			update Pedido set Vlr_Pedido=[dbo].[fPedido_Vlr_Total_Item](P.cd_pedido) from Pedido P
				join Pedido_det PD with(nolock) on PD.cd_pedido = P.cd_pedido
				left Join Pedido_Ship PS with(nolock) on PD.Item=ps.item and PD.cd_pedido=PS.cd_pedido
			where obs_pc like '%Register by Integration%' and num_proc is null			
		End		
	END			
--
--	IF @@ERROR<>0 
--		BEGIN
--			ROLLBACK TRANSACTION
--			RETURN -1
--		END
COMMIT TRANSACTION
GO
