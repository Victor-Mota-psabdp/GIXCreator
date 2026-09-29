SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from [Tipo_Campo_Produto_Cliente]
--sp_help [Tipo_Campo_Produto_Cliente] 
--select * from [Campo_Produto_Cliente]
--sp_help [Campo_Produto_Cliente]

CREATE procedure [dbo].[spATL_Campo_Produto_Cliente_Sel]
(
	@Cd_Prod		int,
	@Descr_Campo	varChar(30),
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

Declare @Grupo Varchar (20)
	set @Grupo=(select cd_Cliente from Produto_Cliente where cd_prod = @Cd_Prod)
	
if @Tipo = 'C'  or @Tipo = 'D'
	Begin
		select distinct 			
			convert(varchar(25), 'Saved')			[Status],
			CP.cd_prod								[ID],
			TCC.Id_Campo							[Field Code],
			TCC.Descr_Campo							[Field Description],			
			isnull(CP.Campo_Dados,'')				[Information Code],
			convert(varchar(500), '')				[Information Value],
			TCC.Cod_Busca							[Search Code],
			TCC.Tab_Relacionada						[Related Table],
			TCC.Tipo								[Type Code],
			v.Nome_Tipo								[Type Name],	
			TCC.Campo_Exibicao						[Display Field],
			''										[Where Field],			
			TCC.Cd_Pes_Grupo						[Group Code],
			P.Apelido								[Group Name],			
           CP.Cd_Usuario							[User Code],
           U.Nome_Usuario							[User Name],
           CP.Dt_Ins								[Insert Date]
		from [dbo].[Tipo_Campo_Produto_Cliente] TCC
			left join [dbo].[Campo_Produto_Cliente] CP on TCC.Id_Campo=CP.Id_Campo and cd_prod = @Cd_Prod
			Join grupo G with(nolock) on G.cd_pes_grupo=TCC.cd_pes_grupo
			join Pessoa P on P.Cd_Pes = G.Cd_Pes_Grupo
			left join usuario U on U.cd_usuario = CP.cd_usuario
			left join Tipo_Variavel V on V.Cd_Tipo = TCC.Tipo
		where 
			TCC.cd_pes_grupo in ('10017',@Grupo) 
			and TCC.Tipo <> 'X'	
	End
	
if @Tipo = 'N'  or @Tipo = 'O'
	Begin
		select distinct 			
			convert(varchar(25), 'Saved')			[Status],
			CP.cd_prod								[ID],
			TCC.Id_Campo							[Field Code],
			TCC.Descr_Campo							[Field Description],			
			isnull(CP.Campo_Dados,'')				[Information Code],
			convert(varchar(500), '')				[Information Value],
			TCC.Cod_Busca							[Search Code],
			TCC.Tab_Relacionada						[Related Table],
			TCC.Tipo								[Type Code],
			v.Nome_Tipo								[Type Name],	
			TCC.Campo_Exibicao						[Display Field],
			''										[Where Field],			
			TCC.Cd_Pes_Grupo						[Group Code],
			P.Apelido								[Group Name],			
           CP.Cd_Usuario							[User Code],
           U.Nome_Usuario							[User Name],
           CP.Dt_Ins								[Insert Date]
		from [dbo].[Tipo_Campo_Produto_Cliente] TCC
			left join [dbo].[Campo_Produto_Cliente] CP on TCC.Id_Campo=CP.Id_Campo and cd_prod = @Cd_Prod
			Join grupo G with(nolock) on G.cd_pes_grupo=TCC.cd_pes_grupo
			join Pessoa P on P.Cd_Pes = G.Cd_Pes_Grupo
			left join usuario U on U.cd_usuario = CP.cd_usuario
			left join Tipo_Variavel V on V.Cd_Tipo = TCC.Tipo
		where 
			TCC.cd_pes_grupo in ('10017',@Grupo) 
			and TCC.Tipo <> 'X'	
			and Descr_Campo=@Descr_Campo	
	End
	

	
	
--	select tcc.id_campo,
--		Descr_Campo, 
--		isnull(Campo_Dados,'') Campo_Dados,
--		cod_busca, 
--		Tab_Relacionada, 
--		--Cod_Busca_Pk, 
--		Campo_Exibicao,
--		nome_usuario Usuario
--	from [dbo].[Tipo_Campo_Produto_Cliente] TCC
--		left join [dbo].[Campo_Produto_Cliente] CP on TCC.Id_Campo=CP.Id_Campo and cd_prod = @Cd_Prod
--		left join usuario U on U.cd_usuario = CP.cd_usuario		
--	where		
--		TCC.cd_pes_grupo in ('10017',@Grupo) 
--		and TCC.Tipo <> 'X'
--		--and ativo = 1		
----		and cd_pedido = @cd_pedido		
--	order by
--		2

/*
ALTER procedure [dbo].[spATL_Campo_Produto_Cliente_Sel]
(
	@Cd_Prod		int,
	@Descr_Campo	varChar(30),
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

Declare @Grupo Varchar (20)
	set @Grupo=(select cd_Cliente from Produto_Cliente where cd_prod = @Cd_Prod)
	
if @Tipo = 'C'  or @Tipo = 'D'
	Begin
		select distinct 
			convert(varchar(25), 'Saved') Status,
			isnull(Campo_Dados,'') Campo_Dados,
			tcc.id_campo,
			tcc.Descr_Campo [Field],			
			tcc.cod_busca,
			tcc.Tab_Relacionada,
			tcc.Tipo,			
			tcc.Campo_Exibicao,
			cp.Cd_Usuario,
			Nome_Usuario Usuario,
			isnull(Campo_Dados,'') [Information]
		from [dbo].[Tipo_Campo_Produto_Cliente] TCC
			left join [dbo].[Campo_Produto_Cliente] CP on TCC.Id_Campo=CP.Id_Campo and cd_prod = @Cd_Prod
			Join grupo G with(nolock) on G.cd_pes_grupo=TCC.cd_pes_grupo
			left join usuario U on U.cd_usuario = CP.cd_usuario			
		--from Campo_Produto_Cliente CP with(nolock)
		--	 join Tipo_Campo_Produto_Cliente TCC with(nolock) on TCC.Id_Campo=CP.Id_Campo
		--	 Join grupo G with(nolock) on G.cd_pes_grupo=TCC.cd_pes_grupo
		--	 LEFT JOIN Usuario U with(nolock) on u.cd_usuario = cp.cd_usuario
		where 
			--(TCC.cd_pes_grupo='10017' OR G.Cd_Pes_Grupo =@Grupo)
			----and Descr_Campo=@Descr_Campo	
			--and cp.cd_prod = @Cd_Prod	
			TCC.cd_pes_grupo in ('10017',@Grupo) 
			and TCC.Tipo <> 'X'	
	End
	
if @Tipo = 'N'  or @Tipo = 'O'
	Begin
		select distinct 
			convert(varchar(25), 'Saved') Status,
			isnull(Campo_Dados,'') Campo_Dados,
			tcc.id_campo,
			tcc.Descr_Campo [Field],
			tcc.cod_busca,
			tcc.Tab_Relacionada,
			tcc.Tipo,			
			tcc.Campo_Exibicao,
			cp.Cd_Usuario,
			Nome_Usuario Usuario,
			isnull(Campo_Dados,'') [Information]
		from [dbo].[Tipo_Campo_Produto_Cliente] TCC
			left join [dbo].[Campo_Produto_Cliente] CP on TCC.Id_Campo=CP.Id_Campo and cd_prod = @Cd_Prod
			Join grupo G with(nolock) on G.cd_pes_grupo=TCC.cd_pes_grupo
			left join usuario U on U.cd_usuario = CP.cd_usuario			
		--from Campo_Produto_Cliente CP with(nolock)
		--	 join Tipo_Campo_Produto_Cliente TCC with(nolock) on TCC.Id_Campo=CP.Id_Campo
		--	 Join grupo G with(nolock) on G.cd_pes_grupo=TCC.cd_pes_grupo
		--	 LEFT JOIN Usuario U with(nolock) on u.cd_usuario = cp.cd_usuario
		where 
			--(TCC.cd_pes_grupo='10017' OR G.Cd_Pes_Grupo =@Grupo)
			----and Descr_Campo=@Descr_Campo	
			--and cp.cd_prod = @Cd_Prod	
			TCC.cd_pes_grupo in ('10017',@Grupo) 
			and TCC.Tipo <> 'X'	
			and Descr_Campo=@Descr_Campo	
	End
	

	
	
--	select tcc.id_campo,
--		Descr_Campo, 
--		isnull(Campo_Dados,'') Campo_Dados,
--		cod_busca, 
--		Tab_Relacionada, 
--		--Cod_Busca_Pk, 
--		Campo_Exibicao,
--		nome_usuario Usuario
--	from [dbo].[Tipo_Campo_Produto_Cliente] TCC
--		left join [dbo].[Campo_Produto_Cliente] CP on TCC.Id_Campo=CP.Id_Campo and cd_prod = @Cd_Prod
--		left join usuario U on U.cd_usuario = CP.cd_usuario		
--	where		
--		TCC.cd_pes_grupo in ('10017',@Grupo) 
--		and TCC.Tipo <> 'X'
--		--and ativo = 1		
----		and cd_pedido = @cd_pedido		
--	order by
--		2

*/

GO
