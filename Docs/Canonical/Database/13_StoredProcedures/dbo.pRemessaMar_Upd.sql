SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pRemessaMar_Upd 
(
@Num_Ref_RM			Varchar(12), 
@Dt_Oper_RM			Varchar(10),
@Cd_Banco			Varchar(3),
@Cd_Agencia			Varchar(5),
@Num_Cta_Cte			Varchar(20),
@Cd_Pes			Varchar(10),
@Qtd_Hou_RM			Varchar(2),
@Vlr_Tot_Dol_RM		Float, 
@Tx_Dol_RM			Float, 
@Cd_Tp_Moeda_C_RM		Varchar(3),
@Vlr_Tot_Conv_RM		Float, 
@Tx_Conv_RM			Float, 
@Cd_Tp_Moeda_F_RM		Varchar(3),
@Vlr_Tot_Fchto_RM		Float, 
@Tx_Fchto_RM			Float, 
@Vlr_Tot_RM			Float,
@Dt_RM			Varchar(10),
@Usuario			VarChar(10), 
@QtdHouse_Ret		Int = Null OUTPUT,
@VlrDol_Ret			Float=Null OUTPUT,
@VlrOut_Ret			Float=Null OUTPUT
) 
AS
	Begin Transaction 
	If IsNull((Select Concil_RM From Remessa_Mar Where Num_Ref_RM = @Num_Ref_RM),'S') = 'S'
		Begin 
			RollBack Transaction 
			Return - 5
		End 

	Exec pRemessaMarCalc_Sel  @Num_Ref_RM, @Dt_Oper_RM, @Dt_RM, @Tx_Dol_RM, @Tx_Conv_RM, @Tx_Fchto_RM, @Usuario, @QtdHouse = @QtdHouse_Ret OUTPUT, @VlrDol = @VlrDol_Ret OUTPUT, @VlrOut = @VlrOut_Ret  OUTPUT

	Update 
		Remessa_Mar
	Set 
		Dt_Oper_RM = @Dt_Oper_RM, 
		Cd_Banco = @Cd_Banco, 
		Cd_Agencia = @Cd_Agencia, 
		Num_Cta_Cte = @Num_Cta_Cte, 
		Cd_Pes = @Cd_Pes, 
		Qtd_Hou_RM = @Qtd_Hou_RM,
		Vlr_Tot_Dol_RM = @Vlr_Tot_Dol_RM, 
		Tx_Dol_RM = @Tx_Dol_RM, 
		Cd_Tp_Moeda_C_RM = @Cd_Tp_Moeda_C_RM, 
		Vlr_Tot_Conv_RM = @Vlr_Tot_Conv_RM, 
		Tx_Conv_RM = @Tx_Conv_RM, 
		Cd_Tp_Moeda_F_RM = @Cd_Tp_Moeda_F_RM, 
		Vlr_Tot_Fchto_RM = @Vlr_Tot_Fchto_RM,
		Tx_Fchto_RM = @Tx_Fchto_RM, 
		Vlr_Tot_RM = @Vlr_Tot_RM, 
		Dt_RM = @Dt_RM 
	Where
		Num_Ref_RM = @Num_Ref_RM	

	If @@Error <> 0 and  @@RowCount <> 1  
		Begin 
			RollBack Transaction 
			Return -1 	
		End 
	Else 
		Begin 
			Commit Transaction 
			Return 1 
		End

GO
