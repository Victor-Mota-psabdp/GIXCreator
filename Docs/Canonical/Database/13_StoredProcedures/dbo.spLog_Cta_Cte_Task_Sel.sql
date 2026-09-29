SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spLog_Cta_Cte_Task_Sel '','CE','N'
--SP_HELP Log_Cta_Cte_Task
Create PROCEDURE [dbo].[spLog_Cta_Cte_Task_Sel]
(
	@ID		bigint,		
	@Start_Date		Datetime,
	@End_Date		Datetime,
	@Tp_Oper		varchar(1),
	@Cd_Usuario		varchar(6),
	@Tipo			char(1)
)
AS

select * from Tipo_Log_Oper

if @Tipo = 'A' 
	BEGIN
		Select 
			cct.ID_Log				[Log ID],
			cct.Dt_Alter				[Log Date],
			cct.Tp_Oper				[Log Type Code],
			ALT.Nome_Tp_Log_Oper	[Log Type Name],

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
			ps.cd_pes            [CdPessoa], 
			cct.Ativo            [Status]
		from Log_Cta_Cte_Task cct  with(nolock)
		left join Tipo_Log_Oper			Alt		with(nolock) on Alt.Cd_tp_Log_Oper	= cct.Tp_Oper
		left join Tipo_DC tdc with(nolock) on tdc.Cd_Tp_DC = cct.Cd_Tp_DC
		left join Tipo_Modal_Imp_Exp tmi with(nolock)on tmi.CD_TP_MODAL = cct.cd_tp_modal   
		left join Tipo_Taxa tt with(nolock) on tt.Cd_Tp_Tx = cct.Cd_Tp_Tx
		left join Tipo_Tarefas ttf with(nolock) on ttf.ID_Task =cct.Id_Task  and ttf.Modal =tmi.CD_TP_MODAL 
			and (ttf.Cd_Pes_Grupo = cct.Cd_Pes_Grupo or ttf.Cd_Pes_Grupo = '10017')
		left join BDP_Produto bp    on bp.ID_PD = cct.Id_Pd
		left join Grupo       gr    on gr.Cd_Pes_Grupo = cct.Cd_Pes_Grupo
		left join Pessoa      ps    on ps.Cd_Pes = cct.Cd_Pes_Grupo
		left join Usuario     us    on us.Cd_Usuario = cct.Cd_Usuario
		Where
			cct.ID = @ID
		order by 
			CCT.ID	
	END

if @Tipo = 'B' 
	BEGIN
		Select 
			cct.ID_Log				[Log ID],
			cct.Dt_Alter				[Log Date],
			cct.Tp_Oper				[Log Type Code],
			ALT.Nome_Tp_Log_Oper	[Log Type Name],

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
			ps.cd_pes            [CdPessoa], 
			cct.Ativo            [Status]
		from Log_Cta_Cte_Task cct  with(nolock)
		left join Tipo_Log_Oper			Alt		with(nolock) on Alt.Cd_tp_Log_Oper	= cct.Tp_Oper
		left join Tipo_DC tdc with(nolock) on tdc.Cd_Tp_DC = cct.Cd_Tp_DC
		left join Tipo_Modal_Imp_Exp tmi with(nolock)on tmi.CD_TP_MODAL = cct.cd_tp_modal   
		left join Tipo_Taxa tt with(nolock) on tt.Cd_Tp_Tx = cct.Cd_Tp_Tx
		left join Tipo_Tarefas ttf with(nolock) on ttf.ID_Task =cct.Id_Task  and ttf.Modal =tmi.CD_TP_MODAL 
			and (ttf.Cd_Pes_Grupo = cct.Cd_Pes_Grupo or ttf.Cd_Pes_Grupo = '10017')
		left join BDP_Produto bp    on bp.ID_PD = cct.Id_Pd
		left join Grupo       gr    on gr.Cd_Pes_Grupo = cct.Cd_Pes_Grupo
		left join Pessoa      ps    on ps.Cd_Pes = cct.Cd_Pes_Grupo
		left join Usuario     us    on us.Cd_Usuario = cct.Cd_Usuario
		Where
			cct.Dt_Alter between @Start_Date and @End_Date
		order by 
			CCT.ID	
	END

if @Tipo = 'C' 
	BEGIN
		Select 
			cct.ID_Log				[Log ID],
			cct.Dt_Alter				[Log Date],
			cct.Tp_Oper				[Log Type Code],
			ALT.Nome_Tp_Log_Oper	[Log Type Name],

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
			ps.cd_pes            [CdPessoa], 
			cct.Ativo            [Status]
		from Log_Cta_Cte_Task cct  with(nolock)
		left join Tipo_Log_Oper			Alt		with(nolock) on Alt.Cd_tp_Log_Oper	= cct.Tp_Oper
		left join Tipo_DC tdc with(nolock) on tdc.Cd_Tp_DC = cct.Cd_Tp_DC
		left join Tipo_Modal_Imp_Exp tmi with(nolock)on tmi.CD_TP_MODAL = cct.cd_tp_modal   
		left join Tipo_Taxa tt with(nolock) on tt.Cd_Tp_Tx = cct.Cd_Tp_Tx
		left join Tipo_Tarefas ttf with(nolock) on ttf.ID_Task =cct.Id_Task  and ttf.Modal =tmi.CD_TP_MODAL 
			and (ttf.Cd_Pes_Grupo = cct.Cd_Pes_Grupo or ttf.Cd_Pes_Grupo = '10017')
		left join BDP_Produto bp    on bp.ID_PD = cct.Id_Pd
		left join Grupo       gr    on gr.Cd_Pes_Grupo = cct.Cd_Pes_Grupo
		left join Pessoa      ps    on ps.Cd_Pes = cct.Cd_Pes_Grupo
		left join Usuario     us    on us.Cd_Usuario = cct.Cd_Usuario
		Where
			cct.Dt_Alter between @Start_Date and @End_Date
			and cct.Tp_Oper = @Tp_Oper
		order by 
			cct.ID
	END

if @Tipo = 'D' 
	BEGIN
		Select 
			cct.ID_Log				[Log ID],
			cct.Dt_Alter				[Log Date],
			cct.Tp_Oper				[Log Type Code],
			ALT.Nome_Tp_Log_Oper	[Log Type Name],

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
			ps.cd_pes            [CdPessoa], 
			cct.Ativo            [Status]
		from Log_Cta_Cte_Task cct  with(nolock)
		left join Tipo_Log_Oper			Alt		with(nolock) on Alt.Cd_tp_Log_Oper	= cct.Tp_Oper
		left join Tipo_DC tdc with(nolock) on tdc.Cd_Tp_DC = cct.Cd_Tp_DC
		left join Tipo_Modal_Imp_Exp tmi with(nolock)on tmi.CD_TP_MODAL = cct.cd_tp_modal   
		left join Tipo_Taxa tt with(nolock) on tt.Cd_Tp_Tx = cct.Cd_Tp_Tx
		left join Tipo_Tarefas ttf with(nolock) on ttf.ID_Task =cct.Id_Task  and ttf.Modal =tmi.CD_TP_MODAL 
			and (ttf.Cd_Pes_Grupo = cct.Cd_Pes_Grupo or ttf.Cd_Pes_Grupo = '10017')
		left join BDP_Produto bp    on bp.ID_PD = cct.Id_Pd
		left join Grupo       gr    on gr.Cd_Pes_Grupo = cct.Cd_Pes_Grupo
		left join Pessoa      ps    on ps.Cd_Pes = cct.Cd_Pes_Grupo
		left join Usuario     us    on us.Cd_Usuario = cct.Cd_Usuario
		Where
			cct.Cd_Usuario = @Cd_Usuario
		order by 
			cct.ID
		

	END




GO
