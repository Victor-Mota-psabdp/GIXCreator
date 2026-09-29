SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE pAuditor1_Ins 
(
@Data1		DateTime, 
@Data2		DateTime, 
@StrMachine	VarChar(20) , 
@Luc_Menor	Float, 
@Luc_Maior	Float , 
@EA		bit, 
@EM		bit, 
@IA		bit, 
@IM		bit 
)
AS	
	Declare @Processo	VarChar(14)
	Declare @ProcessoH	VarChar(16)
	Declare @ProcessoOld	VarChar(14)
	Declare @Taxa		Char(3) 
	Declare @DC		Char(1) 
	Declare @Vlr_Org	Decimal(12,2) 
	Declare @Vlr_Pgt	Decimal(12,2) 
	Declare @Vlr_House	Decimal(12,2) 
	Declare @PesoM	Float 
	Declare @Fator		Float 
	Declare @House	Int 
	Declare @PesoH	Float 
	Declare @PAridade	Float
	Declare @Moeda	Char(3) 
	Declare @Dt_Ins	VarChar(10)
	Declare @Pago		Char(1) 
	Declare @Tp_Rateio	char(1) 
	Declare @Cliente	varchar(60) 

	Delete Tmp_auditor

---------------------------------Master Imp. Marítima -----------------------------------------

	If @IM = 1
		Begin 
			Declare CurCtaM Cursor For 
			Select 
				Cte.Num_Proc_MIM, Cte.Cd_Tp_Tx, Cte.DC_MIM, Cte.Vlr_Org_MIM,  Cxa.Vlr_Pgto_Rcto_MIM, Par_Moeda, Cte.Cd_Tp_Moeda, Cte.Dt_Ins_MIM
			From 
				Cta_Cte_Mas_Imp_Mar Cte Join Master_Imp_Mar MIM on MIM.Num_Proc_MIM = Cte.Num_Proc_MIM 
				Left Join Caixa_Mas_Imp_Mar Cxa on Cxa.Num_Proc_MIM = Cte.Num_Proc_MIM and Cxa.DC_MIM = Cte.DC_MIM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  and Cxa.Num_Lcto <> 'PROVISÓRIO'
				Left Join Paridade Par on Par.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'IMM' and Dt_Par = Cte.Dt_Ins_MIM
			Where 
				(convert(datetime, mim.dt_emis_mim, 105) between @Data1 and @Data2) and 
				Cte.Desp_Org_MIM = 'N' and Cte.Cd_Tp_Tx not in (select Cd_Tp_Tx from param_aekcontabil_taxas_exc)
		
		
			Open CurCtaM 
			Fetch Next From CurCtaM into @Processo,  @Taxa, @DC, @Vlr_Org, @Vlr_Pgt, @PAridade, @Moeda, @Dt_Ins
			While @@Fetch_Status = 0 
				Begin 
					
					Set @Tp_Rateio = (Select Rateio_Tx From Tipo_Taxa Where Cd_Tp_Tx = @Taxa )			
					If @Processo <> @ProcessoOld 
						Begin 
							Set @ProcessoOld = @Processo
						End 
					If @Tp_Rateio = 'H'
						Set @PesoM = IsNull((Select count(*)  From House_Imp_Mar Where Left(Num_Proc_HIM, 14) = @Processo) , 1) 
					Else
						Set @PesoM = IsNull((Select Sum(Peso_Bruto_HIM) From House_Imp_Mar Where Left(Num_Proc_HIM, 14) = @Processo) , 1) 
		
					Print @Processo 
					Print @PesoM 
					Print  @Taxa
		
					Declare CurHouse Cursor For 
						Select Num_Proc_HIM, Peso_Bruto_HIM, Nome_Raz_Soc From House_Imp_Mar HIM Left Join Pessoa Pes on Pes.Cd_Pes = HIM.Cd_Import_HIM  Where Left(Num_Proc_HIM, 14) = @Processo 
		
					Open CurHouse 
		
					Fetch Next From CurHouse  into @ProcessoH, @PesoH, @Cliente
					While @@Fetch_Status =0 
						Begin 
			
							If @Moeda = 'REL' or @Paridade = null or @Paridade is null 
								Set @Paridade = dbo.VerParidade(@Dt_Ins, @Moeda, 'IMM')
		
		
							If @PesoH = 0 or @Tp_Rateio = 'H'
								Set @PesoH = 1 
		
							If @PesoM = 0 
								Set @PesoM = 1 
		
							If @Vlr_Pgt = Null or @Vlr_Pgt  is null 
								Begin 
									Print 'Pagto null'
									Set @Vlr_House = (((@Vlr_Org * @Paridade) / @PesoM) * @PesoH)
									Set @Pago =0 
								End  
							Else
								Begin 
									Print 'Pagto not null'		
									Set @Vlr_House = (@Vlr_Pgt / @PesoM) * @PesoH
									Set @Pago = 1 
								End 
					Print @Processoh
					Print @Taxa 
					Print @DC
					Print @Vlr_Org
					Print @Vlr_Pgt
					Print @PesoH
					Print @Paridade
					Print @Vlr_House
		
							Insert Into Tmp_Auditor values (@StrMachine, @ProcessoH, @Taxa, @DC, @Vlr_House, @Dt_Ins, @Pago, @Cliente)
		
							Fetch Next From CurHouse  into @ProcessoH, @PesoH, @Cliente
						End 
					Close CurHouse 
					Deallocate CurHouse 
					
					Fetch Next From CurCtaM into @Processo, @Taxa, @DC, @Vlr_Org, @Vlr_Pgt,@Paridade, @Moeda, @Dt_Ins
		
				End
				Close CurCtaM
				Deallocate  CurCtaM
		End 


---------------------------------Master Imp. Aérea -----------------------------------------

	If @IA = 1 
		Begin 
			Declare CurCtaM Cursor For 
			Select 
				Cte.Num_Proc_MIA, Cte.Cd_Tp_Tx, Cte.DC_MIA, Cte.Vlr_Org_MIA,  Cxa.Vlr_Pgto_Rcto_MIA, Par_Moeda, Cte.Cd_Tp_Moeda, Cte.Dt_Ins_MIA
			From 
				Cta_Cte_Mas_Imp_Aer Cte Join Master_Imp_Aer MIA on MIA.Num_Proc_MIA = Cte.Num_Proc_MIA 
				Left Join Caixa_Mas_Imp_Aer Cxa on Cxa.Num_Proc_MIA = Cte.Num_Proc_MIA and Cxa.DC_MIA = Cte.DC_MIA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  and Cxa.Num_Lcto <> 'PROVISÓRIO'
				Left Join Paridade Par on Par.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'IMA' and Dt_Par = Cte.Dt_Ins_MIA
			Where 
				(convert(datetime, mia.dt_emis_mia, 105) between @Data1 and @Data2) and  
				Cte.Desp_Org_MIA = 'N' and Cte.Cd_Tp_Tx not in (select Cd_Tp_Tx from param_aekcontabil_taxas_exc)
		
		
			Open CurCtaM 
			Fetch Next From CurCtaM into @Processo,  @Taxa, @DC, @Vlr_Org, @Vlr_Pgt, @PAridade, @Moeda, @Dt_Ins
			While @@Fetch_Status = 0 
				Begin 
					Set @Tp_Rateio = (Select Rateio_Tx From Tipo_Taxa Where Cd_Tp_Tx = @Taxa )			
					If @Processo <> @ProcessoOld 
						Begin 
							Set @ProcessoOld = @Processo
		
						End 
		
					if @Tp_Rateio = 'H'
						Set @PesoM = IsNull((Select count(*)  From House_Imp_Aer Where Left(Num_Proc_HIA, 14) = @Processo) , 1) 
					else
						Set @PesoM = IsNull((Select Sum(Peso_Bruto_HIA) From House_Imp_Aer Where Left(Num_Proc_HIA, 14) = @Processo) , 1) 
		
					Declare CurHouse Cursor For 
						Select Num_Proc_HIA, Peso_Bruto_HIA, Nome_Raz_Soc  From House_Imp_Aer HIA Left Join Pessoa Pes on Pes.Cd_Pes = HIA.Cd_Import_HIA Where Left(Num_Proc_HIA, 14) = @Processo 
		
					Open CurHouse 
		
					Fetch Next From CurHouse  into @ProcessoH, @PesoH, @Cliente
					While @@Fetch_Status =0 
						Begin 
							If @Moeda = 'REL' or @Paridade = null  or @Paridade is null 
								Set @Paridade = dbo.VerParidade(@Dt_Ins, @Moeda, 'IMA')
		
							If @PesoH = 0 or @Tp_Rateio = 'H'
								Set @PesoH = 1 
		
							If @PesoM = 0 
								Set @PesoM = 1 
		
							If @Vlr_Pgt = Null or @Vlr_Pgt  is null 
								Begin 
									Set @Vlr_House = (((@Vlr_Org * @Paridade) / @PesoM) * @PesoH)
									Set @Pago =0 
								End  
							Else
								Begin 
									Set @Vlr_House =  (@Vlr_Pgt / @PesoM) * @PesoH
									Set @Pago = 1 
								End 
					Print @Processoh
					Print @Taxa 
					Print @DC
					Print @Vlr_House
		
							Insert Into Tmp_Auditor values (@StrMachine, @ProcessoH, @Taxa, @DC, @Vlr_House, @Dt_Ins, @Pago, @Cliente)
		
							Fetch Next From CurHouse  into @ProcessoH, @PesoH, @Cliente
						End 
					Close CurHouse 
					Deallocate CurHouse 
					
					Fetch Next From CurCtaM into @Processo, @Taxa, @DC, @Vlr_Org, @Vlr_Pgt,@Paridade, @Moeda, @Dt_Ins
		
				End
				Close CurCtaM
				Deallocate  CurCtaM
		End 

---------------------------------Master Exp. Marítima -----------------------------------------

	If @EM =1 
		Begin 
			Declare CurCtaM Cursor For 
			Select 
				Cte.Num_Proc_MEM, Cte.Cd_Tp_Tx, Cte.DC_MEM, Cte.Vlr_Org_MEM,  Cxa.Vlr_Pgto_Rcto_MEM, Par_Moeda, Cte.Cd_Tp_Moeda, Cte.Dt_Ins_MEM
			From 
				Cta_Cte_Mas_Exp_Mar Cte Join Master_Exp_Mar MEM on MEM.Num_Proc_MEM = Cte.Num_Proc_MEM 
				Left Join Caixa_Mas_Exp_Mar Cxa on Cxa.Num_Proc_MEM = Cte.Num_Proc_MEM and Cxa.DC_MEM = Cte.DC_MEM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  and Cxa.Num_Lcto <> 'PROVISÓRIO'
				Left Join Paridade Par on Par.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'EXM' and Dt_Par = Cte.Dt_Ins_MEM
			Where 
				(convert(datetime, mem.dt_emis_mem, 105) between @Data1 and @Data2) and 
				Cte.Desp_Dst_MEM = 'N' and Cte.Cd_Tp_Tx not in (select Cd_Tp_Tx from param_aekcontabil_taxas_exc)
		
		
			Open CurCtaM 
			Fetch Next From CurCtaM into @Processo,  @Taxa, @DC, @Vlr_Org, @Vlr_Pgt, @PAridade, @Moeda, @Dt_Ins
			While @@Fetch_Status = 0 
				Begin 
					Set @Tp_Rateio = (Select Rateio_Tx From Tipo_Taxa Where Cd_Tp_Tx = @Taxa )			
					If @Processo <> @ProcessoOld 
						Begin 
							Set @ProcessoOld = @Processo
						End 
		
					if @Tp_Rateio = 'H'
						Set @PesoM = IsNull((Select count(*)  From House_Exp_Mar Where Left(Num_Proc_HEM, 14) = @Processo) , 1) 
					Else 
						Set @PesoM = IsNull((Select Sum(Peso_Bruto_HEM) From House_Exp_Mar Where Left(Num_Proc_HEM, 14) = @Processo) , 1) 
		
					Declare CurHouse Cursor For 
						Select Num_Proc_HEM, Peso_Bruto_HEM, Nome_Raz_Soc From House_Exp_Mar HEM Left Join Pessoa Pes on Pes.Cd_Pes = HEM.Cd_Export_HEM  Where Left(Num_Proc_HEM, 14) = @Processo 
		
					Open CurHouse 
		
					Fetch Next From CurHouse  into @ProcessoH, @PesoH, @Cliente
					While @@Fetch_Status =0 
						Begin 
							If @Moeda = 'REL' or @Paridade = null  or @Paridade is null 
								Set @Paridade = dbo.VerParidade(@Dt_Ins, @Moeda, 'EXM')
		
		
							If @PesoH = 0 or @Tp_Rateio = 'H'
								Set @PesoH = 1 
		
							If @PesoM = 0 
								Set @PesoM = 1 
		
							If @Vlr_Pgt = Null or @Vlr_Pgt  is null 
								Begin 
									Set @Vlr_House = (((@Vlr_Org * @Paridade) / @PesoM) * @PesoH)
									Set @Pago =0 
								End  
							Else
								Begin 
									Set @Vlr_House =  (@Vlr_Pgt / @PesoM) * @PesoH
									Set @Pago = 1 
								End 
					Print @Processoh
					Print @Taxa 
					Print @DC
					Print @Vlr_House
		
							Insert Into Tmp_Auditor values (@StrMachine, @ProcessoH, @Taxa, @DC, @Vlr_House, @Dt_Ins, @Pago, @Cliente)
		
							Fetch Next From CurHouse  into @ProcessoH, @PesoH, @Cliente
						End 
					Close CurHouse 
					Deallocate CurHouse 
					
					Fetch Next From CurCtaM into @Processo, @Taxa, @DC, @Vlr_Org, @Vlr_Pgt,@Paridade, @Moeda, @Dt_Ins
		
				End
				Close CurCtaM
				Deallocate  CurCtaM
		End 


---------------------------------Master Exp. Aérea -----------------------------------------

	If @EA = 1 
		Begin 
			Declare CurCtaM Cursor For 
			Select 
				Cte.Num_Proc_MEA, Cte.Cd_Tp_Tx, Cte.DC_MEA, Cte.Vlr_Org_MEA,  Cxa.Vlr_Pgto_Rcto_MEA, Par_Moeda, Cte.Cd_Tp_Moeda, Cte.Dt_Ins_MEA
			From 
				Cta_Cte_Mas_Exp_Aer Cte Join Master_Exp_Aer MEA on MEA.Num_Proc_MEA = Cte.Num_Proc_MEA 
				Left Join Caixa_Mas_Exp_Aer Cxa on Cxa.Num_Proc_MEA = Cte.Num_Proc_MEA and Cxa.DC_MEA = Cte.DC_MEA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  and Cxa.Num_Lcto <> 'PROVISÓRIO'
				Left Join Paridade Par on Par.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'EXA' and Dt_Par = Cte.Dt_Ins_MEA
			Where 
				(convert(datetime, mea.dt_emis_mea, 105) between @Data1 and @Data2) and 
				Cte.Desp_Dst_MEA = 'N' and Cte.Cd_Tp_Tx not in (select Cd_Tp_Tx from param_aekcontabil_taxas_exc)
		
		
			Open CurCtaM 
			Fetch Next From CurCtaM into @Processo,  @Taxa, @DC, @Vlr_Org, @Vlr_Pgt, @PAridade, @Moeda, @Dt_Ins
			While @@Fetch_Status = 0 
				Begin 
					Set @Tp_Rateio = (Select Rateio_Tx From Tipo_Taxa Where Cd_Tp_Tx = @Taxa )			
					If @Processo <> @ProcessoOld 
						Begin 
							Set @ProcessoOld = @Processo
						End 
		
					If @Tp_Rateio = 'H'
						Set @PesoM = IsNull((Select count(*)  From House_Exp_Aer Where Left(Num_Proc_HEA, 14) = @Processo) , 1) 
					Else 
						Set @PesoM = IsNull((Select Sum(Peso_Bruto_HEA) From House_Exp_Aer Where Left(Num_Proc_HEA, 14) = @Processo) , 1) 
		
					Declare CurHouse Cursor For 
						Select Num_Proc_HEA, Peso_Bruto_HEA, Nome_Raz_Soc From House_Exp_Aer HEA Left Join Pessoa Pes on Pes.Cd_Pes = HEA.Cd_Export_HEA   Where Left(Num_Proc_HEA, 14) = @Processo 
		
					Open CurHouse 
		
					Fetch Next From CurHouse  into @ProcessoH, @PesoH, @Cliente
					While @@Fetch_Status =0 
						Begin 
							If @Moeda = 'REL' or @Paridade = null  or @Paridade is null 
								Set @Paridade = dbo.VerParidade(@Dt_Ins, @Moeda, 'EXA')
		
							If @PesoH = 0 or @Tp_Rateio = 'H' 
								Set @PesoH = 1 
		
							If @PesoM = 0 
								Set @PesoM = 1 
		
							If @Vlr_Pgt = Null or @Vlr_Pgt  is null 
								Begin 
									Set @Vlr_House = (((@Vlr_Org * @Paridade) / @PesoM) * @PesoH)
									Set @Pago =0 
								End  
							Else
								Begin 
									Set @Vlr_House =  (@Vlr_Pgt / @PesoM) * @PesoH
									Set @Pago = 1 
								End 
					Print @Processoh
					Print @Taxa 
					Print @DC
					Print @Vlr_House
		
							Insert Into Tmp_Auditor values (@StrMachine, @ProcessoH, @Taxa, @DC, @Vlr_House, @Dt_Ins, @Pago, @Cliente)
		
							Fetch Next From CurHouse  into @ProcessoH, @PesoH, @Cliente
						End 
					Close CurHouse 
					Deallocate CurHouse 
					
					Fetch Next From CurCtaM into @Processo, @Taxa, @DC, @Vlr_Org, @Vlr_Pgt,@Paridade, @Moeda, @Dt_Ins
		
				End
				Close CurCtaM
				Deallocate  CurCtaM
		End 

	--House Imp. Mar 	
	
	If @IM = 1 
		Begin 
			Declare CurCtaH Cursor For 
			Select 
				Cte.Num_Proc_HIM, Cte.Cd_Tp_Tx, Cte.DC_HIM, Cte.Vlr_Org_HIM, Cte.Dt_Ins_HIM, Cxa.Vlr_Pgto_Rcto_HIM, Par.Par_Moeda, Cte.Cd_Tp_Moeda , Cte.Dt_Ins_HIM, Pes.Nome_Raz_Soc 
			From 
				Cta_Cte_Hou_Imp_Mar Cte Left Join Caixa_Hou_imp_mar Cxa on Cxa.Num_Proc_HIM = Cte.Num_Proc_Him and Cxa.DC_HIM = Cte.DC_HIM and Cxa.Cd_Tp_Tx = Cte.Cd_TP_Tx  
				Left Join Paridade Par on Par.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'IMM' and Dt_Par = Cte.Dt_Ins_HIM
				Join House_Imp_Mar HIM on HIM.Num_Proc_HIM = Cte.NUm_Proc_HIM 
				Left Join Pessoa Pes on Pes.Cd_Pes = HIM.Cd_Import_HIM   
	
			Where 
				(convert(datetime, him.dt_emis_him, 105) between @Data1 and @Data2) and 
				Cte.Desp_Org_HIM = 'N' and Cte.Cd_Tp_Tx not in (select Cd_Tp_Tx from param_aekcontabil_taxas_exc) and 
				Left(Cte.Num_Proc_HIM, 5) <> 'IMJOB'
	
			Open CurCtaH 
			Fetch Next From CurCtaH  Into @ProcessoH, @Taxa, @DC, @Vlr_Org, @Dt_Ins, @Vlr_Pgt, @Paridade , @Moeda, @Dt_Ins, @Cliente
			While @@Fetch_Status = 0 
				Begin 
					If @Moeda = 'REL' or @Paridade = null  or @Paridade is null 
						Set @Paridade = dbo.VerParidade(@Dt_Ins, @Moeda, 'IMM')

					If @Vlr_Pgt = null or @Vlr_Pgt  is null 
						Begin 
							Set @Vlr_House = @Vlr_Org * @Paridade
							Set @PAgo = 0
						End 
					Else 
						Begin 
							Set @Vlr_House = @Vlr_Pgt
							Set @PAgo = 1
						End 
	
				Print @Processoh
				Print @Taxa 
				Print @DC
				Print @Vlr_House
	
					If Exists(Select * From Tmp_Auditor Where TmpMachine = @StrMachine and TmpProcesso = @ProcessoH and TmpCd_Tp_Tx = @Taxa and TmpDC = @DC)
						Update Tmp_Auditor Set TmpValor = TmpValor + @Vlr_House Where TmpMachine = @StrMachine and TmpProcesso = @ProcessoH and TmpCd_Tp_Tx = @Taxa and TmpDC = @DC
					Else
						Insert Into Tmp_Auditor values (@StrMachine, @ProcessoH, @Taxa, @DC, @Vlr_House, @Dt_Ins, @Pago, @Cliente)
			
					Fetch Next From CurCtaH  Into @ProcessoH, @Taxa, @DC, @Vlr_Org, @Dt_Ins, @Vlr_Pgt, @Paridade , @Moeda, @Dt_Ins, @Cliente
			
				End 
			Close CurCtaH
			Deallocate CurCtaH
		End 

	--House Imp Aer 
		
	If @IA =1 
		Begin 
			Declare CurCtaH Cursor For 
			Select 
				Cte.Num_Proc_HIA, Cte.Cd_Tp_Tx, Cte.DC_HIA, Cte.Vlr_Org_HIA, Cte.Dt_Ins_HIA, Cxa.Vlr_Pgto_Rcto_HIA, Par.Par_Moeda, Cte.Cd_Tp_Moeda , Cte.Dt_Ins_HIA, Pes.Nome_Raz_Soc 
			From 
				Cta_Cte_Hou_Imp_Aer Cte Left Join Caixa_Hou_Imp_Aer Cxa on Cxa.Num_Proc_HIA = Cte.Num_Proc_HIA and Cxa.DC_HIA = Cte.DC_HIA and Cxa.Cd_Tp_Tx = Cte.Cd_TP_Tx  
				Left Join Paridade Par on Par.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'IMA' and Dt_Par = Cte.Dt_Ins_HIA
				Join House_Imp_Aer HIA on HIA.Num_Proc_HIA = Cte.NUm_Proc_HIA 
				Left Join Pessoa Pes on Pes.Cd_Pes = HIA.Cd_Import_HIA 
			Where 
				(convert(datetime, hia.dt_emis_hia, 105) between @Data1 and @Data2) and 
				Cte.Desp_Org_HIA = 'N' and Cte.Cd_Tp_Tx not in (select Cd_Tp_Tx from param_aekcontabil_taxas_exc) and 
				Left(Cte.Num_Proc_HIA, 5) <> 'IAJOB'
	
			Open CurCtaH 
			Fetch Next From CurCtaH  Into @ProcessoH, @Taxa, @DC, @Vlr_Org, @Dt_Ins, @Vlr_Pgt, @Paridade , @Moeda, @Dt_Ins, @Cliente
			While @@Fetch_Status = 0 
				Begin 
					If @Moeda = 'REL' or @Paridade = null  or @Paridade is null 
						Set @Paridade = dbo.VerParidade(@Dt_Ins, @Moeda, 'IMA')

					If @Vlr_Pgt = null or @Vlr_Pgt  is null 
						Begin 
							Set @Vlr_House = @Vlr_Org * @Paridade
							Set @PAgo = 0
						End 
					Else 
						Begin 
							Set @Vlr_House = @Vlr_Pgt
							Set @PAgo = 1
						End 
	
				Print @Processoh
				Print @Taxa 
				Print @DC
				Print @Vlr_House
	
					If Exists(Select * From Tmp_Auditor Where TmpMachine = @StrMachine and TmpProcesso = @ProcessoH and TmpCd_Tp_Tx = @Taxa and TmpDC = @DC)
						Update Tmp_Auditor Set TmpValor = TmpValor + @Vlr_House Where TmpMachine = @StrMachine and TmpProcesso = @ProcessoH and TmpCd_Tp_Tx = @Taxa and TmpDC = @DC
					Else
						Insert Into Tmp_Auditor values (@StrMachine, @ProcessoH, @Taxa, @DC, @Vlr_House, @Dt_Ins, @Pago, @Cliente)
			
					Fetch Next From CurCtaH  Into @ProcessoH, @Taxa, @DC, @Vlr_Org, @Dt_Ins, @Vlr_Pgt, @Paridade , @Moeda, @Dt_Ins, @Cliente
			
				End 
			Close CurCtaH
			Deallocate CurCtaH
		End 

	--House Exp. Mar 

	If @EM =1 
		Begin 
			Declare CurCtaH Cursor For 
			Select 
				Cte.Num_Proc_HEM, Cte.Cd_Tp_Tx, Cte.DC_HEM, Cte.Vlr_Org_HEM, Cte.Dt_Ins_HEM, Cxa.Vlr_Pgto_Rcto_HEM, Par.Par_Moeda, Cte.Cd_Tp_Moeda, Cte.Dt_Ins_HEM, Pes.Nome_Raz_Soc 
			From 
				Cta_Cte_Hou_Exp_Mar Cte Left Join Caixa_Hou_Exp_Mar Cxa on Cxa.Num_Proc_HEM = Cte.Num_Proc_HEM and Cxa.DC_HEM = Cte.DC_HEM and Cxa.Cd_Tp_Tx = Cte.Cd_TP_Tx  
				Left Join Paridade Par on Par.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'EXM' and Dt_Par = Cte.Dt_Ins_HEM
				Join House_Exp_Mar HEM on HEM.Num_Proc_HEM = Cte.NUm_Proc_HEM 
				Left Join Pessoa Pes on Pes.Cd_Pes = HEM.Cd_Export_HEM 
			Where 
				(convert(datetime, hem.dt_emis_hem, 105) between @Data1 and @Data2) and 
				Cte.Desp_Dst_HEM = 'N' and Cte.Cd_Tp_Tx not in (select Cd_Tp_Tx from param_aekcontabil_taxas_exc) and 
				Left(Cte.Num_Proc_HEM, 5) <> 'EMJOB'
	
			Open CurCtaH 
			Fetch Next From CurCtaH  Into @ProcessoH, @Taxa, @DC, @Vlr_Org, @Dt_Ins, @Vlr_Pgt, @Paridade , @Moeda, @Dt_Ins, @Cliente
			While @@Fetch_Status = 0 
				Begin 	
					If @Moeda = 'REL' or @Paridade = null  or @Paridade is null 
						Set @Paridade = dbo.VerParidade(@Dt_Ins, @Moeda, 'EXM')

					If @Vlr_Pgt = null or @Vlr_Pgt  is null 
						BEgin 
							Set @Vlr_House = @Vlr_Org * @Paridade
							Set @PAgo = 0
						End 
					Else 
						Begin 
							Set @Vlr_House = @Vlr_Pgt
							Set @PAgo = 1
						End 
	
				Print @Processoh
				Print @Taxa 
				Print @DC
				Print @Vlr_House
	
					If Exists(Select * From Tmp_Auditor Where TmpMachine = @StrMachine and TmpProcesso = @ProcessoH and TmpCd_Tp_Tx = @Taxa and TmpDC = @DC)
						Update Tmp_Auditor Set TmpValor = TmpValor + @Vlr_House Where TmpMachine = @StrMachine and TmpProcesso = @ProcessoH and TmpCd_Tp_Tx = @Taxa and TmpDC = @DC
					Else
						Insert Into Tmp_Auditor values (@StrMachine, @ProcessoH, @Taxa, @DC, @Vlr_House, @Dt_Ins, @Pago, @Cliente)
			
					Fetch Next From CurCtaH  Into @ProcessoH, @Taxa, @DC, @Vlr_Org, @Dt_Ins, @Vlr_Pgt, @Paridade , @Moeda, @Dt_Ins, @Cliente 
			
				End 
			Close CurCtaH
			Deallocate CurCtaH
		End 

	--House Exp. Aer 
	If @EA =1 
		Begin 
			Declare CurCtaH Cursor For 
			Select 
				Cte.Num_Proc_HEA, Cte.Cd_Tp_Tx, Cte.DC_HEA, Cte.Vlr_Org_HEA, Cte.Dt_Ins_HEA, Cxa.Vlr_Pgto_Rcto_HEA, Par.Par_Moeda, Cte.Cd_Tp_Moeda, Cte.Dt_Ins_HEA , Nome_Raz_Soc 
			From 
				Cta_Cte_Hou_Exp_Aer Cte Left Join Caixa_Hou_Exp_Aer Cxa on Cxa.Num_Proc_HEA = Cte.Num_Proc_HEA and Cxa.DC_HEA = Cte.DC_HEA and Cxa.Cd_Tp_Tx = Cte.Cd_TP_Tx  
				Left Join Paridade Par on Par.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'EXA' and Dt_Par = Cte.Dt_Ins_HEA
				Join House_Exp_Aer HEA on HEA.Num_Proc_HEA = Cte.NUm_Proc_HEA 
				Left Join Pessoa Pes on Pes.Cd_Pes = HEA.Cd_Export_HEA 
			Where 
				(convert(datetime, hea.dt_emis_hea, 105) between @Data1 and @Data2) and 
				Cte.Desp_Dst_HEA = 'N' and Cte.Cd_Tp_Tx not in (select Cd_Tp_Tx from param_aekcontabil_taxas_exc) and 
				Left(Cte.Num_Proc_HEA, 5) <> 'EAJOB'
	
			Open CurCtaH 
			Fetch Next From CurCtaH  Into @ProcessoH, @Taxa, @DC, @Vlr_Org, @Dt_Ins, @Vlr_Pgt, @Paridade , @Moeda, @Dt_Ins, @Cliente 
			While @@Fetch_Status = 0 
				Begin 
					If @Moeda = 'REL' or @Paridade = null  or @Paridade is null 
						Set @Paridade = dbo.VerParidade(@Dt_Ins, @Moeda, 'EXA')		
					If @Vlr_Pgt = null or @Vlr_Pgt  is null 
						BEgin 
							Set @Vlr_House = @Vlr_Org * @Paridade
							Set @PAgo = 0
						End 
					Else 
						Begin 
							Set @Vlr_House = @Vlr_Pgt
							Set @PAgo = 1
						End 
	
				Print @Processoh
				Print @Taxa 
				Print @DC
				Print @Vlr_House
	
					If Exists(Select * From Tmp_Auditor Where TmpMachine = @StrMachine and TmpProcesso = @ProcessoH and TmpCd_Tp_Tx = @Taxa and TmpDC = @DC)
						Update Tmp_Auditor Set TmpValor = TmpValor + @Vlr_House Where TmpMachine = @StrMachine and TmpProcesso = @ProcessoH and TmpCd_Tp_Tx = @Taxa and TmpDC = @DC
					Else
						Insert Into Tmp_Auditor values (@StrMachine, @ProcessoH, @Taxa, @DC, @Vlr_House, @Dt_Ins, @Pago, @Cliente)
			
					Fetch Next From CurCtaH  Into @ProcessoH, @Taxa, @DC, @Vlr_Org, @Dt_Ins, @Vlr_Pgt, @Paridade , @Moeda, @Dt_Ins, @Cliente 
			
				End 
			Close CurCtaH
			Deallocate CurCtaH
		End 

	delete Tmp_Auditor_Msg

	Insert Into Tmp_Auditor_Msg
	select distinct ad.tmpmachine, ad.tmpprocesso, 'Taxa a Débito sem correspondente a Crédito' from tmp_auditor ad left join  tmp_auditor ac on ac.tmpmachine = ad.tmpmachine and ac.tmpprocesso = ad.tmpprocesso and ac.tmpcd_tp_tx = ad.tmpcd_tp_Tx and ac.tmpdc <> ad.tmpdc where ad.tmpdc = 'D' and ac.tmpprocesso is null and ad.tmpmachine = @Strmachine and ad.tmpcd_tp_tx not in (select cd_tp_tx from tipo_taxa where pft_aer = 'S')
	
	Insert Into Tmp_Auditor_Msg
	select distinct ad.tmpmachine, ad.tmpprocesso, 'Taxa a Crédito com valor menor que a correspondente a Débito' from tmp_auditor ad left join  tmp_auditor ac on ac.tmpmachine = ad.tmpmachine and ac.tmpprocesso = ad.tmpprocesso and ac.tmpcd_tp_tx = ad.tmpcd_tp_Tx and ac.tmpdc <> ad.tmpdc where ad.tmpdc = 'D' and ac.tmpvalor < ad.tmpvalor and ad.tmpmachine = @Strmachine

--	Insert Into Tmp_Auditor_Msg	
--	select distinct tmpmachine, tmpprocesso, 'Taxa a Crédito não liquidada há mais de 30 dias' from tmp_auditor ta join tipo_taxa tx on tx.cd_Tp_Tx = ta.tmpcd_tp_Tx where tmpdc = 'C' and tmp_pago = '0' and datediff(day,convert(datetime, tmp_Dt_ins, 105),getdate()  ) > 30 and (nome_tp_Tx not like 'Armaz%' and nome_tp_Tx not like 'demur%') and tmpmachine = @Strmachine
	
	Insert Into Tmp_Auditor_Msg
	select distinct ta.tmpmachine, ta.tmpprocesso, 'Lucratividade maior que limite' 
	from tmp_auditor ta 
	left join  tmp_auditor ac on ac.tmpmachine = ta.tmpmachine and ac.tmpprocesso = ta.tmpprocesso and ac.tmpcd_tp_tx = TA.tmpcd_tp_Tx and ac.tmpdc = 'C' 
	left join  tmp_auditor ad on ad.tmpmachine = ta.tmpmachine and ad.tmpprocesso = ta.tmpprocesso and ad.tmpcd_tp_tx = TA.tmpcd_tp_Tx and ad.tmpdc = 'D' 
	group by ta.tmpprocesso, ta.tmpmachine    
	having (sum(ac.tmpvalor) - sum(ad.tmpvalor))/ sum(ad.tmpvalor) > @Luc_Maior   and ta.tmpmachine = @StrMachine
	order by ta.tmpprocesso
	
	Insert Into Tmp_Auditor_Msg
	select distinct ta.tmpmachine, ta.tmpprocesso, 'Lucratividade menor que limite' 
	from tmp_auditor ta 
	left join  tmp_auditor ac on ac.tmpmachine = ta.tmpmachine and ac.tmpprocesso = ta.tmpprocesso and ac.tmpcd_tp_tx = TA.tmpcd_tp_Tx and ac.tmpdc = 'C' 
	left join  tmp_auditor ad on ad.tmpmachine = ta.tmpmachine and ad.tmpprocesso = ta.tmpprocesso and ad.tmpcd_tp_tx = TA.tmpcd_tp_Tx and ad.tmpdc = 'D' 
	group by ta.tmpprocesso, ta.tmpmachine    
	having (sum(ac.tmpvalor) - sum(ad.tmpvalor))/ sum(ad.tmpvalor) < @Luc_Menor   and ta.tmpmachine = @StrMachine
	order by ta.tmpprocesso

	Insert Into Tmp_Auditor_Msg

	select distinct ta.tmpmachine, ta.tmpprocesso, 'PROFIT não cadastrado para processo' 
	from tmp_auditor ta where ta.tmpprocesso not in 
	(select distinct tmpprocesso from tmp_auditor ta join tipo_taxa tt on tt.cd_tp_Tx = ta.tmpcd_tp_tx where pft_aer = 'S' and tmpmachine = @StrMachine)
GO
