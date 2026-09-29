SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO






CREATE PROCEDURE pVolImpAer_Sel
(
@Num_Proc_HIA	VarChar(14), 
@Item_IA		VarChar(2)=''
)
 AS
	Declare @Itens as Int 
	Set @Itens = IsNull((Select Count(*) From Volume_Imp_Aer Where Num_Proc_HIA  =@Num_Proc_HIA ),0)
	If @Item_IA <> '' 
		Begin 
			Select 
				*, TU.Fat_Conv, @Itens as Itens 
			From 
				Volume_Imp_Aer  as VIA Join Tipo_Unidade  as TU on VIA.Cd_Tp_Unidade = TU.Cd_Tp_Unidade
			Where
				Num_Proc_HIA = @Num_Proc_HIA and 
				Item_IA = @Item_IA
		End 
	Else
		Begin 
			Select 
				*, TU.Fat_Conv, @Itens as Itens 
			From 
				Volume_Imp_Aer as VIA Join Tipo_Unidade  as TU on VIA.Cd_Tp_Unidade = TU.Cd_Tp_Unidade
			Where
				Num_Proc_HIA = @Num_Proc_HIA
		End






GO
