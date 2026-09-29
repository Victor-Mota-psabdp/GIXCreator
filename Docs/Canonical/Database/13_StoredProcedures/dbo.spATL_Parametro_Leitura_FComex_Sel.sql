SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
select 
	'2025-08-26 17:00:00.000' CreatedOrModifiedStart ,
	'2025-08-26 17:59:00.000' CreatedOrModifiedEnd
from ATL_INT.dbo.Parametro_Leitura_FComex
*/

CREATE Procedure [dbo].[spATL_Parametro_Leitura_FComex_Sel]
as
--select 
--			format(CreatedOrModifiedStart,'dd/MM/yyyy hh:mm:ss') as CreatedOrModifiedStart ,
--			format(CreatedOrModifiedEnd,'dd/MM/yyyy 23:23:59')  as CreatedOrModifiedEnd
--		from ATL_INT.dbo.Parametro_Leitura_FComex

select 
			 CreatedOrModifiedStart ,
			CreatedOrModifiedEnd
		from ATL_INT.dbo.Parametro_Leitura_FComex


--		select 
--	'2025-09-04 16:20:10' CreatedOrModifiedStart ,
--	'2025-09-04 17:20:10' CreatedOrModifiedEnd
--from ATL_INT.dbo.Parametro_Leitura_FComex


GO
