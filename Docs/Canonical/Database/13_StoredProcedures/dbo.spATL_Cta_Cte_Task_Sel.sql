SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O  /// Busca pelo Nome - Ativos
Z  /// Verifica Nome X Codigo
*/

--[spATL_Cta_Cte_Task_Sel] null,null,null,null,null,null,null,'A'
CREATE procedure [dbo].[spATL_Cta_Cte_Task_Sel]
(
    @ID  int, 
	@CD_TP_MODAL  varchar(2),
	@Cd_Tp_Tx     varchar(3),      
	@ID_Task      int,
	@Cd_Pes_Grupo varchar(20), 
	@Cd_Tp_DC     varchar(1),
	@ID_PD        int,   
	@Tipo varchar(1)
)
as
if @Tipo = 'A'
Begin 
	Select distinct
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
	from Cta_Cte_Task cct  with(nolock)
	left join Tipo_DC tdc with(nolock) on tdc.Cd_Tp_DC = cct.Cd_Tp_DC
	left join Tipo_Modal_Imp_Exp tmi with(nolock)on tmi.CD_TP_MODAL = cct.cd_tp_modal   
	left join Tipo_Taxa tt with(nolock) on tt.Cd_Tp_Tx = cct.Cd_Tp_Tx
	left join Tipo_Tarefas ttf with(nolock) on ttf.ID_Task =cct.Id_Task  and ttf.Modal =tmi.CD_TP_MODAL 
		and (ttf.Cd_Pes_Grupo = cct.Cd_Pes_Grupo or ttf.Cd_Pes_Grupo = '10017')
	left join BDP_Produto bp    on bp.ID_PD = cct.Id_Pd
	left join Grupo       gr    on gr.Cd_Pes_Grupo = cct.Cd_Pes_Grupo
	left join Pessoa      ps    on ps.Cd_Pes = cct.Cd_Pes_Grupo
	left join Usuario     us    on us.Cd_Usuario = cct.Cd_Usuario
    
End
if @Tipo = 'B'
Begin 
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
		ps.cd_pes            [CdPessoa], 
		cct.Ativo            [Status]
	from Cta_Cte_Task cct  with(nolock)
	left join Tipo_DC tdc with(nolock) on tdc.Cd_Tp_DC = cct.Cd_Tp_DC
	left join Tipo_Modal_Imp_Exp tmi with(nolock)on tmi.CD_TP_MODAL = cct.cd_tp_modal   
	left join Tipo_Taxa tt with(nolock) on tt.Cd_Tp_Tx = cct.Cd_Tp_Tx
	left join Tipo_Tarefas ttf with(nolock) on ttf.ID_Task =cct.Id_Task  and ttf.Modal =tmi.CD_TP_MODAL 
		and (ttf.Cd_Pes_Grupo = cct.Cd_Pes_Grupo or ttf.Cd_Pes_Grupo = '10017')
	left join BDP_Produto bp    on bp.ID_PD = cct.Id_Pd
	left join Grupo       gr    on gr.Cd_Pes_Grupo = cct.Cd_Pes_Grupo
	left join Pessoa      ps    on ps.Cd_Pes = cct.Cd_Pes_Grupo
	left join Usuario     us    on us.Cd_Usuario = cct.Cd_Usuario
    where cct.ativo =1 
End
if @Tipo = 'C'
Begin 
	Select 
	ID_Task       	 
	from  Cta_Cte_Task  with(nolock)
	where ID_Task      = @Id_Task
	and   CD_TP_MODAL  = @CD_TP_MODAL
	and   Cd_Tp_Tx     = @Cd_Tp_Tx
	and   Cd_Tp_DC     = @Cd_Tp_DC
	and   Cd_Pes_Grupo = @Cd_Pes_Grupo
	and   Id_Pd        = @ID_PD
end 
if @Tipo = 'D'
Begin 
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
		ps.cd_pes            [CdPessoa], 
		cct.Ativo            [Status]
	from Cta_Cte_Task cct  with(nolock)
	left join Tipo_DC tdc with(nolock) on tdc.Cd_Tp_DC = cct.Cd_Tp_DC
	left join Tipo_Modal_Imp_Exp tmi with(nolock)on tmi.CD_TP_MODAL = cct.cd_tp_modal   
	left join Tipo_Taxa tt with(nolock) on tt.Cd_Tp_Tx = cct.Cd_Tp_Tx
	left join Tipo_Tarefas ttf with(nolock) on ttf.ID_Task =cct.Id_Task  and ttf.Modal =tmi.CD_TP_MODAL 
		and (ttf.Cd_Pes_Grupo = cct.Cd_Pes_Grupo or ttf.Cd_Pes_Grupo = '10017')
	left join BDP_Produto bp    on bp.ID_PD = cct.Id_Pd
	left join Grupo       gr    on gr.Cd_Pes_Grupo = cct.Cd_Pes_Grupo
	left join Pessoa      ps    on ps.Cd_Pes = cct.Cd_Pes_Grupo
	left join Usuario     us    on us.Cd_Usuario = cct.Cd_Usuario
	where ID = @ID
    and  cct.ativo =1 
End

GO
