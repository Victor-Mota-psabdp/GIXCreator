SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spProdutoPerigoso_InsUPD]
		@Cd_Proc_Cliente		VarChar(30),
		@Cd_Cliente				VarChar(10),		
		@Uncode					VarChar(4),
		@classCode				VarChar(4),
		@HazMat_Name_Material	VarChar(200),
		@HazMat_Description		VarChar(max),
		@HazMat_Contact			VarChar(12),
		@HazMat_Phone			VarChar(24),
		@FlashPoint				VarChar(3),
		@measureCode			VarChar(2),
		@packingCode			VarChar(3),
		@EMS_MFAG_NUMBERS		Varchar(50)
AS

Begin Transaction
	Declare @Cd_Prod	int
	Set @Cd_Prod=(select cd_Prod from produto_cliente where cd_Proc_Cliente=@cd_Proc_Cliente and cd_cliente=@cd_cliente)
		
	if not exists (select cd_Prod from produto_perigoso where cd_Prod =@cd_Prod)
		Begin
			Insert into
				Produto_Perigoso
					(
						cd_prod,
						uncode,
						classCode,
						HazMat_Name_Material,
						HazMat_Description,
						HazMat_Contact,
						HazMat_Phone,
						FlashPoint,	
						measureCode,
						packingCode,
						EMS_MFAG_NUMBERS
					)
				values
					(
						@cd_prod,
						@Uncode,
						@classCode,
						@HazMat_Name_Material,
						@HazMat_Description,
						@HazMat_Contact,
						@HazMat_Phone,
						@FlashPoint,
						@measureCode,
						@packingCode,
						@EMS_MFAG_NUMBERS
					)
		end
	Else
		Begin
			Update
				Produto_Perigoso
			Set
				uncode = @Uncode,
				classCode = @classCode,
				HazMat_Name_Material = @HazMat_Name_Material,
				HazMat_Description = @HazMat_Description,
				HazMat_Contact = @HazMat_Contact,
				HazMat_Phone = @HazMat_Phone,
				FlashPoint = @FlashPoint,
				measureCode = @measureCode,
				packingCode = @packingCode,
				EMS_MFAG_NUMBERS = @EMS_MFAG_NUMBERS
			Where
				cd_Prod=@cd_Prod
		End
	


	if @@error <> 0
		Begin
			Rollback transaction
			return -1
		End

Commit Transaction


				
	










GO
