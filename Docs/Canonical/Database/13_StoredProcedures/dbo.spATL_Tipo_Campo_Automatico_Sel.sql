SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Campo_Automatico
--select * from vwATL_Tipo_Campo_Automatico_Sel
--select * from Tipo_Campo_Automatico
CREATE procedure [dbo].[spATL_Tipo_Campo_Automatico_Sel]--'BDP (SÃO PAULO)','HAWB','D'
(	
	@Id_Campo		int,
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
		Select 
			T.Id_Campo							[Code],
			T.Cd_Pes_Grupo						[Group Code],
			P.Apelido							[Group Name],
			T.Tipo								[Type Code],
			V.nome_Tipo							[Type Name],
			T.Descr_Campo						[Field Description],
			T.Tab_Relacionada					[Related Table],
			T.Cod_Busca							[Search Code],
			T.Campo_Exibicao					[Display Field],
			t.[View]							[View]
		From 
			Tipo_Campo_Automatico T	with(nolock) 			
			join Grupo G with(nolock) on T.Cd_Pes_Grupo = G.Cd_Pes_Grupo
			join Pessoa P with(nolock)  on P.Cd_Pes =G.Cd_Pes_Grupo
			join Tipo_Variavel V with(nolock)  on V.cd_tipo = T.Tipo
		Where
			T.Id_Campo=@Id_Campo

	End
	
IF @Tipo = 'B'
	Begin
		Select 
			T.Id_Campo							[Code],
			T.Cd_Pes_Grupo						[Group Code],
			P.Apelido							[Group Name],
			T.Tipo								[Type Code],
			V.nome_Tipo							[Type Name],
			T.Descr_Campo						[Field Description],
			T.Tab_Relacionada					[Related Table],
			T.Cod_Busca							[Search Code],
			T.Campo_Exibicao					[Display Field],
			t.[View]							[View]
		From 
			Tipo_Campo_Automatico T	with(nolock) 			
			join Grupo G with(nolock) on T.Cd_Pes_Grupo = G.Cd_Pes_Grupo
			join Pessoa P with(nolock)  on P.Cd_Pes =G.Cd_Pes_Grupo
			join Tipo_Variavel V with(nolock)  on V.cd_tipo = T.Tipo			
		Where
			T.Id_Campo=@Id_Campo
			AND T.Tipo <> 'X'
	End
	
IF @Tipo = 'C'
	Begin
		Select 
			T.Id_Campo							[Code],
			T.Cd_Pes_Grupo						[Group Code],
			P.Apelido							[Group Name],
			T.Tipo								[Type Code],
			V.nome_Tipo							[Type Name],
			T.Descr_Campo						[Field Description],
			T.Tab_Relacionada					[Related Table],
			T.Cod_Busca							[Search Code],
			T.Campo_Exibicao					[Display Field],
			t.[View]							[View]
		From 
			Tipo_Campo_Automatico T	with(nolock) 			
			join Grupo G with(nolock) on T.Cd_Pes_Grupo = G.Cd_Pes_Grupo
			join Pessoa P with(nolock)  on P.Cd_Pes =G.Cd_Pes_Grupo
			join Tipo_Variavel V with(nolock)  on V.cd_tipo = T.Tipo			
		Where
			T.Cd_Pes_Grupo = @Cd_Pes_Grupo and T.Descr_Campo = @Descr_campo
			
	End
	
IF @Tipo = 'D'
	Begin		
		Select 
			T.Id_Campo							[Code],
			T.Cd_Pes_Grupo						[Group Code],
			P.Apelido							[Group Name],
			T.Tipo								[Type Code],
			V.nome_Tipo							[Type Name],
			T.Descr_Campo						[Field Description],
			T.Tab_Relacionada					[Related Table],
			T.Cod_Busca							[Search Code],
			T.Campo_Exibicao					[Display Field],
			t.[View]							[View]
		From 
			Tipo_Campo_Automatico T	with(nolock) 			
			join Grupo G with(nolock) on T.Cd_Pes_Grupo = G.Cd_Pes_Grupo
			join Pessoa P with(nolock)  on P.Cd_Pes =G.Cd_Pes_Grupo
			join Tipo_Variavel V with(nolock)  on V.cd_tipo = T.Tipo			
		Where	
			(T.Cd_Pes_Grupo = @Cd_Pes_Grupo or T.Cd_Pes_Grupo='10017')			
			and T.Descr_Campo = @Descr_campo
			AND T.Tipo <> 'X'		
			
	End
	
IF @Tipo = 'N'
	Begin
		Select 
			T.Id_Campo							[Code],
			T.Cd_Pes_Grupo						[Group Code],
			P.Apelido							[Group Name],
			T.Tipo								[Type Code],
			V.nome_Tipo							[Type Name],
			T.Descr_Campo						[Field Description],
			T.Tab_Relacionada					[Related Table],
			T.Cod_Busca							[Search Code],
			T.Campo_Exibicao					[Display Field],
			t.[View]							[View]
		From 
			Tipo_Campo_Automatico T	with(nolock) 			
			join Grupo G with(nolock) on T.Cd_Pes_Grupo = G.Cd_Pes_Grupo
			join Pessoa P with(nolock)  on P.Cd_Pes =G.Cd_Pes_Grupo
			join Tipo_Variavel V with(nolock)  on V.cd_tipo = T.Tipo
			
		Where
			T.Cd_Pes_Grupo = @Cd_Pes_Grupo and T.Descr_Campo = @Descr_campo
	End
	
IF @Tipo = 'O'
	Begin
		Select 
			T.Id_Campo							[Code],
			T.Cd_Pes_Grupo						[Group Code],
			P.Apelido							[Group Name],
			T.Tipo								[Type Code],
			V.nome_Tipo							[Type Name],
			T.Descr_Campo						[Field Description],
			T.Tab_Relacionada					[Related Table],
			T.Cod_Busca							[Search Code],
			T.Campo_Exibicao					[Display Field],
			t.[View]							[View]
		From 
			Tipo_Campo_Automatico T	with(nolock) 			
			join Grupo G with(nolock) on T.Cd_Pes_Grupo = G.Cd_Pes_Grupo
			join Pessoa P with(nolock)  on P.Cd_Pes =G.Cd_Pes_Grupo
			join Tipo_Variavel V with(nolock)  on V.cd_tipo = T.Tipo
			
		Where
			(T.Cd_Pes_Grupo = @Cd_Pes_Grupo or T.Cd_Pes_Grupo='10017')			
			and T.Descr_Campo = @Descr_campo
			AND T.Tipo <> 'X'
	End
	
--IF @Tipo = 'X'
--	Begin	
--		select 
--			CP.cd_prod, CP.id_campo, TCC.cd_pes_grupo, apelido 
--		from  
--			Tipo_Campo_Automatico TCC 
--			join [Campo_Produto_Cliente] CP on TCC.Id_Campo=CP.Id_Campo
--			left join Grupo G on G.Cd_pes_grupo=TCC.cd_pes_grupo 
--			left join pessoa P on P.cd_pes=TCC.cd_pes_grupo
--		where 
--			Descr_Campo=@Descr_campo
--			and apelido=@Grupo			
		
--	End
	


/*
--select * from Tipo_Campo_Automatico
--sp_help Tipo_Campo_Automatico
--[spATL_Tipo_Campo_Automatico_Sel]'GRUPO DOW','Integration - DOW ITO - Export','D'
--alter table [dbo].[Tipo_Campo_Automatico] add [View] [varchar](200) NULL
--select * from Tipo_Campo_Automatico where 
--Tab_Relacionada = 'ATL_INT.dbo.GIX_Header_Transportation_ReferenceType'
--update Tipo_Campo_Automatico set [View] = 'vwGIX_Header_Transportation_ReferenceType_Sel' 
--where Tab_Relacionada = 'ATL_INT.dbo.GIX_Header_Transportation_ReferenceType'
--[spATL_Tipo_Campo_Automatico_Sel]'BDP (SÃO PAULO)','HAWB','D'
ALTER procedure [dbo].[spATL_Tipo_Campo_Automatico_Sel]--'BDP (SÃO PAULO)','HAWB','D'
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

--if @Grupo = '' or @Grupo is null
--	set @Grupo = '%'

--if @Descr_campo = '' or @Descr_campo is null
--	set @Descr_campo = '%'

IF @Tipo = 'A' 
	Begin
		Select 
			T.Id_Campo							[Id_Campo],
			P.Apelido							[Grupo],
			T.Descr_Campo						[Descricao do Campo],
			--V.nome_Tipo		[Tipo],
			V.nome_Tipo							[Tipo],
			T.Tab_Relacionada					[Tabela Relacionada],
			T.Cod_Busca							[Codigo Busca],
			T.Campo_Exibicao					[Campo Exibicao],
			t.[View]								[View]
		From 
			Tipo_Campo_Automatico T	with(nolock) 			
			join Grupo G with(nolock) on T.Cd_Pes_Grupo = G.Cd_Pes_Grupo
			join Pessoa P with(nolock)  on P.Cd_Pes =G.Cd_Pes_Grupo
			join Tipo_Variavel V with(nolock)  on V.cd_tipo = T.Tipo

	End
	
IF @Tipo = 'B'
	Begin
		Select 
			T.Id_Campo							[Id_Campo],
			P.Apelido							[Grupo],
			T.Descr_Campo						[Descricao do Campo],
			V.nome_Tipo		[Tipo],
			T.Tab_Relacionada					[Tabela Relacionada],
			T.Cod_Busca						[Codigo Busca],
			T.Campo_Exibicao					[Campo Exibicao]
			
		From 
			Tipo_Campo_Automatico T	with(nolock) 			
			join Grupo G with(nolock) on T.Cd_Pes_Grupo = G.Cd_Pes_Grupo
			join Pessoa P with(nolock)  on P.Cd_Pes =G.Cd_Pes_Grupo
			join Tipo_Variavel V with(nolock)  on V.cd_tipo = T.Tipo
			
		Where
			T.Tipo <> 'X'
	End
	
IF @Tipo = 'C'
	Begin
		Select
			T.Id_Campo							[Id_Campo], 
			P.Apelido							[Grupo],
			T.Descr_Campo						[Descricao do Campo],
			V.nome_Tipo		[Tipo],
			T.Tab_Relacionada					[Tabela Relacionada],
			T.Cod_Busca						[Codigo Busca],
			T.Campo_Exibicao					[Campo Exibicao],
			t.[View]								[View]
		From 
			Tipo_Campo_Automatico T	with(nolock) 			
			join Grupo G with(nolock) on T.Cd_Pes_Grupo = G.Cd_Pes_Grupo
			join Pessoa P with(nolock)  on P.Cd_Pes =G.Cd_Pes_Grupo
			join Tipo_Variavel V with(nolock)  on V.cd_tipo = T.Tipo			
		Where
			P.Apelido = @Grupo and T.Descr_Campo = @Descr_campo
	End
	
IF @Tipo = 'D'
	Begin		
		Select 
			T.Id_Campo							[Id_Campo],
			P.Apelido							[Grupo],
			T.Descr_Campo						[Descricao do Campo],
			V.nome_Tipo		[Tipo],
			T.Tab_Relacionada					[Tabela Relacionada],
			T.Cod_Busca						[Codigo Busca],
			T.Campo_Exibicao					[Campo Exibicao],
			t.[View]								[View]
		From 
			Tipo_Campo_Automatico T	with(nolock) 			
			join Grupo G with(nolock) on T.Cd_Pes_Grupo = G.Cd_Pes_Grupo
			join Pessoa P with(nolock)  on P.Cd_Pes =G.Cd_Pes_Grupo
			join Tipo_Variavel V with(nolock)  on V.cd_tipo = T.Tipo
			
		Where
			(P.Apelido = @Grupo or T.Cd_Pes_Grupo='10017')			
			and T.Descr_Campo = @Descr_campo
			AND T.Tipo <> 'X'
	End
	
IF @Tipo = 'N'
	Begin
		Select 
			T.Id_Campo							[Id_Campo],
			P.Apelido							[Grupo],
			T.Descr_Campo						[Descricao do Campo],
			V.nome_Tipo		[Tipo],
			T.Tab_Relacionada					[Tabela Relacionada],
			T.Cod_Busca						[Codigo Busca],
			T.Campo_Exibicao					[Campo Exibicao],
			t.[View]								[View]
		From 
			Tipo_Campo_Automatico T	with(nolock) 			
			join Grupo G with(nolock) on T.Cd_Pes_Grupo = G.Cd_Pes_Grupo
			join Pessoa P with(nolock)  on P.Cd_Pes =G.Cd_Pes_Grupo
			join Tipo_Variavel V with(nolock)  on V.cd_tipo = T.Tipo
			
		Where
			P.Apelido LIKE @Grupo and T.Descr_Campo LIKE @Descr_campo
	End
	
IF @Tipo = 'O'
	Begin
		Select 
			T.Id_Campo							[Id_Campo],
			P.Apelido							[Grupo],
			T.Descr_Campo						[Descricao do Campo],
			V.nome_Tipo		[Tipo],
			T.Tab_Relacionada					[Tabela Relacionada],
			T.Cod_Busca						[Codigo Busca],
			T.Campo_Exibicao					[Campo Exibicao],
			t.[View]								[View]
		From 
			Tipo_Campo_Automatico T	with(nolock) 			
			join Grupo G with(nolock) on T.Cd_Pes_Grupo = G.Cd_Pes_Grupo
			join Pessoa P with(nolock)  on P.Cd_Pes =G.Cd_Pes_Grupo
			join Tipo_Variavel V with(nolock)  on V.cd_tipo = T.Tipo
			
		Where
			P.Apelido LIKE @Grupo and T.Descr_Campo LIKE @Descr_campo
			AND T.Tipo <> 'X'
	End
	
IF @Tipo = 'X'
	Begin	
		select 
			CP.cd_prod, CP.id_campo, TCC.cd_pes_grupo, apelido 
		from  
			Tipo_Campo_Automatico TCC 
			join [Campo_Produto_Cliente] CP on TCC.Id_Campo=CP.Id_Campo
			left join Grupo G on G.Cd_pes_grupo=TCC.cd_pes_grupo 
			left join pessoa P on P.cd_pes=TCC.cd_pes_grupo
		where 
			Descr_Campo=@Descr_campo
			and apelido=@Grupo			
		
	End
	
	
	


/*
--declare @Tipo as varchar(1)
--set @Tipo = 'C'
--declare @Grupo	VarChar(20)
--set @Grupo = 'BDP (SÃO PAULO)'
--declare	@Descr_campo	VarChar(30)
--set @Descr_campo = 'Shipper'

Declare @Cd_Pes_Grupo as varchar(10)
set @Cd_Pes_Grupo = (select Cd_Pes from Pessoa where Apelido = @Grupo)

Declare @Id_Campo as BigInt
set @Id_Campo = (select Id_Campo from Tipo_Campo_Automatico where Descr_Campo = @Descr_campo and Cd_Pes_Grupo = @Cd_Pes_Grupo)
print @Id_Campo

Declare @Tab_Relacionada as Varchar(200)
set @Tab_Relacionada = (select Tab_Relacionada  from Tipo_Campo_Automatico where Id_Campo = @Id_Campo  and Cd_Pes_Grupo = @Cd_Pes_Grupo)
print @Tab_Relacionada

Declare @Cod_Busca as Varchar(200)
set @Cod_Busca = (select Cod_Busca  from Tipo_Campo_Automatico where Id_Campo = @Id_Campo  and Cd_Pes_Grupo = @Cd_Pes_Grupo)
print @Cod_Busca

Declare @Campo_Exibicao as Varchar(200)
set @Campo_Exibicao = (select Campo_Exibicao  from Tipo_Campo_Automatico where Id_Campo =  @Id_Campo  and Cd_Pes_Grupo = @Cd_Pes_Grupo)
print @Cod_Busca 


declare @select as varchar(1000)

IF @Tipo = 'A'  or @Tipo = 'B'
	begin
		set @select =  ('Select distinct ' + '' + isnull(@Campo_Exibicao,'') + ' from '  
		+ '' + isnull(@Tab_Relacionada,'') + ' order by 1 ')	
	end
IF @Tipo = 'C'  or @Tipo = 'D'
	begin
		set @select =  ('Select distinct ' + ''+isnull(@Campo_Exibicao,'') + ' from '  + ''
			+ isnull(@Tab_Relacionada,'') + ' where + ' + isnull(@Cod_Busca,'') + '=''' + isnull(@Descr_campo,'')) + ''''
			--''' + isnull(@Num_Insc_Munic,'')+ ''''
		print @select
		
	end
	
	EXEC  (@select)
*/


*/
GO
