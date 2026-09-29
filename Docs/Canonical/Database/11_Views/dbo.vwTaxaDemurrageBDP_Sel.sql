SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vwTaxaDemurrageBDP_Sel] 

AS

	select distinct
			Nome_Tp_Cont [01_Type Of Container], 
			ds_periodo [02_Periodo]		
		from Taxa_Demurrage_BDP T
			join Tipo_Container TC on TC.Cd_Tp_Cont = T.cd_tp_cont
			join Tipo_Periodo_Demurrage P on P.cd_periodo = T.Periodo



GO
