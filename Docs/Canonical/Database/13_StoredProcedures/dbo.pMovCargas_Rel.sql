SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pMovCargas_Rel
(
@StrMachine		VarChar(30)
)
AS
	Select 
		Cliente = 
		Case 
			When LCL.Cliente Is Null Then FCL.Cliente 
			Else LCL.Cliente 
		End, 
		Origem = 
		Case 
			When LCL.Origem Is Null Then FCL.Origem
			Else LCL.Origem 
		End, 
		Destino = 
		Case 
			When LCL.Destino Is Null then FCL.Destino 
			Else LCL.Destino 
		End, 
		Modal = 
		Case 
			When LCL.Modal Is Null then FCL.Modal 
			Else LCL.Modal 
		End,
		LCL.Embarques  as LCL_Embarques, LCL.Frete_CC as LCL_Frete_CC, LCL.Frete_PP  as LCL_Frete_PP, LCL.Peso as LCL_Peso, 
		FCL.Embarques  as FCL_Embarques, FCL.Frete_CC as FCL_Frete_CC, FCL.Frete_PP  as FCL_Frete_PP, FCL.Peso as FCL_Peso,
		FCL.Qtd_CC_20, FCL.Qtd_CC_40    
	From 
		Tmp_Mov_Cargas_LCL as LCL Full Outer Join Tmp_Mov_Cargas_FCL  as FCL on FCL.StrMachine = LCL.StrMachine and FCL.Cliente = LCL.Cliente  and FCL.Modal = LCL.Modal and FCL.ORigem = LCL.Origem and FCL.Destino = LCL.Destino 
	Where
		LCL.StrMachine = @StrMachine or FCL.StrMachine = @StrMachine


GO
