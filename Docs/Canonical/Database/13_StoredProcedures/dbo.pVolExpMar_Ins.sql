SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE  PROCEDURE pVolExpMar_Ins
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
	Declare @QtdVol	Float
	Declare @VolTotal	Float
	Insert Into 
		Volume_Exp_Mar
		(Item_EM,Num_Proc_HEM, Qtd_Vol_EM, Compr_EM, Largura_EM, Altura_EM, Cd_Tp_Unidade, Vol_Item_EM, ID_NCM, Peso_Bruto_EM, Cd_Tp_Embal, Marca_EM, Contra_Marca, Item_Cont_EM)
	Values 
		(@Item_EM, @Num_Proc_HEM, @Qtd_Vol_EM, @Compr_EM, @Largura_EM, @Altura_EM, @Cd_Tp_Unidade, @Vol_Item_EM, @ID_NCM, @Peso_Bruto_EM, @Cd_Tp_Embal, @Marca_EM, @Contra_Marca_SM, @Item_Cont_EM)

GO
