SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[pReEmiteNF_Upd] 
(
@NF		VarChar(12),
@Site		Char(1), 
@NewNF 	Int Output 
)
AS
	Begin Transaction 
	Set @NewNF = IsNull((Select Ult_NF_SP From Referencia Where Ref_Acesso = @Site),0) + 1 
	Update 
		Cta_Cte_Hou_Imp_Mar 
	Set
		Num_NF_HIM = @NewNF
	Where
		Num_NF_HIM = @NF and
		Ref_Acesso_NF_HIM = @Site 

	Update 
		Cta_Cte_Hou_Imp_Out
	Set
		Num_NF_HIO = @NewNF
	Where
		Num_NF_HIO = @NF and
		Ref_Acesso_NF_HIO = @Site 

	Update 
		Cta_Cte_Hou_Exp_Mar 
	Set
		Num_NF_HEM = @NewNF  
	Where
		Num_NF_HEM = @NF and
		Ref_Acesso_NF_HEM = @Site 

	Update 
		Cta_Cte_Hou_Exp_Out
	Set
		Num_NF_HEO = @NewNF  
	Where
		Num_NF_HEO = @NF and
		Ref_Acesso_NF_HEO = @Site 

	Update 
		Cta_Cte_Hou_Imp_Aer
	Set
		Num_NF_HIA = @NewNF  
	Where
		Num_NF_HIA = @NF and
		Ref_Acesso_NF_HIA = @Site 
	Update 
		Cta_Cte_Hou_Exp_Aer
	Set
		Num_NF_HEA = @NewNF  
	Where
		Num_NF_HEA = @NF and
		Ref_Acesso_NF_HEA = @Site 
	Update 
		Cta_Cte_Mas_Imp_Mar 
	Set
		Num_NF_MIM = @NewNF
	Where
		Num_NF_MIM = @NF and
		Ref_Acesso_NF_MIM = @Site 
	Update 
		Cta_Cte_Mas_Exp_Mar 
	Set
		Num_NF_MEM = @NewNF  
	Where
		Num_NF_MEM = @NF and
		Ref_Acesso_NF_MEM = @Site 
	Update 
		Cta_Cte_Mas_Imp_Aer
	Set
		Num_NF_MIA = @NewNF  
	Where
		Num_NF_MIA = @NF and
		Ref_Acesso_NF_MIA = @Site 
	Update 
		Cta_Cte_Mas_Exp_Aer
	Set
		Num_NF_MEA = @NewNF  
	Where
		Num_NF_MEA = @NF and
		Ref_Acesso_NF_MEA = @Site 
	Insert 
		Base_Nota_Fiscal
		(Nota_Fiscal, Ref_Acesso, Cd_Pes, Tipo_Serv, Condicoes, Prazo, Cd_Status, Valor_Total)
	(Select @NewNF,  @Site, Cd_Pes, Tipo_Serv, Condicoes, Prazo, 0, Valor_Total From Base_Nota_Fiscal Where Nota_Fiscal = @NF and Ref_Acesso = @Site )
	If @@RowCount =1 
		Begin 
			Update 
				Referencia 
			Set 
				Ult_NF_SP = @NewNF
			Where 
				Ref_Acesso = @Site
	
			If @@RowCount <> 1 
				Begin 
					RollBack Transaction 
					Return -1 
				End 
			Update 
				Base_Nota_Fiscal 
			Set 
				Cd_Status = 2,	
				RPS_Envio = 0  
			Where 
				Nota_Fiscal = @NF and
				Ref_Acesso = @Site 
			If @@RowCount = 1
				Begin 
					Commit Transaction 
					Return 1 
				End 
			Else
				Begin 
					RollBack Transaction 
					Return -2 
				End 
		End 
	Else
		Begin 
			RollBack Transaction 
			Return -1 
		End

GO
