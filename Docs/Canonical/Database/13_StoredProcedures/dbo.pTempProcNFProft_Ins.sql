SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[pTempProcNFProft_Ins] 
(
@Num_Proc		VarChar(16),
@NF			Int,
@Site 			Char(1),
@Paridade		Float=0 OUTPUT,	
@Proft			Float=0 OUTPUT,	
@ValorTotal		Float=0 OUTPUT 	
)
 AS
	Declare @FreteMaster		Float
	Declare @Frete			Float 
	Declare @ProfitAgente		Float	
	Declare @ProfitAgenteRS	Float	
	If Left(@Num_Proc, 2) = 'EM'
		Begin 
			If IsNull((Select Count(*) From Cta_Cte_Hou_Exp_Mar Where Num_Proc_HEM = @Num_Proc and Cd_Tp_Tx in ('PBD','DVC','PSA','SAF') and DC_HEM = 'D'  and Num_NF_HEM = @NF and Ref_Acesso_NF_HEM = @Site AND Num_Proc_HEM = @Num_Proc ),0) > 0 
				Begin 
					Set @Proft = (Select 
							Sum(Cte.Vlr_Pgto_NF_HEM)  
						From 
							House_Exp_Mar as HEM  Join  Cta_Cte_Hou_Exp_Mar as Cte on (HEM.Num_Proc_HEM = Cte.Num_Proc_HEM)
						Where
							Cte.Num_NF_HEM = @NF and 
							Cte.DC_HEM = 'D'  and 
							Ref_Acesso_NF_HEM = @Site and  
							Cte.Num_Proc_HEM = @Num_Proc and 
							Cte.Cd_Tp_Tx  In 
							('PBD','DVC','PSA','SAF'))
					Set @Paridade = (Select  
							Avg(Cte.Par_NF_HEM) 
						From 
							Cta_Cte_Hou_Exp_Mar as Cte 
						Where
							Cte.Num_Proc_HEM = @Num_Proc and 
							Cte.Cd_Tp_Tx  in ('PBD','DVC','PSA','SAF')  and 
							Cte.DC_HEM = 'D' and 
							Cte.Par_NF_HEM Is Not Null
						Group by 
							Cte.Par_NF_HEM) 
						Set @ProfitAgente = @Proft / ((IsNull((Select  Perc_DL From Master_Exp_Mar as MEM Left Outer Join Div_lucro as DL On (DL.Nivel_DL = MEM.Nivel_DL) Where MEM.Num_Proc_MEM = Left(@Num_Proc, 14)),0))/100)
						Set @Proft = @ProfitAgente - @Proft 
						Update Cta_Cte_Hou_Exp_Mar Set Vlr_Pgto_NF_HEM = @ProfitAgente , Par_NF_HEM= @Paridade, Num_NF_HEM = @NF, Ref_Acesso_NF_HEM = @Site  Where Num_Proc_HEM = @Num_Proc and Cd_Tp_Tx = 'FRT' and DC_HEM = 'C'
						Exec pTotalizaNF @NF, @Site, @TotalNF = @ValorTotal
				End 
			Else
				Begin 
					Set @Proft = 0 
				End 
		End 
	If Left(@Num_Proc, 2) = 'EA'
		Begin 
			If IsNull((Select Count(*) From Cta_Cte_Hou_Exp_Aer Where Num_Proc_HEA = @Num_Proc and Cd_Tp_Tx in ('PBD','DVC','PSA','SAF') and DC_HEA = 'D' and Num_NF_HEA = @NF and Ref_Acesso_NF_HEA = @Site and Num_Proc_HEA = @Num_Proc ),0) > 0 
				Begin 
					Set @Proft = (Select 
							Valor = 
								Sum(Cte.Vlr_Pgto_NF_HEA)  
						From 
							House_Exp_Aer as HEA  Join  Cta_Cte_Hou_Exp_Aer as Cte on (HEA.Num_Proc_HEA = Cte.Num_Proc_HEA)
						Where
							Cte.Num_NF_HEA = @NF and 
							Cte.DC_HEA = 'D'  and
							Ref_Acesso_NF_HEA = @Site and  
							Cte.Num_Proc_HEA = @Num_Proc and 
							Cte.Cd_Tp_Tx  In 
							('PBD','DVC','PSA','SAF'))
					Set @Paridade = (Select  
							Avg(Cte.Par_NF_HEA) 
						From 
							Cta_Cte_Hou_Exp_Aer as Cte 
						Where
							Cte.Num_Proc_HEA = @Num_Proc and 
							Cte.Cd_Tp_Tx  in ('PBD','DVC','PSA','SAF')  and 
							Cte.DC_HEA = 'D' and 
							Cte.Par_NF_HEA Is Not Null
						Group by 
							Cte.Par_NF_HEA) 
						Set @ProfitAgente = @Proft / ((IsNull((Select  Perc_DL From Master_Exp_Aer as MEA Left Outer Join Div_lucro as DL On (DL.Nivel_DL = MEA.Nivel_DL) Where MEA.Num_Proc_MEA = Left(@Num_Proc, 14)),0))/100)
						Set @Proft = @ProfitAgente - @Proft 
						Update Cta_Cte_Hou_Exp_Aer Set Vlr_Pgto_NF_HEA = @ProfitAgente, Par_NF_HEA= @Paridade, Num_NF_HEA = @NF, Ref_Acesso_NF_HEA = @Site   Where Num_Proc_HEA = @Num_Proc and Cd_Tp_Tx = 'FRT' and DC_HEA = 'C'
						Exec pTotalizaNF @NF, @Site, @TotalNF = @ValorTotal
				End 
			Else
				Begin 
					Set @Proft = 0 
				End 
		End



GO
