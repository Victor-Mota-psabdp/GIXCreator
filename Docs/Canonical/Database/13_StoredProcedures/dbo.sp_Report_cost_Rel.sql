SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE sp_Report_cost_Rel
(
 @Grupo varchar(20),  
 @DtInicial datetime,  
 @DtFinal datetime
)
AS

/* -------------------------------------------------------------------------------------------------------------------------
HISTORY CHANGE
. Date: 24/11/2020
. Applicant: 
. Developer: Alessandra Suzuki Mariano
. Request:	
-------------------------------------------------------------------------------------------------------------------------
EXECUTION EXECUTION
exec  sp_Report_cost_Rel 'GRUPO DOW','2020-09-01','2020-09-30'

exec  sp_Report_cost_Rel 'GRUPO SPECO','2020-09-01','2020-09-30'
-------------------------------------------------------------------------------------------------------------------------

*/

IF OBJECT_ID('tmp_relatorio_Custo', 'U') IS NOT NULL
	DROP TABLE dbo.tmp_relatorio_Custo;


SELECT GRUPO.CD_PES,GRUPO.APELIDO,V.num_proc, T.dt_conclusao, TT.Nome_Tp_Tx, ISNULL(CC.VLR_ITEM_CUSTO,0) VLR_ITEM_CUSTO
INTO tmp_relatorio_Custo
FROM vwClienteALLJOBS V (NOLOCK)
INNER JOIN Tarefas_Processos T (NOLOCK)
	ON V.num_proc = T.num_proc
INNER JOIN Pessoa_LLP LLP (NOLOCK)
	ON LLP.Cd_Pes = V.cd_cliente
INNER JOIN Pessoa GRUPO (NOLOCK)
	ON GRUPO.CD_PES = LLP.Cd_Pes_Grupo 
INNER JOIN Custo_Cliente CC (NOLOCK)
	ON V.num_proc = CC.Num_Proc
INNER JOIN  Tipo_Taxa	TT  (NOLOCK)
	on TT.Cd_Tp_Tx=CC.Cd_Tp_Tx
WHERE V.ID_Status <> 9
AND LEFT(V.num_proc,1) = 'I'
AND T.id_task=4
AND T.dt_conclusao between @DtInicial and @DtFinal
AND GRUPO.APELIDO =  @Grupo 


IF OBJECT_ID('tmp_relatorio_Custo_campos_select', 'U') IS NOT NULL
	DROP TABLE dbo.tmp_relatorio_Custo_campos_select;

CREATE TABLE tmp_relatorio_Custo_campos_select
(
ID INT IDENTITY(1,1)
,CAMPOS_SELECT VARCHAR(300)
,CAMPOS_PIVOT VARCHAR(100)
,NOME_TP_TX	VARCHAR(100)
)

INSERT INTO tmp_relatorio_Custo_campos_select
(
CAMPOS_SELECT
,CAMPOS_PIVOT
,NOME_TP_TX
)
SELECT DISTINCT 
'ISNULL([' + NOME_TP_TX +'],0)' + ' as [' + NOME_TP_TX   + ']'		AS CAMPOS_SELECT
, '[' + NOME_TP_TX +']'											AS CAMPOS_PIVOT
,NOME_TP_TX 
FROM tmp_relatorio_Custo (NOLOCK)
ORDER BY NOME_TP_TX


DECLARE @string_SELECT nvarchar(max)  
set @string_SELECT = ''  
DECLARE @Temp varchar(1000)  

DECLARE c_cursor_SELECT cursor for    
	SELECT  CAMPOS_SELECT 
	from tmp_relatorio_Custo_campos_select (NOLOCK)
	ORDER BY ID
   
open c_cursor_SELECT  
Fetch Next From c_cursor_SELECT Into @Temp  
While @@FETCH_STATUS = 0  
Begin  
    if @Temp <> '' and @Temp is not null  
		if @string_SELECT=''   
			Begin  
				Set @string_SELECT= + @Temp  
			End  
		Else  
			Begin  
				Set @string_SELECT=@string_SELECT + ',' + @Temp  
			End  
    Fetch Next From c_cursor_SELECT Into @Temp  
End  
  
--select  @string_SELECT + ''''  
  
close c_cursor_SELECT  
deallocate c_cursor_SELECT  



DECLARE @string_PIVOT nvarchar(max)  
set @string_PIVOT = ''  
DECLARE @Temp_PIVOT varchar(1000)  

DECLARE c_cursor_PIVOT cursor for    
	SELECT  CAMPOS_PIVOT 
	from tmp_relatorio_Custo_campos_select (NOLOCK)
	ORDER BY ID
   
open c_cursor_PIVOT  
Fetch Next From c_cursor_PIVOT Into @Temp_PIVOT  
While @@FETCH_STATUS = 0  
Begin  
    if @Temp_PIVOT <> '' and @Temp_PIVOT is not null  
		if @string_PIVOT=''   
			Begin  
				Set @string_PIVOT=  + @Temp_PIVOT  
			End  
		Else  
			Begin  
				Set @string_PIVOT=@string_PIVOT + ',' + @Temp_PIVOT  
			End  
    Fetch Next From c_cursor_PIVOT Into @Temp_PIVOT  
End  
  
--select  @string_PIVOT + ''''  
  
close c_cursor_PIVOT  
deallocate c_cursor_PIVOT  


DECLARE @FINAL_SQL NVARCHAR(MAX)

DECLARE @PART_01 VARCHAR(50)
DECLARE @PART_02 VARCHAR(80)
DECLARE @PART_03 VARCHAR(10)

SET @PART_01 = 'SELECT Cd_Pes,Apelido,num_proc,Dt_Conclusao, '
SET @PART_02 = 'FROM tmp_relatorio_Custo AS C PIVOT (SUM(C.VLR_ITEM_CUSTO) FOR NOME_TP_TX IN ('
SET @PART_03 = '))AS U'


SET @FINAL_SQL = ''
SET @FINAL_SQL = @FINAL_SQL + @PART_01
SET @FINAL_SQL = @FINAL_SQL + @string_SELECT
SET @FINAL_SQL = @FINAL_SQL + @PART_02
SET @FINAL_SQL = @FINAL_SQL + @string_PIVOT
SET @FINAL_SQL = @FINAL_SQL + @PART_03

--PRINT @FINAL_SQL
EXEC (@FINAL_SQL)






GO
