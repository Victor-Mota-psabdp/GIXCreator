SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spMAProcura_Sel] 
	@num_lcto_mov varchar(12), 	
	@num_cta_cte varchar(20),
	@dc_mov char(1),
	@dt_pgto_rcto_mov varchar(30),	
	@Historico varchar(300),
	@vlr_doc_mov varchar(50)

as	

IF @dt_pgto_rcto_mov = '0' and @vlr_doc_mov = '0'
			Begin
				select num_lcto_mov, CC.titular titular,dc_mov, dt_pgto_Rcto_mov , vlr_doc_mov , historico, concil_mov from mvto_cta_cte MCC
					left join cta_cte CC on CC.Num_cta_cte=MCC.num_cta_cte
				where
					MCC.concil_mov  = 'N' and
					MCC.num_lcto_mov like @num_lcto_mov and	
					MCC.num_cta_cte like @num_cta_cte and
					MCC.dc_mov like @dc_mov and
					convert(datetime,MCC.dt_pgto_rcto_mov,103) > '01/01/2007' and
					MCC.Historico like @Historico 

			End		
Else if @dt_pgto_rcto_mov = '0' and @vlr_doc_mov <> '0'
			Begin			
				select num_lcto_mov, CC.titular titular,dc_mov, dt_pgto_Rcto_mov , vlr_doc_mov , historico, concil_mov from mvto_cta_cte MCC
					left join cta_cte CC on CC.Num_cta_cte=MCC.num_cta_cte
				where
					MCC.concil_mov  = 'N' and
					MCC.num_lcto_mov like @num_lcto_mov and	
					MCC.num_cta_cte like @num_cta_cte and
					MCC.dc_mov like @dc_mov and
					convert(datetime,MCC.dt_pgto_rcto_mov,103) > '01/01/2007' and
					MCC.Historico like @Historico and
					MCC.vlr_doc_mov = replace(@vlr_doc_mov,',','.')
			End

 Else IF @dt_pgto_rcto_mov <> '0' and @vlr_doc_mov = '0'
			Begin	
				select num_lcto_mov, CC.titular titular,dc_mov, dt_pgto_Rcto_mov , vlr_doc_mov , historico, concil_mov from mvto_cta_cte MCC
					left join cta_cte CC on CC.Num_cta_cte=MCC.num_cta_cte
				where	
					MCC.concil_mov  = 'N' and
					MCC.num_lcto_mov like @num_lcto_mov and	
					MCC.num_cta_cte like @num_cta_cte and
					MCC.dc_mov like @dc_mov and
					convert(datetime,MCC.dt_pgto_rcto_mov,103) > '01/01/2007' and
					convert(datetime,MCC.dt_pgto_rcto_mov,103) between convert(datetime,left(@dt_pgto_rcto_mov,10),103) and convert(datetime,right(@dt_pgto_rcto_mov,10),103) and	
					MCC.Historico like @Historico										
			End
Else if @dt_pgto_rcto_mov <> '0' and @vlr_doc_mov <> '0'
			Begin
				select num_lcto_mov, CC.titular titular,dc_mov, dt_pgto_Rcto_mov , vlr_doc_mov , historico, concil_mov from mvto_cta_cte MCC
					left join cta_cte CC on CC.Num_cta_cte=MCC.num_cta_cte
				where	
					MCC.concil_mov  = 'N' and
					MCC.num_lcto_mov like @num_lcto_mov and	
					MCC.num_cta_cte like @num_cta_cte and
					MCC.dc_mov like @dc_mov and
					convert(datetime,MCC.dt_pgto_rcto_mov,103) between convert(datetime,left(@dt_pgto_rcto_mov,10),103) and convert(datetime,right(@dt_pgto_rcto_mov,10),103) and	
					convert(datetime,MCC.dt_pgto_rcto_mov,103) > '01/01/2007' and
					MCC.Historico like @Historico and
					MCC.vlr_doc_mov = replace(@vlr_doc_mov,',','.')									
			End

--
--	if @@Error <> 0
--			Begin
--				Rollback Transaction
--				Return -1
--			End
--Commit Transaction



GO
