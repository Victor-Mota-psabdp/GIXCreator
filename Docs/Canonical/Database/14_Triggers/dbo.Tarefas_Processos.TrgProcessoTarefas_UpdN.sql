SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TrgProcessoTarefas_UpdN] ON [dbo].[Tarefas_Processos] 
FOR  UPDATE
AS
	Declare @Processo	varchar(16)
	Declare @id_Task	Int
	Declare @Dt_Conclusao	Datetime
	Declare @Grupo Varchar(10)
	Select @Processo = Num_Proc from inserted 
	Select @id_Task=id_task from inserted
	Select @Dt_Conclusao=dt_conclusao from inserted
	--Select @Grupo=(select top 1 cd_pes_grupo from Grupo with(nolock) where substring(@Processo,3,3)=Grupo)
	
	Select @Grupo= (select Cd_Pes_Grupo from vwClienteALLJOBS V with(nolock) 
			join Pessoa_LLP LLP on LLP.Cd_Pes = V.cd_cliente	
		where V.num_proc = @Processo)
	
	if @Dt_Conclusao is not null
		BEGIN
		--incluido para verificar se eh 21 - Liberação de BL, pra cria como type of Occurence: 104
			-- Ticket #100-98234
			update Tarefas_Processos set Dt_Insert = Getdate()
			where ID_Task = @id_Task and Num_Proc = @Processo
			
			--if @id_Task = 21
			--	Begin
			--		Insert hist_geral

			--			select 
			--				Num_Proc,(select isnull(max(hsgseq),0)+1 from hist_Geral where hsgprocesso=num_proc) Seq,null,
			--				104,Mensagem + convert(varchar(10),dt_Conclusao,103) +' , histórico gerado por  ' + Nome_usuario ,getdate(),null,'ATL' Usuario,
			--				null,'S','U',null
			--			from 
			--				Tarefas_Processos TP with(nolock)
			--				Join Historico_Auto HA with(nolock) on HA.id_Task=TP.id_task and left(TP.num_proc,2)=HA.Modal and HA.ativo='S' and (cd_pes_Grupo=@Grupo or cd_pes_grupo='10017')
			--				Left Join Usuario US with(nolock) on US.cd_usuario=isnull(tp.cd_usuario,'ATL')
			--			where
			--				num_proc=@processo and tp.id_task=@id_Task
			--	End	
			--else
			--	Begin
			--		Insert hist_geral
			--			select 
			--				Num_Proc,(select isnull(max(hsgseq),0)+1 from hist_Geral where hsgprocesso=num_proc) Seq,null,
			--				44,Mensagem + convert(varchar(10),dt_Conclusao,103) +' , histórico gerado por  ' + Nome_usuario ,getdate(),null,'ATL' Usuario,
			--				null,'S','U',null
			--			from 
			--				Tarefas_Processos TP with(nolock)
			--				Join Historico_Auto HA with(nolock) on HA.id_Task=TP.id_task and left(TP.num_proc,2)=HA.Modal and HA.ativo='S' and (cd_pes_Grupo=@Grupo or cd_pes_grupo='10017')
			--				Left Join Usuario US with(nolock) on US.cd_usuario=isnull(tp.cd_usuario,'ATL')
			--			where
			--				num_proc=@processo and tp.id_task=@id_Task
			--				and HA.id_Task <> 163
			--				--outra função faz o 163, direto no codigo de frmHIM
			--	End
			
			--Updated to use the new columns of table: Historico_Auto BDP Support Ticket#200-11972 
			Begin
				Insert hist_geral
					select 
						Num_Proc,(select isnull(max(hsgseq),0)+1 from hist_Geral where hsgprocesso=num_proc) Seq,null,
						HA.cd_tp_ocor,Mensagem + convert(varchar(10),dt_Conclusao,103) +' , histórico gerado por  ' + Nome_usuario ,getdate(),null,'ATL' Usuario,
						null,HA.disp_cliente,'U',null
					from 
						Tarefas_Processos TP with(nolock)
						Join Historico_Auto HA with(nolock) on HA.id_Task=TP.id_task and left(TP.num_proc,2)=HA.Modal and HA.ativo='S' 
							and (cd_pes_Grupo=@Grupo or cd_pes_grupo='10017')
						Left Join Usuario US with(nolock) on US.cd_usuario=isnull(tp.cd_usuario,'ATL')
					where
						num_proc=@processo and tp.id_task=@id_Task
						and HA.id_Task <> 163
						--outra função faz o 163, direto no codigo de frmHIM
			End
				
			--Begin 
			--	Insert Tarefas_Processos_Alerta 
			--		select distinct
			--			TP.Num_Proc,TP.id_Task,TP.dt_conclusao,TP.dt_previsao, TP.cd_usuario, getdate()							
			--		from 
			--			Tarefas_Processos TP with(nolock)
			--			join Alerta_Email_Doc_Automatico A with(nolock) on A.id_task = TP.ID_Task						
			--		where
			--			TP.num_proc=@processo and tp.id_task=@id_Task
			--			and left(@processo,2) = A.MODAL
			--			--and A.cd_pes_grupo = @Grupo
						
			--			and (
			--					(A.cd_pes_grupo = 'ALL' and @Grupo <> 'ALL')
			--					or 
			--					(A.Cd_Pes_Grupo = @Grupo)
			--				)
						
						
			--			and A.ativo = 1
			--End
			
			if @id_Task = 63 and @Grupo in ('1','P20904')  
				Begin
				
					update Tarefas_Processos set Dt_Conclusao = @Dt_Conclusao, Cd_Usuario = 'ATL'
					where ID_Task = 16 and Num_Proc = @Processo and Dt_Conclusao is null
				
				End
			if @id_Task = 15 and @Grupo in ('P000000450')  
				Begin
				
					exec spATL_ExchangeGTNexus_Ins @Processo,'ATL','INTEGRATION POINT','Original'
				
				End
				
		END
		
		--select * from Tarefas_Processos_Alerta 
		--select * from Alerta_Email_Doc_Automatico






--ALTER TRIGGER [dbo].[TrgProcessoTarefas_UpdN] ON [dbo].[Tarefas_Processos] 
--FOR  UPDATE
--AS
--	Declare @Processo	varchar(16)
--	Declare @id_Task	Int
--	Declare @Dt_Conclusao	Datetime
--	Declare @Grupo Varchar(10)
--	Select @Processo = Num_Proc from inserted 
--	Select @id_Task=id_task from inserted
--	Select @Dt_Conclusao=dt_conclusao from inserted
--	Select @Grupo=(select top 1 cd_pes_grupo from Grupo where substring(@Processo,3,3)=Grupo)
	
--	if @Dt_Conclusao is not null
--		BEGIN
--		--incluido para verificar se eh 21 - Liberação de BL, pra cria como type of Occurence: 104
--			if @id_Task = 21
--				Begin
--					Insert hist_geral

--						select 
--							Num_Proc,(select isnull(max(hsgseq),0)+1 from hist_Geral where hsgprocesso=num_proc) Seq,null,
--							104,Mensagem + convert(varchar(10),dt_Conclusao,103) +' , histórico gerado por  ' + Nome_usuario ,getdate(),null,'ATL' Usuario,
--							null,'S','U',null
--						from 
--							Tarefas_Processos TP
--							Join Historico_Auto HA on HA.id_Task=TP.id_task and left(TP.num_proc,2)=HA.Modal and HA.ativo='S' and (cd_pes_Grupo=@Grupo or cd_pes_grupo='10017')
--							Left Join Usuario US on US.cd_usuario=isnull(tp.cd_usuario,'ATL')
--						where
--							num_proc=@processo and tp.id_task=@id_Task
--				End
			
--			--incluido para colocar os numeros dos containers na solicitação de inspeção
--			--o usuario solicitou pra qdo incluir a inspeçoões ja atualize o task
--			--stored: [spATL_InspecaoDeMadeira_Upd]				
--			--else if @id_Task = 163
--			--	Begin
--			--		Insert hist_geral
--			--			select 
--			--				Num_Proc,(select isnull(max(hsgseq),0)+1 from hist_Geral where hsgprocesso=num_proc) Seq,null,
--			--				44,
--			--				Mensagem + [dbo].[fBusca_Containers_Inspecao](@processo) + ' ' + convert(varchar(10),dt_Conclusao,103) + ' , histórico gerado por  ' + Nome_usuario ,
--			--				getdate(),null,'ATL' Usuario,
--			--				null,'S','U',null
--			--			from 
--			--				Tarefas_Processos TP
--			--				Join Historico_Auto HA on HA.id_Task=TP.id_task and left(TP.num_proc,2)=HA.Modal and HA.ativo='S' and (cd_pes_Grupo=@Grupo or cd_pes_grupo='10017')
--			--				Left Join Usuario US on US.cd_usuario=isnull(tp.cd_usuario,'ATL')
--			--			where
--			--				num_proc=@processo and tp.id_task=@id_Task
--			--	End
--			else
--				Begin
--					Insert hist_geral
--						select 
--							Num_Proc,(select isnull(max(hsgseq),0)+1 from hist_Geral where hsgprocesso=num_proc) Seq,null,
--							44,Mensagem + convert(varchar(10),dt_Conclusao,103) +' , histórico gerado por  ' + Nome_usuario ,getdate(),null,'ATL' Usuario,
--							null,'S','U',null
--						from 
--							Tarefas_Processos TP
--							Join Historico_Auto HA on HA.id_Task=TP.id_task and left(TP.num_proc,2)=HA.Modal and HA.ativo='S' and (cd_pes_Grupo=@Grupo or cd_pes_grupo='10017')
--							Left Join Usuario US on US.cd_usuario=isnull(tp.cd_usuario,'ATL')
--						where
--							num_proc=@processo and tp.id_task=@id_Task
--							and HA.id_Task <> 163
--							--outra função faz o 163, direto no codigo de frmHIM
--				End
				
--			Begin 
--				Insert Tarefas_Processos_Alerta 
--					select distinct
--						TP.Num_Proc,TP.id_Task,TP.dt_conclusao,TP.dt_previsao, TP.cd_usuario, getdate()							
--					from 
--						Tarefas_Processos TP
--						join Alerta_Email_Doc_Automatico A on A.id_task = TP.ID_Task						
--					where
--						TP.num_proc=@processo and tp.id_task=@id_Task
--						and left(@processo,2) = A.MODAL
--						and A.cd_pes_grupo = @Grupo
--						and A.ativo = 1
--			End
--			if @id_Task = 63 and @Grupo in ('1','P20904')  
--				Begin
				
--					update Tarefas_Processos set Dt_Conclusao = @Dt_Conclusao, Cd_Usuario = 'ATL'
--					where ID_Task = 16 and Num_Proc = @Processo and Dt_Conclusao is null
				
--				End
--		END
		
--		--select * from Tarefas_Processos_Alerta 
--		--select * from Alerta_Email_Doc_Automatico


GO
ALTER TABLE [dbo].[Tarefas_Processos] ENABLE TRIGGER [TrgProcessoTarefas_UpdN]
GO
