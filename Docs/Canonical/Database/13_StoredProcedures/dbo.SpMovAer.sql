SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE        procedure [dbo].[SpMovAer] 

			@datainicial varchar(10),
			@datafinal varchar(10)

AS

SELECT
	'EA' Modal,left(mawb_mea,3) CIA,num_proc_mea Embarque, 
	peso_bruto_mea  Peso, mas.cd_tp_moeda Moeda, vlr_frete_mea Frete, PAR.par_moeda Par_Frete, USD.Par_Moeda Par_USD,dt_saida_mea Data, Nome_Cia_Aer
FROM
	master_exp_aer mas
	Left Join Paridade PAR on mas.cd_tp_moeda=par.cd_tp_moeda and Par.dt_par=@DataFinal and PAR.Cd_Tp_Par='OFC'
	Left Join Paridade USD on USD.cd_tp_moeda='USD' and USD.dt_par=@DataFinal and USD.cd_tp_par='OFC' 
	Left Join Cia_Aerea CIA on MAS.Cd_Cia_Aer=CIA.Cd_Cia_Aer

where 
	left(num_proc_mea,3) <>'JOB' and 
	convert(datetime, dt_saida_mea, 105) between convert(datetime, @datainicial, 105) and 
	convert(datetime, @datafinal, 105)
	and cia.cd_cia_aer <> 'XX'

union

select 
	'IA' Modal,left(mawb_mia,3) CIA,num_proc_mia Embarque, 
	peso_bruto_mia Peso, mas.cd_tp_moeda Moeda, vlr_frete_mia Frete,PAR.par_moeda Par_Frete, USD.Par_Moeda Par_USD, dt_cheg_mia Data, Nome_Cia_aer
from 
	master_imp_aer MAS
	Left Join Paridade PAR on mas.cd_tp_moeda=par.cd_tp_moeda and Par.dt_par=@DataFinal and par.cd_tp_par='OFC'
	Left Join Paridade USD on USD.cd_tp_moeda='USD' and USD.dt_par=@DataFinal and USD.cd_tp_par='OFC'
	Left Join Cia_Aerea CIA on MAS.Cd_Cia_Aer=CIA.Cd_Cia_Aer

where 
	left(num_proc_mia,3) <>'JOB' and
	convert(datetime, dt_cheg_mia, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)









GO
