SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[vwInsertJOB_Reference_Rules_Sel]
AS

select 
			T.Id							[Id],
			T.Modal							[Modal Code],
			TM.Nome_TP_MODAL				[Modal Name],
			T.Cd_Pes_Grupo					[Group Code],
			P.Apelido						[Group Name],			
			T.ID_DC							[Doc Code],
			TDC.Nome_DC						[Doc Name],
			T.Status						[Enabled],
			T.Cd_Usuario					[User Code],
			U.Nome_Usuario					[User Name],
			T.Dt_Ins						[Insert Date]
		from InsertJOB_Reference_Rules T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
			Join Tipo_Modal_Imp_Exp		TM	With(nolock) on T.Modal = TM.CD_TP_MODAL
			join Pessoa P with(nolock) on P.Cd_Pes=T.Cd_Pes_Grupo
			join Tipo_Doc_Cliente TDC with(nolock) on TDC.ID_DC = T.ID_DC

GO
