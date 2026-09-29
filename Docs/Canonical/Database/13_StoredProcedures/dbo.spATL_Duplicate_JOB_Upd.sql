SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from Campo_Processo where Num_Proc = 'IMCSR201709132BR' and Id_Campo = 143
--select * from Campo_Processo where Num_Proc = 'IMCSR201709133BR' and Id_Campo = 143
CREATE procedure [dbo].[spATL_Duplicate_JOB_Upd]
(
	@num_proc_old varchar(16),
	@num_proc_new as varchar(16),
	@cd_usuario as varchar(6)
)
as	
		-- BDP PRODUCT - 143
		--DESPACHO - 32	
		--NECESSIDADE DE LI - 5
		--TIPO DE LI - 95
		--SELECT * FROM Tipo_Campo_Cliente WHERE Id_Campo in (143,5,32,95)
		
		if exists(SELECT distinct Num_Proc from Campo_Processo 
			where Num_Proc = @num_proc_old and Id_Campo in (143,5,32,95))
		BEGIN
		INSERT Campo_Processo 
			SELECT @num_proc_new,Id_Campo,Campo_Dados,getdate(),@cd_usuario	from Campo_Processo 
			where Num_Proc = @num_proc_old and Id_Campo in (143,5,32,95)	
		END	
		
		

	

--** REF. ADIC.
--- INVOICE CURRENCY
declare @currency as varchar(6)
	set @currency = (select[dbo].[fBusca_CampoLLP] (@num_proc_old,'Cd_Moeda_Invoice'))
	
if @currency <> ''
	begin
		exec [spReferenciasDiversas_InsUPD]@num_proc_new,'Cd_Moeda_Invoice',@currency
	end 
	

	

GO
