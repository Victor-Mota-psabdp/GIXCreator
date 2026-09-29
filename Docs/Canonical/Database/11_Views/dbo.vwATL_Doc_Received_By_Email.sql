SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vwATL_Doc_Received_By_Email]
AS
		select 
			D.[ID],
			D.[Folder],
			D.[Item],
			D.[Doc_Name],
			D.[Doc_Extension],
			D.[Path],
			D.[Doc_Full_Name],
			D.[From],
			D.[Subject],
			D.[Received],
			D.[To],
			D.[Cc],
			D.[Bcc],
			D.[Dt_ins],
			D.[Dt_ATL]
		from 
			ATL_INT.dbo.Doc_Received_By_Email D with(nolock)


GO
