SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure spBuscaTodasRec_Sel-- 'MB2011042768'
		@Num_Lcto	Varchar(12)

as

if upper(Left(@Num_Lcto,1))<>'M'
	Begin
			select 
				REC.num_lcto_rec Number,Num_Lcto_Mov
			from 
				rec_Cta_Cte REC
				Join vwPgtos_Sel PG on PG.num_lcto_rec=REC.num_lcto_rec
			where
				REC.num_lcto_rec=@Num_Lcto

			union

			select 
				REC.num_lcto_rec Number,Num_Lcto_Mov
			from 
				rec_Cta_Cte REC
				Join vwPgtos_Sel PG on PG.num_lcto_rec=REC.num_lcto_rec

				where 
					REC.num_lcto_mov in
					(select num_lcto_mov from rec_Cta_Cte
					where
						num_lcto_rec=@Num_Lcto
					)
			union

			select 
				REC.num_lcto_rec Number,Num_Lcto_Mov
			from 
				rec_Cta_cte REC
				Join vwPgtos_Sel PG on PG.num_lcto_rec=REC.num_lcto_rec
			Where	
				REC.num_lcto_rec
				in (
					select Num_Lcto_REC from rec_Cta_Cte 
					where num_lcto_mov in
					(select num_lcto_mov from rec_Cta_Cte
						where
						num_lcto_rec=@Num_Lcto
					)
				)

	End
Else
	Begin

			select 
				REC.num_lcto_rec Number,Num_Lcto_Mov
			from 
				rec_Cta_Cte REC
				Join vwPgtos_Sel PG on PG.num_lcto_rec=REC.num_lcto_rec

			where
				REC.num_lcto_mov=@Num_Lcto

			union

			select 
				REC.num_lcto_rec Number,Num_Lcto_Mov 
			from 
				rec_Cta_Cte REC
				Join vwPgtos_Sel PG on PG.num_lcto_rec=REC.num_lcto_rec

				where 
					REC.num_lcto_rec in
					(select num_lcto_mov from rec_Cta_Cte
					where
						num_lcto_mov=@Num_Lcto
					)
			union

			select 
				REC.num_lcto_rec Number,Num_Lcto_Mov
			from 
				rec_Cta_cte REC
				Join vwPgtos_Sel PG on PG.num_lcto_rec=REC.num_lcto_rec
			Where	
				rec.num_lcto_mov
				in (
					select Num_Lcto_mov from rec_Cta_Cte 
					where num_lcto_mov in
					(select num_lcto_rec from rec_Cta_Cte
						where
						num_lcto_mov=@Num_Lcto
					)
				)

	End


GO
