SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Left Join Pessoa_ATL_AX AX on 
--(cd_tp_ativ <> 'AGT' and AX.Cd_Pes = PP.Cd_Pes or cd_tp_Ativ='AGT' 
--and left(ax.cd_pes,len(ax.cd_pes)-1)=PP.cd_pes) and Tipo='C'
--
--select * from Pessoa_ATL_AX

CREATE Procedure [dbo].[spATL_ADMAdiantamento_SEL]--'2013-07-26'
	@Data datetime
	
AS

select 
	PG.apelido Customer,
	num_proc [BDP Ref.],
	max(dt_adto) [Received Dt],
	sum(Valor) [Adv Value],
	dbo.fBuscaSaldoCaixaSemServicos_Sel(num_proc) [Balance in the Job],
	AX.cd_ax		[cd_ax]
from 
	adm_adiantamentos A
	Join Grupo GRP on GRP.grupo=substring(num_proc,3,3)
	Join Pessoa PG on pg.cd_pes=cd_pes_grupo
	join vwcta_cte W on W.num_proc_hia = A.num_proc and W.cd_tp_tx = A.cd_tp_tx
	join Pessoa PP on W.cd_cred_dev_hia = PP.cd_pes
	Left Join Pessoa_ATL_AX AX on (PP.cd_tp_ativ <> 'AGT' and AX.Cd_Pes = PP.Cd_Pes or PP.cd_tp_Ativ='AGT' and left(ax.cd_pes,len(ax.cd_pes)-1)=PP.cd_pes) and AX.Tipo='C'
where encerrado=0 and dt_adto <= @Data
and substring(num_proc,3,3) not in ('ATL','SUR','DEC','CLI','CAR')
and dbo.fBuscaSaldoCaixaSemServicos_Sel(num_proc) > 1
group by PG.apelido,num_proc,AX.cd_ax



GO
