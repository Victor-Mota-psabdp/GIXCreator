SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Produto_Perigoso
CREATE PROCEDURE [dbo].[spATL_Produto_Perigoso_Del](
	@cd_prod		INT
)
as

IF EXISTS(SELECT cd_prod from Produto_Perigoso WHERE cd_prod = @cd_prod)
	Begin
		DELETE
			Produto_Perigoso 
		WHERE 
			cd_prod = @cd_prod 
	End

GO
