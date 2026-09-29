SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spContabilidadeCXAEmitidos_Sel] --'2009-09-01','2009-09-30'

--@DataInicial varchar(10),
--@DataFinal	 varchar(10)

AS
select Concil Conc,
	pg.num_lcto					,
	dt_pgto_Rcto,
	dc,
	dbo.valor(vlr_doc,dc)		Valor,
	nome_cta_ctb,
	sum(dbo.valor(isnull(isnull(vlr_pgto_rcto_hia,0),0),dc_hia))+(dbo.valor(vlr_doc,dc)*-1) Saldo,
	num_lcto_mov

from Pgto_rcto PG  

	left Join vwcxas		CXA on PG.num_lcto=CXA.num_lcto
	Left Join cta_cte		CC on CC.num_cta_cte=pg.num_cta_cte
	Left Join cta_ctb		CB on CB.cd_cta_ctb=cc.cd_cta_ctb
	left Join rec_cta_cte	REC on REC.num_lcto_rec=pg.num_lcto
where
--	convert(datetime,dt_pgto_rcto,105) between '2009-10-01' and '2009-10-30' --@DataInicial and @DataFinal
	convert(datetime,dt_pgto_rcto,105) between getdate() - 30 and getdate()
Group by
	pg.num_lcto,
	vlr_doc,
	dc,
	cxa.Num_Lcto,
	dt_pgto_Rcto,
	nome_cta_ctb,
	Concil,
	num_lcto_mov

UNION
SELECT Concil_div						   Conc,
		pg.num_lcto_div,
		dt_pgto_rcto_div,
		dc_div,
		dbo.valor(vlr_doc_div,dc_div),
		nome_cta_ctb,
		sum(dbo.valor(vlr_item,dc_item))+(dbo.valor(vlr_doc_div,dc_div)*-1) Saldo,
		num_lcto_mov

FROM PGTO_RCTO_DIV PG

		Left jOIN Pgto_rcto_div_det		PD on pg.num_lcto_div=pd.num_lcto_div
		Left Join cta_cte				CC on CC.num_cta_cte=pg.num_cta_cte
		Left Join cta_ctb				CB on CB.cd_cta_ctb=cc.cd_cta_ctb
		left Join rec_cta_cte			REC on REC.num_lcto_rec=pg.num_lcto_div
		
Where
--	convert(datetime,dt_pgto_rcto_div,105) between '2009-10-01' and '2009-10-30' --@DataInicial and @DataFinal
	convert(datetime,dt_pgto_rcto_div,105) between getdate() - 30 and getdate()
Group by
	pg.num_lcto_div,
	dt_pgto_rcto_div,
	vlr_doc_div,
	pd.num_lcto_div,
	dc_div,
	nome_cta_ctb,
	Concil_div,
	num_lcto_mov

union

select concil_ra,Num_ref_Ra,dt_ra,'',vlr_tot_ra,nome_cta_ctb, 
	sum(dbo.valor(isnull(isnull(vlr_pgto_rcto_hia,0),0),dc_hia))+(vlr_tot_ra),null
from remessa_Aer RA
	Left Join vwcxas CXA on CXa.num_rcb_hia=RA.num_ref_ra
	Left Join cta_cte				CC on CC.num_cta_cte=ra.num_cta_cte
	Left Join cta_ctb				CB on CB.cd_cta_ctb=cc.cd_cta_ctb
Where 
--	convert(datetime,dt_ra,105) between '2009-10-01' and '2009-10-30' --@DataInicial and @DataFinal
	convert(datetime,dt_ra,105) between getdate() - 30 and getdate()
Group by 
	num_ref_ra,
	dt_ra,
	vlr_tot_ra,
	nome_cta_ctb,
	concil_ra

UNION

select concil_rM,Num_ref_RM,dt_rM,'',vlr_tot_rM,nome_cta_ctb, 
	sum(dbo.valor(isnull(isnull(vlr_pgto_rcto_hia,0),0),dc_hia))+(vlr_tot_rM),
	null
from remessa_MAR RM
	Left Join vwcxas CXA on CXa.num_rcb_hia=RM.num_ref_rM
	Left Join cta_cte				CC on CC.num_cta_cte=rM.num_cta_cte
	Left Join cta_ctb				CB on CB.cd_cta_ctb=cc.cd_cta_ctb
Where 
--	convert(datetime,dt_rM,105) between '2009-10-01' and '2009-10-30'
	convert(datetime,dt_rm,105) between getdate() - 30 and getdate()
Group by 
	num_ref_rM,
	dt_rM,
	vlr_tot_rM,
	nome_cta_ctb,
	concil_rM

GO
