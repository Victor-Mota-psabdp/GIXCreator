SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * From Tipo_Campo_Ordem where 


CREATE Procedure [dbo].[spPedidoCampoOrdem_Sel] --spPedidoCampoOrdem_Sel  247519
		@Cd_Pedido int
		
As

--Begin
--			SET NOCOUNT ON;
--		print @cd_pedido
--		Declare @Saida Table
--			(
--					Descr_Campo	varchar(50),
--	--				Tipo		Char(1),
--					Campo_Dados	Varchar(50)
--			)
--		Declare @Tabela VArchar(50)
--		Declare @Chave	varchar(50)
--		Declare @Campo_Exibicao Varchar(50)
--		Declare @Query Varchar(500)

--		--Inserir casos não tem tabelas relacionadas
--		Insert @Saida 
--		Select Descr_Campo,Campo_Dados  From Tipo_Campo_Ordem TCO with(nolock)
--		Left Join Campo_Ordem CO with(nolock) on TCO.Id_Campo = CO.Id_Campo and Cd_Pedido=@Cd_Pedido
--		Where Ativo='1'and Tab_Relacionada is null and TCO.id_campo in (1,2,3,900)

--		-- Inserir casos que tem tabelas relacionadas
--		Declare cTemp cursor for
			
--			Select Distinct Tab_Relacionada,Cod_Busca_PK,Campo_Exibicao  from Tipo_Campo_ordem
--			Where Ativo='1' and Tab_Relacionada is not null and id_campo in (1,2,3,900)
--		Open cTemp
--			Fetch next From cTemp into @Tabela,@Chave,@Campo_Exibicao
--			While @@FETCH_STATUS=0
--				Begin
--					Set @Query = 'Select Descr_Campo, ' + @Campo_Exibicao +   ' From Tipo_Campo_Ordem TCO with(nolock)'
--					Set @Query = @Query + ' ' + 'Left Join Campo_Ordem CO with(nolock) on TCO.Id_Campo = CO.Id_Campo and cd_pedido=' + cast(@Cd_Pedido as varchar(40))
--					Set @Query = @Query  +  'Left Join ' + @Tabela + ' with (nolock) on ' + @Chave + '=campo_dados where tab_relacionada is not null and TCO.id_campo in (1,2,3,900)'
--					print @Query	
--					Fetch next From cTemp into @Tabela,@Chave,@Campo_Exibicao
--					print @Query
--					Insert @Saida 
--					exec (@query)	
--				End
--		close CTemp
--		deallocate CTemp
		
--		Select 'Saved' Status,Descr_Campo [Field],Campo_Dados [Information] from @Saida 
		
--End


Declare @Grupo Varchar (20)

	set @Grupo=(select cd_grupo from pedido where cd_pedido = @cd_pedido)
	
	select 'Saved' Status,Descr_Campo [Field],Campo_Dados [Information]
		--tcc.id_campo,
		--Descr_Campo, isnull(Campo_Dados,'') Campo_Dados, Tab_Relacionada, Cod_Busca_Pk, Campo_Exibicao,isnull(nome_usuario,'ATL System') Usuario
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
