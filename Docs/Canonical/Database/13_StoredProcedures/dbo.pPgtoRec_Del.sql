SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pPgtoRec_Del    Script Date: 17/10/2002 07:32:51 ******/
CREATE PROCEDURE [dbo].[pPgtoRec_Del] 
(
@Num_Lcto			VarChar(12)
)
 AS
	Begin Transaction
	Declare @Dt_Pgto 	VarChar(10) 
	Declare @PerCont	VarChar(7)
	Declare @TotRec		int 
	Set @TotRec	 = 0 

	set @TotRec	 = IsNull((Select count(*) from caixa_hou_imp_mar where num_rcb_him is not null and NUM_RCB_HIM <> '' AND num_lcto = @num_lcto),0)
	set @TotRec	 = @TotRec + IsNull((Select count(*) from caixa_hou_imp_aer where num_rcb_hia is not null and NUM_RCB_HIA <> '' AND num_lcto = @num_lcto),0)
	set @TotRec	 = @TotRec + IsNull((Select count(*) from caixa_hou_exp_aer where num_rcb_hea is not null and NUM_RCB_HEA <> '' AND num_lcto = @num_lcto),0)
	set @TotRec	 = @TotRec + IsNull((Select count(*) from caixa_hou_exp_mar where num_rcb_hem is not null and NUM_RCB_HEM <> '' AND num_lcto = @num_lcto),0)
	set @TotRec	 = @TotRec + IsNull((Select count(*) from caixa_hou_exp_out where num_rcb_heo is not null and NUM_RCB_HEO <> '' AND num_lcto = @num_lcto),0)
	set @TotRec	 = @TotRec + IsNull((Select count(*) from caixa_hou_imp_out where num_rcb_hio is not null and NUM_RCB_HIO <> '' AND num_lcto = @num_lcto),0)
	
	set @TotRec	 = @TotRec + IsNull((Select count(*) from caixa_mas_imp_mar where num_rcb_mim is not null and NUM_RCB_MIM <> '' AND num_lcto = @num_lcto),0)
	set @TotRec	 = @TotRec + IsNull((Select count(*) from caixa_mas_imp_aer where num_rcb_mia is not null and NUM_RCB_MIA <> '' AND num_lcto = @num_lcto),0)
	set @TotRec	 = @TotRec + IsNull((Select count(*) from caixa_mas_exp_aer where num_rcb_mea is not null and NUM_RCB_MEA <> '' AND num_lcto = @num_lcto),0)
	set @TotRec	 = @TotRec + IsNull((Select count(*) from caixa_mas_exp_mar where num_rcb_mem is not null and NUM_RCB_MEM <> '' AND num_lcto = @num_lcto),0)

	Set @PerCont = (Select pkcmes From param_aekcontabil) 
	Set @Dt_Pgto = (Select dt_pgto_rcto  From Pgto_Rcto Where Num_Lcto = @Num_Lcto)

	If convert(Datetime, @Dt_Pgto, 105) < dbo.fLastDayMonth(@PerCont) 
		Begin 
			Rollback Transaction 
			Return -77 
		End 

	if @TotRec > 0 
		Begin 
			Rollback  Transaction 
			Return - 19 
		End 

	If Exists(Select Num_Lcto From Pgto_Rcto Where Num_Lcto = @Num_Lcto) 
		Begin 
			Delete From 
				Pgto_Rcto 
			Where
				Num_Lcto = @Num_Lcto
			If @@Error = 0 
				Begin 
					Commit Transaction 
					Return 1 
				End 				
			Else
				Begin 
					RollBack Transaction 
					Return -2 
				End 				
		End 
	Else
		Begin 
			RollBack Transaction 
			Return -1 
		End


GO
