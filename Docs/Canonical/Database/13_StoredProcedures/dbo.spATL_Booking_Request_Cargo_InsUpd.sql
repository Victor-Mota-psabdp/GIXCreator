SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Booking_Request_Cargo
CREATE PROCEDURE [dbo].[spATL_Booking_Request_Cargo_InsUpd]
(
	@Num_Proc				varchar(16),
	@Cd_Prod				int,
	@Cd_Proc_Cliente		varchar(30),
	@Produto_Description	varchar(1000),
	@NCM					varchar(20),
	@Net_Weight				float,
	@Gross_Weight			float,
	@Qtde_Embal				int,
	@Cd_Tp_Embal			varchar(3),
	@Name_Tp_Embal			varchar(100),
	@UN_Number				varchar(10),
	@IMO_Class				varchar(1000),
	@Proper_Shipping_Name	varchar(200),
	@fsPoint				varchar(3),
	@Temperature			varchar(200),
	@Packing_Group			varchar(200),
	@Emergency_Contact_Name	varchar(200),
	@Emergency_Contact_Number	varchar(200)

)

AS

Begin Transaction

	If Not Exists(Select Num_Proc from Booking_Request_Cargo where Num_Proc = @Num_Proc and NCM = @NCM) -- and Cd_Proc_Cliente = @Cd_Proc_Cliente)
		Begin
			Insert Into Booking_Request_Cargo
			(
				Num_Proc,Cd_Prod,Cd_Proc_Cliente,Produto_Description,NCM,Net_Weight,
				Gross_Weight,Qtde_Embal,Cd_Tp_Embal,Name_Tp_Embal,UN_Number,IMO_Class,
				Proper_Shipping_Name,fsPoint,Temperature,Packing_Group,Emergency_Contact_Name,
				Emergency_Contact_Number
			)
			Values
			(
				@Num_Proc,@Cd_Prod,@Cd_Proc_Cliente,@Produto_Description,@NCM,@Net_Weight,
				@Gross_Weight,@Qtde_Embal,@Cd_Tp_Embal,@Name_Tp_Embal,@UN_Number,@IMO_Class,
				@Proper_Shipping_Name,@fsPoint,@Temperature,@Packing_Group,@Emergency_Contact_Name,
				@Emergency_Contact_Number
			)		
		End
	Else
		Begin
			Update
				Booking_Request_Cargo
			Set	
				Cd_Prod=@Cd_Prod,	
				Cd_Proc_Cliente = @Cd_Proc_Cliente,
				Produto_Description=@Produto_Description,
				--NCM=@NCM,
				Net_Weight=@Net_Weight,
				Gross_Weight=@Gross_Weight,
				Qtde_Embal=@Qtde_Embal,
				Cd_Tp_Embal=@Cd_Tp_Embal,
				Name_Tp_Embal=@Name_Tp_Embal,
				UN_Number=@UN_Number,
				IMO_Class=@IMO_Class,
				Proper_Shipping_Name=@Proper_Shipping_Name,
				fsPoint=@fsPoint,
				Temperature=@Temperature,
				Packing_Group=@Packing_Group,
				Emergency_Contact_Name=@Emergency_Contact_Name,
				Emergency_Contact_Number=@Emergency_Contact_Number
			Where
				Num_Proc = @Num_Proc 
				and NCM = @NCM
				--and Cd_Proc_Cliente = @Cd_Proc_Cliente
		End



		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

Commit Transaction

GO
