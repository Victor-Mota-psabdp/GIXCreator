SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spCaixasProcessosFMC_Sel]

	@DataInicial	Datetime,
	@DataFinal		Datetime

as
	Select distinct num_proc_hea Num_Proc from Caixa_Hou_Exp_Aer
	where num_proc_hea like '%FMC%' and convert(datetime,Dt_Pgto_Rcto_HEA,105) between convert(datetime,@DataInicial,105) and convert(datetime,@DataFinal,105)

UNION
	Select distinct num_proc_hem Num_Proc from Caixa_Hou_Exp_Mar
	where num_proc_hem like '%FMC%' and convert(datetime,Dt_Pgto_Rcto_HEM,105) between convert(datetime,@DataInicial,105) and convert(datetime,@DataFinal,105)
	
UNION
	Select distinct num_proc_heo Num_Proc from Caixa_Hou_Exp_Out
	where num_proc_heo like '%FMC%' and convert(datetime,Dt_Pgto_Rcto_HEO,105) between convert(datetime,@DataInicial,105) and convert(datetime,@DataFinal,105)
	
UNION
	Select distinct num_proc_hia Num_Proc from Caixa_Hou_Imp_Aer
	where num_proc_hia like '%FMC%' and convert(datetime,Dt_Pgto_Rcto_HIA,105) between convert(datetime,@DataInicial,105) and convert(datetime,@DataFinal,105)

UNION
	Select distinct num_proc_him Num_Proc from Caixa_Hou_Imp_Mar
	where num_proc_him like '%FMC%' and convert(datetime,Dt_Pgto_Rcto_HIM,105) between convert(datetime,@DataInicial,105) and convert(datetime,@DataFinal,105)

UNION
	Select distinct num_proc_hio Num_Proc from Caixa_Hou_Imp_Out
	where num_proc_hio like '%FMC%' and convert(datetime,Dt_Pgto_Rcto_HIO,105) between convert(datetime,@DataInicial,105) and convert(datetime,@DataFinal,105)


GO
