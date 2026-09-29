SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--27/05
--Week 22

--19-06-2008
--Week 25
--Mudança na passagem de parametro - Claudio


--spInvoice_Sel 'EOCSR20080602601','47191058/0001' 

CREATE     Procedure [dbo].[spInvoice_Sel] 

	@Processo	varchar(16),
	@Num_Invoice varchar(30)

AS
-- EXP.AER-----------------------------------------------------------
select 
	INV_CLI.ID_Inv,
	INV_CLI.Status,
	INV_CLI.Num_Invoice,
	INV_CLI.Data_Invoice,
	PO.Numero_PO_HEA PO,
	PED.incoterm,
	B.Apelido Buyer,
	PED.Cd_Tp_Moeda,
	INV_CLI.Obs_PL,
	H.Vlr_Frete_Tot_HEA Vlr_Frete_Tot,
	INV_CLI.Vlr_Seguro,
	INV_CLI.Re_Marks,
	Inv_CLI.Customer_Bank,
	dbo.fbusca_docs_po_modal(INV_CLI.Num_Proc,4) RE,
	INV_CLI.Linguagem,
	INV_CLI.Vencimento,
	INV_CLI.Prazo,
	right('000' + convert(varchar(4),TP.Cd_Termo),4) + ' - ' + Descricao_Termo Termo,
--	INV_DET.ID_Inv,
	PROD.Produto_Descr,
	PROD.Cd_Proc_Cliente,
	INV_DET.Quantidade,
	TE.Nome_Tp_Embal,
	INV_DET.Capacidade, 
	isnull(INV_DET.Peso_Bruto,0) Peso_Bruto,
	isnull(INV_DET.Peso_Liquido,0) Peso_Liquido,
	INV_DET.Tipo_Unid,
	isnull(INV_DET.Preco_Unit,0) Preco_Unit,
	INV_DET.Incluso,
	INV_DET.Cd_Pedido,
	INV_DET.Item,
	INV_DET.Descr_Adicional,
	INV_CLI.Obs_INV,
	PA.nome_pais,
	INV_DET.NF NF,
	INV_DET.DTNF dtNF
from 
	Invoice_Cliente INV_CLI
	Left Join Invoice_Det INV_DET	on INV_DET.ID_Inv=INV_CLI.ID_Inv
	Left Join PO_HEA PO 		on PO.Num_Proc_HEA 	=INV_CLI.Num_Proc and ID_DC=1
	--Left Join PO_HEA RE			on RE.Num_Proc_HEA 	=INV_CLI.Num_Proc and RE.ID_DC = '4'
	Left Join Pedido PED 		on PED.Cd_Pedido 	=INV_DET.Cd_Pedido 
	Left Join Pessoa B  		on B.cd_pes 		=INV_CLI.cd_cliente
	Join House_Exp_Aer	H 		on H.Num_Proc_HEA 	=INV_CLI.Num_Proc
	Left Join Produto_Cliente PROD	on PROD.Cd_Prod 	=INV_DET.Cd_Produto --and  PROD.cd_cliente=cd_Export_hea
	Left Join Job_Exp_Aer JEA 	on JEA.Num_Proc_HEA =INV_CLI.Num_Proc
	Left Join Tipo_Embalagem TE on TE.Cd_Tp_Embal 	=INV_DET.Cd_Embalagem
	Left Join Pedido_Ship PS	on PS.cd_pedido		=INV_DET.cd_pedido and PS.cd_produto=INV_DET.cd_produto and PS.Num_Proc=INV_CLI.Num_Proc and PS.Item=INV_DET.Item
	Left Join Termo_Pagamento TP on TP.Cd_Termo		=INV_CLI.Cd_Termo
	Left Join Pais		PA		 on PA.cd_Pais		=Inv_CLI.cd_pais
Where
	 INV_CLI.Num_Proc=@Processo and INV_CLI.Num_Invoice=@Num_Invoice --and PED.cd_Modal=@Cd_Modal

-- EXP.MAR-----------------------------------------------------------

UNION

select 
	INV_CLI.ID_Inv,
	INV_CLI.Status,
	INV_CLI.Num_Invoice,
	INV_CLI.Data_Invoice,
	PO.Numero_PO_HEM PO,
	PED.incoterm,
	B.Apelido Buyer,
	PED.Cd_tp_moeda,
	INV_CLI.Obs_PL,
	H.Vlr_Frete_Tot_HEM Vlr_Frete_Tot,
	INV_CLI.Vlr_Seguro,
	INV_CLI.Re_Marks,
	Inv_CLI.Customer_Bank,
	dbo.fbusca_docs_po_modal(INV_CLI.Num_Proc,4) RE,
	INV_CLI.Linguagem,
	INV_CLI.Vencimento,
	INV_CLI.Prazo,
	right('000' + convert(varchar(4),TP.Cd_Termo),4) + ' - ' + Descricao_Termo Termo,
--	INV_DET.ID_Inv,
	PROD.Produto_Descr,
	PROD.Cd_Proc_Cliente,
	INV_DET.Quantidade,
	TE.Nome_Tp_Embal,
	INV_DET.Capacidade,
	isnull(INV_DET.Peso_Bruto,0) Peso_Bruto,
	isnull(INV_DET.Peso_Liquido,0) Peso_Liquido,
	INV_DET.Tipo_Unid,
	isnull(INV_DET.Preco_Unit,0) Preco_Unit,
	INV_DET.Incluso,
	INV_DET.Cd_Pedido,
	INV_DET.Item,
	INV_DET.Descr_Adicional,
	INV_CLI.Obs_INV,
	PA.nome_pais,
	INV_DET.NF NF,
	INV_DET.DTNF dtNF
from 
	Invoice_Cliente INV_CLI
	Left Join Invoice_Det INV_DET on INV_DET.ID_Inv	=INV_CLI.ID_Inv
	Left Join PO_HEM PO 		on PO.Num_Proc_HEM 	=INV_CLI.Num_Proc and ID_DC=1
	--Left Join PO_HEM RE			on RE.Num_Proc_HEM 	=INV_CLI.Num_Proc and RE.ID_DC = '4'
	Left Join Pedido PED 		on PED.Cd_Pedido 	=INV_DET.Cd_Pedido
	Left Join Pessoa B  		on B.cd_pes 		=INV_CLI.cd_cliente
	Join House_Exp_Mar	H 		on H.Num_Proc_HEM 	=INV_CLI.Num_Proc
	Left Join Produto_Cliente PROD	on PROD.Cd_Prod 	=INV_DET.Cd_Produto --and  PROD.cd_cliente=cd_Export_hem
	Left Join Job_Exp_Mar JEM 	on JEM.Num_Proc_HEM =INV_CLI.Num_Proc
	Left Join Tipo_Embalagem TE on TE.Cd_Tp_Embal	=INV_DET.Cd_Embalagem
	Left Join Pedido_Ship PS	on PS.cd_pedido		=INV_DET.cd_pedido and PS.cd_produto=INV_DET.cd_produto and PS.Num_Proc=INV_CLI.Num_Proc  and PS.Item=INV_DET.Item
	Left Join Termo_Pagamento TP on TP.Cd_Termo		=INV_CLI.Cd_Termo
	Left Join Pais		PA		 on PA.cd_Pais		=Inv_CLI.cd_pais
Where
	 INV_CLI.Num_Proc=@Processo and INV_CLI.Num_Invoice=@Num_Invoice --and PED.cd_Modal=@Cd_Modal

union

select 
	INV_CLI.ID_Inv,
	INV_CLI.Status,
	INV_CLI.Num_Invoice,
	INV_CLI.Data_Invoice,
	PO.Numero_PO_heo PO,
	PED.incoterm,
	B.Apelido Buyer,
	PED.Cd_tp_moeda,
	INV_CLI.Obs_PL,
	H.Vlr_Frete_efet_heo Vlr_Frete_Tot,
	INV_CLI.Vlr_Seguro,
	INV_CLI.Re_Marks,
	Inv_CLI.Customer_Bank,
	dbo.fbusca_docs_po_modal(INV_CLI.Num_Proc,4) RE,
	INV_CLI.Linguagem,
	INV_CLI.Vencimento,
	INV_CLI.Prazo,
	right('000' + convert(varchar(4),TP.Cd_Termo),4) + ' - ' + Descricao_Termo Termo,
--	INV_DET.ID_Inv,
	PROD.Produto_Descr,
	PROD.Cd_Proc_Cliente,
	INV_DET.Quantidade,
	TE.Nome_Tp_Embal,
	INV_DET.Capacidade,
	isnull(INV_DET.Peso_Bruto,0) Peso_Bruto,
	isnull(INV_DET.Peso_Liquido,0) Peso_Liquido,
	INV_DET.Tipo_Unid,
	isnull(INV_DET.Preco_Unit,0) Preco_Unit,
	INV_DET.Incluso,
	INV_DET.Cd_Pedido,
	INV_DET.Item,
	INV_DET.Descr_Adicional,
	INV_CLI.Obs_INV,
	PA.nome_pais,
	INV_DET.NF NF,
	INV_DET.DTNF dtNF
from 
	Invoice_Cliente INV_CLI
	Left Join Invoice_Det INV_DET on INV_DET.ID_Inv	=INV_CLI.ID_Inv
	Left Join PO_heo PO 		on PO.Num_Proc_heo 	=INV_CLI.Num_Proc and ID_DC=1
	--Left Join PO_HEO RE			on RE.Num_Proc_HEO 	=INV_CLI.Num_Proc and RE.ID_DC = '4'
	Left Join Pedido PED 		on PED.Cd_Pedido 	=INV_DET.Cd_Pedido
	Left Join Pessoa B  		on B.cd_pes 		=INV_CLI.cd_cliente
	Join House_Exp_out	H 		on H.Num_Proc_heo 	=INV_CLI.Num_Proc
	Left Join Produto_Cliente PROD	on PROD.Cd_Prod =INV_DET.Cd_Produto --and  PROD.cd_cliente=cd_Export_heo
--	Join Job_Exp_out JEM 		on JEM.Num_Proc_heo =INV_CLI.Num_Proc
	Left Join Tipo_Embalagem TE	on TE.Cd_Tp_Embal	=INV_DET.Cd_Embalagem
	Left Join Pedido_Ship PS	on PS.cd_pedido		=INV_DET.cd_pedido and PS.cd_produto=INV_DET.cd_produto and PS.Num_Proc=INV_CLI.Num_Proc  and PS.Item=INV_DET.Item
	Left Join Termo_Pagamento TP on TP.Cd_Termo		=INV_CLI.Cd_Termo
	Left Join Pais		PA		 on PA.cd_Pais		=Inv_CLI.cd_pais
Where
	 INV_CLI.Num_Proc=@Processo and INV_CLI.Num_Invoice=@Num_Invoice --and PED.cd_Modal=@Cd_Modal
Order By
	INV_DET.Item










GO
