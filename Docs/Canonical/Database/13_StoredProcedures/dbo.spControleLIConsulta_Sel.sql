SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spControleLIConsulta_Sel '%' ,'%','%',3,'2015-06-1','2015-06-02'

CREATE Procedure [dbo].[spControleLIConsulta_Sel]

	@ID_Status Char(1),
	@Grupo Varchar(25),
	@Destino	Varchar(30),
	@TipoData	int,
	@DataInicial	Datetime,
	@DataFinal	Datetime

	AS
--ETA=1
--ETD=2
--Dt.Solicitacao=3
--Dt L.I.=4
--Dt Vencimento=5

select 
	 
	'Marítimo' Modal,sl.num_solicitacao,convert(varchar(10),dt_solicitacao,103) dt_solicitacao,REQ.Nome_Usuario Requisitante,
	Nome_tp_li Tipo_LI,SL.Num_Proc,OPE.nome_usuario Operador,
	Num_LI,convert(varchar(10),Dt_LI,103) Dt_LI,convert(varchar(10),dt_deferimento,103) dt_deferimento ,convert(varchar(10),dt_aut_embarque,103)dt_aut_embarque ,
	convert(varchar(10),Dt_Vencimento,103) Dt_Vencimento, Protocolo_Transmissao,status_li_descricao Status,convert(varchar(10),ETD_LIM,103) ETD,
	convert(Varchar(10),ATD_LIM,103) ATD, convert(varchar(10),ETA_LiM,103) ETA, convert(varchar(10),ATA_LIM,103) ATA, CNTRY.Nome_Pais Pais_Origem,
	dbo.fBusca_HistoricoDescr_Completo(sl.num_solicitacao)  Historico, dbo.[F_BuscaOrgaoAnuente_Sel](SL.num_solicitacao) Orgao,
	dt_requerimento,num_requerimento, (Case when SL.Dt_LI < DA.Anexado_Em  then 'YES'else 'NO' end) [PDF(YES/NO)]
from 
	solicitacao_li SL With(Nolock)
	Join Usuario REQ With(Nolock) on REQ.cd_usuario=SL.cd_usuario_req
	Join Tipo_LI TL With(Nolock) on TL.id_tipo=id_Tipo_Li
	Left Join Usuario OPE With(Nolock) on OPE.cd_usuario=cd_usuario_oper
	Join tipo_status_li TSL With(Nolock) on TSL.id_status_li=SL.ID_STatus
	Join House_Imp_Mar Hou With(Nolock) on left(SL.num_proc,2)='IM' and hou.num_proc_him=SL.num_proc
	Join LLp_Imp_mar LLP With(Nolock) on left(SL.num_proc,2)='IM' and LLP.num_proc_lim=hou.num_proc_him  
	Join Localidade Org With(Nolock) on ORG.cd_local=cd_org_him
	join Pais CNTRY With(Nolock) on  CnTRY.cd_pais=org.cd_pais
	Join Pessoa_LLP PLLP With(Nolock) on PLLP.cd_pes=cd_consig_him
	Join Pessoa PP With(Nolock) on PP.cd_pes=cd_pes_grupo and desat_pes='N'
	Join Localidade DST With(Nolock) on DST.cd_local=cd_dst_him
	left join Doc_Anexos DA With(Nolock) on SL.Num_Proc = DA.Num_Proc and DA.Id_DC = 23
	--left Join vwBusca_HistoricoDescr_Completo HC with(nolock)on HC.HSGProcesso=sl.num_solicitacao
Where
--SL.Num_Proc = 'IMCSR201504274BR'
	(
		(@TipoData=1 and ETA_LIM between @DataInicial and @DataFinal)
		OR
		(@TipoData=2 and ETD_LIM between @DataInicial and @DataFinal)
		OR
		(@TipoData=3 and Dt_Solicitacao between @DataInicial and @DataFinal)
		OR
		(@TipoData=4 and DT_LI between @DataInicial and @DataFinal)
		OR
		(@TipoData=5 and DT_VEncimento between @DataInicial and @DataFinal)
	)
	and SL.ID_STatus like @ID_Status
	and apelido like @Grupo
	and dst.nome_local like @Destino
	--and left(SL.num_proc,2)='IM'
Group by 
	sl.num_solicitacao,dt_solicitacao,REQ.Nome_Usuario,
	Nome_tp_li ,SL.Num_Proc,OPE.nome_usuario,
	Num_LI,Dt_LI,dt_deferimento,dt_aut_embarque,Dt_Vencimento, Protocolo_Transmissao,status_li_descricao,ETD_LIM,
	ATD_LIM, ETA_LiM, ATA_LIM, CNTRY.Nome_Pais ,dt_requerimento,num_requerimento,(Case when SL.Dt_LI < DA.Anexado_Em  then 'YES'else 'NO' end)--,HC.HSDDescricao
	

UNION All
select 
	Distinct 'Aéreo' Modal,num_solicitacao,convert(varchar(10),dt_solicitacao,103)dt_solicitacao ,REQ.Nome_Usuario Requisitante,
	Nome_tp_li Tipo_LI,SL.Num_Proc,OPE.nome_usuario Operador,
	Num_LI,convert(varchar(10),Dt_LI,103) Dt_LI,convert(varchar(10),dt_deferimento,103) dt_deferimento ,convert(varchar(10),dt_aut_embarque,103)dt_aut_embarque ,
	convert(varchar(10),Dt_Vencimento,103) Dt_Vencimento, Protocolo_Transmissao,status_li_descricao Status,convert(varchar(10),ETD_lia,103) ETD,
	convert(Varchar(10),ATD_lia,103) ATD, convert(varchar(10),ETA_lia,103) ETA, convert(varchar(10),ATA_lia,103) ATA, CNTRY.Nome_Pais Pais_Origem,
	dbo.fBusca_HistoricoDescr_Completo(sl.num_solicitacao) Historico, dbo.[F_BuscaOrgaoAnuente_Sel](SL.num_solicitacao) Orgao,
	dt_requerimento,num_requerimento,(Case when SL.Dt_LI < DA.Anexado_Em  then 'YES'else 'NO' end)

from solicitacao_li SL With(Nolock)
	Join Usuario REQ With(Nolock) on REQ.cd_usuario=SL.cd_usuario_req
	Join Tipo_LI TL With(Nolock) on TL.id_tipo=id_Tipo_Li
	Left Join Usuario OPE With(Nolock) on OPE.cd_usuario=cd_usuario_oper
	Join tipo_status_li TSL With(Nolock) on TSL.id_status_li=SL.ID_STatus
	Join House_Imp_aer Hou With(Nolock) on left(SL.num_proc,2)='IA' and hou.num_proc_hia=SL.num_proc
	Join LLp_Imp_aer LLP With(Nolock) on left(SL.num_proc,2)='IA' and LLP.num_proc_lia=hou.num_proc_hia
	Join Localidade Org With(Nolock) on ORG.cd_local=cd_org_hia
	join Pais CNTRY With(Nolock) on CnTRY.cd_pais=org.cd_pais
	Join Pessoa_LLP PLLP With(Nolock) on PLLP.cd_pes=cd_consig_hia
	Join Pessoa PP With(Nolock) on PP.cd_pes=cd_pes_grupo  and desat_pes='N'
	Join Localidade DST With(Nolock) on DST.cd_local=cd_dst_hia
	left join Doc_Anexos DA With(Nolock) on SL.Num_Proc = DA.Num_Proc and DA.Id_DC = 23 --and SL.Dt_LI > DA.Anexado_Em
	--Left Join vwBusca_HistoricoDescr_Completo HC with(nolock)on HC.HSGProcesso=sl.num_solicitacao
Where

	(
		(@TipoData=1 and ETA_lia between @DataInicial and @DataFinal)
		OR
		(@TipoData=2 and ETD_lia between @DataInicial and @DataFinal)
		OR
		(@TipoData=3 and Dt_Solicitacao between @DataInicial and @DataFinal)
		OR
		(@TipoData=4 and DT_LI between @DataInicial and @DataFinal)
		OR
		(@TipoData=5 and DT_VEncimento between @DataInicial and @DataFinal)
	)
	and SL.ID_STatus like @ID_Status
	and apelido like @Grupo
	and dst.nome_local like @Destino
Group by 
	sl.num_solicitacao,dt_solicitacao,REQ.Nome_Usuario,
	Nome_tp_li ,SL.Num_Proc,OPE.nome_usuario,
	Num_LI,Dt_LI,dt_deferimento,dt_aut_embarque,Dt_Vencimento, Protocolo_Transmissao,status_li_descricao,ETD_LIA,
	ATD_LIA, ETA_LiA, ATA_LIA, CNTRY.Nome_Pais ,dt_requerimento,num_requerimento,(Case when SL.Dt_LI < DA.Anexado_Em  then 'YES'else 'NO' end)--,HC.HSDDescricao 



union ALL


select 
	Distinct
	'Others' Modal,num_solicitacao,convert(varchar(10),dt_solicitacao,103) ,REQ.Nome_Usuario Requisitante,
	Nome_tp_li Tipo_LI,SL.Num_Proc,OPE.nome_usuario Operador,
	Num_LI,convert(varchar(10),Dt_LI,103) Dt_LI,convert(varchar(10),dt_deferimento,103) dt_deferimento ,convert(varchar(10),dt_aut_embarque,103)dt_aut_embarque ,
	convert(varchar(10),Dt_Vencimento,103) Dt_Vencimento, Protocolo_Transmissao,status_li_descricao Status,convert(varchar(10),ETD_lio,103) ETD,
	convert(Varchar(10),ATD_lio,103) ATD, convert(varchar(10),ETA_lio,103) ETA, convert(varchar(10),ATA_lio,103) ATA, CNTRY.Nome_Pais Pais_Origem,
	dbo.fBusca_HistoricoDescr_Completo(sl.num_solicitacao) Historico, dbo.[F_BuscaOrgaoAnuente_Sel](SL.num_solicitacao) Orgao,
	dt_requerimento,num_requerimento,(Case when SL.Dt_LI < DA.Anexado_Em  then 'YES'else 'NO' end) [PDF(YES/NO)]

from solicitacao_li SL With(Nolock)
	Join Usuario REQ With(Nolock) on REQ.cd_usuario=SL.cd_usuario_req
	Join Tipo_LI TL With(Nolock) on TL.id_tipo=id_Tipo_Li
	Left Join Usuario OPE With(Nolock) on OPE.cd_usuario=cd_usuario_oper
	Join tipo_status_li TSL With(Nolock) on TSL.id_status_li=SL.ID_STatus
	Join House_Imp_out Hou With(Nolock) on hou.num_proc_hio=SL.num_proc
	Join LLp_Imp_out LLP With(Nolock) on LLP.num_proc_lio=hou.num_proc_hio
	Join Localidade Org With(Nolock) on ORG.cd_local=cd_org_hio
	join Pais CNTRY With(Nolock) on CnTRY.cd_pais=org.cd_pais
	Join Pessoa_LLP PLLP With(Nolock) on PLLP.cd_pes=cd_consig_hio
	Join Pessoa PP With(Nolock) on desat_pes='N' and PP.cd_pes=cd_pes_grupo   
	Join Localidade DST With(Nolock) on DST.cd_local=cd_dst_hio
	left join Doc_Anexos DA With(Nolock) on SL.Num_Proc = DA.Num_Proc --and DA.Id_DC = 23 and SL.Dt_LI > DA.Anexado_Em
	--Left Join vwBusca_HistoricoDescr_Completo HC with(nolock)on HC.HSGProcesso=sl.num_solicitacao
Where

	(
		(@TipoData=1 and ETA_lio between @DataInicial and @DataFinal)
		OR
		(@TipoData=2 and ETD_lio between @DataInicial and @DataFinal)
		OR
		(@TipoData=3 and Dt_Solicitacao between @DataInicial and @DataFinal)
		OR
		(@TipoData=4 and DT_LI between @DataInicial and @DataFinal)
		OR
		(@TipoData=5 and DT_VEncimento between @DataInicial and @DataFinal)
	)
	and SL.ID_STatus like @ID_Status
	and apelido like @Grupo
	and dst.nome_local like @Destino

Group by 
	sl.num_solicitacao,dt_solicitacao,REQ.Nome_Usuario,
	Nome_tp_li ,SL.Num_Proc,OPE.nome_usuario,
	Num_LI,Dt_LI,dt_deferimento,dt_aut_embarque,Dt_Vencimento, Protocolo_Transmissao,status_li_descricao,ETD_LIO,
	ATD_LIO, ETA_LiO, ATA_LIO, CNTRY.Nome_Pais,dt_requerimento,num_requerimento,(Case when SL.Dt_LI < DA.Anexado_Em  then 'YES'else 'NO' end)--,HC.HSDDescricao
OPTION (HASH JOIN)



GO
