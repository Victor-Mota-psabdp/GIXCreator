SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spReportVolumeAnual_Alerta]
AS

select * from temp_ReportVolume_Anual
order by (Janeiro+Fevereiro+Marco+Abril+Maio+Junho+Julho+Agosto+Setembro+Outubro+Novembro+Dezembro) desc


GO
