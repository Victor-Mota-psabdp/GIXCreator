SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure spLanctoContabil_Sel 
(
	@Num_Lcto varchar(15)
)
AS
	select 
		CC.Nome_Cta_Ctb, CC.Cd_Cta_Ctb, DC, Dt_Lcto, Forma_Pgto_Rcto, Num_Doc, Num_DA, Vlr_Doc, P.Apelido, Dt_Vcto 
	from
		Lancto_Contabil LC
		left join Pessoa P on P.Cd_Pes = LC.Cd_Pes
		left join Cta_Ctb CC on CC.cd_cta_ctb = LC.cd_cta_ctb
	where
		Num_Lcto = @Num_Lcto
GO
