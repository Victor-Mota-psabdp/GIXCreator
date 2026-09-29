SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--select * from pessoa where cd_pes in ('60561719','P16507','P18803')

CREATE procedure [dbo].[spAKZO_TXTCustoProcesso_Rel] --'IMSUR201108009BR'
(
@Num_Proc as varchar(16)
)
as
	Declare @PO as varchar(20)

	Set @PO = (dbo.fBusca_TipoDocCliente ('N',@Num_Proc,1))

select 
	(case 
		when P.Cd_Buyer='60561719' then '2' -- AKZO ITUPEVA SURFACE
		when P.Cd_Buyer='P16507' then '2' -- AKZO NOBEL BAHIA
		when P.Cd_Buyer='P18803' then '2' -- AKZO VARZEA
	end
	) cod_estabel,
	'12114' cod_forn,
	convert(decimal(12,2),CP.valor) valor_mov,
	(case when left(CP.Num_Proc,1)='I' then 1 else 2 end) tipo_an,
	left(@PO,9) referencia,
	isnull(DP.cd_org,'202') despesa,
	(case when len(@PO) > 9 then right(@PO,1) else '1' end) remessa,
	PC.cd_proc_cliente it_codigo,
	'' desc_item,
	(getdate() + 1)  dt_prev_pag,
	P.cd_pes_CTT Centro_Custo,
--	conta,
--	P.num_pedido,
	CP.Num_Proc,
	descr_org,
	nome_tp_tx,
	CP.cd_tp_tx,
	replace(convert(varchar(10),getdate() + 1, 103),'/','')  Prev_Pgto
from 
	Custo_Processo CP
	join Tipo_Taxa TT on TT.cd_tp_tx=CP.cd_tp_tx
	left join de_para DP on DP.cd_dst=CP.cd_tp_tx and DP.cd_cliente='10SUR' and DP.cd_tipo='4'
	join Pedido_Ship PS on PS.Num_Proc=CP.Num_Proc
	join Produto_Cliente PC on PC.cd_prod=PS.cd_produto and PC.cd_cliente='10SUR'
	join pedido P on P.cd_pedido=PS.cd_pedido
where 
	CP.num_proc like @Num_Proc
order by
	CP.Num_Proc

GO
