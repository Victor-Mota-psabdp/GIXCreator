SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[spNum_Lcto_Mov_Sel] 
	@num_lcto_mov varchar(12)
as

select dc_mov, dt_pgto_Rcto_mov , CC.titular titular, vlr_doc_mov ,concil_mov, historico from mvto_cta_cte MCC
	left join cta_cte CC on CC.Num_cta_cte=MCC.num_cta_cte
where
	mcc.num_lcto_mov=@num_lcto_mov

GO
