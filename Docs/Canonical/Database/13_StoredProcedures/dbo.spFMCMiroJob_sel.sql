SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spFMCMiroJob_sel]
	@Job varchar(16)
AS
	select ID_Miro ID,
		(Case
			when ID_Evento = 'C' Then 'C - Frete'
			when ID_Evento = 'F' Then 'F - Despesas Operacionais'
			when ID_Evento = 'I' Then 'I - Fatura'
			when ID_Evento = 'S' Then 'S - Seguro'
			when ID_Evento = 'T' Then 'T - Impostos'
			when ID_Evento = 'R' Then 'R - Impostos Recuperaveis'
			when ID_Evento = 'K' Then 'K - ICMS Complementar'
			when ID_Evento is NULL Then 'NOT Found'
		End) [Type],
		dt_envio [Sent],
		dt_retorno [Return], Closed, OBS
	from 
		fmc_miro 
	where 
		fatura_pc=@Job



GO
