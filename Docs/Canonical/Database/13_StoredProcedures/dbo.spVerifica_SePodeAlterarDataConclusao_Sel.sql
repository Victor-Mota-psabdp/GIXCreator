SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spVerifica_SePodeAlterarDataConclusao_Sel]
(
	@Num_Proc		VARCHAR(16)
	,@Task_Name		VARCHAR(30)
)
AS
/* -------------------------------------------------------------------------------------------------------------------------
HISTORY CHANGE
. Date:			08/11/2021
. Business:		Camila Pereira (camila.pereira@bdpint.com)
. Dept:			Operations
. Developer:	Alessandra Suzuki Mariano
. Ticket:		100-303168
. Request:		Task Envio docs originais p cliente
-------------------------------------------------------------------------------------------------------------------------
EXECUTION 
spVerifica_SePodeAlterarDataConclusao_Sel 'IMSWB201911066BR','Envio docs originais p/cliente'
-------------------------------------------------------------------------------------------------------------------------
*/
SET NOCOUNT ON

	 DECLARE @Cd_Pes_Grupo VARCHAR(10)  

	 SET @Cd_Pes_Grupo = (SELECT Cd_Pes_Grupo   
						 FROM vwClienteALLJOBS V (nolock)   
						 INNER JOIN Pessoa_LLP LLP (nolock)    
							ON LLP.Cd_Pes = V.cd_cliente   
						 WHERE V.num_proc = @Num_Proc)

	-- Verify if the job already have the task to update
	SELECT 
		dt_conclusao 
	FROM TAREFAS_PROCESSOS TP (NOLOCK) 
	INNER JOIN tipo_tarefas TT (NOLOCK) 
		ON TT.id_task = TP.id_task 
		AND TT.modal = LEFT(TP.num_proc,2)  
	WHERE nome_task = @Task_Name
	AND num_proc = @Num_Proc

	UNION

	--Verify if the Group of that job has access to the task to insert in another routine
	SELECT 
		NULL AS dt_conclusao
	FROM TIPO_TAREFAS (NOLOCK)
	WHERE nome_task = @Task_Name
	and (Cd_Pes_Grupo=@Cd_Pes_Grupo OR cd_pes_grupo='10017')



SET NOCOUNT OFF



GO
