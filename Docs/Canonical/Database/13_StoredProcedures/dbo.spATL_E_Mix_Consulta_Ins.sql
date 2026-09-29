SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_E_Mix_Consulta_Ins]
(
	@id_servico			int,
	@id_empresa			int,
	@id_cnpj			int,
	@id_consulta_tipo	int,
	@id_parametro_grupo int,
	@Id_parametro_tipo	int,
	@valor				varchar(50),
	@num_proc			varchar(16)
)
		
AS

BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help E_Mix_Consulta
	BEGIN TRY
		Declare @ID_New as bigint;
		
		BEGIN			
			Insert E_Mix_Consulta	
			(
				[id_servico],[id_empresa],[id_cnpj],[id_consulta_tipo],[id_parametro_grupo],
				[Id_parametro_tipo],[valor],[num_proc],[dt_ins]
			)
			Values
			(
				@id_servico,@id_empresa,@id_cnpj,@id_consulta_tipo,@id_parametro_grupo,
				@Id_parametro_tipo,@valor,@num_proc,GETDATE()
			)
		END	
		
		set @ID_New = @@IDENTITY;
		Select @ID_New as Retorno;				
		

		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	

END
GO
