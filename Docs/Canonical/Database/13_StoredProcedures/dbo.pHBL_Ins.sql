SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE pHBL_Ins 
(
@Num_Proc		varchar(16),                      
@Shipper_00		varchar(50),                      
@Shipper_01		varchar(50), 
@Shipper_02		varchar(50), 
@Shipper_03		varchar(50),
@Notify_00		varchar(50),
@Notify_01		varchar(50),
@Notify_02		varchar(50),                     
@Notify_03		varchar(50),                     
@Consignee_00		varchar(50),
@Consignee_01		varchar(50),
@Consignee_02		varchar(50),
@Consignee_03		varchar(50),
@BLNumber		varchar(30),
@DateofIssue		varchar(20),
@ForwardAgt		varchar(50),
@CargoCtt_01		varchar(50),
@CargoCtt_02		varchar(50),
@CargoCtt_03		varchar(50),
@CargoCtt_04		varchar(50),
@PlaceRcpt		varchar(50),
@ExpCarrier		varchar(50), 
@PortLoading		varchar(50),
@PortDisc		varchar(50),                     
@PlaceDeliv		varchar(50),                     
@Marks_00		varchar(50), 
@Marks_01		varchar(50), 
@Marks_02		varchar(50), 
@Marks_03		varchar(50), 
@Marks_04		varchar(50),                    
@Marks_05		varchar(50),
@Marks_06		varchar(50), 
@Marks_07		varchar(50),
@Marks_08		varchar(50),
@Pkgs_00		varchar(50),                     
@Pkgs_01		varchar(50),                      
@Desc_00		varchar(50),                      
@Desc_01		varchar(50), 
@Desc_02		varchar(50), 
@Desc_03		varchar(50),                     
@Desc_04		varchar(50), 
@Desc_05		varchar(50), 
@Desc_06		varchar(50),                      
@Desc_07		varchar(50),                      
@Desc_08		varchar(50),                     
@Desc_09		varchar(50), 
@Desc_10		varchar(50),                      
@Desc_11		varchar(50), 
@GWeight_00		varchar(50),                      
@GWeight_01		varchar(50),                      
@GWeight_02		varchar(50),                     
@GWeight_03		varchar(50),
@GWeight_04		varchar(50),                     
@Measur_00		varchar(50),                      
@Measur_01		varchar(50), 
@Measur_02		varchar(50),                     
@Measur_03		varchar(50), 
@Measur_04		varchar(50),                      
@Originais		varchar(50),                      
@Dated		varchar(50), 
@Taxas		Varchar(50)                      
)
AS
	Declare @pos int 
	Declare @taxa varchar(3) 
	Declare @subpos int 
	Begin Transaction 
	If not Exists(Select Num_Proc From HBL Where Num_Proc = @Num_Proc)
		Begin 
			Insert Into HBL (Num_Proc, Shipper_00, Shipper_01, Shipper_02, Shipper_03, Notify_00, Notify_01, Notify_02, Notify_03, Consignee_00, 
					Consignee_01, Consignee_02, Consignee_03, BLNumber, DateofIssue, ForwardAgt, CargoCtt_01, CargoCtt_02, CargoCtt_03, 
					CargoCtt_04, PlaceRcpt, ExpCarrier, PortLoading, PortDisc, PlaceDeliv, Marks_00, Marks_01, Marks_02, Marks_03, 
					Marks_04, Marks_05, Marks_06, Marks_07, Marks_08, Pkgs_00, Pkgs_01, Desc_00, Desc_01, Desc_02, Desc_03, 
					Desc_04, Desc_05, Desc_06, Desc_07, Desc_08, Desc_09, Desc_10, Desc_11, GWeight_00, GWeight_01, 
					GWeight_02, GWeight_03, GWeight_04, Measur_00, Measur_01, Measur_02, Measur_03, Measur_04, Originais, Dated )
			Values 
					(@Num_Proc, @Shipper_00, @Shipper_01, @Shipper_02, @Shipper_03, @Notify_00, @Notify_01, @Notify_02, @Notify_03, @Consignee_00, 
					@Consignee_01, @Consignee_02, @Consignee_03, @BLNumber, @DateofIssue, @ForwardAgt, @CargoCtt_01, @CargoCtt_02, @CargoCtt_03, 
					@CargoCtt_04, @PlaceRcpt, @ExpCarrier, @PortLoading, @PortDisc, @PlaceDeliv, @Marks_00, @Marks_01, @Marks_02, @Marks_03, 
					@Marks_04, @Marks_05, @Marks_06, @Marks_07, @Marks_08, @Pkgs_00, @Pkgs_01, @Desc_00, @Desc_01, @Desc_02, @Desc_03, 
					@Desc_04, @Desc_05, @Desc_06, @Desc_07, @Desc_08, @Desc_09, @Desc_10, @Desc_11, @GWeight_00, @GWeight_01, 
					@GWeight_02, @GWeight_03, @GWeight_04, @Measur_00, @Measur_01, @Measur_02, @Measur_03, @Measur_04, @Originais, @Dated )
		End 
	Else
		Begin 
			Update 
				HBL 
			Set 
				Shipper_00 = @Shipper_00, 
				Shipper_01 = @Shipper_01, 
				Shipper_02 = @Shipper_02, 
				Shipper_03 = @Shipper_03, 
				Notify_00 = @Notify_00, 
				Notify_01 = @Notify_01, 
				Notify_02 = @Notify_02, 
				Notify_03 = @Notify_03, 
				Consignee_00 = @Consignee_00, 
				Consignee_01 = @Consignee_01, 
				Consignee_02 = @Consignee_02, 
				Consignee_03 = @Consignee_03, 
				BLNumber = @BLNumber, 
				DateofIssue = @DateofIssue, 
				ForwardAgt = @ForwardAgt, 
				CargoCtt_01 = @CargoCtt_01, 
				CargoCtt_02 = @CargoCtt_02, 
				CargoCtt_03 = @CargoCtt_03, 
				CargoCtt_04 = @CargoCtt_04, 
				PlaceRcpt = @PlaceRcpt, 
				ExpCarrier = @ExpCarrier, 
				PortLoading = @PortLoading, 
				PortDisc = @PortDisc, 
				PlaceDeliv = @PlaceDeliv, 
				Marks_00 = @Marks_00, 
				Marks_01 = @Marks_01, 
				Marks_02 = @Marks_02, 
				Marks_03 = @Marks_03, 
				Marks_04 = @Marks_04, 
				Marks_05 = @Marks_05, 
				Marks_06 = @Marks_06, 
				Marks_07 = @Marks_07, 
				Marks_08 = @Marks_08, 
				Pkgs_00 = @Pkgs_00, 
				Pkgs_01 = @Pkgs_01, 
				Desc_00 = @Desc_00, 
				Desc_01 = @Desc_01, 
				Desc_02 = @Desc_02, 
				Desc_03 = @Desc_03, 
				Desc_04 = @Desc_04, 
				Desc_05 = @Desc_05, 
				Desc_06 = @Desc_06, 
				Desc_07 = @Desc_07, 
				Desc_08 = @Desc_08, 
				Desc_09 = @Desc_09, 
				Desc_10 = @Desc_10, 
				Desc_11= @Desc_11, 
				GWeight_00 = @GWeight_00, 
				GWeight_01 = @GWeight_01, 
				GWeight_02 = @GWeight_02, 
				GWeight_03 = @GWeight_03, 
				GWeight_04 = @GWeight_04, 
				Measur_00 = @Measur_00, 
				Measur_01 = @Measur_01, 
				Measur_02 = @Measur_02, 
				Measur_03 = @Measur_03, 
				Measur_04 = @Measur_04, 
				Originais = @Originais, 	
				Dated  = @Dated
			Where 
				Num_Proc = @Num_Proc 

			If  @@Error<> 0 
				Begin 
					Rollback Transaction 
					Return -1 
				End 
			
			Delete From HBL_Taxas Where Num_Proc = @Num_Proc 

		End 
		
	If @@Error<> 0 
		Begin 
			Rollback Transaction 
			Return -1 
		End 

	if Len(@Taxas) > 0 
		Begin 
			Set @pos = 1
			Set @Taxa = ''
			while @pos <= len(@taxas) + 1
				Begin 
					if substring(@Taxas, @pos, 1) = ';' or (@pos = Len(@Taxas)  + 1)
						Begin 
							Insert Into HBL_Taxas Values (@Num_Proc, @Taxa)
							If @@Error<> 0 
								Begin 
									Rollback Transaction 
									Return -2
								End 
							Set @Taxa = ''
							
						End 
					Else
						Begin 
							Set @Taxa = @Taxa + 	substring(@Taxas, @pos, 1)
						End 

					Set @pos = @pos + 1 
				End 

		End 
	
	Commit Transaction 
	Return 1

GO
