SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pCtaCteBxaMIM_Sel    Script Date: 17/10/2002 07:32:47 ******/
CREATE PROCEDURE pCtaCteBxaMIM_Sel 
(
@Num_Proc		VarChar(16), 
@TpTx 			VarChar(3), 
@DC_MIM		Char(1)
)
 AS
	Select 
		Cxa.*, Tp.*
	From
		Caixa_Mas_Imp_Mar as Cxa Join Tipo_Paridade as TP on Cxa.Cd_Tp_Par = TP.Cd_Tp_Par
	Where
		Num_Proc_MIM = @Num_Proc and Cd_Tp_Tx = @TpTx  and DC_MIM = @DC_MIM and Num_Rcb_MIM = ''  and  Cxa.Cd_Tp_Par = TP.Cd_Tp_Par



GO
