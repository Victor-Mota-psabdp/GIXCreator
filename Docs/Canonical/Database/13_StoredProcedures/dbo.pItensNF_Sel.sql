SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE pItensNF_Sel  
(
@NF		VarChar(6),
@Site		Char(1)
)
AS
	Select 
		Cte.Vlr_Pgto_NF_HIM as Vlr_Pgto, TT.Nome_Tp_Tx, Cte.Cd_Tp_Tx
	From 
		Cta_Cte_Hou_Imp_Mar as Cte Join Tipo_Taxa as TT on Cte.Cd_Tp_Tx = TT.Cd_Tp_Tx 
	Where
		Cte.Num_NF_HIM = @NF  and
		Ref_Acesso_NF_HIM = @Site 
	
	Union 
	Select 
		Cte.Vlr_Pgto_NF_HEM as Vlr_Pgto, TT.Nome_Tp_Tx, Cte.Cd_Tp_Tx
	From 
		Cta_Cte_Hou_Exp_Mar as Cte Join Tipo_Taxa as TT on Cte.Cd_Tp_Tx = TT.Cd_Tp_Tx 
	Where
		Cte.Num_NF_HEM = @NF and
		Ref_Acesso_NF_HEM = @Site 
	
	Union
	Select 
		Cte.Vlr_Pgto_NF_HIA as Vlr_Pgto, TT.Nome_Tp_Tx, Cte.Cd_Tp_Tx
	From 
		Cta_Cte_Hou_Imp_Aer as Cte Join Tipo_Taxa as TT on Cte.Cd_Tp_Tx = TT.Cd_Tp_Tx 
	Where
		Cte.Num_NF_HIA = @NF and
		Ref_Acesso_NF_HIA = @Site 
		
	Union
	Select 
		Cte.Vlr_Pgto_NF_HEA as Vlr_Pgto, TT.Nome_Tp_Tx, Cte.Cd_Tp_Tx
	From 
		Cta_Cte_Hou_Exp_Aer as Cte Join Tipo_Taxa as TT on Cte.Cd_Tp_Tx = TT.Cd_Tp_Tx 
	Where
		Cte.Num_NF_HEA = @NF and
		Ref_Acesso_NF_HEA = @Site 
	Union
	Select 
		Cte.Vlr_Pgto_NF_MIM as Vlr_Pgto, TT.Nome_Tp_Tx, Cte.Cd_Tp_Tx
	From 
		Cta_Cte_Mas_Imp_Mar as Cte Join Tipo_Taxa as TT on Cte.Cd_Tp_Tx = TT.Cd_Tp_Tx 
	Where
		Cte.Num_NF_MIM = @NF and
		Ref_Acesso_NF_MIM = @Site 
	
	Union 
	Select 
		Cte.Vlr_Pgto_NF_MEM as Vlr_Pgto, TT.Nome_Tp_Tx, Cte.Cd_Tp_Tx
	From 
		Cta_Cte_Mas_Exp_Mar as Cte Join Tipo_Taxa as TT on Cte.Cd_Tp_Tx = TT.Cd_Tp_Tx 
	Where
		Cte.Num_NF_MEM = @NF and
		Ref_Acesso_NF_MEM = @Site  
	
	Union
	Select 
		Cte.Vlr_Pgto_NF_MIA as Vlr_Pgto, TT.Nome_Tp_Tx, Cte.Cd_Tp_Tx
	From 
		Cta_Cte_Mas_Imp_Aer as Cte Join Tipo_Taxa as TT on Cte.Cd_Tp_Tx = TT.Cd_Tp_Tx 
	Where
		Cte.Num_NF_MIA = @NF  and
		Ref_Acesso_NF_MIA = @Site 
		
	Union
	Select 
		Cte.Vlr_Pgto_NF_MEA as Vlr_Pgto, TT.Nome_Tp_Tx, Cte.Cd_Tp_Tx
	From 
		Cta_Cte_Mas_Exp_Aer as Cte Join Tipo_Taxa as TT on Cte.Cd_Tp_Tx = TT.Cd_Tp_Tx 
	Where
		Cte.Num_NF_MEA = @NF and
		Ref_Acesso_NF_MEA = @Site



GO
