SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO






CREATE PROCEDURE pVolImpAer_Ins
(
@Num_Proc_HIA		varchar(14),
@Item_IA 			varchar(2),
@Qtd_Vol_IA			Float, 
@Compr_IA			Float, 
@Largura_IA			Float, 
@Altura_IA			Float, 
@Cd_Tp_Unidade		VarChar(3),
@Vol_Item_IA 			Float 
)
 AS
	Insert Into 
		Volume_Imp_Aer
		(Item_IA, Num_Proc_HIA, Qtd_Vol_IA, Compr_IA, Largura_IA, Altura_IA, Cd_Tp_Unidade, Vol_Item_IA )
	Values 
		(@Item_IA, @Num_Proc_HIA, @Qtd_Vol_IA, @Compr_IA, @Largura_IA, @Altura_IA, @Cd_Tp_Unidade, @Vol_Item_IA )






GO
