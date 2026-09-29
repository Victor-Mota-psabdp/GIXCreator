SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pMEM_Conteiner_Sel 
(
@Num_Proc		VarChar(14)='',
@Item			VarChar(2)='', 
@Conteiner		VarChar(15)=''
)
 AS	
	Declare @Itens as Int 
	Set @Itens = IsNull((Select Count(*) From Container_Mas_Exp_Mar Where Num_Proc_MEM =@Num_Proc),0)
	If @Num_Proc <> '' 
		Begin 
			If @Item = ''
				Select 
					Num_Proc_MEM, Item_Cont_EM, Container_Mas_Exp_Mar.Cd_Tp_Cont, 
					Num_Cont_EM, Num_Lacre_EM, Nome_Tp_Cont, @Itens  as Itens ,
					Peso_Bruto_EM, Regime_EM, ID_ISO, Tara_EM, Lacre_02_EM, Lacre_03_EM, Lacre_04_EM
				From 
					Container_Mas_Exp_Mar, Tipo_Container 
				Where
					Container_Mas_Exp_Mar.Cd_Tp_Cont = Tipo_Container.Cd_Tp_Cont AND 
					Num_Proc_MEM =@Num_Proc
				Group by 
					Num_Proc_MEM, Item_Cont_EM, Container_Mas_Exp_Mar.Cd_Tp_Cont, 
					Num_Cont_EM, Num_Lacre_EM, Nome_Tp_Cont,
					Peso_Bruto_EM, Regime_EM, ID_ISO, Tara_EM, Lacre_02_EM, Lacre_03_EM, Lacre_04_EM
			Else
				Select 
					Num_Proc_MEM, Item_Cont_EM, Container_Mas_Exp_Mar.Cd_Tp_Cont, 
					Num_Cont_EM, Num_Lacre_EM, Nome_Tp_Cont, @Itens  as Itens,
					Peso_Bruto_EM, Regime_EM, ID_ISO, Tara_EM, Lacre_02_EM, Lacre_03_EM, Lacre_04_EM
				From 
					Container_Mas_Exp_Mar, Tipo_Container 
				Where
					Container_Mas_Exp_Mar.Cd_Tp_Cont = Tipo_Container.Cd_Tp_Cont AND 
					Num_Proc_MEM =@Num_Proc and Item_Cont_EM = @Item
				Group by 
					Num_Proc_MEM, Item_Cont_EM, Container_Mas_Exp_Mar.Cd_Tp_Cont, 
					Num_Cont_EM, Num_Lacre_EM, Nome_Tp_Cont, Peso_Bruto_EM, 
					Regime_EM, ID_ISO, Tara_EM, Lacre_02_EM, Lacre_03_EM, Lacre_04_EM
		End 
	Else
		Begin 
			If @Conteiner <> '' 
				Select 
					Num_Proc_MEM, Item_Cont_EM, Container_Mas_Exp_Mar.Cd_Tp_Cont, 
					Num_Cont_EM, Num_Lacre_EM, Nome_Tp_Cont, Peso_Bruto_EM, 
					Regime_EM, ID_ISO, Tara_EM, Lacre_02_EM, Lacre_03_EM, Lacre_04_EM
				From 
					Container_Mas_Exp_Mar, Tipo_Container 
				Where
					Container_Mas_Exp_Mar.Cd_Tp_Cont = Tipo_Container.Cd_Tp_Cont and 
					Num_Cont_EM = @Conteiner 
				Order by 
					Num_Cont_EM
			Else 
				Select 
					Num_Proc_MEM, Item_Cont_EM, Container_Mas_Exp_Mar.Cd_Tp_Cont, 
					Num_Cont_EM, Num_Lacre_EM, Nome_Tp_Cont, Peso_Bruto_EM, 
					Regime_EM, ID_ISO, Tara_EM, Lacre_02_EM, Lacre_03_EM, Lacre_04_EM
				From 
					Container_Mas_Exp_Mar, Tipo_Container 
				Where
					Container_Mas_Exp_Mar.Cd_Tp_Cont = Tipo_Container.Cd_Tp_Cont 
				Group by 
					Num_Proc_MEM, Item_Cont_EM, Container_Mas_Exp_Mar.Cd_Tp_Cont, 
					Num_Cont_EM, Num_Lacre_EM, Nome_Tp_Cont, Peso_Bruto_EM, 
					Regime_EM, ID_ISO, Tara_EM, Lacre_02_EM, Lacre_03_EM, Lacre_04_EM
				Order by 
					Num_Cont_EM
		End



GO
