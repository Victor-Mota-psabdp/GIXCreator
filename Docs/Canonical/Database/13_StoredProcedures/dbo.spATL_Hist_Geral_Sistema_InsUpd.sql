SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Hist_Geral_Sistema
CREATE Procedure [dbo].[spATL_Hist_Geral_Sistema_InsUpd]
(
	@HSGProcesso	VarChar(16),
	@HSGSeq			int = Null,
	@Cd_Pes			VarChar(10),
	@Cd_Tp_Ocor		int,
	@HSDDescricao	VarChar(2000),
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


	if @HSGSEQ IS NULL
		BEGIN
			Set @HSGSEQ =(select Isnull(max(hsgseq),0) from Hist_Geral_Sistema where hsgprocesso=@hsgprocesso)+1
			INSERT INTO
				Hist_Geral_Sistema
				(
					HSGProcesso,HSGSeq,Cd_Pes,
					Cd_Tp_Ocor,HSDDescricao,HSGData,
					HSGDataFU,Cd_Usuario,Disp_Cliente,Cd_Origem,
					ID_NC
				)
				VALUES
				(
					@HSGProcesso,@HSGSeq,@Cd_Pes,
					@Cd_Tp_Ocor,@HSDDescricao,getdate(),
					@HSGDataFU,@Cd_Usuario,@Disp_Cliente,@Cd_Origem,
					@Cd_NC
				)
		end
	else
		BEGIN
			UPDATE
				Hist_Geral_Sistema
			SET
				Disp_Cliente=@Disp_Cliente
			WHERE
				hsgprocesso=@hsgprocesso and HSGSeq=@HSGSeq
		END


	IF @@ERROR<>0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END
COMMIT TRANSACTION

GO
