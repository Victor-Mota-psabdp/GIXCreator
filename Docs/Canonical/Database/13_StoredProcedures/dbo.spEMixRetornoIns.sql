SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spEMixRetornoIns]
	(
		@XML_Recebido Varchar(MAX),
		@Tipo_Consulta Varchar(50),
		@Num_Proc	Varchar(16),
		@ID_Envio	BigInt,
		@id bigint output
	)
	
	AS
	
	--Declare @Int as integer
	
	--Set @Int= (select MAX(isnull(id,0)) from Emix_retorno with(nolock))
	--if @Int is null
	--	Begin
	--		Set @Int=1
	--	End
	--Else
	--	Begin
	--		set @Int=@Int+1
	--	End
		
	--Insert Emix_Retorno(id,xml_recebido,Tipo_Consulta,Num_Proc,ID_Envio)values(@Int,@XML_Recebido,@Tipo_Consulta,@num_proc,@ID_Envio)
	
	--SEt @id=@Int
	
	BEGIN 
		BEGIN TRY
			Declare @ID_New as bigint;
			--sp_help ATL_INT.DBO.Emix_Retorno
			BEGIN TRAN		
				Insert ATL_INT.DBO.Emix_Retorno
				(
					XML_Recebido,Tipo_Consulta,Num_Proc,ID_Envio
				)
				Values
				(
					@XML_Recebido,@Tipo_Consulta,@num_proc,@ID_Envio
				)
				
				set @ID = @@IDENTITY;
				Select @ID as Retorno;
			
			COMMIT TRAN
		
		
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	

END
GO
