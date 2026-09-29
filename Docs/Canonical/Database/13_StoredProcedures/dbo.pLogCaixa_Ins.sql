SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pLogCaixa_Ins
(
@Tp_Oper_Cx			char(1),
@Num_Proc_Cx			varchar(16), 
@Cd_Tp_Tx			varchar(3), 
@DC_Cx			char(1), 
@Num_Lcto_Cx			varchar(12),
@Vlr_Ref			float,
@Dt_Conv			varchar(10), 
@Cd_Tp_Par			varchar(3), 
@Par_Moeda_Cx		float, 
@Vlr_Pgto_Rcto		float,
@Dt_Pgto_Rcto_Cx		varchar(10),
@Num_Rcb     			VarChar(12),
@Usuario			varchar(6)
)
 AS
	Insert into 
		Log_Caixa 
		(Data_Cx, Cd_Usuario,Tp_Oper_Cx, Num_Proc_Cx,Cd_Tp_Tx, DC_Cx, Num_Lcto_Cx, Vlr_Ref, Dt_Conv, Cd_Tp_Par, 
		Par_Moeda_Cx, Vlr_Pgto_Rcto, Dt_Pgto_Rcto_Cx, Num_Rcb)
	Values
		(GetDate(),@Usuario, @Tp_Oper_Cx,@Num_Proc_Cx, @Cd_Tp_Tx, @DC_Cx, @Num_Lcto_Cx, @Vlr_Ref, @Dt_Conv, @Cd_Tp_Par, 
		@Par_Moeda_Cx, @Vlr_Pgto_Rcto, @Dt_Pgto_Rcto_Cx,@Num_Rcb)

GO
