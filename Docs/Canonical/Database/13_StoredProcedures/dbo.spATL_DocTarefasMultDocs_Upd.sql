SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--cadu 30/12 - alterei para mais dias, pq tem pego a dt_creacao, mas nao esta pegando a ultima
--DA.dt_creacao >= GETDATE()-1
--para
--DA.dt_creacao >= GETDATE()-15
--coloquei distinct, pois estava incluindo 2 vezes no historico

--DA.num_proc in ('''+ @JOBAtualizar +''')and 
--Declare @JOBAtualizar varchar(16)
--set @JOBAtualizar = 'IMSCH202009005BR'
CREATE procedure [dbo].[spATL_DocTarefasMultDocs_Upd]

as
Declare @ID_Task int
Declare @ID_DC varchar(50)
Declare @strQuery varchar(max)
Declare @ID_TaskJOB int
Declare @Nome_TaskJOB varchar(50)
Declare @JOB varchar(16)
Declare @Msg_Task varchar(max)
Declare @TempTable table(
	JOB varchar(16),
	ID_TaskJOB int,
	Nome_TaskJOB varchar(50),
	QtyJOB int
)

--Seleciona as regras que contem mais de um Documento por Task
Declare DocTarefas cursor for
select distinct ID_Task,ID_DC from Doc_Tarefas DT  with(nolock) where DT.ID_DC like '%,%'
Open DocTarefas 
	Fetch Next From DocTarefas Into @ID_Task,@ID_DC
		While @@FETCH_STATUS = 0
			Begin
			
			--Conta a quantidade documento por cadastro
			DECLARE @ListaXML XML
			SET @ListaXML = '<c><e>' + REPLACE(@ID_DC,',','</e><e>') + '</e></c>'
			DECLARE @TotalItens INT
			SET @TotalItens = @ListaXML.value('count(/c/e)','INT')
			
			---- Localiza os JOBs, caso quantidade de documento por JOB,seja a mesma do cadastrado (@TotalItens)
			--set @strQuery = ('select DA.Num_Proc, TP.ID_Task, TT.Nome_Task,count(DA.Id_DC)  from Doc_Anexos DA with(nolock)
			--	join Doc_Tarefas DT  with(nolock) on DA.Id_DC in('+ @ID_DC +') and DT.ID_DC like ''%,%'' 
			--	join Tipo_Tarefas TT with(nolock) on DT.ID_Task = TT.ID_Task and TT.Modal = SUBSTRING(DA.num_proc,1,2) 
			--	join Tarefas_Processos TP with(nolock) on DT.ID_Task = TP.ID_Task and DA.Num_Proc = TP.Num_Proc 
			--	join Campo_Processo CP143 with(nolock) on DA.Num_Proc = CP143.Num_Proc and CP143.Id_Campo = 143 
			--	where DA.dt_creacao >= GETDATE()-15 and DT.Modal = SUBSTRING(DA.num_proc,1,2) and TP.Dt_Conclusao is null and DT.Status = 1 and ((DT.ID_PD = 0 and CP143.Campo_Dados <> 0) or DT.ID_PD = CP143.Campo_Dados)
			--	group by TP.ID_Task,  TT.Nome_Task ,DA.Num_Proc
			--	having count(DA.Id_DC) = '+ cast(@TotalItens as varchar(50)) + ' '
			--	)
			--Estava errada a linha do join doc_tarefas, pois estava pegando casos de 3 na linha dos casos de apenas 2 id_dc - updated 01Fev2024 - Cadu 3h22
				set @strQuery = ('select DA.Num_Proc, TP.ID_Task, TT.Nome_Task,count(DA.Id_DC)  from Doc_Anexos DA with(nolock)
				join Doc_Tarefas DT  with(nolock) on DA.Id_DC in('+ @ID_DC +') and DT.ID_DC like ''%,%'' and DT.Id_DC = ('''+ @ID_DC +''')
				join Tipo_Tarefas TT with(nolock) on DT.ID_Task = TT.ID_Task and TT.Modal = SUBSTRING(DA.num_proc,1,2) and TT.ATivo = ''S''
				join Tarefas_Processos TP with(nolock) on DT.ID_Task = TP.ID_Task and DA.Num_Proc = TP.Num_Proc 
				join Campo_Processo CP143 with(nolock) on DA.Num_Proc = CP143.Num_Proc and CP143.Id_Campo = 143 
				where DA.dt_creacao >= GETDATE()-60 and DT.Modal = SUBSTRING(DA.num_proc,1,2) and TP.Dt_Conclusao is null and DT.Status = 1 and ((DT.ID_PD = 0 and CP143.Campo_Dados <> 0) or DT.ID_PD = CP143.Campo_Dados)
				group by TP.ID_Task,  TT.Nome_Task ,DA.Num_Proc
				having count(DA.Id_DC) = '+ cast(@TotalItens as varchar(50)) + ' '
				)
			
			-- Inclui os JOB que devem ter o task preenchido
			insert @TempTable
			exec (@strQuery)
			
			-- Preenche os task dos JOB com todos os Documento anexados
			Declare DocTarefasJOB cursor for	
				select distinct JOB,ID_TaskJOB,Nome_TaskJOB from @TempTable
					Open DocTarefasJOB 
						Fetch Next From DocTarefasJOB Into @JOB,@ID_TaskJOB,@Nome_TaskJOB
							While @@FETCH_STATUS = 0
								Begin
								
									update Tarefas_Processos set Dt_Conclusao = GETDATE(), Cd_Usuario = 'ATL'
									where ID_Task = @ID_TaskJOB and Dt_Conclusao is null and Num_Proc =@JOB 
									
									Set @Msg_Task =(select 'Task: ' + @Nome_TaskJOB + ', concluido automaticamente após inclusão dos Documentos: ' + @ID_DC + ' - ' + convert(varchar(10),getdate(),103) + ' ' + convert(varchar(30),getdate(),114))
									Insert hist_geral
										select 
											@JOB,(select isnull(max(hsgseq),0)+1 from hist_Geral with(nolock) where hsgprocesso=@JOB) Seq,null,
											108,@Msg_Task + ' , histórico gerado por ' + 'ATL System' ,
											getdate(),null,'ATL' Usuario,null,'N','U',null
								
								print  @JOB
								
								Fetch Next From DocTarefasJOB Into @JOB,@ID_TaskJOB,@Nome_TaskJOB
								End
								close DocTarefasJOB
								deallocate DocTarefasJOB					
	Fetch Next From DocTarefas Into @ID_Task,@ID_DC
	End
close DocTarefas
deallocate DocTarefas


GO
