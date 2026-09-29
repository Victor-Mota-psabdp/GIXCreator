SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO






CREATE PROCEDURE pVolExpAer_Upd
(
@Num_Proc_HEA		varchar(16),
@Item_EA 			varchar(2),
@Qtd_Vol_EA			Float, 
@Compr_EA			Float, 
@Largura_EA			Float, 
@Altura_EA			Float, 
@Cd_Tp_Unidade		VarChar(3),
@Vol_Item_EA 			Float 
)
 AS
	Update
		Volume_Exp_Aer
	Set 
		Qtd_Vol_EA = @Qtd_Vol_EA, 
		Compr_EA = @Compr_EA, 
		Largura_EA = @Largura_EA, 
		Altura_EA = @Altura_EA, 
		Cd_Tp_Unidade = @Cd_Tp_Unidade, 
		Vol_Item_EA =@Vol_Item_EA
	Where
		Num_Proc_HEA= @Num_Proc_HEA and  
		Item_EA = @Item_EA
GO
