SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Produto_CHB_Det
CREATE procedure [dbo].[spATL_Produto_CHB_Det_InsUpd]
		
	@cd_prod		INT,
	@Cd_Tp_Tx		VARCHAR(3),
	@Porcentagem	float	

AS


Begin Transaction
	
		
		if exists (select Cd_Tp_Tx,cd_prod from Produto_CHB_Det where cd_tp_tx=@cd_tp_tx and cd_prod=@cd_prod)
			Begin
				Update 
					Produto_CHB_Det
				Set
					Cd_Tp_Tx=@cd_tp_tx,
					Porcentagem=@porcentagem
				where
					cd_prod=@cd_prod and Cd_Tp_Tx=@cd_tp_tx
			End
		else
			Begin		
				Insert Produto_CHB_Det(
							cd_prod,
							Cd_Tp_Tx,
							Porcentagem)
					Values(
							@cd_prod,
							@cd_tp_tx,
							@Porcentagem)	
			End
			
Commit Transaction

GO
