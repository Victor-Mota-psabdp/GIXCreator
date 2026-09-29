SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_JSON_FComex_Custo_Processo_Line_InsUp]

	@Id_Processo [bigint],
	@Cd_Tp_Tx [varchar](200) NULL,
	@Valor [varchar](200) NULL,
	@Dt_Rateio [varchar](200) NULL
	   	  
AS
BEGIN
BEGIN TRANSACTION;
--Exceção(try/CATCH)
--Transação
--sp_help JSON_FComex_Custo_Processo_Line

	BEGIN TRY
		IF exists(select @Id_Processo from ATL_INT.dbo.JSON_FComex_Custo_Processo_Line 
			   	  where Id_Processo = @Id_Processo
				  and   Cd_Tp_Tx = @Cd_Tp_Tx) 
			Begin
				Update
					ATL_INT.dbo.JSON_FComex_Custo_Processo_Line
				Set					
					
					[Valor] =@Valor,
					[Dt_Rateio] =@Dt_Rateio
				Where
					Id_Processo = @Id_Processo
					and [Cd_Tp_Tx] = @Cd_Tp_Tx
			End
		Else
			BEGIN
				Insert ATL_INT.dbo.JSON_FComex_Custo_Processo_Line
				(
					[Id_Processo],
					[Cd_Tp_Tx],
					[Valor],
					[Dt_Rateio]
				)
				Values
				(
				    @Id_Processo,
					@Cd_Tp_Tx,
					@Valor,
					@Dt_Rateio
				)
			END	
		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;
	END CATCH	
END

GO
