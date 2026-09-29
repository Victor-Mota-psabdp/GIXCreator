SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE Procedure [dbo].[spLaProcura_Sel] --'%','%','%', '%','%','','70.00'
	@num_lcto varchar(12),
	@num_cta_cte varchar(20),
	@dc char(1),
	@dt_pgto_rcto varchar(30),
	@forma_pgto_rcto varchar(30),
	@apelido varchar (30),
	@vlr_doc varchar(50)	
as

	IF @dt_pgto_rcto = '0' and @vlr_doc = '0'
			Begin
				select num_lcto, CC.titular titular,dc, dt_pgto_Rcto , Forma_pgto_rcto, Num_doc, vlr_doc , P.apelido apelido, dt_vcto from pgto_rcto PR 
					left join cta_cte CC on CC.Num_cta_cte=PR.num_cta_cte
					left join pessoa P on P.cd_pes = PR.cd_pes 
				where
					PR.concil = 'N' and
					PR.num_lcto like @num_lcto and	
					PR.num_cta_cte like @num_cta_cte and
					PR.dc like @dc and					
					PR.forma_pgto_rcto like @forma_pgto_rcto and
					P.apelido like @apelido and
					convert(datetime,PR.dt_pgto_rcto,103) > '01/01/2007'
				UNION
				select PRV.num_lcto_div num_lcto, CC.titular titular,dc_div dc, dt_pgto_Rcto_div dt_pgto_Rcto , Forma_pgto_rcto_div Forma_pgto_rcto, Num_doc_div Num_doc , vlr_doc_div vlr_doc , P.apelido apelido, dt_vcto_div dt_vcto from pgto_rcto_div PRV 
					left join cta_cte CC on CC.Num_cta_cte=PRV.num_cta_cte 
					left join pessoa P on P.cd_pes = PRV.cd_pes
					join pgto_rcto_div_DET Det on det.num_lcto_div = PRV.num_lcto_div
				where
					PRV.concil_div = 'N' and
					PRV.num_lcto_div like @num_lcto and	
					PRV.num_cta_cte like @num_cta_cte and
					PRV.dc_div like @dc and					
					PRV.forma_pgto_rcto_div like @forma_pgto_rcto and
					P.apelido like @apelido	and
					convert(datetime,PRV.dt_pgto_rcto_div,103) > '01/01/2007'				
			End	

	ELSE if @dt_pgto_rcto = '0' and @vlr_doc <> '0'
			Begin
				select num_lcto, CC.titular titular,dc, dt_pgto_Rcto , Forma_pgto_rcto, Num_doc, vlr_doc , P.apelido apelido, dt_vcto from pgto_rcto PR 
					left join cta_cte CC on CC.Num_cta_cte=PR.num_cta_cte
					left join pessoa P on P.cd_pes = PR.cd_pes 					
				where
					PR.concil = 'N' and
					PR.num_lcto like @num_lcto and	
					PR.num_cta_cte like @num_cta_cte and
					PR.dc like @dc and
					PR.vlr_doc = replace(@vlr_doc,',','.') and					
					PR.forma_pgto_rcto like @forma_pgto_rcto and
					P.apelido like @apelido and
					convert(datetime,PR.dt_pgto_rcto,103) > '01/01/2007'
				UNION
				select PRV.num_lcto_div num_lcto, CC.titular titular,dc_div dc, dt_pgto_Rcto_div dt_pgto_Rcto , Forma_pgto_rcto_div Forma_pgto_rcto, Num_doc_div Num_doc , vlr_doc_div vlr_doc , P.apelido apelido, dt_vcto_div dt_vcto from pgto_rcto_div PRV 
					left join cta_cte CC on CC.Num_cta_cte=PRV.num_cta_cte 
					left join pessoa P on P.cd_pes = PRV.cd_pes 
					join pgto_rcto_div_DET Det on det.num_lcto_div = PRV.num_lcto_div
				where
					PRV.concil_div = 'N' and
					PRV.num_lcto_div like @num_lcto and	
					PRV.num_cta_cte like @num_cta_cte and
					PRV.dc_div like @dc and
					PRV.vlr_doc_div = replace(@vlr_doc,',','.') and					
					PRV.forma_pgto_rcto_div like @forma_pgto_rcto and
					P.apelido like @apelido	and			
					convert(datetime,PRV.dt_pgto_rcto_div,103) > '01/01/2007'	
			End	
	ELSE if @dt_pgto_rcto <> '0' and @vlr_doc = '0' 
			Begin
				select num_lcto, CC.titular titular,dc, dt_pgto_Rcto , Forma_pgto_rcto, Num_doc, vlr_doc , P.apelido apelido, dt_vcto from pgto_rcto PR 
					left join cta_cte CC on CC.Num_cta_cte=PR.num_cta_cte
					left join pessoa P on P.cd_pes = PR.cd_pes 
				where
					PR.concil = 'N' and
					PR.num_lcto like @num_lcto and	
					PR.num_cta_cte like @num_cta_cte and
					PR.dc like @dc and					
					convert(datetime,PR.dt_pgto_rcto,103) between convert(datetime,left(@dt_pgto_rcto,10),103) and convert(datetime,right(@dt_pgto_rcto,10),103) and	
					PR.forma_pgto_rcto like @forma_pgto_rcto and
					P.apelido like @apelido and
					convert(datetime,PR.dt_pgto_rcto,103) > '01/01/2007'
				UNION
				select PRV.num_lcto_div num_lcto, CC.titular titular,dc_div dc, dt_pgto_Rcto_div dt_pgto_Rcto , Forma_pgto_rcto_div Forma_pgto_rcto, Num_doc_div Num_doc , vlr_doc_div vlr_doc , P.apelido apelido, dt_vcto_div dt_vcto from pgto_rcto_div PRV 
					left join cta_cte CC on CC.Num_cta_cte=PRV.num_cta_cte 
					left join pessoa P on P.cd_pes = PRV.cd_pes 
					join pgto_rcto_div_DET Det on det.num_lcto_div = PRV.num_lcto_div
				where
					PRV.concil_div = 'N' and
					PRV.num_lcto_div like @num_lcto and	
					PRV.num_cta_cte like @num_cta_cte and
					PRV.dc_div like @dc and					
					convert(datetime,PRV.dt_pgto_rcto_div,103) between convert(datetime,left(@dt_pgto_rcto,10),103) and convert(datetime,right(@dt_pgto_rcto,10),103) and	
					PRV.forma_pgto_rcto_div like @forma_pgto_rcto and
					P.apelido like @apelido	and
					convert(datetime,PRV.dt_pgto_rcto_div,103) > '01/01/2007'		
			End	

	ELSE if @dt_pgto_rcto <> '0' and @vlr_doc <> '0' 
			Begin
				select num_lcto, CC.titular titular,dc, dt_pgto_Rcto , Forma_pgto_rcto, Num_doc, vlr_doc , P.apelido apelido, dt_vcto from pgto_rcto PR 
					left join cta_cte CC on CC.Num_cta_cte=PR.num_cta_cte
					left join pessoa P on P.cd_pes = PR.cd_pes 
				where
					PR.concil = 'N' and
					PR.num_lcto like @num_lcto and	
					PR.num_cta_cte like @num_cta_cte and
					PR.dc like @dc and
					PR.vlr_doc = replace(@vlr_doc,',','.') and
					convert(datetime,PR.dt_pgto_rcto,103) between convert(datetime,left(@dt_pgto_rcto,10),103) and convert(datetime,right(@dt_pgto_rcto,10),103) and	
					PR.forma_pgto_rcto like @forma_pgto_rcto and
					P.apelido like @apelido and
					convert(datetime,PR.dt_pgto_rcto,103) > '01/01/2007'
				UNION
				select PRV.num_lcto_div num_lcto, CC.titular titular,dc_div dc, dt_pgto_Rcto_div dt_pgto_Rcto , Forma_pgto_rcto_div Forma_pgto_rcto, Num_doc_div Num_doc , vlr_doc_div vlr_doc , P.apelido apelido, dt_vcto_div dt_vcto from pgto_rcto_div PRV 
					left join cta_cte CC on CC.Num_cta_cte=PRV.num_cta_cte 
					left join pessoa P on P.cd_pes = PRV.cd_pes 
					join pgto_rcto_div_DET Det on det.num_lcto_div = PRV.num_lcto_div
				where
					PRV.concil_div = 'N' and
					PRV.num_lcto_div like @num_lcto and	
					PRV.num_cta_cte like @num_cta_cte and
					PRV.dc_div like @dc and
					PRV.vlr_doc_div = replace(@vlr_doc,',','.') and
					convert(datetime,PRV.dt_pgto_rcto_div,103) between convert(datetime,left(@dt_pgto_rcto,10),103) and convert(datetime,right(@dt_pgto_rcto,10),103) and	
					PRV.forma_pgto_rcto_div like @forma_pgto_rcto and
					P.apelido like @apelido	 and	
					convert(datetime,PRV.dt_pgto_rcto_div,103) > '01/01/2007'			
			End	



GO
