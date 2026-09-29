SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pMovCargasVer_Sel
(
@StrMachine	VarChar(30), 
@Data1	Datetime, 
@Data2	Datetime, 
@Origem	VarChar(30)='%', 
@Destino	VarChar(30)='%', 
@Cliente	VarChar(30)='%', 
@Modal	VarChar(2) = ''
)
AS

If @Modal = ''
	Begin 
		Select 
			Distinct HIM.Cd_Tp_Moeda as Moeda
		From 
			House_Imp_Mar as HIM Join Master_Imp_Mar as MIM on MIM.Num_Proc_MIM = HIM.Num_Proc_MIM
			Left Outer Join House_Imp_Mar as HIM_PP on (HIM_PP.Num_Proc_HIM = HIM.Num_Proc_HIM and HIM_PP.Tp_Frete_HIM = 'P')
			Left Outer Join House_Imp_Mar as HIM_CC on (HIM_CC.Num_Proc_HIM = HIM.Num_Proc_HIM and HIM_CC.Tp_Frete_HIM = 'C')
			Left Outer Join Pessoa as Cliente on Cliente.Cd_Pes =  HIM.Cd_Import_HIM
			Join Localidade as Origem on Origem.Cd_Local = HIM.Cd_Org_HIM 
			Join Localidade as Destino on Destino.Cd_Local = HIM.Cd_Dst_HIM 
		Where 
			Convert(Datetime, MIM.Dt_Atrac_MIM, 105) between @Data1 and @Data2 and 
			Origem.Nome_Local like @Origem and Destino.Nome_Local Like @Destino and 
			Cliente.Apelido like @Cliente and HIM.Cd_Tp_Moeda Not In (Select Cd_Tp_Moeda From Paridade Where Cd_Tp_Par = 'OFC' and Dt_Par = dbo.StrHoje(GetDate()))
			
		
		Union 
		
		Select 
			Distinct HEM.Cd_Tp_Moeda 
		From 
			House_Exp_Mar as HEM Join Master_Exp_Mar as MEM on MEM.Num_Proc_MEM = HEM.Num_Proc_MEM
			Left Outer Join Pessoa as Cliente on Cliente.Cd_Pes =  HEM.Cd_Export_HEM
			Join Localidade as Origem on Origem.Cd_Local = HEM.Cd_Org_HEM 
			Join Localidade as Destino on Destino.Cd_Local = HEM.Cd_Dst_HEM 
		Where 
			Convert(Datetime, MEM.Dt_Saida_MEM, 105) between @Data1 and @Data2 and 
			Origem.Nome_Local like @Origem and Destino.Nome_Local Like @Destino and 
			Cliente.Apelido like @Cliente and HEM.Cd_Tp_Moeda Not In (Select Cd_Tp_Moeda From Paridade Where Cd_Tp_Par = 'OFC' and Dt_Par = dbo.StrHoje(GetDate()))
		
		Union 
		
		Select 
			Distinct HEA.Cd_Tp_Moeda 
		From 
			House_Exp_Aer as HEA 
			Join Master_Exp_Aer as MEA on MEA.Num_Proc_MEA = HEA.Num_Proc_HEA
			Left Outer Join Pessoa as Cliente on Cliente.Cd_Pes =  HEA.Cd_Export_HEA
			Join Localidade as Origem on Origem.Cd_Local = HEA.Cd_Org_HEA
			Join Localidade as Destino on Destino.Cd_Local = HEA.Cd_Dst_HEA
		Where 
			Convert(Datetime, MEA.Dt_Saida_MEA,105) between @Data1 and @Data2 and 
			Origem.Nome_Local like @Origem and Destino.Nome_Local Like @Destino and 
			Cliente.Apelido like @Cliente and HEA.Cd_Tp_Moeda Not In (Select Cd_Tp_Moeda From Paridade Where Cd_Tp_Par = 'OFC' and Dt_Par = dbo.StrHoje(GetDate()))
		
		Union 
		
		
		Select 
			Distinct HIA.Cd_Tp_Moeda 
		From 
			House_Imp_Aer as HIA 
			Join Master_Imp_Aer as MIA on MIA.Num_Proc_MIA = HIA.Num_Proc_MIA 
			Left Outer Join Pessoa as Cliente on Cliente.Cd_Pes =  HIA.Cd_Export_HIA
			Join Localidade as Origem on Origem.Cd_Local = HIA.Cd_Org_HIA
			Join Localidade as Destino on Destino.Cd_Local = HIA.Cd_Dst_HIA
		Where 
			Convert(Datetime, MIA.Dt_Cheg_MIA, 105)  between @Data1 and @Data2 and 
			Origem.Nome_Local like @Origem and Destino.Nome_Local Like @Destino and 
			Cliente.Apelido like @Cliente and HIA.Cd_Tp_Moeda Not In (Select Cd_Tp_Moeda From Paridade Where Cd_Tp_Par = 'OFC' and Dt_Par = dbo.StrHoje(GetDate()))


	End 
Else
	Begin 
		If @Modal = 'IM' 
			Begin 
				Select 
					Distinct HIM.Cd_Tp_Moeda as Moeda
				From 
					House_Imp_Mar as HIM Join Master_Imp_Mar as MIM on MIM.Num_Proc_MIM = HIM.Num_Proc_MIM
					Left Outer Join House_Imp_Mar as HIM_PP on (HIM_PP.Num_Proc_HIM = HIM.Num_Proc_HIM and HIM_PP.Tp_Frete_HIM = 'P')
					Left Outer Join House_Imp_Mar as HIM_CC on (HIM_CC.Num_Proc_HIM = HIM.Num_Proc_HIM and HIM_CC.Tp_Frete_HIM = 'C')
					Left Outer Join Pessoa as Cliente on Cliente.Cd_Pes =  HIM.Cd_Import_HIM
					Join Localidade as Origem on Origem.Cd_Local = HIM.Cd_Org_HIM 
					Join Localidade as Destino on Destino.Cd_Local = HIM.Cd_Dst_HIM 
				Where 
					Convert(Datetime, MIM.Dt_Atrac_MIM, 105) between @Data1 and @Data2 and 
					Origem.Nome_Local like @Origem and Destino.Nome_Local Like @Destino and 
					Cliente.Apelido like @Cliente and HIM.Cd_Tp_Moeda Not In (Select Cd_Tp_Moeda From Paridade Where Cd_Tp_Par = 'OFC' and Dt_Par = dbo.StrHoje(GetDate()))
			End 
		If @Modal = 'EM'
			Begin 
				Select 
					Distinct HEM.Cd_Tp_Moeda 
				From 
					House_Exp_Mar as HEM Join Master_Exp_Mar as MEM on MEM.Num_Proc_MEM = HEM.Num_Proc_MEM
					Left Outer Join Pessoa as Cliente on Cliente.Cd_Pes =  HEM.Cd_Export_HEM
					Join Localidade as Origem on Origem.Cd_Local = HEM.Cd_Org_HEM 
					Join Localidade as Destino on Destino.Cd_Local = HEM.Cd_Dst_HEM 
				Where 
					Convert(Datetime, MEM.Dt_Saida_MEM, 105) between @Data1 and @Data2 and 
					Origem.Nome_Local like @Origem and Destino.Nome_Local Like @Destino and 
					Cliente.Apelido like @Cliente and HEM.Cd_Tp_Moeda Not In (Select Cd_Tp_Moeda From Paridade Where Cd_Tp_Par = 'OFC' and Dt_Par = dbo.StrHoje(GetDate()))
			End 

		If @Modal = 'EA'
			Begin 
				
				Select 
					Distinct HEA.Cd_Tp_Moeda 
				From 
					House_Exp_Aer as HEA 
					Join Master_Exp_Aer as MEA on MEA.Num_Proc_MEA = HEA.Num_Proc_HEA
					Left Outer Join Pessoa as Cliente on Cliente.Cd_Pes =  HEA.Cd_Export_HEA
					Join Localidade as Origem on Origem.Cd_Local = HEA.Cd_Org_HEA
					Join Localidade as Destino on Destino.Cd_Local = HEA.Cd_Dst_HEA
				Where 
					Convert(Datetime, MEA.Dt_Saida_MEA,105) between @Data1 and @Data2 and 
					Origem.Nome_Local like @Origem and Destino.Nome_Local Like @Destino and 
					Cliente.Apelido like @Cliente and HEA.Cd_Tp_Moeda Not In (Select Cd_Tp_Moeda From Paridade Where Cd_Tp_Par = 'OFC' and Dt_Par = dbo.StrHoje(GetDate()))
				
			End 

		If @Modal = 'IA' 
			Begin 
				Select 
					Distinct HIA.Cd_Tp_Moeda 
				From 
					House_Imp_Aer as HIA 
					Join Master_Imp_Aer as MIA on MIA.Num_Proc_MIA = HIA.Num_Proc_MIA 
					Left Outer Join Pessoa as Cliente on Cliente.Cd_Pes =  HIA.Cd_Export_HIA
					Join Localidade as Origem on Origem.Cd_Local = HIA.Cd_Org_HIA
					Join Localidade as Destino on Destino.Cd_Local = HIA.Cd_Dst_HIA
				Where 
					Convert(Datetime, MIA.Dt_Cheg_MIA, 105)  between @Data1 and @Data2 and 
					Origem.Nome_Local like @Origem and Destino.Nome_Local Like @Destino and 
					Cliente.Apelido like @Cliente and HIA.Cd_Tp_Moeda Not In (Select Cd_Tp_Moeda From Paridade Where Cd_Tp_Par = 'OFC' and Dt_Par = dbo.StrHoje(GetDate()))
			End  

	End

GO
