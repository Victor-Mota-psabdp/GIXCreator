SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spATL_Produto_CHB_Det_Del](
	@cd_prod		INT,
	@cd_tp_tx		varchar(6)
)
as

IF EXISTS(SELECT cd_prod from Produto_CHB_Det WHERE cd_prod = @cd_prod and Cd_Tp_Tx = @cd_tp_tx)
	Begin
		DELETE
			Produto_CHB_Det 
		WHERE 
			cd_prod = @cd_prod and Cd_Tp_Tx = @cd_tp_tx		
	End

GO
