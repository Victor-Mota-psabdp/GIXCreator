SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spCamposAdicionaisCampo_Produto_Cliente_Sel]
(
	@Cd_Prod int
)
as

	Declare @Grupo Varchar (20)

	set @Grupo=(select cd_Cliente from Produto_Cliente where cd_prod = @Cd_Prod)
	
	select tcc.id_campo,
		Descr_Campo, 
		isnull(Campo_Dados,'') Campo_Dados,
		cod_busca, 
		Tab_Relacionada, 
		--Cod_Busca_Pk, 
		Campo_Exibicao,
		nome_usuario Usuario
	from [dbo].[Tipo_Campo_Produto_Cliente] TCC
		left join [dbo].[Campo_Produto_Cliente] CP on TCC.Id_Campo=CP.Id_Campo and cd_prod = @Cd_Prod
		left join usuario U on U.cd_usuario = CP.cd_usuario		
	where		
		TCC.cd_pes_grupo in ('10017',@Grupo) 
		and TCC.Tipo <> 'X'
		--and ativo = 1		
--		and cd_pedido = @cd_pedido		
	order by
		1




GO
