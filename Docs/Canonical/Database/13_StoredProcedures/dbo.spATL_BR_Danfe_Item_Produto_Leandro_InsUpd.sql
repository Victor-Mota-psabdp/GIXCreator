SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[spATL_BR_Danfe_Item_Produto_Leandro_InsUpd]
(
	@Id_Danfe	int,
	@id_Item	int,
	@cProd	varchar(60),
	@cEAN	varchar(14),
	@xProd	varchar(MAX),
	@NCM	varchar(8),
	@CFOP	varchar(4),
	@uCOM	varchar(6),
	@qCom	float,
	@vUNCom	float,
	@vProd	float,
	@vFrete	float,
	@vSeguro	float,
	@vDesconto	float,
	@vOutrasDesp float
)
AS

BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Danfe_Item_Produto
	BEGIN TRY			
		if not exists(select id_danfe from ATL_BR.dbo.Danfe_Item_Produto with(nolock) 
					where id_danfe=@id_danfe and id_item=@id_item and cProd=@cProd)
			Begin									
				Insert into ATL_BR.dbo.Danfe_Item_Produto
				(
					Id_Danfe,id_Item,cProd,--cEAN,
					xProd,NCM,CFOP,uCOM,qCom,vUNCom,vProd,vFrete,vSeguro,vDesconto,vOutrasDesp
				)
				Values
				(
					@Id_Danfe,@id_Item,@cProd,--@cEAN,
					@xProd,@NCM,@CFOP,@uCOM,@qCom,@vUNCom,@vProd,@vFrete,@vSeguro,@vDesconto,@vOutrasDesp
				)							
			End
		Else
			BEGIN
				Update
					ATL_BR.dbo.Danfe_Item_Produto
				Set
					--cEAN=@cEAN,
					xProd=@xProd,
					NCM=@NCM,
					CFOP=@CFOP,
					uCOM=@uCOM,
					qCom=@qCom,
					vUNCom=@vUNCom,
					vProd=@vProd,
					vFrete=@vFrete,
					vSeguro=@vSeguro,
					vDesconto=@vDesconto,
					vOutrasDesp=@vOutrasDesp
					
				Where
					Id_Danfe=@Id_Danfe And
					id_Item=@id_Item And
					cProd=@cProd
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
