SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_LAMAConciliacao_Rel]--'2013-06-01','2013-06-28'
	
	@DtInicial datetime,
	@DtFinal datetime
 
as

	select
		MV.num_lcto_mov			[MA/MB], 
		MV.DC_MOV				[D/C - MA/MB], 
		MV.vlr_doc_mov			[Valor MA/MB], 
		PG.NUM_LCTO				[DA/LA], 
		PG.Dt_Pgto_Rcto			[Data],
		PP.Apelido				[Empresa],
		PG.DC					[D/C],
		DBO.VALOR(VLR_DOC,DC)	[Valor],
		PG.num_cta_cte			[C/C]
	From rec_cta_cte R
		Join Mvto_Cta_cte MV on R.num_lcto_mov=MV.num_lcto_mov
		Join Pgto_rcto PG on PG.num_lcto=num_lcto_rec
		Join Pessoa PP on pp.cd_pes=Pg.cd_pes
	where
		convert(Datetime,dt_pgto_rcto_mov,105) between @DtInicial and @DtFinal
		
	union all

		select
			MV.num_lcto_mov			[MA/MB], 
			MV.DC_MOV				[D/C - MA/MB], 
			MV.vlr_doc_mov			[Valor MA/MB], 
			PG.NUM_LCTO_div			[DA/LA], 
			PG.Dt_Pgto_Rcto_div		[Data],
			PP.Apelido				[Empresa],
			PG.DC_div				[D/C],
			DBO.VALOR(VLR_DOC_div,DC_div)[Valor],
			PG.num_cta_cte			[C/C]
		From rec_cta_cte R
			Join Mvto_Cta_cte MV on R.num_lcto_mov=MV.num_lcto_mov
			Join Pgto_rcto_div PG on PG.num_lcto_div=num_lcto_rec
			Join Pessoa PP on pp.cd_pes=Pg.cd_pes
		where
		convert(Datetime,dt_pgto_rcto_mov,105) between @DtInicial and @DtFinal

	UNION ALL

		select
			MV.num_lcto_mov			[MA/MB], 
			MV.DC_MOV				[D/C - MA/MB], 
			MV.vlr_doc_mov			[Valor MA/MB], 
			PG.NUM_Ref_Ra			[DA/LA/RA/RM], 
			PG.Dt_Oper_Ra			[Data],
			PP.Apelido				[Empresa],
			(case when VLR_TOT_FCHTO_RA <=0 then 'C' else 'D' end)[D/C],
			PG.VLR_TOT_RA *-1		[Valor],
			PG.num_cta_cte			[C/C]
		From rec_cta_cte R
			Join Mvto_Cta_cte MV on R.num_lcto_mov=MV.num_lcto_mov
			Join REMESSA_AER PG on PG.NUM_Ref_Ra=num_lcto_rec
			Join Pessoa PP on pp.cd_pes=Pg.cd_pes
	where
		convert(Datetime,dt_pgto_rcto_mov,105) between @DtInicial and @DtFinal

	UNION ALL

		select
			MV.num_lcto_mov			[MA/MB], 
			MV.DC_MOV				[D/C - MA/MB], 
			MV.vlr_doc_mov			[Valor MA/MB], 
			PG.NUM_Ref_RM			[DA/LA/RA/RM], 
			PG.Dt_Oper_RM			[Data],
			PP.Apelido				[Empresa],
			(case when VLR_TOT_FCHTO_RM <=0 then 'C' else 'D' end)[D/C],
			PG.VLR_TOT_RM *-1		[Valor],
			PG.num_cta_cte			[C/C]
		From rec_cta_cte R
			Join Mvto_Cta_cte MV on R.num_lcto_mov=MV.num_lcto_mov
			Join REMESSA_MAR PG on PG.NUM_Ref_RM=num_lcto_rec
			Join Pessoa PP on pp.cd_pes=Pg.cd_pes
		where
		convert(Datetime,dt_pgto_rcto_mov,105) between @DtInicial and @DtFinal


order by 1


GO
