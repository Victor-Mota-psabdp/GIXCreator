SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spPOLA_Sel]--'LA2010070100'

@Num_LA varchar(14)

as
	Select 
		ID_PO_LA, Numero_PO, Data_PO, PO.Id_DC, Nome_Arquivo, Dt_Envio, isnull(Paridade,0) Paridade, 
		isnull(Valor,0) Valor, isnull(Gravado,0) Gravado, isnull(IVA,0) IVA, isnull(Valor_USD,0) Valor_USD, isnull(Gravado_USD,0) Gravado_USD, isnull(IVA_USD,0) IVA_USD,
		isnull(CAI,'') CAI, CAI_Vcto,Ing_Brt,Ing_Brt_USD,Ret,Ret_USD
	From 
		PO_LA PO
	where 
		Num_LA=@Num_LA order by ID_PO_LA




GO
