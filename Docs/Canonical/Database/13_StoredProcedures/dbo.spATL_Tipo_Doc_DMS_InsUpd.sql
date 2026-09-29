SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Doc_DMS
CREATE PROCEDURE [dbo].[spATL_Tipo_Doc_DMS_InsUpd]
(
	@ID_TP_DC				BIGINT,
	@DMS_Code				VARCHAR(5),
	@Document_Type_Name		VARCHAR(250),
	@Role					VARCHAR(250),
	@Comment				VARCHAR(250),
	@ID_DC					Int,
	@Ativo					BIT,
	@Cd_Usuario				VARCHAR(6),
	@dt_ins					DATETIME
)

AS

Begin Transaction

	If  exists (select DMS_Code from Tipo_Doc_DMS where DMS_Code=@DMS_Code)
		Begin
			Update
				Tipo_Doc_DMS
			Set
				ID_DC = @ID_DC,
				Document_Type_Name=@Document_Type_Name,
				Role=@Role,
				Comment=@Comment,
				Ativo = @Ativo,
				Cd_Usuario=@Cd_Usuario,
				dt_ins = GETDATE()				
			Where
				DMS_Code=@DMS_Code
		End
	Else
		Begin
			Insert Tipo_Doc_DMS
				(DMS_Code,ID_DC,Document_Type_Name,Role,Comment,Ativo,Cd_Usuario)
			Values
				(@DMS_Code,@ID_DC,@Document_Type_Name,@Role,@Comment,@Ativo,@Cd_Usuario)
		End

Commit Transaction

GO
