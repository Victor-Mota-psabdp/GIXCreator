SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   Procedure spMovExpMar
	@datainicial varchar(10),
	@datafinal  varchar(10),
	@pais       varchar(20)

AS

select 
	org.nome_local as Origem, dst.nome_local as Destino,navio_hem,viagem_hem, 
	convert(datetime,dt_saida_mem,105) as ETD, mawb_mem,hawb_hem, pp.apelido as Shipper, 
	imp.apelido as Importador, nome_armador, cd_arm_ofc, 
	count(nome_tp_cont) as TipoContainer,nome_tp_cont,Peso_bruto_hem,Peso_liquido_hem,vol_tot_hem 

from 
	house_exp_mar as hou

inner join localidade as org on (org.cd_local=cd_org_hem)
inner join localidade as dst on (dst.cd_local=cd_dst_hem)
inner join masteR_exP_mar as mas on (mas.num_proc_mem=hou.num_proc_mem)
inner join pessoa as pp on (pp.cd_pes=hou.cd_export_hem)
inner join pessoa as imp on (imp.cd_pes=hou.cD_consig_hem)
inner join armador as arm on (arm.cd_armador=mas.cd_armador)
inner join container_mas_exp_mar as cm on (cm.num_proc_mem=mas.num_proc_mem)
inner join tipo_container as tc on (cm.cd_tp_Cont=tc.cd_tp_cont)
inner join container_hou_exp_mar as ch on (ch.num_proc_mem=cm.num_proc_mem and ch.item_cont_em=cm.item_cont_em)

where 
	dst.pais_local like @pais and convert(datetime,dt_saida_mem,105) between convert(datetime, @datainicial,105) and convert(datetime, @datafinal,105) and mawb_mem <> 'JOB'

group 
	by org.nome_local, dst.nome_local,navio_hem,viagem_hem, dt_saida_mem,mawb_mem,hawb_hem,pp.apelido , imp.apelido , nome_armador, cd_arm_ofc, nome_tp_cont, Peso_bruto_hem,Peso_liquido_hem,vol_tot_hem







GO
