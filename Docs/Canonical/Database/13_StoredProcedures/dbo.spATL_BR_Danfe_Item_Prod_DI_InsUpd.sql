SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_BR_Danfe_Item_Prod_DI_InsUpd]
(
	@Id_Danfe	int,
	@id_Item	int,
	@cProd	varchar(60),
	@nDI	varchar(50),
	@dDI	datetime,
	@xLocDesemb	varchar(60),
	@UFDesemb	char(2),
	@dDesemb	datetime,
	@cExportador	varchar(60),
	@vAFRMM		float
)
AS

BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Danfe_Item_Prod_DI
	BEGIN TRY			
		if not exists(select id_danfe from ATL_BR.dbo.Danfe_Item_Prod_DI with(nolock) 
					where id_danfe=@id_danfe and id_item=@id_item)
			Begin									
				Insert into ATL_BR.dbo.Danfe_Item_Prod_DI
				(
					Id_Danfe,id_Item,cProd,nDI,dDI,xLocDesemb,UFDesemb,dDesemb,cExportador,vAFRMM
				)
				Values
				(
					@Id_Danfe,@id_Item,@cProd,@nDI,@dDI,@xLocDesemb,@UFDesemb,@dDesemb,@cExportador,@vAFRMM
				)						
			End
		Else
			BEGIN
				Update
					ATL_BR.dbo.Danfe_Item_Prod_DI
				SET
					nDI=@nDI,
					dDI=@dDI,
					xLocDesemb=@xLocDesemb,
					UFDesemb=@UFDesemb,
					dDesemb=@dDesemb,
					cExportador=@cExportador,
					vAFRMM = @vAFRMM
				Where
					Id_Danfe=@Id_Danfe And
					id_Item=@id_Item
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
