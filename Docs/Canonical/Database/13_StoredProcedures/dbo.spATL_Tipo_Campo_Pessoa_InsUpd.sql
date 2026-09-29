SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Campo_Pessoa
--spATL_Tipo_Campo_Pessoa_Sel
CREATE Procedure [dbo].[spATL_Tipo_Campo_Pessoa_InsUpd] 
(
	@Id_Campo			int	,
	@Cd_Pes_Grupo		varchar(10),			
	@Cd_Tipo			varchar(1),
	@Descr_campo		VarChar(30),
	@Tab_Relacionada	VarChar(60),
	@Cod_Busca			VarChar(20),
	@Campo_Exibicao		VarChar(30)
)

AS

BEGIN


--Exceção(try/CATCH)
--Transação
--sp_help Tipo_Campo_Produto_Pessoa
	BEGIN TRY
		
	if not exists(select Id_Campo from [dbo].[Tipo_Campo_Pessoa] where Id_Campo=@Id_Campo)
		Begin
			Set @Id_Campo=(select Isnull(max(Id_Campo),0) + 1 from [dbo].[Tipo_Campo_Pessoa])
		end
		
	if not exists (select ID_Campo from [dbo].[Tipo_Campo_Pessoa] where Cd_Pes_Grupo=@Cd_Pes_Grupo and Id_Campo=@ID_Campo)
		Begin
			Insert into
				Tipo_Campo_Pessoa
					(Id_Campo,
					Cd_Pes_Grupo,
					Tipo,Descr_Campo,
					Tab_Relacionada,
					Cod_Busca,
					Campo_Exibicao)
				values
					(@Id_Campo,
					@Cd_Pes_Grupo,
					@Cd_Tipo,
					@Descr_Campo,
					@Tab_Relacionada,
					@Cod_Busca,
					@Campo_Exibicao)
		end
	Else
		Begin
			Update
				Tipo_Campo_Pessoa
			Set
				Tipo=@Cd_Tipo,
				Descr_Campo=@Descr_Campo,
				Tab_Relacionada=@Tab_Relacionada,
				Cod_Busca=@Cod_Busca,
				Campo_Exibicao=@Campo_Exibicao
			Where
				Cd_Pes_Grupo=@Cd_Pes_Grupo 
				and Id_Campo=@ID_Campo
		End
	
	
	Select @ID_Campo as Retorno;
		
		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	

END

GO
