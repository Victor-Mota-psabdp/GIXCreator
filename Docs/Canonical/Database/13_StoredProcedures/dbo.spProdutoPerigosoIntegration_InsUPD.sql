SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spProdutoPerigosoIntegration_InsUPD]
		@Cd_Prod	int,
		@Cd_Proc_Cliente		VarChar(30),
		@Cd_Cliente				VarChar(10),		
		@Uncode					VarChar(4),
		@classCode				VarChar(4),
		@HazMat_Name_Material	VarChar(30),
		@HazMat_Description		VarChar(60),
		@HazMat_Contact			VarChar(12),
		@HazMat_Phone			VarChar(12),
		@FlashPoint				VarChar(3),
		@measureCode			VarChar(2),
		@packingCode			VarChar(3)
AS

Begin Transaction
		
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
						packingCode
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
						@packingCode
					)
		end	


	if @@error <> 0
		Begin
			Rollback transaction
			return -1
		End

Commit Transaction


				
	










GO
