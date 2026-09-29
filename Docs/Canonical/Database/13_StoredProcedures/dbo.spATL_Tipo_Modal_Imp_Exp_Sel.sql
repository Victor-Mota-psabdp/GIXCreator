SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Modal_Imp_Exp
CREATE procedure [dbo].[spATL_Tipo_Modal_Imp_Exp_Sel]
(
	@CD_TP_MODAL		varchar(2),
	@Nome_TP_MODAL		varchar(100),
	@Tipo char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Statuss
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Statuss
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Statuss
*/

if @Tipo = 'A' 
	Begin
		select 
			CD_TP_MODAL [Code], Nome_TP_MODAL [Modal Type Name],Status [Enabled],
			T.Cd_Usuario [User Code],U.Nome_Usuario [User Name],dt_ins [Insert Date]
		from Tipo_Modal_Imp_Exp T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
	End
	
if  @Tipo = 'B'
	Begin
		select 
			CD_TP_MODAL [Code], Nome_TP_MODAL [Modal Type Name],Status [Enabled],
			T.Cd_Usuario [User Code],U.Nome_Usuario [User Name],dt_ins [Insert Date] 
		from Tipo_Modal_Imp_Exp T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			Status = 1
	End

if @Tipo = 'C'
	Begin
		select 
			CD_TP_MODAL [Code], Nome_TP_MODAL [Modal Type Name],Status [Enabled],
			T.Cd_Usuario [User Code],U.Nome_Usuario [User Name],dt_ins [Insert Date] 
		from Tipo_Modal_Imp_Exp T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			CD_TP_MODAL = @CD_TP_MODAL and
			Status = 1
	End
if @Tipo = 'D'
	Begin
		select 
			CD_TP_MODAL [Code], Nome_TP_MODAL [Modal Type Name],Status [Enabled],
			T.Cd_Usuario [User Code],U.Nome_Usuario [User Name],dt_ins [Insert Date] 
		from Tipo_Modal_Imp_Exp T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			CD_TP_MODAL = @CD_TP_MODAL and
			Status = 1
	End
	
if @Tipo = 'N'
	Begin
		select 
			CD_TP_MODAL [Code], Nome_TP_MODAL [Modal Type Name],Status [Enabled],
			T.Cd_Usuario [User Code],U.Nome_Usuario [User Name],dt_ins [Insert Date] 
		from Tipo_Modal_Imp_Exp T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			Nome_TP_MODAL = @Nome_TP_MODAL
	End
	
if @Tipo = 'O'
	Begin
		select 
			CD_TP_MODAL [Code], Nome_TP_MODAL [Modal Type Name],Status [Enabled],
			T.Cd_Usuario [User Code],U.Nome_Usuario [User Name],dt_ins [Insert Date] 
		from Tipo_Modal_Imp_Exp T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			Nome_TP_MODAL = @Nome_TP_MODAL and
			Status = 1
	End
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			CD_TP_MODAL [Code], Nome_TP_MODAL [Modal Type Name],Status [Enabled],
			T.Cd_Usuario [User Code],U.Nome_Usuario [User Name],dt_ins [Insert Date] 
		from Tipo_Modal_Imp_Exp T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			Nome_TP_MODAL = @Nome_TP_MODAL
			AND CD_TP_MODAL <> @CD_TP_MODAL
	End

if  @Tipo = 'S'
	Begin
		select 
			CD_TP_MODAL [Code], Nome_TP_MODAL [Modal Type Name],Status [Enabled],
			T.Cd_Usuario [User Code],U.Nome_Usuario [User Name],dt_ins [Insert Date] 
		from Tipo_Modal_Imp_Exp T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			Status = 1
			and CD_TP_MODAL not in ('AL','BO')
	End

GO
