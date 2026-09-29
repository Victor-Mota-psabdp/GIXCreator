SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_BR_Danfe_Cobr_Fat_InsUpd]
(
	@Id_Danfe	int,
	@nFat varchar(250),
	@vOrig Decimal(18,2),
	@vDesc Decimal(18,2),
	@vLiq Decimal(18,2)
)
AS

BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Danfe_Cobr_Fat
	BEGIN TRY			
		if not exists(select id_danfe from ATL_BR.dbo.Danfe_Cobr_Fat with(nolock) where id_danfe=@id_danfe)
			Begin									
				Insert into ATL_BR.dbo.Danfe_Cobr_Fat
				(
					Id_Danfe,nFat,vOrig,vDesc,vLiq
				)
				Values
				(
					@Id_Danfe,@nFat,@vOrig,@vDesc,@vLiq
				)						
			End
		Else
			BEGIN
				Update
					ATL_BR.dbo.Danfe_Cobr_Fat
				Set
					nFat=@nFat,
					vOrig=@vOrig,
					vDesc=@vDesc,
					vLiq=@vLiq					
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
