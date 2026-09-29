SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE  Procedure [dbo].[spEmbarquesLLPClientes_REL] --'01-01-2009','06-30-2009'
		@DataInicial	Varchar(10),
		@DataFinal		Varchar(10)

as

Delete  temp_ReportVolume_Anual

insert into temp_ReportVolume_Anual(Nome_Cliente, Modal,Localidade)

select 
	Isnull(ppl.apelido,pp.apelido) Cliente,	'CHB' Tipo,Nome_local
from 
	llp_imp_mar LLP
	Join House_imp_mar hou on hou.num_proc_him=llp.num_proc_lim
	Join Pessoa PP on PP.cd_pes=cd_consig_him
	Left Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_consig_him
	Left Join Pessoa PPL on PLLP.cd_pes_grupo=PPL.cd_pes
	Join Localidade DST on DST.cd_local=cd_dst_him
Where
	ATA_LIM between @DataInicial and @DataFinal or ETA_LIM between @DataInicial and @DataFinal

UNION

select 
	Isnull(ppl.apelido,pp.apelido) Cliente, 'CHB' Tipo,Nome_Local
from 
	llp_imp_out LLP
	Join House_imp_out hou on hou.num_proc_hio=llp.num_proc_lio
	Join Pessoa PP on PP.cd_pes=cd_consig_hio
	Left Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_consig_hio
	Left Join Pessoa PPL on PLLP.cd_pes_grupo=PPL.cd_pes
	Join Localidade DST on DST.cd_local=cd_Dst_hio
Where
	ATA_LIO between @DataInicial and @DataFinal or ETA_LIO between @DataInicial and @DataFinal

UNION 


select 
	Isnull(ppl.apelido,pp.apelido) Cliente, 'CHB' Tipo, Nome_Local
from 
	llp_imp_AER LLP
	Join House_imp_AER hou on hou.num_proc_hiA=llp.num_proc_liA
	Join Pessoa PP on PP.cd_pes=cd_consig_hiA
	Left Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_consig_hiA
	Join Localidade DST on DST.cd_local=cd_dst_hia
	Left Join Pessoa PPL on PLLP.cd_pes_grupo=PPL.cd_pes
Where
	ATA_LIA between @DataInicial and @DataFinal or ETA_LIA between @DataInicial and @DataFinal


UNION


select 
	Isnull(ppl.apelido,pp.apelido) Cliente,'CHB' Tipo,Nome_Local
from 
	llp_EXp_mar LLP
	Join House_EXp_mar hou on hou.num_proc_hEm=llp.num_proc_lEm
	Join Pessoa PP on PP.cd_pes=cd_EXPORT_hEm
	Left Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_EXPORT_hEm
	Left Join Pessoa PPL on PLLP.cd_pes_grupo=PPL.cd_pes
	Join Localidade Org on ORg.cd_local=cd_org_hem
Where
	ATD_LEM between @DataInicial and @DataFinal or ETA_LEM between @DataInicial and @DataFinal


UNION



select 
	Isnull(ppl.apelido,pp.apelido) Cliente,  'CHB' Tipo,Nome_Local
from 
	llp_EXp_OUT LLP
	Join House_EXp_OUT hou on hou.num_proc_hEO=llp.num_proc_lEO
	Join Pessoa PP on PP.cd_pes=cd_EXPORT_hEO
	Left Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_EXPORT_hEO
	Left Join Pessoa PPL on PLLP.cd_pes_grupo=PPL.cd_pes
	Join Localidade Org on org.cd_local=cd_org_heo
Where
	ATD_LEO between @DataInicial and @DataFinal or ETA_LEO between @DataInicial and @DataFinal
Group by 
	Isnull(ppl.apelido,pp.apelido) , month(Isnull(ATD_LEO,ETD_LEO)), 
	YEar(Isnull(ATD_LEO,ETD_LEO)) , nome_local


UNION




select 
	Isnull(ppl.apelido,pp.apelido) Cliente, 'CHB' Tipo, Nome_Local
from 
	llp_EXp_AER LLP
	Join House_EXp_AER hou on hou.num_proc_hEA=llp.num_proc_lEA
	Join Pessoa PP on PP.cd_pes=cd_EXPORT_hEA
	Left Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_EXPORT_hEA
	Left Join Pessoa PPL on PLLP.cd_pes_grupo=PPL.cd_pes
	Join Localidade Org on org.cd_local=cd_org_hea
Where
	ATD_LEA between @DataInicial and @DataFinal or ETA_LEA between @DataInicial and @DataFinal


union


select 
	pp.apelido Cliente, 'IM' Tipo,Nome_Local
from 
	House_imp_mar HOU
	Join Master_Imp_MAR MAS on hou.num_proc_mim=mas.num_proc_mim
	Join Pessoa PP on PP.cd_pes=cd_consig_him
	Join Localidade DST on DST.cd_local=cd_dst_him
Where

	convert(Datetime,dt_atrac_mim,105) between @DataInicial and @DataFinal 
	and left(mas.num_proc_mim,5) <> 'IMCLI'


union


select 
	pp.apelido Cliente, 'IA' Tipo,Nome_Local
from 
	House_imp_aer HOU
	Join Master_Imp_aer MAS on hou.num_proc_mia=mas.num_proc_mia
	Join Pessoa PP on PP.cd_pes=cd_consig_hia
	Join Localidade DST on DST.cd_local=cd_dst_hia
Where
	convert(Datetime,dt_cheg_mia,105) between @DataInicial and @DataFinal 
	and left(mas.num_proc_mia,5) <> 'IACLI'

union

select 
	pp.apelido Cliente, 'EM' Tipo,Nome_local
from 
	House_exp_mar HOU
	Join Master_exp_MAR MAS on hou.num_proc_mem=mas.num_proc_mem
	Join Pessoa PP on PP.cd_pes=cd_export_hem
	Join Localidade DST on DST.cd_local=cd_org_hem
Where
	convert(Datetime,dt_saida_mem,105) between @DataInicial and @DataFinal 


union

select 
	pp.apelido Cliente, 'EA' Tipo, Nome_Local
from 
	House_exp_aer HOU
	Join Master_exp_aeR MAS on hou.num_proc_mea=mas.num_proc_mea
	Join Pessoa PP on PP.cd_pes=cd_export_hea
	Join Localidade DST on DST.cd_local=cd_org_hea
Where
	convert(Datetime,dt_saida_mea,105) between @DataInicial and @DataFinal 






GO
