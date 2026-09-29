SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE pCompPag_Rel 
(
@Num_Lcto		varchar(20), 
@Comp			varchar(20)
)
AS
	Select 
		* 
	From 
		pgto_rcto pr join cta_cte cc on cc.cd_banco = pr.cd_banco and cc.cd_agencia = pr.cd_agencia and cc.Num_cta_Cte = pr.Num_Cta_Cte 
		Join banco bco on bco.cd_banco = pr.cd_banco
	Where
		Num_Lcto = @Num_Lcto 
GO
