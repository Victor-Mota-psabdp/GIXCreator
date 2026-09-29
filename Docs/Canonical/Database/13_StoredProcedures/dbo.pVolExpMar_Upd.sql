SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE  PROCEDURE pVolExpMar_Upd
(
@Num_Proc_HEM		varchar(16),
@Item_EM 			varchar(2),
@Qtd_Vol_EM			Float, 
@Compr_EM			Float, 
@Largura_EM			Float, 
@Altura_EM			Float, 
@Cd_Tp_Unidade		VarChar(3),
@Vol_Item_EM 			Float,
@ID_NCM			int,
@Peso_Bruto_EM		float,
@Cd_Tp_Embal			VarChar(3),
@Marca_EM			varchar(60),
@Contra_Marca_SM		varchar(60),
@Item_Cont_EM		Char(2)
)
 AS
	Update
		Volume_Exp_Mar
	Set 
		Qtd_Vol_EM = @Qtd_Vol_EM, 
		Compr_EM = @Compr_EM, 
		Largura_EM = @Largura_EM, 
		Altura_EM = @Altura_EM, 
		Cd_Tp_Unidade = @Cd_Tp_Unidade, 
		Vol_Item_EM =@Vol_Item_EM,
		ID_NCM=@ID_NCM,
		Peso_Bruto_EM=@Peso_Bruto_EM,
		Cd_Tp_Embal=@Cd_Tp_Embal,
		Marca_EM=@Marca_EM,
		Contra_Marca=@Contra_Marca_SM,
		Item_Cont_EM = @Item_Cont_EM
	Where
		Num_Proc_HEM = @Num_Proc_HEM and  
		Item_EM = @Item_EM

GO
