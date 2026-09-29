SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






--26/05
--Week 22
--Nova

--06-06-2008
--Week 23
--right 14 CNPJ  - Claudio

CREATE	Procedure [dbo].[spInvoiceXML_Sel] --'EOCSR20080502201'
@JOB	Varchar(16)
AS
select
	Ship.Nome_Raz_Soc	Seller_Razao,
	right(Ship.Num_CPF_CNPJ,14)	Seller_CNPJ,
	'sistemas@bdp.com.br' Email,
	Num_Invoice			InvoiceNR,
	Vencimento,
	Prazo,
	(sum(INVDET.peso_liquido) * INVDET.preco_unit) Vlr_Mercadoria,
	HOU.Vlr_Frete_tot_hem Vlr_Frete,
	Vlr_Seguro,
	PED.Incoterm,
	Left(RE.Numero_PO_hem,10)	RE,
	HOU.MAWB_HEM		ConhecNR,
	LLP.ATD_Lem			DtEmbarque,
	ORG.Pais_Local		Seller_Pais,
	Buyer.Nome_Raz_Soc	Buyer_Razao,
	DEST.Pais_Local		Buyer_Pais,
	Dt_Envio
from
	Invoice_Cliente InvCLI
	Join House_Exp_Mar	HOU 	on HOU.Num_proc_hem	=InvCLI.Num_Proc
	Join LLP_Exp_Mar	LLP		on LLP.Num_Proc_LEM	=InvCLI.Num_Proc
	Join Invoice_Det	InvDET	on InvDET.ID_Inv 	=InvCLI.ID_Inv
	Join Pedido			PED 	on PED.cd_pedido 	=InvDET.cd_pedido
	Left Join PO_hem	RE		on RE.Num_Proc_hem 	=InvCLI.Num_Proc and RE.ID_DC = '4'
	Join Localidade		ORG		on ORG.cd_local		=HOU.cd_org_hem
	Join Localidade		DEST	on DEST.cd_local	=HOU.cd_dst_hem
	Join Pessoa			SHIP	on SHIP.cd_pes		=HOU.cd_export_hem
	Left Join Pessoa	Buyer	on Buyer.cd_pes		=InvCLI.cd_Cliente
Where
	 InvCLI.Num_Proc = @JOB --'EMCSR20080506301'
Group by
	Ship.Nome_Raz_Soc,Ship.Num_CPF_CNPJ,Num_Invoice,Vencimento,INVDET.preco_unit,HOU.Vlr_Frete_tot_hem,
	Vlr_Seguro,PED.Incoterm,HOU.MAWB_HEM,LLP.ATD_Lem,ORG.Pais_Local,DEST.Pais_Local,RE.Numero_PO_hem,
	Buyer.Nome_Raz_Soc,Dt_Envio,Prazo

union

select
	Ship.Nome_Raz_Soc	Seller_Razao,
	right(Ship.Num_CPF_CNPJ,14)	Seller_CNPJ,
	'sistemas@bdp.com.br' Email,
	Num_Invoice			InvoiceNR,
	Vencimento,
	Prazo,
	(sum(INVDET.peso_liquido) * INVDET.preco_unit) Vlr_Mercadoria,
	HOU.Vlr_Frete_tot_HEA Vlr_Frete,
	Vlr_Seguro,
	PED.Incoterm,
	Left(RE.Numero_PO_HEA,10)	RE,
	HOU.MAWB_HEA		ConhecNR,
	LLP.ATD_LEA			DtEmbarque,
	ORG.Pais_Local		Seller_Pais,
	Buyer.Nome_Raz_Soc	Buyer_Razao,
	DEST.Pais_Local		Buyer_Pais,
	Dt_Envio
from
	Invoice_Cliente InvCLI
	Join House_Exp_Aer	HOU 	on HOU.Num_proc_HEA	=InvCLI.Num_Proc
	Join LLP_Exp_Aer	LLP		on LLP.Num_Proc_LEA	=InvCLI.Num_Proc
	Join Invoice_Det	InvDET	on InvDET.ID_Inv 	=InvCLI.ID_Inv
	Join Pedido			PED 	on PED.cd_pedido 	=InvDET.cd_pedido
	Left Join PO_HEA	RE		on RE.Num_Proc_HEA 	=InvCLI.Num_Proc and RE.ID_DC = '4'
	Join Localidade		ORG		on ORG.cd_local		=HOU.cd_org_HEA
	Join Localidade		DEST	on DEST.cd_local	=HOU.cd_dst_HEA
	Join Pessoa			SHIP	on SHIP.cd_pes		=HOU.cd_export_HEA
	Left Join Pessoa	Buyer	on Buyer.cd_pes		=InvCLI.cd_Cliente
Where
	 InvCLI.Num_Proc = @JOB
Group by
	Ship.Nome_Raz_Soc,Ship.Num_CPF_CNPJ,Num_Invoice,Vencimento,INVDET.preco_unit,HOU.Vlr_Frete_tot_HEA,
	Vlr_Seguro,PED.Incoterm,HOU.MAWB_HEA,LLP.ATD_LEA,ORG.Pais_Local,DEST.Pais_Local,RE.Numero_PO_HEA,
	Buyer.Nome_Raz_Soc,Dt_Envio,Prazo

union
select
	Ship.Nome_Raz_Soc	Seller_Razao,
	right(Ship.Num_CPF_CNPJ,14)	Seller_CNPJ,
	'sistemas@bdp.com.br' Email,
	Num_Invoice			InvoiceNR,
	Vencimento,
	Prazo,
	(sum(INVDET.peso_liquido) * INVDET.preco_unit) Vlr_Mercadoria,
	HOU.Vlr_Frete_Efet_HEO Vlr_Frete,
	Vlr_Seguro,
	PED.Incoterm,
	Left(RE.Numero_PO_HEO,10)	RE,
	HOU.HAWB_HEO		ConhecNR,
	LLP.ATD_LEO			DtEmbarque,
	ORG.Pais_Local		Seller_Pais,
	Buyer.Nome_Raz_Soc	Buyer_Razao,
	DEST.Pais_Local		Buyer_Pais,
	Dt_Envio
from
	Invoice_Cliente InvCLI
	Join House_Exp_Out	HOU 	on HOU.Num_proc_HEO	=InvCLI.Num_Proc
	Join LLP_Exp_Out	LLP		on LLP.Num_Proc_LEO	=InvCLI.Num_Proc
	Join Invoice_Det	InvDET	on InvDET.ID_Inv 	=InvCLI.ID_Inv
	Join Pedido			PED 	on PED.cd_pedido 	=InvDET.cd_pedido
	Left Join PO_HEO	RE		on RE.Num_Proc_HEO 	=InvCLI.Num_Proc and RE.ID_DC = '4'
	Join Localidade		ORG		on ORG.cd_local		=HOU.cd_org_HEO
	Join Localidade		DEST	on DEST.cd_local	=HOU.cd_dst_HEO
	Join Pessoa			SHIP	on SHIP.cd_pes		=HOU.cd_export_HEO
	Left Join Pessoa	Buyer	on Buyer.cd_pes		=InvCLI.cd_Cliente
Where
	 InvCLI.Num_Proc = @JOB
Group by
	Ship.Nome_Raz_Soc,Ship.Num_CPF_CNPJ,Num_Invoice,Vencimento,INVDET.preco_unit,HOU.Vlr_Frete_Efet_HEO,
	Vlr_Seguro,PED.Incoterm,HOU.HAWB_HEO,LLP.ATD_LEO,ORG.Pais_Local,DEST.Pais_Local,RE.Numero_PO_HEO,
	Buyer.Nome_Raz_Soc,Dt_Envio,Prazo



GO
