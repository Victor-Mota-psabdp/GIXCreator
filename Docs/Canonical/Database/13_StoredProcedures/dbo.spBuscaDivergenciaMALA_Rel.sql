SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure spBuscaDivergenciaMALA_Rel

		@DataInicial	Varchar(10),
		@DataFinal		Varchar(10)

AS



select MV.Num_Lcto_Mov, dt_pgto_rcto_mov Data_MA,Num_Lcto Num_LA,dt_pgto_Rcto,dt_vcto from mvto_Cta_Cte MV 
Join Rec_Cta_Cte REC on REC.num_lcto_mov=mv.num_lcto_mov
Join Pgto_Rcto PG on PG.num_lcto=REC.num_lcto_rec
where convert(Datetime,dt_pgto_rcto_mov,105) between @DataInicial and @DataFinal
and (dt_pgto_Rcto_mov <> dt_pgto_Rcto or dt_pgto_Rcto_mov <> dt_vcto)


UNION


select MV.Num_Lcto_Mov, dt_pgto_rcto_mov Data_MA,Num_Lcto_DIV Num_LA,dt_pgto_Rcto_dIV,dt_vcto_DIV from mvto_Cta_Cte MV 
Join Rec_Cta_Cte REC on REC.num_lcto_mov=mv.num_lcto_mov
Join Pgto_Rcto_DIV PG on PG.num_lcto_DIV=REC.num_lcto_rec
where convert(Datetime,dt_pgto_rcto_mov,105) between @DataInicial and @DataFinal
and (dt_pgto_Rcto_mov <> dt_pgto_Rcto_DIV or dt_pgto_Rcto_mov <> dt_vcto_DIV)


UNION

select MV.Num_Lcto_Mov, dt_pgto_rcto_mov Data_MA,Num_Lcto Num_LA,dt_pgto_Rcto,dt_vcto from mvto_Cta_Cte MV 
Join Rec_Cta_Cte REC on REC.num_lcto_mov=mv.num_lcto_mov
Join Pgto_Rcto PG on PG.num_lcto=REC.num_lcto_rec
where convert(Datetime,dt_pgto_rcto,105) between @DataInicial and @DataFinal
and (dt_pgto_Rcto_mov <> dt_pgto_Rcto or dt_pgto_Rcto_mov <> dt_vcto)


UNION


select MV.Num_Lcto_Mov, dt_pgto_rcto_mov Data_MA,Num_Lcto_DIV Num_LA,dt_pgto_Rcto_dIV,dt_vcto_DIV from mvto_Cta_Cte MV 
Join Rec_Cta_Cte REC on REC.num_lcto_mov=mv.num_lcto_mov
Join Pgto_Rcto_DIV PG on PG.num_lcto_DIV=REC.num_lcto_rec
where convert(Datetime,dt_pgto_rcto_DIV,105) between @DataInicial and @DataFinal
and (dt_pgto_Rcto_mov <> dt_pgto_Rcto_DIV or dt_pgto_Rcto_mov <> dt_vcto_DIV)


GO
