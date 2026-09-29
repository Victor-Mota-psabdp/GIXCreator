SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE pItensNFRPS_Rel 
(
@NF		VarChar(10), 
@Site		Char(1), 
@StrMachine	VarChar(20),
@Cd_Pes	VarChar(10)
)
AS
	Begin Transaction 

	Exec pItensNFPre_Ins @NF, @Site, @Cd_Pes, @StrMachine 
	If @@Error <> 0 
		Begin 
			Rollback Transaction 
			Return -1 
		End 

	Update Base_Nota_Fiscal Set RPS_Envio = 1 Where Nota_Fiscal = @NF and Ref_Acesso = @Site 
	If @@Error <> 0 
		Begin 
			Rollback Transaction 
			Return -3 
		End 

	Exec pItensNF_Ins @StrMachine, @NF, @Site 
	If @@Error <> 0 
		Begin 
			Rollback Transaction 
			Return -1 
		End 
	Else
		Begin 
			Commit Transaction 
			Return 1 

			
		End
GO
