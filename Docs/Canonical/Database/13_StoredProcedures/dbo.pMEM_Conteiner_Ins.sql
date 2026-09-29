SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pMEM_Conteiner_Ins
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
	Insert Into 
		Container_Mas_Exp_Mar
		(Num_Proc_MEM, Item_Cont_EM, Cd_Tp_Cont, Num_Cont_EM, Num_Lacre_EM, Lacre_02_EM, Peso_Bruto_EM, Tara_EM, Regime_EM)
	Values 
		(@Num_Proc, @Item_Cont, @Cd_Tp_Cont, @Num_Cont, @Num_Lacre, @Lacre_02_EM, @Peso_Bruto_EM, @Tara_EM, @Regime_EM)



GO
