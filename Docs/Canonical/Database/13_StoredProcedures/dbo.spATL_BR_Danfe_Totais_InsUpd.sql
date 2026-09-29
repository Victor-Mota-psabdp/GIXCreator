SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_BR_Danfe_Totais_InsUpd]
(
	@Id_Danfe	int,
	@vBC	float,
	@vICMS	float,
	@vBCST	float,
	@vST	float,
	@vProd	float,
	@vFrete	float,
	@vSeg	float,
	@vDesc	float,
	@vII	float,
	@vIPI	float,
	@vCofins	float,
	@vPIS	float,
	@vOutros	float,
	@vNF	float
)
AS

BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Danfe_Totais
	BEGIN TRY			
		if not exists(select id_danfe from ATL_BR.dbo.Danfe_Totais with(nolock) where id_danfe=@id_danfe)
			Begin									
				Insert into ATL_BR.dbo.Danfe_Totais
				(
					Id_Danfe,vBC,vICMS,vBCST,vST,vProd,vFrete,vSeg,vDesc,vII,
					vIPI,vCofins,vPIS,vOutros,vNF
				)
				Values
				(
					@Id_Danfe,@vBC,@vICMS,@vBCST,@vST,@vProd,@vFrete,@vSeg,@vDesc,@vII,
					@vIPI,@vCofins,@vPIS,@vOutros,@vNF
				)						
			End
		Else
			BEGIN
				Update
					ATL_BR.dbo.Danfe_Totais
				Set
					vBC=@vBC,
					vICMS=@vICMS,
					vBCST=@vBCST,
					vST=@vST,
					vProd=@vProd,
					vFrete=@vFrete,
					vSeg=@vSeg,
					vDesc=@vDesc,
					vII=@vII,
					vIPI=@vIPI,
					vCofins=@vCofins,
					vPIS=@vPIS,
					vOutros=@vOutros,
					vNF=@vNF
				Where
					Id_Danfe=@Id_Danfe
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
