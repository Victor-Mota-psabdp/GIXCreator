SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spDespesasCHB_Rel]
	 @DataInicial Varchar(10),
	@DataFinal	Varchar(10)
as

select dbo.fBusca_TipoDocCliente('N',num_proc_him,3) ,dbo.fBusca_TipoDocCliente('N',num_proc_him,1) PO_Number,num_proc_him,nome_tp_Tx,vlr_pgto_rcto_hia,dt_conclusao from house_imp_mar
Join vwcxas cxa on cxa.num_proc_hia=num_proc_him and left(cxa.cd_tp_Tx,1)='X' and dc_hia='D'
Join Tarefas_processos TP on TP.num_proc=num_proc_hia and id_task=4
Join Tipo_Taxa TT on TT.cd_tp_tx=cxa.cd_tp_Tx
where
	SUBSTRING(num_proc,3,3)in ('GVD','GVA')   
	and dt_conclusao between @DataInicial and @DataFinal
	and nome_tp_tx not like 'Adiant%'
	and cxa.cd_tp_tx <> 'XCA'
union 


select dbo.fBusca_TipoDocCliente('N',num_proc_him,3) ,dbo.fBusca_TipoDocCliente('N',num_proc_him,1) PO_Number,num_proc_him,nome_tp_Tx,vlr_org_hia,dt_conclusao from house_imp_mar
Join vwcta_cte CTA on cta.num_proc_hia=num_proc_him and cd_cred_dev_hia=cd_consig_him and cta.dc_hia='C'
Left Join vwcxas cxa on cxa.num_proc_hia=cta.num_proc_hia and cxa.cd_tp_tx=cta.cd_tp_Tx and cxa.dc_hia='C'

Join Tarefas_processos TP on TP.num_proc=num_proc_him and id_task=4
Join Tipo_Taxa TT on TT.cd_tp_tx=cta.cd_tp_Tx
where
SUBSTRING(num_proc,3,3)in ('GVD','GVA') and  
	 dt_conclusao between @DataInicial and @DataFinal
	and nome_tp_tx not like 'Adiant%'
	and cta.cd_tp_tx <> 'XCA'

GO
