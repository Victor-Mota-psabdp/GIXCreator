SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_LOG_Nota_Cliente_InsUpd]
(		
	@ID_Log						bigint,
	@Dt_Alter					datetime,
	@Tp_Oper					varchar(1),
	@Nota_Fiscal				VarChar(20), 
	@Num_Proc					varchar(16),
	@CD_Cliente					varchar(50),
	@Cd_Usuario					varchar(10),
	@Justifica					varchar(500)
	
)
AS  

BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help LOG_Nota_Cliente
	BEGIN TRY
		Declare @ID_New as bigint;
		 
		BEGIN 
			
			INSERT LOG_Nota_Cliente
			(  
				Dt_NF,Num_Proc,Nota_Fiscal,Cd_Cliente,Cd_Usuario,Tipo_Oper_NF,Justifica
			)  
			VALUES  
			(  
				Getdate(),@Num_Proc,@Nota_Fiscal,@Cd_Cliente,@Cd_Usuario,@Tp_Oper,@Justifica
			)  
		END  
  
		Select @ID_New as Retorno;				
		

		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;
	END CATCH	
END

GO
