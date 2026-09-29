SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_BR_Danfe_Item_InsUpd]
(
	@Id_Danfe	int,
	@id_Item		int,
	@infAdProd	varchar(500)
)
AS

BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Danfe_Item
	BEGIN TRY			
		if not exists(select id_danfe from ATL_BR.dbo.Danfe_Item with(nolock) where id_danfe=@id_danfe and id_item=@id_item)
			Begin									
				Insert into ATL_BR.dbo.Danfe_Item
				(
					Id_Danfe,
					id_Item,
					infAdProd
				)
			Values
				(
					@Id_Danfe,
					@id_Item,
					@infAdProd
				)
							
			End
		Else
			BEGIN
				Update
					ATL_BR.dbo.Danfe_Item
				Set
					infAdProd=@infAdProd
				Where
					id_danfe=@id_danfe and id_item=@id_item
			END		
			
		Select @Id_Danfe as Retorno;

		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	

END

GO
