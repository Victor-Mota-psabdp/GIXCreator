SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.pMINV_Ins    Script Date: 03/10/2002 12:08:10 ******/
CREATE PROCEDURE pMINV_Ins
(
@Ref_Numb				VarChar(12),
@Net_Cod_Send_Off			VarChar(5),
@Data_Inv				DateTime, 
@Shipper				VarChar(35), 
@Shipper_Ad1				VarChar(35),  
@Shipper_Ad2				VarChar(35), 
@Shipper_Ad3 				VarChar(35), 
@ISO_Count_Code			Char(2), 
@Vat_Code				VarChar(15), 
@Inv_Per_Oper				Char(1), 
@SSL_Code				VarChar(4), 
@OBL_Ser_Numb			VarChar(16),
@Manif_Ser_Numb			VarChar(20), 
@Date_Carg_Manif			DateTime, 
@Est_Ship_Date			DateTime, 
@Vess_Voyag				VarChar(50), 
@Refer					VarChar(30), 
@Port_Orig				VarChar(3), 
@Port_Dest				Char(3), 
@Numb_Piec				Float, 
@Gross_Wei				Float, 
@Charg_Weight				Float, 
@Volume				Float, 
@ISO_Curr_Cod				Char(3), 
@Total_Inv				Float,  
@Imp_Exp_Ship				Char(1), 
@Net_Cod_Dest_Off			VarChar(5)
)
AS
	Declare @Max as int 
	Set @Max = IsNull((Select max(IMINV_ID) From Imp_MINV),0) + 1 
	
	Insert Into 
		Imp_MINV 
	Values 
		(
			@Max, 
			@Ref_Numb,
			@Net_Cod_Send_Off, 
			@Data_Inv, 
			@Shipper, 
			@Shipper_Ad1, 
			@Shipper_Ad2, 
			@Shipper_Ad3,
			@ISO_Count_Code, 
			@Vat_Code, 
			@Inv_Per_Oper,
			@SSL_Code,
			@OBL_Ser_Numb, 
			@Manif_Ser_Numb,
			@Date_Carg_Manif,
			@Est_Ship_Date,
			@Vess_Voyag,
			@Refer,
			@Port_Orig,
			@Port_Dest,
			@Numb_Piec,
			@Gross_Wei,
			@Charg_Weight	,
			@Volume,
			@ISO_Curr_Cod,
			@Total_Inv,
			@Imp_Exp_Ship,
			@Net_Cod_Dest_Off,
			'A',
			Null 
		)
	If @@Error <> 0 
		Return - 1 
	Else 
		Return @Max



GO
