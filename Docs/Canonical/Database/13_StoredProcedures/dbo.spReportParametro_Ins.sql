SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spReportParametro_Ins]
(
	@ID_Report int,
	@Ordem int,
	@Descr varchar(50),
	@Tipo varchar(500)
)
AS

Begin Transaction

	Insert into Report_Parametro(ID_Report,ordem, Descr, Tipo)
	Values(@ID_Report, @Ordem, @Descr, @Tipo)

Commit Transaction


GO
