SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[vwRPS_Pendente]

AS

select distinct FV.FatCOD FatCodRPS from dbo.vwFaturasValidas FV
Join dbo.vwFaturasValidasArg FVA on FV.num_proc=FVA.num_proc and FV.cd_tp_tx=FVA.cd_tp_tx and FV.dc=FVA.dc
Join fatura_arg FA on FA.id_fat=FVA.id_fat
Join base_notA_fiscal NF on right('000000000'+NF.nota_fiscal,10)=right('00000000'+FA.numero,10) and ref_acesso=codigo
where
	cd_status <>'2' and NF.ref_acesso in ('A','I','J','K','C')
	and RPS_NFE is null

union all
--cadu included 2026-04-08
select distinct FV.FatCOD FatCodRPS from dbo.vwNF_Fatura_ALL FV
Join dbo.vwFaturasValidasArg FVA on FV.num_proc=FVA.num_proc and FV.cd_tp_tx=FVA.cd_tp_tx and FV.dc=FVA.dc
Join fatura_arg FA on FA.id_fat=FVA.id_fat
Join base_notA_fiscal NF on right('000000000'+NF.nota_fiscal,10)=right('00000000'+FA.numero,10) and NF.ref_acesso=FA.codigo
where
	cd_status <>'2' and ref_acesso in ('A','I','J','K','C')
	and RPS_NFE is null





GO
