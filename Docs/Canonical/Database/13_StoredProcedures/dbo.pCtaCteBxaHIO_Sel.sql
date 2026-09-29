SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pCtaCteBxaHIM_Sel    Script Date: 17/10/2002 07:32:47 ******/
CREATE PROCEDURE [dbo].[pCtaCteBxaHIO_Sel] 
(
@Num_Proc		VarChar(16), 
@TpTx 			VarChar(3), 
@DC_HIO			Char(1)
)
 AS
	Select 
		Cxa.*, Tp.*
	From
		Caixa_Hou_Imp_Out as Cxa Join Tipo_Paridade as TP on Cxa.Cd_Tp_Par = TP.Cd_Tp_Par
	Where
		Num_Proc_HIO = @Num_Proc and Cd_Tp_Tx = @TpTx  and DC_HIO = @DC_HIO and Cxa.Cd_Tp_Par = TP.Cd_Tp_Par

GO
