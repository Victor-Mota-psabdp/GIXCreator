SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE pPgtoRec_Upd
(
@Num_Lcto			VarChar(12),
@DC				char(1),
@Dt_Pgto_Rcto			varchar(10), 
@Cd_Banco			varchar(3),
@Cd_Agencia			varchar(5),
@Num_Cta_Cte			varchar(20),
@Forma_Pgto_Rcto		varchar(10),
@Num_Doc			varchar(10),
@Vlr_Doc			Float, 
@Cd_Pes			Varchar(10),
@Dt_Vcto			varchar(10),
@Concil			char(1),
@Cta_Cte_Cliente		VarChar(50)='',
@Ck_Doctos			char(1)

)
 AS
	Begin Transaction

	Declare @Dt_Pgto 	VarChar(10) 
	Declare @PerCont	VarChar(7)

	Set @PerCont = (Select pkcmes From param_aekcontabil) 

	If convert(Datetime, @Dt_Pgto_Rcto, 105) < dbo.fFirstDayMonth(@PerCont) 
		Begin 
			Rollback Transaction 
			Return -77 
		End 

	If  Exists (Select * From Pgto_Rcto Where Num_Lcto = @Num_Lcto)
		Begin 
			Update 
				Pgto_Rcto
			Set 
				Cd_Banco = @Cd_Banco , 
				Cd_Agencia = @Cd_Agencia, 
				Num_Cta_Cte = @Num_Cta_Cte, 
				DC = @DC, 
				Dt_Pgto_Rcto = @Dt_Pgto_Rcto, 
				Forma_Pgto_Rcto = @Forma_Pgto_Rcto, 
				Num_Doc = @Num_Doc, 
				Vlr_Doc = @Vlr_Doc, 
				Cd_Pes =@Cd_Pes,  
				Dt_Vcto = @Dt_Vcto, 
				Concil = @Concil,
				Cta_Cte_Cliente = @Cta_Cte_Cliente,
				Ck_Doctos = @Ck_Doctos
			Where
				Num_Lcto = @Num_Lcto 
	
			If @@Error = 0 
				Begin
		
					Update 
						Caixa_Hou_Imp_Mar 
					Set 
						Dt_Pgto_Rcto_HIM = @Dt_Pgto_Rcto
					Where
						Num_Lcto = @Num_Lcto
				
					If @@Error <> 0 
						Begin 
							RollBack Transaction
		 					Return -5		
						End 
		
					Update 
						Caixa_Hou_Imp_Aer
					Set 
						Dt_Pgto_Rcto_HIA = @Dt_Pgto_Rcto
					Where
						Num_Lcto = @Num_Lcto
				
					If @@Error <> 0 
						Begin 
							RollBack Transaction
		 					Return -6		
						End 
		
					Update 
						Caixa_Hou_Exp_Mar 
					Set 
						Dt_Pgto_Rcto_HEM = @Dt_Pgto_Rcto
					Where
						Num_Lcto = @Num_Lcto
				
					If @@Error <> 0 
						Begin 
							RollBack Transaction
		 					Return -7		
						End 
		
					Update 
						Caixa_Hou_Exp_Aer
					Set 
						Dt_Pgto_Rcto_HEA = @Dt_Pgto_Rcto
					Where
						Num_Lcto = @Num_Lcto
				
					If @@Error <> 0 
						Begin 
							RollBack Transaction
		 					Return -8		
						End 
		
		
		
					Update 
						Caixa_Mas_Imp_Mar 
					Set 
						Dt_Pgto_Rcto_MIM = @Dt_Pgto_Rcto
					Where
						Num_Lcto = @Num_Lcto
				
					If @@Error <> 0 
						Begin 
							RollBack Transaction
		 					Return -9
						End 
		
					Update 
						Caixa_Mas_Imp_Aer
					Set 
						Dt_Pgto_Rcto_MIA = @Dt_Pgto_Rcto
					Where
						Num_Lcto = @Num_Lcto
				
					If @@Error <> 0 
						Begin 
							RollBack Transaction
		 					Return -10
						End 
		
					Update 
						Caixa_Mas_Exp_Mar 
					Set 
						Dt_Pgto_Rcto_MEM = @Dt_Pgto_Rcto
					Where
						Num_Lcto = @Num_Lcto
				
					If @@Error <> 0 
						Begin 
							RollBack Transaction
		 					Return -11	
						End 
		
					Update 
						Caixa_Mas_Exp_Aer
					Set 
						Dt_Pgto_Rcto_MEA = @Dt_Pgto_Rcto
					Where
						Num_Lcto = @Num_Lcto
				
					If @@Error <> 0 
						Begin 
							RollBack Transaction
		 					Return -12	
						End 
		
					Commit Transaction 
					Return 1 
				End 
			Else
				Begin 
					Rollback Transaction 
					Return - 2 
				End 
		End 
	Else 
		Begin 
			RollBack Transaction 
			Return - 1 
		End
GO
