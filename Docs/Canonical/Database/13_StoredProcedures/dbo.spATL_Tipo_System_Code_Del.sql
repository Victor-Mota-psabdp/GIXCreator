SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Tipo_System_Code_Del]
(
	@ID_System_Code	BigInt
)
AS  
  
BEGIN TRANSACTION

	IF EXISTS (	SELECT ID_System_Code FROM ATL_INT.dbo.Tipo_System_Code WHERE ID_System_Code = @ID_System_Code)  
		BEGIN  
			Update ATL_INT.dbo.Tipo_System_Code SET Ativo = 0 WHERE ID_System_Code = @ID_System_Code

		END
	
  
COMMIT TRANSACTION


GO
