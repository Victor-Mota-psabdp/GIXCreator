SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spEmbarquesLLP_REL]--'2014-01-01','2014-12-31'
		--@DataInicial	Varchar(10),
		--@DataFinal		Varchar(10)
		@DataInicial	Datetime,
		@DataFinal		Datetime

as

select 
	Nome_Local Localidade,Isnull(ppl.apelido,pp.apelido) Cliente, month(Isnull(ATA_LIM,ETA_LIM)) Mes, 
	YEar(Isnull(ATA_LIM,ETA_LIM)) Ano, 'CHB-IMP' Tipo,count(num_proc_lim) Emb,'CHB-IMP' Modal
from 
	llp_imp_mar LLP
	Join House_imp_mar hou on hou.num_proc_him=llp.num_proc_lim
	Join Pessoa PP on PP.cd_pes=cd_consig_him
	Left Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_consig_him
	Left Join Pessoa PPL on PLLP.cd_pes_grupo=PPL.cd_pes
	Join Localidade Org on Org.cd_local=Cd_dst_him
Where
	((ATA_LIM between @DataInicial and @DataFinal) or (ATA_LIM is null and ETA_LIM between @DataInicial and @DataFinal))
	and (dbo.fBusca_CampoCliente(num_proc_lim,32) is null or dbo.fBusca_CampoCliente(num_proc_lim,32)=1 and substring(num_proc_lim,3,3) <> 'ATL')
		
Group by 
	Isnull(ppl.apelido,pp.apelido) , month(Isnull(ATA_LIM,ETA_LIM)), 
	YEar(Isnull(ATA_LIM,ETA_LIM)) ,nome_local

UNION

select 
	Nome_Local, Isnull(ppl.apelido,pp.apelido) Cliente, month(Isnull(ATA_LIo,ETA_LIo)) Mes, 
	YEar(Isnull(ATA_LIO,ETA_LIo)) Mes, 'CHB-IMP' Tipo,count(num_proc_lio) Emb,'CHB-IMP' Modal
from 
	llp_imp_out LLP
	Join House_imp_out hou on hou.num_proc_hio=llp.num_proc_lio
	Join Pessoa PP on PP.cd_pes=cd_consig_hio
	Left Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_consig_hio
	Left Join Pessoa PPL on PLLP.cd_pes_grupo=PPL.cd_pes
	LEft Join Localidade DST on DST.cd_local=cd_dst_hio
Where
	ATA_LIO between @DataInicial and @DataFinal or ETA_LIO between @DataInicial and @DataFinal
	and (dbo.fBusca_CampoCliente(num_proc_lio,32) is null or dbo.fBusca_CampoCliente(num_proc_lio,32)=1)
Group by 
	Isnull(ppl.apelido,pp.apelido) , month(Isnull(ATA_LIO,ETA_LIO)), 
	YEar(Isnull(ATA_LIO,ETA_LIO)),Nome_Local


UNION 


select 
	Nome_Local, Isnull(ppl.apelido,pp.apelido) Cliente, month(Isnull(ATA_LIa,ETA_LIA)) Mes, 
	YEar(Isnull(ATA_LIA,ETA_LIA)) Mes, 'CHB-IMP' Tipo,count(num_proc_liA) Emb,'CHB-IMP' Modal
from 
	llp_imp_AER LLP
	Join House_imp_AER hou on hou.num_proc_hiA=llp.num_proc_liA
	Join Pessoa PP on PP.cd_pes=cd_consig_hiA
	Left Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_consig_hiA
	Left Join Pessoa PPL on PLLP.cd_pes_grupo=PPL.cd_pes
	Join Localidade DST on DST.cd_local=cd_dst_hia
Where
	ATA_LIA between @DataInicial and @DataFinal or ETA_LIA between @DataInicial and @DataFinal
	and (dbo.fBusca_CampoCliente(num_proc_lia,32) is null or dbo.fBusca_CampoCliente(num_proc_lia,32)=1)

Group by 
	Isnull(ppl.apelido,pp.apelido) , month(Isnull(ATA_LIA,ETA_LIA)), 
	YEar(Isnull(ATA_LIA,ETA_LIA)) ,Nome_Local


UNION


select 
	Nome_Local,Isnull(ppl.apelido,pp.apelido) Cliente, month(Isnull(ATD_LEM,ETD_LEM)) Mes, 
	YEar(Isnull(ATD_LEM,ETD_LEM)) Mes, 'CHB-EXP' Tipo,count(num_proc_lEm) Emb,'CHB-EXP' Modal
from 
	llp_EXp_mar LLP
	Join House_EXp_mar hou on hou.num_proc_hEm=llp.num_proc_lEm
	Join Pessoa PP on PP.cd_pes=cd_EXPORT_hEm
	Left Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_EXPORT_hEm
	Left Join Pessoa PPL on PLLP.cd_pes_grupo=PPL.cd_pes
	Join Localidade DST on DST.cd_local=cd_org_hem
Where
	ATD_LEM between @DataInicial and @DataFinal or ETA_LEM between @DataInicial and @DataFinal
	and (dbo.fBusca_CampoCliente(num_proc_lem,32) is null or dbo.fBusca_CampoCliente(num_proc_lem,32)=1)

Group by 
	Isnull(ppl.apelido,pp.apelido) , month(Isnull(ATD_LEM,ETD_LEM)), 
	YEar(Isnull(ATD_LEM,ETD_LEM)) ,Nome_Local


UNION



select 
	Nome_Local,Isnull(ppl.apelido,pp.apelido) Cliente, month(Isnull(ATD_LEO,ETD_LEO)) Mes, 
	YEar(Isnull(ATD_LEO,ETD_LEO)) Mes, 'CHB-EXP-Rod' Tipo,count(num_proc_lEO) Emb,'CHB-EXP-Rod' Modal
from 
	llp_EXp_OUT LLP
	Join House_EXp_OUT hou on hou.num_proc_hEO=llp.num_proc_lEO
	Join Pessoa PP on PP.cd_pes=cd_EXPORT_hEO
	Left Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_EXPORT_hEO
	Left Join Pessoa PPL on PLLP.cd_pes_grupo=PPL.cd_pes
	Join Localidade Org on org.cd_local=cd_org_heo
Where
	ATD_LEO between @DataInicial and @DataFinal or ETA_LEO between @DataInicial and @DataFinal
	and (dbo.fBusca_CampoCliente(num_proc_leo,32) is null or dbo.fBusca_CampoCliente(num_proc_leo,32)=1)

Group by 
	Isnull(ppl.apelido,pp.apelido) , month(Isnull(ATD_LEO,ETD_LEO)), 
	YEar(Isnull(ATD_LEO,ETD_LEO)) , Nome_Local


UNION




select 
	Nome_Local,Isnull(ppl.apelido,pp.apelido) Cliente, month(Isnull(ATD_LEA,ETD_LEA)) Mes, 
	YEar(Isnull(ATD_LEA,ETD_LEA)) Mes, 'CHB-EXP-Rod' Tipo,count(num_proc_lEA) Emb,'CHB-EXP-Rod' Modal
from 
	llp_EXp_AER LLP
	Join House_EXp_AER hou on hou.num_proc_hEA=llp.num_proc_lEA
	Join Pessoa PP on PP.cd_pes=cd_EXPORT_hEA
	Left Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_EXPORT_hEA
	Left Join Pessoa PPL on PLLP.cd_pes_grupo=PPL.cd_pes
	Join Localidade ORg on Org.cd_local=cd_org_hea
Where
	ATD_LEA between @DataInicial and @DataFinal or ETA_LEA between @DataInicial and @DataFinal
	and (dbo.fBusca_CampoCliente(num_proc_lea,32) is null or dbo.fBusca_CampoCliente(num_proc_lea,32)=1)

Group by 
	Isnull(ppl.apelido,pp.apelido) , month(Isnull(ATD_LEA,ETD_LEA)), 
	YEar(Isnull(ATD_LEA,ETD_LEA)) , Nome_Local


union


select 
	Nome_Local,pp.apelido Cliente, month(convert(Datetime,dt_atrac_mim,105))  Mes, 
	YEar(convert(Datetime,dt_atrac_mim,105)) Mes, 'Frete' Tipo,count(num_proc_him) Emb,'IM' Modal
from 
	House_imp_mar HOU
	Join Master_Imp_MAR MAS on hou.num_proc_mim=mas.num_proc_mim
	Join Pessoa PP on PP.cd_pes=cd_consig_him
	Join Localidade DST on DST.cd_local=cd_dst_him
	Left Join LLP_Imp_MAr LLP on LLP.num_proc_lim=hou.num_proc_him
Where
	convert(Datetime,dt_atrac_mim,105) between @DataInicial and @DataFinal 
	and left(mas.num_proc_mim,5) <> 'IMCLI'
	and num_proc_lim is null
Group by 
	PP.Apelido , month((convert(Datetime,dt_atrac_mim,105))), 
	(YEar(convert(Datetime,dt_atrac_mim,105))), Nome_Local

union


select 
	Nome_Local,pp.apelido Cliente, month(convert(Datetime,dt_cheg_mia,105))  Mes, 
	YEar(convert(Datetime,dt_cheg_mia,105)) Mes, 'Frete' Tipo,count(num_proc_hia) Emb,'IA' Modal
from 
	House_imp_aer HOU
	Join Master_Imp_aer MAS on hou.num_proc_mia=mas.num_proc_mia
	Join Pessoa PP on PP.cd_pes=cd_consig_hia
	Join Localidade DST on DST.cd_local=cd_dst_hia
Where
	convert(Datetime,dt_cheg_mia,105) between @DataInicial and @DataFinal 
	and left(mas.num_proc_mia,5) <> 'IACLI'

Group by 
	PP.Apelido , month((convert(Datetime,dt_cheg_mia,105))), 
	(YEar(convert(Datetime,dt_cheg_mia,105))) ,nome_local


union

select 
	Nome_Local,pp.apelido Cliente, month(convert(Datetime,dt_saida_mem,105))  Mes, 
	YEar(convert(Datetime,dt_saida_mem,105)) Mes, 'Frete' Tipo,count(num_proc_hem) Emb,'EM' Modal
from 
	House_exp_mar HOU
	Join Master_exp_MAR MAS on hou.num_proc_mem=mas.num_proc_mem
	Join Pessoa PP on PP.cd_pes=cd_export_hem
	Join Localidade DST on DST.cd_local=cd_org_hem
Where
	convert(Datetime,dt_saida_mem,105) between @DataInicial and @DataFinal 
Group by 
	PP.Apelido , month((convert(Datetime,dt_saida_mem,105))), 
	(YEar(convert(Datetime,dt_saida_mem,105))) , Nome_Local


union

select 
	Nome_Local,pp.apelido Cliente, month(convert(Datetime,dt_saida_mea,105))  Mes, 
	YEar(convert(Datetime,dt_saida_mea,105)) Mes, 'Frete' Tipo,count(num_proc_hea) Emb,'EA' Modal
from 
	House_exp_aer HOU
	Join Master_exp_aeR MAS on hou.num_proc_mea=mas.num_proc_mea
	Join Pessoa PP on PP.cd_pes=cd_export_hea
	Join Localidade Org on org.cd_local=cd_org_hea
Where
	convert(Datetime,dt_saida_mea,105) between @DataInicial and @DataFinal 
Group by 
	PP.Apelido , month((convert(Datetime,dt_saida_mea,105))), 
	(YEar(convert(Datetime,dt_saida_mea,105))) , Nome_Local


union 


select 
	Nome_Local Localidade,Isnull(ppl.apelido,pp.apelido) Cliente, month(Isnull(ATA_LIM,ETA_LIM)) Mes, 
	YEar(Isnull(ATA_LIM,ETA_LIM)) Ano, 'Frete' Tipo,count(num_proc_lim) Emb,'CHB-IMP' Modal
from 
	llp_imp_mar LLP
	Join House_imp_mar hou on hou.num_proc_him=llp.num_proc_lim
	Join Pessoa PP on PP.cd_pes=cd_consig_him
	Left Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_consig_him
	Left Join Pessoa PPL on PLLP.cd_pes_grupo=PPL.cd_pes
	Join Localidade Org on Org.cd_local=Cd_dst_him
Where
	((ATA_LIM between @DataInicial and @DataFinal) or (ATA_LIM is null and ETA_LIM between @DataInicial and @DataFinal))
	and (dbo.fBusca_CampoCliente(num_proc_lim,32)<>1)
		
Group by 
	Isnull(ppl.apelido,pp.apelido) , month(Isnull(ATA_LIM,ETA_LIM)), 
	YEar(Isnull(ATA_LIM,ETA_LIM)) ,nome_local










GO
