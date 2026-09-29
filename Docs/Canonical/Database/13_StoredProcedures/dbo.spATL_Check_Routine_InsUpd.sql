SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_Check_Routine_InsUpd]
( 
	@ID					bigint,
	@Routine_Name		varchar(250),
	@Server				varchar(250),
	@Path				varchar(MAX),
	@SVN_Download		varchar(MAX),
	@Notes				varchar(MAX),
	@Enabled			bit,
    @Cd_Usuario			varchar(6),
    @Dt_Ins				datetime
 )
  
AS
BEGIN

	BEGIN TRY

		BEGIN TRANSACTION;
		
		Declare @ID_New as bigint;


	If  exists (select ID from ATL_INT.[dbo].Check_Routine where ID = @ID)
		Begin
			Update
				ATL_INT.[dbo].Check_Routine
			Set					
				[Routine_Name] = @Routine_Name,
				[Server] = @Server,
				[Path] = @Path,
				[SVN_Download] = @SVN_Download,
				[Notes] = @Notes,
				[Enabled] =@Enabled,
				[Cd_Usuario] = @Cd_Usuario,
				[Dt_Ins] = GETDATE()			
			Where
				ID = @ID

				set @ID_New = @ID

		End
	Else
		Begin
			Insert into
				ATL_INT.[dbo].Check_Routine
				([Routine_Name], [Server], [Path], [SVN_Download], [Notes], [Enabled], [Cd_Usuario], [Dt_Ins])
			values
				(@Routine_Name, @Server, @Path, @SVN_Download, @Notes, @Enabled,@Cd_Usuario,GETDATE())

				set @ID_New = @@IDENTITY;

		End

		Select @ID_New as Retorno;	

Commit Transaction

END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	

END

GO
