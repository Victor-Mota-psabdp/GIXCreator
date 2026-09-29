SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spATL_CapaProcessoImpAir_Rel] --'IAATL201303029BR' 

		 @Num_Proc varchar(16)
AS
-- House House Importação Aerea 

select
		HOU.Num_Proc_HIA [JOB],
		HOU.Dt_Emis_HIA,
		HOU.MAWB_HIA [MAWB],
		HOU.HAWB_HIA [HAWB],
		HOU.Num_Proc_MIA [Ref. Consolidada],
		SHI.Apelido [Exportador],
		CSG.Apelido [consignatario],
		NTY.Apelido [Notify],
		LAL.Nome_Local [Aeroporto de Embarque],
		LAL.Cd_Local [Cd_Local],
		LAD.Nome_Local [Aeroporto de Descarga],
		LAD.Cd_Local[Cd_Local],
		CIA.Nome_Cia_Aer [Companhia Aerea],
		HOU.Voo_HIA [Voo],
		LLP.ETD_LIA [ETD],
		LLP.ATD_LIA [ATD],
		LLP.ETA_LIA [ETA],
		LLP.ATA_LIA [ATA],
		CAST(HOU.Peso_Real_HIA as decimal(18,2)) [Peso Liquido (KG)],
		CAST(HOU.Peso_Bruto_HIA as decimal(18,2))[Peso Bruto (KG)],
		LLP.Peso_Cubado_LIA [Taxado (KG)],
		HOU.Vol_Tot_HIA [Volume (M³)],
		HOU.Qtd_Tot_Vol_HIA [Peças],
		TM.Nome_Tp_Moeda [Moeda],
		(Case when TM.Cd_Tp_Moeda = 'REL' then 'BRL'
			else
				TM.Cd_Tp_Moeda End) [Cd_Moeda],
		Convert(varchar(10),TT41.Dt_Conclusao,103)[Aprovação de Draft],
		Convert(varchar(10),TT1.Dt_Conclusao,103)[Pre Alert],
		Convert(varchar(10),TT76.Dt_Conclusao,103)[Faturamento Criado],
		Convert(varchar(10),TT905.Dt_Conclusao,103)[Registro de Proft],		
		TM.Cd_Tp_Moeda[Cd_Moeda],
		HOU.Vlr_Frete_Efet_HIA [Valor Frete],
		HOU.Tp_Frete_HIA [Tipo Frete],
		HOU.Obs_HIA [OBS]
	from House_Imp_Aer HOU
	Left Outer	Join Job_Imp_Aer JOB With(Nolock) on HOU.Num_Proc_HIA = JOB.Num_Proc_HIA
				Join Pessoa SHI With(Nolock) on HOU.Cd_Export_HIA = SHI.Cd_Pes
				Join Pessoa CSG With(Nolock) on HOU.Cd_Consig_HIA = CSG.Cd_Pes
				Join Pessoa NTY With(Nolock) on HOU.Cd_Import_HIA = NTY.Cd_Pes
				Join LLP_Imp_Aer LLP With(Nolock) on HOU.Num_Proc_HIA = LLP.Num_Proc_Lia
	Left Outer Join Localidade	LAL With(Nolock) on HOU.Cd_Org_HIA = LAL.Cd_Local
	Left Outer Join Localidade	LAD With(Nolock) on HOU.Cd_Dst_HIA = LAD.Cd_Local
	Left Outer Join Cia_Aerea CIA With(Nolock) on JOB.Cd_Cia_Aer = CIA.Cd_Cia_Aer
	Left Outer Join Tipo_Moeda	TM with (NoLock)on HOU.Cd_Tp_Moeda	= TM.Cd_Tp_Moeda
	Left Outer Join Tarefas_Processos TT1 With(Nolock) on HOU.num_proc_hia = TT1.num_proc and TT1.ID_Task=1
	Left Outer Join Tarefas_Processos TT41 With(NoLock) on HOU.Num_Proc_HIA = TT41.Num_Proc and TT41.ID_Task = 41
	Left Outer Join Tarefas_Processos TT76 With(NoLock) on HOU.Num_Proc_HIA = TT76.Num_Proc and TT76.ID_Task = 76
	Left Outer Join Tarefas_Processos TT905 With (NoLock) on HOU.Num_Proc_HIA = TT905.Num_Proc and TT905.ID_Task = 905
			   
where 
HOU.Num_Proc_HIA = @Num_Proc
GO
