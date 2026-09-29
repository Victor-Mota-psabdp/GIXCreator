SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spTipoCampoOrdem_InsUPD] 
	@Grupo				VarChar(20),
	@Tipo				Char(1),
	@Descr_campo		VarChar(30),
	@Tab_Relacionada	VarChar(30),
	@Cod_Busca			VarChar(20),
	@Campo_Exibicao		VarChar(30)
AS

Begin Transaction
	Declare @Id_Campo	int
	Declare @Cd_Pes_Grupo varchar(10)
	set @Cd_Pes_Grupo=(select Cd_Pes from Pessoa where apelido=@Grupo)

	if not exists(select Id_Campo from Tipo_Campo_Ordem where Descr_Campo=@Descr_Campo and id_campo <> 900)
		Begin
			Set @Id_Campo=(select Isnull(max(Id_Campo),0) + 1 from Tipo_Campo_Ordem where id_campo <> 900)
		end
	Else
		Begin
			Set @Id_Campo=(select top 1 Id_Campo from Tipo_Campo_Ordem where Descr_Campo=@Descr_Campo and id_campo <> 900)
		End

	
	if not exists (select ID_Campo from Tipo_Campo_Ordem where Cd_Pes_Grupo=@Cd_Pes_Grupo and Id_Campo=@ID_Campo)
		Begin
			Insert into
				Tipo_Campo_Ordem
					(
						Id_Campo,
						Cd_Pes_Grupo,
						Tipo,
						Descr_Campo,
						Tab_Relacionada,
						Cod_Busca_PK,
						Campo_Exibicao,
						Ativo
					)
				values
					(
						@Id_Campo,
						@Cd_Pes_Grupo,
						@Tipo,
						@Descr_Campo,
						@Tab_Relacionada,
						@Cod_Busca,
						@Campo_Exibicao,
						1
					)
		end
	Else
		Begin
			Update
				Tipo_Campo_Ordem
				Set
					Tipo=@Tipo,
					Descr_Campo=@Descr_Campo,
					Tab_Relacionada=@Tab_Relacionada,
					Cod_Busca_PK=@Cod_Busca,
					Campo_Exibicao=@Campo_Exibicao,
					ativo = 1
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
