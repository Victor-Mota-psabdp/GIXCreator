SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create VIEW [dbo].[vwProc_NCM_Sel]
AS
	
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

GO
