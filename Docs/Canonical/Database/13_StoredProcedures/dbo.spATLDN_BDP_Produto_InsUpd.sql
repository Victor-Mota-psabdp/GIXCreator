SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spATLDN_BDP_Produto_InsUpd]
(
	@ID_PD					Int,
	@Nome_BDP_Produto		varchar(50)
)	

AS

BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help BDP_Produto
	BEGIN TRY	
		if @ID_PD is null
			Begin
				set @ID_PD =(select Isnull(max(ID_PD),0)+1 from BDP_Produto)
			End
		
		If EXISTS(select ID_PD from BDP_Produto where ID_PD=@ID_PD)
			Begin
				Update
					BDP_Produto
				Set
					Nome_BDP_Produto=@Nome_BDP_Produto
				Where
					ID_PD=@ID_PD				
			End
		Else
			Begin			
				Insert BDP_Produto
				(
					ID_PD,Nome_BDP_Produto
				)
			Values
				(
					@ID_PD,@Nome_BDP_Produto
				)				
			End		
		
		Select @ID_PD as Retorno;				
		

		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	

END






GO
