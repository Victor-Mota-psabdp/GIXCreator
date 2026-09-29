SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_InspecaoDeMadeira_Upd]

	@Num_Proc	varchar(16),
	@cd_usuario varchar(10)

as

Declare @Grupo Varchar(10)
set @Grupo=(select top 1 cd_pes_grupo from Grupo where substring(@Num_Proc,3,3)=Grupo)
Declare @Funcao Varchar(10)
--Inpeção de Madeira- Incluir o Task
Declare @Dt_Conclusao	Datetime
set @Dt_Conclusao = (select Dt_Conclusao from Tarefas_Processos where Num_Proc =@Num_Proc and ID_Task = 163)
set @Funcao = (select [dbo].[fBusca_Containers_Inspecao](@Num_Proc))
if @Dt_Conclusao is null
	BEGIN
		update Tarefas_Processos set Dt_Conclusao = GETDATE(),Cd_Usuario = @cd_usuario
			 where Num_Proc =@Num_Proc and ID_Task = 163
	END		
	
if @Funcao is not null	
	BEGIN
		--incluido para colocar os numeros dos containers na solicitação de inspeção			
		insert hist_geral
				select 
					Num_Proc,(select isnull(max(hsgseq),0)+1 from hist_Geral where hsgprocesso=@Num_Proc) Seq,null,
					106,
					Mensagem + [dbo].[fBusca_Containers_Inspecao](@Num_Proc) + ' ' + convert(varchar(10),dt_Conclusao,103) + ' , histórico gerado por  ' + Nome_usuario ,
					getdate(),null,'ATL' Usuario,null,'S','U',null
				from 
					Tarefas_Processos TP
					Join Historico_Auto HA on HA.id_Task=TP.id_task and left(TP.num_proc,2)=HA.Modal and HA.ativo='S' and (cd_pes_Grupo=@Grupo or cd_pes_grupo='10017')
					Left Join Usuario US on US.cd_usuario=isnull(tp.cd_usuario,'ATL')
				where
					num_proc=@Num_Proc and tp.id_task=163
	
	--insert o log dos conteiners q já foram solicitados pra inspeção
	insert into Container_LOG_Imp_Mar
		select MAS.Num_Proc_MIM, MAS.Item_Cont_IM, MAS.Num_Cont_IM , getdate() from container_mas_imp_mar MAS
     		join container_hou_imp_mar HOU on HOU.Item_Cont_IM = MAS.Item_Cont_IM and MAS.Num_Proc_MIM = HOU.Num_Proc_MIM
     		where 
     		HOU.Num_Proc_HIM = @Num_Proc
     		and isnull(MAS.inspecao,'N') = 'S'     	
     		and MAS.dt_ins >= dateadd(minute, -10, getdate())
     		
	END		
			
GO
