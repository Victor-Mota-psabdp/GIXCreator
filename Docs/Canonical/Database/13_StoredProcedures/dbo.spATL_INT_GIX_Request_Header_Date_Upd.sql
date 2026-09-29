SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spATL_INT_GIX_Request_Header_Date_Upd]

	@ID_Req					BigInt,
	@DT_INS_PEDIDO			Datetime,
	@DT_INS_JOB				Datetime,
	@DT_INS_Nota_Cliente	Datetime,
	@Num_Proc				varchar(16),
	@Utilizado				bit,
	@DT_INS_PESSOA			Datetime,
	@DT_INS_PRODUTO			Datetime,
	@DT_SEND_MESSAGE		Datetime

AS
BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help GIX_Request_Header
	BEGIN TRY
		
		BEGIN			
			update 
				ATL_INT.dbo.GIX_Request_Header
				--Comentado em 15/05/2026 Leandro
			--set
			--	DT_INS_PEDIDO		= @DT_INS_PEDIDO,
			--	DT_INS_JOB			= @DT_INS_JOB,
			--	DT_INS_Nota_Cliente = @DT_INS_Nota_Cliente,
			--	Num_Proc			= @Num_Proc,
			--	Utilizado			= @Utilizado,
			--	DT_INS_PESSOA		= @DT_INS_PESSOA,
			--	DT_INS_PRODUTO		= @DT_INS_PRODUTO,
			--	DT_SEND_MESSAGE		= @DT_SEND_MESSAGE
			set
				DT_INS_PEDIDO		= isnull(@DT_INS_PEDIDO,DT_INS_PEDIDO),
				DT_INS_JOB			= isnull(@DT_INS_JOB,DT_INS_JOB),
				DT_INS_Nota_Cliente = isnull(@DT_INS_Nota_Cliente,DT_INS_Nota_Cliente),
				Num_Proc			= isnull(@Num_Proc,Num_Proc),
				Utilizado			= isnull(@Utilizado,Utilizado),
				DT_INS_PESSOA		= isnull(@DT_INS_PESSOA,DT_INS_PESSOA),
				DT_INS_PRODUTO		= isnull(@DT_INS_PRODUTO,DT_INS_PRODUTO),
				DT_SEND_MESSAGE		= isnull(@DT_SEND_MESSAGE,DT_SEND_MESSAGE)
			where
				ID_Req = @ID_Req			
		END	

		Select @ID_Req as Retorno;			
		

		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	

END

GO
