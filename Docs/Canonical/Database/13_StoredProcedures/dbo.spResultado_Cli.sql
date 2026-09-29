SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE    procedure spResultado_Cli --'11-01-2007','11-30-2007','
		(
		@DataInicial Char(10),
		@DataFinal Char(10),		
		@Cliente Varchar(40)
	)

AS

Select 
	Apelido, dt_cheg_mia Data, org.nome_local Origem, dst.nome_local Destino,
	Num_proC_hia Processo,cast(dbo.spresultado(hou.num_proc_hia) as decimal(10,2)) Valor 
from 
	house_imp_aer HOU
	Join pessoa pp on pp.cd_pes=cd_import_hia
	Join master_imp_aer Mas on mas.num_proc_mia=hou.num_proc_mia
	Join Localidade Org on Org.cd_local=cd_org_hia
	Join Localidade DST on DST.cd_local=cd_dst_hia
Where 
	convert(Datetime,dt_cheg_mia,105) between @DataInicial and @DataFinal
	and apelido like @cliente
UNION



Select 
	Apelido, dt_saida_mea, org.nome_local Origem, dst.nome_local Destino,
	Num_proC_hEa,cast(dbo.spresultado(hou.num_proc_hEa) as Decimal(10,2))  Valor 
from 
	house_exp_aer HOU
	Join pessoa pp on pp.cd_pes=cd_export_hea
	Join master_exp_aer Mas on mas.num_proc_mea=hou.num_proc_mea
	Join Localidade Org on Org.cd_local=cd_org_hea
	Join Localidade DST on DST.cd_local=cd_dst_hea
Where 
	convert(Datetime,dt_saida_mea,105) between @DataInicial and @DataFinal
	and apelido like @cliente

UNION 

Select 
	Apelido, dt_ATRAC_MIM Data, org.nome_local Origem, dst.nome_local Destino,
	Num_proC_HIM Processo, cast(dbo.spresultado(hou.num_proc_HIM) as Decimal(10,2)) Valor 
from 
	house_imp_MAR HOU
	Join pessoa pp on pp.cd_pes=cd_import_HIM
	Join master_imp_MAR Mas on mas.num_proc_MIM=hou.num_proc_MIM
	Join Localidade Org on Org.cd_local=cd_org_HIM
	Join Localidade DST on DST.cd_local=cd_dst_HIM
Where 
	convert(Datetime,dt_ATRAC_MIM,105) between @DataInicial and @DataFinal
	and apelido like @cliente
UNION



Select 
	Apelido, dt_saida_MEM, org.nome_local Origem, dst.nome_local Destino,
	Num_proC_HEM,cast(dbo.spresultado(hou.num_proc_HEM) as decimal(10,2)) Valor 
from 
	house_exp_MAR HOU
	Join pessoa pp on pp.cd_pes=cd_export_HEM
	Join master_exp_MAR Mas on mas.num_proc_MEM=hou.num_proc_MEM
	Join Localidade Org on Org.cd_local=cd_org_HEM
	Join Localidade DST on DST.cd_local=cd_dst_HEM
Where 
	convert(Datetime,dt_saida_MEM,105) between @DataInicial and @DataFinal
	and apelido like @cliente





GO
