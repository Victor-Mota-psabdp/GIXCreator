SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_AlertaTipoOcorrencia_UPD]
	@JOB varchar(16),
	@cd_tp_ocor int
AS
	UPDATE
		Hist_Geral
	SET
		HSGDataConf = Getdate()
	where
		HSGProcesso = @JOB 
		and HSGdata > '2010-11-04' and Disp_Cliente = 'S' 
		and HSGDataConf is null
		and cd_tp_ocor = @Cd_Tp_Ocor

GO
