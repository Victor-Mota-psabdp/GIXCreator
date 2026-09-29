SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spMA_Num_Lcto_Mvto_Sel] 	
	@num_lcto_mov varchar(12)

as	
	if @num_lcto_mov = '0' 
		Begin
			select num_lcto_mov, dc_mov, dt_pgto_Rcto_mov , CC.titular titular, vlr_doc_mov, historico from mvto_cta_cte MCC
			left join cta_cte CC on CC.Num_cta_cte=MCC.num_cta_cte 
			where concil_mov = 'N'
		End
	else
		Begin
			select num_lcto_mov, dc_mov, dt_pgto_Rcto_mov , CC.titular titular, vlr_doc_mov, historico from mvto_cta_cte MCC
			left join cta_cte CC on CC.Num_cta_cte=MCC.num_cta_cte
			where concil_mov = 'N' And num_lcto_mov = @num_lcto_mov
		End



GO
