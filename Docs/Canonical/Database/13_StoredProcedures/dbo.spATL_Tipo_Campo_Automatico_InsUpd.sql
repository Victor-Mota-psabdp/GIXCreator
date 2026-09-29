SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Campo_Automatico
CREATE Procedure [dbo].[spATL_Tipo_Campo_Automatico_InsUpd] 
(
	@Grupo				VarChar(20),
	@Nome_Tipo			VarChar(30),
	@Descr_Campo		VarChar(30),
	@Tab_Relacionada	VarChar(30),
	@Cod_Busca			VarChar(20),
	@Campo_Exibicao		VarChar(30)
)
AS

Begin Transaction
	Declare @Id_Campo	int
	Declare @Cd_Pes_Grupo varchar(10)
	set @Cd_Pes_Grupo=(select Cd_Pes from Pessoa where apelido=@Grupo)

	Declare @Cd_Tipo varchar(1)
	set @Cd_Tipo=(select Cd_Tipo from Tipo_Variavel where Nome_Tipo=@Nome_Tipo)
	
	
	if not exists(select Id_Campo from [dbo].[Tipo_Campo_Automatico] where Descr_Campo=@Descr_Campo)
		Begin
			Set @Id_Campo=(select Isnull(max(Id_Campo),0) + 1 from [dbo].[Tipo_Campo_Automatico])
		end
	Else
		Begin
			Set @Id_Campo=(select top 1 Id_Campo from [dbo].[Tipo_Campo_Automatico] where Descr_Campo=@Descr_Campo)
		End

	
	if not exists (select ID_Campo from [dbo].[Tipo_Campo_Automatico] where Cd_Pes_Grupo=@Cd_Pes_Grupo and Id_Campo=@ID_Campo)
		Begin
			Insert into
				[dbo].[Tipo_Campo_Automatico]
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
				[dbo].[Tipo_Campo_Automatico]
				Set
					Tipo=@Cd_Tipo,
					Descr_Campo=@Descr_Campo,
					Tab_Relacionada=@Tab_Relacionada,
					Cod_Busca=@Cod_Busca,
					Campo_Exibicao=@Campo_Exibicao
			Where
				Cd_Pes_Grupo=@Cd_Pes_Grupo and Id_Campo=@ID_Campo
		End
	


	if @@error <> 0
		Begin
			Rollback transaction
			return -1
		End

Commit Transaction

GO
