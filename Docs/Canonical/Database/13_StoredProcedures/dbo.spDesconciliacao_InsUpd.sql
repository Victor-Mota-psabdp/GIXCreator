SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spDesconciliacao_InsUpd]
		@Num_Lcto	Varchar(12)

AS

--Begin Transaction
	Declare @MAs Table 
		(

			Num_Lcto_Mov Varchar(12),
			Valor	Decimal(10,2)

		)

	Declare @LAs Table
		(
			Num_Lcto_rec Varchar(12),
			Valor	Decimal(10,2)
		)

	insert @MAs
	exec spBuscaMARec_Sel @Num_Lcto
	

	insert @LAs
	exec spBuscaLARec_Sel @Num_Lcto

	Update Mvto_Cta_cte set concil_mov='N'
	Where num_lcto_mov in (select Num_Lcto_Mov from @MAs)
	
	Update Pgto_Rcto set Concil='N'
	Where num_lcto in (select Num_Lcto_REC from @LAs)

	Update Pgto_Rcto_div set Concil_Div='N'
	Where num_lcto_div in (select Num_Lcto_REC from @LAs)

	Update Remessa_Aer set Concil_RA='N'
	Where num_ref_ra in (select Num_Lcto_REC from @LAs)

	Update Remessa_MAr set Concil_RM='N'
	Where num_ref_rm in (select Num_Lcto_REC from @LAs)
	
	Delete rec_ctA_cte
	where num_lcto_Rec in(select Num_Lcto_REC from @LAs)

	Delete rec_ctA_cte
	where num_lcto_Mov in(select Num_Lcto_Mov from @MAS)

--	if @@Error <> 0
--		Begin
--			Rollback transaction
--			return -1
--		End
--Commit Transaction
GO
