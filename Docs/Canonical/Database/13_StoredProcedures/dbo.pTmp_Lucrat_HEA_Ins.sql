SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pTmp_Lucrat_HEA_Ins 
(
@StrMachine		VarChar(30), 
@Data01		Datetime,
@Data02		Datetime,
@Cli			VarChar(20)='%'
)
AS
Declare @Processo	Varchar(16) 
Declare @Taxa		Varchar(3) 
Declare @Cliente	Varchar(60) 

Declare @Processo_Old	Varchar(16) 
Declare @Taxa_Old	Varchar(3) 
Declare @Cliente_Old	Varchar(60)
 
Declare @Vlr_Caixa	Float 
Declare @Vlr_Caixa_Ref	Float 
Declare @Vlr_Caixa_Tot	Float 
Declare @Vlr_Cte_H	Float 
Declare @Vlr_Cte_HRef	Float 
Declare @Vlr_Cte_H_Tot	Float 
Declare @Vlr_Cte_M	Float 
Declare @Proc_Ref	VarChar(16) 
Declare @Peso_H		Float
Declare @Vlr_master 	Float 

If Not Exists(Select * From Paridade Where Cd_Tp_Moeda = 'REL' and Dt_Par = dbo.StrHoje(GetDate()) and Cd_Tp_Par = 'OFC')
	Insert Into Paridade Values (dbo.StrHoje(Getdate()), 'REL', 'OFC', 1) 

Declare Cur_HEA Cursor For
	Select Distinct HEA.Num_Proc_HEA, Cd_Tp_Tx, Cli.Nome_Raz_Soc From Cta_Cte_Hou_Exp_Aer as Cte Join House_Exp_Aer as HEA on HEA.Num_Proc_HEA = Cte.Num_Proc_HEA 
	Join Pessoa as Cli on Cli.Cd_Pes = HEA.Cd_Export_HEA Where Cli.Apelido like @Cli and Cte.Desp_Dst_HEA = 'N' and Convert(Datetime, HEA.Dt_Emis_HEA, 105) between @Data01 and @Data02  and Left(Cte.Num_Proc_HEA, 5) <> 'EAJOB'  Order by HEA.Num_Proc_HEA

Open Cur_HEA 
Set @Processo_Old = ''
Set @Vlr_Cte_H_Tot = 0
Set @Vlr_Caixa_Tot = 0
Set @Cliente = ''
Fetch Next From Cur_HEA into @Processo, @Taxa, @Cliente 
While @@Fetch_Status = 0 
	Begin 
		Set @Vlr_Caixa	= IsNull((Select Sum(Vlr_Pgto_Rcto_HEA) From Caixa_Hou_Exp_Aer Where Num_Proc_HEA = @Processo and Cd_Tp_Tx = @Taxa and DC_HEA = 'C'),0) - IsNull((Select Sum(Vlr_Pgto_Rcto_HEA) From Caixa_Hou_Exp_Aer Where Num_Proc_HEA = @Processo and Cd_Tp_Tx = @Taxa and DC_HEA = 'D'),0)
		Set @Vlr_Caixa_Ref = IsNull((Select Sum(Vlr_Ref_HEA) From Caixa_Hou_Exp_Aer Where Num_Proc_HEA = @Processo and Cd_Tp_Tx = @Taxa and DC_HEA = 'C'),0) - IsNull((Select Sum(Vlr_Ref_HEA) From Caixa_Hou_Exp_Aer Where Num_Proc_HEA = @Processo and Cd_Tp_Tx = @Taxa and DC_HEA = 'D'),0)

		Set @Vlr_Cte_H = IsNull((Select (Vlr_Org_HEA * Par_Moeda)  From Cta_Cte_Hou_Exp_Aer as Cte Join Paridade as Par on Par.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'OFC' and Par.Dt_Par =  dbo.StrHoje(GetDate()) Where Num_Proc_HEA = @Processo and Cd_Tp_Tx = @Taxa and DC_HEA = 'C'),0) - IsNull((Select (Vlr_Org_HEA * Par_Moeda)  From Cta_Cte_Hou_Exp_Aer as Cte Join Paridade as Par on Par.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'OFC' and Par.Dt_Par =  dbo.StrHoje(GetDate()) Where Num_Proc_HEA = @Processo and Cd_Tp_Tx = @Taxa and DC_HEA = 'D'),0)
		Set @Vlr_Cte_HRef = IsNull((Select Vlr_Org_HEA  From Cta_Cte_Hou_Exp_Aer as Cte Where Num_Proc_HEA = @Processo and Cd_Tp_Tx = @Taxa and DC_HEA = 'C'),0) - IsNull((Select Vlr_Org_HEA  From Cta_Cte_Hou_Exp_Aer as Cte Where Num_Proc_HEA = @Processo and Cd_Tp_Tx = @Taxa and DC_HEA = 'D'),0) 

		If @Vlr_Cte_HRef = @Vlr_Caixa_Ref 
			Set @Vlr_Cte_H = @Vlr_Caixa

		If @Processo_Old = '' 
			Set @Processo_Old = @Processo 

		If @Processo = @Processo_Old
			Begin 
				Set @Vlr_Cte_H_Tot = @Vlr_Cte_H + @Vlr_Cte_H_Tot
				Set @Vlr_Caixa_Tot = @Vlr_Caixa + @Vlr_Caixa_Tot
				Set @Cliente_Old = @Cliente

			End 
		Else
			Begin 
				Set @Vlr_Cte_M = 0
				Insert Into tmp_lucrat Values (@StrMachine, @Processo_Old, @CLiente_Old, @Vlr_Caixa_Tot, @Vlr_Cte_H_Tot, 0)
				Set @Peso_H = IsNull((Select Peso_Bruto_HEA From House_Exp_Aer Where Num_Proc_HEA = @Processo_Old),0)
				Declare CurMaster Cursor For
				Select Vlr_C = Case  When TT.Rateio_Tx = 'K' and Sum(Cxa.Vlr_Pgto_Rcto_MEA) Is Null  then ((Cte.Vlr_Org_MEA * Par.Par_Moeda)/MEA.Peso_Bruto_MEA) * @Peso_H 
						       When TT.Rateio_Tx = 'K' and Sum(Cxa.Vlr_Pgto_Rcto_MEA) Is Not Null  then ((Sum(Vlr_Pgto_Rcto_MEA))/MEA.Peso_Bruto_MEA) * @Peso_H 
						       When TT.Rateio_Tx <> 'K' and Sum(Cxa.Vlr_Pgto_Rcto_MEA) Is Null  then (Cte.Vlr_Org_MEA * Par.Par_Moeda) / MEA.Qtd_HAWB_MEA
						       When TT.Rateio_Tx <> 'K' and Sum(Cxa.Vlr_Pgto_Rcto_MEA) Is Not Null  then (Sum(Vlr_Pgto_Rcto_MEA)) / MEA.Qtd_HAWB_MEA
						 End
						 From 
							Cta_Cte_Mas_Exp_Aer as Cte Join Master_Exp_Aer as MEA on MEA.Num_Proc_MEA = Cte.Num_Proc_MEA 
							Join Tipo_Taxa as TT on TT.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
							Join Paridade as Par on Par.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'OFC' and Par.Dt_Par =  dbo.StrHoje(GetDate()) 
							Left Outer Join Caixa_Mas_Exp_Aer as Cxa on Cxa.Num_Proc_MEA = Cte.Num_Proc_MEA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx and Cxa.DC_MEA = Cte.DC_MEA
						Where 
							MEA.Num_Proc_MEA = Left(@Processo_Old, 14) and Cte.DC_MEA = 'C'  and Cte.Desp_Dst_MEA = 'N'
						Group by
							TT.Rateio_Tx, Cte.Vlr_Org_MEA, Par.Par_Moeda,  MEA.Peso_Bruto_MEA, MEA.Qtd_HAWB_MEA

				Open CurMaster 
				Fetch Next From CurMaster Into @Vlr_Master	
				While @@Fetch_Status = 0 
					Begin 
						Set @Vlr_Cte_M	= @Vlr_Cte_M + @Vlr_Master	
						Fetch Next From CurMaster Into @Vlr_Master	
					End 
				Close CurMaster 
				Deallocate CurMaster 
				Declare CurMaster Cursor For
				Select Vlr_C = Case  When TT.Rateio_Tx = 'K' and Sum(Cxa.Vlr_Pgto_Rcto_MEA) Is Null  then ((Cte.Vlr_Org_MEA * Par.Par_Moeda)/MEA.Peso_Bruto_MEA) * @Peso_H 
						       When TT.Rateio_Tx = 'K' and Sum(Cxa.Vlr_Pgto_Rcto_MEA) Is Not Null  then ((Sum(Vlr_Pgto_Rcto_MEA))/MEA.Peso_Bruto_MEA) * @Peso_H 
						       When TT.Rateio_Tx <> 'K' and Sum(Cxa.Vlr_Pgto_Rcto_MEA) Is Null  then (Cte.Vlr_Org_MEA * Par.Par_Moeda) / MEA.Qtd_HAWB_MEA
						       When TT.Rateio_Tx <> 'K' and Sum(Cxa.Vlr_Pgto_Rcto_MEA) Is Not Null  then (Sum(Vlr_Pgto_Rcto_MEA)) / MEA.Qtd_HAWB_MEA
						 End
						 From 
							Cta_Cte_Mas_Exp_Aer as Cte Join Master_Exp_Aer as MEA on MEA.Num_Proc_MEA = Cte.Num_Proc_MEA 
							Join Tipo_Taxa as TT on TT.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
							Join Paridade as Par on Par.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'OFC' and Par.Dt_Par =  dbo.StrHoje(GetDate()) 
							Left Outer Join Caixa_Mas_Exp_Aer as Cxa on Cxa.Num_Proc_MEA = Cte.Num_Proc_MEA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx and Cxa.DC_MEA = Cte.DC_MEA
						Where 
							MEA.Num_Proc_MEA = Left(@Processo_Old, 14) and Cte.DC_MEA = 'D'  and Cte.Desp_Dst_MEA = 'N'
						Group by
							TT.Rateio_Tx, Cte.Vlr_Org_MEA, Par.Par_Moeda,  MEA.Peso_Bruto_MEA, MEA.Qtd_HAWB_MEA

				Open CurMaster 
				Fetch Next From CurMaster Into @Vlr_Master	
				While @@Fetch_Status = 0 
					Begin 
						Set @Vlr_Cte_M	= @Vlr_Cte_M - @Vlr_Master	
						Fetch Next From CurMaster Into @Vlr_Master	
					End 
				Close CurMaster 
				Deallocate CurMaster 
				Update Tmp_lucrat Set Cta_Cte_Master = @Vlr_Cte_M Where Processo = @Processo_Old
				Set @Vlr_Cte_H_Tot = @Vlr_Cte_H
				Set @Vlr_Caixa_Tot = @Vlr_Caixa
				Set @Processo_Old  = @Processo
				Set @Taxa_Old = @Taxa
				Set @Cliente_Old = @Cliente
			End 
		Fetch Next From Cur_HEA into @Processo, @Taxa, @Cliente 
	End 
Close Cur_HEA 
Deallocate Cur_HEA

Delete Paridade Where Cd_Tp_Moeda = 'REL' and Dt_Par = dbo.StrHoje(GetDate()) and Cd_Tp_Par = 'OFC'

GO
