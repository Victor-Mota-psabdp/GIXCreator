SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from paridade where cd_tp_moeda='USD' and convert(datetime,dt_par,105)= '2012-01-12'
--
--select * from master_exp_aer where cd_tp_moeda is null

--select * from llp_master

CREATE procedure [dbo].[SpATL_MovAer]--'2011-01-01','2012-01-13'

			@datainicial as datetime,
			@datafinal as datetime

AS

		SELECT
			'EA'					Modal,
			left(mawb_mea,3)		CIA,
			MAS.num_proc_mea		Embarque, 
			MAS.peso_bruto_mea		Peso, 
			mas.cd_tp_moeda			Moeda, 
			vlr_frete_mea			Frete, 
			PAR.par_moeda			Par_Frete, 
			USD.Par_Moeda			Par_USD,
			LM.etd_master			Data, 
			Cia.Nome_Cia_Aer		Nome_Cia_Aer
		FROM
			master_exp_aer mas With(nolock)
			join llp_master LM With(nolock) on LM.num_proc_master = Mas.num_proc_mea			
			Left Join Paridade PAR With(nolock) on mas.cd_tp_moeda=par.cd_tp_moeda and convert(datetime,Par.dt_par,105)=@DataFinal and PAR.Cd_Tp_Par='OFC'
			Left Join Paridade USD With(nolock) on USD.cd_tp_moeda='USD' and convert(datetime,USD.dt_par,105)= @DataFinal and USD.cd_tp_par='OFC' 
			Left Join Cia_Aerea CIA With(nolock) on MAS.Cd_Cia_Aer=CIA.Cd_Cia_Aer

		where 
			left(MAS.num_proc_mea,3) <>'JOB' and 
			LM.etd_Master between @datainicial and @datafinal
			and cia.cd_cia_aer <> 'XX'
			and Tipo='B'


UNION ALL

		select 
			'IA'					Modal,
			left(mawb_mia,3)		CIA,
			num_proc_mia			Embarque, 
			peso_bruto_mia			Peso,
			mas.cd_tp_moeda			Moeda, 
			vlr_frete_mia			Frete,
			PAR.par_moeda			Par_Frete, 
			USD.Par_Moeda			Par_USD, 
			convert(datetime,MAS.dt_cheg_mia,105)			Data, 
			CIA.Nome_Cia_aer		Nome_Cia_aer
		from 
			master_imp_aer MAS With(nolock)
			Left Join Paridade PAR With(nolock) on mas.cd_tp_moeda=par.cd_tp_moeda and convert(datetime,Par.dt_par,105)=@DataFinal and par.cd_tp_par='OFC'
			Left Join Paridade USD With(nolock) on USD.cd_tp_moeda='USD' and convert(datetime,USD.dt_par,105)=@DataFinal and USD.cd_tp_par='OFC'
			Left Join Cia_Aerea CIA With(nolock) on MAS.Cd_Cia_Aer=CIA.Cd_Cia_Aer
			Join LLP_Master LLP With(nolock) on llp.num_proc_master=mas.num_proc_mia
		where 
			left(num_proc_mia,3) <>'JOB' and
			convert(datetime, dt_cheg_mia, 105) between @datainicial and @datafinal
			and Tipo='B'

--
--
--
--
--
--
--
--

GO
