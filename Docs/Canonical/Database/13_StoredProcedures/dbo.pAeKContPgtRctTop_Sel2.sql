SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[pAeKContPgtRctTop_Sel2] 
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
		Num_Lcto = 'LA2008010034' and 
		month(convert(datetime, dt_pgto_rcto, 105)) = @Mes  and 
		year(convert(datetime, dt_pgto_rcto, 105)) = @Ano and pr.num_lcto not in 
			(Select Num_Lcto From pgto_rcto Where Cd_Banco = '005' and Cd_Agencia = '005' and Num_Cta_Cte = '007')
GO
