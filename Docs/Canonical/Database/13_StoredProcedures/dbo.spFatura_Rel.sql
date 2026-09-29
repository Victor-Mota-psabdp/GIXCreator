SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure spFatura_Rel

	@Processo	varchar(16)

AS

select 
	hou.num_proc_mea Processo,nome_raz_soc Cliente,org.nome_Local Origem, 
	dst.nome_local Destino, convert(datetime,dt_saida_mea,105) Saida,
	Mawb_mea Master, HAWB_hea House

from 
	house_exp_aer HOU
	inner join pessoa PP on PP.cd_pes=HOU.cd_export_hea
	inner join localidade ORG on ORG.cd_local=HOU.cd_org_hea
	inner join localidade DST on DST.cd_local=HOU.cd_dst_hea
	inner join master_exp_aer MAS on MAS.num_proc_mea=HOU.num_proc_mea

Where 
	num_proc_hea=@processo

GO
