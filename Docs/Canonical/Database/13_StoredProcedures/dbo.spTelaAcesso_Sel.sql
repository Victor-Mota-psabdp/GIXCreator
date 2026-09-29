SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spTelaAcesso_Sel]
	@cd_tela varchar(3),
	@cd_area varchar(3),
	@cd_nivel varchar(3)
as	
select leitura, gravacao, exclusao from nivel_acesso NA with(nolock)
	join tela_atl TA with(nolock) on TA.cd_tela=NA.cd_tela
	join usuario USA with(nolock) on NA.cd_area=USA.cd_area and NA.cd_nivel = USA.cd_nivel
where
	NA.cd_tela=@cd_tela and
	NA.cd_area=@cd_area and
	NA.cd_nivel=@cd_nivel

GO
