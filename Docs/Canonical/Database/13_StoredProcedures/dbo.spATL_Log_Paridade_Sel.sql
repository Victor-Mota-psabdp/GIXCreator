SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Log_Paridade
CREATE procedure [dbo].[spATL_Log_Paridade_Sel]
(
	@ID_Log			bigint,
	@Tp_Oper		varchar(1),
	@Dt_Par			varchar(10),
	@Cd_Tp_Moeda	varchar(3),
	@Cd_Tp_Par		varchar(3),
	@Tipo			char(1)
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
			P.ID_Log				[Log ID],
			P.Dt_Ins				[Log Date],
			P.Tp_Oper				[Log Type Code],
			ALT.Nome_Tp_Log_Oper	[Log Type Name],

			P.Dt_Par			[Exchange Rates Date],
			P.Cd_Tp_Moeda		[Currency Type Code],
			TM.Nome_Tp_Moeda	[Currency Type Name],
			P.Cd_Tp_Par			[Exchange Rates Type Code],
			TP.Nome_Tp_Par		[Exchange Rates Type Name],
			P.Par_Moeda			[Exchange Rates Value]						
		from Log_Paridade P with(nolock)
			left Join Tipo_Moeda TM with(nolock) on P.Cd_Tp_Moeda = TM.Cd_Tp_Moeda
			left join Tipo_Paridade TP with(nolock) on P.Cd_Tp_Par = TP.Cd_Tp_Par
			left join Tipo_Log_Oper	Alt	with(nolock) on Alt.Cd_tp_Log_Oper	= P.Tp_Oper
		where
			P.ID_Log = @ID_Log		
	End	

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select 
			P.ID_Log				[Log ID],
			P.Dt_Ins				[Log Date],
			P.Tp_Oper				[Log Type Code],
			ALT.Nome_Tp_Log_Oper	[Log Type Name],

			P.Dt_Par			[Exchange Rates Date],
			P.Cd_Tp_Moeda		[Currency Type Code],
			TM.Nome_Tp_Moeda	[Currency Type Name],
			P.Cd_Tp_Par			[Exchange Rates Type Code],
			TP.Nome_Tp_Par		[Exchange Rates Type Name],
			P.Par_Moeda			[Exchange Rates Value]						
		from Log_Paridade P with(nolock)
			left Join Tipo_Moeda TM with(nolock) on P.Cd_Tp_Moeda = TM.Cd_Tp_Moeda
			left join Tipo_Paridade TP with(nolock) on P.Cd_Tp_Par = TP.Cd_Tp_Par
			left join Tipo_Log_Oper	Alt	with(nolock) on Alt.Cd_tp_Log_Oper	= P.Tp_Oper
		where
			P.Dt_Par=@Dt_Par AND P.Cd_Tp_Moeda=@Cd_Tp_Moeda	
		
	End	

if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select 
			P.ID_Log				[Log ID],
			P.Dt_Ins				[Log Date],
			P.Tp_Oper				[Log Type Code],
			ALT.Nome_Tp_Log_Oper	[Log Type Name],

			P.Dt_Par			[Exchange Rates Date],
			P.Cd_Tp_Moeda		[Currency Type Code],
			TM.Nome_Tp_Moeda	[Currency Type Name],
			P.Cd_Tp_Par			[Exchange Rates Type Code],
			TP.Nome_Tp_Par		[Exchange Rates Type Name],
			P.Par_Moeda			[Exchange Rates Value]						
		from Log_Paridade P with(nolock)
			left Join Tipo_Moeda TM with(nolock) on P.Cd_Tp_Moeda = TM.Cd_Tp_Moeda
			left join Tipo_Paridade TP with(nolock) on P.Cd_Tp_Par = TP.Cd_Tp_Par
			left join Tipo_Log_Oper	Alt	with(nolock) on Alt.Cd_tp_Log_Oper	= P.Tp_Oper
		where
			P.Dt_Par=@Dt_Par AND P.Cd_Tp_Moeda=@Cd_Tp_Moeda AND P.Cd_Tp_Par=@Cd_Tp_Par		
	End	
	



GO
