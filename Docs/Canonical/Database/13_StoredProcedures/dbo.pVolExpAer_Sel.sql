SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO






CREATE PROCEDURE pVolExpAer_Sel
(
@Num_Proc_HEA	VarChar(14), 
@Item_EA		VarChar(2)=''
)
 AS
	Declare @Itens as Int 
	Set @Itens = IsNull((Select Count(*) From Volume_Exp_Aer Where Num_Proc_HEA  =@Num_Proc_HEA ),0)
	If @Item_EA <> '' 
		Begin 
			Select 
				*, TU.Fat_Conv, @Itens as Itens 
			From 
				Volume_Exp_Aer  as VEA Join Tipo_Unidade  as TU on VEA.Cd_Tp_Unidade = TU.Cd_Tp_Unidade
			Where
				Num_Proc_HEA = @Num_Proc_HEA and 
				Item_EA = @Item_EA
		End 
	Else
		Begin 
			Select 
				*, TU.Fat_Conv, @Itens as Itens 
			From 
				Volume_Exp_Aer as VEA Join Tipo_Unidade  as TU on VEA.Cd_Tp_Unidade = TU.Cd_Tp_Unidade
			Where
				Num_Proc_HEA = @Num_Proc_HEA
		End






GO
