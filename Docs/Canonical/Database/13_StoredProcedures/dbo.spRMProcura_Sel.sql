SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




create Procedure [dbo].[spRMProcura_Sel] --'%','7718536-0','%','0','%', '%','0'
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
--			if @dc = 'C'
--				Begin
--					select num_Ref_RA num_lcto, CC.titular titular,'C' dc, dt_RA dt_pgto_Rcto , 'REMESSA' Forma_pgto_rcto, '' Num_doc , abs(Vlr_Tot_RA) vlr_doc , P.apelido apelido, Dt_RA dt_vcto from remessa_aer RA
--						left join cta_cte CC on CC.Num_cta_cte=RA.num_cta_cte 
--						left join pessoa P on P.cd_pes = RA.cd_pes 
--					where
--						RA.concil_ra = 'N' and
--						RA.num_ref_ra like @num_lcto and	
--						RA.num_cta_cte like @num_cta_cte and
--						RA.Vlr_Tot_RA < 0 and					
--						P.apelido like @apelido	and
--						len(Dt_RA) = 10 and
--						convert(datetime,Dt_RA,103) > '01/01/2007'
--					UNION
--					select num_Ref_RM num_lcto, CC.titular titular,'C' dc, dt_RM dt_pgto_Rcto , 'REMESSA' Forma_pgto_rcto, '' Num_doc , abs(Vlr_Tot_RM) vlr_doc , P.apelido apelido, Dt_RM dt_vcto from remessa_mar RM
--						left join cta_cte CC on CC.Num_cta_cte=RM.num_cta_cte 
--						left join pessoa P on P.cd_pes = RM.cd_pes 
--					where
--						RM.concil_RM = 'N' and
--						RM.num_ref_RM like @num_lcto and	
--						RM.num_cta_cte like @num_cta_cte and
--						RM.Vlr_Tot_RM < 0 and					
--						P.apelido like @apelido	and
--						len(Dt_RM) = 10 and
--						convert(datetime,Dt_RM,103) > '01/01/2007'
--				End
--			else if @dc = 'D'
----				Begin
----					select num_Ref_RA num_lcto, CC.titular titular,'D' dc, dt_RA dt_pgto_Rcto , 'REMESSA' Forma_pgto_rcto, '' Num_doc , abs(Vlr_Tot_RA) vlr_doc , P.apelido apelido, Dt_RA dt_vcto from remessa_aer RA
----						left join cta_cte CC on CC.Num_cta_cte=RA.num_cta_cte 
----						left join pessoa P on P.cd_pes = RA.cd_pes 
----					where
----						RA.concil_ra = 'N' and
----						RA.num_ref_ra like @num_lcto and	
----						RA.num_cta_cte like @num_cta_cte and
----						RA.Vlr_Tot_RA >= 0 and					
----						P.apelido like @apelido	 and	
----						len(Dt_RA) = 10 and
----						convert(datetime,Dt_RA,103) > '01/01/2007'
----					UNION
----					select num_Ref_RM num_lcto, CC.titular titular,'D' dc, dt_RM dt_pgto_Rcto , 'REMESSA' Forma_pgto_rcto, '' Num_doc , abs(Vlr_Tot_RM) vlr_doc , P.apelido apelido, Dt_RM dt_vcto from remessa_mar RM
----						left join cta_cte CC on CC.Num_cta_cte=RM.num_cta_cte 
----						left join pessoa P on P.cd_pes = RM.cd_pes 
----					where
----						RM.concil_RM = 'N' and
----						RM.num_ref_RM like @num_lcto and	
----						RM.num_cta_cte like @num_cta_cte and
----						RM.Vlr_Tot_RM >= 0 and					
----						P.apelido like @apelido	 and	
----						len(Dt_RM) = 10 and 
----						convert(datetime,Dt_RM,103) > '01/01/2007'
----				End	
----			else
----				Begin
					select num_Ref_RA num_lcto, CC.titular titular,'R' dc, dt_RA dt_pgto_Rcto , 'REMESSA' Forma_pgto_rcto, '' Num_doc , Vlr_Tot_RA vlr_doc , P.apelido apelido, Dt_RA dt_vcto from remessa_aer RA
						left join cta_cte CC on CC.Num_cta_cte=RA.num_cta_cte 
						left join pessoa P on P.cd_pes = RA.cd_pes 
					where
						RA.concil_ra = 'N' and
						RA.num_ref_ra like @num_lcto and	
						RA.num_cta_cte like @num_cta_cte and
						P.apelido like @apelido	 and
						len(Dt_RA) = 10 and
						convert(datetime,Dt_RA,103) > '01/01/2007'
					UNION
					select num_Ref_RM num_lcto, CC.titular titular,'R' dc, dt_RM dt_pgto_Rcto , 'REMESSA' Forma_pgto_rcto, '' Num_doc , Vlr_Tot_RM vlr_doc , P.apelido apelido, Dt_RM dt_vcto from remessa_mar RM
						left join cta_cte CC on CC.Num_cta_cte=RM.num_cta_cte 
						left join pessoa P on P.cd_pes = RM.cd_pes 
					where
						RM.concil_RM = 'N' and
						RM.num_ref_RM like @num_lcto and	
						RM.num_cta_cte like @num_cta_cte and
						P.apelido like @apelido	 and
						len(Dt_RM) = 10 and
						convert(datetime,Dt_RM,103) > '01/01/2007'
--				End			
		End

	ELSE if @dt_pgto_rcto = '0' and @vlr_doc <> '0'
			Begin
--			if @dc = 'C'
--				Begin
--					select num_Ref_RA num_lcto, CC.titular titular,'C' dc, dt_RA dt_pgto_Rcto , 'REMESSA' Forma_pgto_rcto, '' Num_doc , abs(Vlr_Tot_RA) vlr_doc , P.apelido apelido, Dt_RA dt_vcto from remessa_aer RA
--						left join cta_cte CC on CC.Num_cta_cte=RA.num_cta_cte 
--						left join pessoa P on P.cd_pes = RA.cd_pes 
--					where
--						RA.concil_ra = 'N' and
--						RA.num_ref_ra like @num_lcto and	
--						RA.num_cta_cte like @num_cta_cte and
--						RA.vlr_tot_ra = replace(@vlr_doc,',','.') and		
--						RA.Vlr_Tot_RA < 0 and					
--						P.apelido like @apelido	 and
--						len(Dt_RA) = 10 and
--						convert(datetime,Dt_RA,103) > '01/01/2007'
--					UNION
--					select num_Ref_RM num_lcto, CC.titular titular,'C' dc, dt_RM dt_pgto_Rcto , 'REMESSA' Forma_pgto_rcto, '' Num_doc , abs(Vlr_Tot_RM) vlr_doc , P.apelido apelido, Dt_RM dt_vcto from remessa_rm RM
--						left join cta_cte CC on CC.Num_cta_cte=RM.num_cta_cte 
--						left join pessoa P on P.cd_pes = RM.cd_pes 
--					where
--						RM.concil_RM = 'N' and
--						RM.num_ref_RM like @num_lcto and	
--						RM.num_cta_cte like @num_cta_cte and
--						RM.vlr_tot_RM = replace(@vlr_doc,',','.') and		
--						RM.Vlr_Tot_RM < 0 and					
--						P.apelido like @apelido	 and
--						len(Dt_RM) = 10 and
--						convert(datetime,Dt_RM,103) > '01/01/2007'
--				End
--			else if @dc = 'D'
--				Begin
--					select num_Ref_RA num_lcto, CC.titular titular,'D' dc, dt_RA dt_pgto_Rcto , 'REMESSA' Forma_pgto_rcto, '' Num_doc , abs(Vlr_Tot_RA) vlr_doc , P.apelido apelido, Dt_RA dt_vcto from remessa_aer RA
--						left join cta_cte CC on CC.Num_cta_cte=RA.num_cta_cte 
--						left join pessoa P on P.cd_pes = RA.cd_pes 
--					where
--						RA.concil_ra = 'N' and
--						RA.num_ref_ra like @num_lcto and	
--						RA.num_cta_cte like @num_cta_cte and
--						RA.vlr_tot_ra = replace(@vlr_doc,',','.') and		
--						RA.Vlr_Tot_RA >= 0 and					
--						P.apelido like @apelido	and
--						len(Dt_RA) = 10	 and
--						convert(datetime,Dt_RA,103) > '01/01/2007'
--					UNION
--					select num_Ref_RM num_lcto, CC.titular titular,'D' dc, dt_RM dt_pgto_Rcto , 'REMESSA' Forma_pgto_rcto, '' Num_doc , abs(Vlr_Tot_RM) vlr_doc , P.apelido apelido, Dt_RM dt_vcto from remessa_mar RM
--						left join cta_cte CC on CC.Num_cta_cte=RM.num_cta_cte 
--						left join pessoa P on P.cd_pes = RM.cd_pes 
--					where
--						RM.concil_RM = 'N' and
--						RM.num_ref_RM like @num_lcto and	
--						RM.num_cta_cte like @num_cta_cte and
--						RM.vlr_tot_RM = replace(@vlr_doc,',','.') and		
--						RM.Vlr_Tot_RM >= 0 and					
--						P.apelido like @apelido	and
--						len(Dt_RM) = 10 and
--						convert(datetime,Dt_RM,103) > '01/01/2007'
--				End
--			else
--				Begin
					select num_Ref_RA num_lcto, CC.titular titular,'R' dc, dt_RA dt_pgto_Rcto , 'REMESSA' Forma_pgto_rcto, '' Num_doc , Vlr_Tot_RA vlr_doc , P.apelido apelido, Dt_RA dt_vcto from remessa_aer RA
						left join cta_cte CC on CC.Num_cta_cte=RA.num_cta_cte 
						left join pessoa P on P.cd_pes = RA.cd_pes 
					where
						RA.concil_ra = 'N' and
						RA.num_ref_ra like @num_lcto and	
						RA.num_cta_cte like @num_cta_cte and
						RA.vlr_tot_ra = replace(@vlr_doc,',','.') and					
						P.apelido like @apelido	 and	
						len(Dt_RA) = 10 and 
						convert(datetime,Dt_RA,103) > '01/01/2007'
					UNION
					select num_Ref_RM num_lcto, CC.titular titular,'R' dc, dt_RM dt_pgto_Rcto , 'REMESSA' Forma_pgto_rcto, '' Num_doc , Vlr_Tot_RM vlr_doc , P.apelido apelido, Dt_RM dt_vcto from remessa_mar RM
						left join cta_cte CC on CC.Num_cta_cte=RM.num_cta_cte 
						left join pessoa P on P.cd_pes = RM.cd_pes 
					where
						RM.concil_RM = 'N' and
						RM.num_ref_RM like @num_lcto and	
						RM.num_cta_cte like @num_cta_cte and
						RM.vlr_tot_RM = replace(@vlr_doc,',','.') and					
						P.apelido like @apelido	 and	
						len(Dt_RM) = 10 and
						convert(datetime,Dt_RM,103) > '01/01/2007'
--				End				
			
		End	

	ELSE if @dt_pgto_rcto <> '0' and @vlr_doc = '0' 
			Begin
--		If @dc = 'C'
--				Begin
--					select num_Ref_RA num_lcto, CC.titular titular,'C' dc, dt_RA dt_pgto_Rcto , 'REMESSA' Forma_pgto_rcto, '' Num_doc , abs(Vlr_Tot_RA) vlr_doc , P.apelido apelido, Dt_RA dt_vcto from remessa_aer RA
--						left join cta_cte CC on CC.Num_cta_cte=RA.num_cta_cte 
--						left join pessoa P on P.cd_pes = RA.cd_pes 
--					where
--						RA.concil_ra = 'N' and
--						RA.num_ref_ra like @num_lcto and	
--						RA.num_cta_cte like @num_cta_cte and
--						convert(datetime,RA.dt_RA,103) between convert(datetime,left(@dt_pgto_rcto,10),103) and convert(datetime,right(@dt_pgto_rcto,10),103) and	
--						RA.Vlr_Tot_RA < 0 and					
--						P.apelido like @apelido	 and
--						len(Dt_RA) = 10
--					UNION
--					select num_Ref_RM num_lcto, CC.titular titular,'C' dc, dt_RM dt_pgto_Rcto , 'REMESSA' Forma_pgto_rcto, '' Num_doc , abs(Vlr_Tot_RM) vlr_doc , P.apelido apelido, Dt_RM dt_vcto from remessa_mar RM
--						left join cta_cte CC on CC.Num_cta_cte=RM.num_cta_cte 
--						left join pessoa P on P.cd_pes = RM.cd_pes 
--					where
--						RM.concil_RM = 'N' and
--						RM.num_ref_RM like @num_lcto and	
--						RM.num_cta_cte like @num_cta_cte and
--						convert(datetime,RM.dt_RM,103) between convert(datetime,left(@dt_pgto_rcto,10),103) and convert(datetime,right(@dt_pgto_rcto,10),103) and	
--						RM.Vlr_Tot_RM < 0 and					
--						P.apelido like @apelido	 and
--						len(Dt_RM) = 10
--				End
--			else if @dc = 'D'
--				Begin
--					select num_Ref_RA num_lcto, CC.titular titular,'D' dc, dt_RA dt_pgto_Rcto , 'REMESSA' Forma_pgto_rcto, '' Num_doc , abs(Vlr_Tot_RA) vlr_doc , P.apelido apelido, Dt_RA dt_vcto from remessa_aer RA
--						left join cta_cte CC on CC.Num_cta_cte=RA.num_cta_cte 
--						left join pessoa P on P.cd_pes = RA.cd_pes 
--					where
--						RA.concil_ra = 'N' and
--						RA.num_ref_ra like @num_lcto and	
--						RA.num_cta_cte like @num_cta_cte and
--						convert(datetime,RA.dt_RA,103) between convert(datetime,left(@dt_pgto_rcto,10),103) and convert(datetime,right(@dt_pgto_rcto,10),103) and	
--						RA.Vlr_Tot_RA >= 0 and					
--						P.apelido like @apelido	 and	
--						len(Dt_RA) = 10
--					UNION
--					select num_Ref_RM num_lcto, CC.titular titular,'D' dc, dt_RM dt_pgto_Rcto , 'REMESSA' Forma_pgto_rcto, '' Num_doc , abs(Vlr_Tot_RM) vlr_doc , P.apelido apelido, Dt_RM dt_vcto from remessa_mar RM
--						left join cta_cte CC on CC.Num_cta_cte=RM.num_cta_cte 
--						left join pessoa P on P.cd_pes = RM.cd_pes 
--					where
--						RM.concil_RM = 'N' and
--						RM.num_ref_RM like @num_lcto and	
--						RM.num_cta_cte like @num_cta_cte and
--						convert(datetime,RM.dt_RM,103) between convert(datetime,left(@dt_pgto_rcto,10),103) and convert(datetime,right(@dt_pgto_rcto,10),103) and	
--						RM.Vlr_Tot_RM >= 0 and					
--						P.apelido like @apelido	 and	
--						len(Dt_RM) = 10
--				End	
--			else
--				Begin
					select num_Ref_RA num_lcto, CC.titular titular,'R' dc, dt_RA dt_pgto_Rcto , 'REMESSA' Forma_pgto_rcto, '' Num_doc , Vlr_Tot_RA vlr_doc , P.apelido apelido, Dt_RA dt_vcto from remessa_aer RA
						left join cta_cte CC on CC.Num_cta_cte=RA.num_cta_cte 
						left join pessoa P on P.cd_pes = RA.cd_pes 
					where
						RA.concil_ra = 'N' and
						RA.num_ref_ra like @num_lcto and	
						RA.num_cta_cte like @num_cta_cte and
						convert(datetime,RA.dt_RA,103) between convert(datetime,left(@dt_pgto_rcto,10),103) and convert(datetime,right(@dt_pgto_rcto,10),103) and	
						P.apelido like @apelido	 and	
						len(Dt_RA) = 10
					UNION
					select num_Ref_RM num_lcto, CC.titular titular,'R' dc, dt_RM dt_pgto_Rcto , 'REMESSA' Forma_pgto_rcto, '' Num_doc , Vlr_Tot_RM vlr_doc , P.apelido apelido, Dt_RM dt_vcto from remessa_mar RM
						left join cta_cte CC on CC.Num_cta_cte=RM.num_cta_cte 
						left join pessoa P on P.cd_pes = RM.cd_pes 
					where
						RM.concil_RM = 'N' and
						RM.num_ref_RM like @num_lcto and	
						RM.num_cta_cte like @num_cta_cte and
						convert(datetime,RM.dt_RM,103) between convert(datetime,left(@dt_pgto_rcto,10),103) and convert(datetime,right(@dt_pgto_rcto,10),103) and	
						P.apelido like @apelido	 and	
						len(Dt_RM) = 10
--				End			
		End	

	ELSE if @dt_pgto_rcto <> '0' and @vlr_doc <> '0' 
			Begin
--		If @dc = 'C'
--				Begin
--					select num_Ref_RA num_lcto, CC.titular titular,'C' dc, dt_RA dt_pgto_Rcto , 'REMESSA' Forma_pgto_rcto, '' Num_doc , abs(Vlr_Tot_RA) vlr_doc , P.apelido apelido, Dt_RA dt_vcto from remessa_aer RA
--						left join cta_cte CC on CC.Num_cta_cte=RA.num_cta_cte 
--						left join pessoa P on P.cd_pes = RA.cd_pes 
--					where
--						RA.concil_ra = 'N' and
--						RA.num_ref_ra like @num_lcto and	
--						RA.num_cta_cte like @num_cta_cte and
--						RA.vlr_tot_ra = replace(@vlr_doc,',','.') and
--						convert(datetime,RA.dt_RA,103) between convert(datetime,left(@dt_pgto_rcto,10),103) and convert(datetime,right(@dt_pgto_rcto,10),103) and	
--						RA.Vlr_Tot_RA < 0 and					
--						P.apelido like @apelido	 and
--						len(Dt_RA) = 10
--					UNION
--					select num_Ref_RM num_lcto, CC.titular titular,'C' dc, dt_RM dt_pgto_Rcto , 'REMESSA' Forma_pgto_rcto, '' Num_doc , abs(Vlr_Tot_RM) vlr_doc , P.apelido apelido, Dt_RM dt_vcto from remessa_mar RM
--						left join cta_cte CC on CC.Num_cta_cte=RM.num_cta_cte 
--						left join pessoa P on P.cd_pes = RM.cd_pes 
--					where
--						RM.concil_RM = 'N' and
--						RM.num_ref_RM like @num_lcto and	
--						RM.num_cta_cte like @num_cta_cte and
--						RM.vlr_tot_RM = replace(@vlr_doc,',','.') and
--						convert(datetime,RM.dt_RM,103) between convert(datetime,left(@dt_pgto_rcto,10),103) and convert(datetime,right(@dt_pgto_rcto,10),103) and	
--						RM.Vlr_Tot_RM < 0 and					
--						P.apelido like @apelido	 and
--						len(Dt_RM) = 10
--				End
--			else if @dc = 'D'
--				Begin
--					select num_Ref_RA num_lcto, CC.titular titular,'D' dc, dt_RA dt_pgto_Rcto , 'REMESSA' Forma_pgto_rcto, '' Num_doc , abs(Vlr_Tot_RA) vlr_doc , P.apelido apelido, Dt_RA dt_vcto from remessa_aer RA
--						left join cta_cte CC on CC.Num_cta_cte=RA.num_cta_cte 
--						left join pessoa P on P.cd_pes = RA.cd_pes 
--					where
--						RA.concil_ra = 'N' and
--						RA.num_ref_ra like @num_lcto and	
--						RA.num_cta_cte like @num_cta_cte and
--						RA.vlr_tot_ra = replace(@vlr_doc,',','.') and
--						convert(datetime,RA.dt_RA,103) between convert(datetime,left(@dt_pgto_rcto,10),103) and convert(datetime,right(@dt_pgto_rcto,10),103) and	
--						RA.Vlr_Tot_RA >= 0 and					
--						P.apelido like @apelido	 	and
--						len(Dt_RA) = 10
--					UNION
--					select num_Ref_RM num_lcto, CC.titular titular,'D' dc, dt_RM dt_pgto_Rcto , 'REMESSA' Forma_pgto_rcto, '' Num_doc , abs(Vlr_Tot_RM) vlr_doc , P.apelido apelido, Dt_RM dt_vcto from remessa_mar RM
--						left join cta_cte CC on CC.Num_cta_cte=RM.num_cta_cte 
--						left join pessoa P on P.cd_pes = RM.cd_pes 
--					where
--						RM.concil_RM = 'N' and
--						RM.num_ref_RM like @num_lcto and	
--						RM.num_cta_cte like @num_cta_cte and
--						RM.vlr_tot_RM = replace(@vlr_doc,',','.') and
--						convert(datetime,RM.dt_RM,103) between convert(datetime,left(@dt_pgto_rcto,10),103) and convert(datetime,right(@dt_pgto_rcto,10),103) and	
--						RM.Vlr_Tot_RM >= 0 and					
--						P.apelido like @apelido	 	and
--						len(Dt_RM) = 10
--				End	
--			else
--				Begin
					select num_Ref_RA num_lcto, CC.titular titular,'R' dc, dt_RA dt_pgto_Rcto , 'REMESSA' Forma_pgto_rcto, '' Num_doc , Vlr_Tot_RA vlr_doc , P.apelido apelido, Dt_RA dt_vcto from remessa_aer RA
						left join cta_cte CC on CC.Num_cta_cte=RA.num_cta_cte 
						left join pessoa P on P.cd_pes = RA.cd_pes 
					where
						RA.concil_ra = 'N' and
						RA.num_ref_ra like @num_lcto and	
						RA.num_cta_cte like @num_cta_cte and
						RA.vlr_tot_ra = replace(@vlr_doc,',','.') and
						len(Dt_RA) = 10 and
						convert(datetime,RA.dt_RA,103) between convert(datetime,left(@dt_pgto_rcto,10),103) and convert(datetime,right(@dt_pgto_rcto,10),103) and	
						P.apelido like @apelido	 	
					UNION
					select num_Ref_RM num_lcto, CC.titular titular,'R' dc, dt_RM dt_pgto_Rcto , 'REMESSA' Forma_pgto_rcto, '' Num_doc , Vlr_Tot_RM vlr_doc , P.apelido apelido, Dt_RM dt_vcto from remessa_mar RM
						left join cta_cte CC on CC.Num_cta_cte=RM.num_cta_cte 
						left join pessoa P on P.cd_pes = RM.cd_pes 
					where
						RM.concil_RM = 'N' and
						RM.num_ref_RM like @num_lcto and	
						RM.num_cta_cte like @num_cta_cte and
						RM.vlr_tot_RM = replace(@vlr_doc,',','.') and
						len(Dt_RM) = 10 and
						convert(datetime,RM.dt_RM,103) between convert(datetime,left(@dt_pgto_rcto,10),103) and convert(datetime,right(@dt_pgto_rcto,10),103) and	
						P.apelido like @apelido	

--				End			
end




GO
