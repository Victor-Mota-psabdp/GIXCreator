SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Log_Booking_Request_Cargo
Create PROCEDURE [dbo].[spLog_Booking_Request_Cargo_InsUpd]
(
	@ID_Log				bigint,
	@Dt_Alter			Datetime,
	@Tp_Oper			varchar(1),
	@Cd_Usuario			varchar(6),
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

BEGIN
	BEGIN TRY
		Declare @ID_New as bigint;
		BEGIN
			Insert Into Log_Booking_Request_Cargo
			(
				[Dt_Alter] ,[Tp_Oper] ,[Cd_Usuario],
				Num_Proc,Cd_Prod,Cd_Proc_Cliente,Produto_Description,NCM,Net_Weight,
				Gross_Weight,Qtde_Embal,Cd_Tp_Embal,Name_Tp_Embal,UN_Number,IMO_Class,
				Proper_Shipping_Name,fsPoint,Temperature,Packing_Group,Emergency_Contact_Name,
				Emergency_Contact_Number
			)
			Values
			(
				Getdate(),@Tp_Oper,@Cd_Usuario,
				@Num_Proc,@Cd_Prod,@Cd_Proc_Cliente,@Produto_Description,@NCM,@Net_Weight,
				@Gross_Weight,@Qtde_Embal,@Cd_Tp_Embal,@Name_Tp_Embal,@UN_Number,@IMO_Class,
				@Proper_Shipping_Name,@fsPoint,@Temperature,@Packing_Group,@Emergency_Contact_Name,
				@Emergency_Contact_Number
			)							
			set @ID_New = @@IDENTITY
			Select @ID_New as Retorno;	
		END

		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	
END


GO
