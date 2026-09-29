SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_BR_Danfe_Transp_VeicTransp_InsUpd]
(
	@Id_Danfe	int,	
	@placa	varchar(60),
	@UF	varchar(60)	
)
AS

BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Danfe_Transp_VeicTransp
	BEGIN TRY			
		if not exists(select id_danfe from ATL_BR.dbo.Danfe_Transp_VeicTransp with(nolock) where id_danfe=@id_danfe)
			Begin									
				Insert into ATL_BR.dbo.Danfe_Transp_VeicTransp
				(
					Id_Danfe,placa,UF
				)
				Values
				(
					@Id_Danfe,@placa,@UF
				)						
			End
		Else
			BEGIN
				Update
					ATL_BR.dbo.Danfe_Transp_VeicTransp
				Set					
					placa=@placa,
					UF=@UF					
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
