SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--76 - Faturamento Criado
--select convert(date,Dt_Conclusao,103),convert(date,GETDATE(),103)
-- from TAREFAS_PROCESSOS where Num_Proc = 'IMCSR201902835BR' and id_task=76
--select * from TAREFAS_PROCESSOS where id_task=76 and Num_Proc = 'EMRHO201808003BR' 
--select convert(date,GETDATE(),103) from TAREFAS_PROCESSOS where id_task=76
--and Num_Proc = 'EMRHO201808003BR'
--and 
--(
--	convert(date,Dt_Conclusao,103) <  convert(date,GETDATE(),103)
--or
--	Dt_Conclusao is null
--)

CREATE TRIGGER [dbo].[TrgFatura_CHB_Item_INS] ON [dbo].[Fatura_CHB_Item] 
FOR INSERT,UPDATE
AS

	Declare @Fatura_CC	varchar(17)	
	Select @Fatura_CC = Fatura_CC from inserted
			
	if exists(select Processo_PC from fatura_chb with(nolock) where Fatura_PC = @Fatura_CC and cd_tipo = 'P')
		Begin 
			UPDATE 
				TAREFAS_PROCESSOS
			SET
				Dt_Conclusao=GETDATE(),
				cd_usuario = 'ATL'					
			WHERE
				Num_Proc=left(@Fatura_CC,16) and id_task=76
				and 
				(
					convert(date,Dt_Conclusao,103) <  convert(date,GETDATE(),103)
				or 
					Dt_Conclusao is null
				)
		End
		
	if exists(select Processo_PC from fatura_chb with(nolock) where 
		Fatura_PC = @Fatura_CC and cd_tipo = 'C' and LEFT(@Fatura_CC,2) ='BO')
		Begin 
			UPDATE 
				TAREFAS_PROCESSOS
			SET
				Dt_Conclusao=GETDATE(),
				cd_usuario = 'ATL'					
			WHERE
				Num_Proc=left(@Fatura_CC,16) and id_task=76
				and 
				(
					convert(date,Dt_Conclusao,103) <  convert(date,GETDATE(),103)
				or 
					Dt_Conclusao is null
				)
		End
		

GO
ALTER TABLE [dbo].[Fatura_CHB_Item] ENABLE TRIGGER [TrgFatura_CHB_Item_INS]
GO
