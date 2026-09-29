SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pCtaCteBxaMIA_Sel    Script Date: 17/10/2002 07:32:47 ******/
CREATE PROCEDURE pCtaCteBxaMIA_Sel 
(
@Num_Proc		VarChar(16), 
@TpTx 			VarChar(3), 
@DC_MIA		Char(1)
)
 AS
	Select 
		Cxa.*, Tp.*
	From
		Caixa_Mas_Imp_Aer as Cxa Join Tipo_Paridade as TP on Cxa.Cd_Tp_Par = TP.Cd_Tp_Par
	Where
		Num_Proc_MIA = @Num_Proc and Cd_Tp_Tx = @TpTx  and DC_MIA = @DC_MIA and Num_Rcb_MIA = ''  and  Cxa.Cd_Tp_Par = TP.Cd_Tp_Par



GO
