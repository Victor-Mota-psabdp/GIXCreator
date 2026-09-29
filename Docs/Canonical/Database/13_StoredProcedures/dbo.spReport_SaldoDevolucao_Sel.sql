SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[spReport_SaldoDevolucao_Sel] --[spReport_SaldoDevolucao_Sel]'GRUPO UPL DO BRASIL','2017-01-01','2017-02-20'

	@Grupo varchar(30),
	@DtInicial datetime,
	@DtFinal datetime	
		
AS

select
CTA.Num_Proc_HIA [JOB],
dbo.fBusca_Docs_PO_Modal(CTA.Num_Proc_HIA,9)[SAP],
TT.Nome_Tp_Tx [Nome Taxa],
CTA.Vlr_Org_HIA [Valor],
(Case when CTA.DC_HIA = 'D' then 'Saldo a Devolver' Else 'Saldo a Receber' end) [DC],
TP40.Dt_Conclusao [Envio da Prestaçao de Contas],
CXA.Dt_Pgto_Rcto	[Data da Baixa],
''[Audit.]
from vwHouse_Imp HOU with(nolock)
Left Outer Join Pessoa_LLP PLL	with(nolock) on HOU.Cd_Consig = PLL.Cd_Pes
Left Outer Join Grupo G			with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
Left Outer Join pessoa	PG		with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
Join vwcta_Cte CTA	with(nolock) on HOU.Num_Proc = CTA.Num_Proc_HIA
Join Tipo_Taxa TT	with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
Left Outer Join Caixa_AX CXA	with(nolock) on CTA.Num_Proc_HIA = CXA.Num_Proc and CTA.Cd_Tp_Tx = CXA.Cd_Tp_Tx and CXA.Cd_Tp_Tx in ('XCA','XZD','XCQ','XEQ','XEU','XFS','XFU','XFV','XGA','XGB','XXV','XZK')
left Join Tarefas_Processos TP40 with(nolock) on CTA.Num_Proc_HIA = TP40.Num_Proc and TP40.Id_task = 40
where 
		--HOU.Num_Proc = 'IMUPL201701007BR' and
		convert(Datetime,HOU.dt_emis,105)  between @DtInicial and @DtFinal 
		and (PG.Apelido = @Grupo or @Grupo = 'GRUPO ALL')
		and CTA.Cd_Tp_Tx in ('XCA','XZD','XCQ','XEQ','XEU','XFS','XFU','XFV','XGA','XGB','XXV','XZK')
GO
