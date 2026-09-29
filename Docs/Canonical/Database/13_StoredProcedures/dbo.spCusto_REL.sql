SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure spCusto_REL

as


select num_proc,produto_descr,cd_proc_cliente,Nome_tp_tx, vlr_item_custo from custo_cliente cc
Join Tipo_taxa TT on TT.cd_tp_tx=cc.cd_tp_tx
join produto_cliente PC on pC.cd_prod=cd_produto





GO
