SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spGrupo_Acesso_Sel] --'002','csr'  

	@cd_Tela varchar(3),  
	@Cd_Pes_Grupo varchar(10)  

as  

Select   
	PL.cd_pes codigo_pessoa,  
	TE.nome_tela nome_tela 
FROM Grupo_Acesso GA (nolock)      
INNER JOIN Pessoa_LLP PL (nolock) 
	on GA.Cd_Pes_Grupo=PL.Cd_Pes_Grupo  
INNER JOIN tela_atl TE (nolock)  
	on TE.cd_tela=GA.cd_tela  
Where GA.cd_tela like @cd_tela and GA.Cd_Pes_Grupo like @Cd_Pes_Grupo  



GO
