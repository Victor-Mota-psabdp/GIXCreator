SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_BuscaJOBDashTotal_Sel]

as

delete Modal_Dash

insert INTO Modal_Dash (Modal,Tipo)values('Air Import','Correct')
insert INTO Modal_Dash (Modal,Tipo)values('Air Import','Error')
insert INTO Modal_Dash (Modal,Tipo)values('Sea Import','Correct')
insert INTO Modal_Dash (Modal,Tipo)values('Sea Import','Error')


select ID_Regra, Nome_Regra, Descricao_Regra, Busca, Operador, Dias, Modal  from JOB_Dash where Status = 1

GO
