SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Produto_Cliente
CREATE VIEW [dbo].[vwProduto_Cliente_Sel]
AS

	select 
		cd_prod				[Code], 
		cd_Proc_Cliente		[Product Code],
		pc.cd_Cliente		[Group Code], 
		P.apelido			[Group Name],
		PC.Produto_Descr	[Product Description],
		NCM_Cliente			[N.C.M], 
		N.Descricao_NCM		[N.C.M Description]	
	from Produto_Cliente PC with(nolock)
		join Pessoa P with(nolock) on P.Cd_Pes = PC.cd_Cliente
		left join NCM N with(nolock) on PC.NCM_Cliente = N.NCM
			
--select 
--	cd_prod[Code], cd_Proc_Cliente [Product Code],pc.cd_Cliente, P.apelido [Group],
--	Produto_Descr [Description],NCM_Cliente [N.C.M], N.Descricao_NCM
--from Produto_Cliente PC with(nolock)
--	join Pessoa P with(nolock) on P.Cd_Pes = PC.cd_Cliente
--	left join NCM N with(nolock) on N.NCM = PC.NCM_Cliente



GO
