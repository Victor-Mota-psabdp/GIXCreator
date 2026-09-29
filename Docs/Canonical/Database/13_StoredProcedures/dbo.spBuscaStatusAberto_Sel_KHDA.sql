SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from JOB_Open
----XXXXXXXX para incluir na tabela XXXXXXXXXXXXXXX
--insert into JOB_Open
--Select distinct 
--	LLP.Num_Proc Num_Proc,'100-112102','Leonardo Silva',GETDATE(),null
--	From vwClienteALLJOBS LLP With(nolock)	
--	Where		
--		LLP.ID_Status in ('8','5')and 
--		LLP.num_proc in ('IAMTE201710010BR',
--'IACSR201710025BR')
--spBuscaStatusAberto_Sel_KHDA 9


--select * from vwClienteALLJOBS where Num_Proc = 'EMRHO201604002BR'
CREATE PROCEDURE [dbo].[spBuscaStatusAberto_Sel_KHDA] --spBuscaStatusAberto_Sel_KHDA 9
		@ID_Status int

AS

Declare @Status Varchar(50)
Set @Status= (select cast(ID_Status as varchar(3)) + ' - ' + Status_Descricao from tipo_status_processo With(nolock) where id_status=@id_status)

if @Id_Status = 4
--if @Id_Status = 8
--- Para alterar o status manualmente - Usar o Codigo \\192.168.11.252\ti$\Desenv\IT\Projetos_Andamento\VS_2005\Rafa\AtualizaStatus\AtualizaStatus
	BEGIN
		Select distinct
		LLP.Num_Proc Num_Proc,
		--@Id_Status Status
		@Status  Status,
		SD.Ticket,
		SD.User_Name
		From vwClienteALLJOBS LLP With(nolock)
			--Join Campo_Processo		CP With(Nolock) on CP.num_proc=LLP.Num_Proc and Id_Campo=143
			join JOB_Open	SD With(Nolock) on LLP.num_proc = SD.Num_Proc
			--left Join Tarefas_Processos	TP40 With(Nolock) on TP40.num_Proc=LLP.Num_Proc and TP40.Id_Task=40
			--left Join Tarefas_Processos	TP76 With(Nolock) on TP76.num_Proc=LLP.Num_Proc and TP76.Id_Task=76	
			--left join Log_Status LO With(Nolock) on LLP.Num_Proc = LO.num_proc and LO.ID_status = 8			
		Where 
			--(Campo_Dados=1 or Campo_Dados = 3) 	
			--and (TP40.DT_Conclusao Is Not Null  or TP76.DT_Conclusao Is Not Null)		
			--and Isnull(LLP.ID_STatus,0)<=4
			--LO.dt_ins < GETDATE()- 2 and
			--LO.num_proc is n
			LLP.ID_Status in ('8','5','9')
			--LLP.ID_Status in ('5')
			--and LLP.num_proc in ('IMOXT201706053BR')
			and sd.Dt_Upd is null
	END
	
--if @Id_Status = 9
----- Para alterar o status manualmente - Usar o Codigo \\192.168.11.252\ti$\Desenv\IT\Projetos_Andamento\VS_2005\Rafa\AtualizaStatus\AtualizaStatus
--	BEGIN
--		Select distinct
--		LLP.Num_Proc Num_Proc,
--		--@Id_Status Status
--		@Status  Status,
--		SD.Ticket,
--		SD.User_Name
--		From vwClienteALLJOBS LLP With(nolock)
--			--Join Campo_Processo		CP With(Nolock) on CP.num_proc=LLP.Num_Proc and Id_Campo=143
--			join JOB_Open	SD With(Nolock) on LLP.num_proc = SD.Num_Proc
--			--left Join Tarefas_Processos	TP40 With(Nolock) on TP40.num_Proc=LLP.Num_Proc and TP40.Id_Task=40
--			--left Join Tarefas_Processos	TP76 With(Nolock) on TP76.num_Proc=LLP.Num_Proc and TP76.Id_Task=76	
--			--left join Log_Status LO With(Nolock) on LLP.Num_Proc = LO.num_proc and LO.ID_status = 8			
--		Where 
--			--(Campo_Dados=1 or Campo_Dados = 3) 	
--			--and (TP40.DT_Conclusao Is Not Null  or TP76.DT_Conclusao Is Not Null)		
--			--and Isnull(LLP.ID_STatus,0)<=4
--			--LO.dt_ins < GETDATE()- 2 and
--			--LO.num_proc is n
--			--LLP.ID_Status in ('8','5','9')
--			LLP.ID_Status in ('4')
--			--and LLP.num_proc in ('IMOXT201706053BR')
--			and sd.Dt_Upd is null
--	END
	
--if @Id_Status = 5
----if @Id_Status = 8
----- Para alterar o status manualmente - Usar o Codigo \\192.168.11.252\ti$\Desenv\IT\Projetos_Andamento\VS_2005\Rafa\AtualizaStatus\AtualizaStatus
--	BEGIN
--		Select distinct
--		LLP.Num_Proc Num_Proc,
--		--@Id_Status Status
--		@Status  Status,
--		SD.Ticket,
--		SD.User_Name
--		From vwClienteALLJOBS LLP With(nolock)
--			--Join Campo_Processo		CP With(Nolock) on CP.num_proc=LLP.Num_Proc and Id_Campo=143
--			join JOB_Open	SD With(Nolock) on LLP.num_proc = SD.Num_Proc
--			--left Join Tarefas_Processos	TP40 With(Nolock) on TP40.num_Proc=LLP.Num_Proc and TP40.Id_Task=40
--			--left Join Tarefas_Processos	TP76 With(Nolock) on TP76.num_Proc=LLP.Num_Proc and TP76.Id_Task=76	
--			--left join Log_Status LO With(Nolock) on LLP.Num_Proc = LO.num_proc and LO.ID_status = 8			
--		Where 
--			--(Campo_Dados=1 or Campo_Dados = 3) 	
--			--and (TP40.DT_Conclusao Is Not Null  or TP76.DT_Conclusao Is Not Null)		
--			--and Isnull(LLP.ID_STatus,0)<=4
--			--LO.dt_ins < GETDATE()- 2 and
--			--LO.num_proc is n
--			LLP.ID_Status not in ('8','5','9')
--			--LLP.ID_Status in ('5')
--			--and LLP.num_proc in ('IMOXT201706053BR')
--			and sd.Dt_Upd is null
--	END
	

--delete Job_Temp where num_proc = 'IAGVD201604025BR'
--select * from usuario	where nome_usuario like 'diego%'
--select distinct vw.num_proc, vw.ID_Status from job_Temp ST
--join vwClienteALLJOBS VW on ST.job = VW.num_proc --and ID_Status not in (8)
--where num_proc = 'IAATL201608047BR'
--delete Job_temp
--select * from Job_temp
--rafa alterei alguma coisa pq o user pediu p mudar p o status 8

--select * from JOB_Open
----XXXXXXXX para incluir na tabela XXXXXXXXXXXXXXX
--insert into JOB_Open
--Select distinct 
--	LLP.Num_Proc Num_Proc,'100-112102','Leonardo Silva',GETDATE(),null
--	From vwClienteALLJOBS LLP With(nolock)	
--	Where		
--		LLP.ID_Status in ('8','5')and 
--		LLP.num_proc in ('IAMTE201710010BR',
--'IACSR201710025BR')



GO
