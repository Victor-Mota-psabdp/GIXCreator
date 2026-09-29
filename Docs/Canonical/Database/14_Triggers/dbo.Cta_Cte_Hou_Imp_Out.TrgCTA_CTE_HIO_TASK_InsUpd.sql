SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TrgCTA_CTE_HIO_TASK_InsUpd] ON [dbo].[Cta_Cte_Hou_Imp_Out]
FOR INSERT,UPDATE
AS
	Declare @Processo varchar(16)
	Select @Processo = Num_Proc_HIO from inserted
	 
	Declare @Cd_Tp_Tx varchar(6)
	Select @Cd_Tp_Tx = Cd_Tp_Tx from inserted 
	
--Rosangela:
--2º. ATL -> ABA -> Conta Corrente -> Charge Name -> Adiantamento Cliente - CHB (1) -> Task "Solicitação de Numerário"
--By including the "Customer Advance" the Task "Cash Request" will be filled automatically; 

--XBA	 - Adiantamento Cliente - CHB (1)
--59	Solicitação de Numerário
	
	if (@Cd_Tp_Tx = 'XBA')
	BEGIN
		DEclare @data datetime
		set @data = (select GETDATE())
		
		BEGIN				
			if exists(select Num_Proc from Tarefas_Processos with(nolock) where Num_Proc = @Processo	and Dt_Conclusao is null 
			and ID_Task = 59)	
				Begin
					UPDATE 
						TAREFAS_PROCESSOS
					SET
						Dt_Conclusao=@data,
						Cd_Usuario='ATL'
					WHERE
						Num_Proc=@Processo 
						and id_task=59
				End				
				exec dbo.[spHistG_InsUPD] @Processo,Null ,Null,'CSR','Task: Solicitação de Numerário preenchido pela inclusão da TAXA: Adiantamento Cliente - CHB (1)' ,@data,null ,'ATL System','N','U',null 	
		END			
	END







GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Imp_Out] ENABLE TRIGGER [TrgCTA_CTE_HIO_TASK_InsUpd]
GO
