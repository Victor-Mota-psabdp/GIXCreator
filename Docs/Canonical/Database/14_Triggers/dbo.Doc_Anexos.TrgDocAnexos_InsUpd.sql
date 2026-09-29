SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TrgDocAnexos_InsUpd] ON [dbo].[Doc_Anexos] 
FOR INSERT, UPDATE
AS
	Declare @Processo	varchar(16)
	Select @Processo = Num_Proc from inserted 

	
	if Left(@Processo, 5) <> 'EAJOB'
		--Begin 
		--	Insert Into Exchange (ExcProcesso, ExcDataAlt, ExcStatus,excdtenvio) 
		--	values (@Processo, getdate(), 0,'02-01-2010') 

		--End	
		Begin 
			IF LEFT(@Processo,2) = 'BO'
				Begin
				--se for sem job, tem q ir p o smart, report manager e ax
					if exists(select LBO.Num_Proc_LBO from LLP_BDP_OUT LBO with(nolock)	
						where LBO.Num_Proc_LBO = @Processo and isnull(LBO.Id_TP_Servico ,0) <> 1)										
							Begin
								Insert Into Exchange (ExcProcesso, ExcDataAlt, ExcStatus,ExcDtEnvio) 
								values (@Processo, getdate(), 0,GETDATE()) 				
							End
				-- se for = 1, so vai se  tiver job amarrado, só pode ir p o exchange, q envia ao ax, so deixei o dt_envio_JMD_AX = null
					if exists(select j.Num_Proc from LLP_BDP_OUT LBO with(nolock)	
								join JOB_HBO J with(nolock) on J.Num_Proc_HBO = LBO.Num_Proc_LBO
								where LBO.Num_Proc_LBO = @Processo and  j.Num_Proc is not null and isnull(LBO.Id_TP_Servico ,0) = 1)											
							Begin
								Insert Into Exchange (ExcProcesso, ExcDataAlt, ExcStatus,ExcDtEnvio,excReportManager,excReportManager2)
								values (@Processo, '2010-01-01', 0,'2010-01-01','2010-01-01','2010-01-01') 						
							End
				
				End
			ELSE
				Begin
					Insert Into Exchange (ExcProcesso, ExcDataAlt, ExcStatus,ExcDtEnvio) 
					values (@Processo, getdate(), 0,GETDATE()) 
				End			

		End
		
	Declare @ID_DC as int
	Select @ID_DC= id_dc from inserted
	Declare @cd_usuario as varchar(10)
	Select @cd_usuario = cd_usuario from inserted
	
	Declare @anexado_em as Datetime
	Select @anexado_em  = Anexado_Em from inserted
	
	Declare @anexado_del as Datetime
	Select @anexado_del  = Anexado_Em from deleted
	
	if (@anexado_em <> @anexado_del	or @anexado_del is null) 
		if @Processo is not null and LEFT(@Processo,1) = 'I'
			Begin 
				if exists(select Nome_DC from tipo_doc_cliente with(nolock) where ID_DC = @id_dc and Historico = 'S')
					Insert Into Doc_Anexos_Historico (Num_proc,ID_DC,CD_Usuario,Dt_Ins) 
					values (@Processo, @ID_DC, @cd_usuario,GETDATE()) 

			End
	
if @Processo is not null	
	Begin	
		Declare @Nome_DC varchar(100)
		Set @Nome_DC=(select Nome_DC from tipo_doc_cliente with(nolock) where ID_DC = @id_dc)	
		Declare @ID_Task int
		Declare @Nome_Task varchar(30)
		Declare @Msg_Task varchar(max)
		
		Declare C_DOC cursor for

			--select Distinct TP.ID_Task, TT.Nome_Task from Doc_Anexos DA with(nolock)
			--join Doc_Tarefas DT  with(nolock) on DA.Id_DC = DT.ID_DC
			--join Tipo_Tarefas TT with(nolock) on DT.ID_Task = TT.ID_Task and TT.Modal = SUBSTRING(DA.num_proc,1,2)
			--join Tarefas_Processos TP with(nolock) on DT.ID_Task = TP.ID_Task and DA.Num_Proc = TP.Num_Proc
			--where DA.Id_DC = @id_dc and DT.Modal = SUBSTRING(DA.num_proc,1,2)  and TP.Num_Proc = @Processo and TP.Dt_Conclusao is null and DT.Status = 1
			
			select Distinct TP.ID_Task, TT.Nome_Task  from Doc_Anexos DA with(nolock)
			join Doc_Tarefas DT  with(nolock) on cast(DA.Id_DC as varchar(50)) = DT.ID_DC and cast(DT.ID_DC as varchar(50)) not like '%,%'
			join Tipo_Tarefas TT with(nolock) on DT.ID_Task = TT.ID_Task and TT.Modal = SUBSTRING(DA.num_proc,1,2)
			join Tarefas_Processos TP with(nolock) on DT.ID_Task = TP.ID_Task and DA.Num_Proc = TP.Num_Proc
			join Campo_Processo CP143 with(nolock) on DA.Num_Proc = CP143.Num_Proc and CP143.Id_Campo = 143 
		where 
			DA.Id_DC = @id_dc 
			and DT.Modal = SUBSTRING(DA.num_proc,1,2)  
			and TP.Num_Proc = @Processo
			and TP.Dt_Conclusao is null 
			and DT.Status = 1
			and ((DT.ID_PD = 0 and CP143.Campo_Dados <> 0)
					or 
				(DT.ID_PD = CP143.Campo_Dados))


		Open C_DOC 
		Fetch Next From C_DOC Into @ID_Task,@Nome_Task
			While @@FETCH_STATUS = 0
				Begin
					print @ID_Task
					print @Nome_Task
					update Tarefas_Processos set Dt_Conclusao = GETDATE(), Cd_Usuario = 'ATL'
					where ID_Task = @ID_Task and Dt_Conclusao is null and Num_Proc =@Processo 
					
					Set @Msg_Task =(select 'Task: ' + @Nome_Task + ', concluido automaticamente após inclusão do Documento: ' + @Nome_DC + ' - ' + convert(varchar(10),getdate(),103) + ' ' + convert(varchar(30),getdate(),114))
					Insert hist_geral
						select 
							Num_Proc,(select isnull(max(hsgseq),0)+1 from hist_Geral with(nolock) where hsgprocesso=num_proc) Seq,null,
							108,@Msg_Task + ' , histórico gerado por ' + Nome_usuario ,
							getdate(),null,'ATL' Usuario,null,'N','U',null
						from 
							Doc_Anexos DA with(nolock)							
							Left Join Usuario US with(nolock) on US.cd_usuario=isnull(DA.cd_usuario,'ATL')
						where
							num_proc=@Processo and Id_DC = @id_dc
					Fetch Next From C_DOC Into @ID_Task,@Nome_Task
				End
		close C_DOC
		deallocate C_DOC
	End


/*ALTERAÇOES DO DOC_TAREFAS

ALTER TABLE [dbo].[Doc_Tarefas] DROP CONSTRAINT [PK_Doc_Tarefas]
alter table [dbo].[Doc_Tarefas] alter column [ID_DC] [varchar](50) NOT NULL
ALTER TABLE [dbo].[Doc_Tarefas] ADD CONSTRAINT [PK_Doc_Tarefas] 
PRIMARY KEY CLUSTERED 
(
	[ID_Task] ASC,
	[ID_DC] ASC,
	[Modal] ASC,
	[ID_PD] ASC
)
INSERT INTO [Doc_Tarefas]
select 87,'151,66',1,GETDATE(),'IM',2 from dbo.Doc_Tarefas where ID = 62
DOCsxTask_N.sql
spATL_DocTarefasMultDocs_Upd.sql
TrgDocAnexos_InsUpd.sql

*/

--ALTER TRIGGER [dbo].[TrgDocAnexos_InsUpd] ON [dbo].[Doc_Anexos] 
--FOR INSERT, UPDATE
--AS
--	Declare @Processo	varchar(16)
--	Select @Processo = Num_Proc from inserted 

	
--	if Left(@Processo, 5) <> 'EAJOB'
--		--Begin 
--		--	Insert Into Exchange (ExcProcesso, ExcDataAlt, ExcStatus,excdtenvio) 
--		--	values (@Processo, getdate(), 0,'02-01-2010') 

--		--End	
--		Begin 
--			IF LEFT(@Processo,2) = 'BO'
--				Begin
--				--se for sem job, tem q ir p o smart, report manager e ax
--					if exists(select LBO.Num_Proc_LBO from LLP_BDP_OUT LBO with(nolock)	
--						where LBO.Num_Proc_LBO = @Processo and isnull(LBO.Id_TP_Servico ,0) <> 1)										
--							Begin
--								Insert Into Exchange (ExcProcesso, ExcDataAlt, ExcStatus,ExcDtEnvio) 
--								values (@Processo, getdate(), 0,GETDATE()) 				
--							End
--				-- se for = 1, so vai se  tiver job amarrado, só pode ir p o exchange, q envia ao ax, so deixei o dt_envio_JMD_AX = null
--					if exists(select j.Num_Proc from LLP_BDP_OUT LBO with(nolock)	
--								join JOB_HBO J with(nolock) on J.Num_Proc_HBO = LBO.Num_Proc_LBO
--								where LBO.Num_Proc_LBO = @Processo and  j.Num_Proc is not null and isnull(LBO.Id_TP_Servico ,0) = 1)											
--							Begin
--								Insert Into Exchange (ExcProcesso, ExcDataAlt, ExcStatus,ExcDtEnvio,excReportManager,excReportManager2)
--								values (@Processo, '2010-01-01', 0,'2010-01-01','2010-01-01','2010-01-01') 						
--							End
				
--				End
--			ELSE
--				Begin
--					Insert Into Exchange (ExcProcesso, ExcDataAlt, ExcStatus,ExcDtEnvio) 
--					values (@Processo, getdate(), 0,GETDATE()) 
--				End			

--		End
		
--	Declare @ID_DC as int
--	Select @ID_DC= id_dc from inserted
--	Declare @cd_usuario as varchar(10)
--	Select @cd_usuario = cd_usuario from inserted
	
--	Declare @anexado_em as Datetime
--	Select @anexado_em  = Anexado_Em from inserted
	
--	Declare @anexado_del as Datetime
--	Select @anexado_del  = Anexado_Em from deleted
	
--	if (@anexado_em <> @anexado_del	or @anexado_del is null) 
--		if @Processo is not null and LEFT(@Processo,1) = 'I'
--			Begin 
--				if exists(select Nome_DC from tipo_doc_cliente with(nolock) where ID_DC = @id_dc and Historico = 'S')
--					Insert Into Doc_Anexos_Historico (Num_proc,ID_DC,CD_Usuario,Dt_Ins) 
--					values (@Processo, @ID_DC, @cd_usuario,GETDATE()) 

--			End
	
--if @Processo is not null	
--	Begin	
--		Declare @Nome_DC varchar(100)
--		Set @Nome_DC=(select Nome_DC from tipo_doc_cliente with(nolock) where ID_DC = @id_dc)	
--		Declare @ID_Task int
--		Declare @Nome_Task varchar(30)
--		Declare @Msg_Task varchar(max)
		
--		Declare C_DOC cursor for

--			--select Distinct TP.ID_Task, TT.Nome_Task from Doc_Anexos DA with(nolock)
--			--join Doc_Tarefas DT  with(nolock) on DA.Id_DC = DT.ID_DC
--			--join Tipo_Tarefas TT with(nolock) on DT.ID_Task = TT.ID_Task and TT.Modal = SUBSTRING(DA.num_proc,1,2)
--			--join Tarefas_Processos TP with(nolock) on DT.ID_Task = TP.ID_Task and DA.Num_Proc = TP.Num_Proc
--			--where DA.Id_DC = @id_dc and DT.Modal = SUBSTRING(DA.num_proc,1,2)  and TP.Num_Proc = @Processo and TP.Dt_Conclusao is null and DT.Status = 1
			
--			select Distinct TP.ID_Task, TT.Nome_Task  from Doc_Anexos DA with(nolock)
--			join Doc_Tarefas DT  with(nolock) on DA.Id_DC = DT.ID_DC
--			join Tipo_Tarefas TT with(nolock) on DT.ID_Task = TT.ID_Task and TT.Modal = SUBSTRING(DA.num_proc,1,2)
--			join Tarefas_Processos TP with(nolock) on DT.ID_Task = TP.ID_Task and DA.Num_Proc = TP.Num_Proc
--			join Campo_Processo CP143 with(nolock) on DA.Num_Proc = CP143.Num_Proc and CP143.Id_Campo = 143 
--		where 
--			DA.Id_DC = @id_dc 
--			and DT.Modal = SUBSTRING(DA.num_proc,1,2)  
--			and TP.Num_Proc = @Processo
--			and TP.Dt_Conclusao is null 
--			and DT.Status = 1
--			and ((DT.ID_PD = 0 and CP143.Campo_Dados <> 0)
--					or 
--				(DT.ID_PD = CP143.Campo_Dados))


--		Open C_DOC 
--		Fetch Next From C_DOC Into @ID_Task,@Nome_Task
--			While @@FETCH_STATUS = 0
--				Begin
--					print @ID_Task
--					print @Nome_Task
--					update Tarefas_Processos set Dt_Conclusao = GETDATE(), Cd_Usuario = 'ATL'
--					where ID_Task = @ID_Task and Dt_Conclusao is null and Num_Proc =@Processo 
					
--					Set @Msg_Task =(select 'Task: ' + @Nome_Task + ', concluido automaticamente após inclusão do Documento: ' + @Nome_DC + ' - ' + convert(varchar(10),getdate(),103) + ' ' + convert(varchar(30),getdate(),114))
--					Insert hist_geral
--						select 
--							Num_Proc,(select isnull(max(hsgseq),0)+1 from hist_Geral with(nolock) where hsgprocesso=num_proc) Seq,null,
--							108,@Msg_Task + ' , histórico gerado por ' + Nome_usuario ,
--							getdate(),null,'ATL' Usuario,null,'N','U',null
--						from 
--							Doc_Anexos DA with(nolock)							
--							Left Join Usuario US with(nolock) on US.cd_usuario=isnull(DA.cd_usuario,'ATL')
--						where
--							num_proc=@Processo and Id_DC = @id_dc
--					Fetch Next From C_DOC Into @ID_Task,@Nome_Task
--				End
--		close C_DOC
--		deallocate C_DOC
--	End

GO
ALTER TABLE [dbo].[Doc_Anexos] ENABLE TRIGGER [TrgDocAnexos_InsUpd]
GO
