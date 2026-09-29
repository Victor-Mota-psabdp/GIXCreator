SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spProduto_Cliente_Rel]
	@teste as varchar(10)

as

select 
	Apelido [Group], cd_Proc_Cliente [Product Code],NCM_Cliente [N.C.M],
Produto_Descr [Description] from Produto_Cliente P
	join pessoa A on p.cd_Cliente = A.Cd_Pes
GO
