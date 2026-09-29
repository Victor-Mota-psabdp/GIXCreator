SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from Tipo_Tarefas where ID_Task = 172  
--select * from Pessoa where cd_pes in ('1','362','P000007571','P16997')

CREATE TRIGGER [dbo].[TrgPIM_TASK_InsUpd] ON [dbo].[PO_HIM] 
FOR INSERT,UPDATE
AS
	Declare @Processo varchar(16)
	Select @Processo = num_proc_him from inserted 
	
	Declare @ID_DC as int
	Select @ID_DC= id_dc from inserted
	
	Declare @Data_PO_HIM as Datetime
	select @Data_PO_HIM = Data_PO_HIM from inserted
	
	Declare @Cd_Usuario as varchar(10)
	select @Cd_Usuario = cd_usuario from inserted

	Declare @data datetime
	set @data = (select GETDATE())

--3º. ATL -> ABA -> Referência -> Tipo de Documento -> 005-DI Number -> Task "REGISTRO DE DI"
--By including the information "005-DI Number" the Task "DI REGISTRY" will be filled automatically; 
	
	if (@id_dc = 5 AND CONVERT(date,@Data_PO_HIM) <= CONVERT(date,getdate()))
	BEGIN
		BEGIN
			--IF not exists (select Num_Proc from tarefas_processos where num_proc = @Processo and id_task = 172)
			--	BEGIN
			--		insert into tarefas_processos (num_proc,id_task,dt_conclusao,dt_previsao,cd_usuario)
			--		values (@Processo, 172,@Data_PO_HIM, @Data_PO_HIM -5,@Cd_Usuario)
			--	END
			--ELSE
				BEGIN
					if exists(select Num_Proc from Tarefas_Processos where Num_Proc = @Processo	and Dt_Conclusao is null and ID_Task = 172)	
						Begin
							UPDATE 
								TAREFAS_PROCESSOS
							SET
								Dt_Conclusao=@Data_PO_HIM,
								Cd_Usuario=@cd_usuario
							WHERE
								Num_Proc=@Processo 
								and id_task=172
						End
				END
				exec dbo.[spHistG_InsUPD] @Processo,Null ,Null,'CSR','Task: REGISTRO DE DI preenchido pela inclusão da Referencia: 005-DI Number' ,@data,null ,'ATL System','N','U',null 	
		END			
	END
	if (@id_dc = 237  AND CONVERT(date,@Data_PO_HIM) <= CONVERT(date,getdate()))
	BEGIN
		BEGIN
				BEGIN
					if exists(select Num_Proc from Tarefas_Processos where Num_Proc = @Processo	and Dt_Conclusao is null and ID_Task = 278)	
						Begin
							UPDATE 
								TAREFAS_PROCESSOS
							SET
								Dt_Conclusao=@Data_PO_HIM,
								Cd_Usuario=@cd_usuario
							WHERE
								Num_Proc=@Processo 
								and id_task=278
						End
				END
				exec dbo.[spHistG_InsUPD] @Processo,Null ,Null,'CSR','Task: REGISTRO DE DUIMP preenchido pela inclusão da Referencia: 237-DUIMP Number' ,@data,null ,'ATL System','N','U',null 	
		END			
	END

GO
ALTER TABLE [dbo].[PO_HIM] ENABLE TRIGGER [TrgPIM_TASK_InsUpd]
GO
