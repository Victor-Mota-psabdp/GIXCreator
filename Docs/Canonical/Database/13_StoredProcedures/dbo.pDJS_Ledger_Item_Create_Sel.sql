SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[pDJS_Ledger_Item_Create_Sel] --spATL_AXXMLITEM_Sel] --spATL_AXXMLItem_Sel '428307','REL',1,'C','srv', 'IMCSR201311231BR'
	@ID_AX int,
	--@Moeda varchar(40),
	@Cancela int	
	--@DC	Char(1),
	--@cd_tp_tx_ATL varchar(3),
	--@Num_Proc	varchar(16)
	
	
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
			'Item'									[Type],--Tipo,
			AX.id_ax,
			Account_Number							AccountNum,
			''										AH_Ledger,
			AXI.AccountType							AccountType,
			(
				Case AX.Aprovado
					When 1 then 'Yes'
					When 0 then 'No'
				End
			)										Approved,
			AX.Aprovado_Por							ApprovedBy,
			AXI.Numero_House						BDPHouseBOLNbr,
			AX.Company								Company,
			AXI.Num_Proc_Master						ConsolNbr,
			AXI.CSREmail								CSREmail,
			(
				Case AXI.Moeda
					When 'REL' then 'BRL'
					else AXI.Moeda
				End
			)										CurrencyCode,
			dbo.fBusca_TipoDocCliente('N',AXI.Num_Proc,1) CustRef1,
			(Case 
				When AX.Tipo=3 then 'ADV' else '' End) CustRef2,
			''										CustRef3,
			''										CustRef4,
			Isnull(AXI.Dimensao_1,AX.Dimensao_1)	Dimension_1,
			Isnull(AXi.Dimensao_2,AX.Dimensao_2)	Dimension_2,
			Isnull(AXI.Dimensao_3,AX.Dimensao_3)	Dimension_3,
			Isnull(AXI.Dimensao_4,AX.Dimensao_4)	Dimension_4,
			Isnull(AXI.Dimensao_5,AX.Dimensao_5)	Dimension_5,
			Isnull(AXI.Dimensao_6,AX.Dimensao_6)	Dimension_6,
			Isnull(AXI.Dimensao_7,AX.Dimensao_7)	Dimension_7,
			AX.Dt_Documento							DocumentDate,
			AXI.DocumentNum							DocumentNum,
			AX.Dt_Vencimento						Due,
			AXI.Paridade*100						ExchRate,
			Case 
				When tipo=2 then AXI.Num_Proc + '.' + AX.Invoice_number +AXI.DC+'.'+AXI.cd_tp_Tx_ATL 
				when len(AX.Invoice_number)=15 and tipo <> 2 then AXI.Num_Proc+'.'+isnull(TM.Cod_Int_Moeda,0)+ cast(AX.ID_AX as varchar(50)) + AXI.DC+'.'+AXI.cd_tp_Tx_ATL
					When Tipo=3 then AX.Invoice_number +'.'+isnull(TM.Cod_Int_Moeda,0) +AXI.DC+'.'+AXI.cd_tp_Tx_ATL+'_ADV'

				else AX.Invoice_number+'.'+isnull(TM.Cod_Int_Moeda,0) +AXI.DC+'.'+AXI.cd_tp_Tx_ATL
--				else	@Num_Proc + '.' + Invoice_number +@DC+'.'+@Cd_Tp_TX_ATL 
			End										Invoice,
			AXI.Num_Proc								JobNbr,
			AXI.MasterBOLNbr							MasterBOLNbr ,
			AXI.MasterBookingNbr						MasterBookingNbr,	
			''										PaymId,
			''										PaymMode ,
			AX.TaxGroup								TaxGroup,
			AXI.TaxGroup							TaxItemGroup,
			AX.dt_Ins								TransDate,
			''										Voucher,
			abs((dbo.valor(abs(AXI.valor),DC)))			[Value],
			(
				Case 
					when (dbo.valor(abs(AXI.valor),DC))>0 then 'AmountCurCredit'
					else 'AmountCurDebit'
				End
			)										TypeCD,
			AXI.Cd_Tp_TX							Cd_Tp_TX,
			left(AXI.Num_Proc +  ' - ' +TT.Nome_Tp_Tx,60)	TXT,
			Case 
				When (AX.Tipo=1 or AX.tipo=3) then isnull(AX.Invoice_number,(num_proc)) 
				When AX.tipo=2 then (AXI.Num_Proc)
			End										StatutoryInvoice1_BDP,
			Case				
				When (AX.Tipo=1 or AX.Tipo=3) and @blnDivide =0 then isnull(AXI.DocumentNum,'') 
				--When tipo=2 then Invoice_number
				When AX.Tipo=2 then isnull(AXI.DocumentNum,AX.Invoice_number)
			End										StatutoryInvoice2_BDP,
			(Case AX.Tipo
				When 1 then 'Cust'
				when 2 then 'Vend'
				When 3 then 'Cust'
				When 4 then 'Vend'
				When 5 then 'Cust'
			End)									OffsetAccountType,
			cast(AXI.Valor*(TTA.Porcentagem/100) as decimal(10,2)) CorrSalesTaxAmt,
			AXI.citCityHallServiceCode				citCityHallServiceCode,
			dbo.FRemoveCaracteresEspeciais(AXI.citCityHallServiceDesc)citCityHallServiceDesc,
			AXI.CitTransDateNF						CitTransDateNF,
			AXI.[07Invoice]							[07Invoice]
		 from AX_Doc AX
			Join AX_Doc_Item AXI on AXI.id_ax=AX.id_ax
			Join Tipo_Moeda TM on TM.cd_tp_moeda=Moeda
			Join Tipo_Tax_AX TTA on TTA.cd_tax_AX=AXI.TaxGroup
			Join Tipo_Taxa TT on TT.cd_tp_Tx=AXI.Cd_tp_TX_ATL
		Where 
			AX.id_AX=@ID_AX 
			--and dc=@DC	
			--and moeda=@Moeda
			and AXI.valor >0 
			--and cd_tp_tx_ATL = @cd_tp_tx_ATL 
			--and axi.num_proc=@Num_Proc
			and isnull(AXI.cd_tp_TX,'') <> '000.1' 
	End 
else

	Begin
		select		
			'Item'												[Type],--Tipo,
			AX.id_ax,
			Account_Number										AccountNum,
			''													AH_Ledger,
			AXI.AccountType										AccountType,
			(
				Case AX.Aprovado
					When 1 then 'Yes'
					When 0 then 'No'
				End
			)													Approved,
			AX.Aprovado_Por										ApprovedBy,
			AXI.Numero_House									BDPHouseBOLNbr,
			AX.Company											Company,
			AXI.Num_Proc_Master									ConsolNbr,
			AXI.CSREmail										CSREmail,
			(
				Case AXI.Moeda
					When 'REL' then 'BRL'
					else AXI.Moeda
				End
			)													CurrencyCode,
			dbo.fBusca_TipoDocCliente('N',AXI.Num_Proc,1)		CustRef1,
			Case 
				When AX.Tipo=3 then 'ADV' else '' End			CustRef2,
			''													CustRef3,
			''													CustRef4,
			Isnull(AXI.Dimensao_1, AX.Dimensao_1)				Dimension_1,
			Isnull(AXi.Dimensao_2, AX.Dimensao_2)				Dimension_2,
			case 
				when AX.Tipo=2 then V.Dimensao3
				else C.Dimensao3
			End													Dimension_3,
			Isnull(AXI.Dimensao_4,AX.Dimensao_4)				Dimension_4,
			Isnull(AXI.Dimensao_5, AX.Dimensao_5)				Dimension_5,
			Isnull(AXI.Dimensao_6,AX.Dimensao_6)				Dimension_6,
			Isnull(AXI.Dimensao_7,AX.Dimensao_7)				Dimension_7,
			AX.dt_Canc											DocumentDate,
			AXI.DocumentNum										DocumentNum,
			AX.Dt_Vencimento									Due,
			AXI.Paridade*100									ExchRate,
			Case 
				When AX.Tipo=2 then AXI.Num_Proc + '.' + AX.Invoice_number +AXI.DC+'.'+AXI.cd_tp_Tx_ATL  + 'V'
				when len(AX.Invoice_number)=15 and tipo <> 2 then AXI.Num_Proc+'.'+isnull(TM.Cod_Int_Moeda,0)+ cast(AX.ID_AX as varchar(50)) +AXI.DC+'.'+axi.cd_tp_Tx_ATL +'V'
				When Tipo=3 then Invoice_number +'.'+isnull(Cod_Int_Moeda,0) +AXI.DC+'.'+axi.cd_tp_Tx_ATL+'_ADVV'

				else Invoice_number+'.'+isnull(TM.Cod_Int_Moeda,0) +AXI.DC+'.'+AXI.cd_tp_Tx_ATL +'V'
--				else	@Num_Proc + '.' + Invoice_number +@DC+'.'+@Cd_Tp_TX_ATL 
			End													Invoice,
			Num_Proc												JobNbr,
			MasterBOLNbr										MasterBOLNbr ,
			MasterBookingNbr									MasterBookingNbr,	
			''													PaymId,
			''													PaymMode ,
			AX.TaxGroup											TaxGroup,
			AXI.TaxGroup										TaxItemGroup,
			AX.Dt_Canc											TransDate,
			''													Voucher,
			abs((dbo.valor(abs(AXI.valor),DC)))					[Value],
			(
				Case 
					when (dbo.valor(abs(valor),DC))>0 then 'AmountCurDebit'
					else 'AmountCurCredit'
				End
			)														TypeCD,
			AXI.Cd_Tp_TX											Cd_Tp_TX,
			left(AXI.Num_Proc +  ' - ' +TT.Nome_Tp_Tx,60)			TXT,
			Case 
				When (AX.Tipo=1 or AX.tipo=3) then isnull(AX.Invoice_number,(AXI.num_proc)) 
				When AX.tipo=2 then (AXI.Num_Proc)
			End														StatutoryInvoice1_BDP,
			Case 
				When (AX.Tipo=1 or AX.tipo=3) and @blnDivide =0 then isnull(AXI.DocumentNum,'') 
				--When tipo=2 then Invoice_number
				When AX.tipo=2 then isnull(AXI.DocumentNum,AX.Invoice_number)
			End														StatutoryInvoice2_BDP,

			(Case AX.Tipo
				When 1 then 'Cust'
				when 2 then 'Vend'
				When 3 then 'Cust'
				When 4 then 'Vend'
				When 5 then 'Cust'
			End)													OffsetAccountType,
			cast(AXI.Valor*(TTA.Porcentagem/100) as decimal(10,2))	CorrSalesTaxAmt,
			AXI.citCityHallServiceCode								citCityHallServiceCode,
			dbo.FRemoveCaracteresEspeciais(AXI.citCityHallServiceDesc)citCityHallServiceDesc,
			AXI.CitTransDateNF										CitTransDateNF,
			AXI.[07Invoice]											[07Invoice]	
		 from AX_Doc AX
			Join AX_Doc_Item AXI on AXI.id_ax=AX.id_ax
			Join Tipo_Moeda TM on TM.cd_tp_moeda=Moeda
			Join Tipo_TAX_AX TTA on TTA.cd_tax_AX=AXI.TaxGroup
			Join Tipo_Taxa TT on TT.cd_tp_Tx=AXI.Cd_tp_TX_ATL
			Left Join dbo.AX_XML_Customer_Recebido C on AX.Cd_Pessoa_AX=C.AccountNum and AX.tipo <>2
			left join dbo.AX_XML_Vendor_Recebido V on AX.Cd_Pessoa_AX=V.AccountNum and AX.tipo =2
		Where 
			AX.id_AX=@ID_AX
			--and dc=@DC	
			--and moeda=@Moeda
			and AXI.valor > 0 
			and AXI.cd_tp_Tx is not null 
			--and	cd_tp_tx_ATL = @cd_tp_tx_ATL 
			--and axi.num_proc=@Num_Proc
			and AXI.cd_tp_TX <> '000.1' 
	End 
GO
