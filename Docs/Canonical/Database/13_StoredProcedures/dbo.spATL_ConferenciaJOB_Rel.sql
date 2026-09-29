SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[spATL_ConferenciaJOB_Rel]'GRUPO ALL','ALL','2016-05-01','2016-05-04'
CREATE procedure [dbo].[spATL_ConferenciaJOB_Rel](
	@Grupo  varchar(50),
	@BDPProduto varchar(50),
	@DtInicial	datetime,
	@DtFinal	datetime
)
as

select 
	'Export'					[Import/Export],
	V.num_proc					[JOB], 
	Nome_BDP_Produto			[BDP Produto],
	cast(V.Id_status as varchar(10))+ ' - ' + T.Status_Descricao [Status do Job], 
	--V.Master, 
	--PS.Nome_Raz_Soc, 
	--PS.Num_CPF_CNPJ,
	PG.Apelido Grupo,
	
	--C.ID,
	--C.Num_Proc,	
	--isnull(C.Vr_Cambio,0) Vr_Cambio,
	(case when C.Vr_Cambio = 0 then 'Não' else
		case when C.Vr_Cambio is NULL then NULL
		else 'Sim' end end )  [Variação Cambial],
	(case when C.Proft = 0 then 'Não'else 
		case when C.Proft is NULL then NULL
	else 'Sim' end end )  [Profit],
	
	(case when C.Prestacao = 0 then 'Não'else 
		case when C.Prestacao is NULL then NULL
	else 'Sim' end end )  [Prestacao],
	
	c.SaldoRepasse			[Saldo],
	[dbo].[fBusca_CtaCteTaxaVlr](V.num_proc,'Prestacao%','C') [Prestacao de Contas Credito],
	[dbo].[fBusca_CtaCteTaxaVlr](V.num_proc,'Prestacao%','D') [Prestacao de Contas Debito],
			
	--isnull(C.Proft,0) Proft,
	--C.Justificativa				[Justificativa],
	--C.Dt_Ins					[Data Inserção],
	--C.Cd_Usuario				[Usuario],
	isnull(c.Status,'Pendente') [Status],	
	CSR.Nome_Usuario			[Usuario CSR],
	C.dt_aproval_csr			[Data Aprovação CSR],
	C.Justificativa_csr			[Justificativa CSR],
	CHB.Nome_Usuario			[Usuario CHB],
	C.dt_aproval_chb			[Data Aprovação CHB],
	C.Justificativa_chb			[Justificativa CHB],
	Transp.Nome_Usuario			[Usuario Transportation],
	dt_aproval_transp			[Data Aprovação Transportation],
	C.Justificativa_transp		[Justificativa Transportation],
	V.ATD						[Data ATD],
	TP15.Dt_Conclusao			[Averbação],
	V.ATA						[Data ATA],
	NULL						[Docs OK-Entrega Transportador],
	TP26.Dt_Conclusao			[Envio de Docs p/ Faturamento],
	Master						[Consolidada],
	DST.Nome_Local				[Destino],
	ORG.Nome_Local				[Origem],
	PS.Apelido					[Shipper],
	CON.Apelido					[Consignee],
	[dbo].[fBusca_Docs_PO_Modal](V.num_proc,3) [Sales Order]
from vwHouse_Exp V	with(nolock)
	left join Confer_Job			C		with(nolock) on C.Num_Proc = V.num_proc
	left join Tipo_Status_Processo  T		with(nolock) on T.ID_Status = V.ID_Status	
	left join Pessoa				PS		with(nolock) on V.Cd_Export = PS.Cd_Pes
	Left Join Pessoa_LLP			PLL		with(nolock) on PS.Cd_Pes = PLL.Cd_Pes
	Left Join Grupo					G		with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
	Join pessoa						PG		with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
	left join Campo_Processo		CP		with(nolock) on V.num_proc = CP.Num_Proc and CP.Id_Campo = 143
	left join BDP_Produto			PRO		with(nolock) on CP.Campo_Dados = PRO.ID_PD
	left join Usuario				CSR		with(nolock) on CSR.Cd_Usuario = C.cd_usuario_csr
	left join Usuario				CHB		with(nolock) on CHB.Cd_Usuario = C.cd_usuario_chb
	left join Usuario				Transp  with(nolock) on Transp.Cd_Usuario = C.cd_usuario_transp
	left join Tarefas_Processos		TP15	with(nolock) on V.Num_Proc = TP15.Num_Proc and TP15.ID_Task = 15
	left join Tarefas_Processos		TP26	with(nolock) on V.Num_Proc = TP26.Num_Proc and TP26.ID_Task = 26
	left join Localidade			ORG		with(nolock) on ORG.Cd_Local  = V.Cd_Org
	left join Localidade			DST		with(nolock) on DST.Cd_Local  = V.Cd_Dst
	left join Pessoa				CON		with(nolock) on V.Cd_Consig = CON.Cd_Pes
Where
	(PG.Apelido = @Grupo or @Grupo = 'GRUPO ALL') 
	and (PRO.Nome_BDP_Produto = @BDPProduto or @BDPProduto = 'ALL')
	--and V.ATD between @DtInicial	and @DtFinal
	and convert(datetime,v.Dt_Emis,103) between @DtInicial	and @DtFinal
	
Union ALL

select 
	'Import'					[Import/Export],
	V.num_proc	[JOB], 
	Nome_BDP_Produto [BDP Produto],
	cast(V.Id_status as varchar(10))+ ' - ' + T.Status_Descricao [Status do Job], 
	--V.Master, 
	--PS.Nome_Raz_Soc, 
	--PS.Num_CPF_CNPJ,
	PG.Apelido Grupo,
	
	--C.ID,
	--C.Num_Proc,	
	--isnull(C.Vr_Cambio,0) Vr_Cambio,
	(case when C.Vr_Cambio = 0 then 'Não' else
		case when C.Vr_Cambio is NULL then NULL
		else 'Sim' end end )  [Variação Cambial],
	(case when C.Proft = 0 then 'Não'else 
		case when C.Proft is NULL then NULL
	else 'Sim' end end )  [Profit],
	
	
	(case when C.Prestacao = 0 then 'Não'else 
		case when C.Prestacao is NULL then NULL
	else 'Sim' end end )  [Prestacao],
	
	c.SaldoRepasse			[Saldo],
	[dbo].[fBusca_CtaCteTaxaVlr](V.num_proc,'Prestacao%','C') [Prestacao de Contas Credito],
	[dbo].[fBusca_CtaCteTaxaVlr](V.num_proc,'Prestacao%','D') [Prestacao de Contas Debito],
	
	--isnull(C.Proft,0) Proft,
	--C.Justificativa				[Justificativa],
	--C.Dt_Ins					[Data Inserção],
	--C.Cd_Usuario				[Usuario],
	isnull(c.Status,'Pendente') [Status],	
	CSR.Nome_Usuario			[Usuario CSR],
	C.dt_aproval_csr			[Data Aprovação CSR],
	C.Justificativa_csr			[Justificativa CSR],
	CHB.Nome_Usuario			[Usuario CHB],
	C.dt_aproval_chb			[Data Aprovação CHB],
	C.Justificativa_chb			[Justificativa CHB],
	Transp.Nome_Usuario			[Usuario Transportation],
	dt_aproval_transp			[Data Aprovação Transportation],
	C.Justificativa_transp		[Justificativa Transportation],
	V.ATD						[Data ATD],
	TP68.Dt_Conclusao			[Averbação],
	V.ATA						[Data ATA],
	TP125.Dt_Conclusao			[Docs OK-Entrega Transportador],
	TP26.Dt_Conclusao			[Envio de Docs p/ Faturamento],
	Master						[Consolidada],
	DST.Nome_Local				[Destino],
	ORG.Nome_Local				[Origem],	
	CON.Apelido					[Shipper],
	PS.Apelido					[Consignee],
	[dbo].[fBusca_Docs_PO_Modal](V.num_proc,3) [Sales Order]
from vwHouse_Imp V			with(nolock)
	left join Confer_Job C			with(nolock) on C.Num_Proc = V.num_proc
	left join Tipo_Status_Processo T with(nolock) on T.ID_Status = V.ID_Status	
	left join Pessoa PS			with(nolock) on V.Cd_Consig = PS.Cd_Pes
	Left Join Pessoa_LLP PLL	with(nolock) on PS.Cd_Pes = PLL.Cd_Pes
	Left Join Grupo G			with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
	Join pessoa PG			with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
	left join Campo_Processo CP with(nolock) on V.num_proc = CP.Num_Proc and CP.Id_Campo = 143
	left join BDP_Produto PRO	with(nolock) on CP.Campo_Dados = PRO.ID_PD
	left join Usuario CSR with(nolock) on CSR.Cd_Usuario = C.cd_usuario_csr
	left join Usuario CHB with(nolock) on CHB.Cd_Usuario = C.cd_usuario_chb
	left join Usuario Transp with(nolock) on Transp.Cd_Usuario = C.cd_usuario_transp
	left join Tarefas_Processos TP68 with(nolock) on V.Num_Proc = TP68.Num_Proc and TP68.ID_Task = 68
	left join Tarefas_Processos TP125 with(nolock) on V.Num_Proc = TP125.Num_Proc and TP125.ID_Task = 125
	left join Tarefas_Processos TP26 with(nolock) on V.Num_Proc = TP26.Num_Proc and TP26.ID_Task = 26
	left join Localidade ORG with(nolock) on ORG.Cd_Local  = V.Cd_Org
	left join Localidade DST with(nolock) on DST.Cd_Local  = V.Cd_Dst
	left join Pessoa CON		with(nolock) on V.Cd_Export = CON.Cd_Pes
Where
	(PG.Apelido = @Grupo or @Grupo = 'GRUPO ALL') 
	and (PRO.Nome_BDP_Produto = @BDPProduto or @BDPProduto = 'ALL')
	--and V.ATA between @DtInicial and @DtFinal
	and convert(datetime,v.Dt_Emis,103) between @DtInicial	and @DtFinal





GO
