SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from tipo_campo_ordem
--select min(Dt_Ins_Upd)  from campo_ordem where id_campo=26
--select * from campo_ordem C 
--	join Pedido_ship Ps on Ps.cd_pedido = C.cd_pedido
--	where  C.id_campo=3
--	and dt_ins> '2021-03-25'
--select * from campo_ordem where cd_pedido=330702
--select distinct PS.Num_Proc,
--	(case when CO3.campo_dados is not null then
--		(case when CO26.campo_dados = 'Y' then CO26.campo_dados else 'N' end)			
--		else NULL end) [STO Indicator] 
--	from Pedido_Ship PS with(nolock)
--	Join  campo_ordem CO3 with(nolock) on PS.cd_pedido=CO3.cd_pedido and CO3.id_campo=3
--	left Join campo_ordem CO26 with(nolock) on PS.cd_pedido=CO26.cd_pedido and CO26.id_campo=26
--	where  CO3.id_campo=3
--	and CO3.Dt_Ins_Upd> '2021-03-25'
--	and CO26.campo_dados is null
--spCampo_Ordem_STOY_Sel 'EMCSR202102001BR'
--spCampo_Ordem_STOY_Sel 'EMCSR202102002BR'
--select * from Pedido_ship where Num_Proc = 'EMCSR202102001BR'
--select * from campo_ordem where cd_pedido=330702
--spCampo_Ordem_STOY_Sel 'EMCSR202103128BR'
CREATE Procedure [dbo].[spCampo_Ordem_STOY_Sel]
(
	@Num_Proc	varchar(16)
)
	
as

select distinct	
	(case when CO3.campo_dados is not null and CO3.Dt_Ins_Upd > '2021-03-25' then
		(case when CO26.campo_dados = 'Y' then CO26.campo_dados else 'N' end)			
		else '' end) [STO Indicator] 
	from Pedido_Ship PS with(nolock)
	Join  campo_ordem CO3 with(nolock) on PS.cd_pedido=CO3.cd_pedido and CO3.id_campo=3
	left Join campo_ordem CO26 with(nolock) on PS.cd_pedido=CO26.cd_pedido and CO26.id_campo=26
	Where 
		PS.num_proc=@Num_Proc
		--and CO3.Dt_Ins_Upd > '2021-03-25'  --data que começamos a receber em producao este stoind

--select distinct CO.campo_dados [STO Indicator] 
--	from Pedido_Ship PS with(nolock)
--	Join  campo_ordem CO with(nolock) on PS.cd_pedido=CO.cd_pedido and CO.id_campo=26
--	Where 
--		num_proc=@Num_Proc

	--select distinct	
	--	(case when CO.campo_dados is not null then right(CO.campo_dados,1) 
	--		else 'N' end) [STO Indicator] 
	--from Pedido_Ship PS with(nolock)
	--left Join  campo_ordem CO with(nolock) on PS.cd_pedido=CO.cd_pedido and CO.id_campo=26
	--Where 
	--	num_proc=@Num_Proc
		

--select * from campo_ordem where cd_pedido = '119493' and id_campo = 26
--select * from tipo_campo_ordem  where id_campo = 26
GO
