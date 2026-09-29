SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spSolicitacaoLIReport_Ricardo_Rel] --[spSolicitacaoLIReport_Ricardo_Rel]'GRUPO LEVIS','2014-12-01','2014-12-10'
	
	@Grupo varchar(30),
	@DtInicial Datetime,
	@DtFinal Datetime
	
AS		
	
SET NOCOUNT ON
SET ANSI_WARNINGS OFF	
	
select 
	'IM'			[Modal],
	dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'1')[PO Number],
	dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'9') [Customer PO],
	HOU.HAWB		[House],
	HOU.num_proc	[JOB Number],
	Org.Nome_Local	[Origin],
	Nome_PAis		[Country of Origin],
	CONSIG.Apelido	[Consignee],
	DST.Nome_Local	[Destination],
	HOU.Peso_Bruto  [Gross Weight],
	HOU.Peso_Liquido[Net Weight],
	ETD [ETD - Date],
	ATD [ATD - Date], 
	ETA [ETA - Date], 
	ATA [ATA - Date],
	PC.cd_Proc_Cliente [Product ID],
	NCM [NCM Number],
	PC.Produto_Descr [Product Description],
	Nome_Tp_LI [LI Type],
	SLI.dt_solicitacao [LI Request - Date ],
	SLI.dt_li [LI - Date],
	SLI.dt_deferimento [Def. LI - Date],
	SLI.dt_Vencimento [LI Exp. - Date],
	SLI.num_li [LI Number],
	OA.Nome_Orgao_anuente [Government Agency], 
	num_requerimento [Requirement Number],
	dt_requerimento [Requirement - Date],
	Motivo [Motive],
	TP28.Dt_Conclusao [Port Entry Date],
	dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,'5') [Customs Transmission Date],
	dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'9') [Entry Number],
	HOU.Canal [Channel],
	TP4.Dt_Conclusao [Customs Clearance Date],
	dbo.fBusca_HistoricoDescr(HOU.Num_Proc,0,getdate())  [Last Historic],
	TP7.Dt_Conclusao [Docs Delivery for Transport]
from 
	vwHouse_Imp HOU With(nolock)
	INNER HASH JOIN Localidade Org					With(nolock)	on Org.cd_local=cd_org
	INNER HASH JOIN Pais							With(nolock)	on pais.cd_pais=org.cd_pais
	INNER HASH JOIN Localidade DST					With(nolock)	on DST.cd_local=cd_dst
	LEFT HASH JOIN Solicitacao_LI SLI				With(nolock)	on SLI.num_proc=hou.num_proc and SLI.num_solicitacao=(select top 1 num_solicitacao from solicitacao_li where num_proc=hou.num_proc order by 1 desc)
	LEFT HASH JOIN Tipo_LI TLI						With(nolock)	on TLI.id_tipo=sli.id_tipo_li
	LEFT HASH JOIN solicitacao_li_produto SLP		With(nolock)	on SLI.num_solicitacao=SLP.num_solicitacao
	LEFT HASH JOIN Produto_Cliente PC				With(nolock)	on SLP.Cd_Produto = PC.cd_prod
	LEFT HASH JOIN De_PAra_PRoduto DPP				With(nolock)	on DPP.GMID = PC.cd_proc_cliente
	LEFT HASH JOIN NCM								With(nolock)	on SLP.id_NCM = NCM.id_NCM
	LEFT HASH JOIN Pedido_Ship PS					With(nolock)	on SLI.Num_Proc = PS.Num_Proc and SLP.Cd_Produto =PS.cd_produto
	LEFT HASH JOIN Pedido P							With(nolock)	on PS.cd_pedido = P.Cd_Pedido
	LEFT HASH JOIN Solicitacao_LI_Orgao_Anuente OALI	With(nolock)	on OALI.Num_Solicitacao	= SLI.Num_Solicitacao
	LEFT HASH JOIN Orgao_Anuente OA					With(nolock)	on OA.ID_Orgao = OALI.ID_Orgao_anuente
	INNER HASH JOIN Pessoa CONSIG						With(nolock)	on HOU.Cd_Consig = CONSIG.Cd_Pes
	LEFT HASH JOIN	Pessoa_LLP		PLL				with(nolock)	on CONSIG.Cd_Pes = PLL.Cd_Pes
	LEFT HASH JOIN	Grupo			G				with(nolock)	on G.cd_pes_grupo = PLL.cd_pes_grupo
	LEFT HASH JOIN	pessoa			PG				with(nolock)	on PG.cd_pes = PLL.Cd_Pes_Grupo
	LEFT HASH JOIN Tarefas_Processos TP28			With(nolock)	on HOU.Num_Proc = TP28.Num_Proc and TP28.ID_Task = 28
	LEFT HASH JOIN Tarefas_Processos TP4			With(nolock)	on HOU.Num_Proc = TP4.Num_Proc and TP4.ID_Task = 4	
	LEFT HASH JOIN Tarefas_Processos TP7			With(nolock)	on HOU.Num_Proc = TP7.Num_Proc and TP7.ID_Task = 7
where
	convert(Datetime,dt_emis,105) between @DtInicial and @DtFinal  
	--substring(hou.num_proc_him,3,3) in (@Grupo)
	and (PG.Apelido = @Grupo or @Grupo = 'GRUPO ALL' or @Grupo = '')
	and HOU.ID_Status <> 9 
	and P.Cd_pedido is not null
	
	group by
	HOU.num_proc,
	HOU.Peso_Bruto,
	HOU.Peso_Liquido,
	HOU.HAWB,
	Org.Nome_Local,
	Nome_PAis,
	CONSIG.Apelido,
	DST.Nome_Local,
	ETD,
	ATD, 
	ETA, 
	ATA,
	PC.cd_Proc_Cliente,
	NCM,
	PC.Produto_Descr,
	Nome_Tp_LI,
	dt_solicitacao,
	dt_li,
	dt_deferimento,
	dt_Vencimento,
	num_li,
	OA.Nome_Orgao_anuente, 
	num_requerimento,
	dt_requerimento,
	Motivo,
	TP28.Dt_Conclusao,
	HOU.Canal,
	Tp4.Dt_Conclusao,
	TP7.Dt_Conclusao
	
	
	
		
--as
--declare @cd_pes_grupo varchar(10)
--set @cd_pes_grupo = (select top 1 cd_pes from pessoa where Desat_pes = 'N' and apelido = @Grupo)

--if @cd_pes_grupo is not NULL
--	begin
--		set @Grupo = (select grupo from grupo where cd_pes_grupo = @cd_pes_grupo)
--	end

--select 
--	'IM' Modal,
--	P.Num_PO [PO Number],
--	P.Num_Pedido [Order Reference],
--	P.Customer_PO [Customer PO],
--	HOU.HAWB_HIM [House],
--	HOU.num_proc_him [JOB Number],
--	Org.Nome_Local [Origin] ,
--	Nome_PAis [Country of Origin] ,
--	Ship.Apelido[Shipper],
--	DST.Nome_Local [Destination],
--	SUM(SLP.Peso_Bruto) [Gross Weight],
--	SUM(SLP.Peso_Liquido) [Net Weight],
--	etd_LIM [ETD - Date],
--	ATD_LIM [ATD - Date], 
--	EtA_LIM [ETA - Date], 
--	ATA_LIM [ATA - Date],
--	PC.cd_Proc_Cliente [Product ID],
--	NCM [NCM Number],
--	PC.Produto_Descr [Product Description],
--	--Value_Center_Descr [Value Center],
--	--Business_Group_Descr [Business Group],
--	Nome_Tp_LI [LI Type],
--	SLI.dt_solicitacao [LI Request - Date ],
--	SLI.dt_li [LI - Date],
--	SLI.dt_deferimento [Def. LI - Date],
--	SLI.dt_Vencimento [LI Exp. - Date],
--	SLI.num_li [LI Number],
--	OA.Nome_Orgao_anuente [Government Agency], 
--	num_requerimento [Requirement Number],
--	dt_requerimento [Requirement - Date],
--	Motivo [Motive],
--	TP28.Dt_Conclusao [Port Entry Date],
--	P5.Data_PO_HIM [Customs Transmission Date],
--	P5.Numero_PO_HIM [Entry Number],
--	LLP.Canal_Lim [Channel],
--	Tp4.Dt_Conclusao [Customs Clearance Date],
--	dbo.fBusca_HistoricoDescr(HOU.Num_Proc_HIM,0,getdate())  [Last Historic],
--	TP7.Dt_Conclusao [Docs Delivery for Transport]
--from 
--	house_imp_mar HOU With(nolock)
--	INNER HASH JOIN Localidade Org							With(nolock)	on Org.cd_local=cd_org_him
--	INNER HASH JOIN Pais									With(nolock)	on pais.cd_pais=org.cd_pais
--	INNER HASH JOIN Localidade DST							With(nolock)	on DST.cd_local=cd_dst_him
--	INNER HASH JOIN LLP_Imp_Mar LLP						With(nolock)	on llp.num_proc_lim=hou.num_proc_him
--	left HASH JOIN Solicitacao_LI SLI				With(nolock)	on SLI.num_proc=hou.num_proc_him and SLI.num_solicitacao=(select top 1 num_solicitacao from solicitacao_li where num_proc=hou.num_proc_him order by 1 desc)
--	left HASH JOIN Tipo_LI TLI						With(nolock)	on TLI.id_tipo=sli.id_tipo_li
--	left HASH JOIN solicitacao_li_produto SLP		With(nolock)	on SLI.num_solicitacao=SLP.num_solicitacao
--	left HASH JOIN Produto_Cliente PC						With(nolock)	on SLP.Cd_Produto = PC.cd_prod
--	Left HASH JOIN De_PAra_PRoduto DPP				With(nolock)	on DPP.GMID = PC.cd_proc_cliente
--	Left HASH JOIN NCM								With(nolock)	on SLP.id_NCM = NCM.id_NCM
--	left HASH JOIN Pedido_Ship PS					With(nolock)	on SLI.Num_Proc = PS.Num_Proc and SLP.Cd_Produto =PS.cd_produto
--	left HASH JOIN Pedido P							With(nolock)	on PS.cd_pedido = P.Cd_Pedido
--	left HASH JOIN Solicitacao_LI_Orgao_Anuente OALI	With(nolock)	on OALI.Num_Solicitacao	= SLI.Num_Solicitacao
--	left HASH JOIN Orgao_Anuente OA					With(nolock)	on OA.ID_Orgao = OALI.ID_Orgao_anuente
--	INNER HASH JOIN Pessoa Ship							With(nolock)	on HOU.Cd_Export_HIM = Ship.Cd_Pes
--	left HASH JOIN Tarefas_Processos TP28			With(nolock)	on HOU.Num_Proc_HIM = TP28.Num_Proc and TP28.ID_Task = 28
--	left HASH JOIN PO_HIM	P5						With(nolock)	on HOU.Num_Proc_HIM = P5.Num_Proc_HIM and P5.ID_DC = 5	
--	left HASH JOIN Tarefas_Processos TP4				With(nolock)	on HOU.Num_Proc_HIM = TP4.Num_Proc and TP4.ID_Task = 4	
--	left HASH JOIN Tarefas_Processos TP7				With(nolock)	on HOU.Num_Proc_HIM = TP7.Num_Proc and TP7.ID_Task = 7
--where 
--	substring(hou.num_proc_him,3,3) in (@Grupo)
--	and convert(Datetime,dt_emis_him,105) between @DtInicial and @DtFinal 
--	and LLP.ID_Status <> 9 
--	and P.Cd_pedido is not null
	
--	group by
--	HOU.num_proc_him,
--	P.Num_PO,
--	P.Num_Pedido,
--	P.Customer_PO,
--	HOU.HAWB_HIM,
--	Org.Nome_Local,
--	Nome_PAis,
--	Ship.Apelido,
--	DST.Nome_Local,
--	etd_LIM,
--	ATD_LIM, 
--	EtA_LIM, 
--	ATA_LIM,
--	PC.cd_Proc_Cliente,
--	NCM,
--	PC.Produto_Descr,
--	--Value_Center_Descr,
--	--Business_Group_Descr,
--	Nome_Tp_LI,
--	dt_solicitacao,
--	dt_li,
--	dt_deferimento,
--	dt_Vencimento,
--	num_li,
--	OA.Nome_Orgao_anuente, 
--	num_requerimento,
--	dt_requerimento,
--	Motivo,
--	LLP.Status_LIM,
--	TP28.Dt_Conclusao,
--	P5.Data_PO_HIM,
--	P5.Numero_PO_HIM,
--	LLP.Canal_Lim,
--	Tp4.Dt_Conclusao,
--	TP7.Dt_Conclusao
--union all

--select 
--	'IM' Modal,
--	P.Num_PO [PO Number],
--	P.Num_Pedido [Order Reference],
--	P.Customer_PO [Customer PO],
--	HOU.HAWB_HIA [House],
--	HOU.num_proc_HIA [JOB Number],
--	Org.Nome_Local [Origin] ,
--	Nome_PAis [Country of Origin] ,
--	Ship.Apelido[Shipper],
--	DST.Nome_Local [Destination],
--	SUM(SLP.Peso_Bruto) [Gross Weight],
--	SUM(SLP.Peso_Liquido) [Net Weight],
--	etd_Lia [ETD - Date],
--	ATD_Lia [ATD - Date], 
--	EtA_Lia [ETA - Date], 
--	ATA_Lia [ATA - Date],
--	PC.cd_Proc_Cliente [Product ID],
--	NCM [NCM Number],
--	PC.Produto_Descr [Product Description],
--	--Value_Center_Descr [Value Center],
--	--Business_Group_Descr [Business Group],
--	Nome_Tp_LI [LI Type],
--	SLI.dt_solicitacao [LI Request - Date ],
--	SLI.dt_li [LI - Date],
--	SLI.dt_deferimento [Def. LI - Date],
--	SLI.dt_Vencimento [LI Exp. - Date],
--	SLI.num_li [LI Number],
--	OA.Nome_Orgao_anuente [Government Agency], 
--	num_requerimento [Requirement Number],
--	dt_requerimento [Requirement - Date],
--	Motivo [Motive],
--	TP28.Dt_Conclusao [Port Entry Date],
--	P5.Data_PO_HIA [Customs Transmission Date],
--	P5.Numero_PO_HIA [Entry Number],
--	LLP.Canal_Lia [Channel],
--	Tp4.Dt_Conclusao [Customs Clearance Date],
--	dbo.fBusca_HistoricoDescr(HOU.Num_Proc_HIA,0,getdate())  [Last Historic],
--	TP7.Dt_Conclusao [Docs Delivery for Transport]
--from 
--	house_imp_aer HOU With(nolock)
--	INNER HASH JOIN Localidade Org							With(nolock)	on Org.cd_local=cd_org_HIA
--	INNER HASH JOIN Pais									With(nolock)	on pais.cd_pais=org.cd_pais
--	INNER HASH JOIN Localidade DST							With(nolock)	on DST.cd_local=cd_dst_HIA
--	INNER HASH JOIN LLP_Imp_aer LLP						With(nolock)	on llp.num_proc_Lia=hou.num_proc_HIA
--	INNER HASH JOIN Solicitacao_LI SLI						With(nolock)	on SLI.num_proc=hou.num_proc_HIA and SLI.num_solicitacao=(select top 1 num_solicitacao from solicitacao_li where num_proc=hou.num_proc_HIA order by 1 desc)
--	INNER HASH JOIN Tipo_LI TLI							With(nolock)	on TLI.id_tipo=sli.id_tipo_li
--	INNER HASH JOIN solicitacao_li_produto SLP				With(nolock)	on SLI.num_solicitacao=SLP.num_solicitacao
--	INNER HASH JOIN Produto_Cliente PC						With(nolock)	on SLP.Cd_Produto = PC.cd_prod
--	Left HASH JOIN De_PAra_PRoduto DPP				With(nolock)	on DPP.GMID = PC.cd_proc_cliente
--	Left HASH JOIN NCM								With(nolock)	on SLP.id_NCM = NCM.id_NCM
--	left HASH JOIN Pedido_Ship PS					With(nolock)	on SLI.Num_Proc = PS.Num_Proc and SLP.Cd_Produto =PS.cd_produto
--	left HASH JOIN Pedido P							With(nolock)	on PS.cd_pedido = P.Cd_Pedido
--	left HASH JOIN Solicitacao_LI_Orgao_Anuente OALI	With(nolock)	on OALI.Num_Solicitacao	= SLI.Num_Solicitacao
--	left HASH JOIN Orgao_Anuente OA					With(nolock)	on OA.ID_Orgao = OALI.ID_Orgao_anuente
--	INNER HASH JOIN Pessoa Ship							With(nolock)	on HOU.Cd_Export_HIA = Ship.Cd_Pes
--	left HASH JOIN Tarefas_Processos TP28			With(nolock)	on HOU.Num_Proc_HIA = TP28.Num_Proc and TP28.ID_Task = 28
--	left HASH JOIN PO_HIA	P5						With(nolock)	on HOU.Num_Proc_HIA = P5.Num_Proc_HIA and P5.ID_DC = 5	
--	left HASH JOIN Tarefas_Processos TP4				With(nolock)	on HOU.Num_Proc_HIA = TP4.Num_Proc and TP4.ID_Task = 4	
--	left HASH JOIN Tarefas_Processos TP7				With(nolock)	on HOU.Num_Proc_HIA = TP7.Num_Proc and TP7.ID_Task = 7
--where 
--	substring(hou.num_proc_HIA,3,3) in (@Grupo)
--	and convert(Datetime,dt_emis_HIA,105) between @DtInicial and @DtFinal 
--	and LLP.ID_Status <> 9 
--	and P.Cd_pedido is not null
	
--	group by
--	HOU.num_proc_HIA,
--	P.Num_PO,
--	P.Num_Pedido,
--	P.Customer_PO,
--	HOU.HAWB_HIA,
--	Org.Nome_Local,
--	Nome_PAis,
--	Ship.Apelido,
--	DST.Nome_Local,
--	etd_Lia,
--	ATD_Lia, 
--	EtA_Lia, 
--	ATA_Lia,
--	PC.cd_Proc_Cliente,
--	NCM,
--	PC.Produto_Descr,
--	--Value_Center_Descr,
--	--Business_Group_Descr,
--	Nome_Tp_LI,
--	dt_solicitacao,
--	dt_li,
--	dt_deferimento,
--	dt_Vencimento,
--	num_li,
--	OA.Nome_Orgao_anuente, 
--	num_requerimento,
--	dt_requerimento,
--	Motivo,
--	LLP.Status_Lia,
--	TP28.Dt_Conclusao,
--	P5.Data_PO_HIA,
--	P5.Numero_PO_HIA,
--	LLP.Canal_Lia,
--	Tp4.Dt_Conclusao,
--	TP7.Dt_Conclusao
	
--union ALL

--select 
--	'IM' Modal,
--	P.Num_PO [PO Number],
--	P.Num_Pedido [Order Reference],
--	P.Customer_PO [Customer PO],
--	HOU.HAWB_HIO [House],
--	HOU.num_proc_HIO [JOB Number],
--	Org.Nome_Local [Origin] ,
--	Nome_PAis [Country of Origin] ,
--	Ship.Apelido[Shipper],
--	DST.Nome_Local [Destination],
--	SUM(SLP.Peso_Bruto) [Gross Weight],
--	SUM(SLP.Peso_Liquido) [Net Weight],
--	etd_LIO [ETD - Date],
--	ATD_LIO [ATD - Date], 
--	EtA_LIO [ETA - Date], 
--	ATA_LIO [ATA - Date],
--	PC.cd_Proc_Cliente [Product ID],
--	NCM [NCM Number],
--	PC.Produto_Descr [Product Description],
--	--Value_Center_Descr [Value Center],
--	--Business_Group_Descr [Business Group],
--	Nome_Tp_LI [LI Type],
--	SLI.dt_solicitacao [LI Request - Date ],
--	SLI.dt_li [LI - Date],
--	SLI.dt_deferimento [Def. LI - Date],
--	SLI.dt_Vencimento [LI Exp. - Date],
--	SLI.num_li [LI Number],
--	OA.Nome_Orgao_anuente [Government Agency], 
--	num_requerimento [Requirement Number],
--	dt_requerimento [Requirement - Date],
--	Motivo [Motive],
--	TP28.Dt_Conclusao [Port Entry Date],
--	P5.Data_PO_HIO [Customs Transmission Date],
--	P5.Numero_PO_HIO [Entry Number],
--	LLP.Canal_LIO [Channel],
--	Tp4.Dt_Conclusao [Customs Clearance Date],
--	dbo.fBusca_HistoricoDescr(HOU.Num_Proc_HIO,0,getdate())  [Last Historic],
--	TP7.Dt_Conclusao [Docs Delivery for Transport]
--from 
--	house_imp_out HOU With(nolock)
--	INNER HASH JOIN Localidade Org							With(nolock)	on Org.cd_local=cd_org_HIO
--	INNER HASH JOIN Pais									With(nolock)	on pais.cd_pais=org.cd_pais
--	INNER HASH JOIN Localidade DST							With(nolock)	on DST.cd_local=cd_dst_HIO
--	INNER HASH JOIN LLP_Imp_out LLP						With(nolock)	on llp.num_proc_LIO=hou.num_proc_HIO
--	INNER HASH JOIN Solicitacao_LI SLI						With(nolock)	on SLI.num_proc=hou.num_proc_HIO and SLI.num_solicitacao=(select top 1 num_solicitacao from solicitacao_li where num_proc=hou.num_proc_HIO order by 1 desc)
--	INNER HASH JOIN Tipo_LI TLI							With(nolock)	on TLI.id_tipo=sli.id_tipo_li
--	INNER HASH JOIN solicitacao_li_produto SLP				With(nolock)	on SLI.num_solicitacao=SLP.num_solicitacao
--	INNER HASH JOIN Produto_Cliente PC						With(nolock)	on SLP.Cd_Produto = PC.cd_prod
--	Left HASH JOIN De_PAra_PRoduto DPP				With(nolock)	on DPP.GMID = PC.cd_proc_cliente
--	Left HASH JOIN NCM								With(nolock)	on SLP.id_NCM = NCM.id_NCM
--	left HASH JOIN Pedido_Ship PS					With(nolock)	on SLI.Num_Proc = PS.Num_Proc and SLP.Cd_Produto =PS.cd_produto
--	left HASH JOIN Pedido P							With(nolock)	on PS.cd_pedido = P.Cd_Pedido
--	left HASH JOIN Solicitacao_LI_Orgao_Anuente OALI	With(nolock)	on OALI.Num_Solicitacao	= SLI.Num_Solicitacao
--	left HASH JOIN Orgao_Anuente OA					With(nolock)	on OA.ID_Orgao = OALI.ID_Orgao_anuente
--	INNER HASH JOIN Pessoa Ship							With(nolock)	on HOU.Cd_Export_HIO = Ship.Cd_Pes
--	left HASH JOIN Tarefas_Processos TP28			With(nolock)	on HOU.Num_Proc_HIO = TP28.Num_Proc and TP28.ID_Task = 28
--	left HASH JOIN PO_HIO	P5						With(nolock)	on HOU.Num_Proc_HIO = P5.Num_Proc_HIO and P5.ID_DC = 5	
--	left HASH JOIN Tarefas_Processos TP4				With(nolock)	on HOU.Num_Proc_HIO = TP4.Num_Proc and TP4.ID_Task = 4	
--	left HASH JOIN Tarefas_Processos TP7				With(nolock)	on HOU.Num_Proc_HIO = TP7.Num_Proc and TP7.ID_Task = 7
--where 
--	substring(hou.num_proc_HIO,3,3) in (@Grupo)
--	and convert(Datetime,dt_emis_HIO,105) between @DtInicial and @DtFinal 
--	and LLP.ID_Status <> 9 
--	and P.Cd_pedido is not null
--	group by
--	HOU.num_proc_HIO,
--	P.Num_PO,
--	P.Num_Pedido,
--	P.Customer_PO,
--	HOU.HAWB_HIO,
--	Org.Nome_Local,
--	Nome_PAis,
--	Ship.Apelido,
--	DST.Nome_Local,
--	etd_LIO,
--	ATD_LIO, 
--	EtA_LIO, 
--	ATA_LIO,
--	PC.cd_Proc_Cliente,
--	NCM,
--	PC.Produto_Descr,
--	--Value_Center_Descr,
--	--Business_Group_Descr,
--	Nome_Tp_LI,
--	dt_solicitacao,
--	dt_li,
--	dt_deferimento,
--	dt_Vencimento,
--	num_li,
--	OA.Nome_Orgao_anuente, 
--	num_requerimento,
--	dt_requerimento,
--	Motivo,
--	LLP.Status_LIO,
--	TP28.Dt_Conclusao,
--	P5.Data_PO_HIO,
--	P5.Numero_PO_HIO,
--	LLP.Canal_LIO,
--	Tp4.Dt_Conclusao,
--	TP7.Dt_Conclusao
----OPTION(HASH HASH JOIN)
GO
