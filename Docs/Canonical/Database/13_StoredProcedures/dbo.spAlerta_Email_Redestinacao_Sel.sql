SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spAlerta_Email_Redestinacao_Sel]-- ''
	
AS

	select 
		P.Apelido		[Grupo],
		M.Nome_TP_Alerta [Tipo Alerta],		
		E.DIA			[Dia],
		E.DIAFIM			[DiaFim],
		E.Email			[Para],
		E.Email_CC		[Copia],
		E.Mensagem		[Mensagem],
		E.Status		[Ativo],
		U.Nome_Usuario	[Usuario],
		M.Regra			[Regra]
	from Alerta_Email_Redestinacao E
		join Pessoa P on P.cd_pes = E.cd_pes_grupo
		join Tipo_Alerta_Redestinacao M on M.id_tp_alerta = E.id_tp_alerta
		join Usuario U on U.Cd_Usuario = E.	Cd_Usuario
	order by 
		P.Apelido				
	

		
		




GO
