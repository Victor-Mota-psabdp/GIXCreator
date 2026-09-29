SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Produto_Cliente
CREATE procedure [dbo].[spATLDN_Produto_Cliente_Sel]
(
	@cd_prod				int,
	@cd_Proc_Cliente	varchar(30),
	@cd_cliente			varchar(10),
	@Tipo char(1)
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
			cd_prod[Code], cd_Proc_Cliente [Product Code],pc.cd_Cliente, P.apelido [Group],
			Produto_Descr [Description],NCM_Cliente [N.C.M], N.Descricao_NCM
		from Produto_Cliente PC with(nolock)
			join Pessoa P with(nolock) on P.Cd_Pes = PC.cd_Cliente
			left join NCM N with(nolock) on PC.NCM_Cliente = N.NCM
		where
			cd_prod = @cd_prod
	
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select 
			cd_prod[Code], cd_Proc_Cliente [Product Code],pc.cd_Cliente, P.apelido [Group],
			Produto_Descr [Description],NCM_Cliente [N.C.M], N.Descricao_NCM
		from Produto_Cliente PC with(nolock)
			join Pessoa P with(nolock) on P.Cd_Pes = PC.cd_Cliente
			left join NCM N with(nolock) on PC.NCM_Cliente = N.NCM
		where
			cd_Proc_Cliente = @cd_Proc_Cliente AND cd_Cliente = @cd_cliente
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

GO
