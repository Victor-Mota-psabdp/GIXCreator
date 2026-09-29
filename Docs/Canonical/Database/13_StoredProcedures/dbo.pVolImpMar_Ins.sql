SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pVolImpMar_Ins
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
	Insert Into 
		Volume_Imp_Mar
		(Item_IM, Num_Proc_HIM, Qtd_Vol_IM, Compr_IM, Largura_IM, Altura_IM, Cd_Tp_Unidade, Vol_Item_IM, Id_NCM, Peso_Bruto_IM, Cd_Tp_Embal, Marca_IM, Contra_Marca, Item_Cont_IM)
	Values 
		(@Item_IM, @Num_Proc_HIM, @Qtd_Vol_IM, @Compr_IM, @Largura_IM, @Altura_IM, @Cd_Tp_Unidade, @Vol_Item_IM, @Id_NCM, @Peso_Bruto_IM, @Cd_Tp_Embal, @Marca_IM, @Contra_Marca, @Item_Cont_IM)

GO
