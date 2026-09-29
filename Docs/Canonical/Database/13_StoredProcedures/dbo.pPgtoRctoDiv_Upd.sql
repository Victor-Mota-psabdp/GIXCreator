SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



/****** Object:  Stored Procedure dbo.pPgtoRctoDiv_Upd    Script Date: 17/10/2002 07:32:51 ******/
CREATE PROCEDURE pPgtoRctoDiv_Upd
(
@Num_Lcto_Div			Varchar(12),
@Cd_Banco				Varchar(3),
@Cd_Agencia				Varchar(5), 
@Num_Cta_Cte				Varchar(20),
@DC_Div				Char(1), 
@Dt_Pgto_Rcto_Div			Varchar(10),
@Forma_Pgto_Rcto_Div			Varchar(10),
@Num_Doc_Div			Varchar(10),
@Vlr_Doc_Div				Float,
@Cd_Pes				Varchar(10), 
@Dt_Vcto_Div				Varchar(10),
@Concil_Div				Char(1),
@Cta_Cte_Cliente_Div			VarChar(50)=Null,
@Ck_Doctos				Char(1)
)
 AS
	Declare @Dt_Pgto 	VarChar(10) 
	Declare @PerCont	VarChar(7)

	Set @PerCont = (Select pkcmes From param_aekcontabil) 


	If convert(Datetime, @Dt_Pgto_Rcto_Div, 105) < dbo.fFirstDayMonth(@PerCont) 
		Return - 77		


	Update
		Pgto_Rcto_Div
	Set 
		Cd_Banco=@Cd_Banco, 
		Cd_Agencia=@Cd_Agencia, 
		Num_Cta_Cte=@Num_Cta_Cte, 
		DC_Div = @DC_Div, 
		Dt_Pgto_Rcto_Div = @Dt_Pgto_Rcto_Div, 
		Forma_Pgto_Rcto_Div = @Forma_Pgto_Rcto_Div, 
		Num_Doc_Div = @Num_Doc_Div,
		Vlr_Doc_Div = @Vlr_Doc_Div, 
		Cd_Pes = @Cd_Pes, 
		Dt_Vcto_Div = @Dt_Vcto_Div, 
		Concil_Div =@Concil_Div,
		Cta_Cte_Cliente_Div = @Cta_Cte_Cliente_Div
	Where 
		Num_Lcto_Div = @Num_Lcto_Div
	Return @@RowCount
GO
