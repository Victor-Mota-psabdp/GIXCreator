SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pRemessaAer_Ins 
(
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
@Concil_RA			Char(1),
@Num_Ref_RA			Varchar(12)=Null OUTPUT
) 
AS
	
	Declare @Mes 		Char(2) 
	Declare @Referencia	VarChar(12) 
	Set @Mes =  Cast(Month(GetDate()) as Char(2))
	If Len(@Mes) = 1 
		Set @Mes = '0' +  Cast(month(GetDate()) as Char(2))

	Begin Transaction 
	Set @Referencia = IsNull((Select Max(Right(Num_Ref_RA, 4))  From Remessa_Aer  Where Left(Num_Ref_RA, 8) = 'RA' +  Cast(Year(GetDate()) as Char(4)) + @Mes),0) + 1 			

	If Len(@Referencia) = 1 
		Set @Referencia  = '000' + @Referencia 
	If Len(@Referencia) = 2 
		Set @Referencia  = '00' + @Referencia 			
	If Len(@Referencia) = 3 
		Set @Referencia  = '0' + @Referencia 			

	Set @Referencia = 'RA' + Cast(year(GetDate()) as Char(4)) + @Mes +  @Referencia

	Insert Into 
		Remessa_Aer	
		(Num_Ref_RA, Dt_Oper_RA, Cd_Banco, Cod_Praca_RA, Cd_Agencia, Num_Cta_Cte, Cd_Pes, Qtd_Hou_RA, Vlr_Tot_Dol_RA, Tx_Dol_RA, Cd_Tp_Moeda_C_RA, Vlr_Tot_Conv_RA, 
		Tx_Conv_RA, Cd_Tp_Moeda_F_RA, Vlr_Tot_Fchto_RA, Tx_Fchto_RA, Vlr_Tot_RA, Dt_RA, Concil_RA)
	Values 
		(@Referencia, @Dt_Oper_RA, @Cd_Banco, @Cod_Praca_RA, @Cd_Agencia, @Num_Cta_Cte, @Cd_Pes, @Qtd_Hou_RA, @Vlr_Tot_Dol_RA, @Tx_Dol_RA, @Cd_Tp_Moeda_C_RA, @Vlr_Tot_Conv_RA, 
		@Tx_Conv_RA, @Cd_Tp_Moeda_F_RA, @Vlr_Tot_Fchto_RA, @Tx_Fchto_RA, @Vlr_Tot_RA, @Dt_RA, @Concil_RA)		

	If @@RowCount <> 1  Or  @@Error <> 0
		Begin 
			RollBack Transaction 
			Return -1 	
		End 
	Else 
		Begin 
			Commit Transaction 
			Set @Num_Ref_RA = @Referencia 
			Return 1 
		End

GO
