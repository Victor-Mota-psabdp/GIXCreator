SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure spExp_Rel 

	@datainicial 	varchar(10),
	@datafinal 	varchar(10)

AS

select 
	org.nome_local as Origem,dst.nome_local as Destino, 
	Navio_hem, viagem_hem, convert(datetime,dt_saida_mem,105) as DtSaida, 
	mawb_mem, ship.apelido as Shipper, consig.apelido as Consignee, 
	nome_armador, nome_tp_cont, count(nome_tp_cont) as Qty,peso_bruto_hem, 
	peso_liquido_hem,Vol_Tot_HEM  

from 
	
	house_exp_mar as hou

inner join localidade as org on (org.cd_local=hou.cd_org_hem)
inner join localidade as dst on (dst.cd_local=hou.cd_dst_hem)
inner join pessoa as ship on (ship.cd_pes=hou.cd_export_hem)
inner join pessoa as consig on (consig.cd_pes=hou.cd_consig_hem)
inner join masteR_exp_mar as mas on (mas.num_proc_mem=hou.num_proc_mem)
inner join armador as arm on (arm.cd_armador=mas.cd_armador)
inner join container_hou_exp_mar as ch on (ch.num_proc_hem=hou.num_proc_hem)
inner join container_mas_exp_mar as cm on (cm.num_proc_mem=ch.num_proc_mem and cm.item_cont_em=ch.item_cont_em)
inner join tipo_container as tc on (tc.cd_tp_cont=cm.cd_tp_cont)

where 
	convert(datetime, dt_saida_mem, 105) between convert(datetime, @datainicial, 105)  and convert(datetime, @datafinal, 105)

group by org.nome_local,dst.nome_local, Navio_hem, viagem_hem, dt_saida_mem, mawb_mem, ship.apelido, consig.apelido, nome_armador, nome_tp_cont, peso_bruto_hem, peso_liquido_hem,Vol_Tot_HEM 


GO
