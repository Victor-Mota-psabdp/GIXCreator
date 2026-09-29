SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



create Procedure [dbo].[spNivel_Acesso_Sel] --'ADM','%','%'
	@cd_area varchar(3),
	@cd_tela varchar(3),
	@cd_nivel varchar(3)
as
--	if	@cd_area <> '' and @cd_tela <> '' and @cd_nivel <> ''
--		BEGIN
			Select 
				AR.nome_area nome_Area,
				TE.nome_tela nome_tela,	
				N.tipo_nivel nome_nivel,
				leitura, 
				gravacao, 
				exclusao 
			From 
				nivel_acesso NA				
				Left join area AR on AR.cd_area=NA.cd_area
				Left join tela_atl TE on TE.cd_tela=NA.cd_tela
				left join nivel N on N.cd_nivel=NA.cd_nivel
			Where 
				NA.cd_area like @cd_area and
				NA.cd_tela like @cd_tela	and
				NA.cd_nivel like @cd_nivel							
	--	END
--	ELSE
--		if @cd_area <> ''
--			BEGIN
--				Select 
--					AR.nome_area nome_Area,
--					TE.nome_tela nome_tela,	
--					N.tipo_nivel nome_nivel,
--					leitura, 
--					gravacao, 
--					exclusao 
--				From 
--					nivel_acesso NA				
--					Left join area AR on AR.cd_area=NA.cd_area
--					Left join tela TE on TE.cd_tela=NA.cd_tela
--					left join nivel N on N.cd_nivel=NA.cd_nivel
--				Where 
--					NA.cd_area=@cd_area
--			END
--	ELSE
--		if @cd_area <> '' and @cd_tela <> ''
--			BEGIN
--				Select 
--					AR.nome_area nome_Area,
--					TE.nome_tela nome_tela,	
--					N.tipo_nivel nome_nivel,
--					leitura, 
--					gravacao, 
--					exclusao 
--				From 
--					nivel_acesso NA				
--					Left join area AR on AR.cd_area=NA.cd_area
--					Left join tela TE on TE.cd_tela=NA.cd_tela
--					left join nivel N on N.cd_nivel=NA.cd_nivel
--				Where 				
--					NA.cd_area=@cd_area and
--					NA.cd_tela=@cd_tela
--			END	
--	ELSE		
--		if @cd_area <> '' and @cd_nivel <> ''
--			BEGIN
--				Select 
--					AR.nome_area nome_Area,
--					TE.nome_tela nome_tela,	
--					N.tipo_nivel nome_nivel,
--					leitura, 
--					gravacao, 
--					exclusao 
--				From 
--					nivel_acesso NA				
--					Left join area AR on AR.cd_area=NA.cd_area
--					Left join tela TE on TE.cd_tela=NA.cd_tela
--					left join nivel N on N.cd_nivel=NA.cd_nivel
--				Where 				
--					NA.cd_area=@cd_area and
--					NA.cd_nivel=@cd_nivel
--			END	
--	ELSE
--		if @cd_tela <> ''
--			BEGIN
--				Select 
--					AR.nome_area nome_Area,
--					TE.nome_tela nome_tela,	
--					N.tipo_nivel nome_nivel,
--					leitura, 
--					gravacao, 
--					exclusao 
--				From 
--					nivel_acesso NA				
--					Left join area AR on AR.cd_area=NA.cd_area
--					Left join tela TE on TE.cd_tela=NA.cd_tela
--					left join nivel N on N.cd_nivel=NA.cd_nivel
--				Where 					
--					NA.cd_tela=@cd_tela
--			END	
--	ELSE
--		if @cd_tela <> '' and @cd_nivel <> ''
--			BEGIN
--				Select 
--					AR.nome_area nome_Area,
--					TE.nome_tela nome_tela,	
--					N.tipo_nivel nome_nivel,
--					leitura, 
--					gravacao, 
--					exclusao 
--				From 
--					nivel_acesso NA				
--					Left join area AR on AR.cd_area=NA.cd_area
--					Left join tela TE on TE.cd_tela=NA.cd_tela
--					left join nivel N on N.cd_nivel=NA.cd_nivel
--				Where 				
--					NA.cd_tela=@cd_tela and
--					NA.cd_nivel=@cd_nivel
--			END
--	ELSE
--		if @cd_nivel <> ''
--			BEGIN
--				Select 
--					AR.nome_area nome_Area,
--					TE.nome_tela nome_tela,	
--					N.tipo_nivel nome_nivel,
--					leitura, 
--					gravacao, 
--					exclusao 
--				From 
--					nivel_acesso NA				
--					Left join area AR on AR.cd_area=NA.cd_area
--					Left join tela TE on TE.cd_tela=NA.cd_tela
--					left join nivel N on N.cd_nivel=NA.cd_nivel
--				Where 				
--					NA.cd_nivel=@cd_nivel
--			END


GO
