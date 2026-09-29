SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_BR_Danfe_Item_Prod_DI_Adicao_InsUpd]
(
	@nDI		varchar(50),
	@nAdicao	varchar(3),
	@nSeqAdic	varchar(3),
	@cFabricante	varchar(60),
	@vDescDI	float,
	@ID_Danfe	int,
	@Id_Item	int
)
AS

BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Danfe_Item_Prod_DI_Adicao
	BEGIN TRY			
		if not exists(select id_danfe from ATL_BR.dbo.Danfe_Item_Prod_DI_Adicao with(nolock) 
					where id_danfe=@ID_Danfe and id_item=@id_item and nDI=@nDI And nAdicao=@nAdicao And nSeqAdic=@nSeqAdic)
			Begin									
				Insert into ATL_BR.dbo.Danfe_Item_Prod_DI_Adicao
				(
					nDI,nAdicao,nSeqAdic,cFabricante,vDescDI,ID_Danfe,Id_Item
				)
				Values
				(
					@nDI,@nAdicao,@nSeqAdic,@cFabricante,@vDescDI,@ID_Danfe,@Id_Item
				)						
			End
		Else
			BEGIN
				Update
					ATL_BR.dbo.Danfe_Item_Prod_DI_Adicao
				SET
					cFabricante	=@cFabricante,
					vDescDI	=@vDescDI
				Where
					id_danfe=@ID_Danfe and id_item=@id_item 
					and nDI=@nDI And nAdicao=@nAdicao And nSeqAdic=@nSeqAdic
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
