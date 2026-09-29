SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_BR_Danfe_Transp_Vol_InsUpd]
(
	@Id_Danfe	int,
	@qVol	int,
	@esp	varchar(60),
	@Marca	varchar(60),
	@nVol	Varchar(50),
	@PesoL	float,
	@PesoB	float
)
AS

BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Danfe_Transp_Vol
	BEGIN TRY			
		if not exists(select id_danfe from ATL_BR.dbo.Danfe_Transp_Vol with(nolock) where id_danfe=@id_danfe)
			Begin									
				Insert into ATL_BR.dbo.Danfe_Transp_Vol
				(
					Id_Danfe,qVol,esp,Marca,nVol,PesoL,PesoB
				)
				Values
				(
					@Id_Danfe,@qVol,@esp,@Marca,@nVol,@PesoL,@PesoB
				)						
			End
		Else
			BEGIN
				Update
					ATL_BR.dbo.Danfe_Transp_Vol
				Set
					qVol=@qVol,
					esp=@esp,
					Marca=@Marca,
					nVol=@nVol,
					PesoL=@PesoL,
					PesoB=@PesoB
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
