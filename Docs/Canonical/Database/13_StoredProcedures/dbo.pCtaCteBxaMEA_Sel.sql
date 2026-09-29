SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pCtaCteBxaMEA_Sel    Script Date: 17/10/2002 07:32:47 ******/
CREATE PROCEDURE pCtaCteBxaMEA_Sel 
(
@Num_Proc		VarChar(16), 
@TpTx 			VarChar(3), 
@DC_MEA		Char(1)
)
 AS
	Select 
		Cxa.*, Tp.*
	From
		Caixa_Mas_Exp_Aer as Cxa Join Tipo_Paridade as TP on Cxa.Cd_Tp_Par = TP.Cd_Tp_Par
	Where
		Num_Proc_MEA = @Num_Proc and Cd_Tp_Tx = @TpTx  and DC_MEA = @DC_MEA and Num_Rcb_MEA = ''  and  Cxa.Cd_Tp_Par = TP.Cd_Tp_Par



GO
