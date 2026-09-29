SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Alerta_Ocorrencia
create procedure [dbo].[spATL_Alerta_Ocorrencia_Sel]--null,'Teste','Z'
(
	@Cd_Tp_Ocor		int,
	@Cd_Pes_Grupo	varchar(10),	
	@Modal			char(2),
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
--sp_help Alerta_Ocorrencia
if @Tipo = 'A' 
	Begin
		select
			A.Cd_Pes_Grupo		[Group Code],
			G.Apelido			[Group Name],
			A.cd_Tp_Ocor		[Type Of Occurrence Code],
			T.Nome_Tp_Ocor		[Type Of Occurrence Name],			
			A.Modal				[Modal Type Code],
			TM.Nome_TP_MODAL	[Modal Type Name],
			A.Emails			[Emails],
			A.ResponderPara		[Reply To],
			A.Assunto			[Subject],
			A.cd_usuario		[User Code],
			US.Nome_Usuario		[User Name],
			A.dt_ins			[Insert Date],
			A.Ativo				[Enabled]
		from Alerta_Ocorrencia A with(nolock) 
			Join tipo_ocorrencia T with(nolock) on T.Cd_Tp_Ocor = A.Cd_Tp_Ocor
			join Pessoa G with(nolock) on  G.cd_pes = A.Cd_Pes_Grupo
			join Usuario US with(nolock) on US.Cd_Usuario = A.Cd_Usuario
			join Tipo_Modal_Imp_Exp TM with(nolock) on TM.CD_TP_MODAL = A.Modal
		Order by 1
	End
	
if  @Tipo = 'B'
	Begin
		select
			A.Cd_Pes_Grupo		[Group Code],
			G.Apelido			[Group Name],
			A.cd_Tp_Ocor		[Type Of Occurrence Code],
			T.Nome_Tp_Ocor		[Type Of Occurrence Name],			
			A.Modal				[Modal Type Code],
			TM.Nome_TP_MODAL	[Modal Type Name],
			A.Emails			[Emails],
			A.ResponderPara		[Reply To],
			A.Assunto			[Subject],
			A.cd_usuario		[User Code],
			US.Nome_Usuario		[User Name],
			A.dt_ins			[Insert Date],
			A.Ativo				[Enabled]
		from Alerta_Ocorrencia A with(nolock) 
			Join tipo_ocorrencia T with(nolock) on T.Cd_Tp_Ocor = A.Cd_Tp_Ocor
			join Pessoa G with(nolock) on  G.cd_pes = A.Cd_Pes_Grupo
			join Usuario US with(nolock) on US.Cd_Usuario = A.Cd_Usuario
			join Tipo_Modal_Imp_Exp TM with(nolock) on TM.CD_TP_MODAL = A.Modal	
		where
			A.Cd_Pes_Grupo = @Cd_Pes_Grupo
			--A.Ativo = 1
		Order by 1
	End

if @Tipo = 'C'
	Begin
		select
			A.Cd_Pes_Grupo		[Group Code],
			G.Apelido			[Group Name],
			A.cd_Tp_Ocor		[Type Of Occurrence Code],
			T.Nome_Tp_Ocor		[Type Of Occurrence Name],			
			A.Modal				[Modal Type Code],
			TM.Nome_TP_MODAL	[Modal Type Name],
			A.Emails			[Emails],
			A.ResponderPara		[Reply To],
			A.Assunto			[Subject],
			A.cd_usuario		[User Code],
			US.Nome_Usuario		[User Name],
			A.dt_ins			[Insert Date],
			A.Ativo				[Enabled]
		from Alerta_Ocorrencia A with(nolock) 
			Join tipo_ocorrencia T with(nolock) on T.Cd_Tp_Ocor = A.Cd_Tp_Ocor
			join Pessoa G with(nolock) on  G.cd_pes = A.Cd_Pes_Grupo
			join Usuario US with(nolock) on US.Cd_Usuario = A.Cd_Usuario
			join Tipo_Modal_Imp_Exp TM with(nolock) on TM.CD_TP_MODAL = A.Modal	
		where
			A.Cd_Tp_Ocor = @Cd_Tp_Ocor and A.Cd_Pes_Grupo = @Cd_Pes_Grupo
		Order by 1
	End
	
if @Tipo = 'D'
	Begin
		select
			A.Cd_Pes_Grupo		[Group Code],
			G.Apelido			[Group Name],
			A.cd_Tp_Ocor		[Type Of Occurrence Code],
			T.Nome_Tp_Ocor		[Type Of Occurrence Name],			
			A.Modal				[Modal Type Code],
			TM.Nome_TP_MODAL	[Modal Type Name],
			A.Emails			[Emails],
			A.ResponderPara		[Reply To],
			A.Assunto			[Subject],
			A.cd_usuario		[User Code],
			US.Nome_Usuario		[User Name],
			A.dt_ins			[Insert Date],
			A.Ativo				[Enabled]
		from Alerta_Ocorrencia A with(nolock) 
			Join tipo_ocorrencia T with(nolock) on T.Cd_Tp_Ocor = A.Cd_Tp_Ocor
			join Pessoa G with(nolock) on  G.cd_pes = A.Cd_Pes_Grupo
			join Usuario US with(nolock) on US.Cd_Usuario = A.Cd_Usuario
			join Tipo_Modal_Imp_Exp TM with(nolock) on TM.CD_TP_MODAL = A.Modal	
		where
			A.Cd_Tp_Ocor = @Cd_Tp_Ocor and A.Cd_Pes_Grupo = @Cd_Pes_Grupo
			and A.Ativo = 1
		Order by 1
	End
	
if @Tipo = 'N'
	Begin
		select
			A.Cd_Pes_Grupo		[Group Code],
			G.Apelido			[Group Name],
			A.cd_Tp_Ocor		[Type Of Occurrence Code],
			T.Nome_Tp_Ocor		[Type Of Occurrence Name],			
			A.Modal				[Modal Type Code],
			TM.Nome_TP_MODAL	[Modal Type Name],
			A.Emails			[Emails],
			A.ResponderPara		[Reply To],
			A.Assunto			[Subject],
			A.cd_usuario		[User Code],
			US.Nome_Usuario		[User Name],
			A.dt_ins			[Insert Date],
			A.Ativo				[Enabled]
		from Alerta_Ocorrencia A with(nolock) 
			Join tipo_ocorrencia T with(nolock) on T.Cd_Tp_Ocor = A.Cd_Tp_Ocor
			join Pessoa G with(nolock) on  G.cd_pes = A.Cd_Pes_Grupo
			join Usuario US with(nolock) on US.Cd_Usuario = A.Cd_Usuario
			join Tipo_Modal_Imp_Exp TM with(nolock) on TM.CD_TP_MODAL = A.Modal	
		where
			A.Cd_Tp_Ocor = @Cd_Tp_Ocor and A.Cd_Pes_Grupo = @Cd_Pes_Grupo
			and A.Modal = @Modal
		Order by 1
	End
	
if @Tipo = 'O'
	Begin
		select
			A.Cd_Pes_Grupo		[Group Code],
			G.Apelido			[Group Name],
			A.cd_Tp_Ocor		[Type Of Occurrence Code],
			T.Nome_Tp_Ocor		[Type Of Occurrence Name],			
			A.Modal				[Modal Type Code],
			TM.Nome_TP_MODAL	[Modal Type Name],
			A.Emails			[Emails],
			A.ResponderPara		[Reply To],
			A.Assunto			[Subject],
			A.cd_usuario		[User Code],
			US.Nome_Usuario		[User Name],
			A.dt_ins			[Insert Date],
			A.Ativo				[Enabled]
		from Alerta_Ocorrencia A with(nolock) 
			Join tipo_ocorrencia T with(nolock) on T.Cd_Tp_Ocor = A.Cd_Tp_Ocor
			join Pessoa G with(nolock) on  G.cd_pes = A.Cd_Pes_Grupo
			join Usuario US with(nolock) on US.Cd_Usuario = A.Cd_Usuario
			join Tipo_Modal_Imp_Exp TM with(nolock) on TM.CD_TP_MODAL = A.Modal	
		where
			A.Cd_Tp_Ocor = @Cd_Tp_Ocor and A.Cd_Pes_Grupo = @Cd_Pes_Grupo
			and A.Modal = @Modal and A.Ativo = 1
		Order by 1
	End
	
--if @Tipo = 'Z' --or @Tipo = 'O'
--	Begin
--		select
--			A.Cd_Pes_Grupo		[Group Code],
			--G.Apelido			[Group Name],
			--A.cd_Tp_Ocor		[Type Of Occurrence Code],
			--T.Nome_Tp_Ocor		[Type Of Occurrence Name],			
			--A.Modal				[Modal Type Code],
			--TM.Nome_TP_MODAL	[Modal Type Name],
			--A.Emails			[Emails],
			--A.ResponderPara		[Reply To],
			--A.Assunto			[Subject],
			--A.cd_usuario		[User Code],
			--US.Nome_Usuario		[User Name],
			--A.dt_ins			[Insert Date],
			--A.Ativo				[Enabled]
--		from Alerta_Ocorrencia A with(nolock) 
--			Join tipo_ocorrencia T with(nolock) on T.Cd_Tp_Ocor = A.Cd_Tp_Ocor
--			join Pessoa G with(nolock) on  G.cd_pes = A.Cd_Pes_Grupo
--			join Usuario US with(nolock) on US.Cd_Usuario = A.Cd_Usuario
--			join Tipo_Modal_Imp_Exp TM with(nolock) on TM.CD_TP_MODAL = A.Modal	
--		where
--			A.Cd_Tp_Ocor = @Cd_Tp_Ocor and A.Cd_Pes_Grupo = @Cd_Pes_Grupo
--			and A.Modal = @Modal and A.Ativo = 1			
--	End

GO
