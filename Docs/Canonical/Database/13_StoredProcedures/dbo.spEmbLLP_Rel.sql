SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure spEmbLLP_Rel
	@Num_Proc	Varchar(16)
as

select 
	MAWB_hIM,HAWB_HIM,Org.Nome_Local Origem, Dst.Nome_Local Destino,PP.Apelido Importador, 
	PE.Apelido Exportador,eta_lim ETA,etd_LIM ETD,ata_LIM ATA,atd_LIM ATD, Navio_HIM Navio,
	Viagem_HIM Viagem, cd_proc_cliente, Produto_Descr, 'Marítimo' Modal, HOU.num_proc_him JOB
from 
	house_imp_mar HOU
	Join Pedido_Ship PS on Hou.num_proc_him=ps.num_proc
	Join Localidade Org on Org.cd_local=cd_org_him
	Join Localidade Dst on Dst.cd_local=cd_dst_him
	Join Pedido PD on PD.cd_pedido=ps.cd_pedido
	join Pessoa PP on PP.cd_pes=cd_import_him
	Join Pessoa PE on PE.cd_pes=cd_export_him
	Join LLP_Imp_Mar LLP on LLP.num_proc_lim=hou.num_proC_him
	Join Produto_Cliente PC on PC.cd_prod=PS.cd_produto	
where
	hou.num_proc_him like @Num_proc

union


select 
	MAWB_hem,HAWB_hem,Org.Nome_Local Origem, Dst.Nome_Local Destino,PP.Apelido exportador, 
	PE.Apelido Exportador,eta_lem ETA,etd_lem ETD,ata_lem ATA,atd_lem ATD, Navio_hem Navio,
	Viagem_hem Viagem, cd_proc_cliente, Produto_Descr, 'Marítimo' Modal, HOU.num_proc_hem JOB
from 
	house_exp_mar HOU
	Join Pedido_Ship PS on Hou.num_proc_hem=ps.num_proc
	Join Localidade Org on Org.cd_local=cd_org_hem
	Join Localidade Dst on Dst.cd_local=cd_dst_hem
	Join Pedido PD on PD.cd_pedido=ps.cd_pedido
	join Pessoa PP on PP.cd_pes=cd_export_hem
	Join Pessoa PE on PE.cd_pes=cd_export_hem
	Join LLP_exp_Mar LLP on LLP.num_proc_lem=hou.num_proC_hem
	Join Produto_Cliente PC on PC.cd_prod=PS.cd_produto	
where
	hou.num_proc_hem like @Num_proc
union

select 
	MAWB_hia,HAWB_hia,Org.Nome_Local Origem, Dst.Nome_Local Destino,PP.Apelido Importador, 
	PE.Apelido Exportador,eta_lia ETA,etd_lia ETD,ata_lia ATA,atd_lia ATD, Null Navio,
	Voo_Hia Viagem, cd_proc_cliente, Produto_Descr, 'Aéreo' Modal, HOU.num_proc_hia JOB
from 
	house_imp_aer HOU
	Join Pedido_Ship PS on Hou.num_proc_hia=ps.num_proc
	Join Localidade Org on Org.cd_local=cd_org_hia
	Join Localidade Dst on Dst.cd_local=cd_dst_hia
	Join Pedido PD on PD.cd_pedido=ps.cd_pedido
	join Pessoa PP on PP.cd_pes=cd_import_hia
	Join Pessoa PE on PE.cd_pes=cd_export_hia
	Join LLP_Imp_aer LLP on LLP.num_proc_lia=hou.num_proC_hia
	Join Produto_Cliente PC on PC.cd_prod=PS.cd_produto	
where
	hou.num_proc_hia like @Num_proc

union


select 
	MAWB_hea,HAWB_hea,Org.Nome_Local Origem, Dst.Nome_Local Destino,PP.Apelido exportador, 
	PE.Apelido Exportador,eta_lea ETA,etd_lea ETD,ata_lea ATA,atd_lea ATD, Null Navio,
	Voo_hea Viagem, cd_proc_cliente, Produto_Descr, 'Marítimo' Modal, HOU.num_proc_hea JOB
from 
	house_exp_aer HOU
	Join Pedido_Ship PS on Hou.num_proc_hea=ps.num_proc
	Join Localidade Org on Org.cd_local=cd_org_hea
	Join Localidade Dst on Dst.cd_local=cd_dst_hea
	Join Pedido PD on PD.cd_pedido=ps.cd_pedido
	join Pessoa PP on PP.cd_pes=cd_export_hea
	Join Pessoa PE on PE.cd_pes=cd_export_hea
	Join LLP_exp_aer LLP on LLP.num_proc_lea=hou.num_proC_hea
	Join Produto_Cliente PC on PC.cd_prod=PS.cd_produto	
where
	hou.num_proc_hea like @Num_proc

union

select 
	MAWB_hio,HAWB_hio,Org.Nome_Local Origem, Dst.Nome_Local Destino,PP.Apelido Importador, 
	PE.Apelido Exportador,eta_lio ETA,etd_lio ETD,ata_lio ATA,atd_lio ATD, Null Navio,
	Voo_Hio Viagem, cd_proc_cliente, Produto_Descr, Tipo_Lio Modal, HOU.num_proc_hio JOB
from 
	house_imp_out HOU
	Join Pedido_Ship PS on Hou.num_proc_hio=ps.num_proc
	Join Localidade Org on Org.cd_local=cd_org_hio
	Join Localidade Dst on Dst.cd_local=cd_dst_hio
	Join Pedido PD on PD.cd_pedido=ps.cd_pedido
	join Pessoa PP on PP.cd_pes=cd_import_hio
	Join Pessoa PE on PE.cd_pes=cd_export_hio
	Join LLP_Imp_out LLP on LLP.num_proc_lio=hou.num_proC_hio
	Join Produto_Cliente PC on PC.cd_prod=PS.cd_produto	
where
	hou.num_proc_hio like @Num_proc

union

select 
	MAWB_heo,HAWB_heo,Org.Nome_Local Origem, Dst.Nome_Local Destino,PP.Apelido exportador, 
	PE.Apelido Exportador,eta_leo ETA,etd_leo ETD,ata_leo ATA,atd_leo ATD, NULL Navio,
	Voo_Heo Viagem, cd_proc_cliente, Produto_Descr, Tipo_Leo Modal, HOU.num_proc_heo JOB
from 
	house_exp_out HOU
	Join Pedido_Ship PS on Hou.num_proc_heo=ps.num_proc
	Join Localidade Org on Org.cd_local=cd_org_heo
	Join Localidade Dst on Dst.cd_local=cd_dst_heo
	Join Pedido PD on PD.cd_pedido=ps.cd_pedido
	join Pessoa PP on PP.cd_pes=cd_export_heo
	Join Pessoa PE on PE.cd_pes=cd_export_heo
	Join LLP_exp_out LLP on LLP.num_proc_leo=hou.num_proC_heo
	Join Produto_Cliente PC on PC.cd_prod=PS.cd_produto	
where
	hou.num_proc_heo like @Num_proc


GO
