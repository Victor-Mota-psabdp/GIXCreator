SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pHandling_InsUpd 
(
@Num_Proc		VarChar(16), 
@Hand_01		VarChar(300)='',
@Hand_02		VarChar(300)='',
@Hand_03		VarChar(300)=''
)
AS
	If Len(@Num_Proc) = 16 
		Begin 
			If RTrim(@Hand_01) = '' and RTrim(@Hand_02) = '' and RTrim(@Hand_03) = ''
				Begin 
					Delete Handling_HEA Where Num_Proc_HEA = @Num_Proc 				
				End 
			Else
				Begin 
					If Exists(Select Num_proc_HEA From Handling_HEA Where Num_Proc_HEA = @Num_Proc)
						Begin 
							Update 
								Handling_HEA 
							Set 
								Hand_HEA_1 = @Hand_01, 
								Hand_HEA_2 = @Hand_02, 
								Hand_HEA_3 = @Hand_03
							Where
								Num_Proc_HEA = @Num_Proc 
						End 
					Else
						Begin 
							Insert Into Handling_HEA Values (@Num_Proc, @Hand_01, @Hand_02, @Hand_03)
		
						End 
				End 
		End 
	Else
		Begin 
			If RTrim(@Hand_01) = '' and RTrim(@Hand_02) = '' and RTrim(@Hand_03) = ''
				Begin 
					Delete Handling_MEA Where Num_Proc_MEA = @Num_Proc 				
				End 
			Else
				Begin 
					If Exists(Select Num_proc_MEA From Handling_MEA Where Num_Proc_MEA = @Num_Proc)
						Begin 
							Update 
								Handling_MEA 
							Set 
								Hand_MEA_1 = @Hand_01, 
								Hand_MEA_2 = @Hand_02, 
								Hand_MEA_3 = @Hand_03
							Where
								Num_Proc_MEA = @Num_Proc 
						End 
					Else
						Begin 
							Insert Into Handling_MEA Values (@Num_Proc, @Hand_01, @Hand_02, @Hand_03)
		
						End 
				End 
		End

GO
