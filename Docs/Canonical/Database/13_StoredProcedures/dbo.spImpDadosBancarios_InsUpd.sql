SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- spImpDadosBancarios_InsUpd '001','3617X','6546-3','D','23/11/2009','92663.82','N','SISCOMEX PROT 1106367003','I','Carlos Eduardo'

CREATE procedure [dbo].[spImpDadosBancarios_InsUpd]--'001','3617X','6546-3','D','23/11/2009','92663.82','N','SISCOMEX PROT 1106367003','I','Carlos Eduardo'

	@cd_banco			varchar(3),
	@cd_agencia			varchar(5),
	@num_cta_cte		varchar(20),
	@dc_mov				char(1),
	@Dt_Pgto_Rcto_Mov	varchar(10),
	@Vlr_Doc_Mov		decimal(10,2),
	@Concil_Mov			char(1),		
	@historico			varchar(300),
	@tipo_oper_mov		char(1),
	@usuario			varchar(30),
	@Num_lcto_movN		varchar(13) output

AS
	Begin Transaction
	
	declare @cd_usuario varchar(3)

	set @cd_usuario=(select cd_usuario from usuario where nome_usuario=@usuario)

	Declare @novo  varchar(13)
	set @novo = (select cast(isnull(max(right(num_lcto_mov,4)),0) + 1 as varchar(5)) FROM mvto_cta_cte where left(num_lcto_mov,2) <> 'MA' and left(num_lcto_mov,8) = 'MB' + CAST(YEAR(GETDATE()) AS VARCHAR(4)) + RIGHT('0'+ CAST(MONTH(GETDATE()) AS VARCHAR(2)),2))
	set @novo = '00000' + @novo
	set @novo = 'MB' + convert(varchar,year(getdate()),4) + right('0' + convert(varchar,month(getdate()),2),2) + right(@novo,4)

Insert Into 
		mvto_cta_cte
		(num_lcto_mov, cd_banco, cd_agencia, num_cta_cte, dc_mov, Dt_Pgto_Rcto_Mov, Vlr_Doc_Mov, Concil_Mov, 
		 Dt_Ctb_Mvto, historico)
	Values 
		(@novo, @cd_banco, @cd_agencia, @num_cta_cte, @dc_mov, @Dt_Pgto_Rcto_Mov, @Vlr_Doc_Mov, @Concil_Mov, 
		 NULL, @historico)		

Set @Num_lcto_movN = @novo

Insert Into 
		log_mvto_cta_cte
		(num_lcto_mov, cd_banco, cd_agencia, num_cta_cte, dc_mov, Dt_Pgto_Rcto_Mov, Vlr_Doc_Mov, Concil_Mov, 
		 Dt_Ctb_Mvto, historico,data_mov, tipo_oper_mov, cd_usuario)
	Values 
		(@novo, @cd_banco, @cd_agencia, @num_cta_cte, @dc_mov, @Dt_Pgto_Rcto_Mov, @Vlr_Doc_Mov, @Concil_Mov,
		NULL, @historico, getDate(), @tipo_oper_mov, @cd_usuario)

	If @@RowCount <> 1 
		Begin 
			RollBack Transaction 
			Return -1 
		End 	
Commit Transaction











GO
