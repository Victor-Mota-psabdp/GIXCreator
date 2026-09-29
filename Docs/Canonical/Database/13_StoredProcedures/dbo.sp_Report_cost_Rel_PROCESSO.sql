SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_Report_cost_Rel_PROCESSO]
(
 @Grupo varchar(20),  
 @DtInicial datetime,  
 @DtFinal datetime
)
AS

/* -------------------------------------------------------------------------------------------------------------------------
HISTORY CHANGE
. Date: 15/02/2021
. Applicant: 
. Developer: Alessandra Suzuki Mariano
. Request:	
-------------------------------------------------------------------------------------------------------------------------
EXECUTION EXECUTION
exec  sp_Report_cost_Rel_PROCESSO 'GRUPO DOW','2020-06-01','2020-06-30'

exec  sp_Report_cost_Rel_PROCESSO 'GRUPO SPECO','2020-09-01','2020-09-30'
-------------------------------------------------------------------------------------------------------------------------

*/

IF OBJECT_ID('tmp_relatorio_Custo_Processo', 'U') IS NOT NULL
	DROP TABLE dbo.tmp_relatorio_Custo_Processo;


SELECT 
--GRUPO.CD_PES
--,GRUPO.APELIDO
--,Cd_Consig
--,Cd_Export
--,SHIP.Nome_Raz_Soc				AS shipper
--,V.num_proc
--,HAWB
--,TP040.Dt_Conclusao					AS DT_PREST
V.num_proc
,V.cd_tp_oper
,V.Cd_Consig
,V.Cd_Org
,v.Cd_Dst
,V.CarrierName
,V.Vessel
,V.HAWB
,V.ETD
,V.ATD
,V.ETA
,V.ATA
,T.dt_conclusao AS dt_desembaraco
,V.Canal
,V.Qtd_Vol
,V.Peso_Liquido
,V.Peso_Bruto
INTO tmp_relatorio_Custo_Processo
FROM vwHouse_Imp V (NOLOCK)
INNER JOIN Tarefas_Processos T (NOLOCK)
	ON V.num_proc = T.num_proc
INNER JOIN Pessoa SHIP (NOLOCK)
	ON v.Cd_Export  = SHIP.CD_PES
INNER JOIN Pessoa_LLP LLP (NOLOCK)
	ON LLP.Cd_Pes = V.Cd_Consig
INNER JOIN Pessoa GRUPO (NOLOCK)
	ON GRUPO.CD_PES = LLP.Cd_Pes_Grupo 
WHERE V.ID_Status <> 9
AND T.id_task=4
AND T.dt_conclusao between @DtInicial and @DtFinal
AND GRUPO.APELIDO =  @Grupo 
--and v.num_proc IN('IMCSR202005426BR','IACSR201909032BR','IOCSR202006002BR','IMCSR202005426BR')

IF OBJECT_ID('tmp_relatorio_Custo_Processo_TAXAS', 'U') IS NOT NULL
	DROP TABLE dbo.tmp_relatorio_Custo_Processo_TAXAS;

SELECT 
V.num_proc
, TT.Nome_Tp_Tx
, ISNULL(CC.VLR_ITEM_CUSTO,0) VLR_ITEM_CUSTO
,CC.cd_tp_tx
INTO tmp_relatorio_Custo_Processo_TAXAS
FROM tmp_relatorio_Custo_Processo V (NOLOCK) 
INNER JOIN Custo_Cliente CC (NOLOCK)
	ON V.num_proc = CC.Num_Proc
INNER JOIN  Tipo_Taxa	TT  (NOLOCK)
	on TT.Cd_Tp_Tx=CC.Cd_Tp_Tx

IF OBJECT_ID('tmp_relatorio_Custo_Processo_Demais_colunas', 'U') IS NOT NULL
	DROP TABLE dbo.tmp_relatorio_Custo_Processo_Demais_colunas;


select 
CASE 
	WHEN SUBSTRING(TMP.NUM_PROC,1,2) = 'IM' THEN 'Ocean Import'
	WHEN SUBSTRING(TMP.NUM_PROC,1,2) = 'IA' THEN 'Air Import'
	WHEN SUBSTRING(TMP.NUM_PROC,1,2) = 'IO' THEN 'Other Import'
	ELSE ''	end																			AS [Modal]
,TMP.num_proc																			AS [Num_Proc]
,dbo.fBusca_Docs_PO_Modal(TMP.NUM_PROC,1)												AS [Numero da Ordem]
,TMP.cd_tp_oper																			AS [Incoterm]
,CONS.Nome_Raz_Soc																		AS [Consignee]
,CONS.Num_CPF_CNPJ																		AS [CNPJ]
,ori.nome_Local																			AS [Origin]
,ori.Pais_Local																			AS [Country of Origin]
,DEST.nome_Local																		AS [Destination]
,TMP.CarrierName																		AS [Carrier]
,TMP.Vessel																				AS [Vessel]
,TMP.HAWB																				AS [House]
,TMP.ETD																				AS [ETD]
,TMP.ATD																				AS [ATD]
,TMP.ETA																				AS [ETA]
,TMP.ATA																				AS [ATA]
,dbo.fBusca_Docs_PO_Modal(TMP.NUM_PROC,5)												AS [Numero da DI]
,CP031.Campo_Dados																		AS [Exchange Rates Value]
,dbo.fBusca_DATA_PO_Modal(TMP.NUM_PROC,5)												AS [Customs Transmission Date]
,TMP.dt_desembaraco																		AS [Data Desembaraço]
,case  
      When month(TMP.dt_desembaraco)=1 then 'Jan'  
      When month(TMP.dt_desembaraco)=2 then 'Fev'  
      When month(TMP.dt_desembaraco)=3 then 'Mar'  
      When month(TMP.dt_desembaraco)=4 then 'Abr'  
      When month(TMP.dt_desembaraco)=5 then 'Mai'  
      When month(TMP.dt_desembaraco)=6 then 'Jun'  
      When month(TMP.dt_desembaraco)=7 then 'Jul'  
      When month(TMP.dt_desembaraco)=8 then 'Ago'  
      When month(TMP.dt_desembaraco)=9 then 'Set'  
      When month(TMP.dt_desembaraco)=10 then 'Oct'  
      When month(TMP.dt_desembaraco)=11 then 'Nov'  
	  When month(TMP.dt_desembaraco)=12 then 'Dez'  
      else ''  
End																						AS [Month of Clearance]
,TMP.CANAL																				AS [Canal]
,dbo.fBusca_Docs_PO_Modal(TMP.NUM_PROC,10)												AS [NF Number]
,TP007.dt_conclusao																		AS [Transport. Doc Delivery Date]
,dbo.fBusca_Containers(TMP.NUM_PROC)													AS [Containers]
,TMP.Qtd_Vol																			AS [Container Qty]
,TMP.Peso_Liquido																		AS [Net Weight KG]
,TMP.Peso_Bruto																			AS [Gross Weight]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'Despesas Portuárias','','')			AS [Despesas Portuárias]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'Arqueação','','')					AS [Arqueação]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'TUP','','Atracação')					AS [TUP]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'Atracação','','')					AS [ATRACACAO]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'Liberação','BL','')					AS [Liberação de BL]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'Emissão de BL','','')				AS [Emissão de BL]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'Desconsolida','','')					AS [Desconsolidação]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'capatazias','','')
+dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'THC','','fthc')						AS [Capatazias / THC]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'Carta','correção','')				AS [Carta de Correção]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'correção','siscarga','')				AS [Correção Siscarga]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'taxa','siscarga','')					AS [TAXA SISCARGA]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'Demurrage','','')					AS [Demurrage]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'taxa','retirada','')					AS [Taxa de retirada de Doc]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'taxa','agente','')					AS [Taxa do Agente]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'damage','protection','')				AS [Damage Protection charge]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'Exame','Laboratorial','')			AS [Exame Laboratorial]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'taxa','lacre','')					AS [Taxa de Lacre]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'Armazenagem','','')					AS [Armazenagem]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'Handling','','')						AS [Handling]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'Manuseio','','')						AS [Manuseio de Carga]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'inspeção','madeira','')				AS [Inspeção de Madeira]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'Desova','','')						AS [Desova]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'Estadia','','')						AS [Estadia]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'Posicionamento','CNTR','')			AS [Posicionamento de CNTR]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'remoção','CNTR','')					AS [Remoção CNTR]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'Pesagem','CNTR','')					AS [Pesagem CNTR]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'Equip','Surcharge','')				AS [Equip. Surcharge]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'VISTORIA','CNTR','')					AS [VISTORIA DE CNTR]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'DESPESA','container','')				AS [DESPESA CONTAINER]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'Devolução','CNTR','')				AS [Devolução de CNTR]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'DROP','OFF','')						AS [Drop Off]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'lavagem','CNTR','')					AS [Lavagem CNTR]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'Reparo','Container','')				AS [Reparo de Container]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'Seguro','','')						AS [Seguro]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'frete','Interno','')					AS [Frete Interno]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'Serviço','Despacho','')				AS [Serviços de Despacho]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'Cartório','','')						AS [Cartório]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'Correio','','')						AS [Correio]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'Courier','','')						AS [Courier]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'Acompanhamento','Operacional','')	AS [Acompanhamento Operacional]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'Anuência',' li ','')					AS [Anuência de LI]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'emissão',' li ','')					AS [LI]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'Exercito',' li ','')					AS [Min. Exercito LI]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'AFRMM',' li ','')					AS [AFRMM]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'Taxa','Siscomex','')					AS [Taxas Siscomex]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'Imposto','Importação','')			AS [Imposto de Importação]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'IPI','','')							AS [IPI]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'PIS','','')							AS [PIS]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'COFINS','','')						AS [COFINS]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'ICMS','','')							AS [ICMS]
,dbo.fBusca_Custo_Processo_relatorio(TMP.NUM_PROC,'AntiDumping','','')					AS [AntiDumping Value]
into tmp_relatorio_Custo_Processo_Demais_colunas
from tmp_relatorio_Custo_Processo TMP (nolock)
INNER JOIN Pessoa CONS (NOLOCK)
	ON TMP.Cd_Consig  = CONS.CD_PES
LEFT JOIN LOCALIDADE ORI (NOLOCK)
	ON TMP.Cd_Org = ori.CD_LOCAL
LEFT JOIN LOCALIDADE DEST (NOLOCK)
	ON TMP.Cd_Dst = dest.CD_LOCAL
LEFT JOIN Campo_Processo CP031 (nolock)  
	ON TMP.Num_Proc = CP031.Num_Proc
	AND CP031.Id_Campo = 31 
LEFT JOIN Tarefas_Processos TP007 (NOLOCK) -- DOCS DISPONÍVEIS P/ TRANSP.
	ON TMP.num_proc = TP007.num_proc
	AND TP007.ID_TASK = 7





--IF OBJECT_ID('tmp_relatorio_Custo_Processo_campos_select', 'U') IS NOT NULL
--	DROP TABLE dbo.tmp_relatorio_Custo_Processo_campos_select;

--CREATE TABLE tmp_relatorio_Custo_Processo_campos_select
--(
--ID INT IDENTITY(1,1)
--,CAMPOS_SELECT VARCHAR(300)
--,CAMPOS_PIVOT VARCHAR(100)
--,NOME_TP_TX	VARCHAR(100)
--)

--INSERT INTO tmp_relatorio_Custo_Processo_campos_select
--(
--CAMPOS_SELECT
--,CAMPOS_PIVOT
--,NOME_TP_TX
--)
--SELECT DISTINCT 
--'ISNULL([' + NOME_TP_TX +'],0)' + ' as [' + NOME_TP_TX   + ']'		AS CAMPOS_SELECT
--, '[' + NOME_TP_TX +']'											AS CAMPOS_PIVOT
--,NOME_TP_TX 
--FROM tmp_relatorio_Custo_Processo_TAXAS (NOLOCK)
--ORDER BY NOME_TP_TX


--DECLARE @string_SELECT nvarchar(max)  
--set @string_SELECT = ''  
--DECLARE @Temp varchar(1000)  

--DECLARE c_cursor_SELECT cursor for    
--	SELECT  CAMPOS_SELECT 
--	from tmp_relatorio_Custo_Processo_campos_select (NOLOCK)
--	ORDER BY ID
   
--open c_cursor_SELECT  
--Fetch Next From c_cursor_SELECT Into @Temp  
--While @@FETCH_STATUS = 0  
--Begin  
--    if @Temp <> '' and @Temp is not null  
--		if @string_SELECT=''   
--			Begin  
--				Set @string_SELECT= + @Temp  
--			End  
--		Else  
--			Begin  
--				Set @string_SELECT=@string_SELECT + ',' + @Temp  
--			End  
--    Fetch Next From c_cursor_SELECT Into @Temp  
--End  
  
----select  @string_SELECT + ''''  
  
--close c_cursor_SELECT  
--deallocate c_cursor_SELECT  



--DECLARE @string_PIVOT nvarchar(max)  
--set @string_PIVOT = ''  
--DECLARE @Temp_PIVOT varchar(1000)  

--DECLARE c_cursor_PIVOT cursor for    
--	SELECT  CAMPOS_PIVOT 
--	from tmp_relatorio_Custo_Processo_campos_select (NOLOCK)
--	ORDER BY ID
   
--open c_cursor_PIVOT  
--Fetch Next From c_cursor_PIVOT Into @Temp_PIVOT  
--While @@FETCH_STATUS = 0  
--Begin  
--    if @Temp_PIVOT <> '' and @Temp_PIVOT is not null  
--		if @string_PIVOT=''   
--			Begin  
--				Set @string_PIVOT=  + @Temp_PIVOT  
--			End  
--		Else  
--			Begin  
--				Set @string_PIVOT=@string_PIVOT + ',' + @Temp_PIVOT  
--			End  
--    Fetch Next From c_cursor_PIVOT Into @Temp_PIVOT  
--End  
  
----select  @string_PIVOT + ''''  
  
--close c_cursor_PIVOT  
--deallocate c_cursor_PIVOT  



--IF OBJECT_ID('tmp_relatorio_Custo_Processo_PIVOT', 'U') IS NOT NULL
--	DROP TABLE dbo.tmp_relatorio_Custo_Processo_PIVOT;



--DECLARE @FINAL_SQL NVARCHAR(MAX)

--DECLARE @PART_01 VARCHAR(50)
--DECLARE @PART_02 VARCHAR(200)
--DECLARE @PART_03 VARCHAR(10)

--SET @PART_01 = 'SELECT num_proc, '
--	SET @PART_02 = ' INTO tmp_relatorio_Custo_Processo_PIVOT FROM tmp_relatorio_Custo_Processo_TAXAS AS C PIVOT (SUM(C.VLR_ITEM_CUSTO) FOR NOME_TP_TX IN ('
--SET @PART_03 = '))AS U'


--SET @FINAL_SQL = ''
--SET @FINAL_SQL = @FINAL_SQL + @PART_01
--SET @FINAL_SQL = @FINAL_SQL + @string_SELECT
--SET @FINAL_SQL = @FINAL_SQL + @PART_02
--SET @FINAL_SQL = @FINAL_SQL + @string_PIVOT
--SET @FINAL_SQL = @FINAL_SQL + @PART_03

----SELECT @FINAL_SQL
--EXEC (@FINAL_SQL)

select *,dbo.fBusca_GMID(num_proc) [ProductCode/GMID],dbo.fNCM(num_proc) [NCM] from tmp_relatorio_Custo_Processo_Demais_colunas with(nolock)

--select * from tmp_relatorio_Custo_Processo_PIVOT


GO
