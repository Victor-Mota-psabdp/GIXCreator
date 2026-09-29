SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC [dbo].[spATL_AXXMLHeader2Oracle_Sel]'1',0
--cadu 20260519 17:24 - incluido BDPHouseBOLNbr, MasterBOLNbr ,MasterBookingNbr

--[dbo].[spAX_NFFaturas2AXDOCNF_SEL]
--[dbo].[spAX_Faturas2AXDOCNF2Oracle_SEL]
--IMKEM202604001BRC
--spAX_BuscaProcessoHeader2Oracle_SEL
--select * from AX_DOC_Oracle A with(nolock) where ID_AX = 18585
--select * from AX_DOC_XML_Oracle A with(nolock) where ID_AX = 18585
--[dbo].[spATL_AXXMLHeader2Oracle_Sel] '18556',0
CREATE Procedure [dbo].[spATL_AXXMLHeader2Oracle_Sel] 
	@id_AX int,	
	@Cancela int
	
as

Declare @CustRef1 as varchar(25) = ''

if exists (select top 1 A.ID_AX from AX_DOC_Oracle A with(nolock)
join Demurrage_ATL D with(nolock) on D.Processo + D.Fatura = A.Invoice_Number
where 
	A.ID_AX = @ID_AX)
	BEGIN
		set @CustRef1='DEMURRAGE'
	END


--Declare @blnDivide bit
--Declare @InvoiceNumber Varchar(40)
--Declare @CSR	Varchar(100) --Ultimo usuario que criou ou alterou a taxa
	
--If ((select COUNT(distinct moeda) from AX_Doc_Item where ID_AX=@id_AX)>1)
--	begin
--		Set @blnDivide=1
--	End
--else
--	Begin
--		Set @blnDivide=0	
--	End

		--Declare @Paridade Decimal(10,4)
		--Declare @Total float
		--Declare @int int
		
		--Set @Int=(select count(distinct(paridade)) From Ax_DOC_Item  where ID_AX=@ID_aX) --Moeda=@Moeda AND  )
		--if @Int >1 
		--	Begin
		--		Set @Paridade=(select top 1 paridade from Ax_DOC_Item  where ID_AX=@ID_aX and [07Invoice] is not null) --Moeda=@Moeda AND )
		--	End
		--if @Paridade is null or @Paridade =0 
		--	BEgin
		--		Set @Paridade=(select top 1 paridade from Ax_DOC_Item  where ID_AX=@ID_aX) --Moeda=@Moeda AND  )
		--	End

If @Cancela =0
	Begin
		--tipo 2 ap sol de pagamento tudo em real
		select
			AX.id_ax,
			AX.cd_pessoa_AX					AccountNum,
			''								AH_Ledger,
			AX.AccountType,
			(
				Case Aprovado
					When 1 then 'Yes'
					When 0 then 'No'
				End
			)								Approved,
			AX.Aprovado_Por					ApprovedBy,
			max(AXI.Numero_House)			BDPHouseBOLNbr,
			''								CitCustomerPO,
			AX.Company						Company,
			''								ConsolNbr,
			--CSREmail						CSREmail,
			''								CSREmail,
			--(
			--	Case AXI.Moeda
			--		When 'REL' then 'BRL'
			--		else AXI.Moeda
			--	End
			--)								CurrencyCode,
			'BRL'							CurrencyCode,
			--dbo.fBusca_TipoDocCliente('N',Num_Proc,1) CustRef1,
			'' 								CustRef1,
			'' 								CustRef2,
			'' 								CustRef3,
			'' 								CustRef4,
			AX.Dimensao_1					Dimensao_1,
			----100-67593 - Incluido o campo Dimensao_2
			max(AXI.Dimensao_2)					Dimensao_2,
			case 
				when Tipo=2 then V.Dimensao3
				else C.Dimensao3
			End								Dimensao_3,
			--isnull(AX.Dimensao_3,CUST.Dimensao3) Dimensao_3,
			AX.Dimensao_4					Dimensao_4,
			AX.Dimensao_5					Dimensao_5,
			AX.Dimensao_6					Dimensao_6,
			AX.Dimensao_7					Dimensao_7,
			Case when SOL.ID is not null and SOL.Doc_Number is not null and SOL.Dt_IssueDate is not null then SOL.Dt_IssueDate else AX.dt_documento	END DocumentDate,
			--AX.dt_documento					DocumentDate,
			--isnull(AX.Numero_Documento,AX.invoice_number)		DocumentNum,
			Case when SOL.ID is not null then Convert(Varchar(50),SOL.ID) else isnull(AX.Numero_Documento,AX.invoice_number) END DocumentNum,
			AX.Dt_Vencimento				Due,
			--max(paridade)*100				ExchRate,
			1*100							ExchRate,
--			Case 
--				When tipo=2 then @Num_Proc + '.' + Invoice_number +@DC+'.'+@Cd_Tp_TX_ATL 
--				when len(Invoice_number)=15 and tipo <> 2 then @Num_Proc+'.'+isnull(Cod_Int_Moeda,0) + cast(AX.ID_AX as varchar(50)) +@DC+'.'+@Cd_Tp_TX_ATL
--				When Tipo=3 then Invoice_number +'.'+isnull(Cod_Int_Moeda,0) +@DC+'.'+@Cd_Tp_TX_ATL+'_ADVN'
--				else Invoice_number+'.'+isnull(Cod_Int_Moeda,0) +@DC+'.'+@Cd_Tp_TX_ATL
----				else	@Num_Proc + '.' + Invoice_number +@DC+'.'+@Cd_Tp_TX_ATL 
--			End								Invoice,
			--AX.id_ax						Invoice,
			--AX.invoice_number				Invoice,
			--Case when SOL.ID is not null then isnull(Convert(Varchar(50),SOL.Doc_Number),'SP' + Convert(Varchar(50),SOL.ID)) else Convert(Varchar(50),AX.invoice_number) END Invoice,

			Case when SOL.ID is not null then isnull(Convert(Varchar(50),SOL.Doc_Number),'SP' + Convert(Varchar(50),SOL.ID)) else 
				Case when LEN(AX.invoice_number) >= 18 then Convert(Varchar(50),AX.ID_AX) else			
					Convert(Varchar(50),AX.invoice_number) END END Invoice,

			max(Num_Proc)					JobNbr,
			--'' 								JobNbr,
			max(AXI.MasterBOLNbr)			MasterBOLNbr ,
			--''								MasterBOLNbr ,
			max(AXI.MasterBookingNbr)		MasterBookingNbr,
			--''								MasterBookingNbr,
			''								O7Invoice,
			--''								PaymId,
			Case when SOL.ID is not null then Convert(Varchar(50),SOL.ID) else '' END PaymId,
			''								PaymMode ,
			AX.TaxGroup						TaxGroup,
			Null							TaxItemGroup,
			AX.dt_Ins						TransDate,
			--'2013-10-31' TransDate,
			''								Voucher,
			--abs(sum(dbo.valor(abs(valor),DC))) valor,
			--abs(sum(dbo.valor(abs(valor),DC))) * (paridade*100) valor,
			--sum(abs(dbo.valor(abs(valor),DC)) * (Paridade * 100)) valor,
			--sum(convert(decimal(18,2),abs(dbo.valor(abs(AXI.valor),DC)) * (Paridade))) valor,

			abs(sum(convert(decimal(18,2),dbo.valor(AXI.valor,DC) * (Paridade)))) valor,
			--abs(sum(dbo.valor(abs(AXI.valor),AXI.DC))) valor,
			(
				Case 
					when sum(convert(decimal(18,2),dbo.valor(AXI.valor,DC) * (Paridade))) > 0 then 'AmountCurDebit'
					else 'AmountCurCredit'
				End
			)								TipoCD,	
			--left(Num_PRoc + ' - ' + Nome_tp_tx,60)   TXT,
			''								TXT,
			--Case 
			--	When tipo=1 and DocumentNum Is not NULL  then 'PT'  estava duplicando em um cancelamento 1785919
			--End										PostingProfile,
			''								PostingProfile,
			--Case 
			--	when (Tipo=1 or tipo=3) and @blnDivide =1 then isnull(Invoice_number,max(num_proc))+'.'+isnull(Cod_Int_Moeda,0)  
			--	When (Tipo=1 or tipo=3) and @blnDivide =0 then isnull(Invoice_number,max(num_proc)) 
			--	When tipo=2 then max(Num_Proc)
			--End   StatutoryInvoice1_BDP,
			''								StatutoryInvoice1_BDP,
			--Case 
				
			--	When (Tipo=1 or tipo=3) and @blnDivide =0 then isnull(DocumentNum,'') 
			--	When tipo=2 then Invoice_number
			--End   StatutoryInvoice2_BDP,
			--''								StatutoryInvoice2_BDP,

			Case when len(SOL.InfBanco) between 40 and 60 and SOL.Cd_Tp_Doc = 'BLT' then [dbo].[FRemoveCaracteresEspeciais](SOL.InfBanco) else '' END StatutoryInvoice2_BDP,  --changed 2026-03-12 13:30h

			Case when SOL.ID is not null then Convert(Varchar(50),SOL.ID) else '' END PaymReference,

			--Case 
			--	when right(AXI.Cd_Tp_TX,1)='1' then 'No'
			--	else 'Yes'
			--End							 TaxWithholdCalculate,
			''								TaxWithholdCalculate ,
			'Ledger'					OffsetAccountType,
			Tipo,
			''									Cd_Tp_TX
		from ax_doc AX with(nolock)
		Join AX_DOC_ITem AXI with(nolock) on AXI.id_ax=AX.id_ax
		Left Join dbo.AX_XML_Customer_Recebido C on AX.Cd_Pessoa_AX=C.AccountNum and tipo <>2
		left join dbo.AX_XML_Vendor_Recebido V on AX.Cd_Pessoa_AX=V.AccountNum and tipo =2
		--LEFT Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=AXI.Moeda
		--Join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=AXI.cd_tp_Tx_ATL
		join Sol_Pgto_Cta_Cte SOL on Convert(varchar(25),SOL.ID) = AX.Numero_Documento
		Where 
			AX.id_AX=@id_AX
			--AND Moeda=@Moeda
			--and AXI.valor > 0.00 
			--and DC=@DC 
			and AXI.cd_tp_Tx is not null
			--and cd_Tp_Tx_ATL=@Cd_Tp_TX_ATL 
			--And AXI.num_proc=@Num_Proc 
			and axi.cd_tp_Tx <> '000.1' 
		group by
			AX.id_ax,AX.cd_pessoa_AX,AX.AccountType,AX.Aprovado,AX.Aprovado_Por,AX.Company,AX.Dimensao_1,
			--AXI.Dimensao_2,
			V.Dimensao3,C.Dimensao3,
			--AX.Dimensao_3,
			AX.Dimensao_4,AX.Dimensao_5,AX.Dimensao_6,AX.Dimensao_7,AX.dt_documento,AX.Numero_Documento,AX.Dt_Vencimento,AX.TaxGroup,AX.dt_Ins,
			AX.invoice_number,
			AX.Tipo	,SOL.InfBanco
			,SOL.Doc_Number,SOL.ID,SOL.Dt_IssueDate,SOL.Cd_Tp_Doc--,AXI.Moeda
		HAVING
			abs(sum(convert(decimal(18,2),abs(dbo.valor(abs(valor),DC)) * (Paridade))))> 0.00

	UNION
	
	--tipo 2 ap mandar a moeda que vier
	select
			AX.id_ax,
			AX.cd_pessoa_AX					AccountNum,
			''								AH_Ledger,
			AX.AccountType,
			(
				Case Aprovado
					When 1 then 'Yes'
					When 0 then 'No'
				End
			)								Approved,
			AX.Aprovado_Por					ApprovedBy,
			max(AXI.Numero_House)				BDPHouseBOLNbr,
			--''								BDPHouseBOLNbr,
			''								CitCustomerPO,
			AX.Company						Company,
			''								ConsolNbr,
			--CSREmail						CSREmail,
			''								CSREmail,
			(
				Case AXI.Moeda
					When 'REL' then 'BRL'
					else AXI.Moeda
				End
			)								CurrencyCode,
			--'BRL'							CurrencyCode,
			--dbo.fBusca_TipoDocCliente('N',Num_Proc,1) CustRef1,
			'' 								CustRef1,
			'' 								CustRef2,
			'' 								CustRef3,
			'' 								CustRef4,
			AX.Dimensao_1					Dimensao_1,
			----100-67593 - Incluido o campo Dimensao_2
			max(AXI.Dimensao_2)					Dimensao_2,
			case 
				when Tipo=2 then V.Dimensao3
				else C.Dimensao3
			End								Dimensao_3,
			--isnull(AX.Dimensao_3,CUST.Dimensao3) Dimensao_3,
			AX.Dimensao_4					Dimensao_4,
			AX.Dimensao_5					Dimensao_5,
			AX.Dimensao_6					Dimensao_6,
			AX.Dimensao_7					Dimensao_7,
			Case when SOL.ID is not null and SOL.Doc_Number is not null and SOL.Dt_IssueDate is not null then SOL.Dt_IssueDate else AX.dt_documento	END DocumentDate,
			--AX.dt_documento					DocumentDate,
			--isnull(AX.Numero_Documento,AX.invoice_number)		DocumentNum,
			Case when SOL.ID is not null then Convert(Varchar(50),SOL.ID) else isnull(AX.Numero_Documento,AX.invoice_number) END DocumentNum,
			AX.Dt_Vencimento				Due,
			max(paridade)*100				ExchRate,
			--1*100							ExchRate,
--			Case 
--				When tipo=2 then @Num_Proc + '.' + Invoice_number +@DC+'.'+@Cd_Tp_TX_ATL 
--				when len(Invoice_number)=15 and tipo <> 2 then @Num_Proc+'.'+isnull(Cod_Int_Moeda,0) + cast(AX.ID_AX as varchar(50)) +@DC+'.'+@Cd_Tp_TX_ATL
--				When Tipo=3 then Invoice_number +'.'+isnull(Cod_Int_Moeda,0) +@DC+'.'+@Cd_Tp_TX_ATL+'_ADVN'
--				else Invoice_number+'.'+isnull(Cod_Int_Moeda,0) +@DC+'.'+@Cd_Tp_TX_ATL
----				else	@Num_Proc + '.' + Invoice_number +@DC+'.'+@Cd_Tp_TX_ATL 
--			End								Invoice,
			--AX.id_ax						Invoice,
			--AX.invoice_number				Invoice,
			--Case when SOL.ID is not null then isnull(Convert(Varchar(50),SOL.Doc_Number),'SP' + Convert(Varchar(50),SOL.ID)) else Convert(Varchar(50),AX.invoice_number) END Invoice,

			Case when SOL.ID is not null then isnull(Convert(Varchar(50),SOL.Doc_Number),'SP' + Convert(Varchar(50),SOL.ID)) else 
				Case when LEN(AX.invoice_number) >= 18 then Convert(Varchar(50),AX.ID_AX) else			
					Convert(Varchar(50),AX.invoice_number) END END Invoice,

			max(Num_Proc)					JobNbr,
			--'' 								JobNbr,
			max(AXI.MasterBOLNbr)			MasterBOLNbr ,
			--''								MasterBOLNbr ,
			max(AXI.MasterBookingNbr)		MasterBookingNbr,
			''								O7Invoice,
			--''								PaymId,
			Case when SOL.ID is not null then Convert(Varchar(50),SOL.ID) else '' END PaymId,
			''								PaymMode ,
			AX.TaxGroup						TaxGroup,
			Null							TaxItemGroup,
			AX.dt_Ins						TransDate,
			--'2013-10-31' TransDate,
			''								Voucher,
			--abs(sum(dbo.valor(abs(valor),DC))) valor,
			--abs(sum(dbo.valor(abs(valor),DC))) * (paridade*100) valor,
			--sum(abs(dbo.valor(abs(valor),DC)) * (Paridade * 100)) valor,
			--sum(convert(decimal(18,2),abs(dbo.valor(abs(AXI.valor),DC)) * (Paridade))) valor,
			abs(sum(dbo.valor(abs(AXI.valor),AXI.DC))) valor,
			--abs(sum(convert(decimal(18,2),dbo.valor(AXI.valor,DC) * (Paridade)))) valor,
			--abs(sum(dbo.valor(abs(AXI.valor),AXI.DC))) valor,
			(
				Case 
					when sum(convert(decimal(18,2),dbo.valor(AXI.valor,DC) * (Paridade))) > 0 then 'AmountCurDebit'
					else 'AmountCurCredit'
				End
			)								TipoCD,	
			--left(Num_PRoc + ' - ' + Nome_tp_tx,60)   TXT,
			''								TXT,
			--Case 
			--	When tipo=1 and DocumentNum Is not NULL  then 'PT'  estava duplicando em um cancelamento 1785919
			--End										PostingProfile,
			''								PostingProfile,
			--Case 
			--	when (Tipo=1 or tipo=3) and @blnDivide =1 then isnull(Invoice_number,max(num_proc))+'.'+isnull(Cod_Int_Moeda,0)  
			--	When (Tipo=1 or tipo=3) and @blnDivide =0 then isnull(Invoice_number,max(num_proc)) 
			--	When tipo=2 then max(Num_Proc)
			--End   StatutoryInvoice1_BDP,
			''								StatutoryInvoice1_BDP,
			--Case 
				
			--	When (Tipo=1 or tipo=3) and @blnDivide =0 then isnull(DocumentNum,'') 
			--	When tipo=2 then Invoice_number
			--End   StatutoryInvoice2_BDP,
			--''								StatutoryInvoice2_BDP,

			Case when len(SOL.InfBanco) between 40 and 60 and SOL.Cd_Tp_Doc = 'BLT' then [dbo].[FRemoveCaracteresEspeciais](SOL.InfBanco) else '' END StatutoryInvoice2_BDP,  --changed 2026-03-12 13:30h

			Case when SOL.ID is not null then Convert(Varchar(50),SOL.ID) else '' END PaymReference,

			--Case 
			--	when right(AXI.Cd_Tp_TX,1)='1' then 'No'
			--	else 'Yes'
			--End							 TaxWithholdCalculate,
			''								TaxWithholdCalculate ,
			'Ledger'					OffsetAccountType,
			Tipo,
			''									Cd_Tp_TX
		from ax_doc AX with(nolock)
		Join AX_DOC_ITem AXI with(nolock) on AXI.id_ax=AX.id_ax
		Left Join dbo.AX_XML_Customer_Recebido C on AX.Cd_Pessoa_AX=C.AccountNum and tipo <>2
		left join dbo.AX_XML_Vendor_Recebido V on AX.Cd_Pessoa_AX=V.AccountNum and tipo =2
		--LEFT Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=AXI.Moeda
		--Join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=AXI.cd_tp_Tx_ATL
		left join Sol_Pgto_Cta_Cte SOL on Convert(varchar(25),SOL.ID) = AX.Numero_Documento
		Where 
			AX.id_AX=@id_AX
			--AND Moeda=@Moeda
			--and AXI.valor > 0.00 
			--and DC=@DC 
			and AXI.cd_tp_Tx is not null
			--and cd_Tp_Tx_ATL=@Cd_Tp_TX_ATL 
			--And AXI.num_proc=@Num_Proc 
			and axi.cd_tp_Tx <> '000.1'
			and SOL.ID is null
		group by
			AX.id_ax,AX.cd_pessoa_AX,AX.AccountType,AX.Aprovado,AX.Aprovado_Por,AX.Company,AX.Dimensao_1,
			--AXI.Dimensao_2,
			V.Dimensao3,C.Dimensao3,
			--AX.Dimensao_3,
			AX.Dimensao_4,AX.Dimensao_5,AX.Dimensao_6,AX.Dimensao_7,AX.dt_documento,AX.Numero_Documento,AX.Dt_Vencimento,AX.TaxGroup,AX.dt_Ins,
			AX.invoice_number,
			AX.Tipo	,SOL.InfBanco
			,SOL.Doc_Number,SOL.ID,SOL.Dt_IssueDate,SOL.Cd_Tp_Doc,AXI.Moeda
		HAVING
			abs(sum(convert(decimal(18,2),abs(dbo.valor(abs(valor),DC)) * (Paridade))))> 0.00


	UNION
		select
			AX.id_ax,
			AX.cd_pessoa_AX					AccountNum,
			''								AH_Ledger,
			AX.AccountType,
			(
				Case Aprovado
					When 1 then 'Yes'
					When 0 then 'No'
				End
			)								Approved,
			AX.Aprovado_Por					ApprovedBy,
			max(AXI.Numero_House)			BDPHouseBOLNbr,
			''								CitCustomerPO,
			AX.Company						Company,
			''								ConsolNbr,
			''								CSREmail,
			(
				Case AXI.Moeda
					When 'REL' then 'BRL'
					else AXI.Moeda
				End
			)								CurrencyCode,
			--'BRL'							CurrencyCode,
			@CustRef1						CustRef1,
			'' 								CustRef2,
			'' 								CustRef3,
			'' 								CustRef4,
			AX.Dimensao_1					Dimensao_1,
			max(AXI.Dimensao_2)					Dimensao_2,
			case 
				when Tipo=2 then V.Dimensao3
				else C.Dimensao3
			End								Dimensao_3,
			AX.Dimensao_4					Dimensao_4,
			AX.Dimensao_5					Dimensao_5,
			AX.Dimensao_6					Dimensao_6,
			AX.Dimensao_7					Dimensao_7,
			Case when SOL.ID is not null and SOL.Doc_Number is not null and SOL.Dt_IssueDate is not null then SOL.Dt_IssueDate else AX.dt_documento	END DocumentDate,
			--AX.dt_documento					DocumentDate,
			Case when SOL.ID is not null then Convert(Varchar(50),SOL.ID) else isnull(AX.Numero_Documento,AX.invoice_number) END DocumentNum,
			AX.Dt_Vencimento				Due,
			--1*100							ExchRate,
			max(AXI.Paridade)*100				ExchRate,
			--Case when SOL.ID is not null then isnull(Convert(Varchar(50),SOL.Doc_Number),'SP' + Convert(Varchar(50),SOL.ID)) else Convert(Varchar(50),AX.invoice_number) END Invoice,
			
			Case when SOL.ID is not null then isnull(Convert(Varchar(50),SOL.Doc_Number),'SP' + Convert(Varchar(50),SOL.ID)) else 
				Case when LEN(AX.invoice_number) >= 18 then Convert(Varchar(50),AX.ID_AX) else			
					Convert(Varchar(50),AX.invoice_number) END END Invoice,
			
			max(Num_Proc)					JobNbr,
			--'' 								JobNbr,
			max(AXI.MasterBOLNbr)			MasterBOLNbr ,
			max(AXI.MasterBookingNbr)		MasterBookingNbr,
			''								O7Invoice,
			--''								PaymId,
			Case when SOL.ID is not null then Convert(Varchar(50),SOL.ID) else '' END PaymId,
			''								PaymMode ,
			AX.TaxGroup						TaxGroup,
			Null							TaxItemGroup,
			AX.dt_Ins						TransDate,
			''								Voucher,
			--abs(sum(convert(decimal(18,2),dbo.valor(AXI.valor,DC) * (Paridade)))) valor,
			abs(sum(dbo.valor(abs(AXI.valor),AXI.DC))) valor,
			(
				Case 
					when sum(convert(decimal(18,2),dbo.valor(AXI.valor,DC) * (Paridade))) > 0 then 'AmountCurDebit'
					else 'AmountCurCredit'
				End
			)								TipoCD,	
			''								TXT,
			''								PostingProfile,
			''								StatutoryInvoice1_BDP,
			--Case when len(SOL.InfBanco) = 50 then SOL.InfBanco else '' END StatutoryInvoice2_BDP, 
			Case when len(SOL.InfBanco) between 40 and 60 and SOL.Cd_Tp_Doc = 'BLT' then [dbo].[FRemoveCaracteresEspeciais](SOL.InfBanco) else '' END StatutoryInvoice2_BDP,  --changed 2026-03-12 13:30h

			Case when SOL.ID is not null then Convert(Varchar(50),SOL.ID) else '' END PaymReference,	
			''								TaxWithholdCalculate ,
			'Ledger'					OffsetAccountType,
			Tipo,
			''									Cd_Tp_TX
		from AX_DOC_Oracle AX with(nolock)
		Join AX_DOC_Item_Oracle AXI with(nolock) on AXI.id_ax=AX.id_ax
		Left Join dbo.AX_XML_Customer_Recebido C on AX.Cd_Pessoa_AX=C.AccountNum and tipo <>2
		left join dbo.AX_XML_Vendor_Recebido V on AX.Cd_Pessoa_AX=V.AccountNum and tipo =2
		left join Sol_Pgto_Cta_Cte SOL on Convert(varchar(25),SOL.ID) = AX.Numero_Documento
		Where 
			AX.id_AX=@id_AX
			and AXI.cd_tp_Tx is not null
			and axi.cd_tp_Tx <> '000.1' 
		group by
			AX.id_ax,AX.cd_pessoa_AX,AX.AccountType,AX.Aprovado,AX.Aprovado_Por,AX.Company,AX.Dimensao_1,
			V.Dimensao3,C.Dimensao3,
			AX.Dimensao_4,AX.Dimensao_5,AX.Dimensao_6,AX.Dimensao_7,AX.dt_documento,AX.Numero_Documento,AX.Dt_Vencimento,AX.TaxGroup,AX.dt_Ins,
			AX.invoice_number,
			AX.Tipo	,SOL.InfBanco
			,SOL.Doc_Number,SOL.ID,SOL.Dt_IssueDate,SOL.Cd_Tp_Doc,AXI.Moeda
		
		HAVING
			abs(sum(convert(decimal(18,2),abs(dbo.valor(abs(valor),DC)) * (Paridade))))> 0.00
		
	End

Else

	Begin
		select
			AX.id_ax,
			cd_pessoa_AX					AccountNum,
			''								AH_Ledger,
			AX.AccountType					AccountType,

			(
				Case Aprovado
					When 1 then 'Yes'
					When 0 then 'No'
				End
			)								Approved,
			Aprovado_Por					ApprovedBy,
			max(AXI.Numero_House)		BDPHouseBOLNbr,
			--''								BDPHouseBOLNbr,
			''								CitCustomerPO,
			AX.Company						Company,
			''								ConsolNbr,
			''								CSREmail,
			--(
			--	Case AXI.Moeda
			--		When 'REL' then 'BRL'
			--		else AXI.Moeda
			--	End
			--)								CurrencyCode,
			'BRL'							CurrencyCode,
			'' 								CustRef1,
			'' 								CustRef2,
			'' 								CustRef3,
			'' 								CustRef4,
			AX.Dimensao_1					Dimensao_1,
			----100-67593 - Incluido o campo Tipo_Prod_Code
			MAX(AXI.Dimensao_2)				Dimensao_2,
			case 
				when Tipo=2 then V.Dimensao3
				else C.Dimensao3
			End								Dimensao_3,
			AX.Dimensao_4					Dimensao_4,
			AX.Dimensao_5					Dimensao_5,
			AX.Dimensao_6					Dimensao_6,
			AX.Dimensao_7					Dimensao_7,
			AX.Dt_Canc							DocumentDate,
			--Numero_Documento				DocumentNum,
			Case when SOL.ID is not null then Convert(Varchar(50),SOL.ID) else isnull(AX.Numero_Documento,AX.invoice_number) END DocumentNum,
			AX.Dt_Vencimento				Due,			
			--Max (Paridade)* 100				ExchRate,
			1*100							ExchRate,
--			Case 
--				When tipo=2 then @Num_Proc + '.' + Invoice_number +@DC+'.'+@Cd_Tp_TX_ATL +'V'
--				when len(Invoice_number)=15 and tipo <> 2 then @Num_Proc+'.'+isnull(Cod_Int_Moeda,0) +@DC+'.'+@Cd_Tp_TX_ATL + 'V'
--				When Tipo=3 then Invoice_number +'.'+isnull(Cod_Int_Moeda,0) +@DC+'.'+@Cd_Tp_TX_ATL+'_ADVNV'

--				else Invoice_number+'.'+isnull(Cod_Int_Moeda,0) +@DC+'.'+@Cd_Tp_TX_ATL + 'V'
----				else	@Num_Proc + '.' + Invoice_number +@DC+'.'+@Cd_Tp_TX_ATL 
--			End
			--Convert(Varchar(25),AX.id_ax) +'V'					Invoice,
			--AX.invoice_number	+'V'					Invoice,
			--Case when SOL.ID is not null then isnull(Convert(Varchar(50),SOL.Doc_Number)+'V','SP' + Convert(Varchar(50),SOL.ID)) +'V' else Convert(Varchar(50),AX.invoice_number)+'V' END Invoice,
			
			Case when SOL.ID is not null then isnull(Convert(Varchar(50),SOL.Doc_Number),'SP' + Convert(Varchar(50),SOL.ID)) +'V' else 
				Case when LEN(AX.invoice_number) >= 18 then Convert(Varchar(50),AX.ID_AX)+'V' else			
					Convert(Varchar(50),AX.invoice_number)+'V' END END Invoice,
			
			max(AXI.Num_Proc)					JobNbr,
			--'' 								JobNbr,
			max(AXI.MasterBOLNbr)				MasterBOLNbr ,
			--'' 								MasterBOLNbr ,
			max(AXI.MasterBookingNbr)		MasterBookingNbr,
			'' 								O7Invoice,
			--''								PaymId,
			Case when SOL.ID is not null then Convert(Varchar(50),SOL.ID) else '' END PaymId,
			''								PaymMode,
			AX.TaxGroup						TaxGroup,
			Null							TaxItemGroup,
			AX.Dt_Canc							TransDate,
			''								Voucher,
			--abs(sum(dbo.valor(abs(valor),DC))) valor,
			--abs(sum(dbo.valor(abs(valor),DC)) * (Paridade * 100)) valor,
			--sum(abs(dbo.valor(abs(valor),DC)) * (Paridade * 100)) valor,
			abs(sum(convert(decimal(18,2),dbo.valor(AXI.valor,AXI.DC) * (AXI.Paridade)))) valor,	
			--abs(sum(dbo.valor(abs(AXI.valor),AXI.DC))) valor,
			(
				Case 
					when sum(convert(decimal(18,2),dbo.valor(AXI.valor,AXI.DC) * (AXI.Paridade))) > 0 then 'AmountCurCredit'
					else 'AmountCurDebit'
				End
			)								TipoCD,
			--Case 
			--	When tipo=1 and DocumentNum Is not NULL  then 'PT'  estava duplicando em um cancelamento 1785919
			--End										PostingProfile,
			''								PostingProfile,
			--left(Num_Proc  + ' - ' + Nome_Tp_TX,60) TXT,
			''								TXT,
			--Case 
			--	When (Tipo=1 or tipo=3)  then isnull(Invoice_number,max(num_proc)) 
			--	When tipo=2 then max(Num_Proc)
			--End								StatutoryInvoice1_BDP,
			''								StatutoryInvoice1_BDP ,
			--Case 
				
			--	When (Tipo=1 or tipo=3) and @blnDivide =0 then isnull(DocumentNum,'') 
			--	When tipo=2 then Invoice_number
			--End								StatutoryInvoice2_BDP,
			--''								StatutoryInvoice2_BDP ,
			--Case when len(SOL.InfBanco) = 50 then SOL.InfBanco else '' END StatutoryInvoice2_BDP, 
			Case when len(SOL.InfBanco) between 40 and 60 and SOL.Cd_Tp_Doc = 'BLT' then [dbo].[FRemoveCaracteresEspeciais](SOL.InfBanco) else '' END StatutoryInvoice2_BDP,  --changed 2026-03-12 13:30h

			Case when SOL.ID is not null then Convert(Varchar(50),SOL.ID) else '' END PaymReference,
			--'No'							TaxWithholdCalculate,
			'No'							TaxWithholdCalculate ,
			'Ledger'						OffsetAccountType,
			Tipo	,
			''									Cd_Tp_TX
	from 
		AX_Doc AX
		Join AX_DOC_ITem AXI on AXI.ID_AX=AX.ID_AX
		Join Tipo_Moeda TM on TM.Cd_Tp_Moeda=AXI.Moeda
		Join Tipo_Taxa TT on TT.cd_tp_Tx=AXI.Cd_Tp_TX_ATL
		Left Join dbo.AX_XML_Customer_Recebido C on AX.Cd_Pessoa_AX=C.AccountNum and tipo <>2
		left join dbo.AX_XML_Vendor_Recebido V on AX.Cd_Pessoa_AX=V.AccountNum and tipo =2
		join Sol_Pgto_Cta_Cte SOL on Convert(varchar(25),SOL.ID) = AX.Numero_Documento
		 left join vwNF_Fatura_ALL NF on NF.Num_Proc = AXI.Num_Proc and NF.Cd_Tp_Tx = AXI.cd_tp_Tx_ATL and NF.DC = AXI.DC
	Where 
		AX.id_AX=@id_AX
		--AND Moeda=@Moeda
		--and valor > 0.00 
		--and DC=@DC 
		and AXI.cd_tp_Tx is not null
		--and AXI.cd_Tp_Tx_ATL=@Cd_Tp_TX_ATL 
		--and axi.num_proc=@num_proc
		and axi.cd_tp_Tx <> '000.1' 
		AND NF.ID is null
		and AX.Dt_Canc	is not null 
	Group by
		AX.id_ax,AX.cd_pessoa_AX,AX.AccountType,AX.Aprovado,Aprovado_Por,AX.Company,AX.Dimensao_1,
		--AXI.Dimensao_2,
		V.Dimensao3,C.Dimensao3,AX.Dimensao_4,AX.Dimensao_5,AX.Dimensao_6,AX.Dimensao_7,AX.Dt_Canc,
		AX.Numero_Documento,AX.Dt_Vencimento,AX.TaxGroup,AX.Dt_Canc,
		AX.invoice_number,
		AX.Tipo	,SOL.InfBanco
		,SOL.Doc_Number,SOL.ID,SOL.Cd_Tp_Doc--,AXI.Moeda
	HAVING
		abs(sum(convert(decimal(18,2),abs(dbo.valor(abs(valor),AXI.DC)) * (AXI.Paridade))))>0

	UNION

	select
			AX.id_ax,
			cd_pessoa_AX					AccountNum,
			''								AH_Ledger,
			AX.AccountType					AccountType,

			(
				Case Aprovado
					When 1 then 'Yes'
					When 0 then 'No'
				End
			)								Approved,
			Aprovado_Por					ApprovedBy,
			max(AXI.Numero_House)			BDPHouseBOLNbr,
			--''								BDPHouseBOLNbr,
			''								CitCustomerPO,
			AX.Company						Company,
			''								ConsolNbr,
			''								CSREmail,
			(
				Case AXI.Moeda
					When 'REL' then 'BRL'
					else AXI.Moeda
				End
			)								CurrencyCode,
			--'BRL'							CurrencyCode,
			'' 								CustRef1,
			'' 								CustRef2,
			'' 								CustRef3,
			'' 								CustRef4,
			AX.Dimensao_1					Dimensao_1,
			----100-67593 - Incluido o campo Tipo_Prod_Code
			MAX(AXI.Dimensao_2)				Dimensao_2,
			case 
				when Tipo=2 then V.Dimensao3
				else C.Dimensao3
			End								Dimensao_3,
			AX.Dimensao_4					Dimensao_4,
			AX.Dimensao_5					Dimensao_5,
			AX.Dimensao_6					Dimensao_6,
			AX.Dimensao_7					Dimensao_7,
			AX.Dt_Canc							DocumentDate,
			--Numero_Documento				DocumentNum,
			Case when SOL.ID is not null then Convert(Varchar(50),SOL.ID) else isnull(AX.Numero_Documento,AX.invoice_number) END DocumentNum,
			AX.Dt_Vencimento				Due,			
			Max (AXI.Paridade)* 100			ExchRate,
			--1*100							ExchRate,
--			Case 
--				When tipo=2 then @Num_Proc + '.' + Invoice_number +@DC+'.'+@Cd_Tp_TX_ATL +'V'
--				when len(Invoice_number)=15 and tipo <> 2 then @Num_Proc+'.'+isnull(Cod_Int_Moeda,0) +@DC+'.'+@Cd_Tp_TX_ATL + 'V'
--				When Tipo=3 then Invoice_number +'.'+isnull(Cod_Int_Moeda,0) +@DC+'.'+@Cd_Tp_TX_ATL+'_ADVNV'

--				else Invoice_number+'.'+isnull(Cod_Int_Moeda,0) +@DC+'.'+@Cd_Tp_TX_ATL + 'V'
----				else	@Num_Proc + '.' + Invoice_number +@DC+'.'+@Cd_Tp_TX_ATL 
--			End
			--Convert(Varchar(25),AX.id_ax) +'V'					Invoice,
			--AX.invoice_number	+'V'					Invoice,
			--Case when SOL.ID is not null then isnull(Convert(Varchar(50),SOL.Doc_Number)+'V','SP' + Convert(Varchar(50),SOL.ID)) +'V' else Convert(Varchar(50),AX.invoice_number)+'V' END Invoice,
			
			Case when SOL.ID is not null then isnull(Convert(Varchar(50),SOL.Doc_Number),'SP' + Convert(Varchar(50),SOL.ID)) +'V' else 
				Case when LEN(AX.invoice_number) >= 18 then Convert(Varchar(50),AX.ID_AX)+'V' else			
					Convert(Varchar(50),AX.invoice_number)+'V' END END Invoice,
			
			max(AXI.Num_Proc)					JobNbr,
			--'' 								JobNbr,
			max(AXI.MasterBOLNbr)		MasterBOLNbr ,
			--'' 								MasterBOLNbr ,
			max(AXI.MasterBookingNbr)		MasterBookingNbr,
			'' 								O7Invoice,
			--''								PaymId,
			Case when SOL.ID is not null then Convert(Varchar(50),SOL.ID) else '' END PaymId,
			''								PaymMode,
			AX.TaxGroup						TaxGroup,
			Null							TaxItemGroup,
			AX.Dt_Canc							TransDate,
			''								Voucher,
			--abs(sum(dbo.valor(abs(valor),DC))) valor,
			--abs(sum(dbo.valor(abs(valor),DC)) * (Paridade * 100)) valor,
			--sum(abs(dbo.valor(abs(valor),DC)) * (Paridade * 100)) valor,

			--abs(sum(convert(decimal(18,2),dbo.valor(AXI.valor,AXI.DC) * (AXI.Paridade)))) valor,
			abs(sum(dbo.valor(abs(AXI.valor),AXI.DC))) valor,

			--abs(sum(dbo.valor(abs(AXI.valor),AXI.DC))) valor,
			(
				Case 
					when sum(convert(decimal(18,2),dbo.valor(AXI.valor,AXI.DC) * (AXI.Paridade))) > 0 then 'AmountCurCredit'
					else 'AmountCurDebit'
				End
			)								TipoCD,
			--Case 
			--	When tipo=1 and DocumentNum Is not NULL  then 'PT'  estava duplicando em um cancelamento 1785919
			--End										PostingProfile,
			''								PostingProfile,
			--left(Num_Proc  + ' - ' + Nome_Tp_TX,60) TXT,
			''								TXT,
			--Case 
			--	When (Tipo=1 or tipo=3)  then isnull(Invoice_number,max(num_proc)) 
			--	When tipo=2 then max(Num_Proc)
			--End								StatutoryInvoice1_BDP,
			''								StatutoryInvoice1_BDP ,
			--Case 
				
			--	When (Tipo=1 or tipo=3) and @blnDivide =0 then isnull(DocumentNum,'') 
			--	When tipo=2 then Invoice_number
			--End								StatutoryInvoice2_BDP,
			--''								StatutoryInvoice2_BDP ,
			--Case when len(SOL.InfBanco) = 50 then SOL.InfBanco else '' END StatutoryInvoice2_BDP, 
			Case when len(SOL.InfBanco) between 40 and 60 and SOL.Cd_Tp_Doc = 'BLT' then [dbo].[FRemoveCaracteresEspeciais](SOL.InfBanco) else '' END StatutoryInvoice2_BDP,  --changed 2026-03-12 13:30h

			Case when SOL.ID is not null then Convert(Varchar(50),SOL.ID) else '' END PaymReference,
			--'No'							TaxWithholdCalculate,
			'No'							TaxWithholdCalculate ,
			'Ledger'						OffsetAccountType,
			Tipo	,
			''									Cd_Tp_TX
	from 
		AX_Doc AX
		Join AX_DOC_ITem AXI on AXI.ID_AX=AX.ID_AX
		Join Tipo_Moeda TM on TM.Cd_Tp_Moeda=AXI.Moeda
		Join Tipo_Taxa TT on TT.cd_tp_Tx=AXI.Cd_Tp_TX_ATL
		Left Join dbo.AX_XML_Customer_Recebido C on AX.Cd_Pessoa_AX=C.AccountNum and tipo <>2
		left join dbo.AX_XML_Vendor_Recebido V on AX.Cd_Pessoa_AX=V.AccountNum and tipo =2
		left join Sol_Pgto_Cta_Cte SOL on Convert(varchar(25),SOL.ID) = AX.Numero_Documento
		 left join vwNF_Fatura_ALL NF on NF.Num_Proc = AXI.Num_Proc and NF.Cd_Tp_Tx = AXI.cd_tp_Tx_ATL and NF.DC = AXI.DC
	Where 
		AX.id_AX=@id_AX
		--AND Moeda=@Moeda
		--and valor > 0.00 
		--and DC=@DC 
		and AXI.cd_tp_Tx is not null
		--and AXI.cd_Tp_Tx_ATL=@Cd_Tp_TX_ATL 
		--and axi.num_proc=@num_proc
		and axi.cd_tp_Tx <> '000.1' 
		AND NF.ID is null
		and AX.Dt_Canc	is not null 
		and SOL.ID is null
	Group by
		AX.id_ax,AX.cd_pessoa_AX,AX.AccountType,AX.Aprovado,Aprovado_Por,AX.Company,AX.Dimensao_1,
		--AXI.Dimensao_2,
		V.Dimensao3,C.Dimensao3,AX.Dimensao_4,AX.Dimensao_5,AX.Dimensao_6,AX.Dimensao_7,AX.Dt_Canc,
		AX.Numero_Documento,AX.Dt_Vencimento,AX.TaxGroup,AX.Dt_Canc,
		AX.invoice_number,
		AX.Tipo	,SOL.InfBanco
		,SOL.Doc_Number,SOL.ID,SOL.Cd_Tp_Doc,AXI.Moeda
	HAVING
		abs(sum(convert(decimal(18,2),abs(dbo.valor(abs(valor),AXI.DC)) * (AXI.Paridade))))>0

	UNION

		select
			AX.id_ax,
			AX.cd_pessoa_AX					AccountNum,
			''								AH_Ledger,
			AX.AccountType,
			(
				Case AX.Aprovado
					When 1 then 'Yes'
					When 0 then 'No'
				End
			)								Approved,
			AX.Aprovado_Por					ApprovedBy,
			max(AXI.Numero_House)			BDPHouseBOLNbr,
			--''								BDPHouseBOLNbr,
			''								CitCustomerPO,
			AX.Company						Company,
			''								ConsolNbr,
			''								CSREmail,
			(
				Case AXI.Moeda
					When 'REL' then 'BRL'
					else AXI.Moeda
				End
			)								CurrencyCode,
			--'BRL'							CurrencyCode,
			@CustRef1						CustRef1,
			'' 								CustRef2,
			'' 								CustRef3,
			'' 								CustRef4,
			AX.Dimensao_1					Dimensao_1,
			max(AXI.Dimensao_2)					Dimensao_2,
			case 
				when AX.Tipo=2 then V.Dimensao3
				else C.Dimensao3
			End								Dimensao_3,
			AX.Dimensao_4					Dimensao_4,
			AX.Dimensao_5					Dimensao_5,
			AX.Dimensao_6					Dimensao_6,
			AX.Dimensao_7					Dimensao_7,
			AXDOC.dt_canc					DocumentDate,			
			--AX.dt_documento					DocumentDate,
			Case when SOL.ID is not null then Convert(Varchar(50),SOL.ID) else isnull(AX.Numero_Documento,AX.invoice_number) END DocumentNum,
			AX.Dt_Vencimento				Due,
			--1*100							ExchRate,
			max(AXI.Paridade)*100				ExchRate,
			--Case when SOL.ID is not null then isnull(Convert(Varchar(50),SOL.Doc_Number)+'V','SP' + Convert(Varchar(50),SOL.ID)) +'V' else Convert(Varchar(50),AX.invoice_number)+'V' END Invoice,
			
			Case when SOL.ID is not null then isnull(Convert(Varchar(50),SOL.Doc_Number),'SP' + Convert(Varchar(50),SOL.ID)) +'V' else 
				Case when LEN(AX.invoice_number) >= 18 then Convert(Varchar(50),AX.ID_AX)+'V' else			
					Convert(Varchar(50),AX.invoice_number)+'V' END END Invoice,
			
			max(AXI.Num_Proc)					JobNbr,
			max(AXI.MasterBOLNbr)			MasterBOLNbr ,
			--''								MasterBOLNbr ,
			max(AXI.MasterBookingNbr)		MasterBookingNbr,
			''								O7Invoice,
			--''								PaymId,
			Case when SOL.ID is not null then Convert(Varchar(50),SOL.ID) else '' END PaymId,
			''								PaymMode ,
			AX.TaxGroup						TaxGroup,
			Null							TaxItemGroup,
			AXDOC.dt_canc						TransDate,
			''								Voucher,
			--abs(sum(convert(decimal(18,2),dbo.valor(AXI.valor,AXI.DC) * (AXI.Paridade)))) valor,
			--abs((dbo.valor(abs(axi.Valor),axi.DC)))			Valor,
			abs(sum(dbo.valor(abs(AXI.valor),AXI.DC))) valor,
			(
				Case 
					when sum(convert(decimal(18,2),dbo.valor(AXI.valor,AXI.DC) * (AXI.Paridade))) > 0 then 'AmountCurCredit'
					else  'AmountCurDebit'
				End
			)								TipoCD,	

			''								TXT,
			''								PostingProfile,
			''								StatutoryInvoice1_BDP,
			--Case when len(SOL.InfBanco) = 50 then SOL.InfBanco else '' END StatutoryInvoice2_BDP, 
			Case when len(SOL.InfBanco) between 40 and 60 and SOL.Cd_Tp_Doc = 'BLT' then [dbo].[FRemoveCaracteresEspeciais](SOL.InfBanco) else '' END StatutoryInvoice2_BDP,  --changed 2026-03-12 13:30h

			Case when SOL.ID is not null then Convert(Varchar(50),SOL.ID) else '' END PaymReference,	
			'No'							TaxWithholdCalculate ,
			'Ledger'					OffsetAccountType,
			AX.Tipo,
			''									Cd_Tp_TX
		from AX_DOC_Oracle AX with(nolock)
		Join AX_DOC AXDOC with(nolock) on AXDOC.Invoice_Number=AX.Invoice_Number
		Join AX_DOC_Item_Oracle AXI with(nolock) on AXI.id_ax=AX.id_ax
		left join vwNF_Fatura_ALL NF on NF.Num_Proc = AXI.Num_Proc and NF.Cd_Tp_Tx = AXI.cd_tp_Tx_ATL and NF.DC = AXI.DC
		Left Join dbo.AX_XML_Customer_Recebido C on AX.Cd_Pessoa_AX=C.AccountNum and AX.tipo <>2
		left join dbo.AX_XML_Vendor_Recebido V on AX.Cd_Pessoa_AX=V.AccountNum and AX.Tipo =2
		left join Sol_Pgto_Cta_Cte SOL on Convert(varchar(25),SOL.ID) = AX.Numero_Documento
		Where 
			AX.id_AX=@id_AX
			and AXI.cd_tp_Tx is not null
			and axi.cd_tp_Tx <> '000.1'
			and NF.ID is null
			and AXDOC.Dt_Canc	is not null 
		group by
			AX.id_ax,AX.cd_pessoa_AX,AX.AccountType,AX.Aprovado,AX.Aprovado_Por,AX.Company,AX.Dimensao_1,
			V.Dimensao3,C.Dimensao3,
			AX.Dimensao_4,AX.Dimensao_5,AX.Dimensao_6,AX.Dimensao_7,AXDOC.Dt_Canc,AX.Numero_Documento,AX.Dt_Vencimento,AX.TaxGroup,AX.dt_Ins,
			AX.invoice_number,
			AX.Tipo	,SOL.InfBanco
			,SOL.Doc_Number,SOL.ID,SOL.Dt_IssueDate,SOL.Cd_Tp_Doc,AXI.Moeda
		HAVING
			abs(sum(convert(decimal(18,2),abs(dbo.valor(abs(AXI.valor),AXI.DC)) * (AXI.Paridade))))> 0.00

		UNION

		select
			AX.id_ax,
			AX.cd_pessoa_AX					AccountNum,
			''								AH_Ledger,
			AX.AccountType,
			(
				Case AX.Aprovado
					When 1 then 'Yes'
					When 0 then 'No'
				End
			)								Approved,
			AX.Aprovado_Por					ApprovedBy,
			max(AXI.Numero_House)			BDPHouseBOLNbr,
			--''								BDPHouseBOLNbr,
			''								CitCustomerPO,
			AX.Company						Company,
			''								ConsolNbr,
			''								CSREmail,
			(
				Case AXI.Moeda
					When 'REL' then 'BRL'
					else AXI.Moeda
				End
			)								CurrencyCode,
			--'BRL'							CurrencyCode,
			@CustRef1						CustRef1,
			'' 								CustRef2,
			'' 								CustRef3,
			'' 								CustRef4,
			AX.Dimensao_1					Dimensao_1,
			max(AXI.Dimensao_2)					Dimensao_2,
			case 
				when AX.Tipo=2 then V.Dimensao3
				else C.Dimensao3
			End								Dimensao_3,
			AX.Dimensao_4					Dimensao_4,
			AX.Dimensao_5					Dimensao_5,
			AX.Dimensao_6					Dimensao_6,
			AX.Dimensao_7					Dimensao_7,
			AXDOC.dt_canc					DocumentDate,			
			--AX.dt_documento					DocumentDate,
			Case when SOL.ID is not null then Convert(Varchar(50),SOL.ID) else isnull(AX.Numero_Documento,AX.invoice_number) END DocumentNum,
			AX.Dt_Vencimento				Due,
			--1*100							ExchRate,
			max(AXI.Paridade)*100				ExchRate,
			--Case when SOL.ID is not null then isnull(Convert(Varchar(50),SOL.Doc_Number)+'V','SP' + Convert(Varchar(50),SOL.ID)) +'V' else Convert(Varchar(50),AX.invoice_number)+'V' END Invoice,
			
			Case when SOL.ID is not null then isnull(Convert(Varchar(50),SOL.Doc_Number),'SP' + Convert(Varchar(50),SOL.ID)) +'V' else 
				Case when LEN(AX.invoice_number) >= 18 then Convert(Varchar(50),AX.ID_AX)+'V' else			
					Convert(Varchar(50),AX.invoice_number)+'V' END END Invoice,
			
			max(AXI.Num_Proc)					JobNbr,
			max(AXI.MasterBOLNbr)				MasterBOLNbr ,
			--''								MasterBOLNbr ,
			max(AXI.MasterBookingNbr)		MasterBookingNbr,
			''								O7Invoice,
			--''								PaymId,
			Case when SOL.ID is not null then Convert(Varchar(50),SOL.ID) else '' END PaymId,
			''								PaymMode ,
			AX.TaxGroup						TaxGroup,
			Null							TaxItemGroup,
			AXDOC.dt_canc					TransDate,
			''								Voucher,
			--abs(sum(convert(decimal(18,2),dbo.valor(AXI.valor,AXI.DC) * (AXI.Paridade)))) valor,
			--abs((dbo.valor(abs(axi.Valor),axi.DC)))			Valor,
			abs(sum(dbo.valor(abs(AXI.valor),AXI.DC))) valor,
			(
				Case 
					when sum(convert(decimal(18,2),dbo.valor(AXI.valor,AXI.DC) * (AXI.Paridade))) > 0 then 'AmountCurCredit' 
					else 'AmountCurDebit'
				End
			)								TipoCD,	

			''								TXT,
			''								PostingProfile,
			''								StatutoryInvoice1_BDP,
			--Case when len(SOL.InfBanco) = 50 then SOL.InfBanco else '' END StatutoryInvoice2_BDP, 
			Case when len(SOL.InfBanco) between 40 and 60 and SOL.Cd_Tp_Doc = 'BLT' then [dbo].[FRemoveCaracteresEspeciais](SOL.InfBanco) else '' END StatutoryInvoice2_BDP,  --changed 2026-03-12 13:30h

			Case when SOL.ID is not null then Convert(Varchar(50),SOL.ID) else '' END PaymReference,	
			'No'							TaxWithholdCalculate ,
			'Ledger'					OffsetAccountType,
			AX.Tipo,
			''									Cd_Tp_TX
		from AX_DOC_Oracle AX with(nolock)
		--Join vwNF_Fatura_ALL AXDOC with(nolock) on AXDOC.FatCod=AX.Invoice_Number
		Join AX_DOC_Item_Oracle AXI with(nolock) on AXI.id_ax=AX.id_ax
		join vwNF_Fatura_ALL AXDOC on AXDOC.FatCod=AX.Invoice_Number and AXDOC.Num_Proc = AXI.Num_Proc and AXDOC.Cd_Tp_Tx = AXI.cd_tp_Tx_ATL and AXDOC.DC = AXI.DC
		Left Join dbo.AX_XML_Customer_Recebido C on AX.Cd_Pessoa_AX=C.AccountNum and AX.tipo <>2
		left join dbo.AX_XML_Vendor_Recebido V on AX.Cd_Pessoa_AX=V.AccountNum and AX.Tipo =2
		left join Sol_Pgto_Cta_Cte SOL on Convert(varchar(25),SOL.ID) = AX.Numero_Documento
		Where 
			AX.id_AX=@id_AX
			and AXI.cd_tp_Tx is not null
			and axi.cd_tp_Tx <> '000.1'	
			and AXDOC.Dt_Canc	is not null 
		group by
			AX.id_ax,AX.cd_pessoa_AX,AX.AccountType,AX.Aprovado,AX.Aprovado_Por,AX.Company,AX.Dimensao_1,
			V.Dimensao3,C.Dimensao3,
			AX.Dimensao_4,AX.Dimensao_5,AX.Dimensao_6,AX.Dimensao_7,AXDOC.Dt_Canc,AX.Numero_Documento,AX.Dt_Vencimento,AX.TaxGroup,AX.dt_Ins,
			AX.invoice_number,
			AX.Tipo	,SOL.InfBanco
			,SOL.Doc_Number,SOL.ID,SOL.Dt_IssueDate,SOL.Cd_Tp_Doc,AXI.Moeda
		HAVING
			abs(sum(convert(decimal(18,2),abs(dbo.valor(abs(AXI.valor),AXI.DC)) * (AXI.Paridade))))> 0.00
	

	End



GO
