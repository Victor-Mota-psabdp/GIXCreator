SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--cadu 9/12/16 - incluido terminal no EA e EO

CREATE Procedure [dbo].[SpReportManagerV2_LLP] --SpReportManagerV2_LLP 'IaCSR20091200201',''
	@Num_Proc			varchar(16),
	@FinalDestination	varchar(40) output,
	@Terminal			Varchar(50) output,
	@Bank				varchar(30) output,
	@DeadatTerminalDate datetime output,
	@CountryofFinalDestination varchar(30) output,
	@InlandTrucker varchar(50)output,
	@OriginalETADate datetime output,
	@PORequestDelDate datetime output,
	@ETADate datetime output,
	@ETDDate datetime output,
	@ATADate datetime output,
	@ATDDate datetime output,
	@MonthofArrival varchar(20) output,
	@IntlReference varchar(40) output,
	@TypeOfCargo varchar(5) output,
	@Channel varchar(10) output
AS

if left(@num_proc,2)='IA'
	BEGIN
		Select 
			@finaldestination = Nome_Local ,
			@Terminal=Nome_Terminal,
			@Bank = LLP.Banco,
			@DeadatTerminalDate = LLP.DL_Cargo_Lia,
			@CountryofFinalDestination = PDstFinal.Nome_Pais,
			@InlandTrucker = IT.apelido,
			@OriginalETADate = LLP.Original_ETA_LIA,
			@PORequestDelDate = LLP.PO_Req_Date,
			@ETADate = LLP.ETA_LIA,
			@ETDDate = LLP.ETD_LIA,
			@ATADate = LLP.ATA_LIA,
			@ATDDate = LLP.ATD_LIA,
			@MonthofArrival = Datename(MONTH,LLP.ATA_LIA),
			@IntlReference = LLP.Intl_Ref_LIA,
			@TypeOfCargo = 'LCL',
			@Channel = Canal_LIA
		from 
			llp_imp_aer LLP with(nolock) 
			left Join Localidade DstFinal with(nolock) on DstFinal.cd_local=cd_Dstfinal_lia
			left Join Pais PDstFinal with(nolock) on DstFinal.Cd_Pais = PDstFinal.Cd_Pais
			Left Join Terminal T with(nolock) on T.cd_terminal=LLP.cd_terminal
			left join Pessoa IT With(Nolock)		on IT.Cd_pes = LLP.Cd_Transportadora
		Where
			Num_Proc_Lia=@Num_PRoc
	END	
		
if left(@num_proc,2)='EA'
	BEGIN
		Select 
			@finaldestination = Nome_Local ,
			@Terminal=Nome_Terminal,
			@Bank = LLP.Banco,
			@DeadatTerminalDate = LLP.DL_Cargo_Lea,
			@CountryofFinalDestination = PDstFinal.Nome_Pais,
			@InlandTrucker = IT.apelido,
			@OriginalETADate = LLP.Original_ETA_Lea,
			@PORequestDelDate = LLP.PO_Req_Date,
			@ETADate = LLP.ETA_Lea,
			@ETDDate = LLP.ETD_Lea,
			@ATADate = LLP.ATA_Lea,
			@ATDDate = LLP.ATD_LeA,
			@MonthofArrival = Datename(MONTH,LLP.ATA_LeA),
			@Channel = Canal_LEA
		from 
			llp_exp_aer LLP with(nolock)
			left Join Localidade DstFinal with(nolock) on DstFinal.cd_local=cd_Dstfinal_lea
			left Join Pais PDstFinal with(nolock) on DstFinal.Cd_Pais = PDstFinal.Cd_Pais
			Left Join Terminal T with(nolock) on T.cd_terminal=LLP.cd_terminal
			left join Pessoa IT With(Nolock)		on IT.Cd_pes = LLP.Cd_Transportadora
		Where
			Num_Proc_Lea=@Num_PRoc
	END	
if left(@num_proc,2)='IM'
	BEGIN
		Select 
			@finaldestination = Nome_Local ,
			@Terminal=Nome_Terminal,
			@Bank = LLP.Banco,
			@DeadatTerminalDate = LLP.DL_Cargo_Lim,
			@CountryofFinalDestination = PDstFinal.Nome_Pais,
			@InlandTrucker = IT.apelido,
			@OriginalETADate = LLP.Original_ETA_Lim,
			@PORequestDelDate = LLP.PO_Req_Date,
			@ETADate = LLP.ETA_LIm,
			@ETDDate = LLP.ETD_LIm,
			@ATADate = LLP.ATA_LIm,
			@ATDDate = LLP.ATD_LIm,
			@MonthofArrival = Datename(MONTH,LLP.ATA_LIm),
			@IntlReference = LLP.Intl_Ref_LIm,
			@TypeOfCargo = LEFT(TC.Nome_Tp_Carga,3),
			@Channel = Canal_LIM
		from 
			llp_Imp_Mar LLP with(nolock) 
			left Join Tipo_Carga TC With(Nolock)	on TC.cd_tp_carga=llp.cd_tp_carga
			left Join Localidade DstFinal with(nolock) on DstFinal.cd_local=cd_Dstfinal_lim
			left Join Pais PDstFinal with(nolock) on DstFinal.Cd_Pais = PDstFinal.Cd_Pais
			Left Join Terminal T with(nolock) on T.cd_terminal=LLP.cd_terminal
			left join Pessoa IT With(Nolock)		on IT.Cd_pes = LLP.Cd_Transportadora

		Where

			Num_Proc_Lim=@Num_PRoc
	END	
if left(@num_proc,2)='EM'
	BEGIN
		Select 
			@finaldestination = Nome_Local ,
			@Terminal=Nome_Terminal,
			@Bank = LLP.Banco,
			@DeadatTerminalDate = LLP.DL_Cargo_Lem,
			@CountryofFinalDestination = PDstFinal.Nome_Pais,
			@InlandTrucker = IT.apelido,
			@OriginalETADate = LLP.Original_ETA_Lem,
			@PORequestDelDate = LLP.PO_Req_Date,
			@ETADate = LLP.ETA_Lem,
			@ETDDate = LLP.ETD_Lem,
			@ATADate = LLP.ATA_Lem,
			@ATDDate = LLP.ATD_Lem,
			@MonthofArrival = Datename(MONTH,LLP.ATA_Lem),
			@TypeOfCargo = LEFT(TC.Nome_Tp_Carga,3),
			@Channel = Canal_LEM
		from 
			llp_Exp_Mar LLP with(nolock)
			Left Join Tipo_Carga TC With(Nolock) on TC.cd_tp_carga=llp.cd_tp_carga
			left Join Localidade DstFinal with(nolock) on DstFinal.cd_local=cd_Dstfinal_lem
			left Join Pais PDstFinal with(nolock) on DstFinal.Cd_Pais = PDstFinal.Cd_Pais
			Left Join Terminal T with(nolock) on T.cd_terminal=LLP.cd_terminal
			left join Pessoa IT With(Nolock)		on IT.Cd_pes = LLP.Cd_Transportadora
		Where
			Num_Proc_Lem=@Num_PRoc
	END	
if left(@num_proc,2)='IO'
	BEGIN
		Select 
			@finaldestination = Nome_Local ,
			@Terminal=Nome_Terminal,
			@Bank = LLP.Banco,
			@DeadatTerminalDate = LLP.DL_Cargo_Lio,
			@CountryofFinalDestination = PDstFinal.Nome_Pais,
			@InlandTrucker = IT.apelido,
			@OriginalETADate = LLP.Original_ETA_Lio,
			@PORequestDelDate = LLP.PO_Req_Date,
			@ETADate = LLP.ETA_LIo,
			@ETDDate = LLP.ETD_LIo,
			@ATADate = LLP.ATA_LIo,
			@ATDDate = LLP.ATD_LIo,
			@MonthofArrival = Datename(MONTH,LLP.ATA_LIo),
			@IntlReference = LLP.Intl_Ref_LIO,
			@Channel = Canal_LIO
		from 
			llp_Imp_Out LLP with(nolock)
			left Join Localidade DstFinal with(nolock) on DstFinal.cd_local=cd_Dstfinal_lio
			left Join Pais PDstFinal with(nolock) on DstFinal.Cd_Pais = PDstFinal.Cd_Pais
			Left Join Terminal T with(nolock) on T.cd_terminal=LLP.cd_terminal
			left join Pessoa IT With(Nolock)		on IT.Cd_pes = LLP.Cd_Transportadora
		Where
			Num_Proc_Lio=@Num_PRoc
	END	
if left(@num_proc,2)='EO'
	BEGIN
		Select 
			@finaldestination = Nome_Local,
			@Terminal=Nome_Terminal,
			@Bank = LLP.Banco,
			@DeadatTerminalDate = LLP.DL_Cargo_Leo,
			@CountryofFinalDestination = PDstFinal.Nome_Pais,
			@InlandTrucker = IT.apelido ,
			@OriginalETADate = LLP.Original_ETA_Leo,
			@PORequestDelDate = LLP.PO_Req_Date,
			@ETADate = LLP.ETA_Leo,
			@ETDDate = LLP.ETD_Leo,
			@ATADate = LLP.ATA_Leo,
			@ATDDate = LLP.ATD_Leo,
			@MonthofArrival = Datename(MONTH,LLP.ATA_Leo),
			@Channel = Canal_LEO
		from 
			llp_exp_Out LLP with(nolock)
			left Join Localidade DstFinal with(nolock) on DstFinal.cd_local=cd_Dstfinal_leo
			left Join Pais PDstFinal with(nolock) on DstFinal.Cd_Pais = PDstFinal.Cd_Pais
			Left Join Terminal T with(nolock) on T.cd_terminal=LLP.cd_terminal
			left join Pessoa IT With(Nolock) on IT.Cd_pes = LLP.Cd_Transportadora
		Where
			Num_Proc_Leo=@Num_PRoc
	END	

SET @MonthofArrival = REPLACE(@MonthofArrival, 'January', 'Janeiro')

-- February

SET @MonthofArrival = REPLACE(@MonthofArrival, 'February', 'Fevereiro')

-- March

SET @MonthofArrival = REPLACE(@MonthofArrival, 'March', 'Março')

-- April

SET @MonthofArrival = REPLACE(@MonthofArrival, 'April', 'Abril')

-- May

SET @MonthofArrival = REPLACE(@MonthofArrival, 'May', 'Maio')

-- June

SET @MonthofArrival = REPLACE(@MonthofArrival, 'June', 'Junho')

-- July

SET @MonthofArrival = REPLACE(@MonthofArrival, 'July', 'Julho')

-- August

SET @MonthofArrival = REPLACE(@MonthofArrival, 'August', 'Agosto')

-- September

SET @MonthofArrival = REPLACE(@MonthofArrival, 'September', 'Setembro')

-- October

SET @MonthofArrival = REPLACE(@MonthofArrival, 'October', 'Outubro')

-- November

SET @MonthofArrival = REPLACE(@MonthofArrival, 'November', 'Novembro')

-- December

SET @MonthofArrival = REPLACE(@MonthofArrival, 'December', 'Dezembro')
GO
