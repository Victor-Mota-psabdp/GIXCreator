SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[spCamposAdicionais_Sel] 'IMBUE201103001'
--incluido pra trazer isnull('ATL System') - Cadu 13/07/2015
CREATE procedure [dbo].[spCamposAdicionaisOrdem_Sel]--132253
(
	@cd_pedido int
)
as

	Declare @Grupo Varchar (20)

	set @Grupo=(select cd_grupo from pedido where cd_pedido = @cd_pedido)
	
	select tcc.id_campo,
		Descr_Campo, isnull(Campo_Dados,'') Campo_Dados, Tab_Relacionada, Cod_Busca_Pk, Campo_Exibicao,
		--isnull(nome_usuario,'ATL System') Usuario - retirado pq qdo nao tiver recebido o dado pode incluir manualmente 30/030/2021 - cadu
		nome_usuario Usuario
	from tipo_campo_ordem TCC
		left join Campo_ordem CP on TCC.Id_Campo=CP.Id_Campo and cd_pedido = @cd_pedido
		left join usuario U on U.cd_usuario = CP.cd_usuario
--		Join Grupo G on G.cd_pes_grupo=TCC.cd_pes_grupo  		
	where
		TCC.cd_pes_grupo in ('10017',@Grupo) 
		and TCC.Tipo <> 'X'
		and ativo = 1		
--		and cd_pedido = @cd_pedido		
	order by
		2

GO
