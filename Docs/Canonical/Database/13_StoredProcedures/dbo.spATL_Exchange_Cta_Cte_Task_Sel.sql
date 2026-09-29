SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spATL_Exchange_Cta_Cte_Task_Sel 'A'
create  procedure [dbo].[spATL_Exchange_Cta_Cte_Task_Sel] 
(	
	@Tipo		   char(1)
)
as
	
/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codgo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
S e L para Solicitacao de LI
*/

IF @Tipo = 'A' or @Tipo = 'B' or @Tipo = 'C' or @Tipo = 'D' or @Tipo = 'N' OR @Tipo = 'O'
BEGIN
	select   	
		EXC.Num_Proc				    				[JOB],
		CTA.Cd_Pes_Grupo                                [Cd_Pes_Grupo] ,  
		TP.ID_Task										[ID_Task],	
		ttf.nome_task                                   [Task Name],
		CTA.Cd_Tp_Tx                                    [Cd_Tp_Tx],
		ttx.Nome_Tp_Tx                                  [Tx Name], 
		CTA.Cd_Tp_Modal                                 [Cd_Tp_Modal],
		CTA.ID_PD                                       [ID_PD],
		CTA.Cd_Tp_DC                                    [Cd_Tp_DC],

		EXC.DC,
		CTA.ID
from Exchange_Cta_Cte		EXC	with(nolock)
	join Cta_Cte_Task		CTA	with(nolock)  on EXC.Cd_Tp_Tx  = CTA.Cd_Tp_Tx  and (EXC.DC = CTA.Cd_Tp_DC or CTA.Cd_Tp_DC ='B') and CTA.Cd_Tp_Modal = left(EXC.Num_Proc,2)
	join Campo_Processo   	CP143 with(nolock)on CP143.Campo_Dados = CTA.Id_Pd and CP143.Num_Proc = EXC.Num_Proc and CP143.Id_Campo = 143
	join Tipo_Taxa	 		ttx	with(nolock)  on ttx.Cd_Tp_Tx = CTA.Cd_Tp_Tx	
	join vwCliente  		HOU	with(nolock) on HOU.Num_Proc = EXC.Num_Proc

	join Tarefas_Processos	TP	with(nolock)  on TP.Num_Proc = EXC.Num_Proc	and TP.ID_Task = CTA.Id_Task
	join Tipo_Tarefas		TTF	with(nolock)  on TTF.ID_Task = CTA.Id_Task and TTF.Modal = CTA.Cd_Tp_Modal and TTF.Ativo = 'S'
	
	join Pessoa_LLP	LLP	with(nolock) on LLP.cd_pes = HOU.cd_cliente and (LLP.Cd_Pes_Grupo = CTA.Cd_Pes_Grupo or CTA.Cd_Pes_Grupo = TTF.Cd_Pes_Grupo)
		
where 
	--EXC.num_proc= 'IMCSR202109003BR' and
	CTA.Ativo = 1	
	and EXC.Dt_Ins >= GETDATE() - 1
	and tp.Dt_Conclusao is null
END

GO
