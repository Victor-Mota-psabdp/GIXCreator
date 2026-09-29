SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from pessoa where cd_pes = 'P000006830'
--select * from endereco where cd_pes = 'P000006830'
--select * from fatura_consolidada
CREATE procedure [dbo].[spFatura_Consolidada_Rel]--1
(
@ID		int
)

AS

select IT.num_proc [Referencia BDP],
	isnull(EM.numero_po_hem,isnull(EO.numero_po_heo,isnull(EA.numero_po_hea,isnull(IM.numero_po_him,isnull(IO.numero_po_hio,IA.numero_po_hia))))) [Referencia Cliente],
	FCD.vlr_org,
	P.Nome_raz_soc Cliente,
	P.num_cpf_cnpj CNPJ,
	(isnull(E.Rua,'') + ',' + isnull(E.Numero,'') + ' - ' + isnull(E.Cidade,'') + ' - ' + isnull(E.UF,'')) Endereco	,
	dt_vencimento vencimento,
	data
	from fatura_consolidada FC
	join Fatura_Consolidada_Det FCD on FCD.ID = FC.ID
	join item_fat IT on FCD.fatcod = It.fatcod	
	left join po_hem EM on EM.num_proc_hem = IT.num_proc and EM.id_dc = 3
	left join po_heo EO on EO.num_proc_heo = IT.num_proc and EO.id_dc = 3
	left join po_hea EA on EA.num_proc_hea = IT.num_proc and EA.id_dc = 3
	left join po_him IM on IM.num_proc_him = IT.num_proc and IM.id_dc = 1
	left join po_hio IO on IO.num_proc_hio = IT.num_proc and IO.id_dc = 1
	left join po_hia IA on IA.num_proc_hia = IT.num_proc and IA.id_dc = 1
	join pessoa P on P.cd_pes = FC.cd_cliente
	join endereco E on E.cd_pes = P.cd_pes	
 where	
	FCD.ID = @ID and ativo = 1
	and cd_tp_tx in ('XCA','XCQ' ,'XEQ','XEU')
	and dc='C'

GO
