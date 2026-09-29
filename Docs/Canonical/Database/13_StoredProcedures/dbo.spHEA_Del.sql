SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE          Procedure [dbo].[spHEA_Del] 
		@Processo	VarChar(16)
			
AS
Begin Transaction

If Not Exists (Select Num_Proc_HEA from caixa_hou_exp_AER where Num_Proc_HEA = @Processo)
	If Not Exists (Select Num_Proc from item_nota_fiscal where Num_Proc = @Processo)
		Begin

		--Excluindo Tarafas Processo
		--Print 'Tarefas'

			If exists(select num_proc from tarefas_processos where num_proc=@Processo) 
	   			BEGIN
					Delete tarefas_processos where Num_Proc=@Processo
				END
	
		--Excluindo Cta_CTE
		--Print 'Cta_CTE'

			If exists(select num_proc_HEA from cta_cte_hou_exp_AER where num_proc_HEA=@Processo) 
	   			BEGIN
					Delete cta_cte_hou_exp_AER where num_proc_HEA=@Processo
				END

		--Excluindo Pedido
		--Print 'Pedido'
			If exists(select num_proc from Pedido_Ship where num_proc=@Processo) 
	   			BEGIN
					Delete Pedido_Ship where num_proc = @Processo
				END

		--Excluindo Custo
		--Print 'Custo'
			If exists(select num_proc from Custo_Cliente where num_proc=@Processo) 
	   			BEGIN
					Delete Custo_Cliente where num_proc = @Processo
				END
		--Excluindo PO
		--Print 'PO'
			If exists(select Num_Proc_HEA from PO_HEA where num_proc_HEA=@Processo) 
	   			BEGIN
					Delete PO_HEA where num_proc_HEA = @Processo
				END
		--Excluindo NCM
		--Print 'NCM'
			If exists(select Num_Proc from PROC_NCM where num_proc=@Processo) 
	   			BEGIN
					delete Proc_NCM where num_proc = @Processo
				END
		--Excluindo LLP
		--Print 'LLP'
			If exists(select num_proc_LEA from LLP_exp_AER where num_proc_LEA=@Processo) 
			   	BEGIN	
					delete LLP_Exp_AER where Num_Proc_LEA = @Processo
			   	END

		--Excluindo Docs
		--Print 'Docs'
			If exists(select num_proc from Doc_Anexos where num_proc=@Processo) 
			   	BEGIN	
					delete Doc_Anexos where Num_Proc = @Processo
			   	END

		--Job_exp_AER
		--Print 'JOB'
			If exists(select num_proc_HEA from Job_exp_AER where num_proc_HEA=@Processo) 
			   	BEGIN	
					delete job_exp_AER where Num_Proc_HEA = @Processo
			   	END



		--Excluindo HOUSE
		--Print 'HOUSE'
		If exists(select num_proc_HEA from HOUSE_exp_AER where num_proc_HEA=@Processo) 
			   	BEGIN	
					delete HOUSE_Exp_AER where Num_Proc_HEA = @Processo
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
