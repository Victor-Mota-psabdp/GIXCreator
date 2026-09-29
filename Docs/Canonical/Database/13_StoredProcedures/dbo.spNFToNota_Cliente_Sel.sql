SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spNFToNota_Cliente_Sel]
		
as

select distinct
	DB.Num_Proc,
	DB.id_danfe,
	DC.CNPJ,
	DB.nNF,
	DB.dEmis,
	DIP.CFOP,
	DT.vNF,
	P.Apelido Cliente,
	'N' Complementar
from ATL_BR.dbo.Exchange_Danfe_Base E
	Join ATL_BR.dbo.danfe_base DB on E.num_proc collate Latin1_General_CI_AI = Db.Num_Proc and E.id_danfe=  DB.Id_Danfe	
	Join ATL_BR.dbo.Danfe_Cia DC on DC.id_danfe=DB.id_danfe and Tipo='E'
	join dbo.vwClienteALLJOBS A on A.Num_Proc = DB.Num_Proc
	join dbo.Pessoa P on P.Cd_Pes = A.cd_cliente
	Join ATL_BR.dbo.Danfe_Item_Produto DIP on DIP.id_danfe=DB.id_danfe
	Join ATL_BR.dbo.Danfe_Totais DT on DT.id_danfe=DB.id_danfe
	left join dbo.Nota_Cliente NC on NC.Num_Proc = DB.Num_Proc AND DB.NNF = NC.Nota_Fiscal
where 
	NC.ID_NF is null
	and E.dt_send is null








GO
