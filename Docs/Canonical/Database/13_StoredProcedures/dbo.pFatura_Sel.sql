SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pFatura_Sel 
(
@Fatura		VarChar(17)
)
AS
	If Left(@Fatura, 2) = 'EA' 
		Begin 
			Select 
				Fat.FatCod, FatDtVenc, FatObs, FatStatus, ITf.Vlr_Org, Sum(Vlr_Ref_HEA)  as Vlr_Ref, 
				Pes.Nome_Raz_Soc, HEA.Num_Proc_HEA as Processo, HEA.MAWB_HEA as MAWB, 
				Origem.Nome_Local as Origem, Destino.Nome_Local as Destino,  HEA.ETD_HEA as Dt_Refer,
				Itf.Vlr_RS as Vlr_RS, Itf.Paridade as Paridade 
			From 
				Fatura  as Fat Join Item_Fat as ItF on ITf.FatCod = Fat.FatCod 
				Left Outer Join Caixa_Hou_Exp_Aer Cxa on Cxa.Num_Proc_HEA = ITf.Num_Proc and Cxa.DC_HEA = ITf.DC and Cxa.Cd_Tp_Tx = ITf.Cd_Tp_Tx 
				Join Pessoa as Pes on Pes.Cd_Pes = Fat.Cd_Pes 
				Join House_Exp_Aer as HEA on HEA.Num_Proc_HEA = Itf.Num_Proc
				Join Localidade as Origem on Origem.Cd_Local = HEA.Cd_Org_HEA 
				Join Localidade as Destino on Destino.Cd_Local = HEA.Cd_Dst_HEA 
				
			Where 
				Fat.FatCod = @Fatura
			Group by 
				Fat.FatCod, FatDtVenc, FatObs, FatStatus, ITf.Vlr_Org,
				Pes.Nome_Raz_Soc, HEA.Num_Proc_HEA, HEA.MAWB_HEA, 
				Origem.Nome_Local, Destino.Nome_Local,  HEA.ETD_HEA, 
				Itf.Vlr_RS, Itf.Paridade
		End 
			
	If Left(@Fatura, 2) = 'EM' 
		Begin 
			Select 
				Fat.FatCod, FatDtVenc, FatObs, FatStatus, ITf.Vlr_Org, Sum(Vlr_Ref_HEM)  as Vlr_Ref, 
				Pes.Nome_Raz_Soc, HEM.Num_Proc_HEM as Processo, HEM.MAWB_HEM as MAWB, 
				Origem.Nome_Local as Origem, Destino.Nome_Local as Destino,  MEM.Dt_Saida_MEM as Dt_Refer,
				0 as Vlr_RS, 0 as Paridade 

			From 
				Fatura  as Fat Join Item_Fat as ItF on ITf.FatCod = Fat.FatCod 
				Left Outer Join Caixa_Hou_Exp_Mar Cxa on Cxa.Num_Proc_HEM = ITf.Num_Proc and Cxa.DC_HEM = ITf.DC and Cxa.Cd_Tp_Tx = ITf.Cd_Tp_Tx 
				Join Pessoa as Pes on Pes.Cd_Pes = Fat.Cd_Pes 
				Join House_Exp_Mar as HEM on HEM.Num_Proc_HEM = Itf.Num_Proc
				Join Master_Exp_Mar as MEM on MEM.Num_Proc_MEM = HEM.Num_Proc_MEM
				Join Localidade as Origem on Origem.Cd_Local = HEM.Cd_Org_HEM 
				Join Localidade as Destino on Destino.Cd_Local = HEM.Cd_Dst_HEM 

				
			Where 
				Fat.FatCod = @Fatura
			Group by 
				Fat.FatCod, FatDtVenc, FatObs, FatStatus, ITf.Vlr_Org, 
				Pes.Nome_Raz_Soc, HEM.Num_Proc_HEM, HEM.MAWB_HEM, 
				Origem.Nome_Local, Destino.Nome_Local, MEM.Dt_Saida_MEM
		End 
	If Left(@Fatura, 2) = 'IA' 
		Begin 
			Select 
				Fat.FatCod, FatDtVenc, FatObs, FatStatus, ITf.Vlr_Org, Sum(Vlr_Ref_HIA)  as Vlr_Ref, 
				Pes.Nome_Raz_Soc, HIA.Num_Proc_HIA as Processo, HIA.MAWB_HIA as MAWB, 
				Origem.Nome_Local as Origem, Destino.Nome_Local as Destino,  HIA.ETA_HIA as Dt_Refer,
				0 as Vlr_RS, 0 as Paridade 
			From 
				Fatura  as Fat Join Item_Fat as ItF on ITf.FatCod = Fat.FatCod 
				Left Outer Join Caixa_Hou_Imp_Aer Cxa on Cxa.Num_Proc_HIA = ITf.Num_Proc and Cxa.DC_HIA = ITf.DC and Cxa.Cd_Tp_Tx = ITf.Cd_Tp_Tx 
				Join Pessoa as Pes on Pes.Cd_Pes = Fat.Cd_Pes 
				Join House_Imp_Aer as HIA on HIA.Num_Proc_HIA = Itf.Num_Proc
				Join Localidade as Origem on Origem.Cd_Local = HIA.Cd_Org_HIA 
				Join Localidade as Destino on Destino.Cd_Local = HIA.Cd_Dst_HIA 
				
			Where 
				Fat.FatCod = @Fatura
			Group by 
				Fat.FatCod, FatDtVenc, FatObs, FatStatus, ITf.Vlr_Org,
				Pes.Nome_Raz_Soc, HIA.Num_Proc_HIA, HIA.MAWB_HIA, 
				Origem.Nome_Local, Destino.Nome_Local, HIA.ETA_HIA
		End 
			
	If Left(@Fatura, 2) = 'IM' 
		Begin 
			Select 
				Fat.FatCod, FatDtVenc, FatObs, FatStatus, ITf.Vlr_Org, Sum(Vlr_Ref_HIM)  as Vlr_Ref, 
				Pes.Nome_Raz_Soc, HIM.Num_Proc_HIM as Processo, HIM.MAWB_HIM as MAWB, 
				Origem.Nome_Local as Origem, Destino.Nome_Local as Destino,  HIM.Dt_Cheg_HIM as Dt_Refer,
				0 as Vlr_RS, 0 as Paridade 
			From 
				Fatura  as Fat Join Item_Fat as ItF on ITf.FatCod = Fat.FatCod 
				Left Outer Join Caixa_Hou_Imp_Mar Cxa on Cxa.Num_Proc_HIM = ITf.Num_Proc and Cxa.DC_HIM = ITf.DC and Cxa.Cd_Tp_Tx = ITf.Cd_Tp_Tx 
				Join Pessoa as Pes on Pes.Cd_Pes = Fat.Cd_Pes 
				Join House_Imp_Mar as HIM on HIM.Num_Proc_HIM = Itf.Num_Proc
				Join Localidade as Origem on Origem.Cd_Local = HIM.Cd_Org_HIM 
				Join Localidade as Destino on Destino.Cd_Local = HIM.Cd_Dst_HIM 
				
			Where 
				Fat.FatCod = @Fatura
			Group by 
				Fat.FatCod, FatDtVenc, FatObs, FatStatus, ITf.Vlr_Org, 
				Pes.Nome_Raz_Soc, HIM.Num_Proc_HIM, HIM.MAWB_HIM, 
				Origem.Nome_Local , Destino.Nome_Local, HIM.Dt_Cheg_HIM 
		End

GO
