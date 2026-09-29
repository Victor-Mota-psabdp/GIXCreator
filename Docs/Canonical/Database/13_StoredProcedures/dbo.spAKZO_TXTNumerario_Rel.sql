SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--alterado o caso qdo o dp.cd_org vem vazio, ele colocava '202' e conforme solicitação da Marcia/ariane - Ariane.Vieira@akzonobel.com o mesmo foi mudado pra 196

CREATE procedure [dbo].[spAKZO_TXTNumerario_Rel] --'EMSUR20090300101','00064'
(
@Num_Proc as varchar(16),
@POC as varchar(15)
)
as
	Declare @PO as varchar(20)

	Set @PO = (dbo.fBusca_TipoDocCliente ('N',@Num_Proc,1))

select 
	'2' cod_estabel,
	'12114' cod_forn,
	(ACD.valor * ACD.Paridade) valor_mov,
	(case when left(AC.Num_Proc,1)='I' then 1 else 2 end) tipo_an,
	left(@PO,9) referencia,
	(case when conta='B' then isnull(DP.cd_org,'196') else DP.cd_org end) despesa,
	(case when len(@PO) > 9 then right(@PO,1) else '1' end) remessa,
	PC.cd_proc_cliente it_codigo,
	'' desc_item,
	(dt_solicitacao + 2)  dt_prev_pag,
	P.cd_pes_CTT Centro_Custo,
	conta,
--	P.num_pedido,
	AC.Num_Proc,
	descr_org,
	nome_tp_tx,
	ACD.cd_tp_tx
from 
	Adiantamento_Cliente AC
	join Adiantamento_Cliente_Det ACD on ACD.id=AC.id and AC.POC=@POC 
	join Tipo_Taxa TT on TT.cd_tp_tx=ACD.cd_tp_tx
	left join de_para DP on DP.cd_dst=ACD.cd_tp_tx and DP.cd_cliente='10SUR' and DP.cd_tipo='4'
	join Pedido_Ship PS on PS.Num_Proc=AC.Num_Proc
	join Produto_Cliente PC on PC.cd_prod=PS.cd_produto and PC.cd_cliente='10SUR'
	join pedido P on P.cd_pedido=PS.cd_pedido
where 
	AC.num_proc like @Num_Proc
order by
	conta



GO
