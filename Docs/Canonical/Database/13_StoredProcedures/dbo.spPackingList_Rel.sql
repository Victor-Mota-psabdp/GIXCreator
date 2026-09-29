SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE                Procedure [dbo].[spPackingList_Rel] --'4696'

@ID_Inv	int

AS
-- EXPORTAÇÃO AEREA --
select
	Cd_Produto,
	InvCLI.Num_Proc,
	InvCLI.ID_Inv,
	Num_Invoice,
	Data_Invoice,
	dbo.fBusca_Docs_PO_Modal(InvCLI.Num_Proc,1) NumPO,
	dbo.fBusca_Docs_PO_Modal(InvCLI.Num_Proc,3) NumSAL,
	dbo.fBusca_Docs_PO_Modal(InvCLI.Num_Proc,8) SHIPMENT,
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
--	Shipper,
		Ship.Nome_Raz_Soc	Ship_Razao, -- Cd_Cliente,
		Ship.Num_CPF_CNPJ	Ship_CNPJ,
		EndShip.Rua			Ship_Rua,
		EndShip.Numero		Ship_Num,
		EndShip.Compl_End	Ship_Compl,
		EndShip.CEP			Ship_CEP,
		EndShip.Bairro		Ship_Bairro,
		EndShip.Cidade		Ship_Cidade,
		EndShip.UF			Ship_UF,
		EndShip.Pais		Ship_Pais,
--	Consignee,
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
--	Notify,
		Notify.Nome_Raz_Soc	Notify_Razao, -- Cd_Cliente,
		Notify.Num_CPF_CNPJ	Notify_CNPJ,
		EndNotify.Rua		Notify_Rua,
		'0'					Notify_Num,
		EndNotify.Compl_End	Notify_Compl,
		EndNotify.CEP		Notify_CEP,
		EndNotify.Bairro	Notify_Bairro,
		EndNotify.Cidade	Notify_Cidade,
		EndNotify.UF		Notify_UF,
		EndNotify.Pais		Notify_Pais,
		(ContNTF.cd_int +ContNTF.Cd_Area_Fone+ContNTF.Prefixo+ContNTF.Num_fone) NTF_fone,
		ContNTF.Compl_Fone	Email,
		ContNTF.Contato,
		ContNTF.depto_Ctt	FAX,
	InvCLI.Obs_PL,
	Sum(INVdet.peso_bruto)	PesoBruto,
	Sum(INVdet.Peso_liquido) PesoLiq,
	InvDet.Tipo_Unid,
	ORG.nome_pais,
	dbo.fBusca_EmbalagensVOL(INVcli.id_inv)	Pack,
	dbo.fBusca_PRODUTO(INVcli.Num_Proc)	Produtos,
	(select sum(qtd_Vol_EA) from volume_exp_aer where Num_Proc_Hea = InvCLI.Num_Proc) Pallets


from
	Invoice_Cliente InvCLI
	Join Pessoa			Cons 		on Cons.cd_pes=InvCLI.cd_cliente
	Left Join Endereco	EndCons		on EndCons.cd_pes=Cons.Cd_Pes and EndCons.cd_tp_end = 'COM'
	Left Join PO_HEA	PO			on PO.Num_Proc_HEA=InvCLI.Num_Proc and PO.ID_DC = '1'
	Left Join PO_HEA	SHIPMENT	on SHIPMENT.Num_Proc_HEA=InvCLI.Num_Proc and SHIPMENT.ID_DC = '8'
	Left Join Invoice_Det InvDET    on InvDET.ID_Inv=InvCLI.ID_Inv
	Join Pedido			PED 		on PED.cd_pedido=InvDET.cd_pedido
	Join House_Exp_Aer	HEA 		on HEA.Num_proc_hea=InvCLI.Num_Proc
	Join Pessoa			SHIP		on SHIP.cd_pes=HEA.cd_export_HEA
	Left Join Endereco	EndShip		on EndShip.cd_pes=Ship.Cd_Pes and EndShip.cd_tp_end = 'INV'
	Left Join Pessoa	Notify		on Notify.cd_pes=HEA.cd_notify_HEA
	Left Join Endereco	EndNotify	on EndNotify.cd_pes=Notify.Cd_Pes and EndNotify.cd_tp_end = 'COM'
	Left Join Comunicacao ContNTF on ContNTF.cd_pes	=Notify.cd_pes and ContNTF.cd_tp_com = 'TC1'
	Left Join Pessoa	Buyer		on Buyer.cd_pes=PED.cd_buyer
	Left Join Endereco	EndBuyer	on EndBuyer.cd_pes=Buyer.Cd_Pes and EndBuyer.cd_tp_end = 'COM'
	Left Join Pais		ORG		on ORG.cd_Pais		=InvCli.cd_pais

Where
	 InvCLI.ID_Inv = @ID_Inv
Group by
	Cd_Produto,
	InvCLI.Num_Proc,
	InvCLI.ID_Inv,
	Num_Invoice,
	Data_Invoice,
--	PO.Numero_PO_HEA,
--	SHIPMENT.Numero_PO_HEA,
	PED.Num_Pedido, 
	Ship.Nome_Raz_Soc,
	SHIP.Num_CPF_CNPJ,
	EndShip.Rua,
	EndShip.Numero,
	EndShip.Compl_End,
	EndShip.CEP,
	EndShip.Bairro,
	EndShip.Cidade,
	EndShip.UF,
	EndShip.Pais,
	Cons.Nome_Raz_Soc,
	Cons.Num_CPF_CNPJ,
	EndCons.Rua,
	EndCons.Numero,
	EndCons.Compl_End,
	EndCons.CEP,
	EndCons.Bairro,
	EndCons.Cidade,
	EndCons.UF,
	EndCons.Pais,
	Notify.Nome_Raz_Soc,
	Notify.Num_CPF_CNPJ,
	EndNotify.Rua,
--	EndNotify.Numero,
	EndNotify.Compl_End,
	EndNotify.CEP,
	EndNotify.Bairro,
	EndNotify.Cidade,
	EndNotify.UF,
	EndNotify.Pais,
	InvCLI.Obs_PL,
	InvDet.Tipo_Unid,
	Buyer.Nome_Raz_Soc,
	EndBuyer.Rua,
	EndBuyer.Numero,
	EndBuyer.Compl_End,
	EndBuyer.CEP,
	EndBuyer.Bairro,
	EndBuyer.Cidade,
	EndBuyer.UF,
	EndBuyer.Pais,
	ORG.nome_pais,
	ContNTF.cd_int,
	ContNTF.Cd_Area_Fone,
	ContNTF.Prefixo,
	ContNTF.Num_fone,
	INVdet.peso_bruto,
	INVdet.Peso_liquido,
	ContNTF.Contato,
	ContNTF.depto_Ctt,
	ContNTF.Compl_Fone

Union All

-- EXPORTAÇÃO MARITMA --
select
	Cd_Produto,
	InvCLI.Num_Proc,
	InvCLI.ID_Inv,
	Num_Invoice,
	Data_Invoice,
	dbo.fBusca_Docs_PO_Modal(InvCLI.Num_Proc,1) NumPO,
	dbo.fBusca_Docs_PO_Modal(InvCLI.Num_Proc,3) NumSAL,
	dbo.fBusca_Docs_PO_Modal(InvCLI.Num_Proc,8) SHIPMENT,
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
--	Shipper,
		Ship.Nome_Raz_Soc	Ship_Razao,
		Ship.Num_CPF_CNPJ	Ship_CNPJ,
		EndShip.Rua			Ship_Rua,
		EndShip.Numero		Ship_Num,
		EndShip.Compl_End	Ship_Compl,
		EndShip.CEP			Ship_CEP,
		EndShip.Bairro		Ship_Bairro,
		EndShip.Cidade		Ship_Cidade,
		EndShip.UF			Ship_UF,
		EndShip.Pais		Ship_Pais,
--	Consignee,
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
--	Notify,
		Notify.Nome_Raz_Soc	Notify_Razao,
		Notify.Num_CPF_CNPJ	Notify_CNPJ,
		EndNotify.Rua		Notify_Rua,
		'0'					Notify_Num,
		EndNotify.Compl_End	Notify_Compl,
		EndNotify.CEP		Notify_CEP,
		EndNotify.Bairro	Notify_Bairro,
		EndNotify.Cidade	Notify_Cidade,
		EndNotify.UF		Notify_UF,
		EndNotify.Pais		Notify_Pais,
		(ContNTF.cd_int +ContNTF.Cd_Area_Fone+ContNTF.Prefixo+ContNTF.Num_fone) NTF_fone,
		ContNTF.Compl_Fone	Email,
		ContNTF.Contato,
		ContNTF.depto_Ctt	FAX,
	InvCLI.Obs_PL,
	Sum(INVdet.peso_bruto)	PesoBruto,
	Sum(INVdet.Peso_liquido) PesoLiq,
	InvDet.Tipo_Unid,
	ORG.nome_pais,
	dbo.fBusca_EmbalagensVOL(INVcli.id_inv)	Pack,
	dbo.fBusca_PRODUTO(INVcli.Num_Proc)	Produtos,
	(select sum(qtd_Vol_Em) from volume_exp_mar where num_proc_hem = InvCLI.Num_Proc) Pallets
from
	Invoice_Cliente InvCLI
	Left Join Invoice_Det InvDET	on InvDET.ID_Inv=InvCLI.ID_Inv
	Join Pessoa			Cons 		on Cons.cd_pes=InvCLI.cd_cliente
	Left Join Endereco	EndCons		on EndCons.cd_pes=Cons.Cd_Pes and EndCons.cd_tp_end = 'COM'
--	Left Join PO_HEM	PO			on PO.Num_Proc_HEM=InvCLI.Num_Proc and PO.ID_DC = '1'
--	Left Join PO_HEM	SHIPMENT	on SHIPMENT.Num_Proc_HEM=InvCLI.Num_Proc and SHIPMENT.ID_DC = '8'
	Join Pedido			PED 		on PED.cd_pedido=InvDET.cd_pedido
	Join House_Exp_Mar	HEM 		on HEM.Num_proc_HEM=InvCLI.Num_Proc
	Join Pessoa			SHIP		on SHIP.cd_pes=HEM.cd_export_HEM
	Left Join Endereco	EndShip		on EndShip.cd_pes=Ship.Cd_Pes and EndShip.cd_tp_end = 'INV'
	Left Join Pessoa	Notify		on Notify.cd_pes=HEM.cd_notify_HEM
	Left Join Endereco	EndNotify	on EndNotify.cd_pes=Notify.Cd_Pes and EndNotify.cd_tp_end = 'COM'
	Left Join Comunicacao ContNTF on ContNTF.cd_pes	=Notify.cd_pes and ContNTF.cd_tp_com = 'TC1'
	Left Join Pessoa	Buyer		on Buyer.cd_pes=PED.cd_buyer
	Left Join Endereco	EndBuyer	on EndBuyer.cd_pes=Buyer.Cd_Pes and EndBuyer.cd_tp_end = 'COM'
	Left Join Pais		ORG		on ORG.cd_Pais		=InvCli.cd_pais
Where
	 InvCLI.ID_Inv = @ID_Inv

Group by
	Cd_Produto,
	InvCLI.Num_Proc,
	InvCLI.ID_Inv,
	Num_Invoice,
	Data_Invoice,
--	PO.Numero_PO_HEM,
--	SHIPMENT.Numero_PO_HEM,
	PED.Num_Pedido, 
	Ship.Nome_Raz_Soc,
	SHIP.Num_CPF_CNPJ,
	EndShip.Rua,
	EndShip.Numero,
	EndShip.Compl_End,
	EndShip.CEP,
	EndShip.Bairro,
	EndShip.Cidade,
	EndShip.UF,
	EndShip.Pais,
	Cons.Nome_Raz_Soc,
	Cons.Num_CPF_CNPJ,
	EndCons.Rua,
	EndCons.Numero,
	EndCons.Compl_End,
	EndCons.CEP,
	EndCons.Bairro,
	EndCons.Cidade,
	EndCons.UF,
	EndCons.Pais,
	Notify.Nome_Raz_Soc,
	Notify.Num_CPF_CNPJ,
	EndNotify.Rua,
--	EndNotify.Numero,
	EndNotify.Compl_End,
	EndNotify.CEP,
	EndNotify.Bairro,
	EndNotify.Cidade,
	EndNotify.UF,
	EndNotify.Pais,
	InvCLI.Obs_PL,
	InvDet.Tipo_Unid,
	Buyer.Nome_Raz_Soc,
	EndBuyer.Rua,
	EndBuyer.Numero,
	EndBuyer.Compl_End,
	EndBuyer.CEP,
	EndBuyer.Bairro,
	EndBuyer.Cidade,
	EndBuyer.UF,
	EndBuyer.Pais,
	ORG.nome_pais,
	ContNTF.cd_int,
	ContNTF.Cd_Area_Fone,
	ContNTF.Prefixo,
	ContNTF.Num_fone,
	INVdet.peso_bruto,
	INVdet.Peso_liquido,
	ContNTF.Contato,
	ContNTF.depto_Ctt,
	ContNTF.Compl_Fone

Union All

-- EXPORTAÇÃO OUTROS --
select
	Cd_Produto,
	InvCLI.Num_Proc,
	InvCLI.ID_Inv,
	Num_Invoice,
	Data_Invoice,
	dbo.fBusca_Docs_PO_Modal(InvCLI.Num_Proc,1) NumPO,
	dbo.fBusca_Docs_PO_Modal(InvCLI.Num_Proc,3) NumSAL,
	dbo.fBusca_Docs_PO_Modal(InvCLI.Num_Proc,8) SHIPMENT,
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
--	Shipper,
		Ship.Nome_Raz_Soc	Ship_Razao,
		Ship.Num_CPF_CNPJ	Ship_CNPJ,
		EndShip.Rua			Ship_Rua,
		EndShip.Numero		Ship_Num,
		EndShip.Compl_End	Ship_Compl,
		EndShip.CEP			Ship_CEP,
		EndShip.Bairro		Ship_Bairro,
		EndShip.Cidade		Ship_Cidade,
		EndShip.UF			Ship_UF,
		EndShip.Pais		Ship_Pais,
--	Consignee,
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
--	Notify,
		Notify.Nome_Raz_Soc	Notify_Razao,
		Notify.Num_CPF_CNPJ	Notify_CNPJ,
		EndNotify.Rua		Notify_Rua,
		'0'					Notify_Num,
		EndNotify.Compl_End	Notify_Compl,
		EndNotify.CEP		Notify_CEP,
		EndNotify.Bairro	Notify_Bairro,
		EndNotify.Cidade	Notify_Cidade,
		EndNotify.UF		Notify_UF,
		EndNotify.Pais		Notify_Pais,
		(ContNTF.cd_int +ContNTF.Cd_Area_Fone+ContNTF.Prefixo+ContNTF.Num_fone) NTF_fone,
		ContNTF.Compl_Fone	Email,
		ContNTF.Contato,
		ContNTF.depto_Ctt	FAX,
	InvCLI.Obs_PL,
	Sum(INVdet.peso_bruto)	PesoBruto,
	Sum(INVdet.Peso_liquido) PesoLiq,
	InvDet.Tipo_Unid,
	ORG.nome_pais,
	dbo.fBusca_EmbalagensVOL(INVcli.id_inv)	Pack,
	dbo.fBusca_PRODUTO(INVcli.Num_Proc)	Produtos,
	'' Pallets
from
	Invoice_Cliente InvCLI
	Join Pessoa			Cons 		on Cons.cd_pes	=InvCLI.cd_cliente
	Left Join Endereco	EndCons		on EndCons.cd_pes 	=Cons.Cd_Pes and EndCons.cd_tp_end = 'COM'
--	Left Join PO_HEO	PO			on PO.Num_Proc_HEO 	=InvCLI.Num_Proc and PO.ID_DC = '1'
--	Left Join PO_HEO	SHIPMENT	on SHIPMENT.Num_Proc_HEO=InvCLI.Num_Proc and SHIPMENT.ID_DC = '8'
	Left Join Invoice_Det InvDET	on InvDET.ID_Inv 	=InvCLI.ID_Inv
	Join Pedido			PED 		on PED.cd_pedido 	=InvDET.cd_pedido
	Join House_Exp_OUT	HEO 		on HEO.Num_proc_HEO	=InvCLI.Num_Proc
	Join Pessoa			SHIP		on SHIP.cd_pes	=HEO.cd_export_HEO
	Left Join Endereco	EndShip		on EndShip.cd_pes 	=Ship.Cd_Pes and EndShip.cd_tp_end = 'INV'
	Left Join Pessoa	Notify		on Notify.cd_pes	=HEO.cd_notify_HEO
	Left Join Endereco	EndNotify	on EndNotify.cd_pes=Notify.Cd_Pes and EndNotify.cd_tp_end = 'COM'
	Left Join Comunicacao ContNTF on ContNTF.cd_pes	=Notify.cd_pes and ContNTF.cd_tp_com = 'TC1'
	Left Join Pessoa	Buyer		on Buyer.cd_pes=PED.cd_buyer
	Left Join Endereco	EndBuyer	on EndBuyer.cd_pes=Buyer.Cd_Pes and EndBuyer.cd_tp_end = 'COM'
	Left Join Pais		ORG		on ORG.cd_Pais		=InvCli.cd_pais
Where
	 InvCLI.ID_Inv = @ID_Inv
Group by
	Cd_Produto,
	InvCLI.Num_Proc,
	InvCLI.ID_Inv,
	Num_Invoice,
	Data_Invoice,
--	PO.Numero_PO_HEO,
--	SHIPMENT.Numero_PO_HEO,
	PED.Num_Pedido, 
	Ship.Nome_Raz_Soc,
	SHIP.Num_CPF_CNPJ,
	EndShip.Rua,
	EndShip.Numero,
	EndShip.Compl_End,
	EndShip.CEP,
	EndShip.Bairro,
	EndShip.Cidade,
	EndShip.UF,
	EndShip.Pais,
	Cons.Nome_Raz_Soc,
	Cons.Num_CPF_CNPJ,
	EndCons.Rua,
	EndCons.Numero,
	EndCons.Compl_End,
	EndCons.CEP,
	EndCons.Bairro,
	EndCons.Cidade,
	EndCons.UF,
	EndCons.Pais,
	Notify.Nome_Raz_Soc,
	Notify.Num_CPF_CNPJ,
	EndNotify.Rua,
--	EndNotify.Numero,
	EndNotify.Compl_End,
	EndNotify.CEP,
	EndNotify.Bairro,
	EndNotify.Cidade,
	EndNotify.UF,
	EndNotify.Pais,
	InvCLI.Obs_PL,
	InvDet.Tipo_Unid,
	Buyer.Nome_Raz_Soc,
	EndBuyer.Rua,
	EndBuyer.Numero,
	EndBuyer.Compl_End,
	EndBuyer.CEP,
	EndBuyer.Bairro,
	EndBuyer.Cidade,
	EndBuyer.UF,
	EndBuyer.Pais,
	ORG.nome_pais,
	ContNTF.cd_int,
	ContNTF.Cd_Area_Fone,
	ContNTF.Prefixo,
	ContNTF.Num_fone,
	INVdet.peso_bruto,
	INVdet.Peso_liquido,
	ContNTF.Contato,
	ContNTF.depto_Ctt,
	ContNTF.Compl_Fone











GO
