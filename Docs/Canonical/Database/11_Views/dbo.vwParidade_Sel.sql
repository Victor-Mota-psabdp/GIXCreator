SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Paridade
CREATE  VIEW [dbo].[vwParidade_Sel]
AS
	select 
		P.Dt_Par			[Currency Date],
		P.Cd_Tp_Moeda		[Currency Type Code],
		TM.Nome_Tp_Moeda	[Currency Type Name],
		P.Cd_Tp_Par			[Paridade Type Code],
		TP.Nome_Tp_Par		[Paridade Type Name],
		P.Par_Moeda			[Value]						
	from Paridade P with(nolock)
		left Join Tipo_Moeda TM with(nolock) on P.Cd_Tp_Moeda = TM.Cd_Tp_Moeda
		left join Tipo_Paridade TP with(nolock) on P.Cd_Tp_Par = TP.Cd_Tp_Par
	

GO
