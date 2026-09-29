SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  Procedure [dbo].[spDeParaProduto_XLS2SQL_InsUpd]
		
		@Cd_Cliente			        Varchar(10),
		@GMID				        VarChar(8),
		@GMID_Descr_Curta		    VarChar(40),
		@P_Descricao			    VarChar(150),
		@S_Descricao			    VarChar(150),
		@Business_Group_Code		VarChar(8),
		@Business_Group_Name		VarChar(40),
		@Business_Code			    VarChar(8),
		@Business_Name			    VarChar(40),
		@Value_Center_Code		    VarChar(8),
		@Value_Center_Descr		    VarChar(40)

AS

Begin Transaction
	if not exists(select gmid from DE_PARA_PRODUTO where gmid=@GMID and Cd_Cliente=@Cd_Cliente)
		BEGIN
			INSERT INTO 
				DE_PARA_PRODUTO
						(
							Cd_Cliente, GMID, GMID_Descr_Curta, P_Descricao, S_Descricao, Business_Group_Code, 
							Business_Group_Descr, Business_Code,Business_Descr,Value_Center_Code,Value_Center_Descr
						)
				VALUES

						(
							@Cd_Cliente, @GMID, @GMID_Descr_Curta, @P_Descricao, @S_Descricao, @Business_Group_Code,
							@Business_Group_Name, @Business_Code, @Business_Name, @Value_Center_Code, @Value_Center_Descr
						)
		END

	ELSE
		BEGIN
				UPDATE
					DE_PARA_PRODUTO
						SET
							Business_Group_Code=@Business_Group_Code,
							Business_Group_Descr=@Business_Group_Name,							
							--Business_Code=@Business_Code,
							Business_Descr=@Business_Name,
							Value_Center_Descr=@Value_Center_Descr	
									
--							GMID_Descr_Curta=@GMID_Descr_Curta,
--							P_Descricao=@P_Descricao,
--							S_Descricao=@S_Descricao,
							--Value_Center_Code=@Value_Center_Code,						
							
							
							
						WHERE
							GMID=@GMID and Cd_Cliente=@Cd_Cliente
		END
	if @@Error<>0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END
COMMIT TRANSACTION

GO
