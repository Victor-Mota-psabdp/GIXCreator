SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO












CREATE procedure [dbo].[spProdutoCHB_Det_InsUpd]
		
	@CodProduto		varchar(10),
	@TipoTX			varchar(30),
	@Porcentagem	float(3)
	

AS


Begin Transaction
		Declare @Cd_Tp_Tx varchar(3)
		set @Cd_Tp_Tx=(select cd_tp_tx from tipo_taxa where nome_tp_tx=@tipotx)
		
		
		if exists (select cd_tp_tx,cd_prod from produto_chb_det where cd_tp_tx=@cd_tp_tx and cd_prod=@codproduto)
			Begin
				Update 
					produto_chb_det
				Set
					cd_tp_tx=@cd_tp_tx,
					porcentagem=@porcentagem
				where
					cd_prod=@CodProduto and cd_tp_tx=@cd_tp_tx
			End
		else
			Begin		
				Insert Produto_chb_det(
							cd_prod,
							Cd_Tp_Tx,
							Porcentagem)
					Values(
							@CodProduto,
							@cd_tp_tx,
							@Porcentagem)	
			End
Commit Transaction

GO
