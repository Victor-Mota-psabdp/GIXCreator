SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--alter table [dbo].[solicitacao_li] add [ID_Regime] int NULL

CREATE Procedure [dbo].[spSolicitacaoLI_Sel]
		@Num_Solicitacao	Varchar(13)

AS


select 
	num_solicitacao,dt_solicitacao,nome_Tp_li Tipo_LI,num_proc Job,
	REQ.nome_usuario Requisitante, ope.nome_usuario Operador,Num_LI, DT_LI,Dt_Aut_Embarque,Dt_Deferimento,Dt_Vencimento,protocolo_transmissao,
	Motivo,Obs_LI,cast(id_status_li as varchar(2)) + ' - ' + Status_Li_Descricao Nome_Descricao ,
	PP.Apelido Fabricante, dt_Requerimento, Num_Requerimento,CobrancaCliente,
	cast(id_Regime_li as varchar(2)) + ' - ' + TR.Regime_Li_Descricao Regime_Li_Descricao,	
	GG.Apelido Grupo
from solicitacao_li SLI with(nolock)
	left Join Tipo_LI TL with(nolock)on id_tipo_li=id_tipo
	Left Join Usuario REQ with(nolock) on cd_usuario_req=REQ.cd_usuario
	Left Join Usuario OPE with(nolock) on cd_usuario_oper=OPE.cd_usuario
	Left Join Tipo_Status_LI TSL with(nolock) on id_status=ID_Status_LI
	Left Join Pessoa PP with(nolock) on PP.cd_pes=cd_fabricante
	Left join Tipo_Regime_LI TR with(nolock) on SLI.ID_Regime=TR.ID_Regime_LI
	Left Join Pessoa GG with(nolock) on GG.cd_pes=cd_grupo
Where
	Num_Solicitacao=@num_solicitacao


GO
