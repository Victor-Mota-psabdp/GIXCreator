SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pTipoTaxa_Ins
(
@Cd_Tp_Tx			varchar(3), 
@Nome_Tp_Tx			varchar(30), 
@Nome_Tp_Tx_Ing		varchar(30),
@Ref_Ctb_Tx			varchar(3), 
@CPMF_Tx			char(1), 
@IRRF_Tx			char(1), 
@ND_Tx			char(1), 
@Rateio_Tx			char(1), 
@MEA_Tx			char(1), 
@MEM_Tx			char(1), 
@MIA_Tx			char(1), 
@MIM_Tx			char(1), 
@HEA_Tx			char(1), 
@HEM_Tx			char(1), 
@HIA_Tx			char(1), 
@HIM_Tx			char(1), 
@Pft_Aer			char(1), 
@Pft_Mar			char(1), 
@Desat_Tx			char(1), 
@Cd_Cta_Ctb_Atv		varchar(13), 
@Cd_Cta_Ctb_Pas		varchar(13)
)
AS
	Insert Into 
		Tipo_Taxa 
		(Cd_Tp_Tx, Nome_Tp_Tx, Nome_Tp_Tx_Ing, Ref_Ctb_Tx, CPMF_Tx, IRRF_Tx, ND_Tx, Rateio_Tx, 
		MEA_Tx, MEM_Tx, MIA_Tx, MIM_Tx, HEA_Tx, HEM_Tx, HIA_Tx, HIM_Tx, Pft_Aer, Pft_Mar, Desat_Tx, Cd_Cta_Ctb_Atv, 
		Cd_Cta_Ctb_Pas )
	Values 
		(@Cd_Tp_Tx, @Nome_Tp_Tx, @Nome_Tp_Tx_Ing, @Ref_Ctb_Tx, @CPMF_Tx, @IRRF_Tx, @ND_Tx, @Rateio_Tx, 
		@MEA_Tx, @MEM_Tx, @MIA_Tx, @MIM_Tx, @HEA_Tx, @HEM_Tx, @HIA_Tx, @HIM_Tx, @Pft_Aer, @Pft_Mar, @Desat_Tx, @Cd_Cta_Ctb_Atv, 
		@Cd_Cta_Ctb_Pas )
	If @@Error  <> 0 
		Begin 


			Return -1 
		End 
	Else
		Begin 

			Return 1 
		End

GO
