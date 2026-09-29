SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



/****** Object:  Stored Procedure dbo.pPgtoRctoDivDet_Upd    Script Date: 17/10/2002 07:32:51 ******/
CREATE PROCEDURE pPgtoRctoDivDet_Upd
(
@Num_Lcto_Div		varchar(12),
@Cd_Cta_Ctb			varchar(13),
@Cd_Centro_Custo		varchar(5),
@DC_Item			char(1),
@Vlr_Item			Float,
@Cd_Hist_Pdr			VarChar(3),     
@Compl_Hist			VarChar(2000),
@Num_NF			VarChar(20),
@Dt_Emissao			Datetime=Null
)
 AS
	Declare @Dt_Pgto 	VarChar(10) 
	Declare @PerCont	VarChar(7)

	Set @PerCont = (Select pkcmes From param_aekcontabil) 
	Set @Dt_Pgto = (Select dt_pgto_rcto_div  From Pgto_Rcto_Div Where Num_Lcto_Div = @Num_Lcto_Div)

	If convert(Datetime, @Dt_Pgto, 105) < dbo.fFirstDayMonth(@PerCont) 
		Return -77 


	Update  
		Pgto_Rcto_Div_Det
	Set 
		Cd_Centro_Custo = @Cd_Centro_Custo, 
		DC_Item = @DC_Item, 
		Vlr_Item = @Vlr_Item, 
		Cd_Hist_Pdr = @Cd_Hist_Pdr, 
		Compl_Hist = @Compl_Hist, 
		Num_NF  = @Num_NF, 
		Dt_Emissao = @Dt_Emissao 
	Where
		Num_Lcto_Div = @Num_Lcto_Div and 
   	 	Cd_Cta_Ctb = @Cd_Cta_Ctb
GO
