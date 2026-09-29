SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_Campo_Processo_New_Sel '%','Protocolo MAPA','R'
--included 12/11/21 - Cadu and H.Num_Proc is not null
--sp_help Campo_Processo
CREATE procedure [dbo].[spATL_Campo_Processo_New_Sel]--'imcsr201901001br','137','A'
(
	@Num_proc	varChar(16),
	@Id_Campo	bigint,
	@Tipo char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O, /// Busca pelo Nome - Ativos
R  /// Protocolo Mapa
*/

Declare @Grupo Varchar (20)
set @Grupo=(select top 1 cd_pes_grupo from vwcliente with (nolock) 
	join pessoa_llp p with(nolock) on p.cd_pes=cd_cliente and num_proc=@Num_proc)
	
if @Tipo = 'A'  or @Tipo = 'B'
	Begin	
		select distinct
			H.Num_Proc					[JOB],			
			tcc.id_campo				[Field Code],			
			tcc.Descr_Campo				[Field Description],			
			isnull(H.Campo_Dados,'')	[Information Code],	
			convert(varchar(500),'')	[Information Value],		
			
			tcc.cod_busca				[Search Code],	
			tcc.Tab_Relacionada			[Related Table],
			tcc.Tipo					[Type Code],
			T.Nome_Tipo					[Type Name],
			tcc.Campo_Exibicao			[Display Field],
			TCC.Where_Field				[Where Field],
			TCC.Cd_Pes_Grupo			[Group Code],
			A.Apelido					[Group Name],
			H.Cd_Usuario				[User Code],
			Us.Nome_Usuario				[User Name],
			H.Dt_Ins					[Insert Date]		
		from Tipo_Campo_Cliente TCC 
			left join Campo_Processo H on TCC.Id_Campo  = H.Id_Campo and H.Num_Proc = @Num_proc
			left join Usuario Us	on Us.Cd_Usuario  = H.cd_usuario
			left join Pessoa A	on A.CD_PES = tcc.Cd_Pes_Grupo
			LEFT JOIN Tipo_Variavel T ON T.Cd_Tipo = tcc.TIPO
			LEFT join tipo_campo_cliente_modais M with (nolock) on M.id_campo = TCC.id_campo		
		where 
			TCC.cd_pes_grupo in ('10017',@Grupo) and TCC.Tipo <> 'X'
			and (( len(@Num_proc)=16 and M.house=1) or (len(@Num_proc)=14 and M.master=1 ))
			and ((left(@Num_proc,1) = 'E' and Export = '1') or (left(@Num_proc,1) = 'I' and Import = '1'))
			and ((substring(@Num_proc,2,1) = 'A' and Air = '1') or (substring(@Num_proc,2,1) = 'M' and Ocean = '1') 
			or (substring(@Num_proc,2,1) = 'O' and Other = '1'))
		order by
		Descr_Campo
	End

if @Tipo = 'C'  or @Tipo = 'D'
	Begin
		select distinct
			H.Num_Proc					[JOB],			
			tcc.id_campo				[Field Code],			
			tcc.Descr_Campo				[Field Description],			
			isnull(H.Campo_Dados,'')	[Information Code],	
			convert(varchar(500),'')	[Information Value],		
			
			tcc.cod_busca				[Search Code],	
			tcc.Tab_Relacionada			[Related Table],
			tcc.Tipo					[Type Code],
			T.Nome_Tipo					[Type Name],
			tcc.Campo_Exibicao			[Display Field],
			TCC.Where_Field				[Where Field],
			TCC.Cd_Pes_Grupo			[Group Code],
			A.Apelido					[Group Name],
			H.Cd_Usuario				[User Code],
			Us.Nome_Usuario				[User Name],
			H.Dt_Ins					[Insert Date]		
		from Tipo_Campo_Cliente TCC 
			left join Campo_Processo H on TCC.Id_Campo  = H.Id_Campo and H.Num_Proc = @Num_proc
			left join Usuario Us	on Us.Cd_Usuario  = H.cd_usuario
			left join Pessoa A	on A.CD_PES = tcc.Cd_Pes_Grupo
			LEFT JOIN Tipo_Variavel T ON T.Cd_Tipo = tcc.TIPO
			LEFT join tipo_campo_cliente_modais M with (nolock) on M.id_campo = TCC.id_campo
			 Join grupo G with(nolock) on G.cd_pes_grupo=TCC.cd_pes_grupo 		
		where 
			TCC.cd_pes_grupo in ('10017',@Grupo)
			and TCC.Id_Campo =@Id_Campo	
			--and H.Num_Proc = @Num_proc
			--(TCC.cd_pes_grupo='10017' or G.Grupo=substring(@Num_proc,5, 3)) 
			--and Descr_Campo=@Descr_Campo	
			----and cp.Num_Proc = @Num_proc
			and H.Num_Proc is not null
		order by
		Descr_Campo
	End

if @Tipo = 'N'  or @Tipo = 'O'
	Begin
		select distinct
			H.Num_Proc					[JOB],			
			tcc.id_campo				[Field Code],			
			tcc.Descr_Campo				[Field Description],			
			isnull(H.Campo_Dados,'')	[Information Code],	
			convert(varchar(500),'')	[Information Value],		
			
			tcc.cod_busca				[Search Code],	
			tcc.Tab_Relacionada			[Related Table],
			tcc.Tipo					[Type Code],
			T.Nome_Tipo					[Type Name],
			tcc.Campo_Exibicao			[Display Field],
			TCC.Where_Field				[Where Field],
			TCC.Cd_Pes_Grupo			[Group Code],
			A.Apelido					[Group Name],
			H.Cd_Usuario				[User Code],
			Us.Nome_Usuario				[User Name],
			H.Dt_Ins					[Insert Date]		
		from Tipo_Campo_Cliente TCC 
			left join Campo_Processo H on TCC.Id_Campo  = H.Id_Campo and H.Num_Proc = @Num_proc
			left join Usuario Us	on Us.Cd_Usuario  = H.cd_usuario
			left join Pessoa A	on A.CD_PES = tcc.Cd_Pes_Grupo
			LEFT JOIN Tipo_Variavel T ON T.Cd_Tipo = tcc.TIPO
			LEFT join tipo_campo_cliente_modais M with (nolock) on M.id_campo = TCC.id_campo
			 Join grupo G with(nolock) on G.cd_pes_grupo=TCC.cd_pes_grupo 		
		where 
			TCC.cd_pes_grupo in ('10017',@Grupo)
			and TCC.Id_Campo =@Id_Campo	
			--and H.Num_Proc = @Num_proc
			and H.Num_Proc is not null			
		order by
		Descr_Campo
	End

if @Tipo = 'R'
	Begin
		select distinct
			H.Num_Proc					[JOB],			
			tcc.id_campo				[Field Code],			
			tcc.Descr_Campo				[Field Description],			
			isnull(H.Campo_Dados,'')	[Information Code],	
			convert(varchar(500),'')	[Information Value],		
			
			tcc.cod_busca				[Search Code],	
			tcc.Tab_Relacionada			[Related Table],
			tcc.Tipo					[Type Code],
			T.Nome_Tipo					[Type Name],
			tcc.Campo_Exibicao			[Display Field],
			TCC.Where_Field				[Where Field],
			TCC.Cd_Pes_Grupo			[Group Code],
			A.Apelido					[Group Name],
			H.Cd_Usuario				[User Code],
			Us.Nome_Usuario				[User Name],
			H.Dt_Ins					[Insert Date]		
		from Tipo_Campo_Cliente TCC 
			left join Campo_Processo H on TCC.Id_Campo  = H.Id_Campo and H.Num_Proc like @Num_proc
			left join Usuario Us	on Us.Cd_Usuario  = H.cd_usuario
			left join Pessoa A	on A.CD_PES = tcc.Cd_Pes_Grupo
			LEFT JOIN Tipo_Variavel T ON T.Cd_Tipo = tcc.TIPO
			LEFT join tipo_campo_cliente_modais M with (nolock) on M.id_campo = TCC.id_campo
			 Join grupo G with(nolock) on G.cd_pes_grupo=TCC.cd_pes_grupo 		
		where 
			TCC.cd_pes_grupo in ('10017','1')
			and
			TCC.Id_Campo = @Id_Campo	
			--and H.Num_Proc = @Num_proc
			and H.Num_Proc is not null
			and year(H.Dt_Ins) >= year(getdate()) - 5
		order by
		Descr_Campo
	End
GO
