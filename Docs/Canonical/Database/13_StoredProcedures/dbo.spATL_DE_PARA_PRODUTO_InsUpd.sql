SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help DE_PARA_PRODUTO
CREATE Procedure [dbo].[spATL_DE_PARA_PRODUTO_InsUpd]
		
		@Cd_Cliente				varchar(10),
		--@GMID					varchar(100),
		@GMID 					varchar(30),
		@GMID_Descr_Curta		varchar(100),
		@Trade_Product_Code		varchar(8),
		@Trade_Product_Descr	varchar(40),
		@Plan_Product_Code		varchar(8),
		@Plan_Product_Descr		varchar(40),
		@Product_Center_Code	varchar(8),
		@Product_Center_Descr	varchar(40),
		@Performance_Center_Code	varchar(8),
		@Performance_Center_Descr	varchar(40),
		@Value_Center_Code		varchar(8),
		@Value_Center_Descr		varchar(40),
		@Business_Code			varchar(8),
		@Business_Descr			varchar(40),
		@Business_Group_Code	varchar(8),
		@Business_Group_Descr	varchar(40),
		@P_Descricao			varchar(150),
		@S_Descricao			varchar(150),
		@ITO_Especialista		varchar(50)

AS

Begin Transaction


if exists(select Produto_Descr from Produto_Cliente where cd_Proc_Cliente = @GMID and Cd_Cliente=@Cd_Cliente)
	BEGIN
		if not exists(select gmid from DE_PARA_PRODUTO where gmid=@GMID and Cd_Cliente=@Cd_Cliente)
			BEGIN
				INSERT INTO 
					DE_PARA_PRODUTO
						(
							Cd_Cliente,GMID,GMID_Descr_Curta,Trade_Product_Code,Trade_Product_Descr,Plan_Product_Code,
							Plan_Product_Descr,Product_Center_Code,Product_Center_Descr,Performance_Center_Code,
							Performance_Center_Descr,Value_Center_Code,Value_Center_Descr,Business_Code,Business_Descr,
							Business_Group_Code,Business_Group_Descr,P_Descricao,S_Descricao,ITO_Especialista,
							dt_ins
						)
				VALUES

						(
							@Cd_Cliente,@GMID,@GMID_Descr_Curta,@Trade_Product_Code,@Trade_Product_Descr,@Plan_Product_Code,
							@Plan_Product_Descr,@Product_Center_Code,@Product_Center_Descr,@Performance_Center_Code,
							@Performance_Center_Descr,@Value_Center_Code,@Value_Center_Descr,@Business_Code,@Business_Descr,
							@Business_Group_Code,@Business_Group_Descr,@P_Descricao,@S_Descricao,@ITO_Especialista,
							GETDATE()
						)
			END

		ELSE
			BEGIN
				UPDATE
					DE_PARA_PRODUTO
						SET
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
							Business_Group_Descr=@Business_Group_Descr,
							P_Descricao=@P_Descricao,
							S_Descricao=@S_Descricao,
							ITO_Especialista=@ITO_Especialista,
							dt_ins = GETDATE()
						WHERE
							GMID=@GMID and Cd_Cliente=@Cd_Cliente
			END
	END
	
	if @@Error<>0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END
COMMIT TRANSACTION

GO
