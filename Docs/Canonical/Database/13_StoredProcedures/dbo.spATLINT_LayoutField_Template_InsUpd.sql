SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help LayoutField_Template
create procedure [dbo].[spATLINT_LayoutField_Template_InsUpd] 
(			
	@ID				int,
	@PK_Code		varchar(60),
	@Name			varchar(55),
	@TypeField		varchar(15),
	@Path			varchar(100),
	@CheckBox		bit,
	@ClassName		varchar(60),
	@Parameter1		int,
	@FieldMapClass	varchar(60),
	@Cd_Tipo		int,
	@FieldMapClass2	varchar(60),
	@FieldMapClass3	varchar(60),
	@FieldMapClass4	varchar(60),
	@FieldMapClass5	varchar(60),
	@FieldMapClass6	varchar(60)
)

AS

BEGIN TRANSACTION	
	
	if EXISTS(select ID	 from ATL_INT.dbo.LayoutField_Template With(nolock) where ID=@ID)
		BEGIN
			UPDATE
				ATL_INT.dbo.LayoutField_Template			
			SET 
				[PK_Code] = @PK_Code ,[Name] = @Name ,[TypeField] = @TypeField ,[Path] = @Path
			  ,[CheckBox] = @CheckBox  ,[ClassName] = @ClassName  ,[Parameter1] = @Parameter1
			  ,[FieldMapClass] = @FieldMapClass	  ,[Cd_Tipo] = @Cd_Tipo  ,[FieldMapClass2] = @FieldMapClass2
			  ,[FieldMapClass3] = @FieldMapClass3  ,[FieldMapClass4] = @FieldMapClass4  ,[FieldMapClass5] = @FieldMapClass5
			  ,[FieldMapClass6] = @FieldMapClass6
		  where 
			ID=@ID
		END
	ELSE
		BEGIN			
			INSERT INTO ATL_INT.[dbo].[LayoutField_Template]
				([PK_Code],[Name],[TypeField],[Path],[CheckBox],[ClassName],[Parameter1],[FieldMapClass],[Cd_Tipo]
				,[FieldMapClass2],[FieldMapClass3],[FieldMapClass4],[FieldMapClass5],[FieldMapClass6])
			VALUES
				(@PK_Code,@Name,@TypeField,@Path,@CheckBox,@ClassName,@Parameter1,@FieldMapClass,@Cd_Tipo
				,@FieldMapClass2,@FieldMapClass3,@FieldMapClass4,@FieldMapClass5,@FieldMapClass6)
		END

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END

COMMIT TRANSACTION
	













GO
