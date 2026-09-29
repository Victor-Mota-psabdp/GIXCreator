SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure spAFRMMEnviaCustoProcesso_Sel

AS


insert into custo_processo
select cc.num_proc, cc.cd_tp_tx, sum(vlr_item_custo),getdate() from custo_cliente CC
Left Join Custo_Processo CP on CC.num_proc=CP.num_proc and CC.cd_tp_tx=CP.cd_tp_Tx
where cp.cd_tp_tx is null and cc.cd_tp_tx in ('AFR','XAM','XAD',
'SIS','TXS'
)
group  by cc.num_proc, cc.cd_tp_tx



GO
