SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Paridade
CREATE procedure [dbo].[spATLDN_Paridade_Sel]
(
	@Dt_Par			varchar(10),
	@Cd_Tp_Moeda	varchar(3),
	@Cd_Tp_Par		varchar(3),
	@Tipo char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
*/

if @Tipo = 'A'  or  @Tipo = 'B'
	Begin
		select 
			P.Dt_Par			[Exchange Rates Date],
			P.Cd_Tp_Moeda		[Currency Type Code],
			TM.Nome_Tp_Moeda	[Currency Type Name],
			P.Cd_Tp_Par			[Exchange Rates Type Code],
			TP.Nome_Tp_Par		[Exchange Rates Type Name],
			P.Par_Moeda			[Exchange Rates Value]						
		from Paridade P with(nolock)
			left Join Tipo_Moeda TM with(nolock) on P.Cd_Tp_Moeda = TM.Cd_Tp_Moeda
			left join Tipo_Paridade TP with(nolock) on P.Cd_Tp_Par = TP.Cd_Tp_Par
		where
			Dt_Par=@Dt_Par		
	End	

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select 
			P.Dt_Par			[Exchange Rates Date],
			P.Cd_Tp_Moeda		[Currency Type Code],
			TM.Nome_Tp_Moeda	[Currency Type Name],
			P.Cd_Tp_Par			[Exchange Rates Type Code],
			TP.Nome_Tp_Par		[Exchange Rates Type Name],
			P.Par_Moeda			[Exchange Rates Value]				
		from Paridade P with(nolock)
			left Join Tipo_Moeda TM with(nolock) on P.Cd_Tp_Moeda = TM.Cd_Tp_Moeda
			left join Tipo_Paridade TP with(nolock) on P.Cd_Tp_Par = TP.Cd_Tp_Par
		where
			P.Dt_Par=@Dt_Par AND P.Cd_Tp_Moeda=@Cd_Tp_Moeda		
	End	

if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select 
			P.Dt_Par			[Exchange Rates Date],
			P.Cd_Tp_Moeda		[Currency Type Code],
			TM.Nome_Tp_Moeda	[Currency Type Name],
			P.Cd_Tp_Par			[Exchange Rates Type Code],
			TP.Nome_Tp_Par		[Exchange Rates Type Name],
			P.Par_Moeda			[Exchange Rates Value]				
		from Paridade P with(nolock)
			left Join Tipo_Moeda TM with(nolock) on P.Cd_Tp_Moeda = TM.Cd_Tp_Moeda
			left join Tipo_Paridade TP with(nolock) on P.Cd_Tp_Par = TP.Cd_Tp_Par
		where
			P.Dt_Par=@Dt_Par AND P.Cd_Tp_Moeda=@Cd_Tp_Moeda AND P.Cd_Tp_Par=@Cd_Tp_Par		
	End	
	



GO
