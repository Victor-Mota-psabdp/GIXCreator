SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help PDF2ATL_Group
CREATE procedure [dbo].[spATL_PDF2ATL_Group_Sel]
(
	@Id_Dc			int,
	@Cd_Pes_Grupo	varchar(10),	
	@CD_TP_MODAL	char(2),
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
--sp_help PDF2ATL_Group
if @Tipo = 'A' 
	Begin
		select
			A.Cd_Pes_Grupo		[Group Code],
			G.Apelido			[Group Name],
			A.Id_Dc				[Client Doc Type Code],
			T.Nome_DC			[Client Doc Type Name],			
			A.CD_TP_MODAL		[Modal Type Code],
			TM.Nome_TP_MODAL	[Modal Type Name],
			A.Origin			[Origin],
			A.cd_usuario		[User Code],
			US.Nome_Usuario		[User Name],
			A.dt_ins			[Insert Date],
			A.Ativo				[Enabled]
		from PDF2ATL_Group A with(nolock) 
			Join Tipo_Doc_Cliente T with(nolock) on T.ID_DC = A.ID_DC
			join Pessoa G with(nolock) on  G.cd_pes = A.Cd_Pes_Grupo
			join Usuario US with(nolock) on US.Cd_Usuario = A.Cd_Usuario
			join Tipo_Modal_Imp_Exp TM with(nolock) on TM.CD_TP_MODAL = A.CD_TP_MODAL
		Order by 1
	End
	
if  @Tipo = 'B'
	Begin
		select
			A.Cd_Pes_Grupo		[Group Code],
			G.Apelido			[Group Name],
			A.Id_Dc	[Client Doc Type Code],
			T.Nome_DC		[Client Doc Type Name],			
			A.CD_TP_MODAL				[Modal Type Code],
			TM.Nome_TP_MODAL	[Modal Type Name],
			A.Origin			[Origin],
			A.cd_usuario		[User Code],
			US.Nome_Usuario		[User Name],
			A.dt_ins			[Insert Date],
			A.Ativo				[Enabled]
		from PDF2ATL_Group A with(nolock) 
			Join Tipo_Doc_Cliente T with(nolock) on T.ID_DC = A.ID_DC
			join Pessoa G with(nolock) on  G.cd_pes = A.Cd_Pes_Grupo
			join Usuario US with(nolock) on US.Cd_Usuario = A.Cd_Usuario
			join Tipo_Modal_Imp_Exp TM with(nolock) on TM.CD_TP_MODAL = A.CD_TP_MODAL	
		where	
			 A.Ativo = 1
		Order by 1
	End

if @Tipo = 'C'
	Begin
		select
			A.Cd_Pes_Grupo		[Group Code],
			G.Apelido			[Group Name],
			A.Id_Dc	[Client Doc Type Code],
			T.Nome_DC		[Client Doc Type Name],			
			A.CD_TP_MODAL				[Modal Type Code],
			TM.Nome_TP_MODAL	[Modal Type Name],	
			A.Origin			[Origin],
			A.cd_usuario		[User Code],
			US.Nome_Usuario		[User Name],
			A.dt_ins			[Insert Date],
			A.Ativo				[Enabled]
		from PDF2ATL_Group A with(nolock) 
			Join Tipo_Doc_Cliente T with(nolock) on T.ID_DC = A.ID_DC
			join Pessoa G with(nolock) on  G.cd_pes = A.Cd_Pes_Grupo
			join Usuario US with(nolock) on US.Cd_Usuario = A.Cd_Usuario
			join Tipo_Modal_Imp_Exp TM with(nolock) on TM.CD_TP_MODAL = A.CD_TP_MODAL	
		where
			A.Cd_Pes_Grupo = @Cd_Pes_Grupo
		Order by 1
	End
	
if @Tipo = 'D'
	Begin
		select
			A.Cd_Pes_Grupo		[Group Code],
			G.Apelido			[Group Name],
			A.Id_Dc	[Client Doc Type Code],
			T.Nome_DC		[Client Doc Type Name],			
			A.CD_TP_MODAL				[Modal Type Code],
			TM.Nome_TP_MODAL	[Modal Type Name],	
			A.Origin			[Origin],
			A.cd_usuario		[User Code],
			US.Nome_Usuario		[User Name],
			A.dt_ins			[Insert Date],
			A.Ativo				[Enabled]
		from PDF2ATL_Group A with(nolock) 
			Join Tipo_Doc_Cliente T with(nolock) on T.ID_DC = A.ID_DC
			join Pessoa G with(nolock) on  G.cd_pes = A.Cd_Pes_Grupo
			join Usuario US with(nolock) on US.Cd_Usuario = A.Cd_Usuario
			join Tipo_Modal_Imp_Exp TM with(nolock) on TM.CD_TP_MODAL = A.CD_TP_MODAL	
		where
			A.Cd_Pes_Grupo = @Cd_Pes_Grupo
			and A.Ativo = 1
		Order by 1
	End
	
if @Tipo = 'N'
	Begin
		select
			A.Cd_Pes_Grupo		[Group Code],
			G.Apelido			[Group Name],
			A.Id_Dc	[Client Doc Type Code],
			T.Nome_DC		[Client Doc Type Name],			
			A.CD_TP_MODAL				[Modal Type Code],
			TM.Nome_TP_MODAL	[Modal Type Name],
			A.Origin			[Origin],
			A.cd_usuario		[User Code],
			US.Nome_Usuario		[User Name],
			A.dt_ins			[Insert Date],
			A.Ativo				[Enabled]
		from PDF2ATL_Group A with(nolock) 
			Join Tipo_Doc_Cliente T with(nolock) on T.ID_DC = A.ID_DC
			join Pessoa G with(nolock) on  G.cd_pes = A.Cd_Pes_Grupo
			join Usuario US with(nolock) on US.Cd_Usuario = A.Cd_Usuario
			join Tipo_Modal_Imp_Exp TM with(nolock) on TM.CD_TP_MODAL = A.CD_TP_MODAL	
		where
			A.ID_DC = @ID_DC and A.Cd_Pes_Grupo = @Cd_Pes_Grupo			
		Order by 1
	End
	
if @Tipo = 'O'
	Begin
		select
			A.Cd_Pes_Grupo		[Group Code],
			G.Apelido			[Group Name],
			A.Id_Dc	[Client Doc Type Code],
			T.Nome_DC		[Client Doc Type Name],			
			A.CD_TP_MODAL				[Modal Type Code],
			TM.Nome_TP_MODAL	[Modal Type Name],	
			A.Origin			[Origin],
			A.cd_usuario		[User Code],
			US.Nome_Usuario		[User Name],
			A.dt_ins			[Insert Date],
			A.Ativo				[Enabled]
		from PDF2ATL_Group A with(nolock) 
			Join Tipo_Doc_Cliente T with(nolock) on T.ID_DC = A.ID_DC
			join Pessoa G with(nolock) on  G.cd_pes = A.Cd_Pes_Grupo
			join Usuario US with(nolock) on US.Cd_Usuario = A.Cd_Usuario
			join Tipo_Modal_Imp_Exp TM with(nolock) on TM.CD_TP_MODAL = A.CD_TP_MODAL	
		where
			A.ID_DC = @ID_DC and A.Cd_Pes_Grupo = @Cd_Pes_Grupo
			and A.Ativo = 1
		Order by 1
	End

if @Tipo = 'P'
	Begin
		select
			A.Cd_Pes_Grupo		[Group Code],
			G.Apelido			[Group Name],
			A.Id_Dc	[Client Doc Type Code],
			T.Nome_DC		[Client Doc Type Name],			
			A.CD_TP_MODAL				[Modal Type Code],
			TM.Nome_TP_MODAL	[Modal Type Name],
			A.Origin			[Origin],
			A.cd_usuario		[User Code],
			US.Nome_Usuario		[User Name],
			A.dt_ins			[Insert Date],
			A.Ativo				[Enabled]
		from PDF2ATL_Group A with(nolock) 
			Join Tipo_Doc_Cliente T with(nolock) on T.ID_DC = A.ID_DC
			join Pessoa G with(nolock) on  G.cd_pes = A.Cd_Pes_Grupo
			join Usuario US with(nolock) on US.Cd_Usuario = A.Cd_Usuario
			join Tipo_Modal_Imp_Exp TM with(nolock) on TM.CD_TP_MODAL = A.CD_TP_MODAL	
		where
			A.ID_DC = @ID_DC and A.Cd_Pes_Grupo = @Cd_Pes_Grupo
			and A.CD_TP_MODAL = @CD_TP_MODAL
		Order by 1
	End
	
if @Tipo = 'Q'
	Begin
		select
			A.Cd_Pes_Grupo		[Group Code],
			G.Apelido			[Group Name],
			A.Id_Dc				[Client Doc Type Code],
			T.Nome_DC			[Client Doc Type Name],			
			A.CD_TP_MODAL				[Modal Type Code],
			TM.Nome_TP_MODAL	[Modal Type Name],	
			A.Origin			[Origin],
			A.cd_usuario		[User Code],
			US.Nome_Usuario		[User Name],
			A.dt_ins			[Insert Date],
			A.Ativo				[Enabled]
		from PDF2ATL_Group A with(nolock) 
			Join Tipo_Doc_Cliente T with(nolock) on T.ID_DC = A.ID_DC
			join Pessoa G with(nolock) on  G.cd_pes = A.Cd_Pes_Grupo
			join Usuario US with(nolock) on US.Cd_Usuario = A.Cd_Usuario
			join Tipo_Modal_Imp_Exp TM with(nolock) on TM.CD_TP_MODAL = A.CD_TP_MODAL	
		where
			A.ID_DC = @ID_DC and A.Cd_Pes_Grupo = @Cd_Pes_Grupo
			and A.CD_TP_MODAL = @CD_TP_MODAL
			and A.Ativo = 1
		Order by 1
	End
	
--if @Tipo = 'Z' --or @Tipo = 'O'
--	Begin
--		select
--			A.Cd_Pes_Grupo		[Group Code],
			--G.Apelido			[Group Name],
			--A.Id_Dc	[Client Doc Type Code],
			--T.Nome_DC		[Client Doc Type Name],			
			--A.CD_TP_MODAL				[Modal Type Code],
			--TM.Nome_TP_MODAL	[Modal Type Name],
			--A.Emails			[Emails],
			--A.ResponderPara		[Reply To],
			--A.Assunto			[Subject],
			--A.cd_usuario		[User Code],
			--US.Nome_Usuario		[User Name],
			--A.dt_ins			[Insert Date],
			--A.Ativo				[Enabled]
--		from PDF2ATL_Group A with(nolock) 
--			Join Tipo_Doc_Cliente T with(nolock) on T.ID_DC = A.ID_DC
--			join Pessoa G with(nolock) on  G.cd_pes = A.Cd_Pes_Grupo
--			join Usuario US with(nolock) on US.Cd_Usuario = A.Cd_Usuario
--			join Tipo_Modal_Imp_Exp TM with(nolock) on TM.CD_TP_MODAL = A.CD_TP_MODAL	
--		where
--			A.ID_DC = @ID_DC and A.Cd_Pes_Grupo = @Cd_Pes_Grupo
--			and A.CD_TP_MODAL = @CD_TP_MODAL and A.Ativo = 1			
--	End

GO
