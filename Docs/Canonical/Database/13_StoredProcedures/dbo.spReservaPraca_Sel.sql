SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE	procedure [dbo].[spReservaPraca_Sel]
(
@Processo as varchar(16)
)
AS
	select		
			Doc.Apelido 		Docs,
			CMD.Contato 		DocsCont,
			Crg.Apelido 		Carga,
			CMG.Contato 		CargaCont,
			JOB.OBS_JEM 		OBS,
			JOB.Nr_Reserva 		Booking,
			CMC.Contato 		ClienteCont,
			LLP.DL_Draft_Lem	Draft,
			LLP.DL_Cargo_Lem	Cargo,
			RV.Apelido			Retirada_Vazios,
			NTF.Apelido			Notify_2,
			LLP.DL_VGM_Lem		VGM
	From
		Job_Exp_Mar JOB with(nolock)
		Left Outer Join Pessoa Doc with(nolock) on JOB.Cd_Pes_Dcto = Doc.cd_pes
		Left Outer Join Comunicacao CMD with(nolock) on Doc.cd_pes = CMD.cd_pes and JOB.Cd_Tp_Com_Dcto = CMD.Cd_Tp_Com
		Left Outer Join Pessoa Crg with(nolock) on JOB.Cd_Pes_Crg = Crg.cd_pes
		Left Outer Join Comunicacao CMG with(nolock) on Crg.cd_pes = CMG.cd_pes and JOB.Cd_Tp_Com_Crg = CMG.Cd_Tp_Com
		Left Outer Join House_Exp_mar HOU with(nolock) on JOB.Num_proc_hem = HOU.Job_hem
		Left Outer Join Pessoa Cli with(nolock) on HOU.cd_export_hem = Cli.cd_pes
		Left Outer Join Comunicacao CMC with(nolock) on Cli.cd_pes = CMC.cd_pes and JOB.cd_tp_com_cli = CMC.cd_tp_com
		left Outer Join LLP_Exp_Mar LLP with(nolock) on JOB.Num_Proc_Hem = LLP.Num_Proc_Lem
		Left Outer Join Pessoa RV with(nolock) on JOB.Cd_Retirada_Vazios = RV.cd_pes
		Left Outer Join Pessoa NTF with(nolock) on LLP.cd_notify_2 = NTF.cd_pes
	where
		JOB.num_proc_hem = @Processo

GO
