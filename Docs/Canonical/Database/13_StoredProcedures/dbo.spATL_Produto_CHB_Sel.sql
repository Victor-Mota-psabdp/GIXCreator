SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help PRODUTO_CHB
CREATE procedure [dbo].[spATL_Produto_CHB_Sel](
	@cd_prod		INT,
	@Tipo			char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
*/

if @Tipo = 'A' or @Tipo = 'B'
	Begin
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
	
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
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
		where
			PH.cd_prod = @cd_prod
	End	
	
--if @Tipo = 'N' or @Tipo = 'O'
--	Begin
--		select 
--			cd_prod[Code], cd_Proc_Cliente [Product Code],pc.cd_Cliente, P.apelido [Group],
--			Produto_Descr [Description],NCM_Cliente [N.C.M]
--		from Produto_Cliente PC with(nolock)
--			join Pessoa P with(nolock) on P.Cd_Pes = PC.cd_Cliente
--		where
--			p.Apelido = @grupo
--	End
	
	
--if @Tipo = 'Z' --or @Tipo = 'O'
--	Begin
--		select Cd_Tp_End[Code], Nome_Tp_End [Type of Address] from Tipo_Endereco
--		where Nome_Tp_End = @Nome_Tp_End and Cd_Tp_End<> @Cd_Tp_End
--	End

/*
--sp_help PRODUTO_CHB
ALTER procedure [dbo].[spATL_Produto_CHB_Sel](
	@cd_prod		INT,
	@Tipo			char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
*/

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select 
			cd_prod [Code],Etiqueta_Produto,Aprovado,Descricao_Longa,
			convert(varchar(10),Dt_Pesquisa,103)Dt_Pesquisa
			,Tipo_LI,Import_License,
			Orgao_Anuente,Pais_Origem cd_pais, P.Nome_Pais,Concentracao
			--,Descricao_Longa_Backup
		from Produto_CHB PC with(nolock)
			LEFT join Pais P with(nolock) on P.Cd_Pais = PC.Pais_Origem
	
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select 
			cd_prod [Code],Etiqueta_Produto,Aprovado,Descricao_Longa,
			convert(varchar(10),Dt_Pesquisa,103)Dt_Pesquisa
			,Tipo_LI,Import_License,
			Orgao_Anuente,Pais_Origem cd_pais, P.Nome_Pais,Concentracao
			--,Descricao_Longa_Backup
		from PRODUTO_CHB PC with(nolock)
			LEFT join Pais P with(nolock) on P.Cd_Pais = PC.Pais_Origem
	
		where
			cd_prod = @cd_prod
	End	
	
--if @Tipo = 'N' or @Tipo = 'O'
--	Begin
--		select 
--			cd_prod[Code], cd_Proc_Cliente [Product Code],pc.cd_Cliente, P.apelido [Group],
--			Produto_Descr [Description],NCM_Cliente [N.C.M]
--		from Produto_Cliente PC with(nolock)
--			join Pessoa P with(nolock) on P.Cd_Pes = PC.cd_Cliente
--		where
--			p.Apelido = @grupo
--	End
	
	
--if @Tipo = 'Z' --or @Tipo = 'O'
--	Begin
--		select Cd_Tp_End[Code], Nome_Tp_End [Type of Address] from Tipo_Endereco
--		where Nome_Tp_End = @Nome_Tp_End and Cd_Tp_End<> @Cd_Tp_End
--	End

*/

GO
