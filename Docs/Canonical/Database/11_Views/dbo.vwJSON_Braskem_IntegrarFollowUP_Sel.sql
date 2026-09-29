SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[vwJSON_Braskem_IntegrarFollowUP_Sel]
AS
	Select
			S.Id_IntegrarFollowUP	 [Internal Code],
			S.hawb,
			S.deal,
			S.processoNumero,
			S.nomeNavio,
			S.nomeNavioTransbordo,
			S.origin,
			S.destination,
			S.freeTime,
			S.referenciaArmador,
			S.dataAtracacao,
			S.dataEmbarque,
			S.numeroCeMaster,
			S.dataEta,
			S.dataEtd,
			S.dataPrevEtd,
			S.dataPrevEta,
			S.dataPresencaCarga,
			S.dataEfetivaColeta,
			S.dataPrevisaoColeta,
			S.pesoBruto,
			S.volumeCubico,
			S.haCargaImo,
			S.observacaoRodoviario,
			S.dataGreenLight,
			S.dataChegadaArmazem,
			S.dataChegadaDestino,
			S.tipoContratacaoFrete,
			S.Num_Proc,
			S.Dt_Ins					[Insert Date],
			S.Dt_Sent					[Sent Date],
			S.Message
		from 
			ATL_INT.dbo.JSON_Braskem_IntegrarFollowUP S with(nolock)	
	Where
		S.dt_ins > getdate() -365
	

GO
