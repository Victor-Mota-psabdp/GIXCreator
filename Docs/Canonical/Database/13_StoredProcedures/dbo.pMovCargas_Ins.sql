SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pMovCargas_Ins
(
@StrMachine	VarChar(30), 
@Data1	Datetime, 
@Data2	Datetime, 
@Origem	VarChar(30)='%', 
@Destino	VarChar(30)='%', 
@Cliente	VarChar(30)='%', 
@Modal 	VarChar(2)=''
)
AS
Declare @ParUSD	Float 
Set @ParUSD = (Select Par_Moeda From Paridade Where Cd_Tp_Moeda = 'USD' and Cd_Tp_Par = 'OFC' and Dt_Par = dbo.StrHoje(GetDate()))

Delete 
	Tmp_Mov_Cargas_LCL
Where
	StrMachine = @StrMachine 


Delete 
	Tmp_Mov_Cargas_FCL
Where
	StrMachine = @StrMachine 


--HIM LCL

If @Modal = 'IM' or @Modal = '' 
	Begin 
		Insert Into Tmp_Mov_Cargas_LCL
		Select 
			@StrMachine, Cliente.Apelido as Cliente,  'IM'  as Modal, Origem.Nome_Local as Origem, Destino.Nome_Local as Destino, 
			count(*) as Embarques, sum((HIM_PP.Vlr_Frete_Efet_HIM * @ParUSD)/ParMoeda.Par_Moeda) as Frete_PP,
			sum((HIM_CC.Vlr_Frete_Efet_HIM * @ParUSD)/ParMoeda.Par_Moeda) as Frete_CC, Sum(HIM.Peso_Bruto_HIM) as Peso
		From 
			House_Imp_Mar as HIM Join Master_Imp_Mar as MIM on MIM.Num_Proc_MIM = HIM.Num_Proc_MIM
			Left Outer Join House_Imp_Mar as HIM_PP on (HIM_PP.Num_Proc_HIM = HIM.Num_Proc_HIM and HIM_PP.Tp_Frete_HIM = 'P')
			Left Outer Join House_Imp_Mar as HIM_CC on (HIM_CC.Num_Proc_HIM = HIM.Num_Proc_HIM and HIM_CC.Tp_Frete_HIM = 'C')
			Left Outer Join Pessoa as Cliente on Cliente.Cd_Pes =  HIM.Cd_Import_HIM
			Left Outer Join Paridade as ParMoeda on ParMoeda.Cd_Tp_Moeda = HIM.Cd_Tp_Moeda and ParMoeda.Cd_Tp_Par = 'OFC' and ParMoeda.Dt_Par = dbo.StrHoje(GetDate())
			Join Localidade as Origem on Origem.Cd_Local = HIM.Cd_Org_HIM 
			Join Localidade as Destino on Destino.Cd_Local = HIM.Cd_Dst_HIM 
		
		Where 
			HIM.Num_Proc_MIM In 
			(Select Distinct Num_Proc_MIM From Container_mas_imp_mar Where Cd_Tp_Cont = 'LCL' or Cd_Tp_Cont = 'BB') and
			Convert(Datetime, MIM.Dt_Atrac_MIM, 105) between @Data1 and @Data2 and 
			Origem.Nome_Local like @Origem and Destino.Nome_Local Like @Destino and 
			Cliente.Apelido like @Cliente
		Group by 
			Origem.Nome_Local, Destino.Nome_Local, 
			Cliente.Apelido
		
		--HIM FCL
		Insert Into Tmp_Mov_Cargas_FCL
		Select 
			@StrMachine, Cliente.Apelido as Cliente,  'IM'  as Modal, Origem.Nome_Local as Origem, Destino.Nome_Local as Destino, 
			count(*) as Embarques, sum((HIM_PP.Vlr_Frete_Efet_HIM * @ParUSD)/ParMoeda.Par_Moeda) as Frete_PP,
			sum((HIM_CC.Vlr_Frete_Efet_HIM * @ParUSD)/ParMoeda.Par_Moeda) as Frete_CC, Sum(HIM.Peso_Bruto_HIM) as Peso, 0 as 'CC20', 0 as 'CC40'
		From 
			House_Imp_Mar as HIM 
			Join Master_Imp_Mar as MIM on MIM.Num_Proc_MIM = HIM.Num_Proc_MIM
			Left Outer Join House_Imp_Mar as HIM_PP on (HIM_PP.Num_Proc_HIM = HIM.Num_Proc_HIM and HIM_PP.Tp_Frete_HIM = 'P')
			Left Outer Join House_Imp_Mar as HIM_CC on (HIM_CC.Num_Proc_HIM = HIM.Num_Proc_HIM and HIM_CC.Tp_Frete_HIM = 'C')
			Left Outer Join Pessoa as Cliente on Cliente.Cd_Pes =  HIM.Cd_Import_HIM
			Join Localidade as Origem on Origem.Cd_Local = HIM.Cd_Org_HIM 
			Join Localidade as Destino on Destino.Cd_Local = HIM.Cd_Dst_HIM 
			Left Outer Join Paridade as ParMoeda on ParMoeda.Cd_Tp_Moeda = HIM.Cd_Tp_Moeda and ParMoeda.Cd_Tp_Par = 'OFC' and ParMoeda.Dt_Par = dbo.StrHoje(GetDate())
		Where 
			HIM.Num_Proc_MIM In 
			(Select Distinct Num_Proc_MIM From Container_mas_imp_mar Where Cd_Tp_Cont <> 'LCL' and Cd_Tp_Cont <> 'BB') and
			Convert(Datetime, MIM.Dt_Atrac_MIM, 105) between @Data1 and @Data2 and 
			Origem.Nome_Local like @Origem and Destino.Nome_Local Like @Destino and 
			Cliente.Apelido like @Cliente
		Group by 
			Origem.Nome_Local, Destino.Nome_Local, 
			Cliente.Apelido
	End 

--HEM LCL'

If @Modal = 'EM' or @Modal = '' 
	Begin 
		Insert Into Tmp_Mov_Cargas_LCL
		Select 
			@StrMachine, Cliente.Apelido as Cliente,  'EM'  as Modal, Origem.Nome_Local as Origem, Destino.Nome_Local as Destino, 
			count(*) as Embarques, sum((HEM_PP.Vlr_Frete_Tot_HEM * @ParUSD)/ParMoeda.Par_Moeda) as Frete_PP,
			sum((HEM_CC.Vlr_Frete_Tot_HEM * @ParUSD)/ParMoeda.Par_Moeda) as Frete_CC, Sum(HEM.Peso_Bruto_HEM) as Peso
		From 
			House_Exp_Mar as HEM Join Master_Exp_Mar as MEM on MEM.Num_Proc_MEM = HEM.Num_Proc_MEM
			Left Outer Join House_Exp_Mar as HEM_PP on (HEM_PP.Num_Proc_HEM = HEM.Num_Proc_HEM and HEM_PP.Tp_Frete_HEM = 'P')
			Left Outer Join House_Exp_Mar as HEM_CC on (HEM_CC.Num_Proc_HEM = HEM.Num_Proc_HEM and HEM_CC.Tp_Frete_HEM = 'C')
			Left Outer Join Pessoa as Cliente on Cliente.Cd_Pes =  HEM.Cd_Export_HEM
			Join Localidade as Origem on Origem.Cd_Local = HEM.Cd_Org_HEM 
			Join Localidade as Destino on Destino.Cd_Local = HEM.Cd_Dst_HEM 
			Left Outer Join Paridade as ParMoeda on ParMoeda.Cd_Tp_Moeda = HEM.Cd_Tp_Moeda and ParMoeda.Cd_Tp_Par = 'OFC' and ParMoeda.Dt_Par = dbo.StrHoje(GetDate())
		Where 
			HEM.Num_Proc_MEM In 
			(Select Distinct Num_Proc_MEM From Container_mas_exp_mar Where Cd_Tp_Cont = 'LCL' or Cd_Tp_Cont = 'BB') and
			Convert(Datetime, MEM.Dt_Saida_MEM, 105) between @Data1 and @Data2 and 
			Origem.Nome_Local like @Origem and Destino.Nome_Local Like @Destino and 
			Cliente.Apelido like @Cliente
		Group by 
			Origem.Nome_Local, Destino.Nome_Local, 
			Cliente.Apelido
		--HEM FCL'
		
		Insert Into Tmp_Mov_Cargas_FCL
		Select 
			@StrMachine, Cliente.Apelido as Cliente,  'EM'  as Modal, Origem.Nome_Local as Origem, Destino.Nome_Local as Destino, 
			count(*) as Embarques, sum((HEM_PP.Vlr_Frete_Tot_HEM * @ParUSD)/ParMoeda.Par_Moeda) as Frete_PP,
			sum((HEM_CC.Vlr_Frete_Tot_HEM * @ParUSD)/ParMoeda.Par_Moeda) as Frete_CC, Sum(HEM.Peso_Bruto_HEM) as Peso, 0 as 'CC20', 0 as 'CC40'
		From 
			House_Exp_Mar as HEM 	Join Master_Exp_Mar as MEM on MEM.Num_Proc_MEM = HEM.Num_Proc_MEM
			Left Outer Join House_Exp_Mar as HEM_PP on (HEM_PP.Num_Proc_HEM = HEM.Num_Proc_HEM and HEM_PP.Tp_Frete_HEM = 'P')
			Left Outer Join House_Exp_Mar as HEM_CC on (HEM_CC.Num_Proc_HEM = HEM.Num_Proc_HEM and HEM_CC.Tp_Frete_HEM = 'C')
			Left Outer Join Pessoa as Cliente on Cliente.Cd_Pes =  HEM.Cd_Export_HEM
			Join Localidade as Origem on Origem.Cd_Local = HEM.Cd_Org_HEM 
			Join Localidade as Destino on Destino.Cd_Local = HEM.Cd_Dst_HEM 
			Left Outer Join Paridade as ParMoeda on ParMoeda.Cd_Tp_Moeda = HEM.Cd_Tp_Moeda and ParMoeda.Cd_Tp_Par = 'OFC' and ParMoeda.Dt_Par = dbo.StrHoje(GetDate())
		Where 
			HEM.Num_Proc_MEM In 
			(Select Distinct Num_Proc_MEM From Container_mas_exp_mar Where Cd_Tp_Cont <> 'LCL' and Cd_Tp_Cont <> 'BB') and
			Convert(Datetime, MEM.Dt_Saida_MEM, 105) between @Data1 and @Data2 and 
			Origem.Nome_Local like @Origem and Destino.Nome_Local Like @Destino and 
			Cliente.Apelido like @Cliente
		Group by 
			Origem.Nome_Local, Destino.Nome_Local, 
			Cliente.Apelido
	End 

If @Modal = 'IA' or @Modal = '' 
	Begin 
		--HEA LCL'
		Insert Into Tmp_Mov_Cargas_LCL
		Select 
			@StrMachine, Cliente.Apelido as Cliente,  'EA'  as Modal, Origem.Nome_Local as Origem, Destino.Nome_Local as Destino, 
			count(*) as Embarques, sum((HEA_PP.Vlr_Frete_Tot_HEA * @ParUSD)/ParMoeda.Par_Moeda) as Frete_PP,
			sum((HEA_CC.Vlr_Frete_Tot_HEA * @ParUSD)/ParMoeda.Par_Moeda) as Frete_CC, Sum(HEA.Peso_Bruto_HEA) as Peso
		From 
			House_Exp_Aer as HEA 
			Join Master_Exp_Aer as MEA on MEA.Num_Proc_MEA = HEA.Num_Proc_HEA
			Left Outer Join House_Exp_Aer as HEA_PP on (HEA_PP.Num_Proc_HEA = HEA.Num_Proc_HEA and HEA_PP.Tp_Frete_HEA = 'P')
			Left Outer Join House_Exp_Aer as HEA_CC on (HEA_CC.Num_Proc_HEA = HEA.Num_Proc_HEA and HEA_CC.Tp_Frete_HEA = 'C')
			Left Outer Join Pessoa as Cliente on Cliente.Cd_Pes =  HEA.Cd_Export_HEA
			Join Localidade as Origem on Origem.Cd_Local = HEA.Cd_Org_HEA
			Join Localidade as Destino on Destino.Cd_Local = HEA.Cd_Dst_HEA
			Left Outer Join Paridade as ParMoeda on ParMoeda.Cd_Tp_Moeda = HEA.Cd_Tp_Moeda and ParMoeda.Cd_Tp_Par = 'OFC' and ParMoeda.Dt_Par = dbo.StrHoje(GetDate())
		Where 
			Convert(Datetime, MEA.Dt_Saida_MEA,105) between @Data1 and @Data2 and 
			Origem.Nome_Local like @Origem and Destino.Nome_Local Like @Destino and 
			Cliente.Apelido like @Cliente
		Group by 
			Origem.Nome_Local, Destino.Nome_Local, 
			Cliente.Apelido
	End 

--HIA LCL'
If @Modal = 'IA' and @Modal = '' 
	Begin 
		Insert Into Tmp_Mov_Cargas_LCL
		Select 
			@StrMachine, Cliente.Apelido as Cliente,  'IA'  as Modal, Origem.Nome_Local as Origem, Destino.Nome_Local as Destino, 
			count(*) as Embarques, sum((HIA_PP.Vlr_Frete_Efet_HIA * @ParUSD)/ParMoeda.Par_Moeda) as Frete_PP,
			sum((HIA_CC.Vlr_Frete_Efet_HIA * @ParUSD)/ParMoeda.Par_Moeda) as Frete_CC, Sum(HIA.Peso_Bruto_HIA) as Peso
		From 
			House_Imp_Aer as HIA 
			Join Master_Imp_Aer as MIA on MIA.Num_Proc_MIA = HIA.Num_Proc_MIA 
			Left Outer Join House_Imp_Aer as HIA_PP on (HIA_PP.Num_Proc_HIA = HIA.Num_Proc_HIA and HIA_PP.Tp_Frete_HIA = 'P')
			Left Outer Join House_Imp_Aer as HIA_CC on (HIA_CC.Num_Proc_HIA = HIA.Num_Proc_HIA and HIA_CC.Tp_Frete_HIA = 'C')
			Left Outer Join Pessoa as Cliente on Cliente.Cd_Pes =  HIA.Cd_Export_HIA
			Join Localidade as Origem on Origem.Cd_Local = HIA.Cd_Org_HIA
			Join Localidade as Destino on Destino.Cd_Local = HIA.Cd_Dst_HIA
			Left Outer Join Paridade as ParMoeda on ParMoeda.Cd_Tp_Moeda = HIA.Cd_Tp_Moeda and ParMoeda.Cd_Tp_Par = 'OFC' and ParMoeda.Dt_Par = dbo.StrHoje(GetDate())
		Where 
			Convert(Datetime, MIA.Dt_Cheg_MIA, 105)  between @Data1 and @Data2 and 
			Origem.Nome_Local like @Origem and Destino.Nome_Local Like @Destino and 
			Cliente.Apelido like @Cliente
		Group by 
			Origem.Nome_Local, Destino.Nome_Local, 
			Cliente.Apelido
	End 

	If @Modal = 'IM' or @Modal = ''
		Begin 
		Update 
			Tmp_Mov_Cargas_FCL 
		Set 
			Qtd_CC_20 = (Select Count(*) as Containers20 From 
					House_Imp_mar as HIM Join Master_Imp_Mar as MIM on MIM.Num_Proc_MIM = HIM.Num_Proc_MIM
					Join Container_Mas_Imp_Mar as CC20 on CC20.Num_Proc_MIM = HIM.Num_Proc_MIM and CC20.Cd_Tp_Cont Like '%20%'
					Join Localidade as Origem on Origem.Cd_Local = HIM.Cd_Org_HIM 
					Join Localidade as Destino on Destino.Cd_Local = HIM.Cd_Dst_HIM 
					Join Pessoa as Cliente on Cliente.Cd_Pes = HIM.Cd_Import_HIM
				Where 
					Origem.Nome_Local = TMP.Origem  and 
					Destino.Nome_Local = TMP.Destino  and 
					Cliente.Apelido = TMP.Cliente and 
					HIM.Num_Proc_MIM In 
					(Select Distinct Num_Proc_MIM From Container_mas_imp_mar Where Cd_Tp_Cont <> 'LCL' and Cd_Tp_Cont <> 'BB') and
					Convert(Datetime, MIM.Dt_Atrac_MIM, 105) between @Data1 and @Data2 and 
					Origem.Nome_Local like @Origem and Destino.Nome_Local Like @Destino and 
					Cliente.Apelido like @Cliente
				Group by 
					Cliente.Apelido, Origem.Nome_Local, Destino.Nome_Local) 
		From 
			Tmp_Mov_Cargas_FCL as TMP
		Where
			StrMachine = @StrMachine and 
			Modal = 'IM'
		
		
		
		Update 
			Tmp_Mov_Cargas_FCL 
		Set 
			Qtd_CC_40 = (Select Count(*) as Containers40 From 
					House_Imp_mar as HIM Join Master_Imp_Mar as MIM on MIM.Num_Proc_MIM = HIM.Num_Proc_MIM
					Join Container_Mas_Imp_Mar as CC40 on CC40.Num_Proc_MIM = HIM.Num_Proc_MIM and CC40.Cd_Tp_Cont Like '%40%'
					Join Localidade as Origem on Origem.Cd_Local = HIM.Cd_Org_HIM 
					Join Localidade as Destino on Destino.Cd_Local = HIM.Cd_Dst_HIM 
					Join Pessoa as Cliente on Cliente.Cd_Pes = HIM.Cd_Import_HIM
				Where 
					Origem.Nome_Local = TMP.Origem  and 
					Destino.Nome_Local = TMP.Destino  and 
					Cliente.Apelido = TMP.Cliente and 
					HIM.Num_Proc_MIM In 
					(Select Distinct Num_Proc_MIM From Container_mas_imp_mar Where Cd_Tp_Cont <> 'LCL' and Cd_Tp_Cont <> 'BB') and
					Convert(Datetime, MIM.Dt_Atrac_MIM, 105) between @Data1 and @Data2 and 
					Origem.Nome_Local like @Origem and Destino.Nome_Local Like @Destino and 
					Cliente.Apelido like @Cliente
				Group by 
					Cliente.Apelido, Origem.Nome_Local, Destino.Nome_Local) 
		From 
			Tmp_Mov_Cargas_FCL as TMP
		Where
			StrMachine = @StrMachine and 
			Modal = 'IM'

	End 

	If @Modal = 'EM' or @Modal = ''
		Begin 
		Update 
			Tmp_Mov_Cargas_FCL 
		Set 
			Qtd_CC_20 = (Select Count(*) as Containers20 From 
					House_Exp_Mar as HEM Join Master_Exp_Mar as MEM on MEM.Num_Proc_MEM = HEM.Num_Proc_MEM
					Join Container_Mas_Exp_Mar as CC20 on CC20.Num_Proc_MEM = HEM.Num_Proc_MEM and CC20.Cd_Tp_Cont Like '%20%'
					Join Localidade as Origem on Origem.Cd_Local = HEM.Cd_Org_HEM 
					Join Localidade as Destino on Destino.Cd_Local = HEM.Cd_Dst_HEM 
					Join Pessoa as Cliente on Cliente.Cd_Pes = HEM.Cd_Export_HEM
				Where 
					Origem.Nome_Local = TMP.Origem  and 
					Destino.Nome_Local = TMP.Destino  and 
					Cliente.Apelido = TMP.Cliente and 
					HEM.Num_Proc_MEM In 
		
					(Select Distinct Num_Proc_MEM From Container_Mas_Exp_Mar Where Cd_Tp_Cont <> 'LCL' and Cd_Tp_Cont <> 'BB') and
					Convert(Datetime, MEM.Dt_Saida_MEM, 105) between @Data1 and @Data2 and 
					Origem.Nome_Local like @Origem and Destino.Nome_Local Like @Destino and 
					Cliente.Apelido like @Cliente
				Group by 
					Cliente.Apelido, Origem.Nome_Local, Destino.Nome_Local) 
		From 
			Tmp_Mov_Cargas_FCL as TMP
		Where
			StrMachine = @StrMachine and 
			Modal = 'EM'
		
		
		
		Update 
			Tmp_Mov_Cargas_FCL 
		Set 
			Qtd_CC_40 = (Select Count(*) as Containers40 From 
					House_Exp_Mar as HEM Join Master_Exp_Mar as MEM on MEM.Num_Proc_MEM = HEM.Num_Proc_MEM
					Join Container_Mas_Exp_Mar as CC20 on CC20.Num_Proc_MEM = HEM.Num_Proc_MEM and CC20.Cd_Tp_Cont Like '%40%'
					Join Localidade as Origem on Origem.Cd_Local = HEM.Cd_Org_HEM 
					Join Localidade as Destino on Destino.Cd_Local = HEM.Cd_Dst_HEM 
					Join Pessoa as Cliente on Cliente.Cd_Pes = HEM.Cd_Export_HEM
				Where 
					Origem.Nome_Local = TMP.Origem  and 
					Destino.Nome_Local = TMP.Destino  and 
					Cliente.Apelido = TMP.Cliente and 
					HEM.Num_Proc_MEM  In 
					(Select Distinct Num_Proc_MEM From Container_Mas_Exp_Mar Where Cd_Tp_Cont <> 'LCL' and Cd_Tp_Cont <> 'BB') and
					Convert(Datetime, MEM.Dt_Saida_MEM, 105) between @Data1 and @Data2 and 
					Origem.Nome_Local like @Origem and Destino.Nome_Local Like @Destino and 
					Cliente.Apelido like @Cliente
				Group by 
					Cliente.Apelido, Origem.Nome_Local, Destino.Nome_Local) 
		From 
			Tmp_Mov_Cargas_FCL as TMP
		Where
			StrMachine = @StrMachine and 
			Modal = 'EM'
	End

GO
