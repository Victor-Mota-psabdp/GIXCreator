SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--mudanças do T4 por solicitação da Daniele Soares
--incluido novamente a coluna [Debito em Conta Realizado] dia 4-6-12
CREATE procedure [dbo].[spATL_CTACTE_SUN_Rel]--'Grupo Sun Chemical','2011-08-01','2011-08-30' 
	@Grupo varchar(20),
	@DtInicial datetime,
	@DtFinal datetime
as

	declare @cd_pes_grupo varchar(10)
	Set @cd_pes_grupo = (select top 1 Cd_Pes from pessoa where apelido=@Grupo)

	set @grupo = (select grupo from grupo where cd_pes_grupo = @cd_pes_grupo)
	
select 
	HOU.num_proc_him																	[JOB],
	dbo.fbusca_docs_po_modal(HOU.num_proc_him,1)										[PO Number],	
	[dbo].[fBusca_CaixaTaxaVlr](Hou.num_proc_him,'Adiantamento Cliente% - CHB%','C')	[Valor Adiantamento Recebidos],
	(SELECT [dbo].[fBusca_CtaCteTaxaVlr](Hou.num_proc_him,'Adiantamento Cliente% - CHB%','C') - [dbo].[fBusca_CaixaTaxaVlr](Hou.num_proc_him,'Adiantamento Cliente% - CHB%','C'))	[Valor Adiantamento Pendentes],
	[dbo].[FBusca_ADTOTX1](Hou.num_proc_him,'ICMS% - CHB%','C')							[ICMS Previsto],
	((select sum(Valor*Paridade) from adiantamento_cliente_det With(nolock) where id in (select id from adiantamento_cliente With(nolock) where num_proc = Hou.num_proc_him) and conta = 'C')  - [dbo].[FBusca_ADTOTX1](Hou.num_proc_him,'ICMS% - CHB%','C'))[Debito em conta Previsto],

	(select max(data_po_him) from po_him With(nolock)  where id_dc = 5 and num_proc_him = HOU.num_proc_him) [Data da DI],	
	[dbo].[fBusca_Caixa_Data](Hou.num_proc_him,'Adiantamento Cliente% - CHB%','C')		[Data Recebimento de Numerário],
	[dbo].[fBusca_CtaCteTaxaVlr](Hou.num_proc_him,'%CHB%','D')							[Despesas Realizadas],
	([dbo].[fBusca_Custo_Processo](Hou.num_proc_him,'%CHB%')	- [dbo].[fBusca_Custo_Processo](Hou.num_proc_him,'ICMS% - CHB%'))[Debito em Conta Realizado],
	[dbo].[fBusca_Custo_Processo](Hou.num_proc_him,'ICMS% - CHB%')						[ICMS Realizado],
	(([dbo].[fBusca_CaixaTaxaVlr](Hou.num_proc_him,'Adiantamento Cliente% - CHB%','C') - [dbo].[fBusca_CtaCteTaxaVlr](Hou.num_proc_him,'%CHB%','D'))) Saldo,
	[dbo].[fBusca_Caixa_Data](Hou.num_proc_him,'Presta%','C')							[Data Acerto do Saldo]
from House_imp_mar HOU		With(nolock)	
	join llp_imp_mar LLP	With(nolock) on llp.num_proc_lim = hou.num_proc_him	
Where	
	substring(num_proc_lim,3,3) = @grupo 
	and atd_lim  between @DtInicial and @DtFinal
	and isnull(id_status,0) <> 9	

UNION ALL

select 
	HOU.num_proc_hia																	[JOB],
	dbo.fbusca_docs_po_modal(HOU.num_proc_hia,1)										[PO Number],
	[dbo].[fBusca_CaixaTaxaVlr](Hou.num_proc_hia,'Adiantamento Cliente% - CHB%','C')	[Valor Adiantamento Recebidos],
	([dbo].[fBusca_CtaCteTaxaVlr](Hou.num_proc_hia,'Adiantamento Cliente% - CHB%','C') - [dbo].[fBusca_CaixaTaxaVlr](Hou.num_proc_hia,'Adiantamento Cliente% - CHB%','C'))	[Valor Adiantamento Pendentes],

	[dbo].[FBusca_ADTOTX1](Hou.num_proc_hia,'ICMS% - CHB%','C')							[ICMS Previsto],
	((select sum(Valor*Paridade) from adiantamento_cliente_det With(nolock) where id in (select id from adiantamento_cliente With(nolock) where num_proc = Hou.num_proc_hia) and conta = 'C') - [dbo].[FBusca_ADTOTX1](Hou.num_proc_hia,'ICMS% - CHB%','C'))[Debito em conta Previsto],

	(select max(data_po_hia) from po_hia With(nolock)  where id_dc = 5 and num_proc_hia = HOU.num_proc_hia) [Data da DI],
	[dbo].[fBusca_Caixa_Data](Hou.num_proc_hia,'Adiantamento Cliente% - CHB%','C')		[Data Recebimento de Numerário],
	[dbo].[fBusca_CtaCteTaxaVlr](Hou.num_proc_hia,'%CHB%','D')							[Despesas Realizadas],
	([dbo].[fBusca_Custo_Processo](Hou.num_proc_hia,'%CHB%') - [dbo].[fBusca_Custo_Processo](Hou.num_proc_hia,'ICMS% - CHB%'))[Debito em Conta Realizado],
	[dbo].[fBusca_Custo_Processo](Hou.num_proc_hia,'ICMS% - CHB%')						[ICMS Realizado],
	(([dbo].[fBusca_CaixaTaxaVlr](Hou.num_proc_hia,'Adiantamento Cliente% - CHB%','C') - [dbo].[fBusca_CtaCteTaxaVlr](Hou.num_proc_hia,'%CHB%','D'))) Saldo,
	[dbo].[fBusca_Caixa_Data](Hou.num_proc_hia,'Presta%','C')							[Data Acerto do Saldo]
from House_imp_aer HOU		With(nolock)	
	join llp_imp_aer LLP	With(nolock) on llp.num_proc_lia = hou.num_proc_hia
Where 
	substring(num_proc_lia,3,3) = @grupo 
	and atd_lia between @DtInicial and @DtFinal	
	and isnull(id_status,0) <> 9

UNION ALL

	select 
	HOU.num_proc_hio																	[JOB],
	dbo.fbusca_docs_po_modal(HOU.num_proc_hio,1)										[PO Number],
	[dbo].[fBusca_CaixaTaxaVlr](Hou.num_proc_hio,'Adiantamento Cliente% - CHB%','C')	[Valor Adiantamento Recebidos],
	([dbo].[fBusca_CtaCteTaxaVlr](Hou.num_proc_hio,'Adiantamento Cliente% - CHB%','C') - [dbo].[fBusca_CaixaTaxaVlr](Hou.num_proc_hio,'Adiantamento Cliente% - CHB%','C'))	[Valor Adiantamento Pendentes],

	[dbo].[FBusca_ADTOTX1](Hou.num_proc_hio,'ICMS% - CHB%','C')							[ICMS Previsto],
	((select sum(Valor*Paridade) from adiantamento_cliente_det With(nolock) where id in (select id from adiantamento_cliente With(nolock) where num_proc = Hou.num_proc_hio) and conta = 'C') - [dbo].[FBusca_ADTOTX1](Hou.num_proc_hio,'ICMS% - CHB%','C'))[Debito em conta Previsto],


	(select max(data_po_hio) from po_hio With(nolock) where id_dc = 5 and num_proc_hio = HOU.num_proc_hio) [Data da DI],
	[dbo].[fBusca_Caixa_Data](Hou.num_proc_hio,'Adiantamento Cliente% - CHB%','C')		[Data Recebimento de Numerário],
	[dbo].[fBusca_CtaCteTaxaVlr](Hou.num_proc_hio,'%CHB%','D')							[Despesas Realizadas],
	([dbo].[fBusca_Custo_Processo](Hou.num_proc_hio,'%CHB%')-[dbo].[fBusca_Custo_Processo](Hou.num_proc_hio,'ICMS% - CHB%'))[Debito em Conta Realizado],
	[dbo].[fBusca_Custo_Processo](Hou.num_proc_hio,'ICMS% - CHB%')						[ICMS Realizado],
	(([dbo].[fBusca_CaixaTaxaVlr](Hou.num_proc_hio,'Adiantamento Cliente% - CHB%','C') - [dbo].[fBusca_CtaCteTaxaVlr](Hou.num_proc_hio,'%CHB%','D'))) Saldo,
	[dbo].[fBusca_Caixa_Data](Hou.num_proc_hio,'Presta%','C')							[Data Acerto do Saldo]
from House_imp_out HOU		With(nolock)	
	join llp_imp_out LLP	With(nolock) on llp.num_proc_lio = hou.num_proc_hio
Where 
	substring(num_proc_lio,3,3) = @grupo
	and atd_lio between @DtInicial and @DtFinal
	and isnull(id_status,0) <> 9





--------------------------------------------------
--select 
--	HOU.num_proc_him																	[JOB],
----	PO.numero_po_him																	[PO Number],
--	dbo.fbusca_docs_po_modal(HOU.num_proc_him,1)										[PO Number],
--	--[dbo].[fBusca_CtaCteTaxaVlr](Hou.num_proc_him,'Adiantamento Cliente% - CHB%','C')	[Valor Adiantamento],
--	[dbo].[fBusca_CaixaTaxaVlr](Hou.num_proc_him,'Adiantamento Cliente% - CHB%','C')	[Valor Adiantamento Recebidos],
--	([dbo].[fBusca_CtaCteTaxaVlr](Hou.num_proc_him,'Adiantamento Cliente% - CHB%','C') - [dbo].[fBusca_CaixaTaxaVlr](Hou.num_proc_him,'Adiantamento Cliente% - CHB%','C'))	[Valor Adiantamento Pendentes],
--	[dbo].[FBusca_ADTOTX1](Hou.num_proc_him,'ICMS% - CHB%','C')							[ICMS Previsto],
--	(select sum(Valor*Paridade) from adiantamento_cliente_det where id in (select id from adiantamento_cliente where num_proc = Hou.num_proc_him) and conta = 'C') [Debito em conta Previsto],
--
--	(select max(data_po_him) from po_him  where id_dc = 5 and num_proc_him = HOU.num_proc_him) [Data da DI],
--	--DI.Data_Po_him																		[Data da DI],
--	[dbo].[fBusca_Caixa_Data](Hou.num_proc_him,'Adiantamento Cliente% - CHB%','C')		[Data Recebimento de Numerário],
--	[dbo].[fBusca_CtaCteTaxaVlr](Hou.num_proc_him,'%CHB%','D')							[Despesas Realizadas],
--	--[dbo].[fBusca_Custo_Processo](Hou.num_proc_him,'%CHB%')								[Debito em Conta Realizado],
--	[dbo].[fBusca_Custo_Processo](Hou.num_proc_him,'ICMS% - CHB%')						[ICMS Realizado],
--	(([dbo].[fBusca_CaixaTaxaVlr](Hou.num_proc_him,'Adiantamento Cliente% - CHB%','C') - [dbo].[fBusca_CtaCteTaxaVlr](Hou.num_proc_him,'%CHB%','D'))) Saldo,
--	[dbo].[fBusca_Caixa_Data](Hou.num_proc_him,'Presta%','D')							[Data Acerto do Saldo]
--from House_imp_mar HOU With(nolock)	
--	join llp_imp_mar LLP With(nolock) on llp.num_proc_lim = hou.num_proc_him
--	--join PO_HIM PO With(nolock) on PO.num_proc_him = HOU.num_proc_him and PO.id_dc = 1
--	--left join PO_HIM DI With(nolock) on DI.num_proc_him = HOU.num_proc_him and DI.id_dc = 5
--	--Left Join tarefas_processos T4 With(nolock) on T4.num_proc=num_proc_lim and t4.ID_Task=4	
--Where
--	--T4.dt_conclusao is not null and
--	substring(num_proc_lim,3,3) = @grupo 
--	and atd_lim  between @DtInicial and @DtFinal
--	and isnull(id_status,0) <> 9
--	--and T4.dt_conclusao between @DtInicial and @DtFinal
--
--UNION ALL
--
--select 
--	HOU.num_proc_hia																	[JOB],
----	PO.numero_po_hia																	[PO Number],
--	dbo.fbusca_docs_po_modal(HOU.num_proc_hia,1)										[PO Number],
----	[dbo].[fBusca_CtaCteTaxaVlr](Hou.num_proc_hia,'Adiantamento Cliente% - CHB%','C')	[Valor Adiantamento],
--	[dbo].[fBusca_CaixaTaxaVlr](Hou.num_proc_hia,'Adiantamento Cliente% - CHB%','C')	[Valor Adiantamento Recebidos],
--	([dbo].[fBusca_CtaCteTaxaVlr](Hou.num_proc_hia,'Adiantamento Cliente% - CHB%','C') - [dbo].[fBusca_CaixaTaxaVlr](Hou.num_proc_hia,'Adiantamento Cliente% - CHB%','C'))	[Valor Adiantamento Pendentes],
--
--	[dbo].[FBusca_ADTOTX1](Hou.num_proc_hia,'ICMS% - CHB%','C')							[ICMS Previsto],
--	(select sum(Valor*Paridade) from adiantamento_cliente_det where id in (select id from adiantamento_cliente where num_proc = Hou.num_proc_hia) and conta = 'C') [Debito em conta Previsto],
--
--	(select max(data_po_hia) from po_hia  where id_dc = 5 and num_proc_hia = HOU.num_proc_hia) [Data da DI],
--	--DI.Data_Po_hia																		[Data da DI],
--	[dbo].[fBusca_Caixa_Data](Hou.num_proc_hia,'Adiantamento Cliente% - CHB%','C')		[Data Recebimento de Numerário],
--	[dbo].[fBusca_CtaCteTaxaVlr](Hou.num_proc_hia,'%CHB%','D')							[Despesas Realizadas],
--	--[dbo].[fBusca_Custo_Processo](Hou.num_proc_hia,'%CHB%')								[Debito em Conta Realizado],
--	[dbo].[fBusca_Custo_Processo](Hou.num_proc_hia,'ICMS% - CHB%')						[ICMS Realizado],
--	(([dbo].[fBusca_CaixaTaxaVlr](Hou.num_proc_hia,'Adiantamento Cliente% - CHB%','C') - [dbo].[fBusca_CtaCteTaxaVlr](Hou.num_proc_hia,'%CHB%','D'))) Saldo,
--	[dbo].[fBusca_Caixa_Data](Hou.num_proc_hia,'Presta%','D')							[Data Acerto do Saldo]
--from House_imp_aer HOU With(nolock)	
--	join llp_imp_aer LLP With(nolock) on llp.num_proc_lia = hou.num_proc_hia
--	--join PO_HIa PO With(nolock) on PO.num_proc_hia = HOU.num_proc_hia and PO.id_dc = 1
--	--left join PO_HIa DI With(nolock) on DI.num_proc_hia = HOU.num_proc_hia and DI.id_dc = 5	
-- 	--Left Join tarefas_processos T4 With(nolock) on T4.num_proc=num_proc_lia and t4.ID_Task=4	
--Where 
--	--T4.dt_conclusao is not null and 
--	substring(num_proc_lia,3,3) = @grupo 
--	and atd_lia between @DtInicial and @DtFinal	
--	and isnull(id_status,0) <> 9
--	--and T4.dt_conclusao between @DtInicial and @DtFinal
--
--UNION ALL
--
--	select 
--	HOU.num_proc_hio																	[JOB],
----	PO.numero_po_hio																	[PO Number],
--	dbo.fbusca_docs_po_modal(HOU.num_proc_hio,1)										[PO Number],
----	[dbo].[fBusca_CtaCteTaxaVlr](Hou.num_proc_hio,'Adiantamento Cliente% - CHB%','C')	[Valor Adiantamento],
--	[dbo].[fBusca_CaixaTaxaVlr](Hou.num_proc_hio,'Adiantamento Cliente% - CHB%','C')	[Valor Adiantamento Recebidos],
--	([dbo].[fBusca_CtaCteTaxaVlr](Hou.num_proc_hio,'Adiantamento Cliente% - CHB%','C') - [dbo].[fBusca_CaixaTaxaVlr](Hou.num_proc_hio,'Adiantamento Cliente% - CHB%','C'))	[Valor Adiantamento Pendentes],
--
--	[dbo].[FBusca_ADTOTX1](Hou.num_proc_hio,'ICMS% - CHB%','C')							[ICMS Previsto],
--	(select sum(Valor*Paridade) from adiantamento_cliente_det where id in (select id from adiantamento_cliente where num_proc = Hou.num_proc_hio) and conta = 'C') [Debito em conta Previsto],
--
--
--	(select max(data_po_hio) from po_hio  where id_dc = 5 and num_proc_hio = HOU.num_proc_hio) [Data da DI],
--	--DI.Data_Po_hio																		[Data da DI],
--	[dbo].[fBusca_Caixa_Data](Hou.num_proc_hio,'Adiantamento Cliente% - CHB%','C')		[Data Recebimento de Numerário],
--	[dbo].[fBusca_CtaCteTaxaVlr](Hou.num_proc_hio,'%CHB%','D')							[Despesas Realizadas],
--	--[dbo].[fBusca_Custo_Processo](Hou.num_proc_hio,'%CHB%')								[Debito em Conta Realizado],
--	[dbo].[fBusca_Custo_Processo](Hou.num_proc_hio,'ICMS% - CHB%')						[ICMS Realizado],
--	(([dbo].[fBusca_CaixaTaxaVlr](Hou.num_proc_hio,'Adiantamento Cliente% - CHB%','C') - [dbo].[fBusca_CtaCteTaxaVlr](Hou.num_proc_hio,'%CHB%','D'))) Saldo,
--	[dbo].[fBusca_Caixa_Data](Hou.num_proc_hio,'Presta%','D')							[Data Acerto do Saldo]
--from House_imp_out HOU With(nolock)	
--	join llp_imp_out LLP With(nolock) on llp.num_proc_lio = hou.num_proc_hio
--	--join PO_HIo PO With(nolock) on PO.num_proc_hio = HOU.num_proc_hio and PO.id_dc = 1
--	--left join PO_HIo DI With(nolock) on DI.num_proc_hio = HOU.num_proc_hio and DI.id_dc = 5	
--	--Left Join tarefas_processos T4 With(nolock) on T4.num_proc=num_proc_lio and t4.ID_Task=4	
--Where 
--	--T4.dt_conclusao is not null	and 
--	substring(num_proc_lio,3,3) = @grupo
--	and atd_lio between @DtInicial and @DtFinal
--	and isnull(id_status,0) <> 9	
--	--and T4.dt_conclusao between @DtInicial and @DtFinal
--
--

GO
