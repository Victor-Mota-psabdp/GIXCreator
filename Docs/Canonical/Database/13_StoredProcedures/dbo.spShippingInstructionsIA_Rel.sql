SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE		PROCEDURE [dbo].[spShippingInstructionsIA_Rel] --'IACSR20091203201'
(
@Processo	VarChar(16)
)
AS

Select
		HOU.Num_Proc_HIA,
--MASTER BILL OF LADING
--	Agente
		AG.Apelido			Agente,
		AG.Nome_Raz_Soc		Ag_Razao,
		EndAG.Rua			Ag_Rua,
		EndAG.Numero		Ag_Num,
		EndAG.Compl_End		Ag_Compl,
		EndAG.Bairro		Ag_Bairro,
		EndAG.CEP			Ag_CEP,
		EndAG.Cidade		Ag_Cidade,
		EndAG.UF			Ag_UF,
		EndAG.Pais			Ag_Pais,
--	Forwarder
		FORW.Apelido		Forwarder,
		FORW.Nome_Raz_Soc	Forw_Razao,
		FORW.Num_CPF_CNPJ	Forw_CNPJ,
		EndFORW.Rua			Forw_Rua,
		EndFORW.Numero		Forw_Num,
		EndFORW.Compl_End	Forw_Compl,
		EndFORW.Bairro		Forw_Bairro,
		EndFORW.CEP			Forw_CEP,
		EndFORW.Cidade		Forw_Cidade,
		EndFORW.UF			Forw_UF,
		EndFORW.Pais		Forw_Pais,
--	Notify Master
		NM.Apelido			NotifyMaster,
		NM.Nome_Raz_Soc		NotM_Razao,
		NM.Num_CPF_CNPJ		NotM_CNPJ,
		EndNM.Rua			NotM_Rua,
		EndNM.Numero		NotM_Num,
		EndNM.Compl_End		NotM_Compl,
		EndNM.Bairro		NotM_Bairro,
		EndNM.CEP			NotM_CEP,
		EndNM.Cidade		NotM_Cidade,
		EndNM.UF			NotM_UF,
		EndNM.Pais			NotM_Pais,
--HOUSE BL
--	Shipper
		Ship.Apelido 		Shipper,
		Ship.Nome_Raz_Soc	Ship_Razao,
		EndShip.Rua			Ship_Rua,
		EndShip.Numero		Ship_Num,
		EndShip.Compl_End	Ship_Compl,
		EndShip.Bairro		Ship_Bairro,
		EndShip.CEP			Ship_CEP,
		EndShip.Cidade		Ship_Cidade,
		EndShip.UF			Ship_UF,
		EndShip.Pais		Ship_Pais,
--	Consignee
		Consig.Apelido 		Consignee,
		Consig.Nome_Raz_Soc	Cons_Razao,
		right(consig.num_cpf_cnpj,14) Cons_CNPJ,
		EndCons.Rua			Cons_Rua,
		EndCons.Numero		Cons_Num,
		EndCons.Compl_End	Cons_Compl,
		EndCons.Bairro		Cons_Bairro,
		EndCons.CEP			Cons_CEP,
		EndCons.Cidade		Cons_Cidade,
		EndCons.UF			Cons_UF,
		EndCons.Pais		Cons_Pais,
--	Notify
		Import.Apelido 		Notify,
		Import.Nome_Raz_Soc	Not_Razao,
		right(notF.num_cpf_cnpj,14) Not_CNPJ,
		EndImp.Rua			Not_Rua,
		EndImp.Numero		Not_Num,
		EndImp.Compl_End	Not_Compl,
		EndImp.Bairro		Not_Bairro,
		EndImp.CEP			Not_CEP,
		EndImp.Cidade		Not_Cidade,
		EndImp.UF			Not_UF,
		EndImp.Pais			Not_Pais,

		dbo.fBusca_Docs_PO_Modal(@Processo,1) PO,
		dbo.fBusca_Docs_PO_Modal(@Processo,2) Invoce,
		dbo.fNCM(@Processo)	 NCM,
		GD.Descr		 Good_Descr,

--RATE INFORMATION
		AEREA.Nome_Cia_Aer	Cia_Aerea,
		Cd_Tp_Oper		Incoterm,
		Orig.Nome_Local 	Origin,
		Destin.Nome_Local	Destination,
		HOU.Peso_Real_HIA,
		HOU.Peso_Bruto_HIA,
		LIA.Peso_Cubado_LIA
	From  
		House_Imp_Aer	HOU
		Left Outer Join Job_Imp_Aer	JIA		on HOU.Num_Proc_HIA = JIA.Num_Proc_HIA
		Left Outer Join LLP_Imp_Aer LIA		on HOU.Num_Proc_HIA	= LIA.Num_Proc_Lia
		Left Outer Join Pessoa		Ship	on Cd_Export_HIA 	= Ship.Cd_Pes
		Left Outer Join Endereco	EndShip	on Ship.Cd_Pes		= EndShip.Cd_Pes AND EndShip.cd_tp_end='COM'
		Left Outer Join Pessoa		Consig	on Cd_Consig_HIA 	= Consig.Cd_Pes 
		Left Outer Join Endereco	EndCons	on Consig.Cd_Pes	= EndCons.Cd_Pes AND EndCons.cd_tp_end='COM'
		Left Outer Join Pessoa		Import	on Cd_Import_HIA 	= Import.Cd_Pes
		Left Outer Join Endereco	EndImp	on Import.Cd_Pes	= EndImp.Cd_Pes AND EndImp.cd_tp_end='COM'
		Left Outer Join Localidade	Orig	on Cd_Org_HIA 		= Orig.Cd_Local 
		Left Outer Join Localidade	Destin	on Cd_Dst_HIA 		= Destin.Cd_Local 
		Left Outer Join Cia_Aerea	AEREA	on JIA.Cd_Cia_Aer	= AEREA.Cd_Cia_Aer
--		Left Outer Join Pessoa		AG		on JIA.Cd_Agente	= AG.Cd_Pes
		Left Outer Join Pessoa		AG		on LIA.Cd_Forwarder	= AG.Cd_Pes
		Left Outer Join Endereco	EndAG	on AG.Cd_Pes		= EndAG.Cd_Pes AND EndAG.cd_tp_end='COM'
--		Left Outer Join Pessoa		FORW	on LIA.Cd_Forwarder	= FORW.Cd_Pes
		Left Outer Join Pessoa		FORW	on JIA.Cd_Agente	= FORW.Cd_Pes
		Left Outer Join Endereco	EndFORW	on FORW.Cd_Pes		= EndFORW.Cd_Pes AND EndFORW.cd_tp_end='COM'
		Left Outer Join Nature_Goods GD		on HOU.Num_proc_hia = GD.Num_Proc
		Left Outer Join Campo_Processo CPN	on CPN.Num_Proc		= HOU.Num_Proc_HIA and CPN.Id_Campo=33
		Left Outer Join Pessoa		NM		on NM.Cd_Pes		= CPN.Campo_Dados
		Left Outer Join Endereco	EndNM	on NM.Cd_Pes		= EndNM.Cd_Pes AND EndNM.cd_tp_end='COM'
		Left Outer Join pessoa		NotF	on NotF.cd_pes		= Endimp.cd_pes

	Where
		HOU.Num_Proc_HIA = @Processo
GO
