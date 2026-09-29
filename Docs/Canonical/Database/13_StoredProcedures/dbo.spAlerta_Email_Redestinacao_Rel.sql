SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spAlerta_Email_Redestinacao_Rel]

AS

select 
	cd_pes_grupo, 
	A.id_tp_alerta,
	dia,
	diaFim,
	email, 
	email_cc,
	Mensagem,
	stored,
	nome_tp_alerta 
from [dbo].[Alerta_Email_Redestinacao] A
	join  [dbo].[Tipo_Alerta_Redestinacao] T on T.id_tp_alerta = A.Id_tp_alerta
Where
	A.status = 1
	and A.id_tp_alerta = 3
order by 
	ID_TP_Alerta,dia
GO
