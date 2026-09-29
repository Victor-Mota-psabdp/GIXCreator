SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[vwHistorico_Auto_Sel] 
as 
	Select 	distinct	
			H.Id_Hist_Auto								[Code],
			H.Id_Task									[Task Code],
			(case 
				when H.Id_Task > 0 then TT.Nome_Task
				when H.Id_Task = -1 then 'ETD'
				when H.Id_Task = -2 then 'ATD'
				when H.Id_Task = -3 then 'ETA'
				when H.Id_Task = -4 then 'ATA'
			end)										[Task Name],			
			H.Cd_Pes_Grupo								[Group Code],
			P.Apelido									[Group Name],
			H.Modal										[Modal Code],
			TM.Nome_TP_MODAL							[Modal Name],			
			H.cd_tp_ocor								[Occurence Type Code],
			TOC.Nome_Tp_Ocor							[Occurence Type Name],	
			H.Mensagem									[Message],
			H.Ativo										[Enable],
			H.Cd_Usuario								[User Code],
			US.Nome_Usuario								[User Name],
			H.Disp_Cliente								[Available],
			H.Dt_Ins									[Insert Date]
 	from 
		historico_auto				H	With(nolock)
		left Join Tipo_Tarefas		TT	With(nolock) on H.Id_Task		= TT.ID_Task and H.Modal = TT.Modal  --and H.Cd_Pes_Grupo = TT.Cd_Pes_Grupo 
		Join Pessoa					P	With(nolock) on H.Cd_Pes_Grupo	= P.Cd_Pes
		Join Tipo_Modal_Imp_Exp		TM	With(nolock) on H.Modal			= TM.CD_TP_MODAL
		Left Join Tipo_Ocorrencia	TOC With(nolock) on H.cd_tp_ocor	= TOC.cd_tp_ocor
		Left Join Usuario			US	With(nolock) on H.Cd_Usuario	= US.Cd_Usuario

GO
