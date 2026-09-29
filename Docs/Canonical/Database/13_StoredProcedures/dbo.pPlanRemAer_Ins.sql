SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pPlanRemAer_Ins  
(
@Remessa		VarChar(12),
@StrMachine		VarChar(25)
)
AS

Declare @Num_Proc 		VarChar(16)
Declare @Master		VarChar(25)
Declare @Ref_Intern		VarChar(20)
Declare @House		VarChar(25) 
Declare @Tp_Frete		Char(1) 
Declare @Frete_Moeda		Float 
Declare @Profit_Moeda		Float 
Declare @Remit_Moeda		Float 
Declare @Frete_RS		Float 
Declare @Profit_RS		Float 
Declare @Remit_RS		Float 
Declare @GainLoss		Float 

--Calculo do Frete
------------------
Declare @TxUSD		Float 
Declare @TxConv		Float 
Declare @FreteBase		Float 
Declare @MoedaFrete		VarChar(3) 

--Outras Taxas do Cta_Cte 
----------------------------
Declare @Vlr_Pgt_Rct		Float
Declare @Moeda_Cta		VarChar(3)
Declare	@Paridade		Float 
Declare @Cd_Tp_Tx		VarChar(3) 
Declare @DC			Char(1) 
Declare @Vlr_Org		Float 
Declare @DN			Char(1)
Declare @CN			Char(1) 



Declare @Vlr_Pgt_Rct_Inv	Float
Declare @Moeda_Cta_Inv	VarChar(3)
Declare	@Paridade_Inv		Float 

Delete Tmp_Plan_Rem Where StrMachine = @StrMachine 

Declare Cur_Remessa Cursor For 
	Select 
		Distinct HIA.Num_Proc_HIA, Ref_Int_MIA,  MIA.MAWB_MIA, HIA.HAWB_HIA 
	From 
		Caixa_Hou_Imp_Aer as Cxa Join House_Imp_Aer as HIA on (HIA.Num_Proc_HIA = Cxa.Num_Proc_HIA)
		Left Outer Join Master_Imp_Aer as MIA on MIA.Num_Proc_MIA = HIA.Num_Proc_MIA 
	Where 
		Num_Rcb_HIA = @Remessa 

Set @TxUSD = (Select Tx_Dol_RA From Remessa_Aer Where Num_Ref_Ra = @Remessa)
Set @TxConv = (Select Tx_Conv_RA From Remessa_Aer Where Num_Ref_Ra = @Remessa)

Open Cur_Remessa 
Fetch Next From Cur_Remessa Into @Num_Proc, @Ref_Intern, @Master, @House 

While @@Fetch_Status = 0 
	Begin 
		Set @Tp_Frete = ''
		Set @Frete_Moeda = 0 
		Set @Profit_Moeda = 0 
		Set @Remit_Moeda = 0 
		Set @Frete_RS = 0 
		Set @Profit_RS = 0 
		Set @Remit_RS = 0 
		Set @GainLoss = 0 
		Set @FreteBase = 0 


		If Not Exists(Select * From Caixa_Hou_Imp_Aer Where Num_Proc_HIA = @Num_Proc and Cd_Tp_Tx = 'FRT' and DC_HIA = 'D' and Num_Lcto <> 'PROVISÓRIO')		
			Begin 
				If Not Exists(Select Num_Proc_HIA From Cta_Cte_Hou_Imp_Aer Where Num_Proc_HIA = @Num_Proc and Cd_Tp_Tx = 'FRT' and Desp_Org_HIA = 'S')
					Set @Tp_Frete = 'C' 
				Else
					Set @Tp_Frete = 'P'

				Set @Frete_RS = 0 
				Set @Frete_Moeda = 0 

			End 
		Else 
			Begin 
				Set @Tp_Frete = 'C'	
				--Set @FreteBase = (Select SUM(Vlr_Org_HIA) From Cta_Cte_Hou_Imp_Aer Where Num_Proc_HIA = @Num_Proc and DC_HIA = 'D' and (Cd_Tp_Tx = 'FRT' or Cd_Tp_Tx = 'FRC'))
				Set @FreteBase = (Select SUM(Vlr_Ref_HIA) From Caixa_Hou_Imp_Aer Where Num_Proc_HIA = @Num_Proc and DC_HIA = 'D' and (Cd_Tp_Tx = 'FRT' or Cd_Tp_Tx = 'FRC'))
				Set @MoedaFrete = (Select Cd_Tp_Moeda From Cta_Cte_Hou_Imp_Aer Where Num_Proc_HIA = @Num_Proc and Cd_Tp_Tx = 'FRT' and DC_HIA = 'D')
			End 

		
		If @Tp_Frete = 'P' 
			Begin 
				Set @Frete_RS = 0 
				Set @Frete_Moeda = 0 
			End 
		Else
			Begin 	
				If @MoedaFrete = 'USD'
					Begin 
						Set @Frete_Moeda = @FreteBase * @TxUSD
						Set @Frete_RS = (Select sum(Vlr_Pgto_Rcto_HIA) From Caixa_Hou_Imp_Aer Where Num_Proc_HIA = @Num_Proc and Cd_Tp_Tx in ('FRT','FRC') and DC_HIA = 'D')		
					End 
				Else
					Begin 
						Set @Frete_Moeda = @FreteBase 						
						Set @Frete_RS = IsNull((Select sum(Vlr_Pgto_Rcto_HIA) From Caixa_Hou_Imp_Aer Where Num_Proc_HIA = @Num_Proc and Cd_Tp_Tx in ('FRT','FRC') and DC_HIA = 'D'),0)
					End 
			End 							


		Set @Remit_Moeda = @Frete_Moeda

		Declare Cur_Cta Cursor For 
			Select 
				Cxa.Vlr_Pgto_Rcto_HIA, Cte.Cd_Tp_Moeda, Cxa.Par_Moeda_HIA, Cte.Cd_Tp_Tx, Cte.DC_HIA, Cxa.Vlr_Ref_HIA, Cte.Comp_DN_HIA, Cte.Comp_CN_HIA 
			From 
				Caixa_Hou_Imp_Aer as Cxa  Join Cta_Cte_Hou_Imp_Aer as Cte on Cte.Num_Proc_HIA = Cxa.Num_Proc_HIA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cte.Dc_HIA = Cxa.DC_HIA 
			Where
				Cxa.Num_Proc_HIA = @Num_Proc and Cxa.Num_Rcb_HIA = @Remessa and Num_Lcto <> 'PROVISÓRIO'

		Open Cur_Cta 
		Fetch Next From Cur_Cta into @Vlr_Pgt_Rct, @Moeda_Cta, @Paridade, @Cd_Tp_Tx, @DC, @Vlr_Org, @DN, @CN
		While @@Fetch_Status = 0 
			Begin 
				If @DC = 'D' 
					Set @Remit_RS = @Remit_RS + @Vlr_Pgt_Rct 
				Else
					Begin 
						Set @Remit_RS = (@Remit_RS - @Vlr_Pgt_Rct) 
						Set @Profit_RS = @Profit_RS - @Vlr_Pgt_Rct
					End 
				
				If @Cd_TP_Tx <> 'FRT' and @Cd_Tp_Tx <> 'FRC' or (@CD_TP_TX = 'FRT' and (@DN='S' or @CN='S'))
					Begin 
						If @DC = 'D'		
							Begin 
								If @Moeda_Cta = 'USD'
									Set @Remit_Moeda = @Remit_Moeda + (@Vlr_Org * @TxUSD * @TxConv )
								Else
									Set @Remit_Moeda = @Remit_Moeda + @Vlr_Org

								Set @Profit_RS = @Profit_RS + @Vlr_Pgt_Rct
							End 
						Else		
							Begin 						
								If @Moeda_Cta = 'USD'
									Set @Remit_Moeda = @Remit_Moeda - (@Vlr_Org * @TxUSD * @TxConv)
								Else
									Set @Remit_Moeda = @Remit_Moeda - @Vlr_Org
							End 
					
					End 
				If @Cd_Tp_Tx Not in ('PBD','PSA','DES','DSC','FCA','CLC')	
					Begin 
						If @DC = 'D' 
							Begin 
								If Exists(Select Vlr_Pgto_Rcto_HIA From Caixa_Hou_Imp_Aer Where Num_Proc_HIA = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HIA = 'C' and Num_Lcto <> 'PROVISÓRIO') 
 									Begin 
										Set @Vlr_Pgt_Rct_Inv = IsNull((Select Vlr_Pgto_Rcto_HIA From Caixa_Hou_Imp_Aer Where Num_Proc_HIA = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HIA = 'C' and Num_Lcto <> 'PROVISÓRIO'),0)
										Set @Moeda_Cta_Inv = (Select Cd_Tp_Moeda From Caixa_Hou_Imp_Aer as Cxa Join Cta_Cte_Hou_Imp_Aer as Cte on (Cte.Num_Proc_HIA = Cxa.Num_Proc_HIA and Cte.DC_HIA = Cxa.DC_HIA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx) Where Cxa.Num_Proc_HIA = @Num_Proc and Cxa.Cd_Tp_Tx = @Cd_Tp_Tx and Cxa.DC_HIA = 'C' and Num_Lcto <> 'PROVISÓRIO' )
										Set @Paridade_Inv = (Select Par_Moeda_HIA From Caixa_Hou_Imp_Aer Where Num_Proc_HIA = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HIA = 'C' and Num_Lcto <> 'PROVISÓRIO')
										If @Moeda_Cta = @Moeda_Cta_Inv 
											Begin 
												Set @GainLoss = @GainLoss + ((@Paridade_Inv - @Paridade)* @Vlr_Org)
											End  
										Else
											Begin 
												Set @GainLoss = @GainLoss +  @Vlr_Pgt_Rct_Inv - @Vlr_Pgt_Rct
											End 
									End 
								Else
									Begin 
										Set @Vlr_Pgt_Rct_Inv = IsNull((Select Vlr_Pgto_Rcto_MIA From Caixa_Mas_Imp_Aer Where Num_Proc_MIA = Left(@Num_Proc, 14) and Cd_Tp_Tx = @Cd_Tp_Tx and DC_MIA = 'C' and Num_Lcto <> 'PROVISÓRIO'),0)
										Set @Moeda_Cta_Inv = (Select Cd_Tp_Moeda From Caixa_Mas_Imp_Aer as Cxa Join Cta_Cte_Mas_Imp_Aer as Cte on (Cte.Num_Proc_MIA = Cxa.Num_Proc_MIA and Cte.DC_MIA = Cxa.DC_MIA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx) Where Cxa.Num_Proc_MIA = Left(@Num_Proc, 14) and Cxa.Cd_Tp_Tx = @Cd_Tp_Tx and Cxa.DC_MIA = 'C' and Num_Lcto <> 'PROVISÓRIO')
										Set @Paridade_Inv = (Select Par_Moeda_MIA From Caixa_Mas_Imp_Aer Where Num_Proc_MIA = Left(@Num_Proc, 14) and Cd_Tp_Tx = @Cd_Tp_Tx and DC_MIA = 'C' and Num_Lcto <> 'PROVISÓRIO')
										If @Moeda_Cta = @Moeda_Cta_Inv 
											Begin 
												Set @GainLoss = @GainLoss + ((@Paridade_Inv - @Paridade)* @Vlr_Org)
											End  
										Else
											Begin 
												Set @GainLoss = @GainLoss +  @Vlr_Pgt_Rct_Inv - @Vlr_Pgt_Rct
											End 
									End 
							End 
						Else
							Begin 
								IF Exists(Select Vlr_Pgto_Rcto_HIA From Caixa_Hou_Imp_Aer Where Num_Proc_HIA = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HIA = 'D' and Num_Lcto <> 'PROVISÓRIO') 
 									Begin 
										Set @Vlr_Pgt_Rct_Inv = IsNull((Select Vlr_Pgto_Rcto_HIA From Caixa_Hou_Imp_Aer Where Num_Proc_HIA = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HIA = 'D' and Num_Lcto <> 'PROVISÓRIO'),0 )
										Set @Moeda_Cta_Inv = (Select Cd_Tp_Moeda From Caixa_Hou_Imp_Aer as Cxa Join Cta_Cte_Hou_Imp_Aer as Cte on (Cte.Num_Proc_HIA = Cxa.Num_Proc_HIA and Cte.DC_HIA = Cxa.DC_HIA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx) Where Cxa.Num_Proc_HIA = @Num_Proc and Cxa.Cd_Tp_Tx = @Cd_Tp_Tx and Cxa.DC_HIA = 'D' and Num_Lcto <> 'PROVISÓRIO')
										Set @Paridade_Inv = (Select Par_Moeda_HIA From Caixa_Hou_Imp_Aer Where Num_Proc_HIA = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HIA = 'D' and Num_Lcto <> 'PROVISÓRIO')
										If @Moeda_Cta = @Moeda_Cta_Inv 
											Begin 
												Set @GainLoss = @GainLoss + ((@Paridade - @Paridade_Inv)* @Vlr_Org)
											End  
										Else
											Begin 
												Set @GainLoss = @GainLoss +   @Vlr_Pgt_Rct - @Vlr_Pgt_Rct_Inv
											End 
									End 
								Else
									Begin 
										Set @Vlr_Pgt_Rct_Inv = IsNull((Select Vlr_Pgto_Rcto_MIA From Caixa_Mas_Imp_Aer Where Num_Proc_MIA = Left(@Num_Proc, 14) and Cd_Tp_Tx = @Cd_Tp_Tx and DC_MIA = 'D' and Num_Lcto <> 'PROVISÓRIO'),0 )
										Set @Moeda_Cta_Inv = (Select Cd_Tp_Moeda From Caixa_Mas_Imp_Aer as Cxa Join Cta_Cte_Mas_Imp_Aer as Cte on (Cte.Num_Proc_MIA = Cxa.Num_Proc_MIA and Cte.DC_MIA = Cxa.DC_MIA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx) Where Cxa.Num_Proc_MIA = Left(@Num_Proc, 14) and Cxa.Cd_Tp_Tx = @Cd_Tp_Tx and Cxa.DC_MIA = 'D' and Num_Lcto <> 'PROVISÓRIO')
										Set @Paridade_Inv = (Select Par_Moeda_MIA From Caixa_Mas_Imp_Aer Where Num_Proc_MIA = Left(@Num_Proc, 14) and Cd_Tp_Tx = @Cd_Tp_Tx and DC_MIA = 'D' and Num_Lcto <> 'PROVISÓRIO')
										If @Moeda_Cta = @Moeda_Cta_Inv 
											Begin 
												Set @GainLoss = @GainLoss + ((@Paridade - @Paridade_Inv)* @Vlr_Org)
											End  
										Else
											Begin 
												Set @GainLoss = @GainLoss +  @Vlr_Pgt_Rct - @Vlr_Pgt_Rct_Inv
											End 
									End 
							End 

					End 
				Fetch Next From Cur_Cta into @Vlr_Pgt_Rct, @Moeda_Cta, @Paridade, @Cd_Tp_Tx, @DC, @Vlr_Org, @DN, @CN
			End 
			Close Cur_Cta
			Deallocate Cur_Cta
			Insert Into Tmp_Plan_Rem Values
			(Left(@Num_Proc, 14), @Master, @Ref_Intern, @House, @Tp_Frete, @Frete_Moeda, @Profit_Moeda, @Remit_Moeda, @Frete_RS, (@Profit_RS)*(-1), (@Remit_RS), @GainLoss, @StrMachine)

		Fetch Next From Cur_Remessa Into @Num_Proc, @Ref_Intern, @Master, @House 

	End 
	Close Cur_Remessa
	Deallocate Cur_Remessa

Declare Cur_Remessa Cursor For 
	Select 
		Distinct HEA.Num_Proc_HEA, '' as Ref_Int_MEA,  MEA.MAWB_MEA, HEA.HAWB_HEA 
	From 
		Caixa_Hou_Exp_Aer as Cxa Join House_Exp_Aer as HEA on (HEA.Num_Proc_HEA = Cxa.Num_Proc_HEA)
		Left Outer Join Master_Exp_Aer as MEA on MEA.Num_Proc_MEA = HEA.Num_Proc_MEA 
	Where 
		Num_Rcb_HEA = @Remessa 

Set @TxUSD = (Select Tx_Dol_RA From Remessa_Aer Where Num_Ref_Ra = @Remessa)
Set @TxConv = (Select Tx_Conv_RA From Remessa_Aer Where Num_Ref_Ra = @Remessa)

Open Cur_Remessa 
Fetch Next From Cur_Remessa Into @Num_Proc, @Ref_Intern, @Master, @House 

While @@Fetch_Status = 0 
	Begin 
		Set @Tp_Frete = ''
		Set @Frete_Moeda = 0 
		Set @Profit_Moeda = 0 
		Set @Remit_Moeda = 0 
		Set @Frete_RS = 0 
		Set @Profit_RS = 0 
		Set @Remit_RS = 0 
		Set @GainLoss = 0 

		If Not Exists(Select * From Caixa_Hou_Exp_Aer Where Num_Proc_HEA = @Num_Proc and Cd_Tp_Tx = 'FRT' and DC_HEA = 'D' and Num_Lcto <> 'PROVISÓRIO')		
			Begin 
				If Not Exists(Select Num_Proc_HEA From Cta_Cte_Hou_Exp_Aer Where Num_Proc_HEA = @Num_Proc and Cd_Tp_Tx = 'FRT' and Desp_Dst_HEA = 'S')
					Set @Tp_Frete = 'C' 
				Else
					Set @Tp_Frete = 'P'
			End 
		Else 
			Begin 
				Set @Tp_Frete = 'C'	
				--Set @FreteBase = (Select Sum(Vlr_Org_HEA) From Cta_Cte_Hou_Exp_Aer Where Num_Proc_HEA = @Num_Proc and Cd_Tp_Tx in ('FRT', 'FRC') and DC_HEA = 'D')
				Set @FreteBase = (Select Sum(Vlr_Ref_HEA) From Caixa_Hou_Exp_Aer Where Num_Proc_HEA = @Num_Proc and Cd_Tp_Tx in ('FRT', 'FRC') and DC_HEA = 'D')
				Set @MoedaFrete = (Select Cd_Tp_Moeda From Cta_Cte_Hou_Exp_Aer Where Num_Proc_HEA = @Num_Proc and Cd_Tp_Tx = 'FRT' and DC_HEA = 'D')
			End 
		
		If @Tp_Frete = 'P' 
			Begin 
				Set @Frete_RS = 0 
				Set @Frete_Moeda = 0 
			End 
		Else
			Begin 	
				If @MoedaFrete = 'USD'
					Begin 
						Set @Frete_Moeda = @FreteBase * @TxUSD
						Set @Frete_RS = (Select sum(Vlr_Pgto_Rcto_HEA) From Caixa_Hou_Exp_Aer Where Num_Proc_HEA = @Num_Proc and Cd_Tp_Tx in ('FRT','FRC') and DC_HEA = 'D')		
					End 
				Else
					Begin 
						Set @Frete_Moeda = @FreteBase 						
						Set @Frete_RS = IsNull((Select sum(Vlr_Pgto_Rcto_HEA) From Caixa_Hou_Exp_Aer Where Num_Proc_HEA = @Num_Proc and Cd_Tp_Tx in ('FRT','FRC') and DC_HEA = 'D'),0)
					End 
			End 							

		Set @Remit_Moeda = @Frete_Moeda

		Declare Cur_Cta Cursor For 
			Select 
				Cxa.Vlr_Pgto_Rcto_HEA, Cte.Cd_Tp_Moeda, Cxa.Par_Moeda_HEA, Cte.Cd_Tp_Tx, Cte.DC_HEA, Cxa.Vlr_Ref_HEA, Cte.Comp_DN_HEA, Cte.Comp_CN_HEA 
			From 
				Caixa_Hou_Exp_Aer as Cxa  Join Cta_Cte_Hou_Exp_Aer as Cte on Cte.Num_Proc_HEA = Cxa.Num_Proc_HEA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cte.Dc_HEA = Cxa.DC_HEA 
			Where
				Cxa.Num_Proc_HEA = @Num_Proc and Cxa.Num_Rcb_HEA = @Remessa and Num_Lcto <> 'PROVISÓRIO'

		Open Cur_Cta 
		Fetch Next From Cur_Cta into @Vlr_Pgt_Rct, @Moeda_Cta, @Paridade, @Cd_Tp_Tx, @DC, @Vlr_Org, @DN, @CN
		While @@Fetch_Status = 0 
			Begin 
				If @DC = 'D' 
					Set @Remit_RS = @Remit_RS + @Vlr_Pgt_Rct 
				Else
					Begin 
						Set @Remit_RS = (@Remit_RS - @Vlr_Pgt_Rct) 
						Set @Profit_RS = @Profit_RS - @Vlr_Pgt_Rct
					End 
				
				If @Cd_TP_Tx <> 'FRT' and @Cd_Tp_Tx <> 'FRC' or (@CD_TP_TX = 'FRT' and (@DN='S' or @CN='S'))
					Begin 
						If @DC = 'D'		
							Begin 
								If @Moeda_Cta = 'USD'
									Set @Remit_Moeda = @Remit_Moeda + (@Vlr_Org * @TxUSD * @TxConv )
								Else
									Set @Remit_Moeda = @Remit_Moeda + @Vlr_Org

								Set @Profit_RS = @Profit_RS + @Vlr_Pgt_Rct
							End 
						Else		
							Begin 						
								If @Moeda_Cta = 'USD'
									Set @Remit_Moeda = @Remit_Moeda - (@Vlr_Org * @TxUSD * @TxConv)
								Else
									Set @Remit_Moeda = @Remit_Moeda - @Vlr_Org
							End 
					
					End 
				If @Cd_Tp_Tx Not in ('PBD','PSA','DES','DSC','FCA','CLC')	
					Begin 
						If @DC = 'D' 
							Begin 
								If Exists(Select Vlr_Pgto_Rcto_HEA From Caixa_Hou_Exp_Aer Where Num_Proc_HEA = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HEA = 'C' and Num_Lcto <> 'PROVISÓRIO') 
 									Begin 
										Set @Vlr_Pgt_Rct_Inv = IsNull((Select Vlr_Pgto_Rcto_HEA From Caixa_Hou_Exp_Aer Where Num_Proc_HEA = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HEA = 'C' and Num_Lcto <> 'PROVISÓRIO'),0)
										Set @Moeda_Cta_Inv = (Select Cd_Tp_Moeda From Caixa_Hou_Exp_Aer as Cxa Join Cta_Cte_Hou_Exp_Aer as Cte on (Cte.Num_Proc_HEA = Cxa.Num_Proc_HEA and Cte.DC_HEA = Cxa.DC_HEA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx) Where Cxa.Num_Proc_HEA = @Num_Proc and Cxa.Cd_Tp_Tx = @Cd_Tp_Tx and Cxa.DC_HEA = 'C' and Num_Lcto <> 'PROVISÓRIO' )
										Set @Paridade_Inv = (Select Par_Moeda_HEA From Caixa_Hou_Exp_Aer Where Num_Proc_HEA = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HEA = 'C' and Num_Lcto <> 'PROVISÓRIO')
										If @Moeda_Cta = @Moeda_Cta_Inv 
											Begin 
												Set @GainLoss = @GainLoss + ((@Paridade_Inv - @Paridade)* @Vlr_Org)
											End  
										Else
											Begin 
												Set @GainLoss = @GainLoss +  @Vlr_Pgt_Rct_Inv - @Vlr_Pgt_Rct
											End 
									End 
								Else
									Begin 
										Set @Vlr_Pgt_Rct_Inv = IsNull((Select Vlr_Pgto_Rcto_MEA From Caixa_Mas_Exp_Aer Where Num_Proc_MEA = Left(@Num_Proc, 14) and Cd_Tp_Tx = @Cd_Tp_Tx and DC_MEA = 'C' and Num_Lcto <> 'PROVISÓRIO'),0)
										Set @Moeda_Cta_Inv = (Select Cd_Tp_Moeda From Caixa_Mas_Exp_Aer as Cxa Join Cta_Cte_Mas_Exp_Aer as Cte on (Cte.Num_Proc_MEA = Cxa.Num_Proc_MEA and Cte.DC_MEA = Cxa.DC_MEA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx) Where Cxa.Num_Proc_MEA = Left(@Num_Proc, 14) and Cxa.Cd_Tp_Tx = @Cd_Tp_Tx and Cxa.DC_MEA = 'C' and Num_Lcto <> 'PROVISÓRIO')
										Set @Paridade_Inv = (Select Par_Moeda_MEA From Caixa_Mas_Exp_Aer Where Num_Proc_MEA = Left(@Num_Proc, 14) and Cd_Tp_Tx = @Cd_Tp_Tx and DC_MEA = 'C' and Num_Lcto <> 'PROVISÓRIO')
										If @Moeda_Cta = @Moeda_Cta_Inv 
											Begin 
												Set @GainLoss = @GainLoss + ((@Paridade_Inv - @Paridade)* @Vlr_Org)
											End  
										Else
											Begin 
												Set @GainLoss = @GainLoss +  @Vlr_Pgt_Rct_Inv - @Vlr_Pgt_Rct
											End 
									End 
							End 
						Else
							Begin 
								IF Exists(Select Vlr_Pgto_Rcto_HEA From Caixa_Hou_Exp_Aer Where Num_Proc_HEA = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HEA = 'D' and Num_Lcto <> 'PROVISÓRIO') 
 									Begin 
										Set @Vlr_Pgt_Rct_Inv = IsNull((Select Vlr_Pgto_Rcto_HEA From Caixa_Hou_Exp_Aer Where Num_Proc_HEA = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HEA = 'D' and Num_Lcto <> 'PROVISÓRIO'),0 )
										Set @Moeda_Cta_Inv = (Select Cd_Tp_Moeda From Caixa_Hou_Exp_Aer as Cxa Join Cta_Cte_Hou_Exp_Aer as Cte on (Cte.Num_Proc_HEA = Cxa.Num_Proc_HEA and Cte.DC_HEA = Cxa.DC_HEA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx) Where Cxa.Num_Proc_HEA = @Num_Proc and Cxa.Cd_Tp_Tx = @Cd_Tp_Tx and Cxa.DC_HEA = 'D' and Num_Lcto <> 'PROVISÓRIO')
										Set @Paridade_Inv = (Select Par_Moeda_HEA From Caixa_Hou_Exp_Aer Where Num_Proc_HEA = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HEA = 'D' and Num_Lcto <> 'PROVISÓRIO')
										If @Moeda_Cta = @Moeda_Cta_Inv 
											Begin 
												Set @GainLoss = @GainLoss + ((@Paridade - @Paridade_Inv)* @Vlr_Org)
											End  
										Else
											Begin 
												Set @GainLoss = @GainLoss +   @Vlr_Pgt_Rct - @Vlr_Pgt_Rct_Inv
											End 
									End 
								Else
									Begin 
										Set @Vlr_Pgt_Rct_Inv = IsNull((Select Vlr_Pgto_Rcto_MEA From Caixa_Mas_Exp_Aer Where Num_Proc_MEA = Left(@Num_Proc, 14) and Cd_Tp_Tx = @Cd_Tp_Tx and DC_MEA = 'D' and Num_Lcto <> 'PROVISÓRIO'),0 )
										Set @Moeda_Cta_Inv = (Select Cd_Tp_Moeda From Caixa_Mas_Exp_Aer as Cxa Join Cta_Cte_Mas_Exp_Aer as Cte on (Cte.Num_Proc_MEA = Cxa.Num_Proc_MEA and Cte.DC_MEA = Cxa.DC_MEA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx) Where Cxa.Num_Proc_MEA = Left(@Num_Proc, 14) and Cxa.Cd_Tp_Tx = @Cd_Tp_Tx and Cxa.DC_MEA = 'D' and Num_Lcto <> 'PROVISÓRIO')
										Set @Paridade_Inv = (Select Par_Moeda_MEA From Caixa_Mas_Exp_Aer Where Num_Proc_MEA = Left(@Num_Proc, 14) and Cd_Tp_Tx = @Cd_Tp_Tx and DC_MEA = 'D' and Num_Lcto <> 'PROVISÓRIO')
										If @Moeda_Cta = @Moeda_Cta_Inv 
											Begin 
												Set @GainLoss = @GainLoss + ((@Paridade - @Paridade_Inv)* @Vlr_Org)
											End  
										Else
											Begin 
												Set @GainLoss = @GainLoss +  @Vlr_Pgt_Rct - @Vlr_Pgt_Rct_Inv
											End 
									End 
							End 

					End 
				Fetch Next From Cur_Cta into @Vlr_Pgt_Rct, @Moeda_Cta, @Paridade, @Cd_Tp_Tx, @DC, @Vlr_Org, @DN, @CN
			End 
			Close Cur_Cta
			Deallocate Cur_Cta
			Insert Into Tmp_Plan_Rem Values
			(Left(@Num_Proc, 14), @Master, @Ref_Intern, @House, @Tp_Frete, @Frete_Moeda, @Profit_Moeda, @Remit_Moeda, @Frete_RS, (@Profit_RS)*(-1), (@Remit_RS), @GainLoss, @StrMachine)

		Fetch Next From Cur_Remessa Into @Num_Proc, @Ref_Intern, @Master, @House 
	End 
	Close Cur_Remessa
	Deallocate Cur_Remessa
GO
