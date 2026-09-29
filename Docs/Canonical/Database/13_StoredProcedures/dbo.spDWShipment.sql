SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spDWShipment] --'01-01-2009','12-31-2009'

		@DataInicial	Datetime,
		@DataFinal		Datetime

AS


select 
	Nome_Raz_Soc,convert(Datetime,dt_cheg_mia,105) Dt_Ship,num_proc_hia,'IA' Modal
from 
	House_imp_aer HOU
	Join Pessoa PP on PP.cd_pes=cd_consig_hia
	Join Master_Imp_aer mas on mas.num_proc_mia=hou.num_proc_mia
Where
	convert(datetime,dt_cheg_mia,105) between @DataInicial and @DataFinal

Union 

select 
	Nome_Raz_Soc,convert(Datetime,dt_atrac_mim,105),num_proc_him,'IM' Modal
from 
	House_imp_mar HOU
	Join Pessoa PP on PP.cd_pes=cd_consig_him
	Join Master_Imp_MAR mas on mas.num_proc_miM=hou.num_proc_miM
Where
	convert(datetime,dt_atrac_mim,105) between @DataInicial and @DataFinal

Union 

select 
	Nome_Raz_Soc,convert(Datetime,dt_saida_mea,105),num_proc_hea,'EA' Modal
from 
	House_exp_Aer HOU
	Join Pessoa PP on PP.cd_pes=cd_Export_hea
	Join Master_exp_aer mas on mas.num_proc_mea=hou.num_proc_mea
Where
	convert(datetime,dt_saida_mea,105) between @DataInicial and @DataFinal


UNION 

select 
	Nome_Raz_Soc,convert(Datetime,dt_saida_meM,105),num_proc_heM,'EM' Modal
from 
	House_exp_MAR HOU
	Join Pessoa PP on PP.cd_pes=cd_Export_heM
	Join Master_exp_MAR mas on mas.num_proc_meM=hou.num_proc_meM
Where
	convert(datetime,dt_saida_meM,105) between @DataInicial and @DataFinal

UNION 


select 
	Isnull(GRP.Apelido,PP.Nome_Raz_Soc),etd_lem,num_proc_heM,'CHB' Modal
from 
	House_exp_MAR HOU
	Join Pessoa PP on PP.cd_pes=cd_Export_heM
	Join LLP_Exp_MAR LLP on LLP.num_proc_lem=hou.num_proc_hem
	Join Tarefas_Processos TF on TF.num_proc=num_proc_lem and Id_Task=4
	Left Join Pessoa_LLP P on PP.cd_pes=P.cd_pes
	Left Join Pessoa GRP on p.cd_pes_grupo=GRP.cd_pes
Where
	etd_lem between @DataInicial and @DataFinal


UNION 

select 
	Isnull(GRP.Apelido,PP.Nome_Raz_Soc),etd_leo,num_proc_heo,'CHB' Modal
from 
	House_exp_out HOU
	Join Pessoa PP on PP.cd_pes=cd_Export_heo
	Join LLP_Exp_out LLP on LLP.num_proc_leo=hou.num_proc_heo
	Join Tarefas_Processos TF on TF.num_proc=num_proc_leo and Id_Task=4
	Left Join Pessoa_LLP P on PP.cd_pes=P.cd_pes
	Left Join Pessoa GRP on p.cd_pes_grupo=GRP.cd_pes
Where
	etd_leo between @DataInicial and @DataFinal

Union 

select 
	Isnull(GRP.Apelido,PP.Nome_Raz_Soc),etd_lea,num_proc_hea,'CHB' Modal
from 
	House_exp_aer HOU
	Join Pessoa PP on PP.cd_pes=cd_Export_hea
	Join LLP_Exp_Aer LLP on LLP.num_proc_lea=hou.num_proc_hea
	Join Tarefas_Processos TF on TF.num_proc=num_proc_lea and Id_Task=4
	Left Join Pessoa_LLP P on PP.cd_pes=P.cd_pes
	Left Join Pessoa GRP on p.cd_pes_grupo=GRP.cd_pes

Where
	etd_lea between @DataInicial and @DataFinal

Union 

select 
	Isnull(GRP.Apelido,PP.Nome_Raz_Soc),eta_lio,num_proc_hio,'CHB' Modal
from 
	House_imp_out HOU
	Join Pessoa PP on PP.cd_pes=cd_consig_hio
	Join LLP_imp_out LLP on LLP.num_proc_lio=hou.num_proc_hio
	Join Tarefas_Processos TF on TF.num_proc=num_proc_lio and Id_Task=4
	Left Join Pessoa_LLP P on PP.cd_pes=P.cd_pes
	Left Join Pessoa GRP on p.cd_pes_grupo=GRP.cd_pes
Where
	eta_lio between @DataInicial and @DataFinal


Union 



select 
	 Isnull(GRP.Apelido,PP.Nome_Raz_Soc),eta_lim,num_proc_him,'CHB' Modal
from 
	House_imp_mar HOU
	Join Pessoa PP on PP.cd_pes=cd_consig_him
	Join LLP_imp_mar LLP on LLP.num_proc_lim=hou.num_proc_him
	Join Tarefas_Processos TF on TF.num_proc=num_proc_lim and Id_Task=4
	Left Join Pessoa_LLP P on PP.cd_pes=P.cd_pes
	Left Join Pessoa GRP on p.cd_pes_grupo=GRP.cd_pes

Where
	eta_lim between @DataInicial and @DataFinal


Union 



select 
	Isnull(GRP.Apelido,PP.Nome_Raz_Soc),eta_lia,num_proc_hia,'CHB' Modal
from 
	House_imp_aer HOU
	Join Pessoa PP on PP.cd_pes=cd_consig_hia
	Join LLP_imp_aer LLP on LLP.num_proc_lia=hou.num_proc_hia
	Join Tarefas_Processos TF on TF.num_proc=num_proc_lia and Id_Task=4
	Left Join Pessoa_LLP P on PP.cd_pes=P.cd_pes
	Left Join Pessoa GRP on p.cd_pes_grupo=GRP.cd_pes
Where
	eta_lia between @DataInicial and @DataFinal







GO
