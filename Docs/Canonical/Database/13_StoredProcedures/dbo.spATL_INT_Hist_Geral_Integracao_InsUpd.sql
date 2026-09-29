SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spATL_INT_Hist_Geral_Integracao_Del
--select * from ATL_INT.dbo.Hist_Geral_Integracao
--sp_help Hist_Geral_Integracao
CREATE Procedure [dbo].[spATL_INT_Hist_Geral_Integracao_InsUpd]
(
	@ID				BigInt,
	@HSGProcesso	VarChar(16),
	@HSGSeq			int = Null,
	@Cd_Pes			VarChar(10),
	@Cd_Tp_Ocor		int,
	@HSDDescricao	VarChar(MAX),
	@HSGData		Datetime,
	@HSGDataFU		Datetime,	
	@Cd_Usuario		VarChar(6),
	@HSGDataConf	Datetime,
	@Disp_Cliente	Char(1),
	@Cd_Origem		Char(1),
	@Cd_NC			VarChar(50)
)

AS

BEGIN TRANSACTION

	if @ID IS NULL
		BEGIN	
			Set @HSGSEQ =(select Isnull(max(hsgseq),0) from ATL_INT.dbo.Hist_Geral_Integracao where hsgprocesso=@hsgprocesso)+1
			INSERT INTO
				ATL_INT.dbo.Hist_Geral_Integracao
				(
					HSGProcesso,HSGSeq,Cd_Pes,Cd_Tp_Ocor,HSDDescricao,HSGDataFU,Cd_Usuario,Disp_Cliente,Cd_Origem,ID_NC
				)
				VALUES
				(
					@HSGProcesso,@HSGSeq,@Cd_Pes,@Cd_Tp_Ocor,@HSDDescricao,@HSGDataFU,@Cd_Usuario,@Disp_Cliente,@Cd_Origem,@Cd_NC
				)
		end
	else
		BEGIN
			UPDATE				
				ATL_INT.dbo.Hist_Geral_Integracao
			SET
				HSDDescricao = @HSDDescricao,
				Disp_Cliente=@Disp_Cliente
			WHERE
				ID=@ID
		END


	IF @@ERROR<>0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END
COMMIT TRANSACTION




GO
