SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_Customer_Profile_Del] 
	@ID_CP int
as

	delete customer_profile_taxas where id_cp = @Id_Cp
             
	delete customer_profile where id_cp = @Id_Cp
	
	IF @@Error <> 0
		BEGIN
			PRINT 'ERRADO'
			ROLLBACK TRANSACTION
			rETURN -1
		END
Commit Transaction

GO
