SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from Job_Imp_Mar where num_proc_him = 'IMVPF201112004br'
--JIM.Cd_Agente
--select * from Campo_Processo where Id_Campo=33 and num_proc = 'IMVPF201112004br'
--select * from pessoa where cd_pes = 'P16219'
--select * from pessoa where cd_pes = 'P20631'


CREATE		PROCEDURE [dbo].[spShippingInstructionsIM_Rel] --'IMATL20100300201'

(
@Processo	VarChar(16)
)
AS

Select
		HOU.Num_Proc_HIM,
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
		right(FORW.Num_CPF_CNPJ,14)	Forw_CNPJ,
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
		right(NM.Num_CPF_CNPJ,14)NotM_CNPJ,
		EndNM.Rua			NotM_Rua,
		EndNM.Numero		NotM_Num,
		EndNM.Compl_End		NotM_Compl,
		EndNM.Bairro		NotM_Bairro,
		EndNM.CEP			NotM_CEP,
		EndNM.Cidade		NotM_Cidade,
		EndNM.UF			NotM_UF,
		EndNM.Pais			NotM_Pais,

		CttNM.Contato		NotM_Contato,
		('+' + CttNM.Cd_Int + ' ' + CttNM.Cd_Area_Fone + ' ' + CttNM.Prefixo + ' ' + CttNM.Num_Fone) NotM_Fone,
		CttNM.Compl_Fone	NotM_Email,
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
		right(Consig.Num_CPF_CNPJ,14) Cons_CNPJ,
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
		(case when Import.cd_tp_grupo = 'PEF' then
			'CPF: ' + right(Import.Num_CPF_CNPJ,14) 
			else
			'CNPJ: ' + right(Import.Num_CPF_CNPJ,14) end) Not_CNPJ,
--		right(Consig.Num_CPF_CNPJ,14) Not_CNPJ,
		EndImp.Rua			Not_Rua,
		EndImp.Numero		Not_Num,
		EndImp.Compl_End	Not_Compl,
		EndImp.Bairro		Not_Bairro,
		EndImp.CEP			Not_CEP,
		EndImp.Cidade		Not_Cidade,
		EndImp.UF			Not_UF,
		(case when Import.cd_tp_grupo = 'PEF' then
			''
		else
			EndImp.Pais	end)Not_Pais,
		
		dbo.fBusca_Docs_PO_Modal(@Processo,1) PO,
		dbo.fBusca_Docs_PO_Modal(@Processo,2) Invoce,
		dbo.fNCM(@Processo)	 NCM,
		GD.Descr			Good_Descr,
--RATE INFORMATION
		ARM.Nome_Armador	Carrier,
		Cd_Tp_Oper			Incoterm,
		Orig.Nome_Local 	Origin,
		Destin.Nome_Local	Destination,
		
		-- Alterado por Rafael Matjas - 11/06/2013 - Incluido os campos 
		
		Pload.Nome_local	PortOfLoad,
		PDischa.Nome_local	PortOfDisch

	From  
		House_Imp_Mar	HOU
		Left Outer Join Job_Imp_Mar		JIM			on HOU.Num_Proc_HIM 	= JIM.Num_Proc_HIM
		Left Outer Join LLP_Imp_Mar 	LIM			on HOU.Num_Proc_HIM		= LIM.Num_Proc_Lim
		Left Outer Join Pessoa			Ship		on Cd_Export_HIM 		= Ship.Cd_Pes
		Left Outer Join Endereco		EndShip		on Ship.Cd_Pes			= EndShip.Cd_Pes AND EndShip.cd_tp_end='COM'
		Left Outer Join Pessoa			Consig		on Cd_Consig_HIM 		= Consig.Cd_Pes 
		Left Outer Join Endereco		EndCons		on Consig.Cd_Pes		= EndCons.Cd_Pes AND EndCons.cd_tp_end='COM'
		Left Outer Join Pessoa			Import		on Cd_Import_HIM 		= Import.Cd_Pes
		Left Outer Join Endereco		EndImp		on Import.Cd_Pes		= EndImp.Cd_Pes AND EndImp.cd_tp_end='COM'

		-- Alterado por Rafael Matjas - 11/06/2013 - Incluido os campos 
		
		Left Outer Join Localidade		Orig		on Cd_planta_LIM 		= Orig.Cd_Local 
		Left Outer Join Localidade		Destin		on Cd_dstfinal_LIM 		= Destin.Cd_Local
		Left Outer Join Localidade		PLoad		on Cd_Org_HIM	 		= PLoad.Cd_Local
		Left Outer Join Localidade		PDischa		on Cd_Dst_HIM	 		= PDischa.Cd_Local
			
		Left Outer Join Armador			ARM			on JIM.Cd_Armador		= Arm.Cd_Armador
--		Left Outer Join Pessoa			AG			on JIM.Cd_Agente		= AG.Cd_Pes
		Left Outer Join Pessoa			AG			on LIM.Cd_Forwarder		= AG.Cd_Pes
		Left Outer Join Endereco		EndAG		on AG.Cd_Pes			= EndAG.Cd_Pes AND EndAG.cd_tp_end='COM'
--		Left Outer Join Pessoa			FORW		on LIM.Cd_Forwarder		= FORW.Cd_Pes
		Left Outer Join Pessoa			FORW		on JIM.Cd_Agente		= FORW.Cd_Pes
		Left Outer Join Endereco		EndFORW		on FORW.Cd_Pes			= EndFORW.Cd_Pes AND EndFORW.cd_tp_end='COM'
		Left Outer Join Nature_Goods	GD			on HOU.Num_proc_him 	= GD.Num_Proc
		Left Outer Join Campo_Processo	CPN			on CPN.Num_Proc			= HOU.Num_Proc_HIM and CPN.Id_Campo=33
		Left Outer Join Pessoa			NM			on NM.Cd_Pes			= CPN.Campo_Dados
		Left Outer Join Endereco		EndNM		on NM.Cd_Pes			= EndNM.Cd_Pes AND EndNM.cd_tp_end='COM'
		Left Outer Join Comunicacao		CttNM		on CttNM.Cd_Pes			= NM.Cd_Pes	
		Left Outer Join	Pessoa			NotF		On NotF.cd_pes			= EndImp.cd_pes and EndImp.cd_tp_end='COM'	
	Where
		HOU.Num_Proc_HIM = @Processo
GO
