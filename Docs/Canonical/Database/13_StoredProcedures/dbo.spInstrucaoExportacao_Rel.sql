SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--select * from house_exp_mar



--[spInstrucaoExportacao_Rel] 'EMCSR20090510201'

CREATE         Procedure [dbo].[spInstrucaoExportacao_Rel]
(
@Processo	varchar(16)
)
AS

--29/11/2011:inclusão de NoLock - Anderson Oliveira
select
	Transp.Apelido							Transportadora,
	isnull(SO.Numero_PO_HEA,P.Num_Pedido)	SalesOrder,
	SHPM.Numero_PO_HEA						Shipment,
	isnull(PO.Numero_PO_HEA,P.Num_PO)		PO,
	DN.Numero_PO_HEA						Delivery_Note,
	EXPO.Nome_raz_Soc						Export,
		EndEXP.Rua						EXP_Rua,
		EndEXP.Numero					EXP_Num,
		EndEXP.Compl_End				EXP_Compl,
		EndEXP.CEP						EXP_CEP,
		EndEXP.Bairro					EXP_Bairro,
		EndEXP.Cidade					EXP_Cidade,
		EndEXP.UF						EXP_UF,
		EndEXP.Pais						EXP_Pais,
	(ContEXP.cd_int + ContEXP.Cd_Area_Fone + ContEXP.Prefixo + ContEXP.Num_fone) EXP_fone,
	CONS.Nome_Raz_Soc						Importador,
	NTF.Nome_Raz_Soc						Notify,
		EndNTF.Rua						NTF_Rua,
		EndNTF.Numero					NTF_Num,
		EndNTF.Compl_End				NTF_Compl,
		EndNTF.CEP						NTF_CEP,
		EndNTF.Bairro					NTF_Bairro,
		EndNTF.Cidade					NTF_Cidade,
		EndNTF.UF						NTF_UF,
		EndNTF.Pais						NTF_Pais,
	(ContNTF.cd_int + ContNTF.Cd_Area_Fone + ContNTF.Prefixo + ContNTF.Num_fone) NTF_fone,
	right(PLA.cd_planta,4) + ' ' + PLA.Planta_Nome	Planta_Retirada,
	CIA.Nome_Cia_Aer						Transp_Int,
	null									BookingNumber,
	LLP.ETD_LEA								ETD,
	ORIG.Nome_Local							Origem,
	DEST.Nome_Local							Destino,
	ENTR.Nome_Raz_Soc							Local_Entrega,
		EndENTR.Rua						ENTR_Rua,
		EndENTR.Numero					ENTR_Num,
		EndENTR.Compl_End				ENTR_Compl,
		EndENTR.CEP						ENTR_CEP,
		EndENTR.Bairro					ENTR_Bairro,
		EndENTR.Cidade					ENTR_Cidade,
		EndENTR.UF						ENTR_UF,
		EndENTR.Pais					ENTR_Pais,
	(ContENTR.cd_int + ContENTR.Cd_Area_Fone + ContENTR.Prefixo + ContENTR.Num_fone) ENTR_fone,
	dbo.fNCM(HOU.Num_Proc_HEA)				NCM,
	EXPO.Num_CPF_CNPJ						CNPJ,
	dbo.FNATOP(@Processo)					NATOP,
	HOU.Vol_Tot_HEA							Volume,
	HOU.Obs_HEA								OBS,
	null									Navio,
	null									DL_Draft,
	null									DL_Cargo,
	null									Local_Vazios,
	null									Local_Cheios,
	'EA'									Modal,
	Agente.Apelido							Agente,
	Term.Nome_Terminal						Terminal
from 
	House_Exp_Aer			HOU		with (nolock) 
	Join LLP_Exp_Aer		LLP		with (nolock) on HOU.Num_Proc_HEA		=LLP.Num_Proc_LEA
	Left Join PO_HEA		SHPM	with (nolock) on HOU.Num_Proc_HEA 	=SHPM.Num_Proc_HEA and SHPM.ID_DC = 8
	Left Join PO_HEA		SO		with (nolock)  on HOU.Num_Proc_HEA 	=SO.Num_Proc_HEA and SO.ID_DC = 3
	Left Join PO_HEA		PO		with (nolock)  on HOU.Num_Proc_HEA 	=PO.Num_Proc_HEA and PO.ID_DC = 1
	Left Join PO_HEA		DN		with (nolock)  on HOU.Num_Proc_HEA 	=DN.Num_Proc_HEA and DN.ID_DC = 7
	Left Join Pessoa		EXPO	with (nolock)  on EXPO.cd_pes			=HOU.cd_Export_hea
	Left Join Endereco		EndEXP	with (nolock)  on EndEXP.cd_pes 		=EXPO.Cd_Pes and EndEXP.cd_tp_end = 'COM'
	Left Join Comunicacao	ContEXP with (nolock)  on ContEXP.cd_pes		=EXPO.cd_pes and ContEXP.cd_tp_com = 'TC1'
	Left Join Pessoa		CONS	with (nolock)  on CONS.cd_pes			=HOU.cd_consig_HEA
	Left Join Pessoa		NTF		with (nolock)  on NTF.cd_pes			=HOU.cd_notify_HEA
	Left Join Endereco		EndNTF	with (nolock)  on EndNTF.cd_pes 		=NTF.Cd_Pes and EndNTF.cd_tp_end = 'COM'
	Left Join Comunicacao	ContNTF with (nolock)  on ContNTF.cd_pes		=NTF.cd_pes and ContNTF.cd_tp_com = 'TC1'
	Left Join Localidade	ORIG	with (nolock)  on HOU.Cd_Org_HEA		=ORIG.Cd_Local
	Left Join Localidade	DEST	with (nolock)  on HOU.cd_dst_HEA		=DEST.Cd_Local
	Left Join Cia_Aerea		CIA		with (nolock)  on LLP.Cd_CiaAerea_LEA	=CIA.Cd_Cia_Aer
	Left Join Pedido_Ship	PS		with (nolock)  on HOU.Num_Proc_HEA		=PS.Num_Proc and convert(int,PS.Item) = 1
	Left Join Pedido		P		with (nolock)  on PS.Cd_Pedido			=P.Cd_Pedido
	Left Join Pessoa		Transp	with (nolock)  on Transp.cd_pes		=LLP.cd_Transportadora
	Left Join Pessoa_LLP	PLA		with (nolock)  on HOU.cd_export_HEA	=PLA.cd_pes
	Left Join Pessoa		ENTR	with (nolock)  on ENTR.cd_pes			=LLP.cd_notify_2
	Left Join Endereco		EndENTR	with (nolock)  on EndENTR.cd_pes 		=ENTR.Cd_Pes and EndENTR.cd_tp_end = 'COM'
	Left Join Comunicacao	ContENTR with (nolock)  on ContENTR.cd_pes		=ENTR.cd_pes and ContENTR.cd_tp_com = 'TC1'
	Left Join Job_Exp_Aer	JOB		with (nolock)  on JOB.Num_Proc_HEA		=HOU.Num_Proc_HEA
	Left Join Pessoa		Agente with (nolock)  on JOB.cd_agente	= Agente.cd_pes
	Left Join Terminal		Term	with (nolock)  on LLP.cd_terminal = term.cd_terminal
Where
	HOU.Num_Proc_HEA = @Processo

Union All

select
	Transp.Apelido							Transportadora,
	isnull(SO.Numero_PO_HEM,P.Num_Pedido)	SalesOrder,
	SHPM.Numero_PO_HEM						Shipment,
	isnull(PO.Numero_PO_HEM,P.Num_PO)		PO,
	DN.Numero_PO_HEM						Delivery_Note,
	EXPO.Nome_raz_Soc						Export,
		EndEXP.Rua						EXP_Rua,
		EndEXP.Numero					EXP_Num,
		EndEXP.Compl_End				EXP_Compl,
		EndEXP.CEP						EXP_CEP,
		EndEXP.Bairro					EXP_Bairro,
		EndEXP.Cidade					EXP_Cidade,
		EndEXP.UF						EXP_UF,
		EndEXP.Pais						EXP_Pais,
	(ContEXP.cd_int + ContEXP.Cd_Area_Fone + ContEXP.Prefixo + ContEXP.Num_fone) EXP_fone,
	CONS.Nome_Raz_Soc						Importador,
	NTF.Nome_Raz_Soc						Notify,
		EndNTF.Rua						NTF_Rua,
		EndNTF.Numero					NTF_Num,
		EndNTF.Compl_End				NTF_Compl,
		EndNTF.CEP						NTF_CEP,
		EndNTF.Bairro					NTF_Bairro,
		EndNTF.Cidade					NTF_Cidade,
		EndNTF.UF						NTF_UF,
		EndNTF.Pais						NTF_Pais,
	(ContNTF.cd_int + ContNTF.Cd_Area_Fone + ContNTF.Prefixo + ContNTF.Num_fone) NTF_fone,
	right(PLA.cd_planta,4) + ' ' + PLA.Planta_Nome Planta_Retirada,
	ARM.Nome_Armador						Transp_Int,
	JOB.Nr_Reserva							BookingNumber,
	LLP.ETD_LEM								ETD,
	ORIG.Nome_Local							Origem,
	DEST.Nome_Local							Destino,
	ENTR.Nome_Raz_Soc							Local_Entrega,
		EndENTR.Rua						ENTR_Rua,
		EndENTR.Numero					ENTR_Num,
		EndENTR.Compl_End				ENTR_Compl,
		EndENTR.CEP						ENTR_CEP,
		EndENTR.Bairro					ENTR_Bairro,
		EndENTR.Cidade					ENTR_Cidade,
		EndENTR.UF						ENTR_UF,
		EndENTR.Pais					ENTR_Pais,
	(ContENTR.cd_int + ContENTR.Cd_Area_Fone + ContENTR.Prefixo + ContENTR.Num_fone) ENTR_fone,
	dbo.fNCM(HOU.Num_Proc_HEM)				NCM,
	EXPO.Num_CPF_CNPJ						CNPJ,
	dbo.FNATOP(@Processo)					NATOP,
	HOU.Vol_Tot_HEM							Volume,
	HOU.Obs_HEM								OBS,
	HOU.Navio_HEM							Navio,
	LLP.DL_Draft_LEM						DL_Draft,
	LLP.DL_Cargo_LEM						DL_Cargo,
	RVAZ.Apelido							Local_Vazios,
	ECHEIO.Apelido							Local_Cheios,
	'EM'									Modal,
	Agente.Apelido							Agente,
	Term.Nome_Terminal						Terminal

from 
	House_Exp_Mar			HOU
	Join LLP_Exp_Mar		LLP		with (nolock)  on HOU.Num_Proc_HEM		=LLP.Num_Proc_LEM
	Left Join PO_HEM		SHPM	with (nolock)  on HOU.Num_Proc_HEM 	=SHPM.Num_Proc_HEM and SHPM.ID_DC = 8
	Left Join PO_HEM		SO		with (nolock)  on HOU.Num_Proc_HEM 	=SO.Num_Proc_HEM and SO.ID_DC = 3
	Left Join PO_HEM		PO		with (nolock)  on HOU.Num_Proc_HEM 	=PO.Num_Proc_HEM and PO.ID_DC = 1
	Left Join PO_HEM		DN		with (nolock)  on HOU.Num_Proc_HEM 	=DN.Num_Proc_HEM and DN.ID_DC = 7
	Left Join Pessoa		EXPO	with (nolock)  on EXPO.cd_pes			=HOU.cd_Export_hem
	Left Join Endereco		EndEXP	with (nolock)  on EndEXP.cd_pes 		=EXPO.Cd_Pes and EndEXP.cd_tp_end = 'COM'
	Left Join Comunicacao	ContEXP with (nolock)  on ContEXP.cd_pes		=EXPO.cd_pes and ContEXP.cd_tp_com = 'TC1'
	Left Join Pessoa		CONS	with (nolock)  on CONS.cd_pes			=HOU.cd_consig_HEM
	Left Join Pessoa		NTF		with (nolock)  on NTF.cd_pes			=HOU.cd_notify_HEM
	Left Join Endereco		EndNTF	with (nolock)  on EndNTF.cd_pes 		=NTF.Cd_Pes and EndNTF.cd_tp_end = 'COM'
	Left Join Comunicacao	ContNTF with (nolock)  on ContNTF.cd_pes		=NTF.cd_pes and ContNTF.cd_tp_com = 'TC1'
	Left Join Localidade	ORIG	with (nolock)  on HOU.Cd_Org_HEM		=ORIG.Cd_Local
	Left Join Localidade	DEST	with (nolock)  on HOU.cd_dst_HEM		=DEST.Cd_Local
	Left Join Pedido_Ship	PS		with (nolock)  on HOU.Num_Proc_HEM		=PS.Num_Proc and convert(int,PS.Item) = 1
	Left Join Pedido		P		with (nolock)  on PS.Cd_Pedido			=P.Cd_Pedido
	Left Join Pessoa		Transp	with (nolock)  on Transp.cd_pes		=LLP.cd_Transportadora
	Left Join Pessoa_LLP	PLA		with (nolock)  on HOU.cd_export_HEM	=PLA.cd_pes
	Left Join Pessoa		ENTR	with (nolock)  on ENTR.cd_pes			=LLP.cd_notify_2
--select cd_notify_2 from llp_exp_mar where num_proc_lem = 'EMCSR20090510201'
--select * from pessoa where cd_pes = 'P14725'
	Left Join Endereco		EndENTR	with (nolock)  on EndENTR.cd_pes 		=ENTR.Cd_Pes and EndENTR.cd_tp_end = 'COM'
	Left Join Comunicacao	ContENTR with (nolock)  on ContENTR.cd_pes		=ENTR.cd_pes and ContENTR.cd_tp_com = 'TC1'
	Left Join Armador 		ARM		with (nolock)  on LLP.Cd_Armador_LEM	=ARM.cd_armador
	Left Join Job_Exp_Mar	JOB		with (nolock)  on JOB.Num_Proc_HEM		=HOU.Num_Proc_HEM
	Left Join Pessoa		RVAZ	with (nolock)  on RVAZ.cd_pes			=JOB.cd_retirada_vazios
	Left Join Pessoa		ECHEIO	with (nolock)  on ECHEIO.cd_pes		=JOB.Cd_Pes_Crg
	Left Join Pessoa		Agente	with (nolock)  on JOB.cd_agente = Agente.cd_pes
	Left Join Terminal		Term	with (nolock)  on LLP.cd_terminal = term.cd_terminal
Where
	HOU.Num_Proc_HEM = @Processo

Union All

select
	Transp.Apelido							Transportadora,
	isnull(SO.Numero_PO_HEO,P.Num_Pedido)	SalesOrder,
	SHPM.Numero_PO_HEO						Shipment,
	isnull(PO.Numero_PO_HEO,P.Num_PO)		PO,
	DN.Numero_PO_HEO						Delivery_Note,
	EXPO.Nome_raz_Soc						Export,
		EndEXP.Rua						EXP_Rua,
		EndEXP.Numero					EXP_Num,
		EndEXP.Compl_End				EXP_Compl,
		EndEXP.CEP						EXP_CEP,
		EndEXP.Bairro					EXP_Bairro,
		EndEXP.Cidade					EXP_Cidade,
		EndEXP.UF						EXP_UF,
		EndEXP.Pais						EXP_Pais,
	(ContEXP.cd_int + ContEXP.Cd_Area_Fone + ContEXP.Prefixo + ContEXP.Num_fone) EXP_fone,
	CONS.Nome_Raz_Soc						Importador,
	NTF.Nome_Raz_Soc						Notify,
		EndNTF.Rua						NTF_Rua,
		EndNTF.Numero					NTF_Num,
		EndNTF.Compl_End				NTF_Compl,
		EndNTF.CEP						NTF_CEP,
		EndNTF.Bairro					NTF_Bairro,
		EndNTF.Cidade					NTF_Cidade,
		EndNTF.UF						NTF_UF,
		EndNTF.Pais						NTF_Pais,
	(ContNTF.cd_int + ContNTF.Cd_Area_Fone + ContNTF.Prefixo + ContNTF.Num_fone) NTF_fone,
	right(PLA.cd_planta,4) + ' ' + PLA.Planta_Nome Planta_Retirada,
	CARR.Apelido							Transp_Int,
	null									BookingNumber,
	LLP.ETD_LEO								ETD,
	ORIG.Nome_Local							Origem,
	DEST.Nome_Local							Destino,
	ENTR.Nome_Raz_Soc							Local_Entrega,
		EndENTR.Rua						ENTR_Rua,
		EndENTR.Numero					ENTR_Num,
		EndENTR.Compl_End				ENTR_Compl,
		EndENTR.CEP						ENTR_CEP,
		EndENTR.Bairro					ENTR_Bairro,
		EndENTR.Cidade					ENTR_Cidade,
		EndENTR.UF						ENTR_UF,
		EndENTR.Pais					ENTR_Pais,
	(ContENTR.cd_int + ContENTR.Cd_Area_Fone + ContENTR.Prefixo + ContENTR.Num_fone) ENTR_fone,
	dbo.fNCM(HOU.Num_Proc_HEO)				NCM,
	EXPO.Num_CPF_CNPJ						CNPJ,
	dbo.FNATOP(@Processo)					NATOP,
	HOU.Vol_Tot_HEO							Volume,
	HOU.Obs_HEO								OBS,
	null									Navio,
	null									DL_Draft,
	null									DL_Cargo,
	null									Local_Vazios,
	null									Local_Cheios,
	LLP.Tipo_LEO							Modal,
	Agente.Apelido							Agente,
	Term.Nome_Terminal						Terminal
	
from 
	House_Exp_Out			HOU		with (nolock) 
	Join LLP_Exp_Out		LLP		with (nolock) on HOU.Num_Proc_HEO		=LLP.Num_Proc_LEO
	Left Join PO_HEO		SHPM	with (nolock) on HOU.Num_Proc_HEO 	=SHPM.Num_Proc_HEO and SHPM.ID_DC = 8
	Left Join PO_HEO		SO		with (nolock) on HOU.Num_Proc_HEO 	=SO.Num_Proc_HEO and SO.ID_DC = 3
	Left Join PO_HEO		PO		with (nolock) on HOU.Num_Proc_HEO 	=PO.Num_Proc_HEO and PO.ID_DC = 1
	Left Join PO_HEO		DN		with (nolock) on HOU.Num_Proc_HEO 	=DN.Num_Proc_HEO and DN.ID_DC = 7
	Left Join Pessoa		EXPO	with (nolock) on EXPO.cd_pes			=HOU.cd_Export_heo
	Left Join Endereco		EndEXP	with (nolock) on EndEXP.cd_pes 		=EXPO.Cd_Pes and EndEXP.cd_tp_end = 'COM'
	Left Join Comunicacao	ContEXP with (nolock) on ContEXP.cd_pes		=EXPO.cd_pes and ContEXP.cd_tp_com = 'TC1'
	Left Join Pessoa		CONS	with (nolock) on CONS.cd_pes			=HOU.cd_consig_HEO
	Left Join Pessoa		NTF		with (nolock)  on NTF.cd_pes			=HOU.cd_notify_HEO
	Left Join Endereco		EndNTF	with (nolock)  on EndNTF.cd_pes 		=NTF.Cd_Pes and EndNTF.cd_tp_end = 'COM'
	Left Join Comunicacao	ContNTF with (nolock)  on ContNTF.cd_pes		=NTF.cd_pes and ContNTF.cd_tp_com = 'TC1'
	Left Join Localidade	ORIG	with (nolock)  on HOU.Cd_Org_HEO		=ORIG.Cd_Local
	Left Join Localidade	DEST	with (nolock)  on HOU.cd_dst_HEO		=DEST.Cd_Local
	Left Join Pedido_Ship	PS		with (nolock)  on HOU.Num_Proc_HEO		=PS.Num_Proc and convert(int,PS.Item) = 1
	Left Join Pedido		P		with (nolock)  on PS.Cd_Pedido			=P.Cd_Pedido
	Left Join Pessoa		Transp	with (nolock)  on Transp.cd_pes		=LLP.cd_Transportadora
	Left Join Pessoa_LLP	PLA		with (nolock)  on HOU.cd_export_HEO	=PLA.cd_pes
	Left Join Pessoa		ENTR	with (nolock)  on ENTR.cd_pes			=LLP.cd_notify_2
	Left Join Endereco		EndENTR	with (nolock)  on EndENTR.cd_pes 		=ENTR.Cd_Pes and EndENTR.cd_tp_end = 'COM'
	Left Join Comunicacao	ContENTR with (nolock)  on ContENTR.cd_pes		=ENTR.cd_pes and ContENTR.cd_tp_com = 'TC1'
	Left Join Pessoa		CARR	with (nolock)  on LLP.cd_carrier		=CARR.cd_pes
	Left Join Pessoa		Agente	with (nolock)  on LLP.cd_agente		=Agente.cd_pes
	Left Join Terminal		Term	with (nolock)  on LLP.cd_terminal = term.cd_terminal
Where
	HOU.Num_Proc_HEO = @Processo









GO
