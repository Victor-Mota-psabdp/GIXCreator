SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pRemessaMar_Ins 
(
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
@Concil_RM			Char(1),
@Num_Ref_RM			Varchar(12)=Null OUTPUT
) 
AS
	
	Declare @Mes 		Char(2) 
	Declare @Referencia	VarChar(12) 
	Set @Mes =  Cast(Month(GetDate()) as Char(2))
	If Len(@Mes) = 1 
		Set @Mes = '0' +  Cast(month(GetDate()) as Char(2))

	Begin Transaction 
	Set @Referencia = IsNull((Select Max(Right(Num_Ref_RM, 4))  From Remessa_Mar  Where Left(Num_Ref_RM, 8) = 'RM' +  Cast(Year(GetDate()) as Char(4)) + @Mes),0) + 1 			

	If Len(@Referencia) = 1 
		Set @Referencia  = '000' + @Referencia 
	If Len(@Referencia) = 2 
		Set @Referencia  = '00' + @Referencia 			
	If Len(@Referencia) = 3 
		Set @Referencia  = '0' + @Referencia 			

	Set @Referencia = 'RM' + Cast(year(GetDate()) as Char(4)) + @Mes +  @Referencia

	Insert Into 
		Remessa_Mar
		(Num_Ref_RM, Dt_Oper_RM, Cd_Banco, Cd_Agencia, Num_Cta_Cte, Cd_Pes, Qtd_Hou_RM, Vlr_Tot_Dol_RM, Tx_Dol_RM, Cd_Tp_Moeda_C_RM, Vlr_Tot_Conv_RM, 
		Tx_Conv_RM, Cd_Tp_Moeda_F_RM, Vlr_Tot_Fchto_RM, Tx_Fchto_RM, Vlr_Tot_RM, Dt_RM, Concil_RM)
	Values 
		(@Referencia, @Dt_Oper_RM, @Cd_Banco, @Cd_Agencia, @Num_Cta_Cte, @Cd_Pes, @Qtd_Hou_RM, @Vlr_Tot_Dol_RM, @Tx_Dol_RM, @Cd_Tp_Moeda_C_RM, @Vlr_Tot_Conv_RM, 
		@Tx_Conv_RM, @Cd_Tp_Moeda_F_RM, @Vlr_Tot_Fchto_RM, @Tx_Fchto_RM, @Vlr_Tot_RM, @Dt_RM, @Concil_RM)		

	If @@RowCount <> 1  Or  @@Error <> 0
		Begin 
			RollBack Transaction 
			Return -1 	
		End 
	Else 
		Begin 
			Commit Transaction 
			Set @Num_Ref_RM = @Referencia 
			Return 1 
		End

GO
