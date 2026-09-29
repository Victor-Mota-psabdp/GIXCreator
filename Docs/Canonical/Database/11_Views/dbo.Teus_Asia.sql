SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE    View Teus_Asia

AS

select 
	month(convert(datetime,mim.dt_atrac_mim,105))as Mes,Sh.Apelido Cliente,lc.Nome_local Origem, lca.nome_local Destino,count(ch.item_cont_im)as Teus,cd_tp_cont
from 
	house_imp_mar him 
	left join Pessoa SH on him.cd_Import_him = SH.cd_pes
	left join localidade lc on him.cd_org_him = lc.cd_local
	left join regiao rg on lc.cd_regiao = rg.cd_regiao
	left join master_imp_mar mim on him.num_proc_mim = mim.num_proc_mim 
	left join localidade lca on him.cd_dst_him = lca.cd_local
	left join container_mas_imp_mar cmim on mim.num_proc_mim = cmim.num_proc_mim
	lEFT jOIN container_hou_imp_mar ch on cmim.num_proc_mim=ch.num_proc_mim and cmim.item_cont_im=ch.item_cont_im 
where rg.cd_regiao = '006' and cmim.cd_tp_cont not in  ('LCL','LCM') and convert(datetime,dt_atrac_mim,105) >='01/01/2007'
group by month(convert(datetime,mim.dt_atrac_mim,105)), lc.Nome_local, lca.nome_local, Sh.Apelido,cd_tp_cont





GO
