SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pItensNF_Rel 
(
@NF		VarChar(10), 
@Site		Char(1), 
@StrMachine	VarChar(20),
@Cd_Pes	VarChar(10)
)
AS


	Exec pItensNFPre_Ins @NF, @Site, @Cd_Pes, @StrMachine 
	If @@Error <> 0 
		Begin 
			Return -1 
		End 

	Exec pItensNF_Ins @StrMachine, @NF, @Site 
	If @@Error <> 0 
		Begin 
			Return -1 
		End 
	Else
		Begin 
			Return 1 


		End

GO
