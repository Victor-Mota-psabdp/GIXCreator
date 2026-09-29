SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE	PROCEDURE [dbo].[spReservaPraca_Upd] 
(
@Processo			VarChar(16), 
@Contato_Cli		Varchar(50),
@Pes_Dcto			Varchar(50),
@Contato_Dcto		Varchar(50),
@Pes_Crg			Varchar(50), 
@Contato_Crg		Varchar(50),
@Obs				VarChar(500),
@Booking			Varchar(30),
@DL_Draft_Lem		Datetime,	
@DL_Cargo_Lem		Datetime,
@Retirada_Vazios	Varchar(50),
@DL_VGM_Lem			Datetime
)
AS
BEGIN TRANSACTION		

	Declare @Cd_Pes_Dcto		varchar(10)
	Declare @Cd_Pes_Crg			varchar(10)
	Declare @Cd_Tp_Com_Dcto		Varchar(3)
	Declare @Cd_Tp_Com_Crg		Varchar(3)
	Declare @Cd_Tp_Com_Cli 		Varchar(3)
	Declare @Cd_Retirada_Vazios	Varchar(10)

	Set @Cd_Retirada_Vazios =(Select cd_pes from pessoa with(nolock) where apelido = @Retirada_Vazios)
	Set @Cd_Pes_Dcto =(Select cd_pes from pessoa with(nolock) where apelido = @Pes_Dcto)
	Set @Cd_Pes_Crg =(Select cd_pes from pessoa with(nolock)	where apelido = @Pes_Crg)
	Set @Cd_Tp_Com_Dcto =(Select CM.cd_tp_com from pessoa PS with(nolock)
							left join comunicacao CM with(nolock) on PS.cd_pes = CM.cd_pes
							where CM.cd_pes = @cd_pes_dcto and contato = @Contato_Dcto) 
	Set @Cd_Tp_Com_Crg = (Select CM.cd_tp_com from pessoa PS with(nolock)
						left join comunicacao CM with(nolock) on PS.cd_pes = CM.cd_pes
						where CM.cd_pes = @cd_pes_Crg and CM.contato = @Contato_Crg)

	If @Contato_Cli Is Null
		Set @CD_Tp_Com_Cli = Null
	Else
		Begin
			Set @Cd_Tp_Com_Cli =(
							Select CM.cd_tp_com from job_exp_mar JOB with(nolock)
							left join house_exp_mar HOU with(nolock) on JOB.num_proc_hem = HOU.job_hem
							left join pessoa PS with(nolock) on HOU.cd_export_hem = PS.cd_pes
							left join comunicacao CM with(nolock) on PS.cd_pes = CM.cd_pes
							where HOU.num_proc_hem = @Processo and CM.contato = @Contato_Cli 
				      		) 	
		End	

--JOB

	Update 
		Job_Exp_Mar
	Set 
		Cd_Tp_Com_Cli=@Cd_Tp_Com_Cli,
		Cd_Pes_Dcto=@Cd_Pes_Dcto, 
		Cd_Tp_Com_Dcto=@Cd_Tp_Com_Dcto, 
		Cd_Pes_Crg=@Cd_Pes_Crg, 
		Cd_Tp_Com_Crg=@Cd_Tp_Com_Crg,
		Obs_JEM = @Obs,
		Nr_Reserva = @Booking,
		Cd_Retirada_Vazios=@Cd_Retirada_Vazios
	Where
		Num_Proc_HEM = @Processo

---LLP
	Update 
		LLP_Exp_Mar
	Set 
		DL_Draft_Lem = @DL_Draft_Lem,
		DL_Cargo_Lem = @DL_Cargo_Lem,
		DL_VGM_Lem = @DL_VGM_Lem		
	Where
		Num_Proc_LEM = @Processo

--Gera a Linha para atualizar Report Manager e Smart: Não existe trigger para a tabela JOB e LLP.
	Insert Into ATL_INT.dbo.Exchange_ODS (ExcProcesso, ExcDataAlt) 
	values (@Processo, getdate()) 
	
	Insert Into Exchange (ExcProcesso, ExcDataAlt, ExcStatus,ExcDtEnvio) 
	values (@Processo, getdate(), 0, getdate()) 


		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END


COMMIT TRANSACTION












GO
