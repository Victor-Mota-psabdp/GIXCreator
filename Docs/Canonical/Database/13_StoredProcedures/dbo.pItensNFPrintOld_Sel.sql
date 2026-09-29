SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pItensNFPrintOld_Sel 
(
@NF		VarChar(12),
@Site		Char(1) 
)
AS
	Select 
		CteC.Num_Proc_HIM as Num_Proc, CteC.CD_TP_TX, TT.Nome_Tp_Tx, Sum(CteC.Vlr_Pgto_NF_HIM) - IsNull(Sum(CteD.Vlr_Pgto_NF_HIM),0) as ValorItem 
	From 
		Cta_Cte_Hou_Imp_Mar as CteC Left Outer Join Cta_Cte_Hou_Imp_Mar as CteD on (CteC.Num_Proc_Him= CteD.Num_Proc_HIM and CteC.Cd_Tp_Tx = CteD.Cd_Tp_Tx and CteC.Num_NF_HIM = CteD.Num_NF_HIM and CteC.Ref_Acesso_NF_HIM= CteD.Ref_Acesso_NF_HIM and CteD.DC_HIM = 'D')
		Left Outer Join Tipo_Taxa as TT on CteC.Cd_Tp_Tx = TT.Cd_Tp_Tx 
	Where
		CteC.DC_HIM = 'C'  and 
		CteC.Num_NF_HIM = @NF and 
		CteC.Ref_Acesso_NF_HIM = @Site 
	Group by 
		CteC.Num_Proc_HIM, CteC.Cd_Tp_Tx, TT.Nome_Tp_Tx
	Union 
	Select 
		CteC.Num_Proc_HIA as Num_Proc , CteC.CD_TP_TX, TT.Nome_Tp_Tx,Sum(CteC.Vlr_Pgto_NF_HIA) - IsNull(Sum(CteD.Vlr_Pgto_NF_HIA),0) as ValorItem 
	From 
		Cta_Cte_Hou_Imp_Aer as CteC Left Outer Join Cta_Cte_Hou_Imp_Aer as CteD on (CteC.Num_Proc_HIA = CteD.Num_Proc_HIA and CteC.Cd_Tp_Tx = CteD.Cd_Tp_Tx and CteC.Num_NF_HIA = CteD.Num_NF_HIA and CteC.Ref_Acesso_NF_HIA= CteD.Ref_Acesso_NF_HIA and CteD.DC_HIA = 'D')
		Left Outer Join Tipo_Taxa as TT on CteC.Cd_Tp_Tx = TT.Cd_Tp_Tx 
	Where
		CteC.DC_HIA = 'C'  and 
		CteC.Num_NF_HIA = @NF and 
		CteC.Ref_Acesso_NF_HIA = @Site 
	Group by 
		CteC.Num_Proc_HIA, CteC.Cd_Tp_Tx, TT.Nome_Tp_Tx
	Union 
	Select 
		CteC.Num_Proc_HEM as Num_Proc , CteC.CD_TP_TX, TT.Nome_Tp_Tx, Sum(CteC.Vlr_Pgto_NF_HEM) - IsNull(Sum(CteD.Vlr_Pgto_NF_HEM),0) as ValorItem 
	From 
		Cta_Cte_Hou_Exp_Mar as CteC Left Outer Join Cta_Cte_Hou_Exp_Mar as CteD on (CteC.Num_Proc_HEM= CteD.Num_Proc_HEM and CteC.Cd_Tp_Tx = CteD.Cd_Tp_Tx and CteC.Num_NF_HEM = CteD.Num_NF_HEM and CteC.Ref_Acesso_NF_HEM= CteD.Ref_Acesso_NF_HEM and CteD.DC_HEM = 'D')
		Left Outer Join Tipo_Taxa as TT on CteC.Cd_Tp_Tx = TT.Cd_Tp_Tx 
	Where
		CteC.DC_HEM = 'C'  and 
		CteC.Num_NF_HEM = @NF and 
		CteC.Ref_Acesso_NF_HEM = @Site  
	Group by 
		CteC.Num_Proc_HEM, CteC.Cd_Tp_Tx, TT.Nome_Tp_Tx
	Union 
	Select 
		CteC.Num_Proc_HEA as Num_Proc , CteC.CD_TP_TX, TT.Nome_Tp_Tx, Sum(CteC.Vlr_Pgto_NF_HEA) - IsNull(Sum(CteD.Vlr_Pgto_NF_HEA),0) as ValorItem 
	From 
		Cta_Cte_Hou_Exp_Aer as CteC Left Outer Join Cta_Cte_Hou_Exp_Aer as CteD on (CteC.Num_Proc_HEA= CteD.Num_Proc_HEA and CteC.Cd_Tp_Tx = CteD.Cd_Tp_Tx and CteC.Num_NF_HEA = CteD.Num_NF_HEA and CteC.Ref_Acesso_NF_HEA= CteD.Ref_Acesso_NF_HEA and CteD.DC_HEA = 'D')
		Left Outer Join Tipo_Taxa as TT on CteC.Cd_Tp_Tx = TT.Cd_Tp_Tx 
	Where
		CteC.DC_HEA = 'C'  and 
		CteC.Num_NF_HEA = @NF and 
		CteC.Ref_Acesso_NF_HEA = @Site 
	Group by 
		CteC.Num_Proc_HEA, CteC.Cd_Tp_Tx, TT.Nome_Tp_Tx
	Union 
	Select 
		CteC.Num_Proc_MIM as Num_Proc , CteC.CD_TP_TX, TT.Nome_Tp_Tx, Sum(CteC.Vlr_Pgto_NF_MIM) - IsNull(Sum(CteD.Vlr_Pgto_NF_MIM),0) as ValorItem 
	From 
		Cta_Cte_Mas_Imp_Mar as CteC Left Outer Join Cta_Cte_Mas_Imp_Mar as CteD on (CteC.Num_Proc_MIM= CteD.Num_Proc_MIM and CteC.Cd_Tp_Tx = CteD.Cd_Tp_Tx and CteC.Num_NF_MIM = CteD.Num_NF_MIM and CteC.Ref_Acesso_NF_MIM= CteD.Ref_Acesso_NF_MIM and CteD.DC_MIM = 'D')
		Left Outer Join Tipo_Taxa as TT on CteC.Cd_Tp_Tx = TT.Cd_Tp_Tx 
	Where
		CteC.DC_MIM = 'C'  and 
		CteC.Num_NF_MIM = @NF and 
		CteC.Ref_Acesso_NF_MIM = @Site 
	Group by 
		CteC.Num_Proc_MIM, CteC.Cd_Tp_Tx, TT.Nome_Tp_Tx
	Union 
	Select 
		CteC.Num_Proc_MIA as Num_Proc , CteC.CD_TP_TX, TT.Nome_Tp_Tx, Sum(CteC.Vlr_Pgto_NF_MIA) - IsNull(Sum(CteD.Vlr_Pgto_NF_MIA),0) as ValorItem 
	From 
		Cta_Cte_Mas_Imp_Aer as CteC Left Outer Join Cta_Cte_Mas_Imp_Aer as CteD on (CteC.Num_Proc_MIA = CteD.Num_Proc_MIA and CteC.Cd_Tp_Tx = CteD.Cd_Tp_Tx and CteC.Num_NF_MIA = CteD.Num_NF_MIA and CteC.Ref_Acesso_NF_MIA= CteD.Ref_Acesso_NF_MIA and CteD.DC_MIA = 'D')
		Left Outer Join Tipo_Taxa as TT on CteC.Cd_Tp_Tx = TT.Cd_Tp_Tx 
	Where
		CteC.DC_MIA = 'C'  and 
		CteC.Num_NF_MIA = @NF and 
		CteC.Ref_Acesso_NF_MIA = @Site 
	Group by 
		CteC.Num_Proc_MIA, CteC.Cd_Tp_Tx, TT.Nome_Tp_Tx
	Union 
	Select 
		CteC.Num_Proc_MEM as Num_Proc , CteC.CD_TP_TX, TT.Nome_Tp_Tx, Sum(CteC.Vlr_Pgto_NF_MEM) - IsNull(Sum(CteD.Vlr_Pgto_NF_MEM),0) as ValorItem 
	From 
		Cta_Cte_Mas_Exp_Mar as CteC Left Outer Join Cta_Cte_Mas_Exp_Mar as CteD on (CteC.Num_Proc_MEM= CteD.Num_Proc_MEM and CteC.Cd_Tp_Tx = CteD.Cd_Tp_Tx and CteC.Num_NF_MEM = CteD.Num_NF_MEM and CteC.Ref_Acesso_NF_MEM= CteD.Ref_Acesso_NF_MEM and CteD.DC_MEM = 'D')
		Left Outer Join Tipo_Taxa as TT on CteC.Cd_Tp_Tx = TT.Cd_Tp_Tx 
	Where
		CteC.DC_MEM = 'C'  and 
		CteC.Num_NF_MEM = @NF and 
		CteC.Ref_Acesso_NF_MEM = @Site  
	Group by 
		CteC.Num_Proc_MEM, CteC.Cd_Tp_Tx, TT.Nome_Tp_Tx
	Union 
	Select 
		CteC.Num_Proc_MEA as Num_Proc , CteC.CD_TP_TX, TT.Nome_Tp_Tx, Sum(CteC.Vlr_Pgto_NF_MEA) - IsNull(Sum(CteD.Vlr_Pgto_NF_MEA),0) as ValorItem 
	From 
		Cta_Cte_Mas_Exp_Aer as CteC Left Outer Join Cta_Cte_Mas_Exp_Aer as CteD on (CteC.Num_Proc_MEA= CteD.Num_Proc_MEA and CteC.Cd_Tp_Tx = CteD.Cd_Tp_Tx and CteC.Num_NF_MEA = CteD.Num_NF_MEA and CteC.Ref_Acesso_NF_MEA= CteD.Ref_Acesso_NF_MEA and CteD.DC_MEA = 'D')
		Left Outer Join Tipo_Taxa as TT on CteC.Cd_Tp_Tx = TT.Cd_Tp_Tx 
	Where
		CteC.DC_MEA = 'C'  and 
		CteC.Num_NF_MEA = @NF and 
		CteC.Ref_Acesso_NF_MEA = @Site 
	Group by 
		CteC.Num_Proc_MEA, CteC.Cd_Tp_Tx, TT.Nome_Tp_Tx

GO
