SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_NC_Cliente
CREATE procedure [dbo].[spATLD_Tipo_NC_Cliente_Sel]
(
	@Cd_NC				varchar(40),
	@Cd_Pes_Grupo		varChar(10),
	@Descricao_NC		Varchar(150),
	@Tipo				char
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

if @Tipo = 'A' 
	Begin
		select			
			T.Cd_NC				[GNC Display Code],
			T.Descricao_nC		[GNC Display Code Description],
			T.Parte_Resp		[Responsible Party],
			T.Processo			[Process],
			T.Descricao_NC_ENG	[NC],
			T.Descricao_NC_PTG	[NC Translated],
			T.ativo				[Enabled],
			T.Historico_Padrao	[Default History],
			T.Ativo_Historico		[Enable History],
			T.cd_pes_grupo		[Group Code],
			P.Apelido			[Group Name]
		from 
			Tipo_NC_Cliente T with(nolock)
			left join Grupo G with(nolock) on G.cd_pes_grupo = T.cd_pes_grupo
			left join Pessoa P with(nolock) on P.cd_pes = G.cd_pes_grupo
		
	End

if @Tipo = 'B'
	Begin
		select			
			T.Cd_NC				[GNC Display Code],
			T.Descricao_nC		[GNC Display Code Description],
			T.Parte_Resp			[Responsible Party],
			T.Processo			[Process],
			T.Descricao_NC_ENG	[NC],
			T.Descricao_NC_PTG	[NC Translated],
			T.ativo				[Enabled],
			T.Historico_Padrao	[Default History],
			T.Ativo_Historico		[Enable History],
			T.cd_pes_grupo		[Group Code],
			P.Apelido			[Group Name]
		from 
			Tipo_NC_Cliente T with(nolock)
			left join Grupo G with(nolock) on G.cd_pes_grupo = T.cd_pes_grupo
			left join Pessoa P with(nolock) on P.cd_pes = G.cd_pes_grupo
		where
			T.Ativo ='S'
	End

if @Tipo = 'C' 
	Begin
		select			
			T.Cd_NC				[GNC Display Code],
			T.Descricao_nC		[GNC Display Code Description],
			T.Parte_Resp			[Responsible Party],
			T.Processo			[Process],
			T.Descricao_NC_ENG	[NC],
			T.Descricao_NC_PTG	[NC Translated],
			T.ativo				[Enabled],
			T.Historico_Padrao	[Default History],
			T.Ativo_Historico		[Enable History],
			T.cd_pes_grupo		[Group Code],
			P.Apelido			[Group Name]
		from 
			Tipo_NC_Cliente T with(nolock)
			left join Grupo G with(nolock) on G.cd_pes_grupo = T.cd_pes_grupo
			left join Pessoa P with(nolock) on P.cd_pes = G.cd_pes_grupo
		where 
			T.Cd_NC	 = @Cd_NC AND T.cd_pes_grupo = @cd_pes_grupo
	End
	
if  @Tipo = 'D'
	Begin
		select			
			T.Cd_NC				[GNC Display Code],
			T.Descricao_nC		[GNC Display Code Description],
			T.Parte_Resp			[Responsible Party],
			T.Processo			[Process],
			T.Descricao_NC_ENG	[NC],
			T.Descricao_NC_PTG	[NC Translated],
			T.ativo				[Enabled],
			T.Historico_Padrao	[Default History],
			T.Ativo_Historico		[Enable History],
			T.cd_pes_grupo		[Group Code],
			P.Apelido			[Group Name]
		from 
			Tipo_NC_Cliente T with(nolock)
			left join Grupo G with(nolock) on G.cd_pes_grupo = T.cd_pes_grupo
			left join Pessoa P with(nolock) on P.cd_pes = G.cd_pes_grupo
		where 
			T.Cd_NC	 = @Cd_NC AND T.cd_pes_grupo = @cd_pes_grupo
			and T.Ativo ='S'
	End
	
if @Tipo = 'N' 
	Begin
		select			
			T.Cd_NC				[GNC Display Code],
			T.Descricao_nC		[GNC Display Code Description],
			T.Parte_Resp		[Responsible Party],
			T.Processo			[Process],
			T.Descricao_NC_ENG	[NC],
			T.Descricao_NC_PTG	[NC Translated],
			T.ativo				[Enabled],
			T.Historico_Padrao	[Default History],
			T.Ativo_Historico		[Enable History],
			T.cd_pes_grupo		[Group Code],
			P.Apelido			[Group Name]
		from 
			Tipo_NC_Cliente T with(nolock)
			left join Grupo G with(nolock) on G.cd_pes_grupo = T.cd_pes_grupo
			left join Pessoa P with(nolock) on P.cd_pes = G.cd_pes_grupo
		where 
			T.Descricao_nC = @Descricao_NC AND
			T.cd_pes_grupo = @cd_pes_grupo
	End
	
if @Tipo = 'O'
	Begin
		select			
			T.Cd_NC				[GNC Display Code],
			T.Descricao_nC		[GNC Display Code Description],
			T.Parte_Resp		[Responsible Party],
			T.Processo			[Process],
			T.Descricao_NC_ENG	[NC],
			T.Descricao_NC_PTG	[NC Translated],
			T.ativo				[Enabled],
			T.Historico_Padrao	[Default History],
			T.Ativo_Historico		[Enable History],
			T.cd_pes_grupo		[Group Code],
			P.Apelido			[Group Name]
		from 
			Tipo_NC_Cliente T with(nolock)
			left join Grupo G with(nolock) on G.cd_pes_grupo = T.cd_pes_grupo
			left join Pessoa P with(nolock) on P.cd_pes = G.cd_pes_grupo
		where 
			T.Descricao_nC = @Descricao_NC AND
			T.cd_pes_grupo = @cd_pes_grupo
			and T.Ativo ='S'
	End
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select			
			T.Cd_NC				[GNC Display Code],
			T.Descricao_nC		[GNC Display Code Description],
			T.Parte_Resp		[Responsible Party],
			T.Processo			[Process],
			T.Descricao_NC_ENG	[NC],
			T.Descricao_NC_PTG	[NC Translated],
			T.ativo				[Enabled],
			T.Historico_Padrao	[Default History],
			T.Ativo_Historico		[Enable History],
			T.cd_pes_grupo		[Group Code],
			P.Apelido			[Group Name]
		from 
			Tipo_NC_Cliente T with(nolock)
			left join Grupo G with(nolock) on G.cd_pes_grupo = T.cd_pes_grupo
			left join Pessoa P with(nolock) on P.cd_pes = G.cd_pes_grupo
		where 
			--T.Descricao_nC = @Descricao_nC
			T.cd_pes_grupo = @cd_pes_grupo 
			AND T.Cd_NC <> @Cd_NC
	End

	if @Tipo = 'E' 
	Begin
		select			
			T.Cd_NC				[GNC Display Code],
			T.Descricao_nC		[GNC Display Code Description],
			T.Parte_Resp			[Responsible Party],
			T.Processo			[Process],
			T.Descricao_NC_ENG	[NC],
			T.Descricao_NC_PTG	[NC Translated],
			T.ativo				[Enabled],
			T.Historico_Padrao	[Default History],
			T.Ativo_Historico		[Enable History],
			T.cd_pes_grupo		[Group Code],
			P.Apelido			[Group Name]
		from 
			Tipo_NC_Cliente T with(nolock)
			left join Grupo G with(nolock) on G.cd_pes_grupo = T.cd_pes_grupo
			left join Pessoa P with(nolock) on P.cd_pes = G.cd_pes_grupo
		where 
			T.Cd_NC	 = @Cd_NC
	End
GO
