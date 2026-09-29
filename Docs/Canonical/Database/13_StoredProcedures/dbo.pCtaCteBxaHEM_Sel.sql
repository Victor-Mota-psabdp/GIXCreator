SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pCtaCteBxaHEM_Sel    Script Date: 17/10/2002 07:32:47 ******/
CREATE PROCEDURE pCtaCteBxaHEM_Sel 
(
@Num_Proc		VarChar(16), 
@TpTx 			VarChar(3), 
@DC_HEM		Char(1)
)
 AS
	Select 
		Cxa.*, Tp.*
	From
		Caixa_Hou_Exp_Mar as Cxa Join Tipo_Paridade as TP on Cxa.Cd_Tp_Par = TP.Cd_Tp_Par
	Where
		Num_Proc_HEM = @Num_Proc and Cd_Tp_Tx = @TpTx  and DC_HEM = @DC_HEM and Num_Rcb_HEM = ''  and  Cxa.Cd_Tp_Par = TP.Cd_Tp_Par



GO
