SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pTmp_Lucrat_HIA_Ins 
(
@StrMachine		VarChar(30), 
@Data01		Datetime,
@Data02		Datetime,
@Cli			VarChar(20) = '%'
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


Declare Cur_HIA Cursor For
	Select Distinct HIA.Num_Proc_HIA, Cd_Tp_Tx, Cli.Nome_Raz_Soc From Cta_Cte_Hou_Imp_Aer as Cte Join House_Imp_Aer as HIA on HIA.Num_Proc_HIA = Cte.Num_Proc_HIA 
	Join Pessoa as Cli on Cli.Cd_Pes = HIA.Cd_Import_HIA Where Cli.Apelido like @Cli  and Desp_Org_HIA = 'N' and Convert(Datetime, HIA.Dt_Emis_HIA, 105) between @Data01 and @Data02  and Left(Cte.Num_Proc_HIA, 5) <> 'IAJOB' Order by HIA.Num_Proc_HIA

Open Cur_HIA 
Set @Processo_Old = ''
Set @Vlr_Cte_H_Tot = 0
Set @Vlr_Caixa_Tot = 0
Set @Cliente = ''
Fetch Next From Cur_HIA into @Processo, @Taxa, @Cliente 
While @@Fetch_Status = 0 
	Begin 
		Set @Vlr_Caixa	= IsNull((Select Sum(Vlr_Pgto_Rcto_HIA) From Caixa_Hou_Imp_Aer Where Num_Proc_HIA = @Processo and Cd_Tp_Tx = @Taxa and DC_HIA = 'C'),0) - IsNull((Select Sum(Vlr_Pgto_Rcto_HIA) From Caixa_Hou_Imp_Aer Where Num_Proc_HIA = @Processo and Cd_Tp_Tx = @Taxa and DC_HIA = 'D'),0)
		Set @Vlr_Caixa_Ref = IsNull((Select Sum(Vlr_Ref_HIA) From Caixa_Hou_Imp_Aer Where Num_Proc_HIA = @Processo and Cd_Tp_Tx = @Taxa and DC_HIA = 'C'),0) - IsNull((Select Sum(Vlr_Ref_HIA) From Caixa_Hou_Imp_Aer Where Num_Proc_HIA = @Processo and Cd_Tp_Tx = @Taxa and DC_HIA = 'D'),0)

		Set @Vlr_Cte_H = IsNull((Select (Vlr_Org_HIA * Par_Moeda)  From Cta_Cte_Hou_Imp_Aer as Cte Join Paridade as Par on Par.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'OFC' and Par.Dt_Par =  dbo.StrHoje(GetDate()) Where Num_Proc_HIA = @Processo and Cd_Tp_Tx = @Taxa and DC_HIA = 'C'),0) - IsNull((Select (Vlr_Org_HIA * Par_Moeda)  From Cta_Cte_Hou_Imp_Aer as Cte Join Paridade as Par on Par.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'OFC' and Par.Dt_Par =  dbo.StrHoje(GetDate()) Where Num_Proc_HIA = @Processo and Cd_Tp_Tx = @Taxa and DC_HIA = 'D'),0)
		Set @Vlr_Cte_HRef = IsNull((Select Vlr_Org_HIA  From Cta_Cte_Hou_Imp_Aer as Cte Where Num_Proc_HIA = @Processo and Cd_Tp_Tx = @Taxa and DC_HIA = 'C'),0) - IsNull((Select Vlr_Org_HIA  From Cta_Cte_Hou_Imp_Aer as Cte Where Num_Proc_HIA = @Processo and Cd_Tp_Tx = @Taxa and DC_HIA = 'D'),0) 

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
				Set @Peso_H = IsNull((Select Peso_Bruto_HIA From House_Imp_Aer Where Num_Proc_HIA = @Processo_Old),0)
				Declare CurMaster Cursor For
				Select Vlr_C = Case  When TT.Rateio_Tx = 'K' and Sum(Cxa.Vlr_Pgto_Rcto_MIA) Is Null  then ((Cte.Vlr_Org_MIA * Par.Par_Moeda)/MIA.Peso_Bruto_MIA) * @Peso_H 
						       When TT.Rateio_Tx = 'K' and Sum(Cxa.Vlr_Pgto_Rcto_MIA) Is Not Null  then ((Sum(Vlr_Pgto_Rcto_MIA))/MIA.Peso_Bruto_MIA) * @Peso_H 
						       When TT.Rateio_Tx <> 'K' and Sum(Cxa.Vlr_Pgto_Rcto_MIA) Is Null  then (Cte.Vlr_Org_MIA * Par.Par_Moeda) / MIA.Qtd_HAWB_MIA
						       When TT.Rateio_Tx <> 'K' and Sum(Cxa.Vlr_Pgto_Rcto_MIA) Is Not Null  then (Sum(Vlr_Pgto_Rcto_MIA)) / MIA.Qtd_HAWB_MIA
						 End
						 From Cta_Cte_Mas_Imp_Aer as Cte Join Master_Imp_Aer as MIA on MIA.Num_Proc_MIA = Cte.Num_Proc_MIA 
							Join Tipo_Taxa as TT on TT.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
							Join Paridade as Par on Par.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'OFC' and Par.Dt_Par =  dbo.StrHoje(GetDate()) 
							Left Outer Join Caixa_Mas_Imp_Aer as Cxa on Cxa.Num_Proc_MIA = Cte.Num_Proc_MIA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx and Cxa.DC_MIA = Cte.DC_MIA 
						Where 
							Cte.Desp_Org_MIA = 'N' and MIA.Num_Proc_MIA = Left(@Processo_Old, 14) and Cte.DC_MIA = 'C' 
						Group by
							TT.Rateio_Tx, Cte.Vlr_Org_MIA, Par.Par_Moeda,  MIA.Peso_Bruto_MIA, MIA.Qtd_HAWB_MIA

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
				Select Vlr_C = Case  When TT.Rateio_Tx = 'K' and Sum(Cxa.Vlr_Pgto_Rcto_MIA) Is Null  then ((Cte.Vlr_Org_MIA * Par.Par_Moeda)/MIA.Peso_Bruto_MIA) * @Peso_H 
						       When TT.Rateio_Tx = 'K' and Sum(Cxa.Vlr_Pgto_Rcto_MIA) Is Not Null  then ((Sum(Vlr_Pgto_Rcto_MIA))/MIA.Peso_Bruto_MIA) * @Peso_H 
						       When TT.Rateio_Tx <> 'K' and Sum(Cxa.Vlr_Pgto_Rcto_MIA) Is Null  then (Cte.Vlr_Org_MIA * Par.Par_Moeda) / MIA.Qtd_HAWB_MIA
						       When TT.Rateio_Tx <> 'K' and Sum(Cxa.Vlr_Pgto_Rcto_MIA) Is Not Null  then (Sum(Vlr_Pgto_Rcto_MIA)) / MIA.Qtd_HAWB_MIA
						 End
						 From 
							Cta_Cte_Mas_Imp_Aer as Cte Join Master_Imp_Aer as MIA on MIA.Num_Proc_MIA = Cte.Num_Proc_MIA 
							Join Tipo_Taxa as TT on TT.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
							Join Paridade as Par on Par.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'OFC' and Par.Dt_Par =  dbo.StrHoje(GetDate()) 
							Left Outer Join Caixa_Mas_Imp_Aer as Cxa on Cxa.Num_Proc_MIA = Cte.Num_Proc_MIA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx and Cxa.DC_MIA = Cte.DC_MIA 
						Where 
							Cte.Desp_Org_MIA = 'N' and MIA.Num_Proc_MIA = Left(@Processo_Old, 14) and Cte.DC_MIA = 'D' 
						Group by
							TT.Rateio_Tx, Cte.Vlr_Org_MIA, Par.Par_Moeda,  MIA.Peso_Bruto_MIA, MIA.Qtd_HAWB_MIA
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
		Fetch Next From Cur_HIA into @Processo, @Taxa, @Cliente 
	End 
Close Cur_HIA 
Deallocate Cur_HIA

Delete Paridade Where Cd_Tp_Moeda = 'REL' and Dt_Par = dbo.StrHoje(GetDate()) and Cd_Tp_Par = 'OFC'

GO
