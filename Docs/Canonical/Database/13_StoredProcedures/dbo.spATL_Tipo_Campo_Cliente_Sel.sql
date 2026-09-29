SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Incluido no D ser por Grupo e ID
--select * from Tipo_Campo_Cliente
--sp_help Tipo_Campo_Cliente
CREATE procedure [dbo].[spATL_Tipo_Campo_Cliente_Sel]-- null,'','','A'
(	
	@Id_Campo		Int,
	@Cd_Pes_Grupo	VarChar(10),
	@Descr_campo	VarChar(30),
	@Tipo			char(1)
)
as
		
/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codgo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos

X /// para ver se tem algum job com este campo preenchido
*/

--if @Grupo = '' or @Grupo is null
--	set @Grupo = '%'

--if @Descr_campo = '' or @Descr_campo is null
--	set @Descr_campo = '%'

IF @Tipo = 'A' 
	Begin
		SELECT
			T.Id_Campo							[Code],
			T.Cd_Pes_Grupo						[Group Code],
			P.Apelido							[Group Name],
			T.Descr_Campo						[Field Description],
			T.Tipo								[Type Code],
			V.Nome_Tipo							[Type Name],
			T.Tab_Relacionada					[Related Table],
			T.Cod_Busca							[Search Code],
			T.Campo_Exibicao					[Display Field],
			T.Where_Field						[Where Field],
			isnull(M.House,0)					[House],
			isnull(M.Master,0)					[Master],
			isnull(M.Export,0)					[Export],
			isnull(M.Import,0)					[Import],
			isnull(M.Air,0)						[Air],
			isnull(M.Ocean,0)					[Ocean],
			isnull(M.Other,0)					[Other]
		From 
			Tipo_Campo_Cliente T	with(nolock) 			
			join Grupo G with(nolock) on T.Cd_Pes_Grupo = G.Cd_Pes_Grupo
			join Pessoa P with(nolock)  on P.Cd_Pes =G.Cd_Pes_Grupo
			join Tipo_Variavel V with(nolock)  on V.cd_tipo = T.Tipo
			left join tipo_campo_cliente_Modais M on M.Id_campo = T.Id_Campo		
	End
	
IF @Tipo = 'B'
	Begin
		Select
			T.Id_Campo							[Code], 
			T.Cd_Pes_Grupo						[Group Code],
			P.Apelido							[Group Name],
			T.Descr_Campo						[Field Description],
			T.Tipo								[Type Code],
			V.Nome_Tipo							[Type Name],
			T.Tab_Relacionada					[Related Table],
			T.Cod_Busca							[Search Code],
			T.Campo_Exibicao					[Display Field],
			T.Where_Field						[Where Field],
			isnull(M.House,0)					[House],
			isnull(M.Master,0)					[Master],
			isnull(M.Export,0)					[Export],
			isnull(M.Import,0)					[Import],
			isnull(M.Air,0)						[Air],
			isnull(M.Ocean,0)					[Ocean],
			isnull(M.Other,0)					[Other]
		From 
			Tipo_Campo_Cliente T	with(nolock) 			
			join Grupo G with(nolock) on T.Cd_Pes_Grupo = G.Cd_Pes_Grupo
			join Pessoa P with(nolock)  on P.Cd_Pes =G.Cd_Pes_Grupo
			join Tipo_Variavel V with(nolock)  on V.cd_tipo = T.Tipo
			left join tipo_campo_cliente_Modais M on M.Id_campo = T.Id_Campo
		Where
			T.Id_Campo = @Id_Campo and
			T.Tipo <> 'X'
	End
	
IF @Tipo = 'C'
	Begin
		Select 
			T.Id_Campo							[Code],
			T.Cd_Pes_Grupo						[Group Code],
			P.Apelido							[Group Name],
			T.Descr_Campo						[Field Description],
			T.Tipo								[Type Code],
			V.Nome_Tipo							[Type Name],
			T.Tab_Relacionada					[Related Table],
			T.Cod_Busca							[Search Code],
			T.Campo_Exibicao					[Display Field],
			T.Where_Field						[Where Field],
			isnull(M.House,0)					[House],
			isnull(M.Master,0)					[Master],
			isnull(M.Export,0)					[Export],
			isnull(M.Import,0)					[Import],
			isnull(M.Air,0)						[Air],
			isnull(M.Ocean,0)					[Ocean],
			isnull(M.Other,0)					[Other]
		From 
			Tipo_Campo_Cliente T	with(nolock) 			
			join Grupo G with(nolock) on T.Cd_Pes_Grupo = G.Cd_Pes_Grupo
			join Pessoa P with(nolock)  on P.Cd_Pes =G.Cd_Pes_Grupo
			join Tipo_Variavel V with(nolock)  on V.cd_tipo = T.Tipo
			left join tipo_campo_cliente_Modais M on M.Id_campo = T.Id_Campo
		Where		
			t.cd_pes_grupo in ('10017',@Cd_Pes_Grupo)
		
	End
	
IF @Tipo = 'D'
	Begin		
		Select
			T.Id_Campo							[Code], 
			T.Cd_Pes_Grupo						[Group Code],
			P.Apelido							[Group Name],
			T.Descr_Campo						[Field Description],
			T.Tipo								[Type Code],
			V.Nome_Tipo							[Type Name],
			T.Tab_Relacionada					[Related Table],
			T.Cod_Busca							[Search Code],
			T.Campo_Exibicao					[Display Field],
			T.Where_Field						[Where Field],
			isnull(M.House,0)					[House],
			isnull(M.Master,0)					[Master],
			isnull(M.Export,0)					[Export],
			isnull(M.Import,0)					[Import],
			isnull(M.Air,0)						[Air],
			isnull(M.Ocean,0)					[Ocean],
			isnull(M.Other,0)					[Other]
		From 
			Tipo_Campo_Cliente T	with(nolock) 			
			join Grupo G with(nolock) on T.Cd_Pes_Grupo = G.Cd_Pes_Grupo
			join Pessoa P with(nolock)  on P.Cd_Pes =G.Cd_Pes_Grupo
			join Tipo_Variavel V with(nolock)  on V.cd_tipo = T.Tipo
			left join tipo_campo_cliente_Modais M on M.Id_campo = T.Id_Campo
		Where
			T.Id_Campo = @Id_Campo and
			t.Cd_Pes_Grupo in ('10017',@Cd_Pes_Grupo) 
			AND T.Tipo <> 'X'
	End
	
IF @Tipo = 'N'
	Begin
		Select 
			T.Id_Campo							[Code],
			T.Cd_Pes_Grupo						[Group Code],
			P.Apelido							[Group Name],
			T.Descr_Campo						[Field Description],
			T.Tipo								[Type Code],
			V.Nome_Tipo							[Type Name],
			T.Tab_Relacionada					[Related Table],
			T.Cod_Busca							[Search Code],
			T.Campo_Exibicao					[Display Field],
			T.Where_Field						[Where Field],
			isnull(M.House,0)					[House],
			isnull(M.Master,0)					[Master],
			isnull(M.Export,0)					[Export],
			isnull(M.Import,0)					[Import],
			isnull(M.Air,0)						[Air],
			isnull(M.Ocean,0)					[Ocean],
			isnull(M.Other,0)					[Other]
		From 
			Tipo_Campo_Cliente T	with(nolock) 			
			join Grupo G with(nolock) on T.Cd_Pes_Grupo = G.Cd_Pes_Grupo
			join Pessoa P with(nolock)  on P.Cd_Pes =G.Cd_Pes_Grupo
			join Tipo_Variavel V with(nolock)  on V.cd_tipo = T.Tipo
			left join tipo_campo_cliente_Modais M on M.Id_campo = T.Id_Campo
		Where
			t.Cd_Pes_Grupo in ('10017',@Cd_Pes_Grupo) 
			and T.Descr_Campo = @Descr_campo
	End
	
IF @Tipo = 'O'
	Begin
		SELECT
			T.Id_Campo							[Code],
			T.Cd_Pes_Grupo						[Group Code],
			P.Apelido							[Group Name],
			T.Descr_Campo						[Field Description],
			T.Tipo								[Type Code],
			V.Nome_Tipo							[Type Name],
			T.Tab_Relacionada					[Related Table],
			T.Cod_Busca							[Search Code],
			T.Campo_Exibicao					[Display Field],
			T.Where_Field						[Where Field],
			isnull(M.House,0)					[House],
			isnull(M.Master,0)					[Master],
			isnull(M.Export,0)					[Export],
			isnull(M.Import,0)					[Import],
			isnull(M.Air,0)						[Air],
			isnull(M.Ocean,0)					[Ocean],
			isnull(M.Other,0)					[Other]
		From 
			Tipo_Campo_Cliente T	with(nolock) 			
			join Grupo G with(nolock) on T.Cd_Pes_Grupo = G.Cd_Pes_Grupo
			join Pessoa P with(nolock)  on P.Cd_Pes =G.Cd_Pes_Grupo
			join Tipo_Variavel V with(nolock)  on V.cd_tipo = T.Tipo
			left join tipo_campo_cliente_Modais M on M.Id_campo = T.Id_Campo
		Where
			t.Cd_Pes_Grupo in ('10017',@Cd_Pes_Grupo) 
			--P.Apelido LIKE @Grupo 
			and T.Descr_Campo LIKE @Descr_campo
			AND T.Tipo <> 'X'
	End
	
IF @Tipo = 'X'
	Begin	
		select 
			num_proc, CP.id_campo, TCC.cd_pes_grupo, apelido 
		from  
			Tipo_campo_cliente TCC 
			join campo_processo CP on TCC.Id_Campo=CP.Id_Campo
			left join Grupo G on G.Grupo=right(left(Num_Proc,5),3) and G.Cd_pes_grupo=TCC.cd_pes_grupo 
			left join pessoa P on P.cd_pes=TCC.cd_pes_grupo
		where 
			Descr_Campo=@Descr_campo
			AND TCC.cd_pes_grupo = @Cd_Pes_Grupo
			--and apelido=@Grupo
	End


/*
--select * from Tipo_Campo_Cliente
--sp_help Tipo_Campo_Cliente
ALTER procedure [dbo].[spATL_Tipo_Campo_Cliente_Sel]--'','','B'
(	
	@Grupo			VarChar(20),
	@Descr_campo	VarChar(30),
	@Tipo			char(1)
)
as
		
/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codgo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos

X /// para ver se tem algum job com este campo preenchido
*/

if @Grupo = '' or @Grupo is null
	set @Grupo = '%'

if @Descr_campo = '' or @Descr_campo is null
	set @Descr_campo = '%'

IF @Tipo = 'A' 
	Begin
		Select 
			P.Apelido							[Grupo],
			T.Descr_Campo						[Descricao do Campo],
			--V.nome_Tipo		[Tipo],
			V.nome_Tipo							[Tipo],
			T.Tab_Relacionada					[Tabela Relacionada],
			T.Cod_Busca							[Codigo Busca],
			T.Campo_Exibicao					[Campo Exibicao],
			isnull(M.House,0)					[H],
			isnull(M.Master,0)					[M],
			isnull(M.Export,0)					[E],
			isnull(M.Import,0)					[I],
			isnull(M.Air,0)						[A],
			isnull(M.Ocean,0)					[O],
			isnull(M.Other,0)					[T]
		From 
			Tipo_Campo_Cliente T	with(nolock) 			
			join Grupo G with(nolock) on T.Cd_Pes_Grupo = G.Cd_Pes_Grupo
			join Pessoa P with(nolock)  on P.Cd_Pes =G.Cd_Pes_Grupo
			join Tipo_Variavel V with(nolock)  on V.cd_tipo = T.Tipo
			left join tipo_campo_cliente_Modais M on M.Id_campo = T.Id_Campo
	End
	
IF @Tipo = 'B'
	Begin
		Select 
			P.Apelido							[Grupo],
			T.Descr_Campo						[Descricao do Campo],
			V.nome_Tipo		[Tipo],
			T.Tab_Relacionada					[Tabela Relacionada],
			T.Cod_Busca							[Codigo Busca],
			T.Campo_Exibicao					[Campo Exibicao],
			isnull(M.House,0)					[H],
			isnull(M.Master,0)					[M],
			isnull(M.Export,0)					[E],
			isnull(M.Import,0)					[I],
			isnull(M.Air,0)						[A],
			isnull(M.Ocean,0)					[O],
			isnull(M.Other,0)					[T]
		From 
			Tipo_Campo_Cliente T	with(nolock) 			
			join Grupo G with(nolock) on T.Cd_Pes_Grupo = G.Cd_Pes_Grupo
			join Pessoa P with(nolock)  on P.Cd_Pes =G.Cd_Pes_Grupo
			join Tipo_Variavel V with(nolock)  on V.cd_tipo = T.Tipo
			left join tipo_campo_cliente_Modais M on M.Id_campo = T.Id_Campo
		Where
			T.Tipo <> 'X'
	End
	
IF @Tipo = 'C'
	Begin
		Select 
			P.Apelido							[Grupo],
			T.Descr_Campo						[Descricao do Campo],
			V.nome_Tipo		[Tipo],
			T.Tab_Relacionada					[Tabela Relacionada],
			T.Cod_Busca							[Codigo Busca],
			T.Campo_Exibicao					[Campo Exibicao],
			isnull(M.House,0)					[H],
			isnull(M.Master,0)					[M],
			isnull(M.Export,0)					[E],
			isnull(M.Import,0)					[I],
			isnull(M.Air,0)						[A],
			isnull(M.Ocean,0)					[O],
			isnull(M.Other,0)					[T]
		From 
			Tipo_Campo_Cliente T	with(nolock) 			
			join Grupo G with(nolock) on T.Cd_Pes_Grupo = G.Cd_Pes_Grupo
			join Pessoa P with(nolock)  on P.Cd_Pes =G.Cd_Pes_Grupo
			join Tipo_Variavel V with(nolock)  on V.cd_tipo = T.Tipo
			left join tipo_campo_cliente_Modais M on M.Id_campo = T.Id_Campo
		Where
			P.Apelido LIKE @Grupo and T.Descr_Campo LIKE @Descr_campo
	End
	
IF @Tipo = 'D'
	Begin		
		Select 
			P.Apelido							[Grupo],
			T.Descr_Campo						[Descricao do Campo],
			V.nome_Tipo		[Tipo],
			T.Tab_Relacionada					[Tabela Relacionada],
			T.Cod_Busca							[Codigo Busca],
			T.Campo_Exibicao					[Campo Exibicao],
			isnull(M.House,0)					[H],
			isnull(M.Master,0)					[M],
			isnull(M.Export,0)					[E],
			isnull(M.Import,0)					[I],
			isnull(M.Air,0)						[A],
			isnull(M.Ocean,0)					[O],
			isnull(M.Other,0)					[T]
		From 
			Tipo_Campo_Cliente T	with(nolock) 			
			join Grupo G with(nolock) on T.Cd_Pes_Grupo = G.Cd_Pes_Grupo
			join Pessoa P with(nolock)  on P.Cd_Pes =G.Cd_Pes_Grupo
			join Tipo_Variavel V with(nolock)  on V.cd_tipo = T.Tipo
			left join tipo_campo_cliente_Modais M on M.Id_campo = T.Id_Campo
		Where
			P.Apelido LIKE @Grupo and T.Descr_Campo LIKE @Descr_campo
			AND T.Tipo <> 'X'
	End
	
IF @Tipo = 'N'
	Begin
		Select 
			P.Apelido							[Grupo],
			T.Descr_Campo						[Descricao do Campo],
			V.nome_Tipo		[Tipo],
			T.Tab_Relacionada					[Tabela Relacionada],
			T.Cod_Busca							[Codigo Busca],
			T.Campo_Exibicao					[Campo Exibicao],
			isnull(M.House,0)					[H],
			isnull(M.Master,0)					[M],
			isnull(M.Export,0)					[E],
			isnull(M.Import,0)					[I],
			isnull(M.Air,0)						[A],
			isnull(M.Ocean,0)					[O],
			isnull(M.Other,0)					[T]
		From 
			Tipo_Campo_Cliente T	with(nolock) 			
			join Grupo G with(nolock) on T.Cd_Pes_Grupo = G.Cd_Pes_Grupo
			join Pessoa P with(nolock)  on P.Cd_Pes =G.Cd_Pes_Grupo
			join Tipo_Variavel V with(nolock)  on V.cd_tipo = T.Tipo
			left join tipo_campo_cliente_Modais M on M.Id_campo = T.Id_Campo
		Where
			P.Apelido LIKE @Grupo and T.Descr_Campo LIKE @Descr_campo
	End
	
IF @Tipo = 'O'
	Begin
		Select 
			P.Apelido							[Grupo],
			T.Descr_Campo						[Descricao do Campo],
			V.nome_Tipo		[Tipo],
			T.Tab_Relacionada					[Tabela Relacionada],
			T.Cod_Busca							[Codigo Busca],
			T.Campo_Exibicao					[Campo Exibicao],
			isnull(M.House,0)					[H],
			isnull(M.Master,0)					[M],
			isnull(M.Export,0)					[E],
			isnull(M.Import,0)					[I],
			isnull(M.Air,0)						[A],
			isnull(M.Ocean,0)					[O],
			isnull(M.Other,0)					[T]
		From 
			Tipo_Campo_Cliente T	with(nolock) 			
			join Grupo G with(nolock) on T.Cd_Pes_Grupo = G.Cd_Pes_Grupo
			join Pessoa P with(nolock)  on P.Cd_Pes =G.Cd_Pes_Grupo
			join Tipo_Variavel V with(nolock)  on V.cd_tipo = T.Tipo
			left join tipo_campo_cliente_Modais M on M.Id_campo = T.Id_Campo
		Where
			P.Apelido LIKE @Grupo and T.Descr_Campo LIKE @Descr_campo
			AND T.Tipo <> 'X'
	End
	
IF @Tipo = 'X'
	Begin	
		select 
			num_proc, CP.id_campo, TCC.cd_pes_grupo, apelido 
		from  
			Tipo_campo_cliente TCC 
			join campo_processo CP on TCC.Id_Campo=CP.Id_Campo
			left join Grupo G on G.Grupo=right(left(Num_Proc,5),3) and G.Cd_pes_grupo=TCC.cd_pes_grupo 
			left join pessoa P on P.cd_pes=TCC.cd_pes_grupo
		where 
			Descr_Campo=@Descr_campo
			and apelido=@Grupo
	End
*/

GO
