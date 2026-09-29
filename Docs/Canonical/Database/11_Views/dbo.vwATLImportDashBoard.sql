SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select count(*) from [vwATLImportDashBoard]
--Cadu - 200-14960 18/09/2022 - Included "Solicitamos ainda o ajuste do critério do "Registre Date" de 12 meses para 18 meses
--, sendo necessário buscar também os processos liberados neste mesmo período, critério "Customs Clearance Date"."
--Cadu - 12/11/2022 - 12:37h retorno a antiga view
--3:10h
create view [dbo].[vwATLImportDashBoard]
as

select 
	H.Num_Proc [BDP Ref.],
	US.Nome_Usuario [Account Manager],
	TP59.Dt_Conclusao [Advanced Request Date],
	--convert(datetime,dt_pgto_rcto_hia,105) [Advancement Received Date],
	convert(datetime,dt_pgto_rcto_hia,105) [Advancement Received Credit Date],
	TP156.Dt_Conclusao [Cargo Manifest for Import Declaration - Date],
	Canal [Channel],
	US167.Nome_Usuario [CHB Collaborator],
	case 
		when CP32.Campo_Dados=1 then 'Y' 
		else 'N'
	end [CHB Y/N],
	
	case 
		WHEN len(Consignee.Num_CPF_CNPJ)>14 then substring(Consignee.Num_CPF_CNPJ,2,2) + '.' + substring(Consignee.Num_CPF_CNPJ,4,3) + '.' + substring(Consignee.Num_CPF_CNPJ,7,3) + '/' + substring(Consignee.Num_CPF_CNPJ,10,4) + '-' + substring(Consignee.Num_CPF_CNPJ,14,2)    
		ELSE  substring(Consignee.Num_CPF_CNPj,1,2) + '.' + substring(Consignee.Num_CPF_CNPj,3,3) + '.' + substring(Consignee.Num_CPF_CNPj,6,3) + '/' + substring(Consignee.Num_CPF_CNPj,9,4) + '-' + substring(Consignee.Num_CPF_CNPj,13,2)    
	End CNPJ  
	
	,
	Consignee.Nome_Raz_Soc Consignee,
	[dbo].[fBusca_Containers_TP](h.Num_Proc) [Container Type],
	tp4.Dt_Conclusao [Customs Clearance Date],
	CP186.Campo_Dados [Customs Clearance Terminal],
	DI.Data_PO [Customs Transmission Date],
	TP26.Dt_Conclusao [Docs to BDP Billing Date],
	DI.Numero_PO [Entry Number],
	TCP2.Nome_Terminal [Entry Terminal],
	ETA [ETA Date],
	TP150.Dt_Conclusao [Freight Payment and Fees - Date],
	grupo.Apelido [Group Name],
	h.HAWB [House],
	TP61.Dt_Conclusao [ICMS Exoneration Date],
	TP24.Dt_Conclusao [ICMS Payment Date],
	'Import' [Import / Export],
	TP30.Dt_Conclusao [Inspection MAPA - Date],
	Modal ,
	H.Original_ETA [Original ETA - Date],
	'F' Packing,
	left(dbo.fBusca_Docs_PO_Modal(h.Num_Proc,1),500)[PO Number],
	convert(datetime,h.Dt_Emis,105) [Register Date],
	case 
		when CP36.Campo_Dados=1 then 'Y' 
		else 'N'
	end [Urgent Y/N],
	TP7.Dt_Conclusao [Transport. Doc Delivery Date],
	Isnull(TC.Nome_Tp_Carga,'LCL') [Cargo Type],
	dst.Nome_Local [Destination],
	dbo.fBusca_HistoricoDescr_Completo(h.Num_Proc)  [Last Historic],
	[dbo].[fBusca_HistoricoDescr](h.Num_Proc,116,GETDATE())  [Last Historic Client],
	H.ATD [ATD Date],
	H.CarrierName [Carrier],
	 left(dbo.fBusca_TipoDocCliente('N',H.Num_Proc,29),50)  [CE Mercante],
	 '' [Government Agency],
	 case 
		when CP5.Campo_Dados=1 then 'Y' 
		else 'N'
	end [Necessidade de LI?],
	H.Notas [Notes],
	 case 
		when DA44.id_dc is not null  then 'Y' 
		else 'N'
	end [PDF - BL Original],
		 case 
		when DA72.id_dc is not null  then 'Y' 
		else 'N'
	end [PDF - Freight and Fees Receipt],
	H.Vessel Vessel,
	dbo.fBusca_HistoricoDescr_Completo(h.Num_Proc) [Cd_BDP Last Historic] ,
	TP21.Dt_Conclusao [BL Payment Date],
		TP15.Dt_Conclusao [Port of Entry Date],
	H.ATA [ATA Date],
	tP42.Dt_Conclusao [Container Yard Request Date],
	TP155.Dt_Conclusao [Original Docs Received - CHB - Date],
	TP110.Dt_Conclusao [Received MBL - Date],
	cast(TSP.ID_Status  as char(2)) + TSP.Status_Descricao [Process Status],
	FDST.Nome_Local [Final Destination],
	'' OrderType,
	Trucker.Nome_Raz_Soc [Inland Trucker],
	
	TP30.Dt_Conclusao [Wood Inspection - Date],
	TP163.Dt_Conclusao [Wood Inspection Selected - Date],
		TP164.Dt_Conclusao [Wood Inspection Date],
		TP5.Dt_Conclusao [Booking Confirmation Date],
		TP63.Dt_Conclusao [Docs OK to register - Date],
		TP16.Dt_Conclusao [Docs Received Date],
	H.ETD [ETD Date],
			TP109.Dt_Conclusao [Copy of Docs Received - Date],
	T.Nome_Terminal [Terminal],
	[dbo].[fBusca_ListNC](h.num_proc) [Reason Code Events],
	shipper.Nome_Raz_Soc Shipper,
	TP136.Dt_Conclusao [Discharge Conclusion - Date],
	csr.Nome_Usuario [CSR Name],
	CP191.Campo_Dados [Agricultural Batch],
	org.Pais_Local [Country of Origin],
	TP23.Dt_Conclusao [Docs to Cambio - Date],
	TP21.Dt_Conclusao [BL Released - Date],
	CP146.Campo_Dados [Delivery Address],
	CP138.Campo_Dados [Free Time],
	case 
		when DA16.id_dc is not null  then 'Y' 
		else 'N'
	end [PDF - Requerimento],
	case 
		when DA25.id_dc is not null  then 'Y' 
		else 'N'
	end [PDF - COA],
	case 
		when DA29.id_dc is not null  then 'Y' 
		else 'N'
	end [PDF - CE Mercante],
	case 
		when DA41.id_dc is not null  then 'Y' 
		else 'N'
	end [PDF - AFRMM],
	case 
		when DA20.id_dc is not null  then 'Y' 
		else 'N'
	end [PDF - BL],
	case 
		when DA6.id_dc is not null  then 'Y' 
		else 'N'
	end [PDF - CI],
	case 
		when DA5.id_dc is not null  then 'Y' 
		else 'N'
	end [PDF - DI],
	case 
		when DA40.id_dc is not null  then 'Y' 
		else 'N'
	end [PDF - ICMS],
	case 
		when DA2.id_dc is not null  then 'Y' 
		else 'N'
	end [PDF - Invoice],
	
	case 
		when DA10.id_dc is not null  then 'Y' 
		else 'N'
	end [PDF - NF],
	TP13.Dt_Conclusao [Good Receipt Date - Actual],
	TP13.Dt_Conclusao [Entrega na Planta - Date],
	TP23.Dt_Conclusao [PRE DI Date],
	TP65.Dt_Conclusao [DI Draft OK - Date - BR only],
	TP41.Dt_Conclusao [Draft Approval IMP - Date],
	TP108.Dt_Conclusao [Danfe Receipt - Date - BR only],
	TP67.Dt_Conclusao [NFE Draft - Date],
	TP25.Dt_Conclusao [AFRMM Payment Date],
	TP150.Dt_Conclusao [BL Fee Payment - Date],
	TP223.Dt_Conclusao [Loading at the Terminal - Date],
	dbo.fBusca_HistoricoDescr(h.num_proc,117,getdate())  [Ops Comments],
	TP222.Dt_Conclusao [GR Efetivo - Date],
	TP164.Dt_Conclusao [Wood Released - Date],
	left(dbo.fBusca_HistoricoDescr_Completo(h.Num_Proc),120)  [Last Historic Client.2],

	--200-14960
	--tp26.Dt_Conclusao  [Dt Envio Docs Para Faturamento],  already TP26.Dt_Conclusao [Docs to BDP Billing Date],
	tp79.Dt_Conclusao  [Dt Envio Pre-Faturamento], 
	tp233.Dt_Conclusao [Receb Ordem confirmation],
	tp249.Dt_Conclusao [BL Orig. Emitido no Destino],
	tp250.Dt_Conclusao [BL Orig. Emitido na Origem],
	dbo.fBusca_TipoDocCliente('N',H.Num_Proc,7)  [Delivery Note],
	H.MAWB [Master],
	H.Master[Ref Consignada],
	tp13.Dt_Previsao   [PO Req. Deliv.],
	--tp41.Dt_Conclusao  [Aprovação de Draft], already TP41.Dt_Conclusao [Draft Approval IMP - Date],
	tp1.Dt_Conclusao   [Envio do pré-alerta],
	tp10.Dt_Conclusao  [Saída da Planta],
	tp127.Dt_Conclusao [Recebimento de CRT]

From
	vwHouse_Imp H
	Join Localidade Dst with(nolock) on DST.Cd_Local=H.Cd_Dst
	Join Localidade Org with(nolock) on Org.Cd_Local=H.Cd_Org
	Left Join Localidade FDST with(nolock) on h.Cd_DstFinal = fdst.Cd_Local
	join Pessoa Consignee with(nolock) on Consignee.cd_pes=Cd_Consig
	Join Pessoa shipper with(nolock) on Shipper.cD_pes=cd_export 
	join Pessoa_LLP G with(nolock) on G.Cd_Pes=Cd_Consig
	join Grupo GRP with(nolock) on G.Cd_Pes_Grupo = GrP.Cd_Pes_Grupo
	join Pessoa Grupo with(nolock) on Grupo.Cd_Pes=G.Cd_Pes_Grupo
	jOIN usuario us with(nolock) on us.Cd_Usuario=Responsavel
	Left Join Tarefas_processos TP59 with(nolock) on H.Num_Proc=TP59.Num_Proc and TP59.ID_Task=59
	Left Join Tarefas_processos TP156 with(nolock) on H.Num_Proc=TP156.Num_Proc and TP156.ID_Task=156
	Left Join Tarefas_processos TP4 with(nolock) on H.Num_Proc=TP4.Num_Proc and TP4.ID_Task=4
	Left Join Tarefas_processos TP5 with(nolock) on H.Num_Proc=TP5.Num_Proc and TP5.ID_Task=5
	Left Join Tarefas_processos TP7 with(nolock) on H.Num_Proc=TP7.Num_Proc and TP7.ID_Task=7
	Left Join Tarefas_processos TP15 with(nolock) on H.Num_Proc=TP15.Num_Proc and TP15.ID_Task=15
	Left Join Tarefas_processos TP16 with(nolock) on H.Num_Proc=TP16.Num_Proc and TP16.ID_Task=16
	Left Join Tarefas_processos TP42 with(nolock) on H.Num_Proc=TP42.Num_Proc and TP42.ID_Task=42
	Left Join Tarefas_processos TP26 with(nolock) on H.Num_Proc=TP26.Num_Proc and TP26.ID_Task=26
	Left Join Tarefas_processos TP150 with(nolock) on H.Num_Proc=TP150.Num_Proc and TP150.ID_Task=150
	Left Join Tarefas_processos TP61 with(nolock) on H.Num_Proc=TP61.Num_Proc and TP61.ID_Task=61
	Left Join Tarefas_processos TP21 with(nolock) on H.Num_Proc=TP21.Num_Proc and TP21.ID_Task=21
	Left Join Tarefas_processos TP23 with(nolock) on H.Num_Proc=TP23.Num_Proc and TP23.ID_Task=23
	Left Join Tarefas_processos TP25 with(nolock) on H.Num_Proc=TP25.Num_Proc and TP25.ID_Task=25
	Left Join Tarefas_processos TP13 with(nolock) on H.Num_Proc=TP13.Num_Proc and TP13.ID_Task=13	
	Left Join Tarefas_processos TP24 with(nolock) on H.Num_Proc=TP24.Num_Proc and TP24.ID_Task=24
	Left Join Tarefas_processos TP27 with(nolock) on H.Num_Proc=TP27.Num_Proc and TP27.ID_Task=27
	Left Join Tarefas_processos TP30 with(nolock) on H.Num_Proc=TP30.Num_Proc and TP30.ID_Task=30
	Left Join Tarefas_processos TP65 with(nolock) on H.Num_Proc=TP65.Num_Proc and TP65.ID_Task=65
	Left Join Tarefas_processos TP67 with(nolock) on H.Num_Proc=TP67.Num_Proc and TP67.ID_Task=67
	Left Join Tarefas_processos TP155 with(nolock) on H.Num_Proc=TP155.Num_Proc and TP155.ID_Task=155
	Left Join Tarefas_processos TP108 with(nolock) on H.Num_Proc=TP108.Num_Proc and TP108.ID_Task=108
	Left Join Tarefas_processos TP109 with(nolock) on H.Num_Proc=TP109.Num_Proc and TP109.ID_Task=109
	Left Join Tarefas_processos TP110 with(nolock) on H.Num_Proc=TP110.Num_Proc and TP110.ID_Task=110
	Left Join Tarefas_processos TP41 with(nolock) on H.Num_Proc=TP41.Num_Proc and TP41.ID_Task=41

	Left Join Tarefas_processos TP136 with(nolock) on H.Num_Proc=TP136.Num_Proc and TP136.ID_Task=136
	Left Join Tarefas_processos TP164 with(nolock) on H.Num_Proc=TP164.Num_Proc and TP164.ID_Task=164
	Left Join Tarefas_processos TP163 with(nolock) on H.Num_Proc=TP163.Num_Proc and TP163.ID_Task=163
	Left Join Tarefas_processos TP223 with(nolock) on H.Num_Proc=TP223.Num_Proc and TP223.ID_Task=223
	Left Join Tarefas_processos TP222 with(nolock) on H.Num_Proc=TP222.Num_Proc and TP222.ID_Task=222
	Left Join Tarefas_processos TP63 with(nolock) on H.Num_Proc=TP63.Num_Proc and TP63.ID_Task=63

	Left Join Tarefas_processos TP79 with(nolock) on H.Num_Proc=TP79.Num_Proc and TP79.ID_Task=79
	Left Join Tarefas_processos TP233 with(nolock) on H.Num_Proc=TP233.Num_Proc and TP233.ID_Task=233
	Left Join Tarefas_processos TP249 with(nolock) on H.Num_Proc=TP249.Num_Proc and TP249.ID_Task=249
	Left Join Tarefas_processos TP250 with(nolock) on H.Num_Proc=TP250.Num_Proc and TP250.ID_Task=250
	Left Join Tarefas_processos TP1 with(nolock) on H.Num_Proc=TP1.Num_Proc and TP1.ID_Task=1
	Left Join Tarefas_processos TP10 with(nolock) on H.Num_Proc=TP10.Num_Proc and TP10.ID_Task=10
	Left Join Tarefas_processos TP127 with(nolock) on H.Num_Proc=TP127.Num_Proc and TP127.ID_Task=127

	Left Join vwPO_ALL  di on h.num_proc=di.num_proc and di.ID_DC=5
	Left join vwcxas CXA  on h.Num_Proc=cxa.Num_Proc_HIA  and cxa.dc_hia='C' and cd_tp_Tx in (select cd_tp_Tx from tipo_taxa with(nolock)  where CD_AX_Resultado = '900.1' and nome_tp_Tx not like 'Presta%')
	Left Join campo_processo CP167 with(nolock) on H.Num_Proc=CP167.Num_Proc and CP167.Id_Campo=167
	Left Join Usuario us167 with(nolock) on CP167.Campo_Dados =US167.Cd_Usuario
	Left Join campo_processo CP32 with(nolock) on H.Num_Proc=CP32.Num_Proc and CP32.Id_Campo=32
	Left Join campo_processo CP186 with(nolock) on H.Num_Proc=CP186.Num_Proc and CP186.Id_Campo=186
	Left Join campo_processo CP191 with(nolock) on H.Num_Proc=CP191.Num_Proc and CP191.Id_Campo=191
	Left Join campo_processo CP2 with(nolock) on H.Num_Proc=CP2.Num_Proc and CP2.Id_Campo=2
	Left Join campo_processo CP5 with(nolock) on H.Num_Proc=CP5.Num_Proc and CP5.Id_Campo=5
	Left Join campo_processo CP36 with(nolock) on H.Num_Proc=CP36.Num_Proc and CP36.Id_Campo=36
	Left Join campo_processo CP138 with(nolock) on H.Num_Proc=CP138.Num_Proc and CP138.Id_Campo=138
	Left Join campo_processo CP146 with(nolock) on H.Num_Proc=CP146.Num_Proc and CP146.Id_Campo=146
	Left Join Terminal TCP2 with(nolock) on TcP2.Cd_Terminal= CP2.Campo_Dados
	Left Join Tipo_Carga TC with (nolock) on TC.Cd_Tp_Carga = h.Tp_Carga
	Left join Doc_Anexos DA44 with(nolock) on H.num_proc=da44.Num_Proc and da44.id_dc=44
	Left join Doc_Anexos DA72 with(nolock) on H.num_proc=da72.Num_Proc and da72.id_dc=72
	Left join Doc_Anexos DA25 with(nolock) on H.num_proc=da25.Num_Proc and da25.id_dc=25
	Left join Doc_Anexos DA16 with(nolock) on H.num_proc=da16.Num_Proc and da16.id_dc=16
	Left join Doc_Anexos DA29 with(nolock) on H.num_proc=da29.Num_Proc and da29.id_dc=29
	Left join Doc_Anexos DA41 with(nolock) on H.num_proc=da41.Num_Proc and da41.id_dc=41
	Left join Doc_Anexos DA20 with(nolock) on H.num_proc=da20.Num_Proc and da20.id_dc=20
	Left join Doc_Anexos DA6 with(nolock) on H.num_proc=da6.Num_Proc and da6.id_dc=6
	Left join Doc_Anexos DA40 with(nolock) on H.num_proc=da40.Num_Proc and da40.id_dc=40
	Left join Doc_Anexos DA5 with(nolock) on H.num_proc=da5.Num_Proc and da5.id_dc=5
	Left join Doc_Anexos DA2 with(nolock) on H.num_proc=da2.Num_Proc and da2.id_dc=2
	Left join Doc_Anexos DA10 with(nolock) on H.num_proc=da10.Num_Proc and da10.id_dc=10
	Left Join Tipo_Status_Processo TsP with(nolock) on h.ID_Status=TSP.ID_Status
	Left Join Pessoa Trucker with(nolock) on H.Cd_Transportadora=Trucker.cd_pes
	Left Join Terminal T with(nolock) on H.Cd_Terminal=T.Cd_Terminal
	Join Usuario CSR with(nolock) on csr.Cd_Usuario=h.cd_usuario
where
	(
		convert(datetime,h.Dt_Emis,105) >= getdate()-545
	or
		Tp4.Dt_conclusao >= getdate()-545
	)

	--convert(datetime,h.Dt_Emis,105) >=getdate()-365
	---- Alessandra 31/06/2021 - Status 8 devem ser incluidos na busca, segundo solicitação da "Luciana Regina"
	---- E-mail assunto: "BDP Support Ticket#100-278748 with a priority of 4 - Low Assigned to Group Atlantis Development"
	----and h.ID_Status not in (9,8,7)
	and h.ID_Status not in (9,7)
	

GO
