SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_CTRLDemurrage_Rel 'Grupo ALL','2015-01-01','2015-01-01'

CREATE procedure [dbo].[spATL_CTRLDemurrage_Rel](
@Grupo varchar(50),
@DtInicial datetime,
@DtFinal datetime

)
as
Declare @TempTable Table(
[ID] varchar(10),
[BDP Ref.] varchar(16),
[PO Number]varchar(50),
[Customer_PO]varchar(50),
[Consignee]varchar(50),
[Product Description]varchar(max),-- Aguadando definição
[Origem]varchar(50),
[Destino]varchar(50),
[Port of Discharge]varchar(50),
[Incoterm]varchar(50),
--[Terminal]varchar(50),
[Carrier]varchar(50),
[BL Number]varchar(50),
--NULL [House], Campo eliminado do relatorio por duplicidade com o [BL Number]
---[Gross Weight - House]float,
--[Net Weight - House]float,
[Container]varchar(50),
[Type - Container]varchar(50),
[Gross Weight - Container]float,
--[References], -- Checar com a operação --Campo eliminado
[ETA Date]datetime,
[ATA Date]datetime,
[Free-Time]int,
[Exp. Del. Date]datetime,
[Return Date]datetime,
--NULL [Type],-- Checar com a operação --Campo eliminado
[Transport. Doc Delivery Date]datetime,
[Good Receipt]datetime,
[Delivery to Warehouse]datetime,
[Exit to Warehouse]datetime,
[Empty Exit]datetime,
[Return Date Info]datetime,
[Delivery Empty Container]varchar(50),
[Delivery Place]Varchar(50),
[Dias Corridos Após ATA]int,
--[Dias Corridos Após ATA]varchar(50),
--[Dias Corridos Após Free Time]int,
[Dias Corridos Após Free Time]Varchar(50),
[QTDE 1º PERÍODO DEMURRAGE] int, --Inserido para o calculo [Dias corridos após 1º período]
[Dias corridos após 1º período]int,
[Análise de demurrage]varchar(50),
[Utilização do 1º período]varchar(50),
[VALOR 1º PERÍODO DEMURRAGE POR DIA] float,--Inserido para o calculo [Cálculo Se 1º período total]
[Cálculo Se 1º período total]float,
[Cálculo Se 1º período parcial]float,
[Valor do 1º período]float,
[Utilização do 2º período]varchar(50),
[VALOR 2º PERÍODO DEMURRAGE POR DIA] float,--Inserido para o calculo[Cálculo se 2º período]
[Cálculo se 2º período] float,
[Valor do 2º período]float,
[Valor total de demurrage]float,
[Valor Pago de Demurrage] float,
[Data Report] datetime
)



insert @TempTable
Select 
ROW_NUMBER() OVER(ORDER BY vw.Num_Proc DESC) + 1 ,
vw.Num_Proc [BDP Ref.],
PO.Numero_PO [PO Number],
PO.Numero_Customer_PO [Customer_PO],
CNSG.Apelido [Consignee],
REPLACE(dbo.fBusca_PRODUTO(vw.Num_Proc),';',CHAR(10)) [Product Description],-- Aguadando definição
ORG.Nome_Local [Origem],
DST.Nome_Local [Destino],
PDST.Nome_Local [Port of Discharge],
VW.cd_tp_oper [Incoterm],
--TRMN.Apelido [Terminal],
ARM.Nome_Armador [Carrier],
vw.HAWB [BL Number],
--NULL [House], Campo eliminado do relatorio por duplicidade com o [BL Number]
--vw.Peso_Bruto [Gross Weight - House],
--vw.Peso_Liquido [Net Weight - House],
CTN.Num_Cont [Container],
TCTN.Nome_Tp_Cont [Type - Container],
CTN.Peso_Bruto [Gross Weight - Container],
--NULL [References], -- Checar com a operação --Campo eliminado
vw.ETA [ETA Date],
vw.ATA [ATA Date],
CP138.Campo_Dados [Free-Time],
(Case When CTN.Dt_Vcto_Devol = '' then NULL else convert(datetime,CTN.Dt_Vcto_Devol,103) end) [Exp. Del. Date],
convert(datetime,Dt_Devol,103) [Return Date],
--NULL [Type],-- Checar com a operação --Campo eliminado
TP7.Dt_Conclusao [Transport. Doc Delivery Date],
CNTI.dt_entregaPlanta [Good Receipt],
CNTI.dt_entregaArmazem [Delivery to Warehouse],
CNTI.dt_saidaArmazem [Exit to Warehouse],
CNTI.dt_saidaVazio [Empty Exit],
CNTI.dt_devolucao [Return Date],
CNTI.local_Entrega_Vazio [Delivery Empty Container],
CNTI.local_Entrega [Delivery Place],
NULL [Dias Corridos Após ATA],
NULL [Dias Corridos Após Free Time],
CP156.Campo_Dados [QTDE 1º PERÍODO DEMURRAGE],
NULL [Dias corridos após 1º período],
NULL [Análise de Demurrage],
NULL [Utilização do 1º período],
CP157.Campo_Dados [VALOR 1º PERÍODO DEMURRAGE POR DIA],
NULL [Cálculo Se 1º período total],
NULL [Cálculo Se 1º período parcial],
NULL [Valor do 1º período],
NULL [Utilização do 2º período],
CP158.Campo_Dados [VALOR 2º PERÍODO DEMURRAGE POR DIA],
NULL [Cálculo se 2º período],
NULL [Valor do 2º período],
NULL [Valor total de demurrage],
dbo.fBusca_Custo_Processo(vw.Num_Proc,'Demurrage%') ,
getdate()



from vwHouse_IMP vw with(nolock)
left join vwPO_IMP PO with(nolock) on  vw.Num_proc = PO.Num_proc
left join vwContainer_IMP CTN with(nolock) on vw.Num_Proc = CTN.Num_proc
join Tipo_Container TCTN with(nolock) on CTN.Cd_Tp_Cont = TCTN.Cd_Tp_Cont 
join Pessoa CNSG with(nolock) on vw.Cd_Consig=CNSG.Cd_Pes
join Localidade ORG with(nolock) on vw.Cd_Planta=ORG.Cd_Local
join Localidade DST with(nolock) on vw.Cd_DstFinal=DST.Cd_Local
join Localidade PDST with(nolock) on vw.Cd_Dst=PDST.Cd_Local
--left join Pessoa TRMN with(nolock) on vw.Cd_Terminal=TRMN.Cd_Pes
left join Armador ARM with(nolock) on vw.Cd_Armador = ARM.Cd_Armador
left join Campo_Processo CP138 with(nolock) on vw.Num_Proc = CP138.Num_Proc and CP138.Id_Campo = 138
left join Campo_Processo CP156 with(nolock) on vw.Num_Proc = CP156.Num_Proc and CP156.Id_Campo = 156
left join Campo_Processo CP157 with(nolock) on vw.Num_Proc = CP157.Num_Proc and CP157.Id_Campo = 157
left join Campo_Processo CP158 with(nolock) on vw.Num_Proc = CP158.Num_Proc and CP158.Id_Campo = 158
left join Tarefas_Processos TP7 with(nolock) on vw.Num_proc = TP7.Num_Proc and TP7.ID_Task = 7
left join Container_Additional_Info CNTI with(nolock) on vw.Num_Proc = CNTI.num_proc and  replace(CTN.Num_Cont,'-','') = replace(CNTI.num_cont,'-','')
Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=vw.Cd_Consig
join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
join pessoa	PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
--where vw.Num_Proc in ('IMOXT201712032BR')
where vw.ETA between @DtInicial and @DtFinal and (PG.Apelido like @Grupo or @Grupo ='Grupo ALL')
OPTION (HASH JOIN)




--
--update @TempTable set [Dias Corridos Após ATA] = '=Y' + ID +'-P'+ ID
--update @TempTable set [Dias Corridos Após Free Time] = '=IF(Y' + ID +'-Q'+ID + '<=0;0;Y' + ID+ '-Q'+ID+')'



update @TempTable set [Dias Corridos Após ATA] = DATEDIFF(DAY,[ATA Date], isnull([Return Date Info],GETDATE()))
update @TempTable set [Dias Corridos Após Free Time] = (Case when [Dias Corridos Após ATA] - [Free-Time] <= 0 then 0 else [Dias Corridos Após ATA] - [Free-Time]end)
update @TempTable set [Dias corridos após 1º período] = (case when [Dias Corridos Após Free Time] = 0 then 0 else [Dias Corridos Após Free Time]- [QTDE 1º PERÍODO DEMURRAGE]end)
--update @TempTable set [Dias corridos após 1º período] = (case when [Dias Corridos Após Free Time] = 0 then 0 else (case when [Dias Corridos Após Free Time]- [QTDE 1º PERÍODO DEMURRAGE] < 0 then [Dias Corridos Após Free Time] else [Dias Corridos Após Free Time]- [QTDE 1º PERÍODO DEMURRAGE] end)end)
update @TempTable set [Análise de Demurrage] = (case when isnull([Dias Corridos Após Free Time],0) <= 0 then 'Sem Demurrage' else 'Com Demurrage'  end)
update @TempTable set [Utilização do 1º período] = (case when [Análise de Demurrage]= 'Sem Demurrage' then 'Sem Utilização' else (Case when [Dias Corridos Após Free Time]>=[QTDE 1º PERÍODO DEMURRAGE]then'Total'else Case when [QTDE 1º PERÍODO DEMURRAGE] is null then 'N/D' else 'Parcial' end end)  end)
update @TempTable set [Cálculo Se 1º Período Total] = (case when [Utilização do 1º período] = 'Total' then[QTDE 1º PERÍODO DEMURRAGE]* [VALOR 1º PERÍODO DEMURRAGE POR DIA] else 0  end)
update @TempTable set [Cálculo Se 1º período parcial] = (case when [Utilização do 1º período] = 'Total' then 0 else [Dias Corridos Após Free Time]* [VALOR 1º PERÍODO DEMURRAGE POR DIA] end)
update @TempTable set [Valor do 1º período] = (case when [Utilização do 1º período] = 'Total' then [Cálculo Se 1º Período Total] else [Cálculo Se 1º período parcial]  end)
update @TempTable set [Utilização do 2º período] = (case when isnull([Dias corridos após 1º período],0) <= 0 and  [Utilização do 1º período] <>'N/D' then 'Não' else 'Sim'  end)
update @TempTable set [Cálculo se 2º período] = (case when [Utilização do 2º período] = 'Sim' and [Utilização do 1º período] <>'N/D' then [Dias corridos após 1º período]*[VALOR 2º PERÍODO DEMURRAGE POR DIA] 
											else case when [Utilização do 2º período] = 'Sim' and [Utilização do 1º período] ='N/D' then [Dias Corridos Após Free Time] *[VALOR 2º PERÍODO DEMURRAGE POR DIA]  else 0  end end)
update @TempTable set [Valor do 2º período]=(case when [Utilização do 2º período] = 'Sim' then [Cálculo se 2º período] else 0  end)
update @TempTable set [Valor total de demurrage] = (case when [Utilização do 1º período] ='N/D' then [Valor do 2º período] else [Valor do 2º período]+[Valor do 1º período] end)


/*OLD
update @TempTable set [Utilização do 2º período] = (case when isnull([Dias corridos após 1º período],0) <= 0 or isnull([QTDE 1º PERÍODO DEMURRAGE],0) = 0 then 'Não' else 'Sim'  end)
update @TempTable set [Cálculo se 2º período] = (case when [Utilização do 2º período] = 'Sim' and [Utilização do 1º período] <>'N/D' then [Dias corridos após 1º período]*[VALOR 2º PERÍODO DEMURRAGE POR DIA] 
											else case when [Utilização do 2º período] = 'Sim' and [Utilização do 1º período] ='N/D' then [Dias Corridos Após Free Time] *[VALOR 2º PERÍODO DEMURRAGE POR DIA]  else 0  end end)
update @TempTable set [Valor do 2º período]=(case when [Utilização do 2º período] = 'Sim' then [Cálculo se 2º período] else 0  end)
update @TempTable set [Valor total de demurrage] = (case when [Utilização do 1º período] ='N/D' then [Valor do 2º período] else [Valor do 2º período]+[Valor do 1º período] end)
*/
select 
[BDP Ref.],
[PO Number],
[Customer_PO],
[Consignee],
[Product Description],
[Origem],
--[Destino],
[Port of Discharge],
[Incoterm],
[Carrier],
[BL Number],
[Container],
[Type - Container],
[Gross Weight - Container],
[ETA Date],
[ATA Date],
[Free-Time],
--[Exp. Del. Date],
--[Return Date],
[Transport. Doc Delivery Date],
[Good Receipt],
[Delivery to Warehouse],
[Exit to Warehouse],
[Empty Exit],
[Return Date Info],
[Delivery Empty Container],
[Delivery Place],
[Dias Corridos Após ATA],
[Dias Corridos Após Free Time],
[QTDE 1º PERÍODO DEMURRAGE],
[Dias corridos após 1º período],
[Análise de demurrage],
[Utilização do 1º período],
[VALOR 1º PERÍODO DEMURRAGE POR DIA],
[Cálculo Se 1º período total],
[Cálculo Se 1º período parcial],
[Valor do 1º período],
[Utilização do 2º período],
[VALOR 2º PERÍODO DEMURRAGE POR DIA],
[Cálculo se 2º período],
[Valor do 2º período],
[Valor total de demurrage],
[Valor Pago de Demurrage] ,
[Data Report]

 from @TempTable

/*
--where vw.num_proc = 'IMOXT21508056BR'

select * from Campo_Processo

select * from Tipo_Campo_Cliente




*/



GO
