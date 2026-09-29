SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Nota_Cliente_Del]
(
	@ID_NF				bigint, 
	@Nota_Fiscal		VarChar(20),  
	@Cd_Cliente			VarChar(10),
	@Num_Proc			VarChar(16)
)
AS  
  
BEGIN TRANSACTION
  
	IF EXISTS (SELECT ID_NF FROM Nota_Cliente WHERE Num_Proc= @Num_Proc and Nota_Fiscal = @Nota_Fiscal and cd_cliente = @Cd_Cliente)  
		BEGIN  
			UPDATE
				Nota_Cliente
			Set
				Num_proc=Left(num_proc,15)+'D'
			Where
				Num_Proc= @Num_Proc and Nota_Fiscal = @Nota_Fiscal and cd_cliente = @Cd_Cliente
		END	
  
COMMIT TRANSACTION


GO
