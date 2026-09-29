SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spInvoiceIMP_FMC_Rel]--'2348'

	@ID_Inv	int

AS

	select
		InvCLI.Num_Proc,
		InvCLI.ID_Inv,
		InvCLI.Num_Invoice,
		isnull(INV.Data_PO_Hio,InvCLI.Data_Invoice) Data_Invoice,
		isnull(dbo.fBusca_Docs_PO_Modal(InvCLI.Num_Proc,'9'),PED.Customer_PO) Customer_PO,
		isnull(dbo.fBusca_Docs_PO_Modal(InvCLI.Num_Proc,'1'),PED.Num_Pedido) Num_PO,

--	Shipper
		Ship.Nome_Raz_Soc	Ship_Razao,		
		EndShip.Rua			Ship_Rua,		
		EndShip.Compl_End	Ship_Compl,
		EndShip.CEP			Ship_CEP,		
		EndShip.Cidade		Ship_Cidade,
		EndShip.UF			Ship_UF,
		EndShip.Pais		Ship_Pais,
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
		Buyer.Num_CPF_CNPJ  Buyer_CNPJ,

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
--	Fabricante
		FAB.Nome_Raz_Soc	FAB_Razao,
		EndFAB.Rua			FAB_Rua,
		EndFAB.Compl_End	FAB_Compl,
		EndFAB.CEP			FAB_CEP,
		EndFAB.Bairro		FAB_Bairro,
		EndFAB.Cidade		FAB_Cidade,
		EndFAB.UF			FAB_UF,
		EndFAB.Pais			FAB_Pais,
		TC.Nome_tp_Oper		Incoterm,
		DEST.Nome_Local		Destino,
		DSTP.Nome_Pais		Destino_Pais,
		Descricao_Termo		Term_Pagamento,
		InvCLI.Customer_Bank,
		(ORG.Nome_Local + ' - ' + ORGP.Nome_Pais) Origem,
		(case when HOU.Tp_Frete_Hio='C' then 'COLLECT' else 'PREPAID' end) Tipo_Frete,
		OBS_PL,
		OBS_INV,
		isnull(PA.nome_pais,EndFAB.Pais) Pais_OrigemFAB,
		CIA.Apelido			Carrier,
		LLP.ETD_LIO			ETD,
		PSF.Nome_Raz_Soc	Origin
	from
		Invoice_Cliente InvCLI
		Join House_Imp_out	HOU 	on HOU.Num_proc_hio	=InvCLI.Num_Proc
		Join LLP_Imp_out	LLP		on LLP.Num_Proc_LIO	=InvCLI.Num_Proc
		Join Grupo			GRP		on GRP.grupo=Right(left(InvCLI.Num_Proc,5),3)
		Left Join Pedido	PED		on PED.Cd_Pedido = (select top 1 cd_pedido from pedido_ship where num_proc = InvCLI.Num_Proc) and PED.Cd_Grupo=GRP.Cd_Pes_Grupo
		Left Join Pessoa	Cons 	on Cons.cd_pes 		=InvCLI.cd_cliente
		Left Join Pessoa	SHIP	on SHIP.cd_pes		=HOU.cd_export_hio
		Left Join Pessoa	Buyer	on Buyer.cd_pes		=PED.cd_buyer
		Left Join Endereco	EndShip on EndShip.cd_pes	=Ship.Cd_Pes and EndShip.cd_tp_end = 'INV'
		Left Join Endereco	EndCons on EndCons.cd_pes 	=Cons.Cd_Pes and EndCons.cd_tp_end = 'COM'
		Left Join Endereco	EndBuyer on EndBuyer.cd_pes	=Buyer.Cd_Pes and EndBuyer.cd_tp_end = 'COM'
		Left Join Localidade ORG	on HOU.Cd_Org_HIo	=ORG.Cd_Local
		Left Join Pais		ORGP	on ORGP.cd_Pais		=ORG.cd_pais
		Left Join Localidade DEST	on DEST.cd_local	=HOU.cd_dst_hio
		Left Join Pais		DSTP	on DSTP.cd_Pais		=DEST.cd_pais
		Left Join PO_HiO	INV		on INV.Num_Proc_hio	=InvCLI.Num_Proc and INV.ID_DC = '2'
		Left Join Termo_Pagamento TP on TP.Cd_Termo		=INVCLI.Cd_Termo
		Left Join Tipo_Oper		TC	on TC.cd_tp_oper	=HOU.cd_tp_oper
		Left Join Pais		PA		on PA.cd_Pais		=InvCLI.cd_pais
		left Join pessoa	CIA		on CIA.cd_pes		=LLP.cd_carrier
		Left Join Campo_Processo CP	on CP.Num_Proc		=InvCLI.Num_Proc and CP.Id_Campo='1'
		Left Join Pessoa	FAB		on FAB.cd_pes		=CP.Campo_Dados
		Left Join Endereco	EndFAB	on EndFAB.cd_pes	=FAB.Cd_Pes and EndFAB.cd_tp_end = 'COM'
		Left Join Campo_Processo SF	on SF.Num_Proc		=InvCLI.Num_Proc and SF.Id_Campo='43'
		Left Join Pessoa	PSF		on PSF.cd_pes		=SF.Campo_Dados
	Where
		InvCLI.ID_Inv = @ID_Inv

UNION

	select
		InvCLI.Num_Proc,
		InvCLI.ID_Inv,
		InvCLI.Num_Invoice,
		isnull(INV.Data_PO_HiA,InvCLI.Data_Invoice) Data_Invoice,
		isnull(dbo.fBusca_Docs_PO_Modal(InvCLI.Num_Proc,'9'),PED.Customer_PO) Customer_PO,
		isnull(dbo.fBusca_Docs_PO_Modal(InvCLI.Num_Proc,'1'),PED.Num_Pedido) Num_PO,
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
		Buyer.Num_CPF_CNPJ  Buyer_CNPJ,
--	Shipper
		Ship.Nome_Raz_Soc	Ship_Razao,		
		EndShip.Rua			Ship_Rua,		
		EndShip.Compl_End	Ship_Compl,
		EndShip.CEP			Ship_CEP,		
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
--	Fabricante
		FAB.Nome_Raz_Soc	FAB_Razao,
		EndFAB.Rua			FAB_Rua,
		EndFAB.Compl_End	FAB_Compl,
		EndFAB.CEP			FAB_CEP,
		EndFAB.Bairro		FAB_Bairro,
		EndFAB.Cidade		FAB_Cidade,
		EndFAB.UF			FAB_UF,
		EndFAB.Pais			FAB_Pais,
		TC.Nome_tp_Oper		Incoterm,
		DEST.Nome_Local		Destino,
		DSTP.Nome_Pais		Destino_Pais,
		Descricao_Termo		Term_Pagamento,
		InvCLI.Customer_Bank,
		(ORG.Nome_Local + ' - ' + ORGP.Nome_Pais) Origem,
		(case when HOU.Tp_Frete_Hia='C' then 'COLLECT' else 'PREPAID' end) Tipo_Frete,
		OBS_PL,
		OBS_INV,
		isnull(PA.nome_pais,EndFAB.Pais) Pais_OrigemFAB,
		CIA.Nome_Cia_Aer		Carrier,
		LLP.ETD_LIA				ETD,
		PSF.Nome_Raz_Soc		Origin
	from
		Invoice_Cliente InvCLI
		Join House_Imp_Aer	HOU 	on HOU.Num_proc_hia	=InvCLI.Num_Proc
		Join LLP_Imp_Aer	LLP		on LLP.Num_Proc_LIA	=InvCLI.Num_Proc
		Join Grupo			GRP		on GRP.grupo=Right(left(InvCLI.Num_Proc,5),3)
		Left Join Pedido	PED		on PED.Cd_Pedido = (select top 1 cd_pedido from pedido_ship where num_proc = InvCLI.Num_Proc) and PED.Cd_Grupo=GRP.Cd_Pes_Grupo
		Left Join Pessoa	Cons 	on Cons.cd_pes 		=InvCLI.cd_cliente
		Left Join Pessoa	SHIP	on SHIP.cd_pes		=HOU.cd_export_hia
		Left Join Pessoa	Buyer	on Buyer.cd_pes		=PED.cd_buyer
		Left Join Endereco	EndShip on EndShip.cd_pes	=Ship.Cd_Pes and EndShip.cd_tp_end = 'INV'
		Left Join Endereco	EndCons on EndCons.cd_pes 	=Cons.Cd_Pes and EndCons.cd_tp_end = 'COM'
		Left Join Endereco	EndBuyer on EndBuyer.cd_pes	=Buyer.Cd_Pes and EndBuyer.cd_tp_end = 'COM'
		Left Join Localidade ORG	on HOU.Cd_Org_HIA	=ORG.Cd_Local
		Left Join Pais		ORGP	on ORGP.cd_Pais		=ORG.cd_pais
		Left Join Localidade DEST	on DEST.cd_local	=HOU.cd_dst_hia
		Left Join Pais		DSTP	on DSTP.cd_Pais		=DEST.cd_pais
		Left Join PO_HiA	INV		on INV.Num_Proc_hiA	=InvCLI.Num_Proc and INV.ID_DC = '2'
		Left Join Termo_Pagamento TP on TP.Cd_Termo		=INVCLI.Cd_Termo
		Left Join Tipo_Oper		TC	on TC.cd_tp_oper	=HOU.cd_tp_oper
		Left Join Pais		PA		on PA.cd_Pais		=InvCLI.cd_pais
		Left Join Job_Imp_Aer	JOB	on HOU.Num_Proc_HIA = JOB.Num_Proc_HIA
		left Join Cia_Aerea CIA		on CIA.cd_cia_Aer	=JOB.Cd_Cia_Aer
		Left Join Campo_Processo CP	on CP.Num_Proc		=InvCLI.Num_Proc and CP.Id_Campo='1'
		Left Join Pessoa	FAB		on FAB.cd_pes		=CP.Campo_Dados
		Left Join Endereco	EndFAB	on EndFAB.cd_pes	=FAB.Cd_Pes and EndFAB.cd_tp_end = 'COM'
		Left Join Campo_Processo SF	on SF.Num_Proc		=InvCLI.Num_Proc and SF.Id_Campo='43'
		Left Join Pessoa	PSF		on PSF.cd_pes		=SF.Campo_Dados
	Where
		InvCLI.ID_Inv = @ID_Inv

UNION

	select
		InvCLI.Num_Proc,
		InvCLI.ID_Inv,
		InvCLI.Num_Invoice,
		isnull(INV.Data_PO_HiM,InvCLI.Data_Invoice) Data_Invoice,
		isnull(dbo.fBusca_Docs_PO_Modal(InvCLI.Num_Proc,'9'),PED.Customer_PO) Customer_PO,
		isnull(dbo.fBusca_Docs_PO_Modal(InvCLI.Num_Proc,'1'),PED.Num_Pedido) Num_PO,
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
		Buyer.Num_CPF_CNPJ  Buyer_CNPJ,
--	Shipper
		Ship.Nome_Raz_Soc	Ship_Razao,		
		EndShip.Rua			Ship_Rua,		
		EndShip.Compl_End	Ship_Compl,
		EndShip.CEP			Ship_CEP,		
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
--	Fabricante
		FAB.Nome_Raz_Soc	FAB_Razao,
		EndFAB.Rua			FAB_Rua,
		EndFAB.Compl_End	FAB_Compl,
		EndFAB.CEP			FAB_CEP,
		EndFAB.Bairro		FAB_Bairro,
		EndFAB.Cidade		FAB_Cidade,
		EndFAB.UF			FAB_UF,
		EndFAB.Pais			FAB_Pais,
		TC.Nome_tp_Oper		Incoterm,
		DEST.Nome_Local		Destino,
		DSTP.Nome_Pais		Destino_Pais,
		Descricao_Termo		Term_Pagamento,
		InvCLI.Customer_Bank,
		(ORG.Nome_Local + ' - ' + ORGP.Nome_Pais) Origem,
		(case when HOU.Tp_Frete_HiM='C' then 'COLLECT' else 'PREPAID' end) Tipo_Frete,
		OBS_PL,
		OBS_INV,
		isnull(PA.nome_pais,EndFAB.Pais) Pais_OrigemFAB,
		CIA.Nome_Armador		Carrier,
		LLP.ETD_LIM				ETD,
		PSF.Nome_Raz_Soc		Origin
	from
		Invoice_Cliente InvCLI
		Join House_Imp_Mar	HOU 	on HOU.Num_proc_hiM	=InvCLI.Num_Proc
		Join LLP_Imp_Mar	LLP		on LLP.Num_Proc_LIM	=InvCLI.Num_Proc
		Join Grupo			GRP		on GRP.grupo=Right(left(InvCLI.Num_Proc,5),3)
		Left Join Pedido	PED		on PED.Cd_Pedido = (select top 1 cd_pedido from pedido_ship where num_proc = InvCLI.Num_Proc) and PED.Cd_Grupo=GRP.Cd_Pes_Grupo
		Left Join Pessoa	Cons 	on Cons.cd_pes 		=InvCLI.cd_cliente
		Left Join Pessoa	SHIP	on SHIP.cd_pes		=HOU.cd_export_him
		Left Join Pessoa	Buyer	on Buyer.cd_pes		=PED.cd_buyer
		Left Join Endereco	EndShip on EndShip.cd_pes	=Ship.Cd_Pes and EndShip.cd_tp_end = 'INV'
		Left Join Endereco	EndCons on EndCons.cd_pes 	=Cons.Cd_Pes and EndCons.cd_tp_end = 'COM'
		Left Join Endereco	EndBuyer on EndBuyer.cd_pes	=Buyer.Cd_Pes and EndBuyer.cd_tp_end = 'COM'
		Left Join Localidade ORG	on HOU.Cd_Org_HIM	=ORG.Cd_Local
		Left Join Pais		ORGP	on ORGP.cd_Pais		=ORG.cd_pais
		Left Join Localidade DEST	on DEST.cd_local	=HOU.cd_dst_hiM
		Left Join Pais		DSTP	on DSTP.cd_Pais		=DEST.cd_pais
		Left Join PO_HiM	INV		on INV.Num_Proc_hiM	=InvCLI.Num_Proc and INV.ID_DC = '2'
		Left Join Termo_Pagamento TP on TP.Cd_Termo		=INVCLI.Cd_Termo
		Left Join Tipo_Oper	TC		on TC.cd_tp_oper	=HOU.cd_tp_oper
		Left Join Pais		PA		on PA.cd_Pais		=InvCLI.cd_pais
		Left Join Job_Imp_Mar	JOB	on HOU.Num_Proc_HIM = JOB.Num_Proc_HIM
		left Join Armador CIA		on CIA.cd_armador	=JOB.Cd_Armador
		Left Join Campo_Processo CP	on CP.Num_Proc		=InvCLI.Num_Proc and CP.Id_Campo='1'
		Left Join Pessoa	FAB		on FAB.cd_pes		=CP.Campo_Dados
		Left Join Endereco	EndFAB	on EndFAB.cd_pes	=FAB.Cd_Pes and EndFAB.cd_tp_end = 'COM'
		Left Join Campo_Processo SF	on SF.Num_Proc		=InvCLI.Num_Proc and SF.Id_Campo='43'
		Left Join Pessoa	PSF		on PSF.cd_pes		=SF.Campo_Dados
	Where
		InvCLI.ID_Inv = @ID_Inv



GO
