SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure spVerificaLA_Sel
		@Num_Lcto Varchar(12)
AS

/*
Rotina responsavel por verificar se o LA esta com todas as condição para Geração de Lançamento inverso e para envio para o MITs (Interface com a Contabilidade)
Condições: LA tem que ter um LA e o saldo deverá ser Zero
Anderson Oliveira - 10/11/2011
*/
select 
	dbo.valor(vlr_doc,dc),sum(dbo.valor(vlr_pgto_rcto_hia,dc_hia)) 
from 
	pgto_Rcto PG
	Join vwcxas CXA on cxa.num_lcto=PG.num_lcto
Where
	PG.num_lcto=@Num_Lcto
	and exists(select * from po_la where num_La=@Num_lcto)
Group by 
	vlr_doc,dc
Having 
	dbo.valor(vlr_doc,dc)=sum(dbo.valor(vlr_pgto_rcto_hia,dc_hia))
GO
