SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pMEM_Conteiner_Upd
(
@Num_Proc			varchar(14), 
@Item_Cont			varchar(2),
@Cd_Tp_Cont			varchar(3),
@Num_Cont			varchar(15), 
@Num_Lacre			varchar(15)='',
@Lacre_02_EM			Varchar(15)=Null, 
@Peso_Bruto_EM		Float=Null, 
@Tara_EM			Float =Null, 
@Regime_EM			Char(2)=Null
)
 AS
	Update  
		Container_Mas_Exp_Mar
	Set 
		Cd_Tp_Cont = @Cd_Tp_Cont, 
		Num_Cont_EM = @Num_Cont, 
		Num_Lacre_EM = @Num_Lacre,
		Lacre_02_EM = @Lacre_02_EM, 
		Peso_Bruto_EM = @Peso_Bruto_EM,
		Tara_EM = @Tara_EM, 
		Regime_EM = @Regime_EM
	Where 
		Num_Proc_MEM = @Num_Proc and 
		Item_Cont_EM = @Item_Cont
	Return @@RowCount



GO
