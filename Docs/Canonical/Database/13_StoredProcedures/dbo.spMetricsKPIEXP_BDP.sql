SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


---spMetricsKPIEXP_BDP '2010','FMC'

--spMetricsKPIEXP_BDP '2010','FMC'

CREATE Procedure [dbo].[spMetricsKPIEXP_BDP] --'2009'
	@ano	varchar(4),
	@Referencia	Varchar(3)
as
Declare @Smart Varchar(20)

Set @smart=(select top 1 smart_exp from grupo where grupo=@referencia)

select 
	distinct Num_proc_lem Job,num_pedido, null OrderType,'Marítimo' Modal, 
	Isnull(right(cm.cd_tp_cont,1),nome_tp_Carga) Dispatch,nome_tp_carga,li.Numero_PO_hem,org.nome_local Origem, dst.nome_local Destino,convert(varchar(10),atd_lem,103) ATD, 
	convert(varchar(10),dt_conclusao,103) CCD, dbo.quantidade_dias(atd_lem,dt_conclusao) Dias,Canal_lem,business_group_descr, Business_Descr, '' Planta,
	Isnull(Form_A,'N') Form_A,pa.cd_pais,cast((Dt_Conclusao - ATD_LEM) as int) As Dias_corridos,
	RE.NUMERO_po_hem RE, RE.Data_PO_HEM Data_RE, 
	Convert(Datetime,dt_emis_hem,105) Data_Criacao,Cast(RE.DATA_PO_HEM-convert(Datetime,dt_emis_hem,105) as Int) Dias_RE_C,
	dbo.fbusca_tarefa(num_proc_lem,12) Doc_Sent,
	dbo.fbusca_tarefa(num_proc_lem,40) Prestacao,
	dbo.fbusca_tarefa(num_proc_lem,5) Booking,
	convert(Datetime,dt_emis_hem,105) Dt_Ins,
	dbo.fbusca_tarefa(num_proc_lem,66) Draft,
	cast(dbo.fBusca_TipoDocCliente ('D',num_proc_lem,13) as datetime) Cert_Origem,
	Nome_Regiao, dbo.fbusca_tarefa(num_proc_lem,58) Sol_Booking,dbo.fbusca_tarefa(num_proc_lem,50) Rec_Processo,
	dbo.fbusca_tarefa(num_proc_lem,58) Sol_Booking,dbo.fbusca_tarefa(num_proc_lem,97) Form_A,dbo.fbusca_tarefa(num_proc_lem,21) Lib_BL

	
from house_exp_mar HOU
Join LLP_exp_MAr LLP on LLP.num_proc_lem=hou.num_proc_hem
Join Localidade ORG on ORG.cd_local=cd_org_hem
Join Localidade DST on DST.cd_local=cd_dst_hem
Left Join Pedido_Ship PS on PS.num_proc=num_proc_lem
Left Join PO_HEM RE on RE.num_proc_hem=num_proc_lem and RE.ID_DC=4
Left Join Produto_Cliente PC on PC.cd_prod=PS.cd_produto
Left Join De_ParA_PRoduto DPP on DPP.gmid=cd_proc_cliente
Left Join tarefas_processos TP on TP.num_proc=num_proc_lem and id_task=4
Join Tipo_Carga TC on TC.cd_tp_carga=LLP.cd_tp_carga
Left Join Container_hou_exp_mar CH on num_proc_lem=CH.num_proc_hem
Left Join Container_mas_exp_mar CM on CH.num_proc_mem=CM.num_proc_mem and CH.item_cont_em=CM.item_cont_em
Left Join Pedido PD on PD.cd_pedido=PS.cd_pedido
Left Join PO_hem LI on num_proc_lem=li.num_proc_hem and li.id_dc=23
Left Join PO_hem IV on num_proc_lem=iV.num_proc_hem and iV.id_dc=2
Left Join Pais PA on PA.cd_pais=DST.cd_pais
Left Join Regiao RG on DST.cd_regiao=RG.cd_regiao

Where 
	atd_lem is not null
	and right(left(num_proc_lem,5),3) in (select grupo from grupo where smart_exp=@Smart	)
	and year(atd_lem)=@ano

UNION



select 
	distinct Num_proc_leo Job,num_pedido, null OrderType,'Rodoviário', 
	'Truck','LCL' ,LI.Numero_PO_heo,ORG.Nome_Local Origem, dst.nome_local Destino,convert(varchar(10),atd_leo,103) ATA, 
	convert(varchar(10),dt_conclusao,103) Desembaraco, dbo.quantidade_dias(atd_leo,dt_conclusao),Canal_leo,business_group_descr, Business_Descr, '' Planta,
	'N' Form_A,PA.cd_pais, cast((Dt_Conclusao - ATD_LEo) as int) as Dias_corridos,
	RE.NUMERO_po_heo RE, RE.Data_PO_HEo Data_RE, 
	Convert(Datetime,dt_emis_heO,105) Data_Criacao,Cast(RE.DATA_PO_HEO-convert(Datetime,dt_emis_heO,105) as Int) Dias_RE_C,
	dbo.fbusca_tarefa(num_proc_leO,12),
		dbo.fbusca_tarefa(num_proc_leo,40) Prestacao,
	dbo.fbusca_tarefa(num_proc_leo,5) Booking,
	convert(Datetime,dt_emis_heo,105) Dt_Ins,
	Null Draft,
	cast(dbo.fBusca_TipoDocCliente ('D',num_proc_leo,13) as datetime) Cert_Origem,Nome_regiao,
	null, dbo.fbusca_tarefa(num_proc_leo,50) Rec_Processo,null,null,null




from house_exp_out HOU
Join LLP_exp_out LLP on LLP.num_proc_leo=hou.num_proc_heo
Join Localidade ORG on ORG.cd_local=cd_org_heo
Join Localidade DST on DST.cd_local=cd_dst_heo
Left Join Pedido_Ship PS on PS.num_proc=num_proc_leo
Left Join Produto_Cliente PC on PC.cd_prod=PS.cd_produto
Left Join De_ParA_PRoduto DPP on DPP.gmid=cd_proc_cliente
Left Join tarefas_processos TP on TP.num_proc=num_proc_leo and id_task=4
Left Join Pedido PD on PD.cd_pedido=PS.cd_pedido
Left Join PO_heo LI on num_proc_leo=li.num_proc_heo and li.id_dc=23
Join Pais PA on PA.cd_pais=DST.cd_pais
Left Join PO_HEo RE on RE.num_proc_heo=num_proc_leo and RE.ID_DC=4
--Left Join PO_heo IV on num_proc_leo=iV.num_proc_heo and iV.id_dc=2
	Left Join Regiao RG on DST.cd_regiao=RG.cd_regiao

Where atd_leo is not null
and Tipo_leo='T'
and right(left(num_proc_leo,5),3) in (select grupo from grupo where smart_exp=@Smart)
and year(atd_leo)=@ano

UNION

select 
	distinct Num_proc_leo Job,num_pedido, null OrderType,'Ferroviário', 
	'Rail','LCL' ,li.Numero_PO_heo,Org.nome_local Origem, Dst.Nome_Local Destino,convert(varchar(10),atd_leo,103) ATA, 
	convert(varchar(10),dt_conclusao,103) Desembaraco, dbo.quantidade_dias(atd_leo,dt_conclusao),Canal_leo,business_group_descr, Business_Descr, '' Planta,
	'N' Form_A,PA.cd_pais, cast((Dt_Conclusao - ATD_LEo) as int) as DIas,
	RE.NUMERO_po_heo RE, RE.Data_PO_HEo Data_RE, 
	Convert(Datetime,dt_emis_heO,105) Data_Criacao,Cast(RE.DATA_PO_HEO-convert(Datetime,dt_emis_heO,105) as Int) Dias_RE_C,
	dbo.fbusca_tarefa(num_proc_leO,12),
	dbo.fbusca_tarefa(num_proc_leo,40) Prestacao,
	dbo.fbusca_tarefa(num_proc_leo,5) Booking,
	convert(Datetime,dt_emis_heo,105) Dt_Ins,
	null,
	cast(dbo.fBusca_TipoDocCliente ('D',num_proc_leo,13) as datetime) Cert_Origem,
	Nome_Regiao, null, dbo.fbusca_tarefa(num_proc_leo,50) Rec_Processo,null,null,null




from house_exp_out HOU
Join LLP_exp_out LLP on LLP.num_proc_leo=hou.num_proc_heo
Join Localidade ORG on ORG.cd_local=cd_org_heo
Join Localidade DST on DST.cd_local=cd_dst_heo
Left Join Pedido_Ship PS on PS.num_proc=num_proc_leo
Left Join Produto_Cliente PC on PC.cd_prod=PS.cd_produto
Left Join De_ParA_PRoduto DPP on DPP.gmid=cd_proc_cliente
Left Join tarefas_processos TP on TP.num_proc=num_proc_leo and id_task=4
Left Join Pedido PD on PD.cd_pedido=PS.cd_pedido
Left Join PO_heo LI on num_proc_leo=li.num_proc_heo and li.id_dc=23
Join Pais PA on PA.cd_pais=DST.cd_pais
Left Join PO_HEO RE on RE.num_proc_heo=num_proc_leo and RE.ID_DC=4
Left Join PO_heo IV on num_proc_leo=iV.num_proc_heo and iV.id_dc=2
Left Join Regiao RG on DST.cd_regiao=RG.cd_regiao

Where ATD_LEO is not null
and Tipo_leo='R'
and right(left(num_proc_leo,5),3) in (select grupo from grupo where smart_exp=@Smart)
and year(atd_leo)=@ano

union

select 
	distinct Num_proc_lea Job,num_pedido, null OrderType,'Aéreo', 
	'Air','LCL' ,li.Numero_PO_hea,ORG.nome_local Origem, dst.nome_local Destino,convert(varchar(10),atd_lea,103) ATA, 
	convert(varchar(10),dt_conclusao,103) Desembaraco, dbo.quantidade_dias(atd_lea,dt_conclusao),Canal_lea,business_group_descr, Business_Descr , '' Planta,
	Isnull(Form_A,'N') Form_A,PA.cd_pais, cast((Dt_Conclusao - ATD_LEA) as int) as DIas,
	RE.NUMERO_po_hea RE, RE.Data_PO_HEa Data_RE, 
	Convert(Datetime,dt_emis_heA,105) Data_Criacao,Cast(RE.DATA_PO_HEA-convert(Datetime,dt_emis_heA,105) as Int) Dias_RE_C,
	dbo.fbusca_tarefa(num_proc_leA,12),
	dbo.fbusca_tarefa(num_proc_lea,40) Prestacao,
	dbo.fbusca_tarefa(num_proc_lea,5) Booking,
	convert(Datetime,dt_emis_hea,105) Dt_Ins,
	null,
	cast(dbo.fBusca_TipoDocCliente ('D',num_proc_lea,13) as datetime) Cert_Origem,
	Nome_regiao, null, dbo.fbusca_tarefa(num_proc_lea,50) Rec_Processo,null,null,null




from house_exp_aer HOU
Join LLP_exp_aer LLP on LLP.num_proc_lea=hou.num_proc_hea
Join Localidade ORG on ORG.cd_local=cd_org_hea
Join Localidade DST on DST.cd_local=cd_dst_hea
Left Join Pedido_Ship PS on PS.num_proc=num_proc_lea
Left Join Produto_Cliente PC on PC.cd_prod=PS.cd_produto
Left Join De_ParA_PRoduto DPP on DPP.gmid=cd_proc_cliente
Left Join tarefas_processos TP on TP.num_proc=num_proc_lea and id_task=4
Left Join Pedido PD on PD.cd_pedido=PS.cd_pedido
Left Join PO_hea LI on num_proc_lea=li.num_proc_hea and li.id_dc=23
Join Pais PA on PA.cd_pais=DST.cd_pais
Left Join PO_HEA RE on RE.num_proc_hea=num_proc_lea and RE.ID_DC=4
Left Join PO_HEA IV on IV.num_proc_hea=num_proc_lea and IV.ID_DC=2
	Left Join Regiao RG on DST.cd_regiao=RG.cd_regiao

Where 
	ATD_LEA is not null
and right(left(num_proc_lea,5),3) in (select grupo from grupo where smart_exp=@Smart)
and year(atd_lea)=@ano




















GO
