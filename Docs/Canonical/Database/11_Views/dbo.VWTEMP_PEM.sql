SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   VIEW VWTEMP_PEM

AS

SELECT excprocesso Processo,excdataalt FROM exchange HOU
where excdataalt > '01-01-2008'


GO
