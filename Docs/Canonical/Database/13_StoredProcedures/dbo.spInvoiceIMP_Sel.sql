SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--27/05
--Week 22

--19-06-2008
--Week 25
--Mudança na passagem de parametro - Claudio


--spInvoiceIMP_Sel 'IMFMC20090100201','46000315' 

CREATE     Procedure [dbo].[spInvoiceIMP_Sel] 

	@Processo	varchar(16),
	@Num_Invoice varchar(30)

AS
-- EXP.AER-----------------------------------------------------------
select 
	INV_CLI.ID_Inv,
	INV_CLI.Status,
	INV_CLI.Num_Invoice,
	INV_CLI.Data_Invoice,
	PO.Numero_PO_HIA PO,
	PED.incoterm,
	B.Apelido Buyer,
	PED.Cd_Tp_Moeda,
	INV_CLI.Obs_PL,
	H.Vlr_Frete_Efet_HIA Vlr_Frete_Tot,
	INV_CLI.Vlr_Seguro,
	INV_CLI.Re_Marks,
	Inv_CLI.Customer_Bank,
	DI.Numero_PO_HIA RE,
	INV_CLI.Linguagem,
	INV_CLI.Vencimento,
	INV_CLI.Prazo,
	right('000' + convert(varchar(4),TP.Cd_Termo),4) + ' - ' + Descricao_Termo Termo,
	INV_DET.ID_Inv,
	PROD.Cd_Proc_Cliente,
	PROD.Produto_Descr,
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
	Left Join PO_HIA PO 		on PO.Num_Proc_HIA 	=INV_CLI.Num_Proc and ID_DC=1
	Left Join PO_HIA DI			on DI.Num_Proc_HIA 	=INV_CLI.Num_Proc and DI.ID_DC = '5'
	Left Join Pedido PED 		on PED.Cd_Pedido 	=INV_DET.Cd_Pedido 
	Left Join Pessoa B  		on B.cd_pes 		=INV_CLI.cd_cliente
	Join House_IMP_Aer	H 		on H.Num_Proc_HIA 	=INV_CLI.Num_Proc
	Left Join Produto_Cliente PROD	on PROD.Cd_Prod 	=INV_DET.Cd_Produto --and  PROD.cd_cliente=cd_IMPort_HIA
	Left Join Job_IMP_Aer JEA 	on JEA.Num_Proc_HIA =INV_CLI.Num_Proc
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
	PO.Numero_PO_HIM PO,
	PED.incoterm,
	B.Apelido Buyer,
	PED.Cd_tp_moeda,
	INV_CLI.Obs_PL,
	H.Vlr_Frete_Efet_HIM Vlr_Frete_Tot,
	INV_CLI.Vlr_Seguro,
	INV_CLI.Re_Marks,
	Inv_CLI.Customer_Bank,
	DI.Numero_PO_HIM RE,
	INV_CLI.Linguagem,
	INV_CLI.Vencimento,
	INV_CLI.Prazo,
	right('000' + convert(varchar(4),TP.Cd_Termo),4) + ' - ' + Descricao_Termo Termo,
	INV_DET.ID_Inv,
	PROD.Cd_Proc_Cliente,
	PROD.Produto_Descr,
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
	Left Join PO_HIM PO 		on PO.Num_Proc_HIM 	=INV_CLI.Num_Proc and ID_DC=1
	Left Join PO_HIM DI			on DI.Num_Proc_HIM 	=INV_CLI.Num_Proc and DI.ID_DC = '5'
	Left Join Pedido PED 		on PED.Cd_Pedido 	=INV_DET.Cd_Pedido
	Left Join Pessoa B  		on B.cd_pes 		=INV_CLI.cd_cliente
	Join House_IMP_Mar	H 		on H.Num_Proc_HIM 	=INV_CLI.Num_Proc
	Left Join Produto_Cliente PROD	on PROD.Cd_Prod 	=INV_DET.Cd_Produto --and  PROD.cd_cliente=cd_IMPort_HIM
	Left Join Job_IMP_Mar JEM 	on JEM.Num_Proc_HIM =INV_CLI.Num_Proc
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
	PO.Numero_PO_HIO PO,
	PED.incoterm,
	B.Apelido Buyer,
	PED.Cd_tp_moeda,
	INV_CLI.Obs_PL,
	H.Vlr_Frete_efet_HIO Vlr_Frete_Tot,
	INV_CLI.Vlr_Seguro,
	INV_CLI.Re_Marks,
	Inv_CLI.Customer_Bank,
	DI.Numero_PO_HIO RE,
	INV_CLI.Linguagem,
	INV_CLI.Vencimento,
	INV_CLI.Prazo,
	right('000' + convert(varchar(4),TP.Cd_Termo),4) + ' - ' + Descricao_Termo Termo,
	INV_DET.ID_Inv,
	PROD.Cd_Proc_Cliente,
	PROD.Produto_Descr,
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
	Left Join PO_HIO PO 		on PO.Num_Proc_HIO 	=INV_CLI.Num_Proc and ID_DC=1
	Left Join PO_HIO DI			on DI.Num_Proc_HIO 	=INV_CLI.Num_Proc and DI.ID_DC = '5'
	Left Join Pedido PED 		on PED.Cd_Pedido 	=INV_DET.Cd_Pedido
	Left Join Pessoa B  		on B.cd_pes 		=INV_CLI.cd_cliente
	Join House_IMP_out	H 		on H.Num_Proc_HIO 	=INV_CLI.Num_Proc
	Left Join Produto_Cliente PROD	on PROD.Cd_Prod =INV_DET.Cd_Produto --and  PROD.cd_cliente=cd_IMPort_HIO
--	Join Job_IMP_out JEM 		on JEM.Num_Proc_HIO =INV_CLI.Num_Proc
	Left Join Tipo_Embalagem TE	on TE.Cd_Tp_Embal	=INV_DET.Cd_Embalagem
	Left Join Pedido_Ship PS	on PS.cd_pedido		=INV_DET.cd_pedido and PS.cd_produto=INV_DET.cd_produto and PS.Num_Proc=INV_CLI.Num_Proc  and PS.Item=INV_DET.Item
	Left Join Termo_Pagamento TP on TP.Cd_Termo		=INV_CLI.Cd_Termo
	Left Join Pais		PA		 on PA.cd_Pais		=Inv_CLI.cd_pais
Where
	 INV_CLI.Num_Proc=@Processo and INV_CLI.Num_Invoice=@Num_Invoice --and PED.cd_Modal=@Cd_Modal
Order By
	INV_DET.Item










GO
