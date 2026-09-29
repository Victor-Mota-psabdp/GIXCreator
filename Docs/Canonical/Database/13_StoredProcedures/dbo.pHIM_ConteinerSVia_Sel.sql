SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[pHIM_ConteinerSVia_Sel] 
(
@Num_Proc		VarChar(16) 
)
 AS	
	Select 
		CMIM.Num_Proc_MIM, CMIM.Item_Cont_IM, 
		Num_Proc_HIM, CMIM.Cd_Tp_Cont, Num_Cont_IM, Num_Lacre_IM, 
		Nome_Tp_Cont, Dt_Vcto_Devol_IM,Dt_Devol_IM, Cd_CC_Ofc, Cd_Term_Ofc,
--		Regime_IM, 
		ID_ISO, Tara_IM, CMIM.Peso_Bruto_IM
	From 
		Container_Mas_Imp_Mar as CMIM  Join Volume_Imp_Mar as VIM  on (CMIM.Num_Proc_MIM = Left(VIM.Num_Proc_HIM, 14) and CMIM.Item_Cont_IM = VIM.Item_Cont_IM )
		Join Tipo_Container as TC on CMIM.Cd_Tp_Cont = TC.Cd_Tp_Cont 
		Join Master_Imp_Mar as MIM on MIM.Num_Proc_MIM = Left(@Num_Proc, 14) 
		Left Outer Join Terminal as Term on MIM.Cd_Terminal = Term.Cd_Terminal
	Where
		VIM.Num_Proc_HIM = @Num_Proc and 
		CMIM.Cd_Tp_Cont <> 'LCL'



GO
