SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Campo_Produto_Cliente
CREATE Procedure [dbo].[spATL_Tipo_Campo_Produto_Cliente_InsUpd] 
(
	@Id_Campo			int,
	@Cd_Pes_Grupo		varchar(10),
	@Cd_Tipo			varchar(1),
	@Descr_Campo		VarChar(30),
	@Tab_Relacionada	VarChar(30),
	@Cod_Busca			VarChar(20),
	@Campo_Exibicao		VarChar(30)
)
AS
	
BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Tipo_Campo_Produto_Cliente
	BEGIN TRY
	
	if not exists(select Id_Campo from [dbo].[Tipo_Campo_Produto_Cliente] where Descr_Campo=@Descr_Campo)
		Begin
			Set @Id_Campo=(select Isnull(max(Id_Campo),0) + 1 from [dbo].[Tipo_Campo_Produto_Cliente])
		end
	Else
		Begin
			Set @Id_Campo=(select top 1 Id_Campo from [dbo].[Tipo_Campo_Produto_Cliente] where Descr_Campo=@Descr_Campo)
		End
		
		
	if not exists (select ID_Campo from [dbo].[Tipo_Campo_Produto_Cliente] where 
				Cd_Pes_Grupo=@Cd_Pes_Grupo and Id_Campo=@ID_Campo)
		Begin
			Insert into
				[dbo].[Tipo_Campo_Produto_Cliente]
					(
						Id_Campo,
						Cd_Pes_Grupo,
						Tipo,
						Descr_Campo,
						Tab_Relacionada,
						Cod_Busca,
						Campo_Exibicao
					)
				values
					(
						@Id_Campo,
						@Cd_Pes_Grupo,
						@Cd_Tipo,
						@Descr_Campo,
						@Tab_Relacionada,
						@Cod_Busca,
						@Campo_Exibicao
					)
		end
	Else
		Begin
			Update
				[dbo].[Tipo_Campo_Produto_Cliente]
				Set
					Tipo=@Cd_Tipo,
					Descr_Campo=@Descr_Campo,
					Tab_Relacionada=@Tab_Relacionada,
					Cod_Busca=@Cod_Busca,
					Campo_Exibicao=@Campo_Exibicao
			Where
				Cd_Pes_Grupo=@Cd_Pes_Grupo and Id_Campo=@ID_Campo
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
	
--	if not exists(select Id_Campo from [dbo].[Tipo_Campo_Produto_Cliente] where Descr_Campo=@Descr_Campo)
--		Begin
--			Set @Id_Campo=(select Isnull(max(Id_Campo),0) + 1 from [dbo].[Tipo_Campo_Produto_Cliente])
--		end
--	Else
--		Begin
--			Set @Id_Campo=(select top 1 Id_Campo from [dbo].[Tipo_Campo_Produto_Cliente] where Descr_Campo=@Descr_Campo)
--		End

	
--	if not exists (select ID_Campo from [dbo].[Tipo_Campo_Produto_Cliente] where 
--				Cd_Pes_Grupo=@Cd_Pes_Grupo and Id_Campo=@ID_Campo)
--		Begin
--			Insert into
--				[dbo].[Tipo_Campo_Produto_Cliente]
--					(
--						Id_Campo,
--						Cd_Pes_Grupo,
--						Tipo,
--						Descr_Campo,
--						Tab_Relacionada,
--						Cod_Busca,
--						Campo_Exibicao
--					)
--				values
--					(
--						@Id_Campo,
--						@Cd_Pes_Grupo,
--						@Cd_Tipo,
--						@Descr_Campo,
--						@Tab_Relacionada,
--						@Cod_Busca,
--						@Campo_Exibicao
--					)
--		end
--	Else
--		Begin
--			Update
--				[dbo].[Tipo_Campo_Produto_Cliente]
--				Set
--					Tipo=@Cd_Tipo,
--					Descr_Campo=@Descr_Campo,
--					Tab_Relacionada=@Tab_Relacionada,
--					Cod_Busca=@Cod_Busca,
--					Campo_Exibicao=@Campo_Exibicao
--			Where
--				Cd_Pes_Grupo=@Cd_Pes_Grupo and Id_Campo=@ID_Campo
--		End
	


--	if @@error <> 0
--		Begin
--			Rollback transaction
--			return -1
--		End

--Commit Transaction


				
	











GO
