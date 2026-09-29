SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pCDNoteHEM_Ins    Script Date: 17/10/2002 07:32:47 ******/
CREATE PROCEDURE pCDNoteHEM_Ins
(
@Num_Proc 		VarChar(16),
@Cred_Dev		VarChar(10), 
@CD			Char(1),
@Site			Char(1),
@NewNote		VarChar(12) = ''  OUTPUT
)
 AS
	Declare @LastNote	VarChar(12) 
	Declare @Mes		Char(2)
	Declare @Ano		Char(4) 
	Declare @Seq		Char(3)
	Begin Transaction 
	If @CD = 'C'
		Begin 
			Set @LastNote = (Select Ult_Credit_Note From Referencia Where Ref_Acesso = @Site) 
			Set @Ano = Substring(@LastNote, 4,4) 
			Set @Mes = Substring(@LastNote, 8, 2)
			Set @Seq = Substring(@LastNote, 10, 3)
			If @Ano <> Year(GetDate()) 
				Set @NewNote  = 'CN' + @Site +  Cast(Year(GetDate()) as VarChar(4))+ right(('!0' + Cast(Month(GetDate()) as VarChar(2))), 2)+ '001'
			Else
				Begin 
					If @Mes <> Month(GetDate())
						Set @NewNote  = 'CN' + @Site +  Cast(Year(GetDate()) as VarChar(4))+ right(('!0' + Cast(Month(GetDate()) as VarChar(2))), 2)+ '001'
					Else
						Set @NewNote  = 'CN' + @Site +@Ano + @Mes + Right('!000' + Cast((Cast(@Seq as int) +1) as VarChar(3)),3)
				End 
			Update
				Cta_Cte_Hou_Exp_Mar 
			Set 
				Num_DCN_HEM = @NewNote 
			Where	
				Num_Proc_HEM = @Num_Proc and 
				Num_DCN_HEM is null  and
				Cd_Cred_Dev_HEM = @Cred_Dev And 
				Comp_CN_HEM = 'S'
	
			If @@Error = 0 
				Begin 
					Update 
						Referencia 
					Set 
						Ult_Credit_Note = @NewNote
					Where 
						Ref_Acesso = @Site				
					If @@Error = 0
						Commit Transaction 
					Else
						Begin 
							Set @NewNote = ''
							Rollback Transaction 
						End 
				End 
			Else
				Begin 
					Set @NewNote = ''
					Rollback Transaction 
				End 
			
		End 
	If @CD = 'D'
		Begin 
			Set @LastNote = (Select Ult_Debit_Note From Referencia Where Ref_Acesso = @Site) 
			Set @Ano = Substring(@LastNote, 4,4) 
			Set @Mes = Substring(@LastNote, 8, 2)
			Set @Seq = Substring(@LastNote, 10, 3)
			If @Ano <> Year(GetDate()) 
				Set @NewNote  = 'DN' + @Site +  Cast(Year(GetDate()) as VarChar(4))+ right(('!00' + Cast(Month(GetDate()) as VarChar(2))), 2)+ '001'
			Else
				Begin 
					If @Mes <> Month(GetDate())
						Set @NewNote  = 'DN' + @Site +  Cast(Year(GetDate()) as VarChar(4))+ right(('!0' + Cast(Month(GetDate()) as VarChar(2))), 2)+ '001'
					Else
						Set @NewNote  = 'DN' + @Site +@Ano + @Mes + Right('!000' + Cast((Cast(@Seq as int) +1) as VarChar(3)),3)
				End 
			Update
				Cta_Cte_Hou_Exp_Mar 
			Set 
				Num_DCN_HEM = @NewNote 
			Where	
				Num_Proc_HEM = @Num_Proc and 
				Num_DCN_HEM is null  and
				Cd_Cred_Dev_HEM = @Cred_Dev And 
				Comp_DN_HEM = 'S'
	
			If @@Error = 0 
				Begin 
					Update 
						Referencia 
					Set 
						Ult_Debit_Note = @NewNote
					Where 
						Ref_Acesso = @Site				
					If @@Error = 0
						Commit Transaction 
					Else
						Begin 
							Set @NewNote = ''
							Rollback Transaction 	
						End 
				End 
			Else
				Begin 
					Set @NewNote = ''
					Rollback Transaction 
				End 
			
		End



GO
