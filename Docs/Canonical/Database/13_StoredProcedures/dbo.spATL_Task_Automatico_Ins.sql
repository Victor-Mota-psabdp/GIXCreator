SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select ETD_Lim,ETA_Lim from LLP_Imp_Mar where Num_Proc_Lim = 'IMATL201310012BR'
--2013-10-03 00:00:00.000	2013-10-26 00:00:00.000
--spATL_Task_Automatico_Ins 'EAATL201406001BR','BRALYX MAQU - 1741C',''
--spATL_Task_Automatico_Ins 'EAATL201406002BR','BRALYX MAQU - 1741C','2014-06-20'
--[spATL_Task_Automatico_Ins]'IAATL201709037BR','COOPER STAN - 2886C','2017-10-05'

CREATE procedure [dbo].[spATL_Task_Automatico_Ins]--'IAATL201709037BR','COOPER STAN - 2886C','2017-10-05''05/10/2017'
	@num_proc	varchar(16),
	@Cliente	varchar(30),
	@DL			datetime	
as

	Declare @StrData		datetime		
	Declare @ID_Task		int
	Declare @JOB			varchar(16)	

--	Define o Modal
	Declare @modal as varchar(2)
	set @modal = LEFT(@num_proc,2)
--Define o cd_pes_grupo pra achar o task pro grupo
	Declare @cd_pes_grupo as varchar(10)
	set @cd_pes_grupo = (select PL.cd_pes_grupo from Pessoa_LLP PL with (nolock)  
								join pessoa P with (nolock) on P.cd_pes=PL.cd_pes
								join Grupo G with (nolock) on G.cd_Pes_Grupo=PL.Cd_Pes_Grupo
								where apelido = @Cliente)
								
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
