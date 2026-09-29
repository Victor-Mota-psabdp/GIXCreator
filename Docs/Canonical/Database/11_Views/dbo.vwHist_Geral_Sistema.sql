SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vwHist_Geral_Sistema] 
as 
	select distinct
		HSGProcesso 
	from 
		Hist_Geral_Sistema 
	where 
		cd_tp_ocor in (45,46) and len(HSGProcesso)=16 and right(left(HSGProcesso,11),2) = MONTH(GETDATE())

GO
