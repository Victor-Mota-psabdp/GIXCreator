SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--incluido dia 13/03/2012 - chamado: 19074 a taxa: Perda-Prejuizo - PRJ
--[spATL_Divergencia_Operacional]'Grupo ALL','2012-01-01', '2015-06-30'
--incluida a view do vwclienteHouse, pra deixar o report igual do spATL_Divergencia_Operacional - 2/9/2015- CADU
CREATE PROCEDURE  [dbo].[spATL_Divergencia_Operacional]
	@Grupo varchar(30),
	@DtInicial datetime,
	@DtFinal datetime
				
AS
		
	declare @cd_pes_grupo varchar(10)
	declare @NomeGrupo as varchar(30)

Select	
	PG.Apelido								[Grupo],
	cxa.Num_Proc_HIA						[BDP Ref.],
	Nome_Tp_Tx								[BDP Charges],
	Vlr_Pgto_Rcto_HIA						[Valor],
	convert(Datetime,Dt_Pgto_Rcto_HIA,105)	[Período]
From
	vwcta_cte CTA with(nolock)
	--caixa_hou_imp_mar CXA	
	--Join cta_cte_hou_imp_mar CTA on cta.num_proc_him=cxa.num_proc_him and cta.cd_tp_tx=cxa.cd_tp_Tx and cta.dc_him=cxa.dc_him
	Join Tipo_Taxa TT	with(nolock) on TT.cd_tp_Tx = CTA.Cd_Tp_Tx
	Join vwCXAS CXA		with(nolock) on CTA.Num_Proc_HIA = CXA.Num_Proc_HIA and cta.cd_tp_tx=cxa.cd_tp_Tx and CTA.DC_HIA = CXA.DC_HIA
	--join vwCliente vw	with(nolock) on CXA.Num_Proc_HIA = vw.num_proc
	join vwCliente_House vw	with(nolock) on CXA.Num_Proc_HIA = vw.num_proc
	Join Pessoa_LLP PLL with(nolock) on PLL.Cd_Pes=vw.cd_cliente --and PLL.Cd_Pes_Grupo=G.Cd_Pes_Grupo
	join Grupo G		with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
	join pessoa	PG		with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
Where	
	convert(Datetime,Dt_Pgto_Rcto_HIA,105)  between @DTinicial and @DTfinal and
	(PG.Apelido = @Grupo or @Grupo = 'GRUPO ALL')
	and len(CTA.num_proc_hia) = '16' and
	cxa.cd_tp_tx in ('XMI','XMH','XYT','XYY','XYU','XYV','XYX','XYZ','PRJ','FDG','200','201','202','203')
	 
	 Order BY Grupo

--select * from Tipo_Taxa
--where Nome_Tp_Tx like 'Diverg%'

--select * from Tipo_Taxa
--where cd_tp_tx in ('XMI','XMH','XYT','XYY','XYU','XYV','XYX','XYZ','PRJ','FDG','200','201','202','203')
--UNION ALL

--Select	
--	@NomeGrupo								[Grupo],
--	cxa.num_proc_hia						[BDP Ref.],
--	Nome_Tp_Tx								[Bdp Charges],
--	Vlr_Pgto_Rcto_Hia						[Valor],
--	convert(Datetime,dt_pgto_rcto_hia,105)	[Período]
--From
--	caixa_hou_imp_aer CXA	
--	Join cta_cte_hou_imp_aer CTA on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_Tx and cta.dc_hia=cxa.dc_hia
--	Join Tipo_Taxa TT on TT.cd_tp_Tx=cxa.cd_tp_Tx
--Where
--	convert(Datetime,dt_pgto_rcto_hia,105)  between @DTinicial and @DTfinal and
--	right(left(cxa.num_proc_hia,5),3) = @grupo and
--	 cxa.cd_tp_tx in ('XMI','XMH','XYT','XYY','XYU','XYV','XYX','XYZ','PRJ')

--UNION ALL

--Select	
--	@NomeGrupo								[Grupo],
--	cxa.num_proc_hio						[BDP Ref.],
--	Nome_Tp_Tx								[Bdp Charges],
--	Vlr_Pgto_Rcto_Hio						[Valor],
--	convert(Datetime,dt_pgto_rcto_hio,105)	[Período]
--From
--	caixa_hou_imp_out CXA	
--	Join cta_cte_hou_imp_out CTA on cta.num_proc_hio=cxa.num_proc_hio and cta.cd_tp_tx=cxa.cd_tp_Tx and cta.dc_hio=cxa.dc_hio
--	Join Tipo_Taxa TT on TT.cd_tp_Tx=cxa.cd_tp_Tx
--Where
--	convert(Datetime,dt_pgto_rcto_hio,105)  between @DTinicial and @DTfinal and
--	right(left(cxa.num_proc_hio,5),3) = @grupo and
--	 cxa.cd_tp_tx in ('XMI','XMH','XYT','XYY','XYU','XYV','XYX','XYZ','PRJ')

----Exportação

--UNION ALL

--Select	
--	@NomeGrupo								[Grupo],
--	cxa.num_proc_hem						[BDP Ref.],
--	Nome_Tp_Tx								[Bdp Charges],
--	Vlr_Pgto_Rcto_Hem						[Valor],
--	convert(Datetime,dt_pgto_rcto_hem,105)	[Período]
--From
--	caixa_hou_exp_mar CXA	
--	Join cta_cte_hou_exp_mar CTA on cta.num_proc_hem=cxa.num_proc_hem and cta.cd_tp_tx=cxa.cd_tp_Tx and cta.dc_hem=cxa.dc_hem
--	Join Tipo_Taxa TT on TT.cd_tp_Tx=cxa.cd_tp_Tx
--Where
--	convert(Datetime,dt_pgto_rcto_hem,105)  between @DTinicial and @DTfinal and
--	right(left(cxa.num_proc_hem,5),3) = @grupo and
--	 cxa.cd_tp_tx in ('XMI','XMH','XYT','XYY','XYU','XYV','XYX','XYZ','PRJ')

--UNION ALL

--Select	
--	@NomeGrupo								[Grupo],
--	cxa.num_proc_hea						[BDP Ref.],
--	Nome_Tp_Tx								[Bdp Charges],
--	Vlr_Pgto_Rcto_Hea						[Valor],
--	convert(Datetime,dt_pgto_rcto_hea,105)	[Período]
--From
--	caixa_hou_exp_aer CXA	
--	Join cta_cte_hou_exp_aer CTA on cta.num_proc_hea=cxa.num_proc_hea and cta.cd_tp_tx=cxa.cd_tp_Tx and cta.dc_hea=cxa.dc_hea
--	Join Tipo_Taxa TT on TT.cd_tp_Tx=cxa.cd_tp_Tx
--Where
--	convert(Datetime,dt_pgto_rcto_hea,105)  between @DTinicial and @DTfinal and
--	right(left(cxa.num_proc_hea,5),3) = @grupo and
--	 cxa.cd_tp_tx in ('XMI','XMH','XYT','XYY','XYU','XYV','XYX','XYZ','PRJ')

--UNION ALL

--Select	
--	@NomeGrupo								[Grupo],
--	cxa.num_proc_heo						[BDP Ref.],
--	Nome_Tp_Tx								[Bdp Charges],
--	Vlr_Pgto_Rcto_Heo						[Valor],
--	convert(Datetime,dt_pgto_rcto_heo,105)	[Período]
--From
--	caixa_hou_exp_out CXA	
--	Join cta_cte_hou_exp_out CTA on cta.num_proc_heo=cxa.num_proc_heo and cta.cd_tp_tx=cxa.cd_tp_Tx and cta.dc_heo=cxa.dc_heo
--	Join Tipo_Taxa TT on TT.cd_tp_Tx=cxa.cd_tp_Tx
--Where
--	convert(Datetime,dt_pgto_rcto_heo,105)  between @DTinicial and @DTfinal and
--	right(left(cxa.num_proc_heo,5),3) = @grupo and
--	 cxa.cd_tp_tx in ('XMI','XMH','XYT','XYY','XYU','XYV','XYX','XYZ','PRJ')



GO
