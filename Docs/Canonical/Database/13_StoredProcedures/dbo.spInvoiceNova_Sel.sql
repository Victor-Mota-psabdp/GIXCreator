SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
select * from invoice_cliente where num_proc='EMCSR20080502501'
select * from pedido_ship where num_proc='EASTB201302001BR'
select * from pedido where num_pedido='63027371'
select * from Pedido_det where cd_pedido = '104699'
select * from house_exp_aer where num_proc_hea='EASTB201302001BR'
select * from produto_cliente where cd_proc_cliente = '67236'
*/
CREATE              Procedure [dbo].[spInvoiceNova_Sel]-- 'EASTB201302001BR','63027371' , 'A'

	@Processo	varchar(16),
	@Num_Pedido 	varchar(30),
	@Cd_Modal	char(1)
AS

--Exp. Aer--------------------------------------------------------------------
select 
	PO.Numero_PO_HEA PO,
	RE.Numero_PO_hea RE,
	P.incoterm,
	B.Apelido Buyer,
	P.Cd_tp_moeda,
	H.Vlr_Frete_Tot_HEA Vlr_Frete_Tot,
	PROD.Produto_Descr,
	PROD.Cd_Proc_Cliente,
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
	Join Pedido P on P.Cd_Pedido = PS.Cd_Pedido and [status] <> 'E'
	Join Pedido_Det PD on PD.cd_pedido=PS.cd_pedido and PD.cd_produto=PS.cd_produto and (PD.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PD.LOTE=PS.LOTE OR PS.LOTE IS NULL)
	Left Join PO_HEA PO on PO.Num_Proc_HEA = PS.Num_Proc AND PO.ID_DC=1
	Left Join PO_HEA RE on RE.Num_Proc_HEA =PS.Num_Proc and RE.ID_DC = '4'
	 Join House_Exp_Aer	H on H.Num_Proc_HEA = PS.Num_Proc
	Join Pessoa B  on B.cd_pes = H.cd_consig_hea
	Join Produto_Cliente PROD on PROD.Cd_Prod = PS.Cd_Produto
	Join Job_Exp_Aer JEA on JEA.Num_Proc_HEA = PS.Num_Proc
	Left Join Tipo_Embalagem TE on TE.Cd_Tp_Embal = JEA.Cd_Tp_Embal
Where
	PS.Num_Proc=@Processo and P.Num_Pedido=@Num_Pedido and P.cd_Modal=@Cd_Modal

--Exp. Mar--------------------------------------------------------------------

union

select 
	PO.Numero_PO_HEM PO,
	RE.Numero_PO_hem RE,
	P.incoterm,
	B.Apelido Buyer,
	P.Cd_tp_moeda,
	H.Vlr_Frete_Tot_HEM Vlr_Frete_Tot,
	PROD.Produto_Descr,
	PROD.Cd_Proc_Cliente,
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
	Join Pedido P on P.Cd_Pedido = PS.Cd_Pedido --and [status] <> 'E'
	Join Pedido_Det PD on PD.cd_pedido=PS.cd_pedido and PD.cd_produto=PS.cd_produto and (PD.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PD.LOTE=PS.LOTE OR PS.LOTE IS NULL)
	Left Join PO_HEM PO on PO.Num_Proc_HEM = PS.Num_Proc AND PO.ID_DC=1
	Left Join PO_HEM RE on RE.Num_Proc_HEM 	=PS.Num_Proc and RE.ID_DC = '4'
	Join House_Exp_Mar	H on H.Num_Proc_HEM = PS.Num_Proc
	Left Join Pessoa B  on B.cd_pes = H.cd_consig_hem
	Left Join Produto_Cliente PROD on PROD.Cd_Prod = PS.Cd_Produto
--	Left Join Job_Exp_Mar JEM on JEM.Num_Proc_HEM = PS.Num_Proc
	Left Join Tipo_Embalagem TE on TE.Cd_Tp_Embal = H.Cd_Tp_Embal
Where
	PS.Num_Proc=@Processo and P.Num_Pedido=@Num_Pedido 

union


select 
	PO.Numero_PO_heo PO,
	RE.Numero_PO_heo RE,
	P.incoterm,
	B.Apelido Buyer,
	P.Cd_tp_moeda,
	H.Vlr_Frete_efet_heo Vlr_Frete_Tot,
	PROD.Produto_Descr,
	PROD.Cd_Proc_Cliente,
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
	Join Pedido P on P.Cd_Pedido = PS.Cd_Pedido and [status] <> 'E'
	Join Pedido_Det PD on PD.cd_pedido=PS.cd_pedido and PD.cd_produto=PS.cd_produto and (PD.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PD.LOTE=PS.LOTE OR PS.LOTE IS NULL)
	Left Join PO_heo PO on PO.Num_Proc_heo = PS.Num_Proc AND PO.ID_DC=1
	Left Join PO_HEO RE on RE.Num_Proc_HEO 	=PS.Num_Proc and RE.ID_DC = '4'
	Join House_Exp_out	H on H.Num_Proc_heo = PS.Num_Proc
	Join Pessoa B  on B.cd_pes = H.cd_consig_heo
	Join Produto_Cliente PROD on PROD.Cd_Prod = PS.Cd_Produto
--	Join Job_Exp_out jeo on jeo.Num_Proc_heo = PS.Num_Proc
--	Left Join Tipo_Embalagem TE on TE.Cd_Tp_Embal = H.Cd_Tp_Embal
Where
	PS.Num_Proc=@Processo and P.Num_Pedido=@Num_Pedido 

order by
	Item





GO
