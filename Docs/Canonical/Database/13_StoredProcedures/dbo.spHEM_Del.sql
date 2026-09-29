SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE            Procedure [dbo].[spHEM_Del] 
		@Processo	VarChar(16)
			
AS
Begin Transaction

If Not Exists (Select Num_Proc_hem from caixa_hou_exp_mar where Num_Proc_Hem = @Processo)
	If Not Exists (Select Num_Proc from item_nota_fiscal where Num_Proc = @Processo)
		Begin

		--Excluindo Tarafas Processo
		--Print 'Tarefas'

			If exists(select num_proc from tarefas_processos where num_proc=@Processo) 
	   			BEGIN
					Delete tarefas_processos where Num_Proc=@Processo
				END
	
		--Excluindo Cta_CTE
		Print 'Cta_CTE'

			If exists(select num_proc_HEM from cta_cte_hou_exp_MAR where num_proc_HEM=@Processo) 
	   			BEGIN
					Delete cta_cte_hou_exp_MAR where num_proc_HEM=@Processo
				END

		--Excluindo Pedido
		Print 'Pedido'
			If exists(select num_proc from Pedido_Ship where num_proc=@Processo) 
	   			BEGIN
					Delete Pedido_Ship where num_proc = @Processo
				END

		--Excluindo Custo
		Print 'Custo'
			If exists(select num_proc from Custo_Cliente where num_proc=@Processo) 
	   			BEGIN
					Delete Custo_Cliente where num_proc = @Processo
				END
		--Excluindo PO
		Print 'PO'
			If exists(select Num_Proc_HEM from PO_HEM where num_proc_HEM=@Processo) 
	   			BEGIN
					Delete PO_HEM where num_proc_HEM = @Processo
				END
		--Excluindo NCM
		Print 'NCM'
			If exists(select Num_Proc from PROC_NCM where num_proc=@Processo) 
	   			BEGIN
					delete Proc_NCM where num_proc = @Processo
				END
		--Excluindo LLP
		Print 'LLP'
			If exists(select num_proc_LEM from LLP_exp_MAR where num_proc_LEM=@Processo) 
			   	BEGIN	
					delete LLP_Exp_Mar where Num_Proc_Lem = @Processo
			   	END

		--Excluindo Docs
		Print 'Docs'
			If exists(select num_proc from Doc_Anexos where num_proc=@Processo) 
			   	BEGIN	
					delete Doc_Anexos where Num_Proc = @Processo
			   	END

		--Job_exp_mar
		Print 'JOB'
			If exists(select num_proc_hEM from Job_exp_MAR where num_proc_hEM=@Processo) 
			   	BEGIN	
					delete job_exp_mar where Num_Proc_hem = @Processo
			   	END



		--Excluindo HOUSE
		Print 'HOUSE'
		If exists(select num_proc_HEM from HOUSE_exp_MAR where num_proc_HEM=@Processo) 
			   	BEGIN	
					delete HOUSE_Exp_Mar where Num_Proc_Hem = @Processo
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
