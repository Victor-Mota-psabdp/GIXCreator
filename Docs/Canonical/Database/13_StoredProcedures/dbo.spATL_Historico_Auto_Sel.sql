SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--select * from Historico_Auto where Id_Hist_Auto = 39 
--select * from Tipo_Tarefas where id_Task = 108 and cd_pes_grupo = '10CAR'
--select * from Tipo_Ocorrencia where cd_tp_ocor = '44'
--[spATL_Historico_Auto_Sel]108,'10PAC','IM','P'

--OLd [dbo].[spHistoricoAutoALL_Sel]
 --[dbo].[spHistoricoAuto_Sel] 'GRUPO AKZO PACKAGING','Recebimento de Danfe','IM'
CREATE procedure [dbo].[spATL_Historico_Auto_Sel]
(
	@ID_Task		int,
	@cd_pes_grupo	varchar(10),	
	@Modal			char(2),
	@Tipo			char(1)
)
as
	
if @Tipo = 'A'  or @Tipo = 'B'
	Begin
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
		
		End
	
if @Tipo = 'C'  or @Tipo = 'D'
	Begin
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
		where 
			H.Id_Task=@ID_Task
	End

if @Tipo = 'N'  or @Tipo = 'O'
	Begin
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
		where 
			H.Cd_Pes_Grupo=@cd_pes_grupo
			and H.Id_Task=@ID_Task			
	End

	
if @Tipo = 'P'  or @Tipo = 'Q'
	Begin
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
		where 
			H.Cd_Pes_Grupo=@cd_pes_grupo
			and H.Id_Task=@ID_Task
			and H.Modal=@Modal
	End
GO
