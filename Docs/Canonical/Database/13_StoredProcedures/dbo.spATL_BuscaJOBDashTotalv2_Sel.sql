SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[spATL_BuscaJOBDashTotalv2_Sel]

as

--delete Modal_Dash

--insert INTO Modal_Dash (Modal,Tipo)values('Air Import','Correct')
--insert INTO Modal_Dash (Modal,Tipo)values('Air Import','Error')
--insert INTO Modal_Dash (Modal,Tipo)values('Sea Import','Correct')
--insert INTO Modal_Dash (Modal,Tipo)values('Sea Import','Error')


select ID_Regra, Nome_Regra, Descricao_Regra, Busca, Operador, Dias, Modal, Descr_Ingles  from JOB_Dash where Status = 1

GO
