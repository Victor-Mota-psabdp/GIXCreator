SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwJSON_Oxiteno_purchaseOrderJOB_Sel]
AS

select 		
	J.ID_purchaseOrderJOB [Internal Code],
	J.ref_processo,
	J.id_despachante,
	J.ref_oxiteno,
	J.num_master,
	J.num_house,
	J.num_di,
	J.modal,
	J.canal_di,
	J.origem,
	J.destino,
	J.moeda,
	J.valor_conhec,
	J.peso_bruto,
	J.peso_liquido,
	J.tx_cambial_di,
	J.paridade,
	J.armazem,
	J.vrt_ii,
	J.vrt_pis,
	J.vrt_cofins,
	J.vrt_icms,
	J.vrt_ipi,
	J.vrt_antidumping,
	J.vrt_siscomex,
	J.vrt_afrmm,
	J.total_prestacao,			
	J.Dt_Ins,
	J.Dt_Sent,
	J.Message,
			
	V.cd_cliente	[Client Code],
	P.Apelido		[Client name],
	P.Num_CPF_CNPJ  [Client CNPJ],
	G.Cd_Pes					[Group Code],
	G.Apelido					[Group Name]
from 
	ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB J with(nolock)		
	LEFT join ATLANTIS.dbo.vwClienteALLJOBS V with (nolock) on V.Num_Proc = J.ref_processo
	LEFT join ATLANTIS.dbo.Pessoa P with (nolock) on V.cd_cliente = P.Cd_Pes		
	LEFT JOIN ATLANTIS.dbo.pessoa_llp llp with (nolock) on llp.Cd_Pes = V.cd_cliente
	--LEFT join ATLANTIS.dbo.Pedido_Ship PS with (nolock) on V.Num_Proc = PS.Num_Proc 
	join ATLANTIS.dbo.Pessoa G with(nolock) on G.cd_pes = 'P21128'	

GO
