SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[pCancelaNF_Upd] 
(
@NF		VarChar(12),
@Site		Char(1)
)
AS
	Begin Transaction 
	Update 
		Cta_Cte_Hou_Imp_Mar 
	Set
		Num_NF_HIM = Null,  
		Vlr_Pgto_NF_HIM = Null, 
		Par_NF_HIM = Null 
	Where
		Num_NF_HIM = @NF and 
		Ref_Acesso_NF_HIM = @Site 

	Update 
		Cta_Cte_Hou_Imp_Out
	Set
		Num_NF_HIO = Null,  
		Vlr_Pgto_NF_HIO = Null, 
		Par_NF_HIO = Null 
	Where
		Num_NF_HIO = @NF and 
		Ref_Acesso_NF_HIO = @Site 

	Update 
		Cta_Cte_Hou_Exp_Mar 
	Set
		Num_NF_HEM = Null,  
		Vlr_Pgto_NF_HEM = Null, 
		Par_NF_HEM = Null 
	Where
		Num_NF_HEM = @NF and
		Ref_Acesso_NF_HEM = @Site 

	Update 
		Cta_Cte_Hou_Exp_Out
	Set
		Num_NF_HEO = Null,  
		Vlr_Pgto_NF_HEO = Null, 
		Par_NF_HEO = Null 
	Where
		Num_NF_HEO = @NF and
		Ref_Acesso_NF_HEO = @Site 

	Update 
		Cta_Cte_Hou_Imp_Aer
	Set
		Num_NF_HIA = Null,  
		Vlr_Pgto_NF_HIA = Null, 
		Par_NF_HIA = Null 
	Where
		Num_NF_HIA = @NF and
		Ref_Acesso_NF_HIA = @Site 
	Update 
		Cta_Cte_Hou_Exp_Aer
	Set
		Num_NF_HEA = Null,  
		Vlr_Pgto_NF_HEA = Null, 
		Par_NF_HEA = Null 
	Where
		Num_NF_HEA = @NF and
		Ref_Acesso_NF_HEA = @Site 
	Update 
		Cta_Cte_Mas_Imp_Mar 
	Set
		Num_NF_MIM = Null,  
		Vlr_Pgto_NF_MIM = Null, 
		Par_NF_MIM = Null 
	Where
		Num_NF_MIM = @NF and
		Ref_Acesso_NF_MIM = @Site 
	Update 
		Cta_Cte_Mas_Exp_Mar 
	Set
		Num_NF_MEM = Null,  
		Vlr_Pgto_NF_MEM = Null, 
		Par_NF_MEM = Null 
	Where
		Num_NF_MEM = @NF and
		Ref_Acesso_NF_MEM = @Site 
	Update 
		Cta_Cte_Mas_Imp_Aer
	Set
		Num_NF_MIA = Null,  
		Vlr_Pgto_NF_MIA = Null, 
		Par_NF_MIA = Null 
	Where
		Num_NF_MIA = @NF and
		Ref_Acesso_NF_MIA = @Site 
	Update 
		Cta_Cte_Mas_Exp_Aer
	Set
		Num_NF_MEA = Null,  
		Vlr_Pgto_NF_MEA = Null, 
		Par_NF_MEA = Null 
	Where
		Num_NF_MEA = @NF and
		Ref_Acesso_NF_MEA = @Site 

	Update 
		Base_Nota_Fiscal
	Set 
		Cd_Status = 2,
		RPS_Envio = 0 
	Where
		Nota_Fiscal = @NF and 
		Ref_Acesso = @Site
	If @@RowCount =1 
		Begin 
			Commit Transaction 
			Return 1 
		End 
	Else
		Begin 
			RollBack Transaction 
			Return -1 
		End

GO
