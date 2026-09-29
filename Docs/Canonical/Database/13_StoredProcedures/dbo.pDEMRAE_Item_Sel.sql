SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pDEMRAE_Item_Sel  
(
@Remessa	VarChar(16),
@StrMachine	VarChar(30) 
)
AS
	If Left(@Remessa, 2) = 'RA'
		Select 
			TMP.*, Ra.Vlr_Tot_Fchto_RA
		From 
			Tmp_DEMRAE as TMP Join Remessa_Aer as RA on RA.Num_Ref_RA = Tmp.Remessa 
		Where
			StrMachine = @StrMachine and 
			Remessa = @Remessa
	Else
		Select 
			TMP.*, RM.Vlr_Tot_Fchto_RM
		From 
			Tmp_DEMRAE as TMP Join Remessa_Mar as RM on RM.Num_Ref_RM = Tmp.Remessa 
		Where
			StrMachine = @StrMachine and 
			Remessa = @Remessa

GO
