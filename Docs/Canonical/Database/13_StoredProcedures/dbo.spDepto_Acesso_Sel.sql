SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE Procedure [dbo].[spDepto_Acesso_Sel] --'002','csr'

	@cd_Tela varchar(3),
	@cd_Area varchar(3)

as

BEGIN

	if @cd_Area = '' and @cd_Tela = ''
		Begin
			Select 
				AR.nome_area nome_Area,
				TE.nome_tela nome_tela,	
				leitura, 
				gravacao, 
				exclusao 
			From 
				dep_acesso DA	with(nolock) 			
				Left join area AR with(nolock) on AR.cd_area=DA.cd_area
				Left join tela_atl TE with(nolock)  on TE.cd_tela=DA.cd_tela	
				
		End
	Else if @cd_Tela = ''
		Begin
			Select 
				AR.nome_area nome_Area,
				TE.nome_tela nome_tela,					
				leitura, 
				gravacao, 
				exclusao 
			From 
				dep_acesso DA with(nolock) 
        		Left join area AR with(nolock)  on AR.cd_area=DA.cd_area
				left join tela_atl  TE with(nolock)  on TE.cd_tela=DA.cd_tela
			Where
				DA.cd_area=@cd_area
				
		End
	Else
		Begin
			Select 
				AR.nome_area nome_Area,
				TE.nome_tela nome_tela,					 
				leitura, 
				gravacao, 
				exclusao 
			From 
				dep_acesso DA with(nolock) 
				Left join area AR with(nolock)  on AR.cd_area=DA.cd_area
        		left join tela_atl TE  with(nolock)  on TE.cd_tela=DA.cd_tela					
			Where
				DA.cd_tela=@cd_tela and DA.cd_area=@cd_area
				
		End
END


GO
