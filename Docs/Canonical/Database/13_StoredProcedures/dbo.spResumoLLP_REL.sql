SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure spResumoLLP_REL
		@Num_Proc	Varchar(16)
as
select 
	Num_Proc_Him, ETA_LIM,ETD_LIM,convert(datetime,dt_saida_him,105) Data_Saida,convert(datetime,dt_cheg_him,105) Data_Chegada,
	Planta_Org.Nome_Local Planta, Origem.Nome_Local Origem, Destino.Nome_Local Destino, Destino_Final.Nome_Local Destino_Final,
	MAWB_HIM Master,HAWB_HIM House,hou.num_proc_him Processo,Seller.apelido Seller, Buyer.Apelido Buyer
from 
	house_imp_mar Hou

	Join Pessoa Buyer on Buyer.cd_pes=cd_consig_him
	Join Pessoa Seller on Seller.cd_pes=cd_export_him
	Join LLP_Imp_Mar LLP on LLP.num_proc_lim=hou.num_proc_him
	Left Join Localidade Planta_Org on Planta_Org.cd_local=cd_planta_lim
	Left Join Localidade Origem on Origem.cd_local=cd_org_him
	Left Join Localidade Destino on Destino.cd_local=cd_dst_him
	Left Join Localidade Destino_Final on Destino_final.cd_local=cd_dstfinal_lim
where
	num_proc_him=@Num_Proc


GO
