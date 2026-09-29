SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_ReportFinal_Rel]--0, 'Grupo Dow'
	@Ativo				int,
	@Grupo			Varchar(50)
AS

if @Grupo = 'GRUPO ALL' or @Grupo = ''
	set @Grupo = '%'
		
select 
	Num_Proc						[JOB],
	Nome_Taxa						[Nome da Taxa],
	dt_adto							[Data do Adiantamento],
	valor							[Valor],
	Status_Descricao				[Status],
	PP.Nome_Raz_Soc					[Cliente], 
	dbo.fBusca_Tarefa(num_proc,4)	[Desembaraço],
	dbo.fBusca_Tarefa(num_proc,35)	[Recebimento de Faturamento],
	dt_devol						[Data Devolução],
	(case when encerrado = 0 then 'Não'	else 'Sim' end)				[Ativo],
	isnull(RPS_NFE,NotA_Fiscal)		[Nota Fiscal],
	saldo							[Saldo],
	obs_adto						[Observação]
from ADM_Adiantamentos with(nolock)
	Join LLP_Imp_mar L with(nolock) on num_proc_lim=num_Proc
	LEft Join Tipo_Status_Processo T with(nolock) on T.id_status=L.id_status
	Join House_Imp_mar hou with(nolock) on hou.num_proc_him=num_proC_lim
	Join Pessoa PP with(nolock) on pp.cd_pes=cd_consig_him
	Left Join vwcta_cte cta with(nolock) on cta.num_proc_hia=num_proc_him and cta.cd_tp_Tx='SRV' and dc_hia='C' 
	Left Join BAse_Nota_Fiscal Nf with(nolock) on nf.notA_fiscal=num_nf_hia and ref_acesso=ref_Acesso_nf_hia 
	Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_HIM
	join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
	join pessoa	PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
where 
	encerrado=@Ativo
	and (PG.Apelido like @Grupo or @Grupo ='CHB')


union all

select Num_Proc,Nome_Taxa,dt_adto,valor,Status_Descricao,PP.Nome_Raz_Soc, 
	dbo.fBusca_Tarefa(num_proc,4),dbo.fBusca_Tarefa(num_proc,35),dt_devol,
	(case when encerrado = 0 then 'Não'	else 'Sim' end)				[Ativo],
	isnull(RPS_NFE,NotA_Fiscal),saldo ,
	obs_adto						[Observação]
from ADM_Adiantamentos with(nolock)
	Join LLP_Imp_aer L with(nolock) on num_proc_lia=num_Proc
	LEft Join Tipo_Status_Processo T with(nolock) on T.id_status=L.id_status
	Join House_Imp_aer hou with(nolock) on hou.num_proc_hia=num_proC_lia
	Join Pessoa PP with(nolock) on pp.cd_pes=cd_consig_hia
	Left Join vwcta_cte cta with(nolock) on cta.num_proc_hia=num_proc and cta.cd_tp_Tx='SRV' and dc_hia='C' 
	Left Join BAse_Nota_Fiscal Nf with(nolock) on nf.notA_fiscal=num_nf_hia and ref_acesso=ref_Acesso_nf_hia 
	Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_HIA
	join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
	join pessoa	PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
where 
	encerrado=@Ativo
	and (PG.Apelido like @Grupo or @Grupo ='CHB')


Union all

select Num_Proc,Nome_Taxa,dt_adto,valor,Status_Descricao,PP.Nome_raz_Soc,
	dbo.fBusca_Tarefa(num_proc,4),dbo.fBusca_Tarefa(num_proc,35),dt_devol,
	(case when encerrado = 0 then 'Não'	else 'Sim' end)				[Ativo],
	isnull(RPS_NFE,NotA_Fiscal),saldo,
	obs_adto						[Observação] 
from ADM_Adiantamentos with(nolock)
	Join LLP_Imp_out L with(nolock) on num_proc_lio=num_Proc
	LEft Join Tipo_Status_Processo T with(nolock) on T.id_status=L.id_status
	Join House_Imp_out hou on hou.num_proc_hio=num_proC_lio
	Join Pessoa PP with(nolock) on pp.cd_pes=cd_consig_hio
	Left Join vwcta_cte cta with(nolock) on cta.num_proc_hia=num_proc and cta.cd_tp_Tx='SRV' and dc_hia='C' 
	Left Join BAse_Nota_Fiscal Nf with(nolock) on nf.notA_fiscal=num_nf_hia and ref_acesso=ref_Acesso_nf_hia
	Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_HIO
	join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
	join pessoa	PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo 
where 
	encerrado=@Ativo
	and (PG.Apelido like @Grupo or @Grupo ='CHB')


Union all

select Num_Proc,Nome_Taxa,dt_adto,valor,Status_Descricao,PP.Nome_Raz_Soc, 
	dbo.fBusca_Tarefa(num_proc,4),dbo.fBusca_Tarefa(num_proc,35),dt_devol,
	(case when encerrado = 0 then 'Não'	else 'Sim' end)				[Ativo],
	isnull(RPS_NFE,NotA_Fiscal),saldo ,
	obs_adto						[Observação]
from ADM_Adiantamentos with(nolock)
	Join LLP_exp_out L with(nolock) on num_proc_leo=num_Proc
	LEft Join Tipo_Status_Processo T with(nolock) on T.id_status=L.id_status
	Join House_exp_out hou with(nolock) on hou.num_proc_heo=num_proC_leo
	Join Pessoa PP with(nolock) on pp.cd_pes=cd_export_heo
	Left Join vwcta_cte cta with(nolock) on cta.num_proc_hia=num_proc and cta.cd_tp_Tx='SRV' and dc_hia='C' 
	Left Join BAse_Nota_Fiscal Nf with(nolock) on nf.notA_fiscal=num_nf_hia and ref_acesso=ref_Acesso_nf_hia 
	Join Pessoa_LLP PLL   with(nolock) on PLL.Cd_Pes=HOU.Cd_Export_HEO
	join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
	join pessoa	PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo 
where 
	encerrado=@Ativo
	and (PG.Apelido like @Grupo or @Grupo ='CHB')

Union all


select 
	Num_Proc,Nome_Taxa,dt_adto,valor,Status_Descricao,PP.Nome_raz_Soc, 
	dbo.fBusca_Tarefa(num_proc,4),dbo.fBusca_Tarefa(num_proc,35),dt_devol,
	(case when encerrado = 0 then 'Não'	else 'Sim' end)				[Ativo],
	isnull(RPS_NFE,NotA_Fiscal),saldo,
	obs_adto						[Observação] 
from ADM_Adiantamentos with(nolock)
	Join LLP_exp_aer L with(nolock) on num_proc_lea=num_Proc
	LEft Join Tipo_Status_Processo T with(nolock) on T.id_status=L.id_status
	Join House_exp_aer hou with(nolock) on hou.num_proc_hea=num_proC_lea
	Join Pessoa PP with(nolock) on pp.cd_pes=cd_export_hea
	Left Join vwcta_cte cta with(nolock) on cta.num_proc_hia=num_proc and cta.cd_tp_Tx='SRV' and dc_hia='C' 
	Left Join BAse_Nota_Fiscal Nf with(nolock) on nf.notA_fiscal=num_nf_hia and ref_acesso=ref_Acesso_nf_hia 
	Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Export_HEA
	join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
	join pessoa	PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo 
where 
	encerrado=@Ativo
	and (PG.Apelido like @Grupo or @Grupo ='CHB')
	
Union all


select 
	Num_Proc,Nome_Taxa,dt_adto,valor,Status_Descricao,PP.Nome_raz_Soc, 
	dbo.fBusca_Tarefa(num_proc,4),dbo.fBusca_Tarefa(num_proc,35),dt_devol,
	(case when encerrado = 0 then 'Não'	else 'Sim' end)				[Ativo],
	isnull(RPS_NFE,NotA_Fiscal),saldo,
	obs_adto						[Observação] 
from ADM_Adiantamentos with(nolock)
	Join LLP_exp_mar L with(nolock) on num_proc_lem=num_Proc
	LEft Join Tipo_Status_Processo T with(nolock) on T.id_status=L.id_status
	Join House_exp_mar hou with(nolock) on hou.num_proc_hem=num_proC_lem
	Join Pessoa PP with(nolock) on pp.cd_pes=cd_export_hem
	Left Join vwcta_cte cta with(nolock) on cta.num_proc_hia=num_proc and cta.cd_tp_Tx='SRV' and dc_hia='C' 
	Left Join BAse_Nota_Fiscal Nf with(nolock) on nf.notA_fiscal=num_nf_hia and ref_acesso=ref_Acesso_nf_hia
	Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Export_HEM
	join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
	join pessoa	PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo 
where 
	encerrado=@Ativo
	and (PG.Apelido like @Grupo or @Grupo ='CHB')

--BO
Union all

select 
	Num_Proc,Nome_Taxa,dt_adto,valor,Status_Descricao,PP.Nome_raz_Soc, 
	dbo.fBusca_Tarefa(num_proc,4),dbo.fBusca_Tarefa(num_proc,35),dt_devol,
	(case when encerrado = 0 then 'Não'	else 'Sim' end)				[Ativo],
	isnull(RPS_NFE,NotA_Fiscal),saldo,
	obs_adto						[Observação] 
from ADM_Adiantamentos
	Join LLP_BDP_OUT L with(nolock) on Num_Proc_LBO=num_Proc
	LEft Join Tipo_Status_Processo T with(nolock) on T.id_status=L.id_status
	Join House_BDP_OUT hou with(nolock) on hou.Num_Proc_HBO=Num_Proc_LBO
	Join Pessoa PP with(nolock) on pp.cd_pes=hou.cd_cliente_hbo
	Left Join vwcta_cte cta with(nolock) on cta.num_proc_hia=num_proc and cta.cd_tp_Tx='SRV' and dc_hia='C' 
	Left Join BAse_Nota_Fiscal Nf with(nolock) on nf.notA_fiscal=num_nf_hia and ref_acesso=ref_Acesso_nf_hia
	Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.cd_cliente_hbo
	join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
	join pessoa	PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo 
where 
	encerrado=0
	and (PG.Apelido like @Grupo or @Grupo ='CHB')
	
OPTION (HASH JOIN)
GO
