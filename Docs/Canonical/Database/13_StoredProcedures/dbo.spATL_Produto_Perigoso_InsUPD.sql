SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_Produto_Perigoso_InsUPD]
(
		@Cd_Prod				int,
		@Cd_Proc_Cliente		VarChar(30),
		@Cd_Cliente				VarChar(10),		
		@Uncode					VarChar(4),
		@classCode				VarChar(4),
		@HazMat_Name_Material	VarChar(30),
		@HazMat_Description		VarChar(60),
		@HazMat_Contact			VarChar(12),
		@HazMat_Phone			VarChar(12),
		@FlashPoint				VarChar(5),
		@measureCode			VarChar(2),
		@ShipperProperName		VarChar(60),
		@MarinePollutant		VarChar(60),
		@MFAG					VarChar(60),
		@EMS					VarChar(60),
		@Density				VarChar(60),
		@packingCode			VarChar(3)
)
AS

Begin Transaction
	if @Cd_Prod is null
		Begin
			Set @Cd_Prod=(select cd_Prod from produto_cliente where 
				cd_Proc_Cliente=@cd_Proc_Cliente and cd_cliente=@cd_cliente)
		end
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
						ShipperProperName,
						MarinePollutant,
						MFAG,
						EMS,
						Density,
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
						@ShipperProperName,
						@MarinePollutant,
						@MFAG,
						@EMS,
						@Density,
						@packingCode
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
				ShipperProperName = @ShipperProperName,
				MarinePollutant = @MarinePollutant,
				MFAG = @MFAG,
				EMS = @EMS,
				Density = @Density,
				packingCode = @packingCode
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
