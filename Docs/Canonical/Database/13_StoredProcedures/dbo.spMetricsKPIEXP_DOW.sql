SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









CREATE Procedure [dbo].[spMetricsKPIEXP_DOW]
	@ano	varchar(4),
	@referencia	Varchar(5)
as



select 
	distinct Num_proc_lem Job,num_pedido, null OrderType,'Marítimo' Modal, 
	Isnull(right(cm.cd_tp_cont,1),nome_tp_Carga) Dispatch,nome_tp_carga,Numero_PO_hem,org.nome_local Origem, dst.nome_local Destino,convert(varchar(10),atd_lem,103) ATD, 
	convert(varchar(10),dt_conclusao,103) Doc_Sent, dbo.quantidade_dias(atd_lem,dt_conclusao) Dias,Canal_lem,business_group_descr, Business_Descr, '' Planta,
	Isnull(Form_A,'N') Form_A,pa.cd_pais,cast((Dt_Conclusao - ATD_LEM) as int) As Dias_corridos,cd_planta
from house_exp_mar HOU
Join LLP_exp_MAr LLP on LLP.num_proc_lem=hou.num_proc_hem
Join Localidade ORG on ORG.cd_local=cd_org_hem
Join Localidade DST on DST.cd_local=cd_dst_hem
Left Join Pedido_Ship PS on PS.num_proc=num_proc_lem
Left Join Produto_Cliente PC on PC.cd_prod=PS.cd_produto
Left Join De_ParA_PRoduto DPP on DPP.gmid=cd_proc_cliente
Left Join tarefas_processos TP on TP.num_proc=num_proc_lem and id_task=12
Join Tipo_Carga TC on TC.cd_tp_carga=LLP.cd_tp_carga
Left Join Container_hou_exp_mar CH on num_proc_lem=CH.num_proc_hem
Left Join Container_mas_exp_mar CM on CH.num_proc_mem=CM.num_proc_mem and CH.item_cont_em=CM.item_cont_em
Left Join Pedido PD on PD.cd_pedido=PS.cd_pedido
Left Join PO_hem LI on num_proc_lem=li.num_proc_hem and id_dc=23
Join Pais PA on PA.cd_pais=DST.cd_pais
Join Pessoa_LLP PP on PP.cd_pes=cd_export_hem
Where atd_lem is not null
and substring(num_proc_lem,3,3) in ('CSR','ROB','STB') and year(atd_lem)=@ano

UNION



select 
	distinct Num_proc_leo Job,num_pedido, null OrderType,'Rodoviário', 
	'Truck','LCL' ,Numero_PO_heo,ORG.Nome_Local Origem, dst.nome_local Destino,convert(varchar(10),atd_leo,103) ATA, 
	convert(varchar(10),dt_conclusao,103) Desembaraco, dbo.quantidade_dias(atd_leo,dt_conclusao),Canal_leo,business_group_descr, Business_Descr, '' Planta,
	'N' Form_A,PA.cd_pais, cast((Dt_Conclusao - ATD_LEo) as int) as Dias_corridos,cd_planta
from house_exp_out HOU
Join LLP_exp_out LLP on LLP.num_proc_leo=hou.num_proc_heo
Join Localidade ORG on ORG.cd_local=cd_org_heo
Join Localidade DST on DST.cd_local=cd_dst_heo
Left Join Pedido_Ship PS on PS.num_proc=num_proc_leo
Left Join Produto_Cliente PC on PC.cd_prod=PS.cd_produto
Left Join De_ParA_PRoduto DPP on DPP.gmid=cd_proc_cliente
Left Join tarefas_processos TP on TP.num_proc=num_proc_leo and id_task=12
Left Join Pedido PD on PD.cd_pedido=PS.cd_pedido
Left Join PO_heo LI on num_proc_leo=li.num_proc_heo and id_dc=23
Join Pais PA on PA.cd_pais=DST.cd_pais
Join Pessoa_LLP PP on PP.cd_pes=cd_export_heo

Where atd_leo is not null
and Tipo_leo='T'
and left(num_proc_leo,5) like @referencia	
and year(atd_leo)=@ano

UNION

select 
	distinct Num_proc_leo Job,num_pedido, null OrderType,'Ferroviário', 
	'Rail','LCL' ,Numero_PO_heo,Org.nome_local Origem, Dst.Nome_Local Destino,convert(varchar(10),atd_leo,103) ATA, 
	convert(varchar(10),dt_conclusao,103) Desembaraco, dbo.quantidade_dias(atd_leo,dt_conclusao),Canal_leo,business_group_descr, Business_Descr, '' Planta,
	'N' Form_A,PA.cd_pais, cast((Dt_Conclusao - ATD_LEo) as int) as DIas,Cd_Planta
from house_exp_out HOU
Join LLP_exp_out LLP on LLP.num_proc_leo=hou.num_proc_heo
Join Localidade ORG on ORG.cd_local=cd_org_heo
Join Localidade DST on DST.cd_local=cd_dst_heo
Left Join Pedido_Ship PS on PS.num_proc=num_proc_leo
Left Join Produto_Cliente PC on PC.cd_prod=PS.cd_produto
Left Join De_ParA_PRoduto DPP on DPP.gmid=cd_proc_cliente
Left Join tarefas_processos TP on TP.num_proc=num_proc_leo and id_task=12
Left Join Pedido PD on PD.cd_pedido=PS.cd_pedido
Left Join PO_heo LI on num_proc_leo=li.num_proc_heo and id_dc=23
Join Pais PA on PA.cd_pais=DST.cd_pais
Join Pessoa_LLP PP on PP.cd_pes=cd_export_heo

Where ATD_LEO is not null
and Tipo_leo='R'
and substring(num_proc_leo,3,3) in ('CSR','ROB','STB')	
and year(atd_leo)=@ano

union

select 
	distinct Num_proc_lea Job,num_pedido, null OrderType,'Aéreo', 
	'Air','LCL' ,Numero_PO_hea,ORG.nome_local Origem, dst.nome_local Destino,convert(varchar(10),atd_lea,103) ATA, 
	convert(varchar(10),dt_conclusao,103) Desembaraco, dbo.quantidade_dias(atd_lea,dt_conclusao),Canal_lea,business_group_descr, Business_Descr , '' Planta,
	Isnull(Form_A,'N') Form_A,PA.cd_pais, cast((Dt_Conclusao - ATD_LEA) as int) as DIas,cd_planta
from house_exp_aer HOU
Join LLP_exp_aer LLP on LLP.num_proc_lea=hou.num_proc_hea
Join Localidade ORG on ORG.cd_local=cd_org_hea
Join Localidade DST on DST.cd_local=cd_dst_hea
Left Join Pedido_Ship PS on PS.num_proc=num_proc_lea
Left Join Produto_Cliente PC on PC.cd_prod=PS.cd_produto
Left Join De_ParA_PRoduto DPP on DPP.gmid=cd_proc_cliente
Left Join tarefas_processos TP on TP.num_proc=num_proc_lea and id_task=12
Left Join Pedido PD on PD.cd_pedido=PS.cd_pedido
Left Join PO_hea LI on num_proc_lea=li.num_proc_hea and id_dc=23
Join Pais PA on PA.cd_pais=DST.cd_pais
Join Pessoa_LLP PP on PP.cd_pes=cd_export_hea

Where ATD_LEA is not null
and substring(num_proc_lea,3,3) in ('CSR','ROB','STB')
and year(atd_lea)=@ano









GO
