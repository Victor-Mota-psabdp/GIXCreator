SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pCompPgto_Ins 
(
@Lcto		VarChar(14), 
@Site		Char(1),
@NewComp	VarChar(14) ='' OUTPUT
)
 AS
	Declare @UltComp 	VarChar(12) 
	Declare @OldComp 	VarChar(12) 
	Begin Transaction 
	Set @OldComp = (Select Num_Rcb_HIM as Recibo from caixa_hou_imp_mar Where Num_Lcto =  @Lcto AND Num_Rcb_HIM <> '' Union 
			   Select Num_Rcb_HEM as Recibo from caixa_hou_exp_mar Where Num_Lcto =  @Lcto AND Num_Rcb_HEM <> ''   Union 
			   Select Num_Rcb_HIA as Recibo from caixa_hou_imp_aer Where Num_Lcto =  @Lcto AND Num_Rcb_HIA <> ''  Union 
			   Select Num_Rcb_HEA as Recibo from caixa_hou_exp_aer Where Num_Lcto =  @Lcto AND Num_Rcb_HEA <> ''  Union 
			   Select Num_Rcb_MIM as Recibo from caixa_mas_imp_mar Where Num_Lcto =  @Lcto AND Num_Rcb_MIM <> ''  Union 
			   Select Num_Rcb_MEM as Recibo from caixa_mas_exp_mar Where Num_Lcto =  @Lcto AND Num_Rcb_MEM <> ''  Union 
			   Select Num_Rcb_MIA as Recibo from caixa_mas_imp_aer Where Num_Lcto =  @Lcto AND Num_Rcb_MIA <> ''  Union 
			   Select Num_Rcb_MEA as Recibo from caixa_mas_exp_aer Where Num_Lcto =  @Lcto AND Num_Rcb_MEA <> '' )
	If @OldComp = null 
		Set @OldComp = ''
	If @OldComp <> ''
		Begin 
			Set @NewComp = @OldComp 
			Commit Transaction 
			Return  1
		End 
	Set @UltComp = (Select Ult_Comprov From Referencia Where Ref_Acesso = @Site)
	Set @NewComp = 'PG' + @Site 
	Set @NewComp = @NewComp + Cast(year(GetDate()) as VarChar(4)) 
	Set @NewComp = @NewComp + right('0' + Cast(month(GetDate()) as VarChar(2)),2) 
	If left(@UltComp, 9 ) = @NewComp
		Begin
			Set @NewComp = @NewComp +  Right('000' + Cast((right(@UltComp, 3) +1) as VarChar(3)),3)
		End 
	Else
		Begin 
			Set @NewComp = @NewComp +  Cast('001' as VarChar(3))
		End 	
	
	Update Caixa_Mas_Imp_Mar Set Num_Rcb_MIM = @NewComp Where Num_Lcto = @Lcto 
	If @@Error <> 0 
		Begin 
			Rollback Transaction 
			Return -1 
		End 
	Update Caixa_Hou_Imp_Mar Set Num_Rcb_HIM = @NewComp Where Num_Lcto = @Lcto 
	If @@Error <> 0 
		Begin 
			Rollback Transaction 
			Return -1 
		End 
	Update Caixa_Mas_Exp_Mar Set Num_Rcb_MEM = @NewComp Where Num_Lcto = @Lcto 
	If @@Error <> 0 
		Begin 
			Rollback Transaction 
			Return -1 
		End 
	Update Caixa_Hou_Exp_Mar Set Num_Rcb_HEM = @NewComp Where Num_Lcto = @Lcto 
	If @@Error <> 0 
		Begin 
			Rollback Transaction 
			Return -1 
		End 
	Update Caixa_Mas_Imp_Aer Set Num_Rcb_MIA = @NewComp Where Num_Lcto = @Lcto 
	If @@Error <> 0 
		Begin 
			Rollback Transaction 
			Return -1 
		End 
	Update Caixa_Hou_Imp_Aer Set Num_Rcb_HIA = @NewComp Where Num_Lcto = @Lcto 
	If @@Error <> 0 
		Begin 
			Rollback Transaction 
			Return -1 
		End 
	Update Caixa_Mas_Exp_Aer Set Num_Rcb_MEA = @NewComp Where Num_Lcto = @Lcto 
	If @@Error <> 0 
		Begin 
			Rollback Transaction 
			Return -1 
		End 
	Update Caixa_Hou_Exp_Aer Set Num_Rcb_HEA = @NewComp Where Num_Lcto = @Lcto 
	If @@Error <> 0 
		Begin 
			Rollback Transaction 
			Return -1 
		End 
	Update Referencia Set Ult_Comprov = @NewComp Where Ref_Acesso = @Site
	Commit Transaction 
	Return 1
GO
