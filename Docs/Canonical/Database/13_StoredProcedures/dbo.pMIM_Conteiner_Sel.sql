SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[pMIM_Conteiner_Sel] 
(
@Num_Proc		VarChar(14)='',
@Item			VarChar(2)='',
@Conteiner 		VarChar(15)=''
)
 AS	
	Declare @Itens as Int 
	Set @Itens = IsNull((Select Count(*) From Container_Mas_Imp_Mar Where Num_Proc_MIM =@Num_Proc),0)
	If @Num_Proc <> '' 
		Begin 
			If @Item = '' 
				Select 
					Num_Proc_MIM, Item_Cont_IM, Container_Mas_Imp_Mar.Cd_Tp_Cont, 
					Num_Cont_IM, Num_Lacre_IM, Nome_Tp_Cont, Dt_Vcto_Devol_IM, Dt_Devol_IM, @Itens  as Itens ,
					Peso_Bruto_IM, 
--					Regime_IM, 
					ID_ISO, Tara_IM, Lacre_02_IM, Lacre_03_IM, Lacre_04_IM, DataDevCli_IM			
				From 
					Container_Mas_Imp_Mar, Tipo_Container 
				Where
					Container_Mas_Imp_Mar.Cd_Tp_Cont = Tipo_Container.Cd_Tp_Cont AND 
					Num_Proc_MIM =@Num_Proc
				Group by 
					Num_Proc_MIM, Item_Cont_IM, Container_Mas_Imp_Mar.Cd_Tp_Cont, 
					Num_Cont_IM, Num_Lacre_IM, Nome_Tp_Cont,  Dt_Vcto_Devol_IM, Dt_Devol_IM,
					Peso_Bruto_IM, 
--					Regime_IM, 
					ID_ISO, Tara_IM, Lacre_02_IM, Lacre_03_IM, Lacre_04_IM, DataDevCli_IM
			Else
				Select 
					Num_Proc_MIM, Item_Cont_IM, Container_Mas_Imp_Mar.Cd_Tp_Cont, 
					Num_Cont_IM, Num_Lacre_IM, Nome_Tp_Cont, Dt_Vcto_Devol_IM, Dt_Devol_IM, @Itens  as Itens,
					Peso_Bruto_IM, 
--					Regime_IM, 
					ID_ISO, Tara_IM, Lacre_02_IM, Lacre_03_IM, Lacre_04_IM, DataDevCli_IM			
				From 
					Container_Mas_Imp_Mar, Tipo_Container 
				Where
					Container_Mas_Imp_Mar.Cd_Tp_Cont = Tipo_Container.Cd_Tp_Cont AND 
					Num_Proc_MIM =@Num_Proc and Item_Cont_IM= @Item
				Group by 
					Num_Proc_MIM, Item_Cont_IM, Container_Mas_Imp_Mar.Cd_Tp_Cont, 
					Num_Cont_IM, Num_Lacre_IM, Nome_Tp_Cont,  Dt_Vcto_Devol_IM, Dt_Devol_IM,
					Peso_Bruto_IM, 
--					Regime_IM, 
					ID_ISO, Tara_IM, Lacre_02_IM, Lacre_03_IM, Lacre_04_IM, DataDevCli_IM
		End 
	Else
		Begin 
			If @Conteiner <> '' 
				Select 
					Num_Proc_MIM, Nome_Tp_Cont, Num_Cont_IM, Num_Lacre_IM,
					Peso_Bruto_IM, 
--					Regime_IM, 
					ID_ISO, Tara_IM, Lacre_02_IM, Lacre_03_IM, Lacre_04_IM			
				From 
					Container_Mas_Imp_Mar, 
					Tipo_Container 
				Where 
					Container_Mas_Imp_Mar.Cd_Tp_Cont = Tipo_Container.Cd_Tp_Cont and
					Num_Cont_IM = @Conteiner
				Order By
					Num_Cont_IM
			Else 
				Select 
					 Num_Proc_MIM, Nome_Tp_Cont, Num_Cont_IM, Num_Lacre_IM,
					Peso_Bruto_IM, 
--					Regime_IM, 
					ID_ISO, Tara_IM, Lacre_02_IM, Lacre_03_IM, Lacre_04_IM			 
				From 
					Container_Mas_Imp_Mar, 
					Tipo_Container 
				Where 
					Container_Mas_Imp_Mar.Cd_Tp_Cont = Tipo_Container.Cd_Tp_Cont 
				Order By
					Num_Cont_IM
		End
GO
