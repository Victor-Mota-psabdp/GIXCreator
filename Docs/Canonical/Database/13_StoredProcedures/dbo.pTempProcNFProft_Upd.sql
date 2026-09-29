SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[pTempProcNFProft_Upd]
(
@Num_Proc		VarChar(16),
@ID_Machine		VarChar(50)
)
 AS
	Declare @FreteMaster		Float
	Declare @Frete			Float 
	Declare @Paridade 		Float
	If Left(@Num_Proc, 2) = 'EM'
		Begin 
			If IsNull((Select Count(*) From Cta_Cte_Hou_Exp_Mar Where Num_Proc_HEM = @Num_Proc and Cd_Tp_Tx in ('PBD','DVC','PSA','SAF')),0) > 0 
				Begin 
					Set @Paridade = (Select 
							Valor = 
							Case  
								When Avg(Cxa.Par_Moeda_HEM) Is Null Then Avg(Par.Par_Moeda) 
								Else Avg(Cxa.Par_Moeda_HEM)
							End 
						From 
							House_Exp_Mar as HEM  Join  Cta_Cte_Hou_Exp_Mar as Cte on (HEM.Num_Proc_HEM = Cte.Num_Proc_HEM)
							Join Master_Exp_Mar as MEM on (HEM.Num_Proc_MEM = MEM.Num_Proc_MEM )
					          	 	Left Outer Join  Caixa_Hou_Exp_Mar as Cxa on (Cte.Num_Proc_HEM = Cxa.Num_Proc_HEM and Cte.DC_HEM = Cxa.DC_HEM and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx )
							Left Outer Join Paridade as Par on (Cte.Cd_Tp_Moeda = Par.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'EXM' and Convert(DateTime, Dt_Par, 105) = Convert(DateTime, MEM.Dt_Saida_MEM, 105))
							Join Tipo_Taxa as TT on Cxa.Cd_Tp_Tx = TT.Cd_Tp_Tx
						Where
							(Cte.Num_NF_HEM Is  Null OR
							Cte.Num_NF_HEM = '') and
							Cte.Num_Proc_HEM = @Num_Proc and 
							Cte.Cd_Tp_Tx  = 'FRT'
						Group by 
							HEM.Num_Proc_HEM, Cte.Cd_Tp_Tx, Cte.DC_HEM,  Cte.Cd_Tp_Moeda,  Cte.Vlr_Org_HEM, Vlr_Pgto_Rcto_HEM)
						Set @FreteMaster = (Select  (Trf_Net_MEM * Peso_Bruto_HEM) From Master_Exp_Mar as MEM Join House_Exp_Mar as HEM on(MEM.Num_Proc_MEM= HEM.Num_Proc_MEM) Where Num_Proc_HEM = @Num_Proc)
						Set @Frete = (Select Vlr_Org_HEM From Cta_Cte_Hou_Exp_Mar Where Num_Proc_HEM = @Num_Proc and Cd_Tp_Tx = 'FRT' and DC_HEM = 'C')
				End 						
						Update  
							Temp_Recibo_NF
						Set 
							Vlr_Oficial =  @Frete  - @FreteMaster,  
							Tx_Convers = @Paridade, 
							Vlr_Pago = ((@Frete  - @FreteMaster ) * @Paridade )
						Where 
							Num_Proc = @Num_Proc and 
							Cd_Tp_Tx = 'FRT' and 
							DC = 'C' and 
							ID_Machine = @ID_Machine 
		End 
	If Left(@Num_Proc, 2) = 'EA'
		Begin 
			If IsNull((Select Count(*) From Cta_Cte_Hou_Exp_Aer Where Num_Proc_HEA = @Num_Proc and Cd_Tp_Tx in ('PBD','DVC','PSA','SAF')),0) > 0 
				Begin 
					Set @Paridade = (Select 
							Valor = 
							Case  
								When Avg(Cxa.Par_Moeda_HEA) Is Null Then Avg(Par.Par_Moeda) 
								Else Avg(Cxa.Par_Moeda_HEA)
							End 
						From 
							House_Exp_Aer as HEA  Join  Cta_Cte_Hou_Exp_Aer as Cte on (HEA.Num_Proc_HEA = Cte.Num_Proc_HEA)
							Join Master_Exp_Aer as MEA on (HEA.Num_Proc_MEA = MEA.Num_Proc_MEA )
					          	 	Left Outer Join  Caixa_Hou_Exp_Aer as Cxa on (Cte.Num_Proc_HEA = Cxa.Num_Proc_HEA and Cte.DC_HEA = Cxa.DC_HEA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx )
							Left Outer Join Paridade as Par on (Cte.Cd_Tp_Moeda = Par.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'EXM' and Convert(DateTime, Dt_Par, 105) = Convert(DateTime, MEA.Dt_Saida_MEA, 105))
							Join Tipo_Taxa as TT on Cxa.Cd_Tp_Tx = TT.Cd_Tp_Tx
						Where
							(Cte.Num_NF_HEA Is  Null OR
							Cte.Num_NF_HEA = '') and
							Cte.Num_Proc_HEA = @Num_Proc and 
							Cte.Cd_Tp_Tx  = 'FRT'
						Group by 
							HEA.Num_Proc_HEA, Cte.Cd_Tp_Tx, Cte.DC_HEA,  Cte.Cd_Tp_Moeda,  Cte.Vlr_Org_HEA, Vlr_Pgto_Rcto_HEA)
						Set @FreteMaster = (Select  (Trf_Net_MEA * Peso_Bruto_HEA) From Master_Exp_Aer as MEA Join House_Exp_Aer as HEA on(MEA.Num_Proc_MEA= HEA.Num_Proc_MEA) Where Num_Proc_HEA = @Num_Proc)
						Set @Frete = (Select Vlr_Org_HEA From Cta_Cte_Hou_Exp_Aer Where Num_Proc_HEA = @Num_Proc and Cd_Tp_Tx = 'FRT' and DC_HEA = 'C')
						Update  
							Temp_Recibo_NF
						Set 
							Vlr_Oficial =  @Frete  - @FreteMaster,  
							Tx_Convers = @Paridade, 
							Vlr_Pago = ((@Frete  - @FreteMaster ) * @Paridade )
						Where 
							Num_Proc = @Num_Proc and 
							Cd_Tp_Tx = 'FRT' and 
							DC = 'C' and 
							ID_Machine = @ID_Machine 
				End 
		End



GO
