SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






CREATE     function Hist_Contra(
			@Hist integer,
			@num_proc varchar(14),
			@job	varchar(14)
				
		)returns datetime
AS 

BEGIN
	return (
		SELECT CASE @Hist
			WHEN 16 THEN (select max(hsgDataFU)  from hist_geral where cd_tp_ocor=10 and hsgprocesso in (@num_proc,@job))
			WHEN 14 THEN (select max(hsgDataFU) from hist_geral where cd_tp_ocor=18 and hsgprocesso in (@num_proc,@job))	
			WHEN 20 THEN (select max(hsgDataFU) from hist_geral where cd_tp_ocor=19 and hsgprocesso in (@num_proc,@job))
			WHEN 7 THEN (select max(hsgDataFU) from hist_geral where cd_tp_ocor=17 and hsgprocesso in (@num_proc,@job))
			WHEN 15 THEN (select max(hsgDataFU) from hist_geral where cd_tp_ocor=9 and hsgprocesso in (@num_proc,@job))		
		END
		)
END







GO
