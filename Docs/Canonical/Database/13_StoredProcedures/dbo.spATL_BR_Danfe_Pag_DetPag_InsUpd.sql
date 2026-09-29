SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_BR_Danfe_Pag_DetPag_InsUpd]
(
	@Id_Danfe	int,
	@tPag [int] NULL,
	@xPag [varchar](14) NULL,
	@vPag decimal(18,2) NULL
)
AS

BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Danfe_Pag_DetPag
	BEGIN TRY			
		if not exists(select id_danfe from ATL_BR.dbo.Danfe_Pag_DetPag with(nolock) where id_danfe=@id_danfe)
			Begin									
				Insert into ATL_BR.dbo.Danfe_Pag_DetPag
				(
					Id_Danfe,tPag,xPag,vPag
				)
				Values
				(
					@Id_Danfe,@tPag,@xPag,@vPag
				)						
			End
		Else
			BEGIN
				Update
					ATL_BR.dbo.Danfe_Pag_DetPag
				Set
					tPag=@tPag,
					xPag=@xPag,
					vPag=@vPag
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
