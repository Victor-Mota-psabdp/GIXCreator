SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_HEM_Booking_Sel]
(
	@Num_Proc varchar(30),
	@Tipo varchar(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O  /// Busca pelo Nome - Ativos
Y  /// Buscar pelo numero do Booking 
Z  /// Verifica Nome X Codigo
*/

if @Tipo = 'Y'
	Begin
		select	
			JOB.Num_Proc_hem		[JOB],
			JOB.Cd_Pes_Dcto			[Client Doc Code],
			Doc.Apelido 			[Client Doc Name],
			JOB.Cd_Tp_Com_Dcto		[Client Doc Contact Code],
			DOCC.Contato 			[Client Doc Contact Name],
			Doc.Nome_raz_soc + 
			isnull(DOCE.Rua,'') + isnull(DOCE.Compl_end,'') + isnull(DOCE.Cep,'') + isnull(DOCE.Cidade,'')  [Client Doc Full Address],					

			JOB.Cd_Pes_Crg			[Client Cargo Code],
			Cargo.Apelido 			[Client Cargo Name],
			JOB.Cd_Tp_Com_Dcto		[Client Cargo Contact Code],
			CargoC.Contato 			[Client Cargo Contact Name],
			Cargo.Nome_raz_soc + 
			isnull(CargoE.Rua,'') + isnull(CargoE.Compl_end,'') + isnull(CargoE.Cep,'') + isnull(CargoE.Cidade,'')  [Client Cargo Full Address],
			
			JOB.OBS_JEM 			[Notes],
			JOB.Nr_Reserva 			[Booking Number],

			LLP.DL_Draft_Lem		[Draft Date],
			LLP.DL_Cargo_Lem		[Cargo Date],
			LLP.DL_VGM_Lem			[VGM Date],

			JOB.cd_tp_com_cli		[Customer Contact Type Code],
			CMC.Contato 			[Customer Contact Name],	

			JOB.Cd_Retirada_Vazios	[Empty Pick-up Address Code],
			RV.Apelido				[Empty Pick-up Address Name]			
			
		From
			Job_Exp_Mar JOB with(nolock)
			Left Outer Join Pessoa DOC with(nolock) on JOB.Cd_Pes_Dcto = DOC.cd_pes
			Left Outer Join Endereco DOCE with(nolock) on JOB.Cd_Pes_Dcto = DOCE.cd_pes and DOCE.Cd_Tp_End ='COM'
			Left Outer Join Comunicacao DOCC with(nolock) on JOB.Cd_Pes_Dcto = DOCC.cd_pes and JOB.Cd_Tp_Com_Dcto = DOCC.Cd_Tp_Com

			Left Outer Join Pessoa Cargo with(nolock) on JOB.Cd_Pes_Crg = Cargo.cd_pes
			Left Outer Join Endereco CargoE with(nolock) on JOB.Cd_Pes_Crg = CargoE.cd_pes and CargoE.Cd_Tp_End ='COM'
			Left Outer Join Comunicacao CargoC with(nolock) on JOB.Cd_Pes_Crg = CargoC.cd_pes and JOB.Cd_Tp_Com_Crg = CargoC.Cd_Tp_Com

			Left Outer Join House_Exp_mar HOU with(nolock) on JOB.Num_proc_hem = HOU.Job_hem
			Left Outer Join LLP_Exp_Mar LLP with(nolock) on JOB.Num_Proc_Hem = LLP.Num_Proc_Lem
			Left Outer Join Pessoa Cli with(nolock) on HOU.cd_export_hem = Cli.cd_pes
			Left Outer Join Comunicacao CMC with(nolock) on Cli.cd_pes = CMC.cd_pes and JOB.cd_tp_com_cli = CMC.cd_tp_com
			
			Left Outer Join Pessoa RV with(nolock) on JOB.Cd_Retirada_Vazios = RV.cd_pes

		where
			JOB.Nr_Reserva = @Num_Proc
			and JOB.Nr_Reserva <> ''
			and JOB.Nr_Reserva <> '0'
	    End	
Else 
		Begin
			select	
				JOB.Num_Proc_hem		[JOB],
				JOB.Cd_Pes_Dcto			[Client Doc Code],
				Doc.Apelido 			[Client Doc Name],
				JOB.Cd_Tp_Com_Dcto		[Client Doc Contact Code],
				DOCC.Contato 			[Client Doc Contact Name],
				Doc.Nome_raz_soc + 
				isnull(DOCE.Rua,'') + isnull(DOCE.Compl_end,'') + isnull(DOCE.Cep,'') + isnull(DOCE.Cidade,'')  [Client Doc Full Address],					

				JOB.Cd_Pes_Crg			[Client Cargo Code],
				Cargo.Apelido 			[Client Cargo Name],
				JOB.Cd_Tp_Com_Dcto		[Client Cargo Contact Code],
				CargoC.Contato 			[Client Cargo Contact Name],
				Cargo.Nome_raz_soc + 
				isnull(CargoE.Rua,'') + isnull(CargoE.Compl_end,'') + isnull(CargoE.Cep,'') + isnull(CargoE.Cidade,'')  [Client Cargo Full Address],
			
				JOB.OBS_JEM 			[Notes],
				JOB.Nr_Reserva 			[Booking Number],

				LLP.DL_Draft_Lem		[Draft Date],
				LLP.DL_Cargo_Lem		[Cargo Date],
				LLP.DL_VGM_Lem			[VGM Date],

				JOB.cd_tp_com_cli		[Customer Contact Type Code],
				CMC.Contato 			[Customer Contact Name],	

				JOB.Cd_Retirada_Vazios	[Empty Pick-up Address Code],
				RV.Apelido				[Empty Pick-up Address Name]			
			
			From
				Job_Exp_Mar JOB with(nolock)
				Left Outer Join Pessoa DOC with(nolock) on JOB.Cd_Pes_Dcto = DOC.cd_pes
				Left Outer Join Endereco DOCE with(nolock) on JOB.Cd_Pes_Dcto = DOCE.cd_pes and DOCE.Cd_Tp_End ='COM'
				Left Outer Join Comunicacao DOCC with(nolock) on JOB.Cd_Pes_Dcto = DOCC.cd_pes and JOB.Cd_Tp_Com_Dcto = DOCC.Cd_Tp_Com

				Left Outer Join Pessoa Cargo with(nolock) on JOB.Cd_Pes_Crg = Cargo.cd_pes
				Left Outer Join Endereco CargoE with(nolock) on JOB.Cd_Pes_Crg = CargoE.cd_pes and CargoE.Cd_Tp_End ='COM'
				Left Outer Join Comunicacao CargoC with(nolock) on JOB.Cd_Pes_Crg = CargoC.cd_pes and JOB.Cd_Tp_Com_Crg = CargoC.Cd_Tp_Com

				Left Outer Join House_Exp_mar HOU with(nolock) on JOB.Num_proc_hem = HOU.Job_hem
				Left Outer Join LLP_Exp_Mar LLP with(nolock) on JOB.Num_Proc_Hem = LLP.Num_Proc_Lem
				Left Outer Join Pessoa Cli with(nolock) on HOU.cd_export_hem = Cli.cd_pes
				Left Outer Join Comunicacao CMC with(nolock) on Cli.cd_pes = CMC.cd_pes and JOB.cd_tp_com_cli = CMC.cd_tp_com
			
				Left Outer Join Pessoa RV with(nolock) on JOB.Cd_Retirada_Vazios = RV.cd_pes

			where
				JOB.Num_Proc_hem = @Num_Proc
		End	
	

GO
