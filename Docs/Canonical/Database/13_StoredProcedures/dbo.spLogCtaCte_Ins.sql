SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE       Procedure spLogCtaCte_Ins
	@Usuario		VarChar(50),
	@Tp_Oper_CC		Char(1),
	@Num_Proc_CC		VarChar(16),
	@Tp_Tx			Char(30),
	@DC_CC			Char(1),
	@Org_Ins		VarChar(9),
	@Dt_Ins			Char(10),
	@Tp_Moeda		Char(30),
	@Vlr_Org		Decimal(10,2),
	@Dt_Prev_Pgto		Char(10),
	@Cred_Dev		VarChar(20),
	@Desp_Org_Dst		Char(1),
	@Comp_CPA		Char(1),
	@Contab			Bit,
	@Vlr_Contab		Decimal(10,2),
	@Cointab_Mes_Ano	VarChar(7)

AS

BEGIN TRANSACTION

		Declare @Cd_Tp_Tx	Varchar(3)
		Declare @Cd_Tp_Moeda	Varchar(3)
		Declare @Cd_Cred_Dev	Varchar(10)
		Declare @Cd_Usuario	Varchar(6) 

		Set @Cd_Tp_Tx = (Select Cd_Tp_Tx from Tipo_Taxa where Nome_Tp_Tx = @Tp_Tx)
		Set @Cd_Tp_Moeda = (Select Cd_Tp_Moeda from Tipo_Moeda where  Nome_Tp_Moeda = @Tp_Moeda)
		Set @Cd_Cred_Dev = (Select Cd_Pes from Pessoa where Apelido = @Cred_Dev)
		Set @Cd_Usuario = (Select top 1 Cd_Usuario from Usuario where Nome_Usuario = @Usuario)


	Insert into Log_Cta_Cte
		(
		Data_CC,
		Cd_Usuario,
		Tp_Oper_CC,
		Num_Proc_CC,
		Cd_Tp_Tx,
		DC_CC,
		Org_Ins,
		Dt_Ins,
		Cd_Tp_Moeda,
		Vlr_Org,
		Dt_Prev_Pgto,
		Cd_Cred_Dev,
		Desp_Org_Dst,
		Comp_CPA,Contab,
		Vlr_Contab,
		Cointab_Mes_Ano	
		)
	Values
		(
		getDate(),
		@Cd_Usuario,
		@Tp_Oper_CC,
		@Num_Proc_CC,
		@Cd_Tp_Tx,
		@DC_CC,
		@Org_Ins,
		@Dt_Ins,
		@Cd_Tp_Moeda,
		@Vlr_Org,
		@Dt_Prev_Pgto,
		@Cd_Cred_Dev,
		@Desp_Org_Dst,
		@Comp_CPA,
		@Contab,
		@Vlr_Contab,
		@Cointab_Mes_Ano		
		)
	IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END

COMMIT TRANSACTION










GO
