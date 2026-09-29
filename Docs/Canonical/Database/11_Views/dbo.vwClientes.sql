SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
cREATE VIEW vwClientes 
as
Select Apelido,Cidade,UF,min(convert(datetime,dt_cheg_mia,105)) Primeiro, max(converT(datetime,dt_cheg_mia,105)) Ultimo
 from house_imp_aer HOU
Join Pessoa pp on pp.cd_pes=cd_consig_hia
Join Master_imp_aer mas on mas.num_proC_mia=hou.num_proc_mia
Join Endereco ED on Ed.cd_pes=pp.cd_pes and cd_tp_end='COM'
where convert(Datetime,dt_cheg_mia,105) between '01-01-2002' and '06-30-2006' and pais = 'Brasil'
GROUP by Apelido,Cidade,UF

UNION


Select Apelido,Cidade,UF,min(convert(datetime,dt_ATRAC_miM,105)), max(converT(datetime,dt_ATRAC_miM,105))
 from house_IMP_MAR HOU
Join Pessoa pp on pp.cd_pes=cd_consig_hiM
Join Master_imp_MAR mas on mas.num_proC_miM=hou.num_proc_miM
Join Endereco ED on Ed.cd_pes=pp.cd_pes and cd_tp_end='COM'
where convert(Datetime,dt_ATRAC_miM,105) between '01-01-2002' and '06-30-2006' and pais = 'Brasil'
GROUP by Apelido,Cidade,UF


GO
