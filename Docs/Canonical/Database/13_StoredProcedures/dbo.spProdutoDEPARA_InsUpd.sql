SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure [dbo].[spProdutoDEPARA_InsUpd]
		
		@Cd_Cliente			        Varchar(10),
		@GMID				        VarChar(8),
		@GMID_Descr_Curta		    VarChar(40),
		@Trade_Product_Code		    VarChar(8),
		@Trade_Product_Descr		VarChar(40),
		@Plan_Product_Code		    VarChar(8),
		@Plan_Product_Descr		    VarChar(40),
		@Product_Center_Code		VarChar(8),
		@Product_Center_Descr		VarChar(40),
		@Performance_Center_Code	VarChar(8),
		@Performance_Center_Descr	VarChar(40),
		@Value_Center_Code		    VarChar(8),
		@Value_Center_Descr		    VarChar(40),
		@Business_Code			    VarChar(8),
		@Business_Descr			    VarChar(40),
		@Business_Group_Code		VarChar(8),
		@Business_Group_Descr		VarChar(40)

AS

Begin Transaction
	if not exists(select gmid from DE_PARA_PRODUTO where gmid=@GMID)
		BEGIN
			INSERT INTO 
				DE_PARA_PRODUTO
						(
							Cd_Cliente,GMID,GMID_Descr_Curta,Trade_Product_Code,Trade_Product_Descr,
							Plan_Product_Code,Plan_Product_Descr,Product_Center_Code,Product_Center_Descr,Performance_Center_Code,
							Performance_Center_Descr,Value_Center_Code,Value_Center_Descr,Business_Code,Business_Descr,Business_Group_Code,Business_Group_Descr
						)
				VALUES

						(
							@Cd_Cliente,@GMID,@GMID_Descr_Curta,@Trade_Product_Code,@Trade_Product_Descr,
							@Plan_Product_Code,@Plan_Product_Descr,@Product_Center_Code,@Product_Center_Descr,@Performance_Center_Code,
							@Performance_Center_Descr,@Value_Center_Code,@Value_Center_Descr,@Business_Code,@Business_Descr,@Business_Group_Code,@Business_Group_Descr
						)
		END

	ELSE
		BEGIN
				UPDATE
					DE_PARA_PRODUTO
						SET
							Cd_Cliente=@Cd_Cliente,
							GMID_Descr_Curta=@GMID_Descr_Curta,
							Trade_Product_Code=@Trade_Product_Code,
							Trade_Product_Descr=@Trade_Product_Descr,
							Plan_Product_Code=@Plan_Product_Code,
							Plan_Product_Descr=@Plan_Product_Descr,
							Product_Center_Code=@Product_Center_Code,
							Product_Center_Descr=@Product_Center_Descr,
							Performance_Center_Code=@Performance_Center_Code,
							Performance_Center_Descr=@Performance_Center_Descr,
							Value_Center_Code=@Value_Center_Code,
							Value_Center_Descr=@Value_Center_Descr,
							Business_Code=@Business_Code,
							Business_Descr=@Business_Descr,
							Business_Group_Code=@Business_Group_Code,
							Business_Group_Descr=@Business_Group_Descr
						WHERE
							GMID=@GMID
		END
	if @@Error<>0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END
COMMIT TRANSACTION
GO
