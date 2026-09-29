SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spLogImpDadosBancarios_InsUpd]
	
	@num_lcto_mov		varchar(12),
	@cd_banco			varchar(3),
	@cd_agencia			varchar(5),
	@num_cta_cte		varchar(20),
	@dc_mov				char(1),
	@Dt_Pgto_Rcto_Mov	varchar(10),
	@Vlr_Doc_Mov		decimal(10,2),
	@Concil_Mov			char(1),
	@Dt_Ctb_Mvto		varchar(10),
	@historico			varchar(300),	
	@tipo_oper_mov		char(1),
	@Usuario			varchar(50)

AS

	Declare @cd_usuario varchar(3)	

	set @cd_usuario = (select cd_usuario from usuario where nome_usuario = @usuario)

	Begin Transaction

Insert Into 
		log_mvto_cta_cte
		(num_lcto_mov, cd_banco, cd_agencia, num_cta_cte, dc_mov, Dt_Pgto_Rcto_Mov, Vlr_Doc_Mov, Concil_Mov, 
		 Dt_Ctb_Mvto, historico,data_mov, tipo_oper_mov, cd_usuario)
	Values 
		(@num_lcto_mov, @cd_banco, @cd_agencia, @num_cta_cte, @dc_mov, @Dt_Pgto_Rcto_Mov, @Vlr_Doc_Mov, @Concil_Mov,
		@Dt_Ctb_Mvto, @historico, getDate(), @tipo_oper_mov, @cd_usuario)		

	If @@RowCount <> 1 
		Begin 
			RollBack Transaction 
			Return -1 
		End 	
Commit Transaction

GO
