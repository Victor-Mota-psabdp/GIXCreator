SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_BR_Danfe_Item_Impostos_InsUpd]
(
	@Id_Danfe	int,
	@id_Item	int,
	@cImpostos	varchar(25),
	@cEnq	varchar(3),
	@orig	int,
	@CST	varchar(2),
	@modBC	int,
	@vBC	float,
	@pImposto	float,
	@vImposto	float,
	@vDespAdu	float,
	@vIOF	float,
	@pRedBCST	float,
	@vBCST	float,
	@pImpostoST float,
	@vImpostoST	float,
	@qBCProd	float,
	@vAliqProd	float,
	@cSelo	varchar(60),
	@qSelo	float,
	@cIEnq	varchar(5),
	@modBCST	int
)
AS

BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Danfe_Item_Impostos
	BEGIN TRY			
		if not exists(select id_danfe from ATL_BR.dbo.Danfe_Item_Impostos with(nolock) 
					where Id_Danfe=@Id_Danfe and id_Item=@id_item and cImpostos=@cImpostos)
			Begin									
				Insert into ATL_BR.dbo.Danfe_Item_Impostos
				(
					Id_Danfe,id_Item,cImpostos,cEnq,orig,CST,modBC,vBC,pImposto,vImposto,
					vDespAdu,vIOF,pRedBCST,vBCST,pImpostoST,vImpostoST,qBCProd,vAliqProd,
					cSelo,qSelo,cIEnq,modBCST
				)
				Values
				(
					@Id_Danfe,@id_Item,@cImpostos,@cEnq,@orig,@CST,@modBC,@vBC,@pImposto,@vImposto,
					@vDespAdu,@vIOF,@pRedBCST,@vBCST,@pImpostoST,@vImpostoST,@qBCProd,@vAliqProd,
					@cSelo,@qSelo,@cIEnq,@modBCST
				)						
			End
		Else
			BEGIN
				Update
					ATL_BR.dbo.Danfe_Item_Impostos
				SET
					cEnq=@cEnq,
					orig=@orig,
					CST=@CST,
					modBC=@modBC,
					vBC=@vBC,
					pImposto=@pImposto,
					vImposto=@vImposto,
					vDespAdu=@vDespAdu,
					vIOF=@vIOF,
					pRedBCST=@pRedBCST,
					vBCST=@vBCST,
					pImpostoST = @pImpostoST,
					vImpostoST=@vImpostoST,
					qBCProd=@qBCProd,
					vAliqProd=@vAliqProd,
					cSelo=@cSelo,
					qSelo=@qSelo,
					cIEnq=@cIEnq,
					modBCST =@modBCST
				Where
					Id_Danfe=@Id_Danfe and id_Item=@id_item and cImpostos=@cImpostos
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
