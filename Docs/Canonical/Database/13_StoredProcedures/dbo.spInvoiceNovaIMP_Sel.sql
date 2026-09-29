SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
select * from invoice_cliente where num_proc='EMCSR20080502501'
select * from pedido_ship where num_proc='EMCSR20080407401'
select * from pedido where num_pedido='24053464'
select * from house_imp_mar
*/
CREATE              Procedure [dbo].[spInvoiceNovaIMP_Sel] --'IMFMC20090100201','46000315' , 'O'

	@Processo	varchar(16),
	@Num_Pedido 	varchar(30),
	@Cd_Modal	char(1)
AS

--Exp. Aer--------------------------------------------------------------------
select 
	PO.Numero_PO_HIA PO,
	DI.Numero_PO_HIA RE,
	P.incoterm,
	B.Apelido Buyer,
	P.Cd_tp_moeda,
	H.Vlr_Frete_Efet_HIA Vlr_Frete_Tot,
	PROD.Cd_Proc_Cliente,
	PROD.Produto_Descr,
	PS.Qty,
	TE.Nome_Tp_Embal,
	isnull(PD.Peso_Liquido_Tot,0)	Peso_Liquido,
	isnull(PD.Vlr_Item,0) Vlr_Item,
	P.Cd_Pedido,
	convert(int,PS.Item) Item,
	'' nf,
	'' dtNF
from 
	Pedido_Ship PS
	Join Pedido P on P.Cd_Pedido = PS.Cd_Pedido AND CD_MODAL=@Cd_Modal
	Join Pedido_Det PD on PD.cd_pedido=PS.cd_pedido and PD.cd_produto=PS.cd_produto and (PD.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PD.LOTE=PS.LOTE OR PS.LOTE IS NULL)
	Left Join PO_HIA PO on PO.Num_Proc_HIA = PS.Num_Proc AND PO.ID_DC=1
	Left Join PO_HIA DI on DI.Num_Proc_HIA =PS.Num_Proc and DI.ID_DC = '5'
	Join House_imp_Aer	H on H.Num_Proc_HIA = PS.Num_Proc
	Join Pessoa B  on B.cd_pes = H.cd_consig_HIA
	Join Produto_Cliente PROD on PROD.Cd_Prod = PS.Cd_Produto
	Join Job_imp_Aer JEA on JEA.Num_Proc_HIA = PS.Num_Proc
	Left Join Tipo_Embalagem TE on TE.Cd_Tp_Embal = JEA.Cd_Tp_Embal
Where
	PS.Num_Proc=@Processo and P.Num_Pedido=@Num_Pedido and P.cd_Modal=@Cd_Modal

--Exp. Mar--------------------------------------------------------------------

union

select 
	PO.Numero_PO_HIM PO,
	DI.Numero_PO_HIM RE,
	P.incoterm,
	B.Apelido Buyer,
	P.Cd_tp_moeda,
	H.Vlr_Frete_Efet_HIM Vlr_Frete_Tot,
	PROD.Cd_Proc_Cliente,
	PROD.Produto_Descr,
	PS.Qty,
	TE.Nome_Tp_Embal,
	isnull(PD.Peso_Liquido_Tot,0)	Peso_Liquido,
	isnull(PD.Vlr_Item,0) Vlr_Item,
	P.Cd_Pedido,
	convert(int,PS.Item) Item,
	'' nf,
	'' dtNF
from 
	Pedido_Ship PS
	Join Pedido P on P.Cd_Pedido = PS.Cd_Pedido 
	Join Pedido_Det PD on PD.cd_pedido=PS.cd_pedido and PD.cd_produto=PS.cd_produto and (PD.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PD.LOTE=PS.LOTE OR PS.LOTE IS NULL)
	Left Join PO_HIM PO on PO.Num_Proc_HIM = PS.Num_Proc AND PO.ID_DC=1
	Left Join PO_HIM DI on DI.Num_Proc_HIM 	=PS.Num_Proc and DI.ID_DC = '5'
	Join House_imp_Mar	H on H.Num_Proc_HIM = PS.Num_Proc
	Left Join Pessoa B  on B.cd_pes = H.cd_consig_HIM
	Left Join Produto_Cliente PROD on PROD.Cd_Prod = PS.Cd_Produto
	Left Join Job_imp_Mar JEM on JEM.Num_Proc_HIM = PS.Num_Proc
	Left Join Tipo_Embalagem TE on TE.Cd_Tp_Embal = H.Cd_Tp_Embal
Where
	PS.Num_Proc=@Processo and P.Num_Pedido=@Num_Pedido 

union


select 
	PO.Numero_PO_HIO PO,
	DI.Numero_PO_HIO RE,
	P.incoterm,
	B.Apelido Buyer,
	P.Cd_tp_moeda,
	H.Vlr_Frete_efet_HIO Vlr_Frete_Tot,
	PROD.Cd_Proc_Cliente,
	PROD.Produto_Descr,
	PS.Qty,
	NULL Nome_Tp_Embal,
	isnull(PD.Peso_Liquido_Tot,0)	Peso_Liquido,
	isnull(PD.Vlr_Item,0) Vlr_Item,
	P.Cd_Pedido,
	convert(int,PS.Item) Item,
	'' nf,
	'' dtNF
from
	Pedido_Ship PS
	Join Pedido P on P.Cd_Pedido = PS.Cd_Pedido AND CD_MODAL=@Cd_Modal
	Join Pedido_Det PD on PD.cd_pedido=PS.cd_pedido and PD.cd_produto=PS.cd_produto and (PD.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PD.LOTE=PS.LOTE OR PS.LOTE IS NULL)
	Left Join PO_HIO PO on PO.Num_Proc_HIO = PS.Num_Proc AND PO.ID_DC=1
	Left Join PO_HIO DI on DI.Num_Proc_HIO 	=PS.Num_Proc and DI.ID_DC = '5'
	Join House_imp_out	H on H.Num_Proc_HIO = PS.Num_Proc
	Join Pessoa B  on B.cd_pes = H.cd_consig_HIO
	Join Produto_Cliente PROD on PROD.Cd_Prod = PS.Cd_Produto
--	Join Job_imp_out jeo on jeo.Num_Proc_HIO = PS.Num_Proc
--	Left Join Tipo_Embalagem TE on TE.Cd_Tp_Embal = H.Cd_Tp_Embal
Where
	PS.Num_Proc=@Processo and P.Num_Pedido=@Num_Pedido 

order by
	Item





GO
