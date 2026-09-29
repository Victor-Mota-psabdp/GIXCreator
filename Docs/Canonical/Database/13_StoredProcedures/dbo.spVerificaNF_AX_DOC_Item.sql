SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spVerificaNF_AX_DOC_Item] '51505','EMATL201310006BR','Forwarding Fee','C'
--select * from ax_doc_item where Num_Proc = 'EMATL201310006BR'
CREATE Procedure [dbo].[spVerificaNF_AX_DOC_Item]

	@strNF as varchar(20),
	@strJob as varchar(16),
	@strTaxa  as varchar(100),
	@strDC as varchar(1)
	
as

select  
	CC.DocumentNum Nota_fiscal
from 
	ax_doc_item CC	
	Join Tipo_Taxa TT on TT.cd_tp_tx = cc.cd_tp_Tx_Atl
	join AX_DOC AX on CC.id_ax = AX.id_ax	
where
	CC.Num_Proc = @strJob and
	TT.nome_tp_tx = @strtaxa and
	CC.DC = @strDC and
	CC.DocumentNum = @strNF and
	Dt_Canc is NULL
GO
