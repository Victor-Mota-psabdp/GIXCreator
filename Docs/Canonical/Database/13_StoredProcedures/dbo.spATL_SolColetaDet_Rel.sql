SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spATL_SolColetaDet_Rel] 'IMUPL201609065BR'
CREATE procedure [dbo].[spATL_SolColetaDet_Rel] 
(
@Num_Proc varchar(16)
)
as
		/*
		select
			dbo.fBusca_Docs_PO_Modal_COALESCE(PC.Num_Proc,'9') PROCESSO,
			PC.Num_Cont [Nº VOLUME],
			TC.Cd_CC_Ofc [TIPO DO CONTAINER (Ft)],
			PCLI.Produto_Descr [PRODUTO],
			PS.Qty [QUANTIDADE (Kg/L)]
		from Pedido_Ship_Container PC with(nolock)
			join vwContainer_IMP CH with(nolock) on PC.Num_Proc = CH.Num_Proc
			join vwCliente CLI with(nolock) on PC.Num_Proc = CLI.num_proc
			join Pessoa_LLP PL with(nolock) on CLI.cd_cliente = PL.Cd_Pes
			join Produto_Cliente PCLI with(nolock) on PC.cd_produto = PCLI.cd_prod and PL.Cd_Pes_Grupo = PCLI.cd_Cliente
			left join Pedido_Ship PS with(nolock) on PC.cd_pedido = PS.cd_pedido and PC.cd_produto = PS.cd_produto and PC.Item = PS.Item
			left join Tipo_Container TC with(nolock) on CH.Cd_Tp_Cont = TC.Cd_Tp_Cont
		where 
			PC.Num_Proc = @Num_Proc

*/
	select
			dbo.fBusca_Docs_PO_Modal_COALESCE(CH.Num_Proc,'9') PROCESSO,
			CH.Num_Cont [Nº VOLUME],
			TC.Cd_CC_Ofc [TIPO DO CONTAINER (Ft)],
			dbo.fBusca_Container_Produto_COALESCE(CH.Num_Proc,CH.Num_Cont) [PRODUTO],
			CH.Peso_Bruto [QUANTIDADE (Kg/L)]
		from vwContainer_IMP CH with(nolock)
			left join Tipo_Container TC with(nolock) on CH.Cd_Tp_Cont = TC.Cd_Tp_Cont
		where 
			CH.Num_Proc = @Num_Proc
			
GO
