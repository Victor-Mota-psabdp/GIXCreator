SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spBuscaMARec_Sel] --'MB2011042768'
		@Num_Lcto	Varchar(12)

as

if upper(Left(@Num_Lcto,1))<>'M'
	Begin
			select 
				REC.num_lcto_mov Number,dbo.valor(Vlr_doc_mov,dc_mov) [Value]
			from 
				rec_Cta_Cte REC
				Join Mvto_Cta_Cte MV on MV.num_lcto_mov=REC.num_lcto_Mov
			where
				num_lcto_rec=@Num_Lcto

			union

			select 
				REC.num_lcto_mov,dbo.valor(Vlr_doc_mov,dc_mov) Valor 
			from 
				rec_Cta_Cte REC
				Join Mvto_Cta_Cte MV on MV.num_lcto_mov=REC.num_lcto_Mov

				where 
					REC.num_lcto_mov in
					(select num_lcto_mov from rec_Cta_Cte
					where
						num_lcto_rec=@Num_Lcto
					)
			union

			select 
				REC.num_lcto_mov,dbo.valor(Vlr_doc_mov,dc_mov) Valor 
			from 
				rec_Cta_cte REC
				Join Mvto_Cta_Cte MV on MV.num_lcto_mov=REC.num_lcto_Mov
			Where	
				num_lcto_rec
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
				REC.num_lcto_mov,dbo.valor(Vlr_doc_mov,dc_mov) Valor 
			from 
				rec_Cta_Cte REC
				Join Mvto_Cta_Cte MV on MV.num_lcto_mov=REC.num_lcto_Mov
			where
				REC.num_lcto_mov=@Num_Lcto

			union

			select 
				REC.num_lcto_mov,dbo.valor(Vlr_doc_mov,dc_mov) Valor 
			from 
				rec_Cta_Cte REC
				Join Mvto_Cta_Cte MV on MV.num_lcto_mov=REC.num_lcto_Mov

				where 
					REC.num_lcto_rec in
					(select num_lcto_rec from rec_Cta_Cte
					where
						num_lcto_mov=@Num_Lcto
					)
			union

			select 
				REC.num_lcto_mov,dbo.valor(Vlr_doc_mov,dc_mov) Valor 
			from 
				rec_Cta_cte REC
				Join Mvto_Cta_Cte MV on MV.num_lcto_mov=REC.num_lcto_Mov
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
