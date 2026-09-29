SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO











CREATE  Procedure [dbo].[spHIO_Del] 
		@Processo	VarChar(16)
			
AS
Begin Transaction

If Not Exists (Select Num_Proc_HIO from caixa_hou_imp_out where Num_Proc_HIO = @Processo)
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

			If exists(select num_proc_HIO from cta_cte_hou_imp_out where num_proc_HIO=@Processo) 
	   			BEGIN
					Delete cta_cte_hou_imp_out where num_proc_HIO=@Processo
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
			If exists(select Num_Proc_HIO from PO_HIO where num_proc_HIO=@Processo) 
	   			BEGIN
					Delete PO_HIO where num_proc_HIO = @Processo
				END
		--Excluindo NCM
		Print 'NCM'
			If exists(select Num_Proc from PROC_NCM where num_proc=@Processo) 
	   			BEGIN
					delete Proc_NCM where num_proc = @Processo
				END
		--Excluindo LLP
		Print 'LLP'
			If exists(select num_proc_LIO from LLP_imp_out where num_proc_LIO=@Processo) 
			   	BEGIN	
					delete LLP_imp_out where Num_Proc_LIO = @Processo
			   	END

		--Excluindo Docs
		Print 'Docs'
			If exists(select num_proc from Doc_Anexos where num_proc=@Processo) 
			   	BEGIN	
					delete Doc_Anexos where Num_Proc = @Processo
			   	END

		--Job_imp_out
		--Print 'JOB'
		--	If exists(select num_proc_HIO from Job_imp_out where num_proc_HIO=@Processo) 
		--	   	BEGIN	
		--			delete job_imp_out where Num_Proc_HIO = @Processo
		--	   	END



		--Excluindo HOUSE
		Print 'HOUSE'
		If exists(select num_proc_HIO from HOUSE_imp_out where num_proc_HIO=@Processo) 
			   	BEGIN	
					delete HOUSE_imp_out where Num_Proc_HIO = @Processo
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
