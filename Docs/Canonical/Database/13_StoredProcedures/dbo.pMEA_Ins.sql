SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE pMEA_Ins
(
@Dt_Emis_MEA			varchar(10),
@MAWB_MEA			varchar(25),
@Voo_MEA			varchar(13),
@Dt_Saida_MEA		varchar(10),
@Cd_Consig_MEA		varchar(10),
@Cd_Export_MEA		varchar(10),
@Cd_Org_MEA			varchar(3),
@Cd_Dst_MEA			varchar(3),
@Cd_Cia_Aer			varchar(3),
@Trf_Net_MEA			Float, 
@Qtd_Tot_Vol_MEA		Float, 
@Peso_Bruto_MEA		Float, 
@Tp_Frete_MEA		Char(1), 
@Cd_Tp_Moeda		Varchar(3), 
@Vlr_Frete_MEA		Float, 
@Qtd_HAWB_MEA		Varchar(2),
@Nivel_DL			Varchar(3),
@Obs_MEA			Varchar(2000),
@Num_Proc_MEA		Varchar(14) ='' OUTPUT, 
@Cd_Gat_MEA			VarChar(3)=Null,
@Tx_Refer_MEA		Float = 0 ,
@Peso_Tax_MEA		Float = Null,
@Refer_Cons_MEA		VarChar(20)=Null, 
@Dt_Impres_MEA		DateTime=Null,
@Consig_Acc_MEA		VarChar(30)=Null,
@ETA_MEA			DateTime=null,
@ETD_MEA			DateTime=null
)
AS
-- Parâmetros de Retorno 
-- (-2)  Erro no processo de Inserção 
			
		Begin Transaction
 		Execute pMEAReferencia_Ins @Cd_Org_MEA, 'EA', @Referencia = @Num_Proc_MEA OUTPUT
		Insert Into 
			Master_Exp_Aer
			(Num_Proc_MEA, Dt_Emis_MEA, MAWB_MEA, Voo_MEA, Dt_Saida_MEA, Cd_Consig_MEA, Cd_Export_MEA, 
			 Cd_Org_MEA, Cd_Dst_MEA, Cd_Cia_Aer, Trf_Net_MEA, Qtd_Tot_Vol_MEA, Peso_Bruto_MEA, Tp_Frete_MEA, 
			Cd_Tp_Moeda, Vlr_Frete_MEA, Qtd_HAWB_MEA, Nivel_DL, Obs_MEA, Cd_Gat_MEA, Tx_Refer_MEA, Peso_Tax_MEA,
			Refer_Cons_MEA, Dt_Impres_MEA, Consig_Acc_MEA, ETA_MEA, ETD_MEA)
		Values 
			(@Num_Proc_MEA, @Dt_Emis_MEA, @MAWB_MEA, @Voo_MEA, @Dt_Saida_MEA, @Cd_Consig_MEA, @Cd_Export_MEA, 
			 @Cd_Org_MEA, @Cd_Dst_MEA, @Cd_Cia_Aer, @Trf_Net_MEA, @Qtd_Tot_Vol_MEA, @Peso_Bruto_MEA, @Tp_Frete_MEA, 
			@Cd_Tp_Moeda, @Vlr_Frete_MEA, @Qtd_HAWB_MEA, @Nivel_DL, @Obs_MEA, @Cd_Gat_MEA, @Tx_Refer_MEA, @Peso_Tax_MEA,
			@Refer_Cons_MEA, @Dt_Impres_MEA, @Consig_Acc_MEA, @ETA_MEA, @ETD_MEA)
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
