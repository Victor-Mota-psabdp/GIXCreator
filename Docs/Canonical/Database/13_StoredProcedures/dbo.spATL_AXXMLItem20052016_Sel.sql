SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--13/3/2015 - alterado a linha do StatutoryInvoice2_BDP
CREATE Procedure [dbo].spATL_AXXMLItem20052016_Sel --spATL_AXXMLItem_Sel '428307','REL',1,'C','srv', 'IMCSR201311231BR'
	@ID_AX int,
	@Moeda varchar(40),
	@Cancela int,
	@DC	Char(1),
	@cd_tp_tx_ATL varchar(3),
	@Num_Proc	varchar(16)
	
	
as
Declare @blnDivide bit

If ((select COUNT(distinct moeda) from AX_Doc_Item where ID_AX=@id_AX)>1)
	begin
		Set @blnDivide=1
	End
else
	Begin
	
		Set @blnDivide=0	
	End
	
if @Cancela=0
	Begin
		select 
			'Item' Tipo,
			AX.id_ax,
			Account_Number AccountNum,
			AXI.AccountType,
			(
				Case Aprovado
					When 1 then 'Yes'
					When 0 then 'No'
				End
			) Approved,
			Aprovado_Por ApprovedBy,
			Numero_House BDPHouseBOLNbr,
			AX.Company,
			Num_Proc_Master ConsolNbr,
			CSREmail CSREmail,
			(
				Case Moeda
					When 'REL' then 'BRL'
					else moeda
				End
			)
			CurrencyCode,
			dbo.fBusca_TipoDocCliente('N',Num_Proc,1) CustRef1,
			(Case 
				When Tipo=3 then 'ADV' else '' End) CustRef2,
			'' CustRef3,
			'' CustRef4,
			Isnull(AXI.Dimensao_1, AX.Dimensao_1) Dimensao_1,
			Isnull(AXi.Dimensao_2, AX.Dimensao_2) Dimensao_2,
			Isnull(AXI.Dimensao_3,AX.Dimensao_3) Dimensao_3,
			Isnull(AXI.Dimensao_4,AX.Dimensao_4)Dimensao_4,
			Isnull(AXI.Dimensao_5, AX.Dimensao_5) Dimensao_5,
			Isnull(AXI.Dimensao_6,AX.Dimensao_6) Dimensao_6,
			Isnull(AXI.Dimensao_7,AX.Dimensao_7) Dimensao_7,
			dt_documento DocumentDate,
			DocumentNum,
			AX.Dt_Vencimento Due,
			Paridade*100 ExchRate,
			Case 
				When tipo=2 then @Num_Proc + '.' + Invoice_number +@DC+'.'+@Cd_Tp_TX_ATL 
				when len(Invoice_number)=15 and tipo <> 2 then @Num_Proc+'.'+isnull(Cod_Int_Moeda,0)+ cast(AX.ID_AX as varchar(50)) + @DC+'.'+@Cd_Tp_TX_ATL
					When Tipo=3 then Invoice_number +'.'+isnull(Cod_Int_Moeda,0) +@DC+'.'+@Cd_Tp_TX_ATL+'_ADV'

				else Invoice_number+'.'+isnull(Cod_Int_Moeda,0) +@DC+'.'+@Cd_Tp_TX_ATL
--				else	@Num_Proc + '.' + Invoice_number +@DC+'.'+@Cd_Tp_TX_ATL 
			End

			Invoice,
			Num_Proc JobNbr,
			MasterBOLNbr MasterBOLNbr ,
			MasterBookingNbr MasterBookingNbr,
	
			'' PaymId,
			'' PaymMode ,
			AX.TaxGroup	TaxGroup,
			AXI.TaxGroup TaxItemGroup,
			--'2013-10-31' TransDate,
			AX.dt_Ins TransDate,
			'' Voucher,
			abs((dbo.valor(abs(valor),DC))) Valor,
			(
				Case 
					when (dbo.valor(abs(valor),DC))>0 then 'AmountCurCredit'
					else 'AmountCurDebit'
				End
			) TipoCD,
			AXI.Cd_Tp_TX,
			left(Num_Proc +  ' - ' +Nome_Tp_Tx,60) txt,
			--Case 
			--	when (Tipo=1 or tipo=3) and @blnDivide =1 then isnull(Invoice_number,(num_proc))+'.'+isnull(Cod_Int_Moeda,0)  
			--	When (Tipo=1 or tipo=3) and @blnDivide =0 then isnull(Invoice_number,(num_proc)) 
			--	When tipo=2 then (Num_Proc)
			--End   StatutoryInvoice1_BDP,
			Case 
				When (Tipo=1 or tipo=3) then isnull(Invoice_number,(num_proc)) 
				When tipo=2 then (Num_Proc)
			End   StatutoryInvoice1_BDP,
			Case 
				
				When (Tipo=1 or tipo=3) and @blnDivide =0 then isnull(DocumentNum,'') 
				--When tipo=2 then Invoice_number
				When tipo=2 then isnull(DocumentNum,Invoice_number)
			End   StatutoryInvoice2_BDP,


			(Case Tipo
				When 1 then 'Cust'
				when 2 then 'Vend'
				When 3 then 'Cust'
				When 4 then 'Vend'
			
			End)
			OffsetAccountType,
			cast(Valor*(porcentagem/100) as decimal(10,2)) CorrSalesTaxAmt,
			citCityHallServiceCode,
			dbo.FRemoveCaracteresEspeciais(citCityHallServiceDesc)citCityHallServiceDesc,
			CitTransDateNF,
			[07Invoice]
			

		 from ax_doc AX
			Join AX_DOC_ITem AXI on AXI.id_ax=AX.id_ax
			Join Tipo_Moeda TM on TM.cd_tp_moeda=Moeda
			Join Tipo_TAX_AX TTA on TTA.cd_tax_AX=AXI.TaxGroup
			Join Tipo_Taxa TT on TT.cd_tp_Tx=AXI.Cd_tp_TX_ATL
		Where 
			AX.id_AX=@ID_AX and dc=@DC	and moeda=@Moeda
			and valor >0 and cd_tp_tx_ATL = @cd_tp_tx_ATL 
			and axi.num_proc=@Num_Proc
			and isnull(AXI.cd_tp_TX,'') <> '000.1' 
	End 
else

	Begin
		select 
			'Item' Tipo,
			AX.id_ax,
			Account_Number AccountNum,
			AXI.AccountType,
			(
				Case Aprovado
					When 1 then 'Yes'
					When 0 then 'No'
				End
			) Approved,
			Aprovado_Por ApprovedBy,
			Numero_House BDPHouseBOLNbr,
			AX.Company,
			Num_Proc_Master ConsolNbr,
			CSREmail CSREmail,
			(
				Case Moeda
					When 'REL' then 'BRL'
					else moeda
				End
			)
			CurrencyCode,
			dbo.fBusca_TipoDocCliente('N',Num_Proc,1) CustRef1,
			Case 
				When Tipo=3 then 'ADV' else '' End CustRef2,
			'' CustRef3,
			'' CustRef4,
			Isnull(AXI.Dimensao_1, AX.Dimensao_1) Dimensao_1,
			Isnull(AXi.Dimensao_2, AX.Dimensao_2) Dimensao_2,
			case 
				when Tipo=2 then V.Dimensao3
				else C.Dimensao3
			End	Dimensao_3,
			Isnull(AXI.Dimensao_4,AX.Dimensao_4)Dimensao_4,
			Isnull(AXI.Dimensao_5, AX.Dimensao_5) Dimensao_5,
			Isnull(AXI.Dimensao_6,AX.Dimensao_6) Dimensao_6,
			Isnull(AXI.Dimensao_7,AX.Dimensao_7) Dimensao_7,
			dt_Canc DocumentDate,
			DocumentNum,
			AX.Dt_Vencimento Due,
			Paridade*100 ExchRate,
			Case 
				When tipo=2 then @Num_Proc + '.' + Invoice_number +@DC+'.'+@Cd_Tp_TX_ATL
				when len(Invoice_number)=15 and tipo <> 2 then @Num_Proc+'.'+isnull(Cod_Int_Moeda,0)+ cast(AX.ID_AX as varchar(50)) +@DC+'.'+@Cd_Tp_TX_ATL
				When Tipo=3 then Invoice_number +'.'+isnull(Cod_Int_Moeda,0) +@DC+'.'+@Cd_Tp_TX_ATL+'_ADV'

				else Invoice_number+'.'+isnull(Cod_Int_Moeda,0) +@DC+'.'+@Cd_Tp_TX_ATL
--				else	@Num_Proc + '.' + Invoice_number +@DC+'.'+@Cd_Tp_TX_ATL 
			End

			Invoice,
			Num_Proc JobNbr,
			MasterBOLNbr MasterBOLNbr ,
			MasterBookingNbr MasterBookingNbr,
	
			'' PaymId,
			'' PaymMode ,
			AX.TaxGroup	TaxGroup,
			AXI.TaxGroup TaxItemGroup,

			AX.Dt_Canc TransDate,
			'' Voucher,
			abs((dbo.valor(abs(valor),DC))) Valor,
			(
				Case 
					when (dbo.valor(abs(valor),DC))>0 then 'AmountCurDebit'
					else 'AmountCurCredit'
				End
			) TipoCD,
			AXI.Cd_Tp_TX,
			left(Num_Proc +  ' - ' +Nome_Tp_Tx,60) txt, 
			--Case 
			--	when (Tipo=1 or tipo=3) and @blnDivide =1 then isnull(Invoice_number,(num_proc))+'.'+isnull(Cod_Int_Moeda,0)  
			--	When (Tipo=1 or tipo=3) and @blnDivide =0 then isnull(Invoice_number,(num_proc)) 
			--	When tipo=2 then (Num_Proc)
			--End   StatutoryInvoice1_BDP,
			Case 
				When (Tipo=1 or tipo=3) then isnull(Invoice_number,(num_proc)) 
				When tipo=2 then (Num_Proc)
			End   StatutoryInvoice1_BDP,
			Case 
				When (Tipo=1 or tipo=3) and @blnDivide =0 then isnull(DocumentNum,'') 
				--When tipo=2 then Invoice_number
				When tipo=2 then isnull(DocumentNum,Invoice_number)
			End   StatutoryInvoice2_BDP,

			(Case Tipo
				When 1 then 'Cust'
				when 2 then 'Vend'
				When 3 then 'Cust'
				When 4 then 'Vend'
			
			End)
			OffsetAccountType,
			cast(Valor*(porcentagem/100) as decimal(10,2)) CorrSalesTaxAmt,
			citCityHallServiceCode,
			dbo.FRemoveCaracteresEspeciais(citCityHallServiceDesc)citCityHallServiceDesc,
			CitTransDateNF,
			[07Invoice]
			
			

		 from ax_doc AX
			Join AX_DOC_ITem AXI on AXI.id_ax=AX.id_ax
			Join Tipo_Moeda TM on TM.cd_tp_moeda=Moeda
			Join Tipo_TAX_AX TTA on TTA.cd_tax_AX=AXI.TaxGroup
			Join Tipo_Taxa TT on TT.cd_tp_Tx=AXI.Cd_tp_TX_ATL
			Left Join dbo.AX_XML_Customer_Recebido C on cd_pessoa_AX=C.accountnum and tipo <>2
			left join dbo.AX_XML_Vendor_Recebido V on cd_pessoa_AX=V.accountnum and tipo =2

			Where 
			AX.id_AX=@ID_AX and dc=@DC	and moeda=@Moeda
			and valor >0 and axi.cd_tp_Tx is not null  and	cd_tp_tx_ATL = @cd_tp_tx_ATL 
			and axi.num_proc=@Num_Proc
			and AXI.cd_tp_TX <> '000.1' 
	End 
GO
