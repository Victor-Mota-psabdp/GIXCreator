SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_DLL_Task_Automatico_Ins]--'IAATL201709037BR','COOPER STAN - 2886C','2017-10-05''05/10/2017'
	@num_proc	varchar(16),
	@cd_pes_grupo as varchar(10),
	@DL			datetime	
as

	Declare @StrData		datetime		
	Declare @ID_Task		int
	Declare @JOB			varchar(16)	

--	Define o Modal
	Declare @modal as varchar(2)
	set @modal = LEFT(@num_proc,2)								
--Declare a tabela pra armazenar o que deve ser incluido no Task						
	Declare @TAB Table 
			(
			[Tipo_Data]		varchar(6),
			[Dias]			float,
			[StrData]		datetime,			
			[ID_Task]		int,
			[JOB]			varchar(16)									
			)
	Begin
		Insert into @TAB
			select distinct	
				TT.Tipo_Data,
				TT.Dias,		
				(Case 
					when Tipo_Data = 'ETA' then				
						isnull(LIA.ETA_LIA,ISNULL(LIM.ETA_Lim,ISNULL(LIO.ETA_Lio,ISNULL(LEA.ETA_Lea,ISNULL(LEM.ETA_Lem,LEO.ETA_Leo))))) + TT.Dias
					else (Case when Tipo_Data = 'ETD' then	
							isnull(LIA.ETD_LIA,ISNULL(LIM.ETD_Lim,ISNULL(LIO.ETD_Lio,ISNULL(LEA.ETD_Lea,ISNULL(LEM.ETD_Lem,LEO.ETD_Leo)))))+ TT.Dias
					else (Case when Tipo_Data = 'DL' and @DL <> '' then
							@DL + TT.Dias
					else (Case when Tipo_Data = 'DL' and @DL = '' then
								isnull(LIA.ETA_LIA,ISNULL(LIM.ETA_Lim,ISNULL(LIO.ETA_Lio,ISNULL(LEA.ETA_Lea,ISNULL(LEM.ETA_Lem,LEO.ETA_Leo))))) + 10 + TT.Dias
					else	
						GETDATE() end)end)end)end) [strData],			
				TT.id_task,
				@num_proc
			from 
				tipo_tarefas TT
				left join LLP_Imp_Aer LIA with (nolock) on  LIA.Num_Proc_Lia = @num_proc
				left join LLP_Imp_Mar LIM with (nolock) on  LIM.Num_Proc_Lim = @num_proc
				left join LLP_Imp_Out LIO with (nolock) on  LIO.Num_Proc_Lio = @num_proc		
				left join LLP_Exp_Aer LEA with (nolock) on  LEA.Num_Proc_Lea = @num_proc
				left join LLP_Exp_Mar LEM with (nolock) on  LEM.Num_Proc_Lem = @num_proc
				left join LLP_Exp_Out LEO with (nolock) on  LEO.Num_Proc_Leo = @num_proc
				left join LLP_BDP_OUT LBO with (nolock) on  LBO.Num_Proc_LBO = @num_proc
			where
				ativo='S' 
				and modal=@modal 
				and (cd_pes_grupo = @cd_pes_grupo  or cd_pes_grupo='10017') 
				and id_task not in (select id_task from tarefas_processos with (nolock) where num_proc=@num_proc)
			order by TT.ID_Task
	End
	
--select * from @TAB

--Faz um for pra incluir linha a linha do select
Declare C_JOBs cursor for
--
		Select [JOB],[StrData],[ID_Task] from @TAB
		
Open C_JOBs 
SET NOCOUNT ON
Fetch Next From C_JOBS Into @JOB,@StrData,@ID_Task
	While @@FETCH_STATUS = 0
		Begin
			insert into tarefas_processos 
				--values(@JOB,@ID_Task,null,@StrData,Null,Null)	--208 esta assim
				values(@JOB,@ID_Task,null,@StrData,Null,NULL)		--226 esta assim
							
Fetch Next From C_JOBS Into @JOB,@StrData,@ID_Task
		End
	
close C_JOBS
deallocate C_JOBS
GO
