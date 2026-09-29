SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spATL_Tipo_Campo_Cliente_Modais_InsUpd]
( 
	@Id_Campo		int,
	--@Descr_campo	VarChar(30),
	@House			char(1),
	@Master			char(1),
	@Export			char(1),
	@Import			char(1),
	@Air			char(1),
	@Ocean			char(1),
	@Other			char(1)
)

AS
--Declare @Id_Campo	int
	--Set @Id_Campo=(select top 1 Id_Campo from Tipo_Campo_Cliente where Descr_Campo=@Descr_Campo)

BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Tipo_Campo_Produto_Cliente
	BEGIN TRY		
		
	if not exists (select ID_Campo from Tipo_Campo_Cliente_Modais where Id_Campo=@ID_Campo)
		Begin
			Insert into
				Tipo_Campo_Cliente_Modais
					(Id_Campo,House,Master,Export,Import,Air,Ocean,Other
					)
				values
					(@Id_Campo,@House,@Master,@Export,@Import,@Air,@Ocean,@Other)
		end
	Else
		Begin
			Update
				Tipo_Campo_Cliente_Modais
			Set
				House=@House,
				Master=@Master,
				Export=@Export,
				Import=@Import,
				Air=@Air,
				Ocean=@Ocean,
				Other=@Other
			Where
				Id_Campo=@ID_Campo
		End
	
	
	Select @ID_Campo as Retorno;
		
		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	

END

--Begin Transaction

	
	
--	if not exists (select ID_Campo from Tipo_Campo_Cliente_Modais where Id_Campo=@ID_Campo)
--		Begin
--			Insert into
--				Tipo_Campo_Cliente_Modais
--					(Id_Campo,House,Master,Export,Import,Air,Ocean,Other
--					)
--				values
--					(@Id_Campo,@House,@Master,@Export,@Import,@Air,@Ocean,@Other)
--		end
--	Else
--		Begin
--			Update
--				Tipo_Campo_Cliente_Modais
--			Set
--				House=@House,
--				Master=@Master,
--				Export=@Export,
--				Import=@Import,
--				Air=@Air,
--				Ocean=@Ocean,
--				Other=@Other
--			Where
--				Id_Campo=@ID_Campo
--		End
	
--	if @@error <> 0
--		Begin
--			Rollback transaction
--			return -1
--		End

--Commit Transaction

GO
