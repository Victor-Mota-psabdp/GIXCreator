SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--incluido dia 13/03/2012 - chamado: 19074 a taxa: Perda-Prejuizo - PRJ
--incluida a view do vwcliente, pra deixar o report igual do spATL_Divergencia_Operacional

CREATE PROCEDURE  [dbo].[spATL_Divergencia_Operacional_Sintetico]--'2008-01-01', '2012-12-31'	
	@DtInicial datetime,
	@DtFinal datetime
				
AS

Select	
	(select apelido from pessoa P join grupo G on G.cd_pes_grupo = P.cd_pes	where grupo = right(left(CTA.num_proc_hia,5),3)) [Grupo],
	CTA.num_proc_hia,
	CXA.Vlr_Pgto_Rcto_HIa [Valor]	
From
	vwcta_cte CTA with(nolock)
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx = CTA.Cd_Tp_Tx
	Join vwCXAS CXA	  with(nolock) on CTA.Num_Proc_HIA = CXA.Num_Proc_HIA and cta.cd_tp_tx=cxa.cd_tp_Tx and CTA.DC_HIA = CXA.DC_HIA
	join vwCliente_House vw	with(nolock) on CXA.Num_Proc_HIA = vw.num_proc
Where
	convert(Datetime,CXA.Dt_Pgto_Rcto_HIa,105)  between @DTinicial and @DTfinal 
	and len(CTA.num_proc_hia) = '16'
	and	cxa.cd_tp_tx in ('XMI','XMH','XYT','XYY','XYU','XYV','XYX','XYZ','PRJ','FDG','200','201','202','203')
	
	order by 1

--Select	
--	(select apelido from pessoa P join grupo G on G.cd_pes_grupo = P.cd_pes	where grupo = right(left(cxa.num_proc_him,5),3)) [Grupo],
--	cxa.num_proc_him,
--	Vlr_Pgto_Rcto_Him [Valor]	
--From
--	caixa_hou_imp_mar CXA	
--	Join cta_cte_hou_imp_mar CTA on cta.num_proc_him=cxa.num_proc_him and cta.cd_tp_tx=cxa.cd_tp_Tx and cta.dc_him=cxa.dc_him
--	Join Tipo_Taxa TT on TT.cd_tp_Tx=cxa.cd_tp_Tx
--Where
--	convert(Datetime,dt_pgto_rcto_him,105)  between @DTinicial and @DTfinal 
--	and	len(cxa.num_proc_him) = 16	
--	and	cxa.cd_tp_tx in ('XMI','XMH','XYT','XYY','XYU','XYV','XYX','XYZ','PRJ')

--union all

--Select	
--	(select apelido from pessoa P join grupo G on G.cd_pes_grupo = P.cd_pes	where grupo = right(left(cxa.num_proc_hia,5),3)) [Grupo],
--	cxa.num_proc_hia,
--	Vlr_Pgto_Rcto_Hia [Valor]	
--From
--	caixa_hou_imp_aer CXA	
--	Join cta_cte_hou_imp_aer CTA on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_Tx and cta.dc_hia=cxa.dc_hia
--	Join Tipo_Taxa TT on TT.cd_tp_Tx=cxa.cd_tp_Tx
--Where
--	convert(Datetime,dt_pgto_rcto_hia,105)  between @DTinicial and @DTfinal 
--	and	len(cxa.num_proc_hia) = 16 and right(left(cxa.num_proc_hia,5),3)  <> 'VCP'
--	and	cxa.cd_tp_tx in ('XMI','XMH','XYT','XYY','XYU','XYV','XYX','XYZ','PRJ')

--union all

--Select	
--	(select apelido from pessoa P join grupo G on G.cd_pes_grupo = P.cd_pes	where grupo = right(left(cxa.num_proc_hio,5),3)) [Grupo],
--	cxa.num_proc_hio,
--	Vlr_Pgto_Rcto_Hio [Valor]	
--From
--	caixa_hou_imp_out CXA	
--	Join cta_cte_hou_imp_out CTA on cta.num_proc_hio=cxa.num_proc_hio and cta.cd_tp_tx=cxa.cd_tp_Tx and cta.dc_hio=cxa.dc_hio
--	Join Tipo_Taxa TT on TT.cd_tp_Tx=cxa.cd_tp_Tx
--Where
--	convert(Datetime,dt_pgto_rcto_hio,105)  between @DTinicial and @DTfinal 
--	and	len(cxa.num_proc_hio) = 16	
--	and	cxa.cd_tp_tx in ('XMI','XMH','XYT','XYY','XYU','XYV','XYX','XYZ','PRJ')


----Exportaçao

--UNION ALL

--Select	
--	(select apelido from pessoa P join grupo G on G.cd_pes_grupo = P.cd_pes	where grupo = right(left(cxa.num_proc_hem,5),3)) [Grupo],
--	cxa.num_proc_hem,
--	Vlr_Pgto_Rcto_Hem [Valor]	
--From
--	caixa_hou_exp_mar CXA	
--	Join cta_cte_hou_exp_mar CTA on cta.num_proc_hem=cxa.num_proc_hem and cta.cd_tp_tx=cxa.cd_tp_Tx and cta.dc_hem=cxa.dc_hem
--	Join Tipo_Taxa TT on TT.cd_tp_Tx=cxa.cd_tp_Tx
--Where
--	convert(Datetime,dt_pgto_rcto_hem,105)  between @DTinicial and @DTfinal 
--	and	len(cxa.num_proc_hem) = 16	
--	and	cxa.cd_tp_tx in ('XMI','XMH','XYT','XYY','XYU','XYV','XYX','XYZ','PRJ')

--union all

--Select	
--	(select apelido from pessoa P join grupo G on G.cd_pes_grupo = P.cd_pes	where grupo = right(left(cxa.num_proc_hea,5),3)) [Grupo],
--	cxa.num_proc_hea,
--	Vlr_Pgto_Rcto_Hea [Valor]	
--From
--	caixa_hou_exp_aer CXA	
--	Join cta_cte_hou_exp_aer CTA on cta.num_proc_hea=cxa.num_proc_hea and cta.cd_tp_tx=cxa.cd_tp_Tx and cta.dc_hea=cxa.dc_hea
--	Join Tipo_Taxa TT on TT.cd_tp_Tx=cxa.cd_tp_Tx
--Where
--	convert(Datetime,dt_pgto_rcto_hea,105)  between @DTinicial and @DTfinal 
--	and	len(cxa.num_proc_hea) = 16	
--	and	cxa.cd_tp_tx in ('XMI','XMH','XYT','XYY','XYU','XYV','XYX','XYZ','PRJ')

--union all

--Select	
--	(select apelido from pessoa P join grupo G on G.cd_pes_grupo = P.cd_pes	where grupo = right(left(cxa.num_proc_heo,5),3)) [Grupo],
--	cxa.num_proc_heo,
--	Vlr_Pgto_Rcto_Heo [Valor]	
--From
--	caixa_hou_exp_out CXA	
--	Join cta_cte_hou_exp_out CTA on cta.num_proc_heo=cxa.num_proc_heo and cta.cd_tp_tx=cxa.cd_tp_Tx and cta.dc_heo=cxa.dc_heo
--	Join Tipo_Taxa TT on TT.cd_tp_Tx=cxa.cd_tp_Tx
--Where
--	convert(Datetime,dt_pgto_rcto_heo,105)  between @DTinicial and @DTfinal 
--	and	len(cxa.num_proc_heo) = 16	
--	and	cxa.cd_tp_tx in ('XMI','XMH','XYT','XYY','XYU','XYV','XYX','XYZ','PRJ')

--order by 1

--usando view
--Select	
--	(select apelido from pessoa P join grupo G on G.cd_pes_grupo = P.cd_pes	where grupo = right(left(cxa.num_proc_hia,5),3)) [Grupo],
--	cxa.num_proc_hia						[BDP Ref.],
--	Nome_Tp_Tx								[Bdp Charges],
--	Vlr_Pgto_Rcto_Hia						[Valor],
--	convert(Datetime,dt_pgto_rcto_hia,105)	[Período]
--From
--	vwcxas CXA	
--	Join vwcta_Cte CTA on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_Tx and cta.dc_hia=cxa.dc_hia
--	Join Tipo_Taxa TT on TT.cd_tp_Tx=cxa.cd_tp_Tx
--Where
--	convert(Datetime,dt_pgto_rcto_hia,105)  between @DTinicial and @DTfinal and
--	len(cxa.num_proc_hia) = 16
--	and cxa.cd_tp_tx in ('XMI','XMH','XYT','XYY','XYU','XYV','XYX','XYZ')
--
--order by 1
GO
