SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spNota_Fiscal_UPD] 

	@Nota_Fiscal	varchar	(8),
	@Ref_Acesso		char	(1),
	@cd_usuario		Varchar(10)
	
AS

BEGIN TRANSACTION

	begin
		update base_nota_fiscal 
			set cd_status = 2, RPS_Data = Null, dt_cancel = GETDATE(), cd_usuario_cancel = @cd_usuario 
		where 
			ref_acesso = @Ref_Acesso and nota_fiscal = @Nota_Fiscal
    end                
     
    begin            
		update fatura_arg 
			set status = 2 
		where 
			codigo = @Ref_Acesso and numero = @Nota_Fiscal
    end                

	
	IF @@ERROR<>0 
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END
COMMIT TRANSACTION











GO
