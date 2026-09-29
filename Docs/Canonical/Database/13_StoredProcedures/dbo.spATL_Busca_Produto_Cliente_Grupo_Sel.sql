SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_Busca_Produto_Cliente_Grupo_Sel] 
(
	@Produto_Descr	varchar(500),
	@Grupo varchar	(20)
)
as

select cd_prod from Produto_Cliente PC
	join Pessoa P on PC.Cd_Cliente = P.cd_pes
	join Grupo GR on P.cd_pes = GR.Cd_Pes_Grupo
where 
	Produto_Descr = @Produto_Descr 
	and P.Apelido = @Grupo
	

	
	



GO
