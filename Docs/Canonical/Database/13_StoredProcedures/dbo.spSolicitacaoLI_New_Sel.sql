SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--alter table [dbo].[solicitacao_li] add [ID_Regime] int NULL
CREATE Procedure [dbo].[spSolicitacaoLI_New_Sel]--'IMOXT201907042BR'
(
		@Num_Proc	Varchar(16)
)

AS


select 
	sli.num_solicitacao,dt_solicitacao,nome_Tp_li Tipo_LI,Num_LI,DT_LI,Dt_Aut_Embarque,Dt_Deferimento,Dt_Vencimento,
	cast(id_status_li as varchar(2)) + ' - ' + Status_Li_Descricao Nome_Descricao ,
	cast(id_Regime_li as varchar(2)) + ' - ' + TR.Regime_Li_Descricao Regime_Li_Descricao,
	O.Nome_Orgao_Anuente,ope.nome_usuario Operador, 
	Motivo,Obs_LI,CobrancaCliente,	
	GG.Apelido Grupo,
	Doc.Item_Doc,doc.Nome_Arquivo
from solicitacao_li SLI with(nolock)
	left Join Tipo_LI TL with(nolock)on id_tipo_li=id_tipo
	Left Join Usuario REQ with(nolock) on cd_usuario_req=REQ.cd_usuario
	Left Join Usuario OPE with(nolock) on cd_usuario_oper=OPE.cd_usuario
	Left Join Tipo_Status_LI TSL with(nolock) on id_status=ID_Status_LI
	Left Join Pessoa PP with(nolock) on PP.cd_pes=cd_fabricante
	Left join Tipo_Regime_LI TR with(nolock) on SLI.ID_Regime=TR.ID_Regime_LI
	Left Join Pessoa GG with(nolock) on GG.cd_pes=cd_grupo
	left join Solicitacao_LI_Orgao_Anuente SO on SO.Num_Solicitacao = SLI.Num_Solicitacao
	left join Orgao_Anuente O on O.ID_Orgao = SO.ID_Orgao_Anuente
	left join Doc_Anexos Doc on Doc.Num_Proc = SLI.Num_Solicitacao and Id_DC = 23
Where
	SLI.Num_Proc=@Num_Proc 
	and SLI.Num_Proc <> ''


GO
