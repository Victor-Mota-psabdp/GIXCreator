SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spATL_Produto_CHB_Del]
(
	@cd_prod		INT
)
as

IF EXISTS(SELECT cd_prod from Produto_CHB WHERE cd_prod = @cd_prod)
	Begin
		DELETE
			Produto_CHB 
		WHERE 
			cd_prod = @cd_prod 	
	End

GO
