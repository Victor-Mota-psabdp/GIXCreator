SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



create Procedure [dbo].[spMEM_Del] --'IMCSR20080100101'
	@Processo	VarChar(16)		
AS

Begin Transaction

If Not Exists (Select Num_Proc_MEM from caixa_Mas_Exp_MAR where Num_Proc_MEM = @Processo)

	Begin
		--Excluindo Tarefas_Master
		Print 'Tarefas'
		If exists(select num_proc from tarefas_master where num_proc=@Processo) 
   			BEGIN
				Delete tarefas_master where Num_Proc=@Processo
			END
		--Excluindo Cta_CTE
		Print 'Cta_CTE'
		If exists(select num_proc_MEM from cta_cte_mas_Exp_MAR where num_proc_MEM=@Processo) 
   			BEGIN
				Delete cta_cte_mas_Exp_MAR where num_proc_MEM=@Processo
			END
		--Excluindo References
		Print 'PO'
		If exists(select Num_Proc_Master from PO_Master where num_proc_master=@Processo) 
   			BEGIN
				Delete PO_Master where num_proc_master = @Processo
			END
		--Excluindo LLP
		Print 'LLP'
		If exists(select num_proc_Master from LLP_Master where num_proc_master=@Processo) 
		   	BEGIN	
				delete LLP_Master where Num_Proc_Master = @Processo
		   	END
		--Excluindo HOUSE
		Print 'HOUSE'
		If exists(select num_proc_MEM from Master_Exp_MAR where num_proc_MEM=@Processo) 
		   	BEGIN	
				delete Master_Exp_MAR where Num_Proc_MEM = @Processo
	 	  	END
	End

		IF @@Error <> 0
		BEGIN
			PRINT 'ERRADO'
			ROLLBACK TRANSACTION
			RETURN -1
		END

Commit Transaction					
			


















GO
