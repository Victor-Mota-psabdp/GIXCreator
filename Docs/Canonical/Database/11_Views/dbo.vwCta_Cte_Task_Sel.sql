SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwCta_Cte_Task_Sel]  
AS  
Select 
		cct.ID               [ID],	       	 
		cct.Cd_Tp_Tx         [Tax Code],	 
		tt.Nome_Tp_Tx        [Tax Name],
		cct.Cd_Tp_DC         [DC Code],
		tdc.Descricao_TP_DC  [Dc Description],
		cct.Id_Task          [Task Code],
		ttf.Nome_Task	     [Task Description],
		cct.Cd_Tp_Modal      [Modal Code] ,	 
        tmi.Nome_TP_MODAL    [Modal Description],			
		cct.Cd_Pes_Grupo     [Group Code],
		ps.Apelido           [Group Name],
		cct.Id_Pd            [Bdp Product Code],
		bp.Nome_BDP_Produto  [Bdp Product Name],
		cct.Cd_Usuario       [User Code],	 
		us.Nome_Usuario      [User Name] ,
		cct.Dt_Ins           [Insert Date],	 	     	      
		cct.Ativo            [Status]
	from Cta_Cte_Task cct  with(nolock)
		left join Tipo_DC tdc with(nolock) 	on tdc.Cd_Tp_DC = cct.Cd_Tp_DC
		left join Tipo_Modal_Imp_Exp tmi with(nolock) on tmi.CD_TP_MODAL = cct.cd_tp_modal   
		left join Tipo_Taxa tt with(nolock) on tt.Cd_Tp_Tx = cct.Cd_Tp_Tx
		left join Tipo_Tarefas ttf with(nolock) on ttf.ID_Task =cct.Id_Task and ttf.Cd_Pes_Grupo = cct.Cd_Pes_Grupo and ttf.Modal =tmi.CD_TP_MODAL
		left join BDP_Produto bp    on bp.ID_PD = cct.Id_Pd
		left join Grupo       gr    on gr.Cd_Pes_Grupo = cct.Cd_Pes_Grupo
		left join Pessoa      ps    on ps.Cd_Pes = cct.Cd_Pes_Grupo
		left join Usuario     us    on us.Cd_Usuario = cct.Cd_Usuario



GO
