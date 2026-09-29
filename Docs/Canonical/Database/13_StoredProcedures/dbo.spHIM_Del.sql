SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO











CREATE              Procedure [dbo].[spHIM_Del] --'IMCSR20080100101'

 

		@Processo	VarChar(16)
			
AS
Begin Transaction

If Not Exists (Select Num_Proc_HIM from caixa_hou_imp_MAR where Num_Proc_HIM = @Processo)
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

			If exists(select num_proc_HIM from cta_cte_hou_imp_MAR where num_proc_HIM=@Processo) 
	   			BEGIN
					Delete cta_cte_hou_imp_MAR where num_proc_HIM=@Processo
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
			If exists(select Num_Proc_HIM from PO_HIM where num_proc_HIM=@Processo) 
	   			BEGIN
					Delete PO_HIM where num_proc_HIM = @Processo
				END
		--Excluindo NCM
		Print 'NCM'
			If exists(select Num_Proc from PROC_NCM where num_proc=@Processo) 
	   			BEGIN
					delete Proc_NCM where num_proc = @Processo
				END
		--Excluindo LLP
		Print 'LLP'
			If exists(select num_proc_LIM from LLP_imp_MAR where num_proc_LIM=@Processo) 
			   	BEGIN	
					delete LLP_imp_MAR where Num_Proc_LIM = @Processo
			   	END

		--Excluindo Docs
		Print 'Docs'
			If exists(select num_proc from Doc_Anexos where num_proc=@Processo) 
			   	BEGIN	
					delete Doc_Anexos where Num_Proc = @Processo
			   	END

		--Job_imp_MAR
		Print 'JOB'
			If exists(select num_proc_HIM from Job_imp_MAR where num_proc_HIM=@Processo) 
			   	BEGIN	
					delete job_imp_MAR where Num_Proc_HIM = @Processo
			   	END



		--Excluindo HOUSE
		Print 'HOUSE'
		If exists(select num_proc_HIM from CONTAINER_HOU_IMP_MAR where num_proc_HIM=@Processo) 
			   	BEGIN	
					delete CONTAINER_HOU_imp_MAR where Num_Proc_HIM = @Processo
		 	  	END


		If exists(select num_proc_HIM from HOUSE_imp_MAR where num_proc_HIM=@Processo) 
			   	BEGIN	
					delete HOUSE_imp_MAR where Num_Proc_HIM = @Processo
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
