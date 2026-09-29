SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO






CREATE PROCEDURE pVolImpAer_Upd
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
	Update
		Volume_Imp_Aer
	Set 
		Qtd_Vol_IA = @Qtd_Vol_IA, 
		Compr_IA = @Compr_IA, 
		Largura_IA = @Largura_IA, 
		Altura_IA = @Altura_IA, 
		Cd_Tp_Unidade = @Cd_Tp_Unidade, 
		Vol_Item_IA =@Vol_Item_IA
	Where
		Num_Proc_HIA= @Num_Proc_HIA and  
		Item_IA = @Item_IA






GO
