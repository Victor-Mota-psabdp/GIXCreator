SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE Procedure [dbo].[spLA_Num_Lcto_Mvto_Sel]	
	@num_lcto varchar(12)

as	
	if @num_lcto = '0' 
		Begin
			select num_lcto, CC.titular titular,dc, dt_pgto_Rcto , Forma_pgto_rcto, Num_doc, vlr_doc , P.apelido apelido, dt_vcto from pgto_rcto PR 
			left join cta_cte CC on CC.Num_cta_cte=PR.num_cta_cte
			left join pessoa P on P.cd_pes = PR.cd_pes 
			where concil = 'N' 
			Union 
			select num_lcto_div num_lcto, CC.titular titular,dc_div dc, dt_pgto_Rcto_div dt_pgto_Rcto , Forma_pgto_rcto_div Forma_pgto_rcto, Num_doc_div Num_doc , vlr_doc_div vlr_doc , P.apelido apelido, dt_vcto_div dt_vcto from pgto_rcto_div PRV 
			left join cta_cte CC on CC.Num_cta_cte=PRV.num_cta_cte 
			left join pessoa P on P.cd_pes = PRV.cd_pes 
			where concil_div = 'N' 
		End
	if left(@num_lcto,2) = 'LA'	or left(@num_lcto,2) = 'LB'
		Begin
			select num_lcto, CC.titular titular,dc, dt_pgto_Rcto , Forma_pgto_rcto, Num_doc, vlr_doc , P.apelido apelido, dt_vcto from pgto_rcto PR 
            left join cta_cte CC on CC.Num_cta_cte=PR.num_cta_cte
            left join pessoa P on P.cd_pes = PR.cd_pes 
            where concil = 'N' and num_lcto = @num_lcto
		End
	if left(@num_lcto,2) = 'DA' or left(@num_lcto,2) = 'DB'
		Begin
			select num_lcto_div num_lcto, CC.titular titular,dc_div dc, dt_pgto_Rcto_div dt_pgto_Rcto , Forma_pgto_rcto_div Forma_pgto_rcto, Num_doc_div Num_doc , vlr_doc_div vlr_doc , P.apelido apelido, dt_vcto_div dt_vcto from pgto_rcto_div PRV 
            left join cta_cte CC on CC.Num_cta_cte=PRV.num_cta_cte 
            left join pessoa P on P.cd_pes = PRV.cd_pes 
            where concil_div = 'N' and num_lcto_div = @num_lcto
		End
	if left(@num_lcto,2) = 'RA' or left(@num_lcto,2) = 'RM'
		Begin
			select num_Ref_RA num_lcto, CC.titular titular,'R' dc, dt_RA dt_pgto_Rcto , 'REMESSA' Forma_pgto_rcto, '' Num_doc , Vlr_Tot_RA vlr_doc , P.apelido apelido, Dt_RA dt_vcto from remessa_aer RA
            left join cta_cte CC on CC.Num_cta_cte=RA.num_cta_cte 
            left join pessoa P on P.cd_pes = RA.cd_pes 
            where concil_ra = 'N' and num_ref_ra = @num_lcto
			UNION
			select num_Ref_RM num_lcto, CC.titular titular,'R' dc, dt_RM dt_pgto_Rcto , 'REMESSA' Forma_pgto_rcto, '' Num_doc , Vlr_Tot_RM vlr_doc , P.apelido apelido, Dt_RM dt_vcto from remessa_mar RM
            left join cta_cte CC on CC.Num_cta_cte=RM.num_cta_cte 
            left join pessoa P on P.cd_pes = RM.cd_pes 
            where concil_RM = 'N' and num_ref_RM = @num_lcto

		End



GO
