SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pRemessaAer_Upd 
(
@Num_Ref_RA			Varchar(12), 
@Dt_Oper_RA			Varchar(10),
@Cd_Banco			Varchar(3),
@Cod_Praca_RA		Varchar(5),
@Cd_Agencia			Varchar(5),
@Num_Cta_Cte			Varchar(20),
@Cd_Pes			Varchar(10),
@Qtd_Hou_RA			Varchar(2),
@Vlr_Tot_Dol_RA		Float, 
@Tx_Dol_RA			Float, 
@Cd_Tp_Moeda_C_RA		Varchar(3),
@Vlr_Tot_Conv_RA		Float, 
@Tx_Conv_RA			Float, 
@Cd_Tp_Moeda_F_RA		Varchar(3),
@Vlr_Tot_Fchto_RA		Float, 
@Tx_Fchto_RA			Float, 
@Vlr_Tot_RA			Float,
@Dt_RA			Varchar(10),
@Usuario			VarChar(10), 
@QtdHouse_Ret		Int = Null OUTPUT,
@VlrDol_Ret			Float=Null OUTPUT,
@VlrOut_Ret			Float=Null OUTPUT
) 
AS
	Begin Transaction 
	If IsNull((Select Concil_RA From Remessa_Aer Where Num_Ref_RA = @Num_Ref_RA),'S') = 'S'
		Begin 
			RollBack Transaction 
			Return - 5
		End 

	Exec pRemessaAerCalc_Sel  @Num_Ref_RA, @Dt_Oper_RA, @Dt_RA, @Tx_Dol_RA, @Tx_Conv_RA, @Tx_Fchto_RA, @Usuario, @QtdHouse = @QtdHouse_Ret OUTPUT, @VlrDol = @VlrDol_Ret OUTPUT, @VlrOut = @VlrOut_Ret  OUTPUT

	Update 
		Remessa_Aer
	Set 
		Dt_Oper_RA = @Dt_Oper_RA, 
		Cd_Banco = @Cd_Banco, 
		Cod_Praca_RA = @Cod_Praca_RA, 
		Cd_Agencia = @Cd_Agencia, 
		Num_Cta_Cte = @Num_Cta_Cte, 
		Cd_Pes = @Cd_Pes, 
		Qtd_Hou_RA = @Qtd_Hou_RA,
		Vlr_Tot_Dol_RA = @Vlr_Tot_Dol_RA, 
		Tx_Dol_RA = @Tx_Dol_RA, 
		Cd_Tp_Moeda_C_RA = @Cd_Tp_Moeda_C_RA, 
		Vlr_Tot_Conv_RA = @Vlr_Tot_Conv_RA, 
		Tx_Conv_RA = @Tx_Conv_RA, 
		Cd_Tp_Moeda_F_RA = @Cd_Tp_Moeda_F_RA, 
		Vlr_Tot_Fchto_RA = @Vlr_Tot_Fchto_RA,
		Tx_Fchto_RA = @Tx_Fchto_RA, 
		Vlr_Tot_RA = @Vlr_Tot_RA, 
		Dt_RA = @Dt_RA 
	Where
		Num_Ref_RA = @Num_Ref_RA	

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
