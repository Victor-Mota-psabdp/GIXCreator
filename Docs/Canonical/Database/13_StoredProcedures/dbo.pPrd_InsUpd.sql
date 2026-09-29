SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pPrd_InsUpd
(
@Num_Proc_M		VarChar(14) ='',
@Num_Proc_H		VarChar(16) ='',
@Product		VarChar(2000)
)
 AS
	If @Num_Proc_H = '' 
		Begin 
			If Left(@Num_Proc_M, 2) ='EM'
				Begin 
					If Exists(Select * From Prd_Mas_Exp_Mar Where Num_Proc_MEM = @Num_Proc_M)
						Update 
							Prd_Mas_Exp_Mar
						Set 
							Prod_MEM = @Product 
						Where 
							Num_Proc_MEM = @Num_Proc_M
					Else
						Begin 
							If Rtrim(@Product) <> ''
								Insert Into 
									Prd_Mas_Exp_Mar
									(Num_Proc_MEM, Prod_MEM)
								Values 
									(@Num_Proc_M,@Product)
						End 
				End 
			If Left(@Num_Proc_M, 2) ='EA'
				Begin 
					If Exists(Select * From Prd_Mas_Exp_Aer Where Num_Proc_MEA = @Num_Proc_M)
						Update 
							Prd_Mas_Exp_Aer
						Set 
							Prod_MEA = @Product 
						Where 
							Num_Proc_MEA = @Num_Proc_M
					Else
						Begin 
							If Rtrim(@Product) <> ''
								Insert Into 
									Prd_Mas_Exp_Aer
									(Num_Proc_MEA, Prod_MEA)
								Values 
									(@Num_Proc_M,@Product)
						End 
				End 

			If Left(@Num_Proc_M, 2) ='IM'
				Begin 
					If Exists(Select * From Prd_Mas_Imp_Mar Where Num_Proc_MIM = @Num_Proc_M)
						Update 
							Prd_Mas_Imp_Mar
						Set 
							Prod_MIM = @Product 
						Where 
							Num_Proc_MIM = @Num_Proc_M
					Else
						Begin 
							If Rtrim(@Product) <> ''
								Insert Into 
									Prd_Mas_Imp_Mar
									(Num_Proc_MIM, Prod_MIM)
								Values 
									(@Num_Proc_M,@Product)
						End 
				End 

			If Left(@Num_Proc_M, 2) ='IA'
				Begin 
					If Exists(Select * From Prd_Mas_Imp_Aer Where Num_Proc_MIA = @Num_Proc_M)
						Update 
							Prd_Mas_Imp_Aer
						Set 
							Prod_MIA = @Product 
						Where 
							Num_Proc_MIA = @Num_Proc_M
					Else
						Begin 
							If Rtrim(@Product) <> ''
								Insert Into 
									Prd_Mas_Imp_Aer
									(Num_Proc_MIA, Prod_MIA)
								Values 
									(@Num_Proc_M,@Product)
						End 
				End 
		End 
	Else
		Begin 
			If Left(@Num_Proc_H, 2) ='EM'
				Begin 
					If Exists(Select * From Prd_Hou_Exp_Mar Where Num_Proc_HEM = @Num_Proc_H)
						Update 
							Prd_Hou_Exp_Mar
						Set 
							Prod_HEM = @Product
						Where 
							Num_Proc_HEM = @Num_Proc_H
					Else
						Begin 
							If Rtrim(@Product) <> ''
								Insert Into 
									Prd_Hou_Exp_Mar
									(Num_Proc_HEM, Prod_HEM)
								Values 
									(@Num_Proc_H,@Product)
						End 
				End 
			If Left(@Num_Proc_H, 2) ='EA'
				Begin 
					If Exists(Select * From Prd_Hou_Exp_Aer Where Num_Proc_HEA = @Num_Proc_H)
						Update 
							Prd_Hou_Exp_Aer
						Set 
							Prod_HEA = @Product
						Where 
							Num_Proc_HEA = @Num_Proc_H
					Else
						Begin 
							If Rtrim(@Product) <> ''
								Insert Into 
									Prd_Hou_Exp_Aer
									(Num_Proc_HEA, Prod_HEA)
								Values 
									(@Num_Proc_H,@Product)
						End 
				End 

			If Left(@Num_Proc_H, 2) ='IM'
				Begin 
					If Exists(Select * From Prd_Hou_Imp_Mar Where Num_Proc_HIM = @Num_Proc_H)
						Update 
							Prd_Hou_Imp_Mar
						Set 
							Prod_HIM = @Product
						Where 
							Num_Proc_HIM = @Num_Proc_H
					Else
						Begin 
							If Rtrim(@Product) <> ''
								Insert Into 
									Prd_Hou_Imp_Mar
									(Num_Proc_HIM, Prod_HIM)
								Values 
									(@Num_Proc_H,@Product)
						End 
				End 

			If Left(@Num_Proc_H, 2) ='IA'
				Begin 
					If Exists(Select * From Prd_Hou_Imp_Aer Where Num_Proc_HIA = @Num_Proc_H)
						Update 
							Prd_Hou_Imp_Aer
						Set 
							Prod_HIA = @Product
						Where 
							Num_Proc_HIA = @Num_Proc_H
					Else
						Begin 
							If Rtrim(@Product) <> ''
								Insert Into 
									Prd_Hou_Imp_Aer
									(Num_Proc_HIA, Prod_HIA)
								Values 
									(@Num_Proc_H,@Product)
						End 
				End 
		End

GO
