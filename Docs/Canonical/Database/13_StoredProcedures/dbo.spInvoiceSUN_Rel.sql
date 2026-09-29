SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spInvoiceSUN_Rel]-- '6517'
@ID_Inv	int
AS

select
--	CD_PRODUTO,
	InvCLI.Num_Proc,
	InvCLI.ID_Inv,
	Num_Invoice,
	isnull(INV.Data_PO_Heo,InvCLI.Data_Invoice) Data_Invoice,
	isnull(CUPO.Numero_PO_Heo,PED.Customer_PO) Customer_PO,
	PO.Numero_PO_Heo Num_PO,
	RE.Numero_PO_heo NumRE,
	SAL.Numero_PO_HEO SAL,
	PED.Num_Pedido, -- Sales Order
--	Buyer
		Buyer.Nome_Raz_Soc	Buyer_Razao,
		EndBuyer.Rua		Buyer_Rua,
		EndBuyer.Numero		Buyer_Num,
		EndBuyer.Compl_End	Buyer_Compl,
		EndBuyer.CEP		Buyer_CEP,
		EndBuyer.Bairro		Buyer_Bairro,
		EndBuyer.Cidade		Buyer_Cidade,
		EndBuyer.UF			Buyer_UF,
		EndBuyer.Pais		Buyer_Pais,
		ContBuy.Contato		BuyerContato,
		(ContBuy.cd_int +ContBuy.Cd_Area_Fone+ContBuy.Prefixo+ContBuy.Num_fone) Buyer_fone,
--	Shipper
		Ship.Nome_Raz_Soc	Ship_Razao, -- Cd_Cliente,
		Ship.Num_CPF_CNPJ	Ship_CNPJ,
		Ship.Num_RG_IE		Ship_IE,
		EndShip.Rua			Ship_Rua,
		EndShip.Numero		Ship_Num,
		EndShip.Compl_End	Ship_Compl,
		EndShip.CEP			Ship_CEP,
		EndShip.Bairro		Ship_Bairro,
		EndShip.Cidade		Ship_Cidade,
		EndShip.UF			Ship_UF,
		EndShip.Pais		Ship_Pais,
--	Consignee
		Cons.Apelido		Consignee,
		Cons.Nome_Raz_Soc	Cons_Razao,
		Cons.Num_CPF_CNPJ	Cons_CNPJ,
		EndCons.Rua			Cons_Rua,
		EndCons.Numero		Cons_Num,
		EndCons.Compl_End	Cons_Compl,
		EndCons.CEP			Cons_CEP,
		EndCons.Bairro		Cons_Bairro,
		EndCons.Cidade		Cons_Cidade,
		EndCons.UF			Cons_UF,
		EndCons.Pais		Cons_Pais,
		ContCON.Contato,
		(ContCON.cd_int +ContCON.cd_area_fone+ContCON.prefixo+ContCON.num_fone) Cont_fone,		
--	Notify
		NTF.Apelido			Notify,
		NTF.Nome_Raz_Soc	NTF_Razao,
		NTF.Num_CPF_CNPJ	NTF_CNPJ,
		EndNTF.Rua			NTF_Rua,
		EndNTF.Numero		NTF_Num,
		EndNTF.Compl_End	NTF_Compl,
		EndNTF.CEP			NTF_CEP,
		EndNTF.Bairro		NTF_Bairro,
		EndNTF.Cidade		NTF_Cidade,
		EndNTF.UF			NTF_UF,
		EndNTF.Pais			NTF_Pais,
		ContNTF.cd_int,
		ContNTF.Cd_Area_Fone,
		ContNTF.Prefixo,
		ContNTF.Num_fone,
		(ContNTF.cd_int +ContNTF.Cd_Area_Fone+ContNTF.Prefixo+ContNTF.Num_fone) NTF_fone,
		ContNTF.Compl_Fone	Email,
		ContNTF.Contato,
		ContNTF.depto_Ctt	FAX,
	--PED.Incoterm,
	--HEO.Cd_Tp_Oper Incoterm,
	TC.Nome_tp_Oper Incoterm,
	DEST.Nome_Local,
	DSTP.Nome_Pais Pais_Local,
	Descricao_Termo Term_Pagamento,
	PED.cd_tp_moeda,
	HEO.Vlr_Frete_efet_heo Vlr_Frete_Tot,
	Vlr_Seguro,
	Sum(InvDet.Quantidade*InvDET.Preco_Unit) Fob,
	dbo.fMarcasVolumeEM(InvCLI.Num_Proc) Marca_Contra,
	cast(LEO.Tipo_Leo as varchar(7)) Tipo,
	InvCLI.Customer_Bank,
	(ORG.Nome_Local + ' - ' + ORGP.Nome_Pais) Origem,
	HEO.Tp_Frete_HEO	Tipo_Frete,
	InvCLI.Linguagem,
	OBS_PL OBS,
	OBS_INV OBS_INV,
	SAL.numero_PO_HEO Sales_Order,
	PP.Nome_Raz_Soc,
	isnull(PA.nome_pais,EndShip.Pais) Nome_pais,
	CIA.Apelido	Carrier,
--	Fabricante
	FAB.Nome_Raz_Soc FAB_Razao,
	EndFAB.Rua		 FAB_Rua,
	EndFAB.Compl_End FAB_Compl,
	EndFAB.CEP		FAB_CEP,
	EndFAB.Bairro	FAB_Bairro,
	EndFAB.Cidade	FAB_Cidade,
	EndFAB.UF		FAB_UF,
	EndFAB.Pais		FAB_Pais,
	dbo.fBusca_EmbalagensVOL(INVcli.id_inv)	Pack,
	vencimento	due_date
from
	Invoice_Cliente InvCLI
	Join House_Exp_out	HEO 	on HEO.Num_proc_heo	=InvCLI.Num_Proc
	Join LLP_Exp_out	LEO		on LEO.Num_Proc_LEO	=InvCLI.Num_Proc
	Join Invoice_Det	InvDET	on InvDET.ID_Inv 	=InvCLI.ID_Inv
	Join Pedido			PED 	on PED.cd_pedido 	=InvDET.cd_pedido
	Join Pessoa			Cons 	on Cons.cd_pes 		=InvCLI.cd_cliente
	Join Pessoa			SHIP	on SHIP.cd_pes		=HEO.cd_export_heo
	Join Pessoa			NTF		on NTF.cd_pes		=HEO.cd_notify_heo
	Left Join Pessoa	Buyer	on Buyer.cd_pes		=PED.cd_buyer
	Left Join Comunicacao ContBUY on ContBUY.cd_pes	=Buyer.cd_pes and ContBUY.cd_tp_com = 'TC1'
	Left Join Endereco	EndShip on EndShip.cd_pes	=Ship.Cd_Pes and EndShip.cd_tp_end = 'INV'
	Left Join Endereco	EndCons on EndCons.cd_pes 	=Cons.Cd_Pes and EndCons.cd_tp_end = 'INV'
	Left Join Endereco	EndNTF	on EndNTF.cd_pes	=NTF.Cd_Pes and EndNTF.cd_tp_end = 'COM'
	Left Join Endereco	EndBuyer on EndBuyer.cd_pes	=Buyer.Cd_Pes and EndBuyer.cd_tp_end = 'COM'
	Left Join Comunicacao ContNTF on ContNTF.cd_pes	=NTF.cd_pes and ContNTF.cd_tp_com = 'TC1'
	left join Comunicacao ContCON on ContCON.cd_pes = INVcli.cd_cliente
	Left Join Localidade ORG	on HEO.Cd_Org_Heo	=ORG.Cd_Local
	Left Join Pais		ORGP	on ORGP.cd_Pais		=ORG.cd_pais
	Left Join Localidade DEST	on DEST.cd_local	=HEO.cd_dst_heo
	Left Join Pais		DSTP	on DSTP.cd_Pais		=DEST.cd_pais
	Left Join PO_heo	PO		on PO.Num_Proc_heo 	=InvCLI.Num_Proc and PO.ID_DC = '1'
	Left Join PO_heo	RE		on RE.Num_Proc_heo 	=InvCLI.Num_Proc and RE.ID_DC = '4'
	Left Join PO_HEO	CUPO	on CUPO.Num_Proc_heo=InvCLI.Num_Proc and CUPO.ID_DC = '9'
	Left Join PO_HEO	INV		on INV.Num_Proc_heo	=InvCLI.Num_Proc and INV.ID_DC = '2'
	Left Join PO_HEO	SAL		on SAL.Num_Proc_heo	=InvCLI.Num_Proc and SAL.ID_DC = '3'
	Left Join Termo_Pagamento TP on TP.Cd_Termo		=INVCLI.Cd_Termo
	Join Produto_Cliente	PROD on PROD.Cd_Prod 	=INVDET.Cd_Produto
	Join Pessoa			PP		on PROD.Cd_Cliente =PP.Cd_pes
	Join Tipo_Oper		TC		on TC.cd_tp_oper	=heo.cd_tp_oper
	Left Join Pais		PA		on PA.cd_Pais		=InvCLI.cd_pais
	left Join pessoa	CIA		on CIA.cd_pes		=LEO.cd_carrier
	Left Join Campo_Processo CP	on CP.Num_Proc		=InvCLI.Num_Proc and CP.Id_Campo='1'
	Left Join Pessoa	FAB		on FAB.cd_pes		=CP.Campo_Dados
	Left Join Endereco	EndFAB	on EndFAB.cd_pes	=FAB.Cd_Pes and EndFAB.cd_tp_end = 'COM'
Where
	 InvCLI.ID_Inv = @ID_Inv
Group by
--CD_PRODUTO,
InvCLI.Num_Proc,InvCLI.ID_Inv,Num_Invoice,Data_Invoice,CUPO.Numero_PO_Heo,PED.Customer_PO, PO.Numero_PO_Heo,RE.Numero_PO_heo,PED.Num_Pedido,
Ship.Nome_Raz_Soc,EndShip.Rua,EndShip.Numero,EndShip.Compl_End,EndShip.CEP,
EndShip.Bairro,EndShip.Cidade,EndShip.UF,EndShip.Pais,Cons.Apelido,
Cons.Nome_Raz_Soc,Cons.Num_CPF_CNPJ,EndCons.Rua,EndCons.Numero,EndCons.Compl_End,
EndCons.CEP,EndCons.Bairro,EndCons.Cidade,EndCons.UF,EndCons.Pais,PED.Incoterm,
DEST.Nome_Local,DSTP.Nome_Pais,TP.Cd_Termo, Descricao_Termo,PED.cd_tp_moeda,HEO.Vlr_Frete_efet_heo,Vlr_Seguro,LEO.Tipo_Leo,	InvCLI.Customer_Bank,HEO.Tp_Frete_HEO,InvCLI.Linguagem,
NTF.Apelido,NTF.Nome_Raz_Soc,NTF.Num_CPF_CNPJ,EndNTF.Rua,EndNTF.Numero,EndNTF.Compl_End,EndNTF.CEP,EndNTF.Bairro,EndNTF.Cidade,EndNTF.UF,EndNTF.Pais,
ContNTF.cd_int,ContNTF.Cd_Area_Fone,ContNTF.Prefixo,ContNTF.Num_fone,ContNTF.Compl_Fone,
Buyer.Nome_Raz_Soc,EndBuyer.Rua,EndBuyer.Numero,EndBuyer.Compl_End,EndBuyer.CEP,EndBuyer.Bairro,EndBuyer.Cidade,EndBuyer.UF,EndBuyer.Pais,ORGP.Nome_Pais, ORG.Nome_Local,INV.Data_PO_Heo, OBS_PL, OBS_INV, SAL.numero_PO_HEO, PP.Nome_Raz_Soc, HEO.Cd_Tp_Oper, TC.Nome_tp_Oper,PA.nome_pais,
Ship.Num_CPF_CNPJ,Ship.Num_RG_IE,CIA.Apelido,FAB.Nome_Raz_Soc,EndFAB.Rua,EndFAB.Compl_End,EndFAB.CEP,EndFAB.Bairro,EndFAB.Cidade,EndFAB.UF,EndFAB.Pais,
ContCON.Contato,
ContCON.cd_int,
ContCON.cd_area_fone,
ContCON.prefixo,
ContCON.num_fone,
ContCON.compl_fone,
SAL.Numero_PO_HEO,
ContNTF.Contato,
ContNTF.depto_Ctt,
vencimento,
ContBuy.Contato,
ContBuy.cd_int ,ContBuy.Cd_Area_Fone,ContBuy.Prefixo,ContBuy.Num_fone

UNION

select
--	CD_PRODUTO,
	InvCLI.Num_Proc,
	InvCLI.ID_Inv,
	Num_Invoice,
	isnull(INV.Data_PO_Hea,InvCLI.Data_Invoice) Data_Invoice,
	isnull(CUPO.Numero_PO_Hea,PED.Customer_PO) Customer_PO,
	PO.Numero_Po_Hea Num_PO,
	RE.Numero_PO_HEA NumRE,
	SAL.Numero_PO_HEA SAL,
	PED.Num_Pedido, -- Sales Order
--	Buyer
		Buyer.Nome_Raz_Soc	Buyer_Razao,
		EndBuyer.Rua		Buyer_Rua,
		EndBuyer.Numero		Buyer_Num,
		EndBuyer.Compl_End	Buyer_Compl,
		EndBuyer.CEP		Buyer_CEP,
		EndBuyer.Bairro		Buyer_Bairro,
		EndBuyer.Cidade		Buyer_Cidade,
		EndBuyer.UF			Buyer_UF,
		EndBuyer.Pais		Buyer_Pais,
		ContBuy.Contato		BuyerContato,
		(ContBuy.cd_int +ContBuy.Cd_Area_Fone+ContBuy.Prefixo+ContBuy.Num_fone) Buyer_fone,
--	Shipper,
		Ship.Nome_Raz_Soc	Ship_Razao, -- Cd_Cliente,
		Ship.Num_CPF_CNPJ	Ship_CNPJ,
		Ship.Num_RG_IE		Ship_IE,
		EndShip.Rua			Ship_Rua,
		EndShip.Numero		Ship_Num,
		EndShip.Compl_End	Ship_Compl,
		EndShip.CEP			Ship_CEP,
		EndShip.Bairro		Ship_Bairro,
		EndShip.Cidade		Ship_Cidade,
		EndShip.UF			Ship_UF,
		EndShip.Pais		Ship_Pais,
		Cons.Apelido		Consignee,
		Cons.Nome_Raz_Soc	Cons_Razao, -- Cd_Cliente,
		Cons.Num_CPF_CNPJ	Cons_CNPJ,
		EndCons.Rua			Cons_Rua,
		EndCons.Numero		Cons_Num,
		EndCons.Compl_End	Cons_Compl,
		EndCons.CEP			Cons_CEP,
		EndCons.Bairro		Cons_Bairro,
		EndCons.Cidade		Cons_Cidade,
		EndCons.UF			Cons_UF,
		EndCons.Pais		Cons_Pais,
		ContCON.Contato,
		(ContCON.cd_int +ContCON.cd_area_fone+ContCON.prefixo+ContCON.num_fone) Cont_fone,	
--	Notify
		NTF.Apelido			Notify,
		NTF.Nome_Raz_Soc	NTF_Razao,
		NTF.Num_CPF_CNPJ	NTF_CNPJ,
		EndNTF.Rua			NTF_Rua,
		EndNTF.Numero		NTF_Num,
		EndNTF.Compl_End	NTF_Compl,
		EndNTF.CEP			NTF_CEP,
		EndNTF.Bairro		NTF_Bairro,
		EndNTF.Cidade		NTF_Cidade,
		EndNTF.UF			NTF_UF,
		EndNTF.Pais			NTF_Pais,
		ContNTF.cd_int,
		ContNTF.Cd_Area_Fone,
		ContNTF.Prefixo,
		ContNTF.Num_fone,
		(ContNTF.cd_int +ContNTF.Cd_Area_Fone+ContNTF.Prefixo+ContNTF.Num_fone) NTF_fone,
		ContNTF.Compl_Fone	Email,
		ContNTF.Contato,
		ContNTF.depto_Ctt	FAX,
	--PED.Incoterm,
	--HEA.Cd_Tp_Oper Incoterm,
	TC.Nome_tp_Oper Incoterm,
	DEST.Nome_Local,
	DSTP.Nome_Pais Pais_Local,
	Descricao_Termo Term_Pagamento,
	PED.cd_tp_moeda,
	HEA.Vlr_Frete_tot_HEA Vlr_Frete_Tot,
	Vlr_Seguro,
	Sum(InvDet.Quantidade*INVDET.Preco_Unit) Fob,
	dbo.fMarcasVolumeEA(InvCLI.Num_Proc) Marca_Contra,
	cast(InvCLI.id_inv as varchar(7)) Tipo, --para o union funcionar
	InvCLI.Customer_Bank,
	(ORG.Nome_Local + ' - ' + ORGP.Nome_Pais) Origem,
	HEA.Tp_Frete_HEA	Tipo_Frete,
	InvCLI.Linguagem,
	OBS_PL OBS,
	OBS_INV OBS_INV,
	SAL.numero_PO_HEA Sales_Order,
	PP.Nome_Raz_Soc,
	isnull(PA.nome_pais,EndShip.Pais) Nome_pais,
	CIA.Nome_Cia_Aer	Carrier,
--	Fabricante
	FAB.Nome_Raz_Soc FAB_Razao,
	EndFAB.Rua		 FAB_Rua,
	EndFAB.Compl_End FAB_Compl,
	EndFAB.CEP		FAB_CEP,
	EndFAB.Bairro	FAB_Bairro,
	EndFAB.Cidade	FAB_Cidade,
	EndFAB.UF		FAB_UF,
	EndFAB.Pais		FAB_Pais,
	dbo.fBusca_EmbalagensVOL(INVcli.id_inv)	Pack,
	vencimento Due_date
from
	Invoice_Cliente InvCLI
	Join Pessoa			Cons 	on Cons.cd_pes 		=InvCLI.cd_cliente
	Left Join Endereco	EndCons on EndCons.cd_pes 	=Cons.Cd_Pes and EndCons.cd_tp_end = 'INV'
	Left Join PO_HEA	PO		on PO.Num_Proc_HEA 	=InvCLI.Num_Proc and PO.ID_DC = '1'
	Left Join PO_HEA	RE		on RE.Num_Proc_HEA 	=InvCLI.Num_Proc and RE.ID_DC = '4'
	Join Invoice_Det	InvDET	on InvDET.ID_Inv 	=InvCLI.ID_Inv
	Join Pedido			PED 	on PED.cd_pedido 	=InvDET.cd_pedido
	Join House_Exp_Aer	HEA 	on HEA.Num_proc_hea	=InvCLI.Num_Proc
	Join Localidade		DEST	on DEST.cd_local	=HEA.cd_dst_HEA
	Left Join Pais		DSTP	on DSTP.cd_Pais		=DEST.cd_pais
	Join Pessoa			SHIP	on SHIP.cd_pes		=HEA.cd_export_HEA
	Left Join Endereco	EndShip on EndShip.cd_pes 	=Ship.Cd_Pes and EndShip.cd_tp_end = 'INV'
	Join Pessoa			NTF		on NTF.cd_pes		=HEA.cd_notify_hea
	Left Join Endereco	EndNTF	on EndNTF.cd_pes	=NTF.Cd_Pes and EndNTF.cd_tp_end = 'COM'
	Left Join PO_HEA	CUPO	on CUPO.Num_Proc_hea=InvCLI.Num_Proc and CUPO.ID_DC = '9'
	Left Join Comunicacao ContNTF on ContNTF.cd_pes=NTF.cd_pes and ContNTF.cd_tp_com = 'TC1'
	left join Comunicacao ContCON on ContCON.cd_pes = INVcli.cd_cliente
	Left Join Pessoa	Buyer	on Buyer.cd_pes		=PED.cd_buyer
	Left Join Comunicacao ContBUY on ContBUY.cd_pes	=Buyer.cd_pes and ContBUY.cd_tp_com = 'TC1'
	Left Join Endereco	EndBuyer on EndBuyer.cd_pes	=Buyer.Cd_Pes and EndBuyer.cd_tp_end = 'COM'
	Left Join Localidade ORG	on HEA.Cd_Org_Hea	=ORG.Cd_Local
	Left Join Pais		ORGP	on ORGP.cd_Pais		=ORG.cd_pais
	Left Join PO_HEA	INV		on INV.Num_Proc_hea	=InvCLI.Num_Proc and INV.ID_DC = '2'
	Left Join PO_HEA	SAL		on SAL.Num_Proc_hea	=InvCLI.Num_Proc and SAL.ID_DC = '3'
	Left Join Termo_Pagamento TP on TP.Cd_Termo		=INVCLI.Cd_Termo
	Join Produto_Cliente PROD	on PROD.Cd_Prod 	=INVDET.Cd_Produto
	Join Pessoa			PP		on PROD.Cd_Cliente 	=PP.Cd_pes
	Join Tipo_Oper		TC		on TC.cd_tp_oper	=hea.cd_tp_oper
	Left Join Pais		PA		on PA.cd_Pais		=InvCLI.cd_pais
	Left Join LLP_Exp_Aer LLP	on LLP.Num_Proc_LEA	=InvCLI.Num_Proc
	left Join Cia_Aerea CIA		on CIA.cd_cia_Aer	=LLP.cd_ciaaerea_lea
	Left Join Campo_Processo CP	on CP.Num_Proc		=InvCLI.Num_Proc and CP.Id_Campo='1'
	Left Join Pessoa	FAB		on FAB.cd_pes		=CP.Campo_Dados
	Left Join Endereco	EndFAB	on EndFAB.cd_pes	=FAB.Cd_Pes and EndFAB.cd_tp_end = 'COM'
Where
	 InvCLI.ID_Inv = @ID_Inv
Group by
--CD_PRODUTO,
InvCLI.Num_Proc,InvCLI.ID_Inv,Num_Invoice,Data_Invoice,CUPO.Numero_PO_Hea,PED.Customer_PO,PO.Numero_PO_Hea,RE.Numero_PO_HEA,PED.Num_Pedido,
Ship.Nome_Raz_Soc,EndShip.Rua,EndShip.Numero,EndShip.Compl_End,EndShip.CEP,
EndShip.Bairro,EndShip.Cidade,EndShip.UF,EndShip.Pais,Cons.Apelido,
Cons.Nome_Raz_Soc,Cons.Num_CPF_CNPJ,EndCons.Rua,EndCons.Numero,EndCons.Compl_End,
EndCons.CEP,EndCons.Bairro,EndCons.Cidade,EndCons.UF,EndCons.Pais,PED.Incoterm,
DEST.Nome_Local,DSTP.Nome_Pais,TP.Cd_Termo, Descricao_Termo,PED.cd_tp_moeda,HEA.Vlr_Frete_Tot_HEA,Vlr_Seguro,InvCLI.Cd_Cliente,	InvCLI.Customer_Bank,HEA.Tp_Frete_HEA,InvCLI.Linguagem,
NTF.Apelido,NTF.Nome_Raz_Soc,NTF.Num_CPF_CNPJ,EndNTF.Rua,EndNTF.Numero,EndNTF.Compl_End,EndNTF.CEP,EndNTF.Bairro,EndNTF.Cidade,EndNTF.UF,EndNTF.Pais,
ContNTF.cd_int,ContNTF.Cd_Area_Fone,ContNTF.Prefixo,ContNTF.Num_fone,ContNTF.Compl_Fone,
Buyer.Nome_Raz_Soc,EndBuyer.Rua,EndBuyer.Numero,EndBuyer.Compl_End,EndBuyer.CEP,EndBuyer.Bairro,EndBuyer.Cidade,EndBuyer.UF,EndBuyer.Pais,ORGP.Nome_Pais, ORG.Nome_Local,INV.Data_PO_Hea,OBS_PL, OBS_INV, SAL.numero_PO_HEA, PP.Nome_Raz_Soc, HEA.Cd_Tp_Oper, TC.Nome_tp_Oper,PA.nome_pais
,Ship.Num_CPF_CNPJ,Ship.Num_RG_IE,CIA.Nome_Cia_Aer,FAB.Nome_Raz_Soc,EndFAB.Rua,EndFAB.Compl_End,EndFAB.CEP,EndFAB.Bairro,EndFAB.Cidade,EndFAB.UF,EndFAB.Pais,
ContCON.Contato,
ContCON.cd_int,
ContCON.cd_area_fone,
ContCON.prefixo,
ContCON.num_fone,
ContCON.compl_fone,
SAL.Numero_PO_HEA,
ContNTF.Contato,
ContNTF.depto_Ctt,
vencimento,
ContBuy.Contato	,
ContBuy.cd_int,ContBuy.Cd_Area_Fone,ContBuy.Prefixo,ContBuy.Num_fone

UNION

select
--	CD_PRODUTO,
	InvCLI.Num_Proc,
	InvCLI.ID_Inv,
	Num_Invoice,
	isnull(INV.Data_PO_Hem,InvCLI.Data_Invoice) Data_Invoice,
	isnull(CUPO.Numero_PO_Hem,PED.Customer_PO) Customer_PO,
	PO.Numero_Po_Hem Num_PO,
	RE.Numero_PO_HEM NumRE,
	SAL.Numero_PO_HEM SAL,
	PED.Num_Pedido, -- Sales Order
--	Buyer
		Buyer.Nome_Raz_Soc	Buyer_Razao,
		EndBuyer.Rua		Buyer_Rua,
		EndBuyer.Numero		Buyer_Num,
		EndBuyer.Compl_End	Buyer_Compl,
		EndBuyer.CEP		Buyer_CEP,
		EndBuyer.Bairro		Buyer_Bairro,
		EndBuyer.Cidade		Buyer_Cidade,
		EndBuyer.UF			Buyer_UF,
		EndBuyer.Pais		Buyer_Pais,
		ContBuy.Contato		BuyerContato,
		(ContBuy.cd_int +ContBuy.Cd_Area_Fone+ContBuy.Prefixo+ContBuy.Num_fone) Buyer_fone,
--	Shipper,
		Ship.Nome_Raz_Soc	Ship_Razao, -- Cd_Cliente,
		Ship.Num_CPF_CNPJ	Ship_CNPJ,
		Ship.Num_RG_IE		Ship_IE,
		EndShip.Rua			Ship_Rua,
		EndShip.Numero		Ship_Num,
		EndShip.Compl_End	Ship_Compl,
		EndShip.CEP			Ship_CEP,
		EndShip.Bairro		Ship_Bairro,
		EndShip.Cidade		Ship_Cidade,
		EndShip.UF			Ship_UF,
		EndShip.Pais		Ship_Pais,
	Cons.Apelido			Consignee,
		Cons.Nome_Raz_Soc	Cons_Razao, -- Cd_Cliente,
		Cons.Num_CPF_CNPJ	Cons_CNPJ,
		EndCons.Rua			Cons_Rua,
		EndCons.Numero		Cons_Num,
		EndCons.Compl_End	Cons_Compl,
		EndCons.CEP			Cons_CEP,
		EndCons.Bairro		Cons_Bairro,
		EndCons.Cidade		Cons_Cidade,
		EndCons.UF			Cons_UF,
		EndCons.Pais		Cons_Pais,
		ContCON.Contato,
		(ContCON.cd_int +ContCON.cd_area_fone+ContCON.prefixo+ContCON.num_fone) Cont_fone,	
--	Notify
		NTF.Apelido			Notify,
		NTF.Nome_Raz_Soc	NTF_Razao,
		NTF.Num_CPF_CNPJ	NTF_CNPJ,
		EndNTF.Rua			NTF_Rua,
		EndNTF.Numero		NTF_Num,
		EndNTF.Compl_End	NTF_Compl,
		EndNTF.CEP			NTF_CEP,
		EndNTF.Bairro		NTF_Bairro,
		EndNTF.Cidade		NTF_Cidade,
		EndNTF.UF			NTF_UF,
		EndNTF.Pais			NTF_Pais,
		ContNTF.cd_int,
		ContNTF.Cd_Area_Fone,
		ContNTF.Prefixo,
		ContNTF.Num_fone,
		(ContNTF.cd_int + ContNTF.Cd_Area_Fone + ContNTF.Prefixo+ ContNTF.Num_fone) NTF_fone,
		ContNTF.Compl_Fone	Email,
		ContNTF.Contato,
		ContNTF.depto_Ctt	FAX,
	--PED.Incoterm,
	--HEM.Cd_Tp_Oper,
	TC.Nome_tp_Oper Incoterm,
	DEST.Nome_Local,
	DSTP.Nome_Pais Pais_Local,
	Descricao_Termo Term_Pagamento,
	PED.cd_tp_moeda,
	HEM.Vlr_Frete_Tot_HEM Vlr_Frete_Tot,
	Vlr_Seguro,
	Sum(InvDet.Quantidade*INVDET.Preco_Unit) Fob,
	dbo.fMarcasVolumeEM(InvCLI.Num_Proc) Marca_Contra,
	cast(LEM.Cd_Tp_Carga as varchar(7)) Tipo,
	InvCLI.Customer_Bank,
	(ORG.Nome_Local + ' - ' + ORGP.Nome_Pais) Origem,
	HEM.Tp_Frete_HEM	Tipo_Frete,
	InvCLI.Linguagem,
	OBS_PL OBS,
	OBS_INV OBS_INV,
	SAL.numero_PO_HEM Sales_order,
	PP.Nome_Raz_Soc,
	isnull(PA.nome_pais,EndShip.Pais) Nome_pais,
	CIA.Nome_Armador	Carrier,
--	Fabricante
	FAB.Nome_Raz_Soc FAB_Razao,
	EndFAB.Rua		 FAB_Rua,
	EndFAB.Compl_End FAB_Compl,
	EndFAB.CEP		FAB_CEP,
	EndFAB.Bairro	FAB_Bairro,
	EndFAB.Cidade	FAB_Cidade,
	EndFAB.UF		FAB_UF,
	EndFAB.Pais		FAB_Pais,
	dbo.fBusca_EmbalagensVOL(INVcli.id_inv)	Pack,
	vencimento Due_date
from
	Invoice_Cliente InvCLI
	Join Pessoa			Cons 	on Cons.cd_pes 		=InvCLI.cd_cliente
	Left Join Endereco	EndCons on EndCons.cd_pes 	=Cons.Cd_Pes and EndCons.cd_tp_end = 'INV'
	Left Join PO_HEM	PO		on PO.Num_Proc_HEM 	=InvCLI.Num_Proc and PO.ID_DC = '1'
	Left Join PO_HEM	RE		on RE.Num_Proc_HEM 	=InvCLI.Num_Proc and RE.ID_DC = '4'
	Join Invoice_Det	InvDET	on InvDET.ID_Inv 	=InvCLI.ID_Inv
	Join Pedido			PED 	on PED.cd_pedido 	=InvDET.cd_pedido
	Join House_Exp_MAR	HEM 	on HEM.Num_proc_HEM	=InvCLI.Num_Proc
	Join Localidade		DEST	on DEST.cd_local	=HEM.cd_dst_HEM
	Left Join Pais		DSTP	on DSTP.cd_Pais		=DEST.cd_pais
	Join Pessoa			SHIP	on SHIP.cd_pes		=HEM.cd_export_HEM
	Left Join Endereco	EndShip on EndShip.cd_pes 	=Ship.Cd_Pes and EndShip.cd_tp_end = 'INV'
	Join Pessoa			NTF		on NTF.cd_pes		=HEM.cd_notify_hem
	Left Join Endereco	EndNTF	on EndNTF.cd_pes	=NTF.Cd_Pes and EndNTF.cd_tp_end = 'COM'
	Join LLP_Exp_Mar	LEM		on LEM.Num_Proc_LEM	=InvCLI.Num_Proc
	Left Join PO_HEM	CUPO	on CUPO.Num_Proc_hem=InvCLI.Num_Proc and CUPO.ID_DC = '9'
	Left Join Localidade ORG	on HEM.Cd_Org_Hem	=ORG.Cd_Local
	Left Join Pais		ORGP	on ORGP.cd_Pais		=ORG.cd_pais
	Left Join Comunicacao ContNTF on ContNTF.cd_pes=NTF.cd_pes and ContNTF.cd_tp_com = 'TC1'
	left join Comunicacao ContCON on ContCON.cd_pes = INVcli.cd_cliente
	Left Join Pessoa	Buyer	on Buyer.cd_pes		=PED.cd_buyer
	Left Join Comunicacao ContBUY on ContBUY.cd_pes	=Buyer.cd_pes and ContBUY.cd_tp_com = 'TC1'
	Left Join Endereco	EndBuyer on EndBuyer.cd_pes	=Buyer.Cd_Pes and EndBuyer.cd_tp_end = 'COM'
	Left Join PO_HEM	INV		on INV.Num_Proc_hem	=InvCLI.Num_Proc and INV.ID_DC = '2'
	Left Join PO_HEM	SAL		on SAL.Num_Proc_hem	=InvCLI.Num_Proc and SAL.ID_DC = '3'
	Left Join Termo_Pagamento TP on TP.Cd_Termo		=INVCLI.Cd_Termo
	Join Produto_Cliente PROD	on PROD.Cd_Prod 	=INVDET.Cd_Produto
	Join Pessoa			PP		on PROD.Cd_Cliente 	=PP.Cd_pes
	Join Tipo_Oper		TC		on TC.cd_tp_oper	=hem.cd_tp_oper
	Left Join Pais		PA		on PA.cd_Pais		=InvCLI.cd_pais
	left Join Armador CIA		on CIA.cd_armador	=LEM.cd_armador_lem
	Left Join Campo_Processo CP	on CP.Num_Proc		=InvCLI.Num_Proc and CP.Id_Campo='1'
	Left Join Pessoa	FAB		on FAB.cd_pes		=CP.Campo_Dados
	Left Join Endereco	EndFAB	on EndFAB.cd_pes	=FAB.Cd_Pes and EndFAB.cd_tp_end = 'COM'
Where
	 InvCLI.ID_Inv = @ID_Inv
Group by
--CD_PRODUTO,
InvCLI.Num_Proc,InvCLI.ID_Inv,Num_Invoice,Data_Invoice,CUPO.Numero_PO_Hem,PED.Customer_PO,PO.Numero_PO_Hem,RE.Numero_PO_HEM,PED.Num_Pedido,
Ship.Nome_Raz_Soc,EndShip.Rua,EndShip.Numero,EndShip.Compl_End,EndShip.CEP,
EndShip.Bairro,EndShip.Cidade,EndShip.UF,EndShip.Pais,Cons.Apelido,
Cons.Nome_Raz_Soc,Cons.Num_CPF_CNPJ,EndCons.Rua,EndCons.Numero,EndCons.Compl_End,
EndCons.CEP,EndCons.Bairro,EndCons.Cidade,EndCons.UF,EndCons.Pais,PED.Incoterm,
DEST.Nome_Local,DSTP.Nome_Pais,TP.Cd_Termo, Descricao_Termo,PED.cd_tp_moeda,HEM.Vlr_Frete_Tot_HEM,Vlr_Seguro,cd_tp_carga,InvCLI.Customer_Bank,HEM.Tp_Frete_HEM,
ORGP.Nome_Pais,InvCLI.Linguagem,
NTF.Apelido,NTF.Nome_Raz_Soc,NTF.Num_CPF_CNPJ,EndNTF.Rua,EndNTF.Numero,EndNTF.Compl_End,EndNTF.CEP,EndNTF.Bairro,EndNTF.Cidade,EndNTF.UF,EndNTF.Pais,
ContNTF.cd_int,ContNTF.Cd_Area_Fone,ContNTF.Prefixo,ContNTF.Num_fone,ContNTF.Compl_Fone,
Buyer.Nome_Raz_Soc,EndBuyer.Rua,EndBuyer.Numero,EndBuyer.Compl_End,EndBuyer.CEP,EndBuyer.Bairro,EndBuyer.Cidade,EndBuyer.UF,EndBuyer.Pais, ORG.Nome_Local,INV.Data_PO_Hem, OBS_PL, OBS_INV, SAL.numero_PO_HEM, PP.Nome_Raz_Soc, HEM.Cd_Tp_Oper, TC.Nome_tp_Oper,PA.nome_pais
,Ship.Num_CPF_CNPJ,Ship.Num_RG_IE,CIA.Nome_Armador,FAB.Nome_Raz_Soc,EndFAB.Rua,EndFAB.Compl_End,EndFAB.CEP,EndFAB.Bairro,EndFAB.Cidade,EndFAB.UF,EndFAB.Pais,
ContCON.Contato,
ContCON.cd_int,
ContCON.cd_area_fone,
ContCON.prefixo,
ContCON.num_fone,
ContCON.compl_fone,
SAL.Numero_PO_HEM,
ContNTF.Contato,
ContNTF.depto_Ctt,
vencimento,
ContBuy.Contato,
ContBuy.cd_int,ContBuy.Cd_Area_Fone,ContBuy.Prefixo,ContBuy.Num_fone	








GO
