SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwSOLUTIONS_BRAZIL_SINCE_2019]  
AS  
select 
	(Case When left(H.Num_Proc,1) = 'I' then 'Import' else 'Export' end)			[Import / Export],
	 BP.Nome_BDP_Produto															[BDP Product],
	 H.Modal																		[Modal],
	 H.Num_Proc																		[BDP Ref.],
	 GRP.Apelido																	[Group Name], 			
     shipper.Nome_Raz_Soc															[Shipper],
	 POrg.Nome_Pais																	[Country of Origin],
     Org.Nome_Local																	[Origin],
     Consignee.Nome_Raz_Soc															[Consignee],
	 (case 
		WHEN len(shipper.Num_CPF_CNPJ)>14 then substring(shipper.Num_CPF_CNPJ,2,2) + '.' + substring(shipper.Num_CPF_CNPJ,4,3) + '.' + substring(shipper.Num_CPF_CNPJ,7,3) + '/' + substring(shipper.Num_CPF_CNPJ,10,4) + '-' + substring(shipper.Num_CPF_CNPJ,14,2)    
		ELSE  substring(shipper.Num_CPF_CNPj,1,2) + '.' + substring(shipper.Num_CPF_CNPj,3,3) + '.' + substring(shipper.Num_CPF_CNPj,6,3) + '/' + substring(shipper.Num_CPF_CNPj,9,4) + '-' + substring(shipper.Num_CPF_CNPj,13,2)    
	 End)																			[CNPJ],
	 PDST.Nome_Pais																	[Country of Destination],
	 DST.Nome_Local																	[Destination],
	 TC.Nome_Tp_Carga																[Type of cargo],
	 dbo.fBusca_TEUS(H.Num_Proc)                									[TEUS Qtys],
	 [dbo].[Qty_Container](H.Num_Proc)												[Container Qty],
	 [dbo].[fBusca_Containers_TP] (H.Num_Proc)										[Container Type],
     H.ATD																			[ATD Date],
     H.ATA																			[ATA Date],
     h.Cd_Tp_Oper               													[Incoterm],
	(Case when H.Modal = 'Air Export' then CIA.Nome_Cia_Aer else 
        (Case when H.Modal = 'Other Export' then CiaOthers.Apelido else
            ARM.Nome_Armador end)end)												[Carrier],
     H.MAWB																			[Master],
	 H.HAWB																			[House],
	cast(dbo.fBusca_TipoDocCliente('D',H.Num_Proc,5) as datetime)					[Customs Transmission Date],
	 left(dbo.fBusca_TipoDocCliente('D',H.Num_Proc,204),500)               			[DUE Date], 
     H.Canal																		[Channel],
     TP4.Dt_Conclusao																[Customs Clearance Date],
	 TSP.Status_Descricao															[Process Status],
	 H.Master																		[Consol Ref.],
	 left(dbo.fBusca_Docs_PO_Modal(H.Num_Proc,'23'),400)							[Import License],
     left(dbo.fBusca_TipoDocCliente('N',H.Num_Proc,204),500)              			[DUE Number],
	left(dbo.fBusca_TipoDocCliente('N',H.Num_Proc,5),100) 						[Entry Number],
	 H.Vessel																		[Vessel],
     left(dbo.fBusca_Docs_PO_Modal(h.Num_Proc,9),500)								[Customer PO],
	 TP7.Dt_Conclusao 																[Transport. Doc Delivery Date]

From vwHouse_Exp H
	Join Localidade Dst with(nolock) on DST.Cd_Local=H.Cd_Dst
    left join Pais PDST with(nolock) on DST.cd_pais=PDST.cd_pais
	Join Localidade Org with(nolock) on Org.Cd_Local=H.Cd_Org
    left join Pais POrg with(nolock) on Org.cd_pais=POrg.cd_pais
	Left Join Localidade FDST with(nolock) on h.Cd_DstFinal = fdst.Cd_Local
	join Pessoa Consignee with(nolock) on Consignee.cd_pes=H.Cd_Consig
    Left Join Terminal T with(nolock) on T.cd_terminal=H.cd_terminal
    Left Join Endereco Consignee_END with(nolock) on Consignee_END.cd_pes=H.Cd_Consig and Consignee_END.cd_tp_end='COM'
	Join Pessoa Shipper with(nolock) on Shipper.cD_pes=H.cd_export
    Left Join Endereco Shipper_END with(nolock) on Shipper_END.cd_pes=H.cd_export and Shipper_END.cd_tp_end='COM'
    Left Join Tipo_Carga TC with (nolock) on TC.Cd_Tp_Carga = h.Cd_Tp_Carga   
	Left Join Tarefas_processos TP4 with(nolock) on H.Num_Proc=TP4.Num_Proc and TP4.ID_Task=4
	left join Tarefas_Processos TP7 with(nolock) on H.Num_Proc = TP7.Num_Proc and TP7.ID_Task =7    
	Left Join campo_processo CP143 with(nolock) on H.Num_Proc=CP143.Num_Proc and CP143.Id_Campo=143
	Left join BDP_Produto BP on BP.ID_PD = CP143.campo_dados
	Left join Pessoa_LLP PL with(nolock) on H.Cd_Export = PL.Cd_Pes
	Left Join Pessoa GRP with(nolock) on PL.Cd_Pes_Grupo = GRP.Cd_Pes
    Left Join Cia_Aerea CIA with(nolock) on CIA.cd_cia_Aer=H.Cd_Armador
    left Join Armador Arm with(nolock) on Arm.cd_armador=H.Cd_Armador
    Left Join Pessoa CiaOthers with(nolock) on CiaOthers.cd_pes=H.Cd_Armador
	Left Join Tipo_Status_Processo TSP  with(nolock) on TSP.id_status = H.id_status
where
	TP4.Dt_Conclusao >='2019-01-01'
	and   CP143.campo_dados in ('1','3')

UNIOn ALL
select 
	(Case When left(H.Num_Proc,1) = 'I' then 'Import' else 'Export' end)			[Import / Export],
	 BP.Nome_BDP_Produto															[BDP Product],
	 H.Modal																		[Modal],
	 H.Num_Proc																		[BDP Ref.],
	 GRP.Apelido																	[Group Name], 			
     shipper.Nome_Raz_Soc															[Shipper],
	 POrg.Nome_Pais																	[Country of Origin],
     Org.Nome_Local																	[Origin],
     Consignee.Nome_Raz_Soc															[Consignee],
	 (case 
		WHEN len(shipper.Num_CPF_CNPJ)>14 then substring(shipper.Num_CPF_CNPJ,2,2) + '.' + substring(shipper.Num_CPF_CNPJ,4,3) + '.' + substring(shipper.Num_CPF_CNPJ,7,3) + '/' + substring(shipper.Num_CPF_CNPJ,10,4) + '-' + substring(shipper.Num_CPF_CNPJ,14,2)    
		ELSE  substring(shipper.Num_CPF_CNPj,1,2) + '.' + substring(shipper.Num_CPF_CNPj,3,3) + '.' + substring(shipper.Num_CPF_CNPj,6,3) + '/' + substring(shipper.Num_CPF_CNPj,9,4) + '-' + substring(shipper.Num_CPF_CNPj,13,2)    
	 End)																			[CNPJ],
	 PDST.Nome_Pais																	[Country of Destination],
	 DST.Nome_Local																	[Destination],
	 TC.Nome_Tp_Carga																[Type of cargo],
	 dbo.fBusca_TEUS(H.Num_Proc)                									[TEUS Qtys],
	 [dbo].[Qty_Container](H.Num_Proc)												[Container Qty],
	 [dbo].[fBusca_Containers_TP] (H.Num_Proc)										[Container Type],
     H.ATD																			[ATD Date],
     H.ATA																			[ATA Date],
     h.Cd_Tp_Oper               													[Incoterm],
	(Case when H.Modal = 'Air Export' then CIA.Nome_Cia_Aer else 
        (Case when H.Modal = 'Other Export' then CiaOthers.Apelido else
            ARM.Nome_Armador end)end)												[Carrier],
     H.MAWB																			[Master],
	 H.HAWB																			[House],
	cast(dbo.fBusca_TipoDocCliente('D',H.Num_Proc,5) as datetime)					[Customs Transmission Date],
	 left(dbo.fBusca_TipoDocCliente('D',H.Num_Proc,204),500)               			[DUE Date], 
     H.Canal																		[Channel],
     TP4.Dt_Conclusao																[Customs Clearance Date],
	 TSP.Status_Descricao															[Process Status],
	 H.Master																		[Consol Ref.],
	 left(dbo.fBusca_Docs_PO_Modal(H.Num_Proc,'23'),400)							[Import License],
     left(dbo.fBusca_TipoDocCliente('N',H.Num_Proc,204),500)              			[DUE Number],
	left(dbo.fBusca_TipoDocCliente('N',H.Num_Proc,5),100) 						[Entry Number],
	 H.Vessel																		[Vessel],
     left(dbo.fBusca_Docs_PO_Modal(h.Num_Proc,9),500)								[Customer PO],
	 TP7.Dt_Conclusao 															[Transport. Doc Delivery Date]

From vwHouse_Imp H
	Join Localidade Dst with(nolock) on DST.Cd_Local=H.Cd_Dst
    left join Pais PDST with(nolock) on DST.cd_pais=PDST.cd_pais
	Join Localidade Org with(nolock) on Org.Cd_Local=H.Cd_Org
    left join Pais POrg with(nolock) on Org.cd_pais=POrg.cd_pais
	Left Join Localidade FDST with(nolock) on h.Cd_DstFinal = fdst.Cd_Local
	join Pessoa Consignee with(nolock) on Consignee.cd_pes=H.Cd_Consig
    Left Join Terminal T with(nolock) on T.cd_terminal=H.cd_terminal
    Left Join Endereco Consignee_END with(nolock) on Consignee_END.cd_pes=H.Cd_Consig and Consignee_END.cd_tp_end='COM'
	Join Pessoa Shipper with(nolock) on Shipper.cD_pes=H.cd_export
    Left Join Endereco Shipper_END with(nolock) on Shipper_END.cd_pes=H.cd_export and Shipper_END.cd_tp_end='COM'
    Left Join Tipo_Carga TC with (nolock) on TC.Cd_Tp_Carga = h.Tp_Carga   
	Left Join Tarefas_processos TP4 with(nolock) on H.Num_Proc=TP4.Num_Proc and TP4.ID_Task=4
	left join Tarefas_Processos TP7 with(nolock) on H.Num_Proc = TP7.Num_Proc and TP7.ID_Task =7    
	Left Join campo_processo CP143 with(nolock) on H.Num_Proc=CP143.Num_Proc and CP143.Id_Campo=143
	Left join BDP_Produto BP on BP.ID_PD = CP143.campo_dados
	Left join Pessoa_LLP PL with(nolock) on H.Cd_Export = PL.Cd_Pes
	Left Join Pessoa GRP with(nolock) on PL.Cd_Pes_Grupo = GRP.Cd_Pes
    Left Join Cia_Aerea CIA with(nolock) on CIA.cd_cia_Aer=H.Cd_Armador
    left Join Armador Arm with(nolock) on Arm.cd_armador=H.Cd_Armador
    Left Join Pessoa CiaOthers with(nolock) on CiaOthers.cd_pes=H.Cd_Armador
	Left Join Tipo_Status_Processo TSP  with(nolock) on TSP.id_status = H.id_status
where
	TP4.Dt_Conclusao >='2019-01-01'
	and   CP143.campo_dados in ('1','3')

GO
