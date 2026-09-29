SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spTaskProcImport_Upd]

		@Num_Proc		VARCHAR(16),
		@Nome_Task		VARCHAR(30),
		@Dt_Conclusao	DATETIME,
		@Dt_Previsao	DATETIME,
		@Usuario		VARCHAR(50)

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

spTaskProcImport_Upd 
'IMSWB201911069BR'
,'Envio docs originais p/cliente'
,'2021-10-29'
,NULL
,'Alessandra Suzuki Mariano'
-------------------------------------------------------------------------------------------------------------------------
*/

BEGIN TRANSACTION
	
	DECLARE @ID_Task		INT
	DECLARE @Cd_Usuario		VARCHAR(15)
	DECLARE @Inserir		BIT -- Alessandra 08/11/2021 - 100-303168
	DECLARE @Cd_Pes_Grupo	VARCHAR(10) -- Alessandra 08/11/2021 - 100-303168 


	SET @Id_task =		(SELECT TOP 1 Id_task FROM tipo_tarefas (NOLOCK) WHERE nome_task=@Nome_task AND modal=LEFT(@num_proc,2))
	SET @Cd_Usuario =	(SELECT Cd_Usuario FROM Usuario (NOLOCK) WHERE Nome_usuario = @Usuario)

	-- Alessandra 08/11/2021 - 100-303168 
	SET @Inserir= 0	
	SET @Cd_Pes_Grupo = (SELECT Cd_Pes_Grupo  
						FROM vwClienteALLJOBS V (nolock)   
						INNER JOIN Pessoa_LLP LLP (nolock)    
						ON LLP.Cd_Pes = V.cd_cliente   
						WHERE V.num_proc = @Num_Proc)

	IF NOT EXISTS	(SELECT dt_conclusao 
					FROM TAREFAS_PROCESSOS TP (NOLOCK) 
					INNER JOIN tipo_tarefas TT (NOLOCK) 
						ON TT.id_task = TP.id_task 
						AND TT.modal = LEFT(TP.num_proc,2)  
					WHERE nome_task = @Nome_task
					AND num_proc = @Num_Proc)
	AND EXISTS		(
					SELECT ID_TASK 
					FROM TIPO_TAREFAS (NOLOCK)
					WHERE nome_task = @Nome_task
					AND (Cd_Pes_Grupo=@Cd_Pes_Grupo OR cd_pes_grupo='10017')
					AND modal = LEFT(@Num_Proc,2)  
					)
		BEGIN
			SET @Inserir= 1
		END
	ELSE
		BEGIN
			SET @Inserir= 0
		END


	SELECT @Id_task AS ID_TASK, @Cd_Usuario AS USUARIO,@Inserir AS INSERIR


--BEGIN OF LOGIC
BEGIN
		
	IF @Dt_Conclusao IS NOT NULL AND @Dt_Previsao IS NOT NULL	
		
		BEGIN

			IF @Inserir = 1 
				BEGIN
					INSERT TAREFAS_PROCESSOS
					(
					Num_Proc
					,ID_Task
					,Dt_Conclusao
					,Dt_Previsao
					,Cd_Usuario
					,Dt_Insert
					)
					SELECT 
					@NUM_Proc		AS Num_Proc
					,@ID_Task		AS ID_Task
					,@Dt_Conclusao	AS Dt_Conclusao
					,@Dt_Previsao	AS Dt_Previsao
					,@Cd_Usuario	AS Cd_Usuario
					,GETDATE()		AS Dt_Insert
				END
			ELSE
				BEGIN
					UPDATE 
						TAREFAS_PROCESSOS
					SET
						Dt_Previsao=@Dt_Previsao,
						Dt_Conclusao=@Dt_Conclusao,
						Cd_Usuario=@cd_usuario
					WHERE
						Num_Proc=@NUM_Proc AND id_task=@ID_Task
				END
		END

	ELSE
		IF @Dt_Conclusao IS NOT NULL AND @Dt_Conclusao <=getdate()

			IF @Inserir = 1 
				BEGIN
					INSERT TAREFAS_PROCESSOS
					(
					Num_Proc
					,ID_Task
					,Dt_Conclusao
					,Dt_Previsao
					,Cd_Usuario
					,Dt_Insert
					)
					SELECT 
					@NUM_Proc		AS Num_Proc
					,@ID_Task		AS ID_Task
					,@Dt_Conclusao	AS Dt_Conclusao
					,GETDATE()		AS Dt_Previsao
					,@Cd_Usuario	AS Cd_Usuario
					,GETDATE()		AS Dt_Insert
				END
			ELSE
				BEGIN
					UPDATE 
						TAREFAS_PROCESSOS
					SET
						Dt_Conclusao=@Dt_Conclusao,
						Dt_Previsao=ISNULL(Dt_Previsao,GETDATE()),
						Cd_Usuario=@cd_usuario
					WHERE
						Num_Proc=@NUM_Proc AND id_task=@ID_Task
				END

	ELSE
		IF @Dt_Previsao IS NOT NULL
			IF @Inserir = 1 
				BEGIN
					INSERT TAREFAS_PROCESSOS
					(
					Num_Proc
					,ID_Task
					,Dt_Conclusao
					,Dt_Previsao
					,Cd_Usuario
					,Dt_Insert
					)
					SELECT 
					@NUM_Proc		AS Num_Proc
					,@ID_Task		AS ID_Task
					,NULL			AS Dt_Conclusao
					,@Dt_Previsao	AS Dt_Previsao
					,@Cd_Usuario	AS Cd_Usuario
					,GETDATE()		AS Dt_Insert
				END
			ELSE

				BEGIN
					UPDATE 
						TAREFAS_PROCESSOS
					SET
						Dt_Previsao=@Dt_Previsao,
						Cd_Usuario=@cd_usuario
					WHERE
						Num_Proc=@NUM_Proc and id_task=@ID_Task
				END
--END OF LOGIC
END

IF @@ERROR <> 0 
	BEGIN
		ROLLBACK TRANSACTION
	END

COMMIT TRANSACTION	






GO
