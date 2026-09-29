SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure spLogCtaCteByJOB
@JOB varchar(16)
AS
select num_proc_cc,
	(select nome_usuario from usuario where cd_usuario = L.cd_usuario) Usuario, 
	data_cc [Data Lacto.],
	( case when tp_oper_cc = 'I' then 'Inclusão' when tp_oper_cc = 'E' then'Exclusão' when tp_oper_cc = 'A' then 'Alteração' end ) [Ação], 
	(select nome_tp_tx from tipo_taxa where cd_tp_tx = L.cd_tp_tx) Taxa, 
	dt_prev_pgto, 
	vlr_org Valor
 from 
	log_cta_cte L where num_proc_cc like @JOB
order by
	data_cc
GO
