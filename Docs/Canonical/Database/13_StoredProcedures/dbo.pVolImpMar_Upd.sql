SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pVolImpMar_Upd
(
@Num_Proc_HIM		varchar(16),
@Item_IM 			varchar(2),
@Qtd_Vol_IM			Float, 
@Compr_IM			Float, 
@Largura_IM			Float, 
@Altura_IM			Float, 
@Cd_Tp_Unidade		VarChar(3),
@Vol_Item_IM 			Float,
@Id_NCM			int,
@Peso_Bruto_IM		float,
@Cd_Tp_Embal			int,
@Marca_IM			varchar(60),
@Contra_Marca			varchar(60),
@Item_Cont_IM			char(2) 
)
 AS
	Update
		Volume_Imp_Mar
	Set 
		Qtd_Vol_IM = @Qtd_Vol_IM, 
		Compr_IM = @Compr_IM, 
		Largura_IM = @Largura_IM, 
		Altura_IM = @Altura_IM, 
		Cd_Tp_Unidade = @Cd_Tp_Unidade, 
		Vol_Item_IM =@Vol_Item_IM,
		Id_NCM = @Id_NCM,
		Peso_Bruto_IM = @Peso_Bruto_IM, 
		Cd_Tp_Embal = @Cd_Tp_Embal, 
		Marca_IM = @Marca_IM, 
		Contra_Marca = @Contra_Marca,
		Item_Cont_IM = @Item_Cont_IM
	Where
		Num_Proc_HIM = @Num_Proc_HIM and  
		Item_IM = @Item_IM



GO
