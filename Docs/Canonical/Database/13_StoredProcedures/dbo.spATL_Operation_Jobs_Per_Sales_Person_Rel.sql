SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from report where regra like '%customer%'
--Group Name and Destination Name and Register Date between Start and End Date and BDP Produto in ("CHB","CHB + Freight Forward") and Modal
--select * from report_parametro where tipo like '%usuario%'
--spGrupoALL_Sel
--spPessoaATL_Sel"%","A","%"
--spPessoaATL_Sel '%','T','%'
--select Nome_usuario from usuario order by Nome_Usuario
CREATE Procedure [dbo].[spATL_Operation_Jobs_Per_Sales_Person_Rel]
(
	@Vendedor	varchar(50),
	@Grupo		varchar(20),
	@Pessoa		varchar(50),
	@DtInicial	datetime,
	@DtFinal	datetime
)
AS

if @Pessoa = ''
	set @Pessoa = '%' 
if @Pessoa = ' ALL'
	set @Pessoa = '%' 

select 
	convert(datetime,h.Dt_Emis,105)													[Job Create Date],
	Sales.Nome_Usuario																[Sales Person],
	H.Intl_Ref																		[Intl Reference],
	TSP.Status_Descricao															[Process Status],
	(Case When left(H.Num_Proc,1) = 'I' then 'Import' else 'Export' end)			[Import / Export],
	H.Modal																			[Modal],
	BP.Nome_BDP_Produto																[BDP Product],
    csr.Nome_Usuario																[CSR Name],
	H.Num_Proc																		[BDP Ref.],
	H.Master																		[Consol Ref.],
	GRP.Apelido																		[Group Name], 			
    H.HAWB																			[Master],
	H.MAWB																			[House],
    Org.Nome_Local																	[Origin],
	POrg.Nome_Pais																	[Country of Origin],
    shipper.Nome_Raz_Soc															[Shipper],
	PDST.Nome_Pais																	[Country of Destination],
    Consignee.Nome_Raz_Soc															[Consignee],
	(case 
		WHEN len(shipper.Num_CPF_CNPJ)>14 then substring(shipper.Num_CPF_CNPJ,2,2) + '.' + substring(shipper.Num_CPF_CNPJ,4,3) + '.' + substring(shipper.Num_CPF_CNPJ,7,3) + '/' + substring(shipper.Num_CPF_CNPJ,10,4) + '-' + substring(shipper.Num_CPF_CNPJ,14,2)    
		ELSE  substring(shipper.Num_CPF_CNPj,1,2) + '.' + substring(shipper.Num_CPF_CNPj,3,3) + '.' + substring(shipper.Num_CPF_CNPj,6,3) + '/' + substring(shipper.Num_CPF_CNPj,9,4) + '-' + substring(shipper.Num_CPF_CNPj,13,2)    
	 End)																			[CNPJ],
     H.ATD																			[ATD Date],
     H.ATA																			[ATA Date],
	 TC.Nome_Tp_Carga																[Type of cargo],
	 [dbo].[fBusca_Containers_TP] (H.Num_Proc)										[Container Type],
	 dbo.fBusca_TEUS(H.Num_Proc)                									[TEUS Qtys],
	TP208.Dt_Conclusao																[Billing Authorization Transportation 1],
	TP261.Dt_Conclusao																[Billing Authorization Transportation 2],
	TP206.Dt_Conclusao																[Billing Authorization CHB],
	TP207.Dt_Conclusao																[Billing Authorization CSR],
	TP905.Dt_Conclusao																[Registro de Profit],
	TP193.Dt_Conclusao																[Embarque sem Profit],
	TP192.Dt_Conclusao																[Embarque com Prejuizo],
	''																				[BDP Invoice Date]
From vwHouse_Exp H
	Join Localidade Dst with(nolock) on DST.Cd_Local=H.Cd_Dst
    left join Pais PDST with(nolock) on DST.cd_pais=PDST.cd_pais
	Join Localidade Org with(nolock) on Org.Cd_Local=H.Cd_Org
    left join Pais POrg with(nolock) on Org.cd_pais=POrg.cd_pais
	join Pessoa Consignee with(nolock) on Consignee.cd_pes=H.Cd_Consig
	Join Pessoa Shipper with(nolock) on Shipper.cD_pes=H.cd_export
    Left Join Tipo_Carga TC with (nolock) on TC.Cd_Tp_Carga = h.Cd_Tp_Carga
    Join Usuario CSR with(nolock) on csr.Cd_Usuario=h.cd_usuario
	Join Usuario Sales with(nolock) on Sales.Cd_Usuario=H.Cd_Vendedor
	Left Join Tarefas_processos TP208 with(nolock) on H.Num_Proc=TP208.Num_Proc and TP208.ID_Task=208
	Left Join Tarefas_processos TP261 with(nolock) on H.Num_Proc=TP261.Num_Proc and TP261.ID_Task=261
	Left Join Tarefas_processos TP206 with(nolock) on H.Num_Proc=TP206.Num_Proc and TP206.ID_Task=206
	Left Join Tarefas_processos TP207 with(nolock) on H.Num_Proc=TP207.Num_Proc and TP207.ID_Task=207
	Left Join Tarefas_processos TP905 with(nolock) on H.Num_Proc=TP905.Num_Proc and TP905.ID_Task=905
	Left Join Tarefas_processos TP193 with(nolock) on H.Num_Proc=TP193.Num_Proc and TP193.ID_Task=193
	Left Join Tarefas_processos TP192 with(nolock) on H.Num_Proc=TP192.Num_Proc and TP192.ID_Task=192
	Left Join campo_processo CP143 with(nolock) on H.Num_Proc=CP143.Num_Proc and CP143.Id_Campo=143
	Left join BDP_Produto BP on BP.ID_PD = CP143.campo_dados
	Left Join Tipo_Status_Processo TSP  with(nolock) on TSP.id_status = H.id_status
	Left join Pessoa_LLP PL with(nolock) on H.Cd_Export = PL.Cd_Pes
	Left Join Pessoa GRP with(nolock) on PL.Cd_Pes_Grupo = GRP.Cd_Pes
where
	convert(datetime,h.Dt_Emis,105) between @DtInicial and @DtFinal
	and Sales.Nome_Usuario like '%' + @Vendedor + '%' 
	and (GRP.Apelido = @Grupo or @Grupo = 'GRUPO ALL')
	and Shipper.Apelido like @Pessoa 
	and h.ID_Status not in (9)
	--H.Num_Proc = 'EAATL202108001BR'


UNION ALL

select 
	convert(datetime,h.Dt_Emis,105)													[Job Create Date],
	Sales.Nome_Usuario																[Sales Person],
	H.Intl_Ref																		[Intl Reference],
	TSP.Status_Descricao															[Process Status],
	(Case When left(H.Num_Proc,1) = 'I' then 'Import' else 'Export' end)			[Import / Export],
	H.Modal																			[Modal],
	BP.Nome_BDP_Produto																[BDP Product],
    csr.Nome_Usuario																[CSR Name],
	H.Num_Proc																		[BDP Ref.],
	H.Master																		[Consol Ref.],
	GRP.Apelido																		[Group Name], 			
    H.HAWB																			[Master],
	H.MAWB																			[House],
    Org.Nome_Local																	[Origin],
	POrg.Nome_Pais																	[Country of Origin],
    shipper.Nome_Raz_Soc															[Shipper],
	PDST.Nome_Pais																	[Country of Destination],
    Consignee.Nome_Raz_Soc															[Consignee],
	(case 
		WHEN len(Consignee.Num_CPF_CNPJ)>14 then substring(Consignee.Num_CPF_CNPJ,2,2) + '.' + substring(Consignee.Num_CPF_CNPJ,4,3) + '.' + substring(Consignee.Num_CPF_CNPJ,7,3) + '/' + substring(Consignee.Num_CPF_CNPJ,10,4) + '-' + substring(Consignee.Num_CPF_CNPJ,14,2)    
		ELSE  substring(Consignee.Num_CPF_CNPj,1,2) + '.' + substring(Consignee.Num_CPF_CNPj,3,3) + '.' + substring(Consignee.Num_CPF_CNPj,6,3) + '/' + substring(Consignee.Num_CPF_CNPj,9,4) + '-' + substring(Consignee.Num_CPF_CNPj,13,2)    
	 End)																			[CNPJ],
     H.ATD																			[ATD Date],
     H.ATA																			[ATA Date],
	 TC.Nome_Tp_Carga																[Type of cargo],
	 [dbo].[fBusca_Containers_TP] (H.Num_Proc)										[Container Type],
	 dbo.fBusca_TEUS(H.Num_Proc)                									[TEUS Qtys],
	TP208.Dt_Conclusao																[Billing Authorization Transportation 1],
	TP261.Dt_Conclusao																[Billing Authorization Transportation 2],
	TP206.Dt_Conclusao																[Billing Authorization CHB],
	TP207.Dt_Conclusao																[Billing Authorization CSR],
	TP905.Dt_Conclusao																[Registro de Profit],
	TP193.Dt_Conclusao																[Embarque sem Profit],
	TP192.Dt_Conclusao																[Embarque com Prejuizo],
	''																				[BDP Invoice Date]
From vwHouse_Imp H
	Join Localidade Dst with(nolock) on DST.Cd_Local=H.Cd_Dst
    left join Pais PDST with(nolock) on DST.cd_pais=PDST.cd_pais
	Join Localidade Org with(nolock) on Org.Cd_Local=H.Cd_Org
    left join Pais POrg with(nolock) on Org.cd_pais=POrg.cd_pais
	Left Join Localidade FDST with(nolock) on h.Cd_DstFinal = fdst.Cd_Local
	join Pessoa Consignee with(nolock) on Consignee.cd_pes=H.Cd_Consig
	Join Pessoa Shipper with(nolock) on Shipper.cD_pes=H.cd_export
    Left Join Tipo_Carga TC with (nolock) on TC.Cd_Tp_Carga = h.Tp_Carga
    Join Usuario CSR with(nolock) on csr.Cd_Usuario=h.cd_usuario
	Join Usuario Sales with(nolock) on Sales.Cd_Usuario=H.Cd_Vendedor
	Left Join Tarefas_processos TP208 with(nolock) on H.Num_Proc=TP208.Num_Proc and TP208.ID_Task=208
	Left Join Tarefas_processos TP261 with(nolock) on H.Num_Proc=TP261.Num_Proc and TP261.ID_Task=261
	Left Join Tarefas_processos TP206 with(nolock) on H.Num_Proc=TP206.Num_Proc and TP206.ID_Task=206
	Left Join Tarefas_processos TP207 with(nolock) on H.Num_Proc=TP207.Num_Proc and TP207.ID_Task=207
	Left Join Tarefas_processos TP905 with(nolock) on H.Num_Proc=TP905.Num_Proc and TP905.ID_Task=905
	Left Join Tarefas_processos TP193 with(nolock) on H.Num_Proc=TP193.Num_Proc and TP193.ID_Task=193
	Left Join Tarefas_processos TP192 with(nolock) on H.Num_Proc=TP192.Num_Proc and TP192.ID_Task=192
	Left Join campo_processo CP143 with(nolock) on H.Num_Proc=CP143.Num_Proc and CP143.Id_Campo=143
	Left join BDP_Produto BP on BP.ID_PD = CP143.campo_dados
	Left Join Tipo_Status_Processo TSP  with(nolock) on TSP.id_status = H.id_status
	Left join Pessoa_LLP PL with(nolock) on H.Cd_Consig = PL.Cd_Pes
	Left Join Pessoa GRP with(nolock) on PL.Cd_Pes_Grupo = GRP.Cd_Pes
where
	convert(datetime,h.Dt_Emis,105) between @DtInicial and @DtFinal
	and Sales.Nome_Usuario like '%' + @Vendedor + '%' 
	and (GRP.Apelido = @Grupo or @Grupo = 'GRUPO ALL')
	and Consignee.Apelido like @Pessoa 
	and h.ID_Status not in (9)
	--H.Num_Proc = 'IAATL202110046BR'



GO
