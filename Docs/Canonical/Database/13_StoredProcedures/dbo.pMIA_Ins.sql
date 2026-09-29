SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE pMIA_Ins 
(
@Dt_Emis_MIA			varchar(10),
@MAWB_MIA			varchar(25),
@Termo_MIA			varchar(15),
@Voo_MIA			varchar(13),
@Cd_Consig_MIA		varchar(10),
@Cd_Export_MIA		varchar(10),
@Cd_Org_MIA			varchar(3),
@Cd_Dst_MIA			varchar(3),
@Dt_Cheg_MIA			varchar(10),
@Qtd_Tot_Vol_MIA		Float, 
@Peso_Bruto_MIA		Float, 
@Tp_Frete_MIA			Char(1), 
@Cd_Tp_Moeda		Varchar(3),
@Vlr_Frete_MIA			Float, 
@Qtd_HAWB_MIA		Varchar(2), 
@Ref_Int_MIA			Varchar(20), 
@Nivel_DL			Varchar(3), 
@Obs_MIA			Varchar(2000),
@Num_Proc_MIA		varchar(14)	OUTPUT,
@Cd_Cia_Aer			varchar(3) = null 
)
AS
		Begin Transaction 
 		Execute pMIA_Referencia_Ins @Cd_Dst_MIA, 'IA', @Referencia = @Num_Proc_MIA OUTPUT
		Insert Into 
			Master_Imp_Aer
			(Num_Proc_MIA, Dt_Emis_MIA, MAWB_MIA, Termo_MIA, Voo_MIA, Cd_Consig_MIA, Cd_Export_MIA, 
			 Cd_Org_MIA, Cd_Dst_MIA, Dt_Cheg_MIA, Qtd_Tot_Vol_MIA, Peso_Bruto_MIA, Tp_Frete_MIA, 
			 Cd_Tp_Moeda, Vlr_Frete_MIA, Qtd_HAWB_MIA, Ref_Int_MIA, Nivel_DL, Obs_MIA, Cd_Cia_Aer) 
		Values
			(@Num_Proc_MIA, @Dt_Emis_MIA, @MAWB_MIA, @Termo_MIA, @Voo_MIA, @Cd_Consig_MIA, @Cd_Export_MIA, 
			 @Cd_Org_MIA, @Cd_Dst_MIA, @Dt_Cheg_MIA, @Qtd_Tot_Vol_MIA,@Peso_Bruto_MIA, @Tp_Frete_MIA, 
			 @Cd_Tp_Moeda, @Vlr_Frete_MIA, @Qtd_HAWB_MIA, @Ref_Int_MIA, @Nivel_DL, @Obs_MIA, @Cd_Cia_Aer) 
		If @@RowCount <> 1 
			Begin 
				RollBack Transaction 
				Return - 2
			End 
		Else
			Begin 
				Commit Transaction 
				Return 1 
			End
GO
