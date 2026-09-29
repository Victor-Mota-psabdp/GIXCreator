SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Servico_Sel]
@cd_servico  int,
@nome_servico varchar(30),
@Tipo char(1),
@cd_site	varchar(1)
as

if @Tipo = 'A'
	Begin
		if @cd_servico  <> '' or @cd_servico  is not NULL
			Begin
				select cd_servico , Item_lei + ' - ' + Descricao as nome_servico from dbo.Tipo_NF_Doc_Register
				where cd_servico  = @cd_servico  and cd_site = @cd_site
			End
		else
			Begin
				select cd_servico, Item_lei + ' - ' + Descricao as nome_servico from dbo.Tipo_NF_Doc_Register
				where Item_lei + ' - ' + Descricao = @nome_servico and cd_site = @cd_site
			End
	End
else if @Tipo = 'B' 
	Begin
		if @cd_servico <> '' or @cd_servico is not NULL
			Begin
				select cd_servico, Item_lei + ' - ' + Descricao as nome_servico from dbo.Tipo_NF_Doc_Register
				where cd_servico = @cd_servico and cd_site = @cd_site
			End
		else
			Begin
				select cd_servico, Item_lei + ' - ' + Descricao as nome_servico from dbo.Tipo_NF_Doc_Register
				where Item_lei + ' - ' + Descricao = @nome_servico and cd_site = @cd_site
			End	
	End


GO
