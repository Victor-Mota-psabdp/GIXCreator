SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[pFatura_Rel] 
(
@Fatura		VarChar(17)
)
AS
	If Left(@Fatura, 2) = 'EA' 
		Begin 
			Select 
				Fat.FatCod, FatDtVenc, FatObs, FatStatus, HEA.HAWB_HEA AS HAWB,
				Pes.Nome_Raz_Soc, HEA.Num_Proc_HEA as Processo, HEA.MAWB_HEA as MAWB, 
				Origem.Nome_Local as Origem, Destino.Nome_Local as Destino,  HEA.ETD_HEA as Dt_Refer
			From 
				Fatura  as Fat Join Pessoa as Pes on Pes.Cd_Pes = Fat.Cd_Pes
				Join House_Exp_Aer as HEA on HEA.Num_Proc_HEA = Left(Fat.FatCod, 16) 
				Join Localidade as Origem on Origem.Cd_Local = HEA.Cd_Org_HEA 
				Join Localidade as Destino on Destino.Cd_Local = HEA.Cd_Dst_HEA 
				
			Where 
				Fat.FatCod = @Fatura

		End 
			
	If Left(@Fatura, 2) = 'EM' 
		Begin 
			Select 
				Fat.FatCod, FatDtVenc, FatObs, FatStatus, HEM.HAWB_HEM AS HAWB,
				Pes.Nome_Raz_Soc, HEM.Num_Proc_HEM as Processo, HEM.MAWB_HEM as MAWB, 
				Origem.Nome_Local as Origem, Destino.Nome_Local as Destino,  MEM.Dt_Saida_MEM as Dt_Refer

			From 
				Fatura  as Fat Join Pessoa as Pes on Pes.Cd_Pes = Fat.Cd_Pes 
				Join House_Exp_Mar as HEM on HEM.Num_Proc_HEM = Left(Fat.FatCod, 16)
				Join Master_Exp_Mar as MEM on MEM.Num_Proc_MEM = HEM.Num_Proc_MEM
				Join Localidade as Origem on Origem.Cd_Local = HEM.Cd_Org_HEM 
				Join Localidade as Destino on Destino.Cd_Local = HEM.Cd_Dst_HEM 
			Where 
				Fat.FatCod = @Fatura

		End 
	If Left(@Fatura, 2) = 'IA' 
		Begin 
			Select 
				Fat.FatCod, FatDtVenc, FatObs, FatStatus, HIA.HAWB_HIA AS HAWB,
				Pes.Nome_Raz_Soc, HIA.Num_Proc_HIA as Processo, HIA.MAWB_HIA as MAWB, 
				Origem.Nome_Local as Origem, Destino.Nome_Local as Destino,  HIA.ETA_HIA as Dt_Refer
			From 
				Fatura  as Fat Join Pessoa as Pes on Pes.Cd_Pes = Fat.Cd_Pes 
				Join House_Imp_Aer as HIA on HIA.Num_Proc_HIA = Left(Fat.FatCod, 16)
				Join Localidade as Origem on Origem.Cd_Local = HIA.Cd_Org_HIA 
				Join Localidade as Destino on Destino.Cd_Local = HIA.Cd_Dst_HIA 
				
			Where 
				Fat.FatCod = @Fatura

		End 
			
	If Left(@Fatura, 2) = 'IM' 
		Begin 
			Select 
				Fat.FatCod, FatDtVenc, FatObs, FatStatus, HIM.HAWB_HIM AS HAWB,
				Pes.Nome_Raz_Soc, HIM.Num_Proc_HIM as Processo, HIM.MAWB_HIM as MAWB, 
				Origem.Nome_Local as Origem, Destino.Nome_Local as Destino,  MAS.Dt_Atrac_mim as Dt_Refer
			From 
				Fatura  as Fat Join Pessoa as Pes on Pes.Cd_Pes = Fat.Cd_Pes 
				Join House_Imp_Mar as HIM on HIM.Num_Proc_HIM = Left(Fat.FatCod, 16) 
				Join Localidade as Origem on Origem.Cd_Local = HIM.Cd_Org_HIM 
				Join Localidade as Destino on Destino.Cd_Local = HIM.Cd_Dst_HIM 
				join Master_imp_mar as MAS on HIM.Num_proc_mim = MAS.Num_proc_mim
			Where 
				Fat.FatCod = @Fatura

		End


GO
