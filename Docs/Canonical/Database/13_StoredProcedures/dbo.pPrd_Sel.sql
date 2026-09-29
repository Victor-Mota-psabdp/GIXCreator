SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pPrd_Sel
(
@Num_Proc_M		VarChar(14) ='',
@Num_Proc_H		VarChar(16) =''
)
 AS
	If @Num_Proc_H = '' 
		Begin 
			If Left(@Num_Proc_M, 2) ='EM'
				Begin 
					Select 
						Prod_MEM as Product 
					From 
						Prd_Mas_Exp_Mar
					Where
						Num_Proc_MEM = @Num_Proc_M
				End 
			If Left(@Num_Proc_M, 2) ='IM'
				Begin 
					Select 
						Prod_MIM as Product 
					From 
						Prd_Mas_Imp_Mar
					Where
						Num_Proc_MIM = @Num_Proc_M
				End 

			If Left(@Num_Proc_M, 2) ='IA'
				Begin 
					Select 
						Prod_MIA as Product 
					From 
						Prd_Mas_Imp_Aer
					Where
						Num_Proc_MIA = @Num_Proc_M
				End 

			If Left(@Num_Proc_M, 2) ='EA'
				Begin 
					Select 
						Prod_MEA as Product 
					From 
						Prd_Mas_Exp_Aer
					Where
						Num_Proc_MEA = @Num_Proc_M
				End 
		End 
	Else
		Begin 
			If Left(@Num_Proc_H, 2) ='EM'
				Begin 
					Select 
						Prod_HEM as Product
					From 
						Prd_Hou_Exp_Mar
					Where
						Num_Proc_HEM = @Num_Proc_H
				End 
			If Left(@Num_Proc_H, 2) ='IM'
				Begin 
					Select 
						Prod_HIM as Product 
					From 
						Prd_Hou_Imp_Mar
					Where
						Num_Proc_HIM = @Num_Proc_H
				End 

			If Left(@Num_Proc_H, 2) ='EA'
				Begin 
					Select 
						Prod_HEA as Product 
					From 
						Prd_Hou_Exp_Aer
					Where
						Num_Proc_HEA = @Num_Proc_H
				End 

			If Left(@Num_Proc_H, 2) ='IA'
				Begin 
					Select 
						Prod_HIA as Product 
					From 
						Prd_Hou_Imp_Aer
					Where
						Num_Proc_HIA = @Num_Proc_H
				End 
		End

GO
