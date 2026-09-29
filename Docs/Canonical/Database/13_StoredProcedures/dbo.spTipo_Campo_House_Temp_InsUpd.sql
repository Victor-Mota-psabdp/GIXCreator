SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ATL_INT.dbo.[Tipo_Campo_House_Temp]
--sp_help Tipo_Campo_House_Temp
create PROCEDURE [dbo].[spTipo_Campo_House_Temp_InsUpd]
(

	@ID_Campo		int,
	@Descr_Campo	varchar(200),
	@Ativo			varchar(200),
	@Cd_Usuario		varchar(200),
	@dt_ins			varchar(200)
)

AS

Begin Transaction

if not exists(select ID_Campo from ATL_INT.dbo.[Tipo_Campo_House_Temp] where ID_Campo= @ID_Campo)
	BEGIN
		SET @ID_Campo=(select Isnull(max(ID_Campo),0)+1 from ATL_INT.dbo.[Tipo_Campo_House_Temp])		
		
		Insert into ATL_INT.dbo.[Tipo_Campo_House_Temp] 
		(
			ID_Campo,Descr_Campo,Ativo,Cd_Usuario,dt_ins
		)
		Values
		(
			@ID_Campo,@Descr_Campo,@Ativo,@Cd_Usuario,@dt_ins
		)
	END
ELSE
	BEGIN
			Update
				ATL_INT.dbo.[Tipo_Campo_House_Temp]
			Set
				Descr_Campo=@Descr_Campo,
				Ativo=@Ativo,
				Cd_Usuario=@Cd_Usuario,
				dt_ins=@dt_ins
			Where
				ID_Campo= @ID_Campo
	END
	
		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

Commit Transaction 


GO
