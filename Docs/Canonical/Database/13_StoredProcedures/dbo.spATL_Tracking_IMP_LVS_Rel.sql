SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Tracking_IMP_LVS_Rel]--[spATL_Tracking_IMP_LVS_Rel]'GRUPO LEVIS','2015-01-01','2015-01-05'
	@Grupo varchar(30),
	@DtInicial Datetime,
	@DtFinal Datetime
as
declare @cd_pes_grupo varchar(10)
set @cd_pes_grupo = (select top 1 cd_pes from pessoa where Desat_pes = 'N' and apelido = @Grupo)

if @cd_pes_grupo is not NULL
	begin
		set @Grupo = (select grupo from grupo where cd_pes_grupo = @cd_pes_grupo)
	end
--as
--Declare	@Grupo varchar(30)
--Declare	@DtInicial Datetime
--Declare @DtFinal Datetime

--Set @Grupo = 'GRUPO LEVIS'
--Set @DtInicial = '2014-01-01'
--Set @DtFinal = '2014-12-10'

--declare @cd_pes_grupo varchar(10)
--set @cd_pes_grupo = (select top 1 cd_pes from pessoa where Desat_pes = 'N' and apelido = @Grupo)

--if @cd_pes_grupo is not NULL
--	begin
--		set @Grupo = (select grupo from grupo where cd_pes_grupo = @cd_pes_grupo)
--	end sp_help Pedido_Ship

select 
P.Num_PO [PO Number],
P.Num_Pedido [Order Reference],
P.Customer_PO [Customer PO],
convert(varchar(10),PS.Qty,103) [Unit],
HOU.HAWB_HIM [House],
LLP.Num_Proc_Lim [JOB Number],
LOrg.Nome_Local [Origin],
POrg.Nome_Pais [Country of Origin],
SHP.Apelido [Shipper],
LDst.Nome_Local [Destination],
cast(CONVERT(decimal(18,3),PDet.Peso_Bruto_TOT) as varchar(50)) [Gross Weight],
cast(CONVERT(decimal(18,3),Pdet.Peso_Liquido_TOT) as varchar(50)) [Net Weight], 
cast(CONVERT(decimal(18,3),HOU.Vol_Tot_HIM) as varchar(50)) [CBM],
LLP.ETD_Lim [ETD - Date],
LLP.ATD_Lim [ATD - Date],
LLP.ETA_Lim [ETA - Date],
LLP.ATA_Lim [ATA - Date],
TM.Nome_Terminal [Terminal],
PCli.cd_Proc_Cliente [Product ID],
SUBSTRING(PDet.NCM,1,2)+ '.' + SUBSTRING(PDet.NCM,3,2)+'.'+ SUBSTRING(PDet.NCM,5,2)+'.'+ SUBSTRING(PDet.NCM,7,2) [NCM Number],
PCli.Produto_Descr [Product Description],
PDet.Qtde_Embal [Qty Packet],
TEmb.Nome_Tp_Embal [Packing Type],
TLI.Nome_Tp_LI[LI Type],
TP146.Dt_Conclusao [Email Broker],
SLI.Dt_Solicitacao [LI Request - Date ],
SLI.Dt_LI [LI - Date],
SLI.Dt_Deferimento [Def. LI - Date],
SLI.Dt_Vencimento [LI Exp. - Date],
ISNULL(SLI.Num_LI,'N/A')  [LI Number],
OA.Nome_Orgao_anuente [Government Agency], 
SLI.Num_Requerimento [Requirement Number],
SLI.Dt_Requerimento [Requirement - Date],
SLI.Motivo [Motive],
TP28.Dt_Conclusao  [Port Entry Date],
P5.Numero_PO_HIM [Entry Number],
P5.Data_PO_HIM [Customs Transmission Date],
LLP.Canal_Lim  [Channel],
Tp4.Dt_Conclusao [Customs Clearance Date],
dbo.fBusca_HistoricoDescr(LLP.Num_Proc_LIM,0,getdate()) [Last Historic],
TP7.Dt_Conclusao  [Docs Delivery for Transport],
sum(PDet.Vlr_Item)[Unit Price],
sum(PDet.Vlr_Total_Item) [Total],
P.Incoterm [Incoterm],
'SEA' [Modal],
CP31.Campo_Dados [Taxa DI],
SUM(II.Vlr_Item_Custo) [II],
SUM(PIS.Vlr_Item_Custo) [PIS],
SUM(CFI.Vlr_Item_Custo) [COFINS],
HOU.Vlr_Frete_Efet_HIM [Ocean Freight USD],
TP143.Dt_Conclusao [Danfe Request],
TP142.Dt_Conclusao [Danfe Receipt],
TP144.Dt_Conclusao [Scheduled Delivery],
TP13.Dt_Conclusao [Good Receipt Date - Actual]

from LLP_Imp_Mar LLP with(nolock)
join House_Imp_Mar HOU						with(nolock) on LLP.Num_Proc_Lim = HOU.Num_Proc_HIM
join Pedido_Ship PS							with(nolock) on LLP.Num_Proc_Lim = PS.Num_Proc
join Pedido P								with(nolock) on PS.cd_pedido = P.Cd_pedido
join Pedido_Det PDet						with(nolock) on P.Cd_pedido = PDet.Cd_Pedido and Ps.cd_produto = PDet.Cd_Produto and Ps.Item = PDet.Item and PS.Lote = PDet.Lote
left Join Volume_Imp_Mar VOL				with(nolock) on HOU.Num_Proc_HIM = VOl.Num_Proc_HIM
left join Tipo_Embalagem TEmb				with(nolock) on PDet.Cd_Tp_Embal = TEmb.Cd_Tp_Embal
join Produto_Cliente PCli					with(nolock) on PS.cd_produto = PCli.cd_prod
join Localidade LOrg						with(nolock) on HOU.Cd_Org_HIM = LOrg.Cd_Local
join Pais POrg								with(nolock) on LOrg.Cd_Pais = POrg.Cd_Pais
join Localidade LDst						with(nolock) on HOU.Cd_Dst_HIM = LDst.Cd_Local
--join Pais PDst							with(nolock) on LDst.Cd_Pais = PDst.Cd_Pais
join Pessoa SHP								with(nolock) on HOU.Cd_Export_HIM = SHP.Cd_Pes
left Join Solicitacao_LI SLI				With(nolock) on SLI.num_proc=hou.num_proc_him and SLI.num_solicitacao=(select top 1 SP.num_solicitacao from solicitacao_li SL 
join solicitacao_li_produto SP				With(nolock) on SL.num_solicitacao=SP.num_solicitacao and PS.cd_produto = SP.Cd_Produto where num_proc=hou.num_proc_him   order by 1 desc)
--join solicitacao_li_produto SLP			With(nolock) on SLI.num_solicitacao=SLP.num_solicitacao and PS.cd_produto = SLP.Cd_Produto
left Join Tipo_LI TLI						With(nolock) on TLI.id_tipo=SLI.id_tipo_li
left join Solicitacao_LI_Orgao_Anuente OALI	With(nolock) on OALI.Num_Solicitacao	= SLI.Num_Solicitacao
left join Orgao_Anuente OA					With(nolock) on OA.ID_Orgao = OALI.ID_Orgao_anuente
left join Tarefas_Processos TP28			With(nolock) on LLP.Num_Proc_LIM = TP28.Num_Proc and TP28.ID_Task = 28
left join PO_HIM	P5						With(nolock) on LLP.Num_Proc_LIM = P5.Num_Proc_HIM and P5.ID_DC = 5
left join Tarefas_Processos TP4				With(nolock) on LLP.Num_Proc_LIM = TP4.Num_Proc and TP4.ID_Task = 4	
left join Tarefas_Processos TP7				With(nolock) on LLP.Num_Proc_LIM = TP7.Num_Proc and TP7.ID_Task = 7
left join Tarefas_Processos TP142			With(nolock) on LLP.Num_Proc_LIM = TP142.Num_Proc and TP142.ID_Task = 142
left join Tarefas_Processos TP143			With(nolock) on LLP.Num_Proc_LIM = TP143.Num_Proc and TP143.ID_Task = 143
left join Tarefas_Processos TP144			With(nolock) on LLP.Num_Proc_LIM = TP144.Num_Proc and TP144.ID_Task = 144
left join Tarefas_Processos TP13			With(nolock) on LLP.Num_Proc_LIM = TP13.Num_Proc and TP13.ID_Task = 13
left join Tarefas_Processos TP146			With(nolock) on LLP.Num_Proc_LIM = TP146.Num_Proc and TP146.ID_Task = 146
left join Campo_Processo CP31				with(nolock) on LLP.Num_Proc_Lim = CP31.Num_Proc and CP31.Id_Campo= 31
left join Custo_Cliente II					with(nolock) on LLP.Num_Proc_Lim = II.Num_Proc and II.Cd_Pedido= PS.cd_pedido and II.Cd_Produto = PS.cd_produto and II.Cd_tp_tx in (select cd_tp_Tx from Tipo_Taxa where Nome_Tp_Tx like 'Imposto de Importa%')
left join Custo_Cliente PIS					with(nolock) on LLP.Num_Proc_Lim = PIS.Num_Proc and PIS.Cd_Pedido= PS.cd_pedido and PIS.Cd_Produto = PS.cd_produto and PIS.Cd_tp_tx in (select cd_tp_Tx from Tipo_Taxa where Nome_Tp_Tx like 'PIS%')
left join Custo_Cliente CFI					with(nolock) on LLP.Num_Proc_Lim = CFI.Num_Proc and CFI.Cd_Pedido= PS.cd_pedido and CFI.Cd_Produto = PS.cd_produto and CFI.Cd_tp_tx in (select cd_tp_Tx from Tipo_Taxa where Nome_Tp_Tx like 'COFINS%')
left join Custo_Cliente IC					with(nolock) on LLP.Num_Proc_Lim = IC.Num_Proc and IC.Cd_Pedido= PS.cd_pedido and IC.Cd_Produto = PS.cd_produto and IC.Cd_tp_tx in (select cd_tp_Tx from Tipo_Taxa where Nome_Tp_Tx like 'ICMS%')
left join Custo_Cliente IND					with(nolock) on LLP.Num_Proc_Lim = IND.Num_Proc and IND.Cd_Pedido= PS.cd_pedido and IND.Cd_Produto = PS.cd_produto and IND.Cd_tp_tx in (select cd_tp_Tx from Tipo_Taxa where Nome_Tp_Tx like 'Inland Freight%')
left join Terminal TM						with(nolock) on LLP.Cd_Terminal = TM.Cd_Terminal

where 	substring(LLP.num_proc_Lim,3,3) in (@Grupo)
	and
	convert(Datetime,dt_emis_Him,105) between @DtInicial and @DtFinal and LLP.ID_Status <> 9 

Group By
Pdet.Peso_Bruto_TOT,
Pdet.Peso_Liquido_TOT, 
P.Num_PO,
P.Num_Pedido,
P.Customer_PO,
HOU.HAWB_HIM,
LLP.Num_Proc_Lim,
HOU.Vol_Tot_HIM,
LOrg.Nome_Local,
POrg.Nome_Pais,
SHP.Apelido,
LDst.Nome_Local,
LLP.ETD_Lim,
LLP.ATD_Lim,
LLP.ETA_Lim,
LLP.ATA_Lim,
PCli.cd_Proc_Cliente,
PDet.NCM,
PCli.Produto_Descr,
TLI.Nome_Tp_LI,
SLI.Dt_Requerimento,
SLI.Dt_LI,
SLI.Dt_Deferimento,
SLI.Dt_Vencimento ,
ISNULL(SLI.Num_LI,'N/A'),
OA.Nome_Orgao_anuente,
SLI.Num_Requerimento,
SLI.Dt_Solicitacao,
SLI.Motivo,
TP28.Dt_Conclusao,
P5.Data_PO_HIM,
P5.Numero_PO_HIM,
LLP.Canal_Lim,
Tp4.Dt_Conclusao,
TP7.Dt_Conclusao,
P.Incoterm,
CP31.Campo_Dados,
TM.Nome_Terminal,
HOU.Vlr_Frete_Efet_HIM,
TP142.Dt_Conclusao,
TP143.Dt_Conclusao,
TP144.Dt_Conclusao,
TP13.Dt_Conclusao,
TP146.Dt_Conclusao,
PDet.Qtde_Embal,
TEmb.Nome_Tp_Embal,
PS.Qty

--UNION ALL

--select 
--P.Num_PO [PO Number],
--P.Num_Pedido [Order Reference],
--P.Customer_PO [Customer PO],
--convert(varchar(10),PS.Qty,103) [Unit],
--HOU.HAWB_HIA [House],
--LLP.Num_Proc_Lia [JOB Number],
--LOrg.Nome_Local [Origin],
--POrg.Nome_Pais [Country of Origin],
--SHP.Apelido [Shipper],
--LDst.Nome_Local [Destination],
--cast(sum(CONVERT(decimal(18,3),PDet.Peso_Bruto_TOT)) as varchar(50)) [Gross Weight],
--cast(sum(CONVERT(decimal(18,3),Pdet.Peso_Liquido_TOT)) as varchar(50)) [Net Weight],
--cast(sum(CONVERT(decimal(18,3),HOU.Vol_Tot_HIA)) as varchar(50)) [CBM],
--LLP.ETD_Lia [ETD - Date],
--LLP.ATD_Lia [ATD - Date],
--LLP.ETA_Lia [ETA - Date],
--LLP.ATA_Lia [ATA - Date],
--TM.Nome_Terminal [Terminal],
--PCli.cd_Proc_Cliente [Product ID],
--SUBSTRING(PDet.NCM,1,2)+ '.' + SUBSTRING(PDet.NCM,3,2)+'.'+ SUBSTRING(PDet.NCM,5,2)+'.'+ SUBSTRING(PDet.NCM,7,2) [NCM Number],
--PCli.Produto_Descr [Product Description],
--PDet.Qtde_Embal [Qty Packet],
--TEmb.Nome_Tp_Embal [Packing Type],
--TLI.Nome_Tp_LI[LI Type],
--TP146.Dt_Conclusao [Email Broker],
--SLI.Dt_Solicitacao [LI Request - Date ],
--SLI.Dt_LI [LI - Date],
--SLI.Dt_Deferimento [Def. LI - Date],
--SLI.Dt_Vencimento [LI Exp. - Date],
--ISNULL(SLI.Num_LI,'N/A')  [LI Number],
--OA.Nome_Orgao_anuente [Government Agency], 
--SLI.Num_Requerimento [Requirement Number],
--SLI.Dt_Requerimento [Requirement - Date],
--SLI.Motivo [Motive],
--TP28.Dt_Conclusao  [Port Entry Date],
--P5.Numero_PO_HIA [Entry Number],
--P5.Data_PO_HIA [Customs Transmission Date],
--LLP.Canal_Lia  [Channel],
--Tp4.Dt_Conclusao [Customs Clearance Date],
--dbo.fBusca_HistoricoDescr(LLP.Num_Proc_Lia,0,getdate()) [Last Historic],
--TP7.Dt_Conclusao  [Docs Delivery for Transport],
--sum(PDet.Vlr_Item)[Unit Price],
--sum(PDet.Vlr_Total_Item) [Total],
--P.Incoterm [Incoterm],
--'AIR' [Modal],
--CP31.Campo_Dados [Taxa DI],
--SUM(II.Vlr_Item_Custo) [II],
--SUM(PIS.Vlr_Item_Custo) [PIS],
--SUM(CFI.Vlr_Item_Custo) [COFINS],
--HOU.Vlr_Frete_Efet_HIA [Ocean Freight USD],
--TP143.Dt_Conclusao [Danfe Request],
--TP142.Dt_Conclusao [Danfe Receipt],
--TP144.Dt_Conclusao [Scheduled Delivery],
--TP13.Dt_Conclusao [Good Receipt Date - Actual]

--from LLP_Imp_Aer LLP with(nolock)
--join House_Imp_Aer HOU						with(nolock) on LLP.Num_Proc_Lia = HOU.Num_Proc_HIA
--join Pedido_Ship PS							with(nolock) on LLP.Num_Proc_Lia = PS.Num_Proc
--join Pedido P								with(nolock) on PS.cd_pedido = P.Cd_pedido
--join Pedido_Det PDet						with(nolock) on P.Cd_pedido = PDet.Cd_Pedido and Ps.cd_produto = PDet.Cd_Produto and Ps.Item = PDet.Item and PS.Lote = PDet.Lote
--left Join Volume_Imp_Aer VOL				with(nolock) on HOU.Num_Proc_HIA = VOl.Num_Proc_HIA
--left join Tipo_Embalagem TEmb				with(nolock) on PDet.cd_tp_embal = TEmb.Cd_Tp_Embal
--join Produto_Cliente PCli					with(nolock) on PS.cd_produto = PCli.cd_prod
--join Localidade LOrg						with(nolock) on HOU.Cd_Org_HIA = LOrg.Cd_Local
--join Pais POrg								with(nolock) on LOrg.Cd_Pais = POrg.Cd_Pais
--join Localidade LDst						with(nolock) on HOU.Cd_Dst_HIA = LDst.Cd_Local
----join Pais PDst							with(nolock) on LDst.Cd_Pais = PDst.Cd_Pais
--join Pessoa SHP								with(nolock) on HOU.Cd_Export_HIA = SHP.Cd_Pes
--left Join Solicitacao_LI SLI				With(nolock) on SLI.num_proc=hou.num_proc_HIA and SLI.num_solicitacao=(select top 1 SP.num_solicitacao from solicitacao_li SL 
--join solicitacao_li_produto SP				With(nolock) on SL.num_solicitacao=SP.num_solicitacao and PS.cd_produto = SP.Cd_Produto where num_proc=hou.num_proc_HIA   order by 1 desc)
----join solicitacao_li_produto SLP			With(nolock) on SLI.num_solicitacao=SLP.num_solicitacao and PS.cd_produto = SLP.Cd_Produto
--left Join Tipo_LI TLI						With(nolock) on TLI.id_tipo=SLI.id_tipo_li
--left join Solicitacao_LI_Orgao_Anuente OALI	With(nolock) on OALI.Num_Solicitacao	= SLI.Num_Solicitacao
--left join Orgao_Anuente OA					With(nolock) on OA.ID_Orgao = OALI.ID_Orgao_anuente
--left join Tarefas_Processos TP28			With(nolock) on LLP.Num_Proc_Lia = TP28.Num_Proc and TP28.ID_Task = 28
--left join PO_HIA	P5						With(nolock) on LLP.Num_Proc_Lia = P5.Num_Proc_HIA and P5.ID_DC = 5
--left join Tarefas_Processos TP4				With(nolock) on LLP.Num_Proc_Lia = TP4.Num_Proc and TP4.ID_Task = 4	
--left join Tarefas_Processos TP7				With(nolock) on LLP.Num_Proc_Lia = TP7.Num_Proc and TP7.ID_Task = 7
--left join Tarefas_Processos TP142			With(nolock) on LLP.Num_Proc_Lia = TP142.Num_Proc and TP142.ID_Task = 142
--left join Tarefas_Processos TP143			With(nolock) on LLP.Num_Proc_Lia = TP143.Num_Proc and TP143.ID_Task = 143
--left join Tarefas_Processos TP144			With(nolock) on LLP.Num_Proc_Lia = TP144.Num_Proc and TP144.ID_Task = 144
--left join Tarefas_Processos TP13			With(nolock) on LLP.Num_Proc_Lia = TP13.Num_Proc and TP13.ID_Task = 13
--left join Tarefas_Processos TP146			With(nolock) on LLP.Num_Proc_Lia = TP146.Num_Proc and TP146.ID_Task = 146
--left join Campo_Processo CP31				with(nolock) on LLP.Num_Proc_Lia = CP31.Num_Proc and CP31.Id_Campo= 31
--left join Custo_Cliente II					with(nolock) on LLP.Num_Proc_Lia = II.Num_Proc and II.Cd_Pedido= PS.cd_pedido and II.Cd_Produto = PS.cd_produto and II.Cd_tp_tx in (select cd_tp_Tx from Tipo_Taxa where Nome_Tp_Tx like 'Imposto de Importa%')
--left join Custo_Cliente PIS					with(nolock) on LLP.Num_Proc_Lia = PIS.Num_Proc and PIS.Cd_Pedido= PS.cd_pedido and PIS.Cd_Produto = PS.cd_produto and PIS.Cd_tp_tx in (select cd_tp_Tx from Tipo_Taxa where Nome_Tp_Tx like 'PIS%')
--left join Custo_Cliente CFI					with(nolock) on LLP.Num_Proc_Lia = CFI.Num_Proc and CFI.Cd_Pedido= PS.cd_pedido and CFI.Cd_Produto = PS.cd_produto and CFI.Cd_tp_tx in (select cd_tp_Tx from Tipo_Taxa where Nome_Tp_Tx like 'COFINS%')
--left join Custo_Cliente IC					with(nolock) on LLP.Num_Proc_Lia = IC.Num_Proc and IC.Cd_Pedido= PS.cd_pedido and IC.Cd_Produto = PS.cd_produto and IC.Cd_tp_tx in (select cd_tp_Tx from Tipo_Taxa where Nome_Tp_Tx like 'ICMS%')
--left join Custo_Cliente IND					with(nolock) on LLP.Num_Proc_Lia = IND.Num_Proc and IND.Cd_Pedido= PS.cd_pedido and IND.Cd_Produto = PS.cd_produto and IND.Cd_tp_tx in (select cd_tp_Tx from Tipo_Taxa where Nome_Tp_Tx like 'Inland Freight%')
--left join Terminal TM						with(nolock) on LLP.Cd_Terminal = TM.Cd_Terminal

--where 	substring(LLP.num_proc_Lia,3,3) in (@Grupo)
--	and
--	convert(Datetime,dt_emis_HIA,105) between @DtInicial and @DtFinal and LLP.ID_Status <> 9 

--Group By
--Pdet.Peso_Bruto_TOT,
--Pdet.Peso_Liquido_TOT, 
--P.Num_PO,
--P.Num_Pedido,
--P.Customer_PO,
--HOU.HAWB_HIA,
--LLP.Num_Proc_Lia,
--LOrg.Nome_Local,
--POrg.Nome_Pais,
--SHP.Apelido,
--LDst.Nome_Local,
--LLP.ETD_Lia,
--LLP.ATD_Lia,
--LLP.ETA_Lia,
--LLP.ATA_Lia,
--PCli.cd_Proc_Cliente,
--PDet.NCM,
--HOU.Vol_Tot_HIA,
--PCli.Produto_Descr,
--TLI.Nome_Tp_LI,
--SLI.Dt_Requerimento,
--SLI.Dt_LI,
--SLI.Dt_Deferimento,
--SLI.Dt_Vencimento ,
--ISNULL(SLI.Num_LI,'N/A'),
--OA.Nome_Orgao_anuente,
--SLI.Num_Requerimento,
--SLI.Dt_Solicitacao,
--SLI.Motivo,
--TP28.Dt_Conclusao,
--P5.Data_PO_HIA,
--P5.Numero_PO_HIA,
--LLP.Canal_Lia,
--Tp4.Dt_Conclusao,
--TP7.Dt_Conclusao,
--P.Incoterm,
--CP31.Campo_Dados,
--TM.Nome_Terminal,
--HOU.Vlr_Frete_Efet_HIA,
--TP142.Dt_Conclusao,
--TP143.Dt_Conclusao,
--TP144.Dt_Conclusao,
--TP13.Dt_Conclusao,
--TP146.Dt_Conclusao,
--Pdet.Qtde_Embal,
--TEmb.Nome_Tp_Embal,
--PS.Qty

--UNION ALL

--select 
--P.Num_PO [PO Number],
--P.Num_Pedido [Order Reference],
--P.Customer_PO [Customer PO],
--convert(varchar(10),PS.Qty,103) [Unit],
--HOU.HAWB_HIO [House],
--LLP.Num_Proc_Lio [JOB Number],
--LOrg.Nome_Local [Origin],
--POrg.Nome_Pais [Country of Origin],
--SHP.Apelido [Shipper],
--LDst.Nome_Local [Destination],
--cast(sum(CONVERT(decimal(18,3),PDet.Peso_Bruto_TOT)) as varchar(50)) [Gross Weight],
--cast(sum(CONVERT(decimal(18,3),Pdet.Peso_Liquido_TOT)) as varchar(50)) [Net Weight], 
--cast(sum(CONVERT(decimal(18,3),HOU.Vol_Tot_HIO)) as varchar(50)) [CBM],
--LLP.ETD_Lio [ETD - Date],
--LLP.ATD_Lio [ATD - Date],
--LLP.ETA_Lio [ETA - Date],
--LLP.ATA_Lio [ATA - Date],
--TM.Nome_Terminal [Terminal],
--PCli.cd_Proc_Cliente [Product ID],
--SUBSTRING(PDet.NCM,1,2)+ '.' + SUBSTRING(PDet.NCM,3,2)+'.'+ SUBSTRING(PDet.NCM,5,2)+'.'+ SUBSTRING(PDet.NCM,7,2) [NCM Number],
--PCli.Produto_Descr [Product Description],
--PDet.Qtde_Embal [Qty Packet],
--TEmb.Nome_Tp_Embal [Packing Type],
--TLI.Nome_Tp_LI[LI Type],
--TP146.Dt_Conclusao [Email Broker],
--SLI.Dt_Solicitacao [LI Request - Date ],
--SLI.Dt_LI [LI - Date],
--SLI.Dt_Deferimento [Def. LI - Date],
--SLI.Dt_Vencimento [LI Exp. - Date],
--ISNULL(SLI.Num_LI,'N/A')  [LI Number],
--OA.Nome_Orgao_anuente [Government Agency], 
--SLI.Num_Requerimento [Requirement Number],
--SLI.Dt_Requerimento [Requirement - Date],
--SLI.Motivo [Motive],
--TP28.Dt_Conclusao  [Port Entry Date],
--P5.Numero_PO_HIO [Entry Number],
--P5.Data_PO_HIO [Customs Transmission Date],
--LLP.Canal_Lio  [Channel],
--Tp4.Dt_Conclusao [Customs Clearance Date],
--dbo.fBusca_HistoricoDescr(LLP.Num_Proc_Lio,0,getdate()) [Last Historic],
--TP7.Dt_Conclusao  [Docs Delivery for Transport],
--sum(PDet.Vlr_Item)[Unit Price],
--sum(PDet.Vlr_Total_Item) [Total],
--P.Incoterm [Incoterm],
--'Others' [Modal],
--CP31.Campo_Dados [Taxa DI],
--SUM(II.Vlr_Item_Custo) [II],
--SUM(PIS.Vlr_Item_Custo) [PIS],
--SUM(CFI.Vlr_Item_Custo) [COFINS],
--HOU.Vlr_Frete_Efet_HIO [Ocean Freight USD],
--TP143.Dt_Conclusao [Danfe Request],
--TP142.Dt_Conclusao [Danfe Receipt],
--TP144.Dt_Conclusao [Scheduled Delivery],
--TP13.Dt_Conclusao [Good Receipt Date - Actual]

--from LLP_Imp_Out LLP with(nolock)
--join House_Imp_Out HOU						with(nolock) on LLP.Num_Proc_Lio = HOU.Num_Proc_HIO
--join Pedido_Ship PS							with(nolock) on LLP.Num_Proc_Lio = PS.Num_Proc
--join Pedido P								with(nolock) on PS.cd_pedido = P.Cd_pedido
--join Pedido_Det PDet						with(nolock) on P.Cd_pedido = PDet.Cd_Pedido and Ps.cd_produto = PDet.Cd_Produto and Ps.Item = PDet.Item and PS.Lote = PDet.Lote
--left Join Volume_Imp_Out VOL				with(nolock) on HOU.Num_Proc_HIO = VOl.Num_Proc_HIO
--left join Tipo_Embalagem TEmb				with(nolock) on PDet.cd_tp_embal = TEmb.Cd_Tp_Embal
--join Produto_Cliente PCli					with(nolock) on PS.cd_produto = PCli.cd_prod
--join Localidade LOrg						with(nolock) on HOU.Cd_Org_HIO = LOrg.Cd_Local
--join Pais POrg								with(nolock) on LOrg.Cd_Pais = POrg.Cd_Pais
--join Localidade LDst						with(nolock) on HOU.Cd_Dst_HIO = LDst.Cd_Local
----join Pais PDst							with(nolock) on LDst.Cd_Pais = PDst.Cd_Pais
--join Pessoa SHP								with(nolock) on HOU.Cd_Export_HIO = SHP.Cd_Pes
--left Join Solicitacao_LI SLI				With(nolock) on SLI.num_proc=hou.Num_Proc_HIO and SLI.num_solicitacao=(select top 1 SP.num_solicitacao from solicitacao_li SL 
--join solicitacao_li_produto SP				With(nolock) on SL.num_solicitacao=SP.num_solicitacao and PS.cd_produto = SP.Cd_Produto where num_proc=hou.Num_Proc_HIO   order by 1 desc)
----join solicitacao_li_produto SLP			With(nolock) on SLI.num_solicitacao=SLP.num_solicitacao and PS.cd_produto = SLP.Cd_Produto
--left Join Tipo_LI TLI						With(nolock) on TLI.id_tipo=SLI.id_tipo_li
--left join Solicitacao_LI_Orgao_Anuente OALI	With(nolock) on OALI.Num_Solicitacao	= SLI.Num_Solicitacao
--left join Orgao_Anuente OA					With(nolock) on OA.ID_Orgao = OALI.ID_Orgao_anuente
--left join Tarefas_Processos TP28			With(nolock) on LLP.Num_Proc_Lio = TP28.Num_Proc and TP28.ID_Task = 28
--left join PO_HIO	P5						With(nolock) on LLP.Num_Proc_Lio = P5.Num_Proc_HIO and P5.ID_DC = 5
--left join Tarefas_Processos TP4				With(nolock) on LLP.Num_Proc_Lio = TP4.Num_Proc and TP4.ID_Task = 4	
--left join Tarefas_Processos TP7				With(nolock) on LLP.Num_Proc_Lio = TP7.Num_Proc and TP7.ID_Task = 7
--left join Tarefas_Processos TP142			With(nolock) on LLP.Num_Proc_Lio = TP142.Num_Proc and TP142.ID_Task = 142
--left join Tarefas_Processos TP143			With(nolock) on LLP.Num_Proc_Lio = TP143.Num_Proc and TP143.ID_Task = 143
--left join Tarefas_Processos TP144			With(nolock) on LLP.Num_Proc_Lio = TP144.Num_Proc and TP144.ID_Task = 144
--left join Tarefas_Processos TP13			With(nolock) on LLP.Num_Proc_Lio = TP13.Num_Proc and TP13.ID_Task = 13
--left join Tarefas_Processos TP146			With(nolock) on LLP.Num_Proc_Lio = TP146.Num_Proc and TP146.ID_Task = 146
--left join Campo_Processo CP31				with(nolock) on LLP.Num_Proc_Lio = CP31.Num_Proc and CP31.Id_Campo= 31
--left join Custo_Cliente II					with(nolock) on LLP.Num_Proc_Lio = II.Num_Proc and II.Cd_Pedido= PS.cd_pedido and II.Cd_Produto = PS.cd_produto and II.Cd_tp_tx in (select cd_tp_Tx from Tipo_Taxa where Nome_Tp_Tx like 'Imposto de Importa%')
--left join Custo_Cliente PIS					with(nolock) on LLP.Num_Proc_Lio = PIS.Num_Proc and PIS.Cd_Pedido= PS.cd_pedido and PIS.Cd_Produto = PS.cd_produto and PIS.Cd_tp_tx in (select cd_tp_Tx from Tipo_Taxa where Nome_Tp_Tx like 'PIS%')
--left join Custo_Cliente CFI					with(nolock) on LLP.Num_Proc_Lio = CFI.Num_Proc and CFI.Cd_Pedido= PS.cd_pedido and CFI.Cd_Produto = PS.cd_produto and CFI.Cd_tp_tx in (select cd_tp_Tx from Tipo_Taxa where Nome_Tp_Tx like 'COFINS%')
--left join Custo_Cliente IC					with(nolock) on LLP.Num_Proc_Lio = IC.Num_Proc and IC.Cd_Pedido= PS.cd_pedido and IC.Cd_Produto = PS.cd_produto and IC.Cd_tp_tx in (select cd_tp_Tx from Tipo_Taxa where Nome_Tp_Tx like 'ICMS%')
--left join Custo_Cliente IND					with(nolock) on LLP.Num_Proc_Lio = IND.Num_Proc and IND.Cd_Pedido= PS.cd_pedido and IND.Cd_Produto = PS.cd_produto and IND.Cd_tp_tx in (select cd_tp_Tx from Tipo_Taxa where Nome_Tp_Tx like 'Inland Freight%')
--left join Terminal TM						with(nolock) on LLP.Cd_Terminal = TM.Cd_Terminal

--where 	substring(LLP.num_proc_Lio,3,3) in (@Grupo)
--	and
--	convert(Datetime,Dt_Emis_HIO,105) between @DtInicial and @DtFinal and LLP.ID_Status <> 9 

--Group By
--P.Num_PO,
--P.Num_Pedido,
--P.Customer_PO,
--HOU.HAWB_HIO,
--LLP.Num_Proc_Lio,
--LOrg.Nome_Local,
--POrg.Nome_Pais,
--SHP.Apelido,
--LDst.Nome_Local,
--LLP.ETD_Lio,
--LLP.ATD_Lio,
--LLP.ETA_Lio,
--LLP.ATA_Lio,
--PCli.cd_Proc_Cliente,
--PDet.NCM,
--HOU.Vol_Tot_HIO,
--PCli.Produto_Descr,
--TLI.Nome_Tp_LI,
--SLI.Dt_Requerimento,
--SLI.Dt_LI,
--SLI.Dt_Deferimento,
--SLI.Dt_Vencimento ,
--ISNULL(SLI.Num_LI,'N/A'),
--OA.Nome_Orgao_anuente,
--SLI.Num_Requerimento,
--SLI.Dt_Solicitacao,
--SLI.Motivo,
--TP28.Dt_Conclusao,
--P5.Data_PO_HIO,
--P5.Numero_PO_HIO,
--LLP.Canal_Lio,
--Tp4.Dt_Conclusao,
--TP7.Dt_Conclusao,
--P.Incoterm,
--CP31.Campo_Dados,
--TM.Nome_Terminal,
--HOU.Vlr_Frete_Efet_HIO,
--TP142.Dt_Conclusao,
--TP143.Dt_Conclusao,
--TP144.Dt_Conclusao,
--TP13.Dt_Conclusao,
--TP146.Dt_Conclusao,
--PDet.Qtde_Embal,
--TEmb.Nome_Tp_Embal,
--PS.Qty
GO
