SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pCotacao_Sel 
(
@Num_Cot	VarChar(10)=''
)
AS
If @Num_Cot = ''
	Select  
		Cota.*, Usr.Nome_Usuario as Vendedor, Origem.Nome_Local as Origem, 
		Destino.Nome_Local as Destino, TP.Nome_Tp_Prod as Tipo_Produto,
		Pes.APelido as Cliente, Pes.Nome_Raz_Soc as Raz_Soc_Cliente
	From 
		Cotacao as Cota Join Pessoa as Pes on Pes.Cd_Pes = Cota.Cd_Pes
		Join Usuario as Usr on Usr.Cd_Usuario = Cota.Cd_Usuario
		Join Localidade as Origem on Origem.Cd_Local = Cota.Cd_Org_Cot
		Join Localidade as Destino on Destino.Cd_Local = Cota.Cd_Dst_Cot
		Join Tipo_Produto as TP on Tp.Cd_Tp_Prod = Cota.Cd_Tp_Prod
	Order by 
		Num_Cot Desc
Else
	Select  
		Cota.*, Usr.Nome_Usuario as Vendedor, Origem.Nome_Local as Origem, 
		Destino.Nome_Local as Destino, TP.Nome_Tp_Prod as Tipo_Produto,
		Pes.APelido as Cliente, Pes.Nome_Raz_Soc as Raz_Soc_Cliente 
	From 
		Cotacao as Cota Join Pessoa as Pes on Pes.Cd_Pes = Cota.Cd_Pes
		Join Usuario as Usr on Usr.Cd_Usuario = Cota.Cd_Usuario
		Join Localidade as Origem on Origem.Cd_Local = Cota.Cd_Org_Cot
		Join Localidade as Destino on Destino.Cd_Local = Cota.Cd_Dst_Cot
		Join Tipo_Produto as TP on Tp.Cd_Tp_Prod = Cota.Cd_Tp_Prod
	Where
		Num_Cot = @Num_Cot

GO
