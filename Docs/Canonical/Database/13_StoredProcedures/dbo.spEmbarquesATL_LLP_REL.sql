SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spEmbarquesATL_LLP_REL] --'2010-07-01','2011-06-01'

	@DataInicial	Varchar(10),
	@DataFinal		Varchar(10)

as
	
select 
	Isnull(ppl.apelido,pp.apelido) Cliente, month(Isnull(ATA_LIM,ETA_LIM)) Mes, 
	YEar(Isnull(ATA_LIM,ETA_LIM)) Ano, 'CHB' Tipo,num_proc_lim Emb,'IM' Modal,
	ORG.nome_local Origem,
	ORG.Pais_Local Pais_Origem, 
	DST.nome_local Destino,
	DST.Pais_Local Pais_Destino 
from 
	llp_imp_mar LLP
	Join House_imp_mar hou on hou.num_proc_him=llp.num_proc_lim
	Join Pessoa PP on PP.cd_pes=cd_consig_him
	Left Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_consig_him
	Left Join Pessoa PPL on PLLP.cd_pes_grupo=PPL.cd_pes
	left join Localidade ORG on ORG.Cd_Local = HOU.cd_org_him
	left join Localidade Dst on DST.cd_local = HOU.cd_dst_him
Where
	ATA_LIM between @DataInicial and @DataFinal or ETA_LIM between @DataInicial and @DataFinal
Group by 
	Isnull(ppl.apelido,pp.apelido) , month(Isnull(ATA_LIM,ETA_LIM)), 
	YEar(Isnull(ATA_LIM,ETA_LIM)), ORG.nome_local, DST.nome_local,num_proC_lim,
	ORG.Pais_Local,DST.Pais_Local

UNION

select 
	Isnull(ppl.apelido,pp.apelido) Cliente, month(Isnull(ATA_LIo,ETA_LIo)) Mes, 
	YEar(Isnull(ATA_LIO,ETA_LIo)) Ano, 'CHB' Tipo ,num_proc_lio Emb,'IO' Modal, 
	ORG.nome_local Origem,
	ORG.Pais_Local Pais_Origem, 
	DST.nome_local Destino,
	DST.Pais_Local Pais_Destino 
from 
	llp_imp_out LLP
	Join House_imp_out hou on hou.num_proc_hio=llp.num_proc_lio
	Join Pessoa PP on PP.cd_pes=cd_consig_hio
	Left Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_consig_hio
	Left Join Pessoa PPL on PLLP.cd_pes_grupo=PPL.cd_pes
	left join Localidade ORG on ORG.Cd_Local = HOU.cd_org_hio
	left join Localidade Dst on DST.cd_local = HOU.cd_dst_hio
Where
	ATA_LIO between @DataInicial and @DataFinal or ETA_LIO between @DataInicial and @DataFinal
Group by 
	Isnull(ppl.apelido,pp.apelido) , month(Isnull(ATA_LIO,ETA_LIO)), 
	YEar(Isnull(ATA_LIO,ETA_LIO)) ,ORG.nome_local, DST.nome_local, num_proc_lio,
	ORG.Pais_Local,DST.Pais_Local


UNION 


select 
	Isnull(ppl.apelido,pp.apelido) Cliente, month(Isnull(ATA_LIa,ETA_LIA)) Mes, 
	YEar(Isnull(ATA_LIA,ETA_LIA)) Ano, 'CHB' Tipo, num_proc_liA Emb,'IA' Modal,
	ORG.nome_local Origem,
	ORG.Pais_Local Pais_Origem, 
	DST.nome_local Destino,
	DST.Pais_Local Pais_Destino 
from 
	llp_imp_AER LLP
	Join House_imp_AER hou on hou.num_proc_hiA=llp.num_proc_liA
	Join Pessoa PP on PP.cd_pes=cd_consig_hiA
	Left Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_consig_hiA
	Left Join Pessoa PPL on PLLP.cd_pes_grupo=PPL.cd_pes
	left join Localidade ORG on ORG.Cd_Local = HOU.cd_org_hia
	left join Localidade Dst on DST.cd_local = HOU.cd_dst_hia
Where
	ATA_LIA between @DataInicial and @DataFinal or ETA_LIA between @DataInicial and @DataFinal
Group by 
	Isnull(ppl.apelido,pp.apelido) , month(Isnull(ATA_LIA,ETA_LIA)), 
	YEar(Isnull(ATA_LIA,ETA_LIA)) ,ORG.nome_local, DST.nome_local, num_proc_liA,
	ORG.Pais_Local,DST.Pais_Local


UNION


select 
	Isnull(ppl.apelido,pp.apelido) Cliente, month(Isnull(ATD_LEM,ETD_LEM)) Mes, 
	YEar(Isnull(ATD_LEM,ETD_LEM)) Ano, 'CHB' Tipo,num_proc_lEm Emb,'EM' Modal,
	ORG.nome_local Origem,
	ORG.Pais_Local Pais_Origem, 
	DST.nome_local Destino,
	DST.Pais_Local Pais_Destino 
from 
	llp_EXp_mar LLP
	Join House_EXp_mar hou on hou.num_proc_hEm=llp.num_proc_lEm
	Join Pessoa PP on PP.cd_pes=cd_EXPORT_hEm
	Left Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_EXPORT_hEm
	Left Join Pessoa PPL on PLLP.cd_pes_grupo=PPL.cd_pes
	left join Localidade ORG on ORG.Cd_Local = HOU.cd_org_hem
	left join Localidade Dst on DST.cd_local = HOU.cd_dst_hem
Where
	ATD_LEM between @DataInicial and @DataFinal or ETA_LEM between @DataInicial and @DataFinal
Group by 
	Isnull(ppl.apelido,pp.apelido) , month(Isnull(ATD_LEM,ETD_LEM)), 
	YEar(Isnull(ATD_LEM,ETD_LEM)) ,ORG.nome_local, DST.nome_local, num_proc_lEm,
	ORG.Pais_Local,DST.Pais_Local


UNION



select 
	Isnull(ppl.apelido,pp.apelido) Cliente, month(Isnull(ATD_LEO,ETD_LEO)) Mes, 
	YEar(Isnull(ATD_LEO,ETD_LEO)) Ano, 'CHB' Tipo,num_proc_lEO Emb,'EO' Modal,
	ORG.nome_local Origem,
	ORG.Pais_Local Pais_Origem, 
	DST.nome_local Destino,
	DST.Pais_Local Pais_Destino 
from 
	llp_EXp_OUT LLP
	Join House_EXp_OUT hou on hou.num_proc_hEO=llp.num_proc_lEO
	Join Pessoa PP on PP.cd_pes=cd_EXPORT_hEO
	Left Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_EXPORT_hEO
	Left Join Pessoa PPL on PLLP.cd_pes_grupo=PPL.cd_pes
	left join Localidade ORG on ORG.Cd_Local = HOU.cd_org_heo
	left join Localidade Dst on DST.cd_local = HOU.cd_dst_heo
Where
	ATD_LEO between @DataInicial and @DataFinal or ETA_LEO between @DataInicial and @DataFinal
Group by 
	Isnull(ppl.apelido,pp.apelido) , month(Isnull(ATD_LEO,ETD_LEO)), 
	YEar(Isnull(ATD_LEO,ETD_LEO)) ,ORG.nome_local, DST.nome_local, num_proc_lEO,
	ORG.Pais_Local,DST.Pais_Local


UNION




select 
	Isnull(ppl.apelido,pp.apelido) Cliente, month(Isnull(ATD_LEA,ETD_LEA)) Mes, 
	YEar(Isnull(ATD_LEA,ETD_LEA)) Ano, 'CHB' Tipo,num_proc_lEA Emb,'EA' Modal,
	ORG.nome_local Origem,
	ORG.Pais_Local Pais_Origem, 
	DST.nome_local Destino,
	DST.Pais_Local Pais_Destino 
from 
	llp_EXp_AER LLP
	Join House_EXp_AER hou on hou.num_proc_hEA=llp.num_proc_lEA
	Join Pessoa PP on PP.cd_pes=cd_EXPORT_hEA
	Left Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_EXPORT_hEA
	Left Join Pessoa PPL on PLLP.cd_pes_grupo=PPL.cd_pes
	left join Localidade ORG on ORG.Cd_Local = HOU.cd_org_hea
	left join Localidade Dst on DST.cd_local = HOU.cd_dst_hea
Where
	ATD_LEA between @DataInicial and @DataFinal or ETA_LEA between @DataInicial and @DataFinal
Group by 
	Isnull(ppl.apelido,pp.apelido) , month(Isnull(ATD_LEA,ETD_LEA)), 
	YEar(Isnull(ATD_LEA,ETD_LEA)) ,ORG.nome_local, DST.nome_local, num_proc_lEA,
	ORG.Pais_Local,DST.Pais_Local


union


select 
	pp.apelido Cliente, month(convert(Datetime,dt_atrac_mim,105))  Mes, 
	YEar(convert(Datetime,dt_atrac_mim,105)) Ano, 'Frete' Tipo,num_proc_him Emb,'IM' Modal,
	ORG.nome_local Origem,
	ORG.Pais_Local Pais_Origem, 
	DST.nome_local Destino,
	DST.Pais_Local Pais_Destino 
from 
	House_imp_mar HOU
	Join Master_Imp_MAR MAS on hou.num_proc_mim=mas.num_proc_mim
	Join Pessoa PP on PP.cd_pes=cd_consig_him
	left join Localidade ORG on ORG.Cd_Local = HOU.cd_org_him
	left join Localidade Dst on DST.cd_local = HOU.cd_dst_him
Where
	convert(Datetime,dt_atrac_mim,105) between @DataInicial and @DataFinal 
Group by 
	PP.Apelido , month((convert(Datetime,dt_atrac_mim,105))), 
	(YEar(convert(Datetime,dt_atrac_mim,105))) ,ORG.nome_local, DST.nome_local, num_proc_him,
	ORG.Pais_Local,DST.Pais_Local


union


select 
	pp.apelido Cliente, month(convert(Datetime,dt_cheg_mia,105))  Mes, 
	YEar(convert(Datetime,dt_cheg_mia,105)) Ano, 'Frete' Tipo, num_proc_hia Emb,'IA' Modal,
	ORG.nome_local Origem,
	ORG.Pais_Local Pais_Origem, 
	DST.nome_local Destino,
	DST.Pais_Local Pais_Destino 
from 
	House_imp_aer HOU
	Join Master_Imp_aer MAS on hou.num_proc_mia=mas.num_proc_mia
	Join Pessoa PP on PP.cd_pes=cd_consig_hia
	left join Localidade ORG on ORG.Cd_Local = HOU.cd_org_hia
	left join Localidade Dst on DST.cd_local = HOU.cd_dst_hia
Where
	convert(Datetime,dt_cheg_mia,105) between @DataInicial and @DataFinal 
Group by 
	PP.Apelido , month((convert(Datetime,dt_cheg_mia,105))), 
	(YEar(convert(Datetime,dt_cheg_mia,105))) ,ORG.nome_local, DST.nome_local, num_proc_hia,
	ORG.Pais_Local,DST.Pais_Local


union

select 
	pp.apelido Cliente, month(convert(Datetime,dt_saida_mem,105))  Mes, 
	YEar(convert(Datetime,dt_saida_mem,105)) Ano, 'Frete' Tipo, num_proc_hem Emb,'EM' Modal,
	ORG.nome_local Origem,
	ORG.Pais_Local Pais_Origem, 
	DST.nome_local Destino,
	DST.Pais_Local Pais_Destino 
from 
	House_exp_mar HOU
	Join Master_exp_MAR MAS on hou.num_proc_mem=mas.num_proc_mem
	Join Pessoa PP on PP.cd_pes=cd_export_hem
	left join Localidade ORG on ORG.Cd_Local = HOU.cd_org_hem
	left join Localidade Dst on DST.cd_local = HOU.cd_dst_hem
Where
	convert(Datetime,dt_saida_mem,105) between @DataInicial and @DataFinal 
Group by 
	PP.Apelido , month((convert(Datetime,dt_saida_mem,105))), 
	(YEar(convert(Datetime,dt_saida_mem,105))) ,ORG.nome_local, DST.nome_local, num_proc_hem,
	ORG.Pais_Local,DST.Pais_Local


union

select 
	pp.apelido Cliente, month(convert(Datetime,dt_saida_mea,105))  Mes, 
	YEar(convert(Datetime,dt_saida_mea,105)) Ano, 'Frete' Tipo, num_proc_hea Emb,'EA' Modal,
	ORG.nome_local Origem,
	ORG.Pais_Local Pais_Origem, 
	DST.nome_local Destino,
	DST.Pais_Local Pais_Destino 
from 
	House_exp_aer HOU
	Join Master_exp_aeR MAS on hou.num_proc_mea=mas.num_proc_mea
	Join Pessoa PP on PP.cd_pes=cd_export_hea
	left join Localidade ORG on ORG.Cd_Local = HOU.cd_org_hea
	left join Localidade Dst on DST.cd_local = HOU.cd_dst_hea
Where
	convert(Datetime,dt_saida_mea,105) between @DataInicial and @DataFinal 
Group by 
	PP.Apelido , month((convert(Datetime,dt_saida_mea,105))), 
	(YEar(convert(Datetime,dt_saida_mea,105))) ,ORG.nome_local, DST.nome_local, num_proc_hea,
	ORG.Pais_Local,DST.Pais_Local

order by 1



GO
