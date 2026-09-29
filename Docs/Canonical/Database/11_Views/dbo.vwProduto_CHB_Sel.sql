SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--sp_help Produto_CHB
CREATE VIEW [dbo].[vwProduto_CHB_Sel]
AS
		select 
			PH.cd_prod							[Code],
			PC.cd_Proc_Cliente					[Product Code],
			PC.Produto_Descr					[Product Description],
			PC.cd_Cliente						[Group Code], 
			G.apelido							[Group Name],
			PH.Etiqueta_Produto					[Product Tag],
			PH.Tipo_LI								[IL Type],
			PH.Aprovado							[Approved],
			PH.Orgao_Anuente						[Orgao Anuente],		
			convert(varchar(10),PH.Dt_Pesquisa,103)[Date Search],
			PH.Pais_Origem							[Origin Country Code], 
			P.Nome_Pais							[Origin Country Name],			
			PH.Import_License						[Import License],			
			PH.Concentracao						[Concentration],
			PH.Descricao_Longa						[Full Product Description]
		from Produto_CHB PH with(nolock)
			join Produto_Cliente PC on PC.cd_prod = PH.cd_prod
			join Pessoa G with(nolock) on G.Cd_Pes = PC.cd_Cliente
			LEFT join Pais P with(nolock) on P.Cd_Pais = PH.Pais_Origem
	--select 
	--	cd_prod [Code],Etiqueta_Produto,Aprovado,Descricao_Longa,Dt_Pesquisa,Tipo_LI,Import_License,
	--	Orgao_Anuente,Pais_Origem cd_pais, P.Nome_Pais,Concentracao--,Descricao_Longa_Backup
	--from Produto_CHB PC with(nolock)
	--	left join Pais P with(nolock) on P.Cd_Pais = PC.Pais_Origem





GO
