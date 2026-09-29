SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO






CREATE PROCEDURE pVolExpAer_Ins
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
	Declare @QtdVol	Float
	Declare @VolTotal	Float
	Insert Into 
		Volume_Exp_Aer
		(Item_EA,Num_Proc_HEA, Qtd_Vol_EA, Compr_EA, Largura_EA, Altura_EA, Cd_Tp_Unidade, Vol_Item_EA )
	Values 
		(@Item_EA, @Num_Proc_HEA, @Qtd_Vol_EA, @Compr_EA, @Largura_EA, @Altura_EA, @Cd_Tp_Unidade, @Vol_Item_EA )
GO
