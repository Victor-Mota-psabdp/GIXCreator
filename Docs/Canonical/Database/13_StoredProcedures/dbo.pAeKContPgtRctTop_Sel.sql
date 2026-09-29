SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[pAeKContPgtRctTop_Sel] 
(
@Ano		VarChar(4) ,
@Mes		char(2) 
)
AS
	Select 
		dt_pgto_rcto, Num_Lcto, Forma_Pgto_Rcto, Cd_Cta_Ctb, Num_Doc ,  DC, Vlr_Doc 
	From 
		pgto_rcto pr left join cta_cte cte on cte.cd_banco = pr.cd_banco and cte.cd_agencia = pr.cd_agencia and cte.num_cta_cte = pr.num_cta_cte 
	where 
		month(convert(datetime, dt_pgto_rcto, 105)) = @Mes  and 
		year(convert(datetime, dt_pgto_rcto, 105)) = @Ano and pr.num_lcto not in 
			(Select Num_Lcto From pgto_rcto Where Cd_Banco = '005' and Cd_Agencia = '005' and Num_Cta_Cte = '007') 
		

	Union 

	
	Select 
		DT_RA dt_pgto_rcto, num_ref_ra Num_Lcto, 'Remessa' Forma_Pgto_Rcto, Cd_Cta_Ctb, '' Num_Doc , 'D' DC, Vlr_Tot_RA Vlr_Doc
	From 
		remessa_aer pr join cta_cte cte on cte.cd_banco = pr.cd_banco and cte.cd_agencia = pr.cd_agencia and cte.num_cta_cte = pr.num_cta_cte 
	where 
		month(convert(datetime, dt_ra, 105)) = @Mes  and year(convert(datetime, dt_ra, 105)) = @Ano 

	Union 

	Select 
		DT_RM dt_pgto_rcto, num_ref_rm Num_Lcto, 'Remessa' Forma_Pgto_Rcto, Cd_Cta_Ctb, '' Num_Doc , 'D' DC, Vlr_Tot_RM Vlr_Doc
	From 
		remessa_mar pr join cta_cte cte on cte.cd_banco = pr.cd_banco and cte.cd_agencia = pr.cd_agencia and cte.num_cta_cte = pr.num_cta_cte 
	where 
		month(convert(datetime, dt_rm, 105)) = @Mes  and year(convert(datetime, dt_rm, 105)) = @Ano



GO
