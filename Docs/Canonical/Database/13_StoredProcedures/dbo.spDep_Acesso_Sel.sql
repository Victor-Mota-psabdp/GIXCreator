SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spDep_Acesso_Sel]
	@Nome_tela varchar(50),
	@cd_area varchar(3)
as

BEGIN
	Declare @cd_Tela varchar(3)
	set @cd_tela=(select cd_tela from Tela_ATL where Nome_Tela=@Nome_Tela)

	Select 
		AR.nome_area nome_Area,
		TE.nome_tela nome_tela,	
		leitura, 
		gravacao, 
		exclusao 
	From 
		dep_acesso DA with(nolock)				
		Left join area AR with(nolock) on AR.cd_area=DA.cd_area
		Left join tela_atl TE with(nolock) on TE.cd_tela=DA.cd_tela
	Where 
		DA.cd_area=@cd_area and	DA.cd_tela=@cd_tela				
END
/*

	ELSE
		if @cd_area <> ''
			BEGIN
				Select 
					AR.nome_area nome_Area,
					TE.nome_tela nome_tela,					
					leitura, 
					gravacao, 
					exclusao 
				From 
					dep_acesso DA
            		Left join area AR on AR.cd_area=DA.cd_area
					left join tela_atl TE on TE.cd_tela=DA.cd_tela
				Where
					DA.cd_area=@cd_area
			END
		ELSE
			BEGIN
				Select 
					AR.nome_area nome_Area,
					TE.nome_tela nome_tela,					 
					leitura, 
					gravacao, 
					exclusao 
				From 
					dep_acesso DA
					Left join area AR on AR.cd_area=DA.cd_area
            		left join tela_atl TE on TE.cd_tela=DA.cd_tela					
				Where
					DA.cd_tela=@cd_tela
			END	

*/





GO
