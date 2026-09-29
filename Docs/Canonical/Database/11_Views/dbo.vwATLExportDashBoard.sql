SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select count(*) from vwATLExportDashBoard
-- select * from vwATLExportDashBoard
--spRManagerv2Header_Sel
--sp_help vwHose_Exp
CREATE view [dbo].[vwATLExportDashBoard]

as

select 
	H.Num_Proc              [BDP Ref.],
    (case 
		WHEN len(shipper.Num_CPF_CNPJ)>14 then substring(shipper.Num_CPF_CNPJ,2,2) + '.' + substring(shipper.Num_CPF_CNPJ,4,3) + '.' + substring(shipper.Num_CPF_CNPJ,7,3) + '/' + substring(shipper.Num_CPF_CNPJ,10,4) + '-' + substring(shipper.Num_CPF_CNPJ,14,2)    
		ELSE  substring(shipper.Num_CPF_CNPj,1,2) + '.' + substring(shipper.Num_CPF_CNPj,3,3) + '.' + substring(shipper.Num_CPF_CNPj,6,3) + '/' + substring(shipper.Num_CPF_CNPj,9,4) + '-' + substring(shipper.Num_CPF_CNPj,13,2)    
	End)                    [CNPJ],
    csr.Nome_Usuario        [CSR Name],
    TC.Nome_Tp_Carga	    [Type of cargo],
    Org.Nome_Local		    [Origin],
    H.Modal			        [Modal],
    NULL               	    [Order Type],
    shipper.Nome_Raz_Soc	[Shipper],
    (isnull(Shipper_END.rua,' ') + isnull(Shipper_END.numero,' ') + isnull(Shipper_END.Cidade,''))  [Shipper Address],
    Consignee.Nome_Raz_Soc	[Consignee],
    (isnull(Consignee_END.rua,' ') + isnull(Consignee_END.numero,' ') + isnull(Consignee_END.Cidade,''))  [Consignee Address],
    left(dbo.fBusca_Docs_PO_Modal(h.Num_Proc,3),500) [Sales Order],
    left(dbo.fBusca_Docs_PO_Modal(h.Num_Proc,9),500) [Customer PO],
    left(dbo.fBusca_Docs_PO_Modal(h.Num_Proc,1),500) [PO Number],
    h.Cd_Tp_Oper               		[Incoterm],
    dbo.FBusca_FOB (H.num_proc,'I') [FOB - Invoice],
    H.Moeda_invoice          [Invoice Currency],
    cast(cast(H.vlr_Invoice as Decimal(18,2)) as varchar(25)) [Invoice Value],
    H.Moeda_Frete +  REPLACE(REPLACE(REPLACE(CONVERT(varchar(20),CONVERT(money,H.Frete_BL), 1),'.','?'),',','.'),'?',',')  [Freight BL],
    H.HAWB			        [Master],
    H.MAWB			        [House],
    DST.Nome_Local		    [Destination],
    PDST.Nome_Pais          [Country of Destination],
    NULL               		[Country of Final Destination],
    POrg.Nome_Pais           [Country of Origin],    
    (Case when H.Modal = 'Air Export' then CIA.Nome_Cia_Aer else 
        (Case when H.Modal = 'Other Export' then CiaOthers.Apelido else
            ARM.Nome_Armador end)end)	[Carrier],
    H.Tipo_Frete 	[Freight Type],
	H.Vessel		[Vessel],
    [dbo].[fBusca_Containers]	 (H.Num_Proc)   [Containers],
    [dbo].[fBusca_Containers_TP] (H.Num_Proc)   [Container Type],
    [dbo].[Qty_Container](H.Num_Proc)           [Container Qty],
    T.Nome_Terminal          [Terminal],
    dbo.fBusca_Docs_PO_Modal(H.Num_Proc,'10')          [NF Number],
   cast(dbo.fBusca_TipoDocCliente('D',H.Num_Proc,10) as datetime)  [NF Date],
    H.Peso_Bruto		    [Gross Weight KG],
    H.Peso_Liquido          [Net Weight KG],
    H.Canal                 [Channel],
    TP58.Dt_Conclusao       [Booking Request Date],
    TP5 .Dt_Conclusao       [Booking Confirmation Date],
    left(dbo.fBusca_TipoDocCliente('N',H.Num_Proc,204),500)              		[DUE Number],
    left(dbo.fBusca_TipoDocCliente('D',H.Num_Proc,204),500)               		[DUE Date],
    (case when DA204.id_dc is not null  then 'Y' else 'N'
	end)					[PDF - DUE],
    H.ATA				    [ATA Date],
	H.ETD					[ETD Date],
    H.ATD				    [ATD Date],
   TP4.Dt_Conclusao         [Customs Clearance Date],
   TP15.Dt_Conclusao        [Averbacao EXP - Date],
   TP26.Dt_Conclusao      	[Docs to BDP Billing Date],
    V.Apelido               [Partner],
    (case when CP32.Campo_Dados=1 then 'Y' else 'N'
	end)                     [CHB Y/N],
    cast((dbo.fBusca_TipoDocCliente('D',H.Num_Proc,3)) as datetime)   [Order Date],
    TP66.Dt_Conclusao        		[Draft EXP - Date],
    h.Cut_Date               		[Dead at Terminal - Date],  
    H.Dead_line             		[Dead Line Draft - DT],
   convert(Datetime,cp115.campo_dados,103)    [Dead Line Transf - Date],
    convert(Datetime,cp130.campo_dados,103)   [DeadLine Loading Date],
    TP12.Dt_Conclusao              		[Doc Sent - Date],
	TP161.Dt_Conclusao               	[Terminal Container Delivery - Date],
	NULL               		[Plant ID],
	GRP.Apelido             [Group Name],
	dbo.fBusca_TEUS(H.Num_Proc)                		[TEUS Qtys],
	TP1.Dt_Conclusao               		[Pre-Alert Sending - Date],
	TP189.Dt_Conclusao            		[Port Entry Date],
	-- month(TP4.Dt_Conclusao)              [Month of Clearance],
	DATENAME(M,TP4.Dt_Conclusao)        [Month of Clearance],
	h.Cut_Date              			[Cut off - DT],
    H.Booking_Number                    [Booking Number],
    dbo.fBusca_HistoricoDescr(H.Num_proc,117,getdate()) [Ops Comments],


	--Leandro

	tsla.Nome_tp_SLA																							[Responsability],
	CP130.Dt_Ins																								[Loading - Date],
	H.ETD																										[Original ETD],
	Reg.Nome_Regiao																								[Region of Origin],
	ETA																											[ETA Date],
	H.Original_ETA																								[Original ETA - Date],
	[dbo].[fBusca_Caixa_Data](h.Num_Proc, 'Prestacao de Contas%','D')											[Advancement Received Debit Date],
	[dbo].[fBusca_Caixa_Data](h.Num_Proc, 'Prestacao de Conta%','C')											[Advancement Received Credit Date],
	--[BDP Invoice Date],
	H.PO_Req_Date																								[GR Atual - Date],
	[dbo].[fBusca_Hist_Geral_Sistema_UltimaAtualizacao](H.Num_Proc,134)											[Message - KPI],
	convert(datetime,h.Dt_Emis,105)																				[Register Date],
	cast(TSP.ID_Status  as char(2)) + TSP.Status_Descricao														[Process Status],
	TP50.Dt_Conclusao																							[Order Received - Date],
	Agente.Apelido																								[Agent],
	dbo.fBusca_TipoDocCliente('D',H.Num_Proc,8)																	[Shipment Date],
	dbo.fBusca_Docs_PO_Modal(H.Num_Proc,8)																		[Shipment Number],
	dbo.fBusca_Docs_PO_Modal(H.Num_Proc,47)																		[Shipment Instructions],
	TP91.Dt_Conclusao																							[Deferimento - Date],
	TP89.Dt_Conclusao																							[Envio Docs Brasilia - Date],
	TP206.Dt_Conclusao																							[Billing Authorization CHB - Date],
	TP207.Dt_Conclusao																							[Billing Authorization CSR - Date],
	TP208.Dt_Conclusao																							[Billing Authorization Transpor - Date],
	TP261.Dt_Conclusao																							[Billing Authorization Transpo2 - Date],
	TP100.Dt_Conclusao																							[Truck Loading Confirmed - Date],
	TP10.Dt_Conclusao																							[Plant Exit Date - Actual],
	TP107.Dt_Conclusao																							[Arrival at the border - Date],
	TP253.Dt_Conclusao																							[Fronteira Destino],
	TP254.Dt_Conclusao																							[Liberação Fronteira Destino],
	TP14.Dt_Conclusao																							[Invoice Sent Date],
	TP264.Dt_Conclusao																							[Doc. Sent],
	[dbo].[fBusca_Data_vwFaturasValidas](H.Num_Proc)															[BDP Invoice Date]


From vwHouse_Exp H
	Left Join Localidade Dst with(nolock) on DST.Cd_Local=H.Cd_Dst
    left join Pais PDST with(nolock) on DST.cd_pais=PDST.cd_pais
	Left Join Localidade Org with(nolock) on Org.Cd_Local=H.Cd_Org
	Left Join Regiao Reg with(nolock) on Org.Cd_Regiao=Reg.Cd_Regiao
    left join Pais POrg with(nolock) on Org.cd_pais=POrg.cd_pais
	Left Join Localidade FDST with(nolock) on h.Cd_DstFinal = fdst.Cd_Local
	Left join Pessoa Consignee with(nolock) on Consignee.cd_pes=H.Cd_Consig
    Left Join Terminal T with(nolock) on T.cd_terminal=H.cd_terminal
    Left Join Endereco Consignee_END with(nolock) on Consignee_END.cd_pes=H.Cd_Consig and Consignee_END.cd_tp_end='COM'
	Left Join Pessoa Shipper with(nolock) on Shipper.cD_pes=H.cd_export
    Left Join Endereco Shipper_END with(nolock) on Shipper_END.cd_pes=H.cd_export and Shipper_END.cd_tp_end='COM'
    Left Join Tipo_Carga TC with (nolock) on TC.Cd_Tp_Carga = h.Cd_Tp_Carga
    Left Join campo_processo CP32 with(nolock) on H.Num_Proc=CP32.Num_Proc and CP32.Id_Campo=32
    Left Join Usuario CSR with(nolock) on csr.Cd_Usuario=h.cd_usuario
	Left Join Tarefas_processos TP58 with(nolock) on H.Num_Proc=TP58.Num_Proc and TP58.ID_Task=58
	Left Join Tarefas_processos TP5 with(nolock) on H.Num_Proc=TP5.Num_Proc and TP5.ID_Task=5
	Left join Doc_Anexos DA204 with(nolock) on H.num_proc=DA204.Num_Proc and DA204.id_dc=204
	Left Join Tarefas_processos TP4 with(nolock) on H.Num_Proc=TP4.Num_Proc and TP4.ID_Task=4
	Left Join Tarefas_processos TP15 with(nolock) on H.Num_Proc=TP15.Num_Proc and TP15.ID_Task=15
	Left Join Tarefas_processos TP26 with(nolock) on H.Num_Proc=TP26.Num_Proc and TP26.ID_Task=26
	Left Join Tarefas_processos TP66 with(nolock) on H.Num_Proc=TP66.Num_Proc and TP66.ID_Task=66
    Left Join Tarefas_processos TP161 with(nolock) on H.Num_Proc=TP161.Num_Proc and TP161.ID_Task=161
	Left Join campo_processo CP130 with(nolock) on H.Num_Proc=CP130.Num_Proc and CP130.Id_Campo=130
	Left Join campo_processo CP115 with(nolock) on H.Num_Proc=CP115.Num_Proc and CP115.Id_Campo=115
    Left Join campo_processo CP166 with(nolock) on H.Num_Proc=CP166.Num_Proc and CP166.Id_Campo=166
    Left join vwPessoa_Partner_Sel V with(nolock) on V.cd_pes = CP166.Campo_Dados
	Left Join Tarefas_processos TP12 with(nolock) on H.Num_Proc=TP12.Num_Proc and TP12.ID_Task=12
	LEFT JOIN Pedido_Ship PS  with(nolock) on PS.num_proc = H.Num_Proc
	Left join Produto_cliente PC on PC.cd_prod = PS.cd_produto
	Left join Pessoa_LLP PL with(nolock) on H.Cd_Export = PL.Cd_Pes
	Left Join Pessoa GRP with(nolock) on PL.Cd_Pes_Grupo = GRP.Cd_Pes
	Left Join Tarefas_processos TP1 with(nolock) on H.Num_Proc=TP1.Num_Proc and TP1.ID_Task=1
	Left Join Tarefas_processos TP189 with(nolock) on H.Num_Proc=TP189.Num_Proc and TP189.ID_Task=189

    Left Join Cia_Aerea CIA with(nolock) on CIA.cd_cia_Aer=H.Cd_Armador
    left Join Armador Arm with(nolock) on Arm.cd_armador=H.Cd_Armador
    Left Join Pessoa CiaOthers with(nolock) on CiaOthers.cd_pes=H.Cd_Armador    

	--Leandro
	--join Pessoa_LLP G with(nolock) on G.Cd_Pes=cd_export
	--join Grupo GRPO with(nolock) on G.Cd_Pes_Grupo = GrPO.Cd_Pes_Grupo
	--join Pessoa Grupo with(nolock) on Grupo.Cd_Pes=G.Cd_Pes_Grupo

	left join Pessoa Agente with(nolock) on Agente.Cd_Pes=H.Cd_Agente
	left join Campo_Processo CP197 with(nolock)  on CP197.Num_Proc = H.Num_Proc and CP197.Id_Campo = 197 
	left join Tipo_SLA tsla with(nolock) on tsla.ID_tp_SLA = CP197.Campo_Dados

	Left Join Tipo_Status_Processo TsP with(nolock) on h.ID_Status=TSP.ID_Status
	Left Join Tarefas_processos TP50 with(nolock) on H.Num_Proc=TP50.Num_Proc and TP50.ID_Task=50
	Left Join Tarefas_processos TP91 with(nolock) on H.Num_Proc=TP91.Num_Proc and TP91.ID_Task=91
	Left Join Tarefas_processos TP89 with(nolock) on H.Num_Proc=TP89.Num_Proc and TP89.ID_Task=89
	Left Join Tarefas_processos TP206 with(nolock) on H.Num_Proc=TP206.Num_Proc and TP206.ID_Task=206
	Left Join Tarefas_processos TP207 with(nolock) on H.Num_Proc=TP207.Num_Proc and TP207.ID_Task=207
	Left Join Tarefas_processos TP208 with(nolock) on H.Num_Proc=TP208.Num_Proc and TP208.ID_Task=208
	Left Join Tarefas_processos TP261 with(nolock) on H.Num_Proc=TP261.Num_Proc and TP261.ID_Task=261	
	Left Join Tarefas_processos TP10 with(nolock) on H.Num_Proc=TP10.Num_Proc and TP10.ID_Task=10
	Left Join Tarefas_processos TP100 with(nolock) on H.Num_Proc=TP100.Num_Proc and TP100.ID_Task=100
	Left Join Tarefas_processos TP107 with(nolock) on H.Num_Proc=TP107.Num_Proc and TP107.ID_Task=107
	Left Join Tarefas_processos TP253 with(nolock) on H.Num_Proc=TP253.Num_Proc and TP253.ID_Task=253
	Left Join Tarefas_processos TP254 with(nolock) on H.Num_Proc=TP254.Num_Proc and TP254.ID_Task=254
	Left Join Tarefas_processos TP14 with(nolock) on H.Num_Proc=TP14.Num_Proc and TP14.ID_Task=14
	Left Join Tarefas_processos TP264 with(nolock) on H.Num_Proc=TP264.Num_Proc and TP264.ID_Task=264
	   	 
where
	(
		convert(datetime,h.Dt_Emis,105) >= getdate()-545
	or
		Tp4.Dt_conclusao >= getdate()-545
	)

GO
