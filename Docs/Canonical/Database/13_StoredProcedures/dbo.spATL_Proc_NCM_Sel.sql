SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--SP_HELP Proc_NCM
--cadu 02/11/2022 updated 15:51hs
CREATE Procedure [dbo].[spATL_Proc_NCM_Sel]
(	
	@Id_NCM_Proc	int,
	@Num_Proc		VarChar(16),
	@Id_NCM			Int,
	@Tipo			char(1)
)
AS

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codgo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
SP_HELP DOC_ANEXOS
*/

IF @Tipo = 'A' or @Tipo = 'B'
	Begin
		Select
			convert(varchar(25),'Saved')	[Status],
			P.Id_NCM_Proc					[Item],
			P.Num_Proc						[JOB],
			N.NCM							[NCM],
			N.NCM							[NCM Code],
			N.Id_NCM						[ID NCM],
			N.Descricao_NCM					[NCM Description]		
 		from 
			Proc_NCM P  With(nolock)
			left join NCM as N With(nolock) on P.Id_NCM = N.Id_NCM
		order by 3
	
End
IF @Tipo = 'C' or @Tipo = 'D'
	Begin	
		Select
			convert(varchar(25),'Saved')	[Status],
			P.Id_NCM_Proc					[Item],
			P.Num_Proc						[JOB],
			N.NCM							[NCM],
			N.NCM							[NCM Code],
			N.Id_NCM						[ID NCM],
			N.Descricao_NCM					[NCM Description]		
 		from 
			Proc_NCM P  With(nolock)
			left join NCM as N With(nolock) on P.Id_NCM = N.Id_NCM
		where 
			P.Num_Proc=@Num_Proc
	order by 2
	
End
	
IF @Tipo = 'N' or @Tipo = 'O'
	Begin
		Select
			convert(varchar(25),'Saved')	[Status],
			P.Id_NCM_Proc					[Item],
			P.Num_Proc						[JOB],
			N.NCM							[NCM],
			N.NCM							[NCM Code],
			N.Id_NCM						[ID NCM],
			N.Descricao_NCM					[NCM Description]		
 		from 
			Proc_NCM P  With(nolock)
			left join NCM as N With(nolock) on P.Id_NCM = N.Id_NCM
		where 
			P.Num_Proc=@Num_Proc and P.ID_NCM_PROC = @ID_NCM_PROC
		order by 2
	End


IF @Tipo = 'P' 
	Begin
		Select
			convert(varchar(25),'Saved')	[Status],
			P.Id_NCM_Proc					[Item],
			P.Num_Proc						[JOB],
			N.NCM							[NCM],
			N.NCM							[NCM Code],
			N.Id_NCM						[ID NCM],
			N.Descricao_NCM					[NCM Description]		
 		from 
			Proc_NCM P  With(nolock)
			left join NCM as N With(nolock) on P.Id_NCM = N.Id_NCM
		where 
			P.Num_Proc=@Num_Proc and P.Id_NCM = @Id_NCM
		order by 2
	End
		


----SP_HELP Proc_NCM
--ALTER Procedure [dbo].[spATL_Proc_NCM_Sel]
--(	
--	@Id_NCM_Proc	int,
--	@Num_Proc		VarChar(16),
--	@Tipo		char(1)
--)
--AS

--/*
--A, /// Todos os registros - Existentes
--B, /// Todos os registros - Ativos
--C, /// Busca pelo Codgo - Existentes
--D, /// Busca pelo Codigo - Ativos
--N, /// Busca pelo Nome - Existentes
--O /// Busca pelo Nome - Ativos
--SP_HELP DOC_ANEXOS
--*/

--IF @Tipo = 'A' or @Tipo = 'B'
--	Begin
--		Select
--			convert(varchar(25),'Saved')	[Status],
--			P.Id_NCM_Proc					[Item],
--			P.Num_Proc						[JOB],
--			N.NCM							[NCM],
--			N.NCM							[NCM Code],
--			N.Id_NCM						[ID NCM],
--			N.Descricao_NCM					[NCM Description]		
-- 		from 
--			Proc_NCM P  With(nolock)
--			left join NCM as N With(nolock) on P.Id_NCM = N.Id_NCM
--		order by 3
	
--End
--IF @Tipo = 'C' or @Tipo = 'D'
--	Begin	
--		Select
--			convert(varchar(25),'Saved')	[Status],
--			P.Id_NCM_Proc					[Item],
--			P.Num_Proc						[JOB],
--			N.NCM							[NCM],
--			N.NCM							[NCM Code],
--			N.Id_NCM						[ID NCM],
--			N.Descricao_NCM					[NCM Description]		
-- 		from 
--			Proc_NCM P  With(nolock)
--			left join NCM as N With(nolock) on P.Id_NCM = N.Id_NCM
--		where 
--			P.Num_Proc=@Num_Proc
--	order by 2
	
--End
	
--IF @Tipo = 'N' or @Tipo = 'O'
--	Begin
--		Select
--			convert(varchar(25),'Saved')	[Status],
--			P.Id_NCM_Proc					[Item],
--			P.Num_Proc						[JOB],
--			N.NCM							[NCM],
--			N.NCM							[NCM Code],
--			N.Id_NCM						[ID NCM],
--			N.Descricao_NCM					[NCM Description]		
-- 		from 
--			Proc_NCM P  With(nolock)
--			left join NCM as N With(nolock) on P.Id_NCM = N.Id_NCM
--		where 
--			P.Num_Proc=@Num_Proc and P.ID_NCM_PROC = @ID_NCM_PROC
--		order by 2
--	End
		
		




GO
