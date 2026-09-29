SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spCentroCustoSite_InsUPDel] 
	@Nome_centro_custo		varChar(30),
	@Nome_site				VarChar(30),
	@particip				decimal(4,2),
	@tipo					varchar(1)
	
AS

Begin Transaction
	
	Declare @cd_centro_custo varchar(5) 
	Declare @site char(1)

	set @cd_centro_custo = (select cd_centro_custo from centro_custo where Nome_centro_custo = @Nome_centro_custo)
	set @site = (select cd_site from site where nome_site = @Nome_site)

	if @tipo <> 'D'
		Begin
			if not exists (select * from centro_custo_site where cd_centro_custo=@cd_centro_custo and site=@site)
				Begin
					Insert into
						centro_custo_site 					
					values
						(
							@cd_centro_custo,
							@site,
							@Particip
						)
				end
			Else
				Begin
					Update
						centro_custo_site 
						Set
							particip = @Particip					
					Where
						cd_centro_custo=@cd_centro_custo and site=@site
				End
		End
	Else
		if exists (select * from centro_custo_site where cd_centro_custo=@cd_centro_custo and site=@site)
			begin
				delete centro_custo_site where cd_centro_custo=@cd_centro_custo and site=@site
			end
		


	if @@error <> 0
		Begin
			Rollback transaction
			return -1
		End

Commit Transaction


				
	











GO
