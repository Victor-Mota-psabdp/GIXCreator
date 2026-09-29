SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Pessoa_LLP
/*
select E.Cd_Pais,* from pessoa PP with(nolock) 
join Endereco E with(nolock)  on E.cd_pes=PP.cd_pes 
join pessoa_llp LLP with(nolock)  on LLP.cd_pes=PP.cd_pes
where cd_vendor='1234536' or cd_planta='1234536'
*/
CREATE procedure [dbo].[spPessoa_LLP_IntegrationExcel_Sel]
(
	@cd_vendor		VarChar(20),
	@cd_planta		VarChar(20)
)
as
	select top 1 E.Cd_Pais from pessoa PP with(nolock) 
		join Endereco E with(nolock)  on E.cd_pes=PP.cd_pes 
		join pessoa_llp LLP with(nolock)  on LLP.cd_pes=PP.cd_pes
	Where
		LLP.cd_vendor=@cd_vendor or LLP.cd_planta=@cd_planta


	

	

	
GO
