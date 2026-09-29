SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spMvtoCtaCte_InsUpd] --'','001','3617X','6546-3','D','23/11/2009','92663.82','N','SISCOMEX PROT 1106367003'
	@num_lcto_mov		varchar(12),
	@cd_banco			varchar(3),
	@cd_agencia			varchar(5),
	@num_cta_cte		varchar(20),
	@dc_mov				char(1),
	@Dt_Pgto_Rcto_Mov	varchar(10),
	@Vlr_Doc_Mov		decimal(10,2),
	--@Concil_Mov			char(1),	
	@Historico			varchar(300),
	@num_lcto_movN		varchar(12) OUTPUT

AS
	Begin Transaction
	
	if @num_lcto_mov = '0'
	Begin	

		Declare @novo  varchar(13)

		--set @novo = (select cast(isnull(max(right(num_lcto_mov,4)),0) + 1 as varchar(5)) FROM mvto_cta_cte where left(num_lcto_mov,2) <> 'MB' and left(num_lcto_mov,8) = 'MA' + CAST(YEAR(GETDATE()) AS VARCHAR(4)) + LEFT('0'+ CAST(MONTH(GETDATE()) AS VARCHAR(2)),2))
		set @novo = (select cast(isnull(max(right(num_lcto_mov,4)),0) + 1 as varchar(5)) FROM mvto_cta_cte where left(num_lcto_mov,2) <> 'MB' and left(num_lcto_mov,8) = 'MA' + CAST(YEAR(GETDATE()) AS VARCHAR(4)) + RIGHT('0'+ CAST(MONTH(GETDATE()) AS VARCHAR(2)),2))
		set @novo = '00000' + @novo		
		set @novo = 'MA' + convert(varchar,year(getdate()),4) + right('0' + convert(varchar,month(getdate()),2),2) + right(@novo,4)
		

	Insert Into 
			mvto_cta_cte
			(num_lcto_mov, cd_banco, cd_agencia, num_cta_cte, dc_mov, Dt_Pgto_Rcto_Mov, Vlr_Doc_Mov, Concil_Mov, 
			 Dt_Ctb_Mvto, historico)
		Values 
			(@novo, @cd_banco, @cd_agencia, @num_cta_cte, @dc_mov, @Dt_Pgto_Rcto_Mov, @Vlr_Doc_Mov, 'N', 
			 NULL, @historico)	
		Set @num_lcto_movN = @novo
	End
	Else
		Begin
			Update
				mvto_cta_cte
			set
				cd_banco = @cd_banco,	
				cd_agencia = @cd_agencia, 
				num_cta_cte = @num_cta_cte, 
				dc_mov = @dc_mov, 
				Dt_Pgto_Rcto_Mov = @Dt_Pgto_Rcto_Mov,
				Vlr_Doc_Mov = @Vlr_Doc_Mov,
				Concil_Mov  = 'N',
				Dt_Ctb_Mvto = NULL,
				historico = @historico
			where
				num_lcto_mov = @num_lcto_mov
	
			Set @num_lcto_movN = @num_lcto_mov
		End

	If @@RowCount <> 1 
		Begin 
			RollBack Transaction 
			Return -1 
		End 	
Commit Transaction






GO
