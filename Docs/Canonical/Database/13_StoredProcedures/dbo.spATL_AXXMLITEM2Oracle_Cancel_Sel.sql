SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from Tipo_Tax_AX
--sp_help Tipo_Tax_AX

--select 'CUS SER 15'Cd_Tax_AX,Descricao_Tax_AX,Porcentagem,ISS,IRRF from Tipo_Tax_AX where Cd_Tax_AX = 'CUS SER 13'-- = 15
--union all
--select 'CUS SER 16'Cd_Tax_AX,Descricao_Tax_AX,Porcentagem,ISS,IRRF from Tipo_Tax_AX where Cd_Tax_AX = 'CUS SER 14' --= 16


CREATE Procedure [dbo].[spATL_AXXMLITEM2Oracle_Cancel_Sel]
	@ID_AX int,
	@Cancela int
	
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
--		select			
--			'Item'									Tipo,
--			AXI.ID_Item								InvoiceLineNbr,
--			AX.id_ax,
--			Account_Number							AccountNum,
--			''										AH_Ledger,
--			AXI.AccountType							AccountType,
--			(
--				Case AX.Aprovado
--					When 1 then 'Yes'
--					When 0 then 'No'
--				End
--			)										Approved,
--			AX.Aprovado_Por							ApprovedBy,
--			AXI.Numero_House						BDPHouseBOLNbr,
--			''										CitCustomerPO,
--			AX.Company								Company,
--			AXI.Num_Proc_Master						ConsolNbr,
--			AXI.CSREmail							CSREmail,
--			--(
--			--	Case AXI.Moeda
--			--		When 'REL' then 'BRL'
--			--		else AXI.Moeda
--			--	End
--			--)										CurrencyCode,
--			'BRL'								CurrencyCode,
--			dbo.fBusca_TipoDocCliente('N',AXI.Num_Proc,1) CustRef1,
--			(Case 
--				When AX.Tipo=3 then 'ADV' else '' End) CustRef2,
--			''										CustRef3,
--			''										CustRef4,
--			Isnull(AXI.Dimensao_1,AX.Dimensao_1)	Dimensao_1,
--			Isnull(AXi.Dimensao_2,AX.Dimensao_2)	Dimensao_2,
--			case 
--				when AX.Tipo=2 then V.Dimensao3
--				else C.Dimensao3
--			End										Dimensao_3,
--			--Isnull(AXI.Dimensao_3,AX.Dimensao_3)	Dimensao_3,
--			Isnull(AXI.Dimensao_4,AX.Dimensao_4)	Dimensao_4,
--			Isnull(AXI.Dimensao_5,AX.Dimensao_5)	Dimensao_5,
--			Isnull(AXI.Dimensao_6,AX.Dimensao_6)	Dimensao_6,
--			Isnull(AXI.Dimensao_7,AX.Dimensao_7)	Dimensao_7,
--			--AX.Dt_Documento							DocumentDate,
--			Case when SOL.ID is not null and SOL.Doc_Number is not null and SOL.Dt_IssueDate is not null then SOL.Dt_IssueDate else AX.dt_documento	END DocumentDate,
--			AXI.DocumentNum							DocumentNum,
--			AX.Dt_Vencimento						Due,
--			--AXI.Paridade*100						ExchRate,
--			1*100									ExchRate,
----			Case 
----				When tipo=2 then AXI.Num_Proc + '.' + AX.Invoice_number +trim(AXI.DC)+'.'+AXI.cd_tp_Tx_ATL 
----				when len(AX.Invoice_number)=15 and tipo <> 2 then AXI.Num_Proc+'.'+isnull(TM.Cod_Int_Moeda,0)+ cast(AX.ID_AX as varchar(50)) + trim(AXI.DC)+'.'+AXI.cd_tp_Tx_ATL
----					When Tipo=3 then AX.Invoice_number +'.'+isnull(TM.Cod_Int_Moeda,0) +trim(AXI.DC)+'.'+AXI.cd_tp_Tx_ATL+'_ADV'

----				else AX.Invoice_number+'.'+isnull(TM.Cod_Int_Moeda,0) +trim(AXI.DC)+'.'+AXI.cd_tp_Tx_ATL
------				else	@Num_Proc + '.' + Invoice_number +@DC+'.'+@Cd_Tp_TX_ATL 
----			End										Invoice,

--			--AXI.ID_AX								Invoice,
--			--AX.invoice_number						Invoice,
--			--Case when SOL.ID is not null then isnull(Convert(Varchar(50),SOL.Doc_Number),'SP' + Convert(Varchar(50),SOL.ID)) else Convert(Varchar(50),AX.invoice_number) END Invoice,

--			Case when SOL.ID is not null then isnull(Convert(Varchar(50),SOL.Doc_Number),'SP' + Convert(Varchar(50),SOL.ID)) else 
--				Case when LEN(AX.invoice_number) >= 18 then Convert(Varchar(50),AX.ID_AX) else			
--					Convert(Varchar(50),AX.invoice_number) END END Invoice,

--			AXI.Num_Proc							JobNbr,
--			AXI.MasterBOLNbr						MasterBOLNbr ,
--			AXI.MasterBookingNbr					MasterBookingNbr,	
--			''										PaymId,
--			''										PaymMode ,

--			isnull(V.CountryRegionID,isnull(V.CountryRegionID3,isnull(V.CountryRegionID4,V.CountryRegionID6))) CountryRegionIDV,
--			Case when SOL.ID is not null and SOL.Doc_number is not null and isnull(V.CountryRegionID,isnull(V.CountryRegionID3,isnull(V.CountryRegionID4,V.CountryRegionID6))) ='BR' then 'VEN SER 10' Else
--				Case when SOL.ID is not null and SOL.Doc_number is not null and isnull(V.CountryRegionID,isnull(V.CountryRegionID3,isnull(V.CountryRegionID4,V.CountryRegionID6))) <> 'BR' then 'VEN SER 20' Else
--					AX.TaxGroup
--					END END TaxGroup,

--			--Case when SOL.ID is not null and SOL.Doc_number is not null and E.cd_pais ='BR' then 'VEN SER 10' Else
--			--	Case when SOL.ID is not null and SOL.Doc_number is not null and E.cd_pais <> 'BR' then 'VEN SER 20' Else
--			--		AX.TaxGroup
--			--		END END TaxGroup,		

--			--AX.TaxGroup								TaxGroup,

--			AXI.TaxGroup							TaxItemGroup,
--			AX.dt_Ins								TransDate,
--			''										Voucher,
--			--abs((dbo.valor(abs(AXI.valor),DC)))	* (AXI.Paridade)		valor,
--			--abs((dbo.valor(abs(axi.Valor),axi.DC)))			Valor,
--			convert(decimal(18,2),abs((dbo.valor(abs(AXI.valor),DC)))	* (AXI.Paridade))	valor,
--			(
--				Case 
--					when (dbo.valor(abs(AXI.valor),DC))>0 then 'AmountCurCredit'
--					else 'AmountCurDebit'
--				End
--			)										TipoCD,
--			--AXI.Cd_Tp_TX							Cd_Tp_TX,
--			AXI.cd_tp_Tx_ATL							Cd_Tp_TX,
--			left(AXI.Num_Proc +  ' - ' +TT.Nome_Tp_Tx,60)	TXT,
--			Case 
--				When (AX.Tipo=1 or AX.tipo=3) then isnull(AX.Invoice_number,(num_proc)) 
--				When AX.tipo=2 then (AXI.Num_Proc)
--			End										StatutoryInvoice1_BDP,
--			Case				
--				When (AX.Tipo=1 or AX.Tipo=3) and @blnDivide =0 then isnull(AXI.DocumentNum,'') 
--				--When tipo=2 then Invoice_number
--				When AX.Tipo=2 then isnull(AXI.DocumentNum,AX.Invoice_number)
--			End										StatutoryInvoice2_BDP,
--			(Case AX.Tipo
--				When 1 then 'Cust'
--				when 2 then 'Vend'
--				When 3 then 'Cust'
--				When 4 then 'Vend'
--				When 5 then 'Cust'
--			End)									OffsetAccountType,
--			--cast(AXI.Valor*(TTA.Porcentagem/100) as decimal(10,2)) CorrSalesTaxAmt,
--			0 CorrSalesTaxAmt,

--			Case when SOL.ID is not null and isnull(AXI.citCityHallServiceCode,'') <> '' then SOL.Item_lei else
--				Case when  isnull(AXI.citCityHallServiceCode,'') <> '' AND isnull(TFDR.Item_lei,'') <> ''  then TFDR.Item_lei 
--					else AXI.citCityHallServiceCode End End citCityHallServiceCode,

--			--AXI.citCityHallServiceCode				citCityHallServiceCode,

--			dbo.FRemoveCaracteresEspeciais(AXI.citCityHallServiceDesc)citCityHallServiceDesc,
--			AXI.CitTransDateNF						CitTransDateNF,
--			AXI.[07Invoice]							[07Invoice]
--		 from AX_Doc AX with(nolock)
--			Join AX_Doc_Item AXI with(nolock) on AXI.id_ax=AX.id_ax
--			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=Moeda
--			--Join Tipo_Tax_AX TTA with(nolock) on TTA.cd_tax_AX=AXI.TaxGroup
--			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=AXI.Cd_tp_TX_ATL
--			Left Join dbo.AX_XML_Customer_Recebido C with(nolock) on AX.Cd_Pessoa_AX=C.AccountNum and AX.tipo <>2
--			left join dbo.AX_XML_Vendor_Recebido V with(nolock) on AX.Cd_Pessoa_AX=V.AccountNum and AX.tipo =2
--			join Sol_Pgto_Cta_Cte SOL with(nolock) on Convert(varchar(25),SOL.ID) = AX.Numero_Documento
--			--left join Pessoa_ATL_AX PA with(nolock) on PA.cd_ax =AX.cd_pessoa_ax and PA.tipo='F'
--			--left join Pessoa P with(nolock) on P.cd_Pes =PA.cd_pes
--			--left join Endereco E with(nolock) on E.cd_Pes =P.cd_pes and E.cd_tp_end = 'COM'

--			left join vwTipo_NF_Doc_Register_AX_DOC_Sel TFDR with(nolock) on convert(varchar(50),TFDR.cd_servico) = convert(varchar(50),AXI.citCityHallServiceCode)
--		Where 
--			AX.id_AX=@ID_AX 
--			--and dc=@DC	
--			--and moeda=@Moeda
--			and AXI.valor >0 
--			--and cd_tp_tx_ATL = @cd_tp_tx_ATL 
--			--and axi.num_proc=@Num_Proc
--			and isnull(AXI.cd_tp_TX,'') <> '000.1' 

--		UNION

		select			
			'Item'									Tipo,
			AXI.ID_Item								InvoiceLineNbr,
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
			''										CitCustomerPO,
			AX.Company								Company,
			AXI.Num_Proc_Master						ConsolNbr,
			AXI.CSREmail							CSREmail,
			(
				Case AXI.Moeda
					When 'REL' then 'BRL'
					else AXI.Moeda
				End
			)										CurrencyCode,
			--'BRL'								CurrencyCode,
			dbo.fBusca_TipoDocCliente('N',AXI.Num_Proc,1) CustRef1,
			(Case 
				When AX.Tipo=3 then 'ADV' else '' End) CustRef2,
			''										CustRef3,
			''										CustRef4,
			Isnull(AXI.Dimensao_1,AX.Dimensao_1)	Dimensao_1,
			Isnull(AXi.Dimensao_2,AX.Dimensao_2)	Dimensao_2,
			case 
				when AX.Tipo=2 then V.Dimensao3
				else C.Dimensao3
			End										Dimensao_3,
			--Isnull(AXI.Dimensao_3,AX.Dimensao_3)	Dimensao_3,
			Isnull(AXI.Dimensao_4,AX.Dimensao_4)	Dimensao_4,
			Isnull(AXI.Dimensao_5,AX.Dimensao_5)	Dimensao_5,
			Isnull(AXI.Dimensao_6,AX.Dimensao_6)	Dimensao_6,
			Isnull(AXI.Dimensao_7,AX.Dimensao_7)	Dimensao_7,
			--AX.Dt_Documento							DocumentDate,
			Case when SOL.ID is not null and SOL.Doc_Number is not null and SOL.Dt_IssueDate is not null then SOL.Dt_IssueDate else AX.dt_documento	END DocumentDate,
			AXI.DocumentNum							DocumentNum,
			AX.Dt_Vencimento						Due,
			AXI.Paridade*100						ExchRate,
			--1*100									ExchRate,
--			Case 
--				When tipo=2 then AXI.Num_Proc + '.' + AX.Invoice_number +trim(AXI.DC)+'.'+AXI.cd_tp_Tx_ATL 
--				when len(AX.Invoice_number)=15 and tipo <> 2 then AXI.Num_Proc+'.'+isnull(TM.Cod_Int_Moeda,0)+ cast(AX.ID_AX as varchar(50)) + trim(AXI.DC)+'.'+AXI.cd_tp_Tx_ATL
--					When Tipo=3 then AX.Invoice_number +'.'+isnull(TM.Cod_Int_Moeda,0) +trim(AXI.DC)+'.'+AXI.cd_tp_Tx_ATL+'_ADV'

--				else AX.Invoice_number+'.'+isnull(TM.Cod_Int_Moeda,0) +trim(AXI.DC)+'.'+AXI.cd_tp_Tx_ATL
----				else	@Num_Proc + '.' + Invoice_number +@DC+'.'+@Cd_Tp_TX_ATL 
--			End										Invoice,

			--AXI.ID_AX								Invoice,
			--AX.invoice_number						Invoice,
			--Case when SOL.ID is not null then isnull(Convert(Varchar(50),SOL.Doc_Number),'SP' + Convert(Varchar(50),SOL.ID)) else Convert(Varchar(50),AX.invoice_number) END Invoice,

			Case when SOL.ID is not null then isnull(Convert(Varchar(50),SOL.Doc_Number),'SP' + Convert(Varchar(50),SOL.ID)) +'A'  else 
				Case when LEN(AX.invoice_number) >= 18 then Convert(Varchar(50),AX.ID_AX)+'A'  else			
					Convert(Varchar(50),AX.invoice_number) +'A'  END END Invoice,

			AXI.Num_Proc							JobNbr,
			AXI.MasterBOLNbr						MasterBOLNbr ,
			AXI.MasterBookingNbr					MasterBookingNbr,	
			''										PaymId,
			''										PaymMode ,

			isnull(V.CountryRegionID,isnull(V.CountryRegionID3,isnull(V.CountryRegionID4,V.CountryRegionID6))) CountryRegionIDV,
			Case when SOL.ID is not null and SOL.Doc_number is not null and isnull(V.CountryRegionID,isnull(V.CountryRegionID3,isnull(V.CountryRegionID4,V.CountryRegionID6))) ='BR' then 'VEN SER 10' Else
				Case when SOL.ID is not null and SOL.Doc_number is not null and isnull(V.CountryRegionID,isnull(V.CountryRegionID3,isnull(V.CountryRegionID4,V.CountryRegionID6))) <> 'BR' then 'VEN SER 20' Else
					AX.TaxGroup
					END END TaxGroup,

			--Case when SOL.ID is not null and SOL.Doc_number is not null and E.cd_pais ='BR' then 'VEN SER 10' Else
			--	Case when SOL.ID is not null and SOL.Doc_number is not null and E.cd_pais <> 'BR' then 'VEN SER 20' Else
			--		AX.TaxGroup
			--		END END TaxGroup,		

			--AX.TaxGroup								TaxGroup,

			AXI.TaxGroup							TaxItemGroup,
			AX.dt_Ins								TransDate,
			''										Voucher,
			--abs((dbo.valor(abs(AXI.valor),DC)))	* (AXI.Paridade)		valor,
			abs((dbo.valor(abs(axi.Valor),axi.DC)))			Valor,
			--convert(decimal(18,2),abs((dbo.valor(abs(AXI.valor),DC)))	* (AXI.Paridade))	valor,
			(
				Case 
					when (dbo.valor(abs(AXI.valor),DC))>0 then 'AmountCurCredit'
					else 'AmountCurDebit'
				End
			)										TipoCD,
			--AXI.Cd_Tp_TX							Cd_Tp_TX,
			AXI.cd_tp_Tx_ATL							Cd_Tp_TX,
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
			--cast(AXI.Valor*(TTA.Porcentagem/100) as decimal(10,2)) CorrSalesTaxAmt,
			0 CorrSalesTaxAmt,

			Case when SOL.ID is not null and isnull(AXI.citCityHallServiceCode,'') <> '' then SOL.Item_lei else
				Case when  isnull(AXI.citCityHallServiceCode,'') <> '' AND isnull(TFDR.Item_lei,'') <> ''  then TFDR.Item_lei 
					else AXI.citCityHallServiceCode End End citCityHallServiceCode,

			--AXI.citCityHallServiceCode				citCityHallServiceCode,

			dbo.FRemoveCaracteresEspeciais(AXI.citCityHallServiceDesc)citCityHallServiceDesc,
			AXI.CitTransDateNF						CitTransDateNF,
			AXI.[07Invoice]							[07Invoice]
		 from AX_Doc AX with(nolock)
			Join AX_Doc_Item AXI with(nolock) on AXI.id_ax=AX.id_ax
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=Moeda
			--Join Tipo_Tax_AX TTA with(nolock) on TTA.cd_tax_AX=AXI.TaxGroup
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=AXI.Cd_tp_TX_ATL
			Left Join dbo.AX_XML_Customer_Recebido C with(nolock) on AX.Cd_Pessoa_AX=C.AccountNum and AX.tipo <>2
			left join dbo.AX_XML_Vendor_Recebido V with(nolock) on AX.Cd_Pessoa_AX=V.AccountNum and AX.tipo =2
			left join Sol_Pgto_Cta_Cte SOL with(nolock) on Convert(varchar(25),SOL.ID) = AX.Numero_Documento
			--left join Pessoa_ATL_AX PA with(nolock) on PA.cd_ax =AX.cd_pessoa_ax and PA.tipo='F'
			--left join Pessoa P with(nolock) on P.cd_Pes =PA.cd_pes
			--left join Endereco E with(nolock) on E.cd_Pes =P.cd_pes and E.cd_tp_end = 'COM'

			left join vwTipo_NF_Doc_Register_AX_DOC_Sel TFDR with(nolock) on convert(varchar(50),TFDR.cd_servico) = convert(varchar(50),AXI.citCityHallServiceCode)
		Where 
			AX.id_AX=@ID_AX 
			--and dc=@DC	
			--and moeda=@Moeda
			and AXI.valor >0 
			--and cd_tp_tx_ATL = @cd_tp_tx_ATL 
			--and axi.num_proc=@Num_Proc
			and isnull(AXI.cd_tp_TX,'') <> '000.1'
			and SOL.ID is null

		UNION

			select			
			'Item'									Tipo,
			AXI.ID_Item								InvoiceLineNbr,
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
			''								CitCustomerPO,
			AX.Company								Company,
			AXI.Num_Proc_Master						ConsolNbr,
			AXI.CSREmail							CSREmail,
			(
				Case AXI.Moeda
					When 'REL' then 'BRL'
					else AXI.Moeda
				End
			)										CurrencyCode,
			--'BRL'								CurrencyCode,
			dbo.fBusca_TipoDocCliente('N',AXI.Num_Proc,1) CustRef1,
			(Case 
				When AX.Tipo=3 then 'ADV' else '' End) CustRef2,
			''										CustRef3,
			''										CustRef4,
			Isnull(AXI.Dimensao_1,AX.Dimensao_1)	Dimensao_1,
			Isnull(AXi.Dimensao_2,AX.Dimensao_2)	Dimensao_2,
			case 
				when AX.Tipo=2 then V.Dimensao3
				else C.Dimensao3
			End										Dimensao_3,
			--Isnull(AXI.Dimensao_3,AX.Dimensao_3)	Dimensao_3,
			Isnull(AXI.Dimensao_4,AX.Dimensao_4)	Dimensao_4,
			Isnull(AXI.Dimensao_5,AX.Dimensao_5)	Dimensao_5,
			Isnull(AXI.Dimensao_6,AX.Dimensao_6)	Dimensao_6,
			Isnull(AXI.Dimensao_7,AX.Dimensao_7)	Dimensao_7,
			--AX.Dt_Documento							DocumentDate,
			Case when SOL.ID is not null and SOL.Doc_Number is not null and SOL.Dt_IssueDate is not null then SOL.Dt_IssueDate else AX.dt_documento	END DocumentDate,
			AXI.DocumentNum							DocumentNum,
			AX.Dt_Vencimento						Due,
			AXI.Paridade*100						ExchRate,
			--1*100									ExchRate,
			--AX.invoice_number						Invoice,
			--Case when SOL.ID is not null then isnull(Convert(Varchar(50),SOL.Doc_Number),'SP' + Convert(Varchar(50),SOL.ID)) else Convert(Varchar(50),AX.invoice_number) END Invoice,

			Case when SOL.ID is not null then isnull(Convert(Varchar(50),SOL.Doc_Number),'SP' + Convert(Varchar(50),SOL.ID)) +'A'  else 
				Case when LEN(AX.invoice_number) >= 18 then Convert(Varchar(50),AX.ID_AX) +'A'  else			
					Convert(Varchar(50),AX.invoice_number) +'A'  END END Invoice,

			AXI.Num_Proc							JobNbr,
			AXI.MasterBOLNbr						MasterBOLNbr ,
			AXI.MasterBookingNbr					MasterBookingNbr,	
			''										PaymId,
			''										PaymMode ,
			isnull(V.CountryRegionID,isnull(V.CountryRegionID3,isnull(V.CountryRegionID4,V.CountryRegionID6))) CountryRegionIDV,
			Case when SOL.ID is not null and SOL.Doc_number is not null and isnull(V.CountryRegionID,isnull(V.CountryRegionID3,isnull(V.CountryRegionID4,V.CountryRegionID6))) ='BR' then 'VEN SER 10' Else
				Case when SOL.ID is not null and SOL.Doc_number is not null and isnull(V.CountryRegionID,isnull(V.CountryRegionID3,isnull(V.CountryRegionID4,V.CountryRegionID6))) <> 'BR' then 'VEN SER 20' Else
					AX.TaxGroup
					END END TaxGroup,	

			--Case when SOL.ID is not null and SOL.Doc_number is not null and E.cd_pais ='BR' then 'VEN SER 10' Else
			--	Case when SOL.ID is not null and SOL.Doc_number is not null and E.cd_pais <> 'BR' then 'VEN SER 20' Else
			--		AX.TaxGroup
			--		END END TaxGroup,	
			--AX.TaxGroup								TaxGroup,
			AXI.TaxGroup							TaxItemGroup,
			AX.dt_Ins								TransDate,
			''										Voucher,
			abs((dbo.valor(abs(axi.Valor),axi.DC)))			Valor,
			--convert(decimal(18,2),abs((dbo.valor(abs(AXI.valor),DC)))	* (AXI.Paridade))	valor,
			(
				Case 
					when (dbo.valor(abs(AXI.valor),DC))>0 then 'AmountCurCredit'
					else 'AmountCurDebit'
				End
			)										TipoCD,
			--AXI.Cd_Tp_TX							Cd_Tp_TX,
			AXI.cd_tp_Tx_ATL							Cd_Tp_TX,
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
			--cast(AXI.Valor*(TTA.Porcentagem/100) as decimal(10,2)) CorrSalesTaxAmt,
			0 CorrSalesTaxAmt,

			Case when SOL.ID is not null and isnull(AXI.citCityHallServiceCode,'') <> '' then SOL.Item_lei else
				Case when  isnull(AXI.citCityHallServiceCode,'') <> '' AND isnull(TFDR.Item_lei,'') <> ''  then TFDR.Item_lei 
					else AXI.citCityHallServiceCode End End citCityHallServiceCode,
			--AXI.citCityHallServiceCode				citCityHallServiceCode,


			dbo.FRemoveCaracteresEspeciais(AXI.citCityHallServiceDesc)citCityHallServiceDesc,
			AXI.CitTransDateNF						CitTransDateNF,
			AXI.[07Invoice]							[07Invoice]
		 from AX_DOC_Oracle AX with(nolock) 
			Join AX_DOC_Item_Oracle AXI with(nolock) on AXI.id_ax=AX.id_ax
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=Moeda
			--Join Tipo_Tax_AX TTA with(nolock) on TTA.cd_tax_AX=AXI.TaxGroup
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=AXI.Cd_tp_TX_ATL
			Left Join dbo.AX_XML_Customer_Recebido C with(nolock) on AX.Cd_Pessoa_AX=C.AccountNum and AX.tipo <>2
			left join dbo.AX_XML_Vendor_Recebido V with(nolock) on AX.Cd_Pessoa_AX=V.AccountNum and AX.tipo =2
			left join Sol_Pgto_Cta_Cte SOL with(nolock) on Convert(varchar(25),SOL.ID) = AX.Numero_Documento
			--left join Pessoa_ATL_AX PA with(nolock) on PA.cd_ax =AX.cd_pessoa_ax and PA.tipo='F'
			--left join Pessoa P with(nolock) on P.cd_Pes =PA.cd_pes
			--left join Endereco E with(nolock) on E.cd_Pes =P.cd_pes and E.cd_tp_end = 'COM'

			left join vwTipo_NF_Doc_Register_AX_DOC_Sel TFDR with(nolock) on convert(varchar(50),TFDR.cd_servico) = convert(varchar(50),AXI.citCityHallServiceCode)
		Where 
			AX.id_AX=@ID_AX 
			and AXI.valor >0 
			and isnull(AXI.cd_tp_TX,'') <> '000.1' 
			--and AXI.cd_tp_Tx_ATL in ('XCA','XCQ','XEQ')
		Order by 2
	End 

else

	Begin
--		select		
--			'Item'												Tipo,
--			AXI.ID_Item											InvoiceLineNbr,
--			AX.id_ax,
--			Account_Number										AccountNum,
--			''													AH_Ledger,
--			AXI.AccountType										AccountType,
--			(
--				Case AX.Aprovado
--					When 1 then 'Yes'
--					When 0 then 'No'
--				End
--			)													Approved,
--			AX.Aprovado_Por										ApprovedBy,
--			AXI.Numero_House									BDPHouseBOLNbr,
--			''								CitCustomerPO,
--			AX.Company											Company,
--			AXI.Num_Proc_Master									ConsolNbr,
--			AXI.CSREmail										CSREmail,
--			--(
--			--	Case AXI.Moeda
--			--		When 'REL' then 'BRL'
--			--		else AXI.Moeda
--			--	End
--			--)													CurrencyCode,
--			'BRL'											CurrencyCode,
--			dbo.fBusca_TipoDocCliente('N',AXI.Num_Proc,1)		CustRef1,
--			Case 
--				When AX.Tipo=3 then 'ADV' else '' End			CustRef2,
--			''													CustRef3,
--			''													CustRef4,
--			Isnull(AXI.Dimensao_1, AX.Dimensao_1)				Dimensao_1,
--			Isnull(AXi.Dimensao_2, AX.Dimensao_2)				Dimensao_2,
--			case 
--				when AX.Tipo=2 then V.Dimensao3
--				else C.Dimensao3
--			End													Dimensao_3,
--			Isnull(AXI.Dimensao_4,AX.Dimensao_4)				Dimensao_4,
--			Isnull(AXI.Dimensao_5, AX.Dimensao_5)				Dimensao_5,
--			Isnull(AXI.Dimensao_6,AX.Dimensao_6)				Dimensao_6,
--			Isnull(AXI.Dimensao_7,AX.Dimensao_7)				Dimensao_7,
--			AX.dt_Canc											DocumentDate,
--			AXI.DocumentNum										DocumentNum,
--			AX.Dt_Vencimento									Due,
--			--AXI.Paridade*100									ExchRate,
--			1*100												ExchRate,
----			Case 
----				When AX.Tipo=2 then AXI.Num_Proc + '.' + AX.Invoice_number + trim(AXI.DC)+'.'+AXI.cd_tp_Tx_ATL  + 'VV'
----				when len(AX.Invoice_number)=15 and tipo <> 2 then AXI.Num_Proc+'.'+isnull(TM.Cod_Int_Moeda,0)+ cast(AX.ID_AX as varchar(50)) +trim(AXI.DC)+'.'+axi.cd_tp_Tx_ATL  +'V'
----				When Tipo=3 then Invoice_number +'.'+isnull(Cod_Int_Moeda,0) +trim(AXI.DC)+'.'+axi.cd_tp_Tx_ATL+'_ADVV'

----				else Invoice_number+'.'+isnull(TM.Cod_Int_Moeda,0) +trim(AXI.DC)+'.'+AXI.cd_tp_Tx_ATL  +'V'
------				else	@Num_Proc + '.' + Invoice_number +@DC+'.'+@Cd_Tp_TX_ATL 
----			End													Invoice,
--			--Convert(varchar(25),AXI.ID_AX)  + 'VV'				Invoice,
--			--AX.invoice_number	+ 'VV'						Invoice,
--			--Case when SOL.ID is not null then isnull(Convert(Varchar(50),SOL.Doc_Number) + 'VV','SP' + Convert(Varchar(50),SOL.ID))+ 'VV' 
--			--else Convert(Varchar(50),AX.invoice_number)+ 'VV' END Invoice,

--			Case when SOL.ID is not null then isnull(Convert(Varchar(50),SOL.Doc_Number),'SP' + Convert(Varchar(50),SOL.ID))  +'V' else 
--				Case when LEN(AX.invoice_number) >= 18 then Convert(Varchar(50),AX.ID_AX) +'V' else			
--					Convert(Varchar(50),AX.invoice_number) +'V' END END Invoice,

--			AXI.Num_Proc											JobNbr,
--			MasterBOLNbr										MasterBOLNbr ,
--			MasterBookingNbr									MasterBookingNbr,	
--			''													PaymId,
--			''													PaymMode ,

--			isnull(V.CountryRegionID,isnull(V.CountryRegionID3,isnull(V.CountryRegionID4,V.CountryRegionID6))) CountryRegionIDV,
--			Case when SOL.ID is not null and SOL.Doc_number is not null and isnull(V.CountryRegionID,isnull(V.CountryRegionID3,isnull(V.CountryRegionID4,V.CountryRegionID6))) ='BR' then 'VEN SER 10' Else
--				Case when SOL.ID is not null and SOL.Doc_number is not null and isnull(V.CountryRegionID,isnull(V.CountryRegionID3,isnull(V.CountryRegionID4,V.CountryRegionID6))) <> 'BR' then 'VEN SER 20' Else
--					AX.TaxGroup
--					END END TaxGroup,


--			--Case when SOL.ID is not null and SOL.Doc_number is not null and E.cd_pais ='BR' then 'VEN SER 10' Else
--			--	Case when SOL.ID is not null and SOL.Doc_number is not null and E.cd_pais <> 'BR' then 'VEN SER 20' Else
--			--		AX.TaxGroup
--			--		END END TaxGroup,	
--			--AX.TaxGroup											TaxGroup,
--			AXI.TaxGroup										TaxItemGroup,
--			AX.Dt_Canc											TransDate,
--			''													Voucher,
--			--abs((dbo.valor(abs(axi.Valor),axi.DC)))				Valor,
--			convert(decimal(18,2),abs((dbo.valor(abs(AXI.valor),AXI.DC)))	* (AXI.Paridade))	valor,
--			--sum(convert(decimal(18,2),abs(dbo.valor(abs(valor),DC)) * (Paridade))) valor,
--			(
--				Case 
--					when (dbo.valor(abs(valor),AXI.DC))>0 then 'AmountCurDebit'
--					else 'AmountCurCredit'
--				End
--			)														TipoCD,
--			--AXI.Cd_Tp_TX											Cd_Tp_TX,
--			AXI.cd_tp_Tx_ATL							Cd_Tp_TX,
--			left(AXI.Num_Proc +  ' - ' +TT.Nome_Tp_Tx,60)			TXT,
--			Case 
--				When (AX.Tipo=1 or AX.tipo=3) then isnull(AX.Invoice_number,(AXI.num_proc)) 
--				When AX.tipo=2 then (AXI.Num_Proc)
--			End														StatutoryInvoice1_BDP,
--			Case 
--				When (AX.Tipo=1 or AX.tipo=3) and @blnDivide =0 then isnull(AXI.DocumentNum,'') 
--				--When tipo=2 then Invoice_number
--				When AX.tipo=2 then isnull(AXI.DocumentNum,AX.Invoice_number)
--			End														StatutoryInvoice2_BDP,

--			(Case AX.Tipo
--				When 1 then 'Cust'
--				when 2 then 'Vend'
--				When 3 then 'Cust'
--				When 4 then 'Vend'
--				When 5 then 'Cust'
--			End)													OffsetAccountType,
--			--cast(AXI.Valor*(TTA.Porcentagem/100) as decimal(10,2))	CorrSalesTaxAmt,
--			0 CorrSalesTaxAmt,

--			Case when SOL.ID is not null and isnull(AXI.citCityHallServiceCode,'') <> '' then SOL.Item_lei else
--				Case when  isnull(AXI.citCityHallServiceCode,'') <> '' AND isnull(TFDR.Item_lei,'') <> ''  then TFDR.Item_lei 
--					else AXI.citCityHallServiceCode End End citCityHallServiceCode,
--			--AXI.citCityHallServiceCode								citCityHallServiceCode,

--			dbo.FRemoveCaracteresEspeciais(AXI.citCityHallServiceDesc)citCityHallServiceDesc,
--			AXI.CitTransDateNF										CitTransDateNF,
--			AXI.[07Invoice]											[07Invoice]	
--		 from AX_Doc AX with(nolock)
--			Join AX_Doc_Item AXI with(nolock) on AXI.id_ax=AX.id_ax
--			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=Moeda
--			--Join Tipo_TAX_AX TTA with(nolock) on TTA.cd_tax_AX=AXI.TaxGroup
--			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=AXI.Cd_tp_TX_ATL
--			Left Join dbo.AX_XML_Customer_Recebido C with(nolock) on AX.Cd_Pessoa_AX=C.AccountNum and AX.tipo <>2
--			left join dbo.AX_XML_Vendor_Recebido V with(nolock) on AX.Cd_Pessoa_AX=V.AccountNum and AX.tipo =2
--			left join Sol_Pgto_Cta_Cte SOL with(nolock) on Convert(varchar(25),SOL.ID) = AX.Numero_Documento
--			--left join Pessoa_ATL_AX PA with(nolock) on PA.cd_ax =AX.cd_pessoa_ax and PA.tipo='F'
--			--left join Pessoa P with(nolock) on P.cd_Pes =PA.cd_pes
--			--left join Endereco E with(nolock) on E.cd_Pes =P.cd_pes and E.cd_tp_end = 'COM'

--			left join vwTipo_NF_Doc_Register_AX_DOC_Sel TFDR with(nolock) on convert(varchar(50),TFDR.cd_servico) = convert(varchar(50),AXI.citCityHallServiceCode)

--			 left join vwNF_FaturaValidas NF on NF.Num_Proc = AXI.Num_Proc and NF.Cd_Tp_Tx = AXI.cd_tp_Tx_ATL and NF.DC = AXI.DC
--		Where 
--			AX.id_AX=@ID_AX
--			--and dc=@DC	
--			--and moeda=@Moeda
--			and AXI.valor > 0 
--			and AXI.cd_tp_Tx is not null 
--			--and	cd_tp_tx_ATL = @cd_tp_tx_ATL 
--			--and axi.num_proc=@Num_Proc
--			and AXI.cd_tp_TX <> '000.1'
--			AND NF.ID is null
--			AND AX.dt_Canc	 is not null 
--		UNION

			select			
			'Item'									Tipo,
			AXI.ID_Item								InvoiceLineNbr,
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
			''								CitCustomerPO,
			AX.Company								Company,
			AXI.Num_Proc_Master						ConsolNbr,
			AXI.CSREmail							CSREmail,
			--(
			--	Case AXI.Moeda
			--		When 'REL' then 'BRL'
			--		else AXI.Moeda
			--	End
			--)										CurrencyCode,
			'BRL'								CurrencyCode,
			dbo.fBusca_TipoDocCliente('N',AXI.Num_Proc,1) CustRef1,
			(Case 
				When AX.Tipo=3 then 'ADV' else '' End) CustRef2,
			''										CustRef3,
			''										CustRef4,
			Isnull(AXI.Dimensao_1,AX.Dimensao_1)	Dimensao_1,
			Isnull(AXi.Dimensao_2,AX.Dimensao_2)	Dimensao_2,
			case 
				when AX.Tipo=2 then V.Dimensao3
				else C.Dimensao3
			End										Dimensao_3,
			--Isnull(AXI.Dimensao_3,AX.Dimensao_3)	Dimensao_3,
			Isnull(AXI.Dimensao_4,AX.Dimensao_4)	Dimensao_4,
			Isnull(AXI.Dimensao_5,AX.Dimensao_5)	Dimensao_5,
			Isnull(AXI.Dimensao_6,AX.Dimensao_6)	Dimensao_6,
			Isnull(AXI.Dimensao_7,AX.Dimensao_7)	Dimensao_7,
			--AX.Dt_Documento							DocumentDate,
			--AX.dt_Canc							DocumentDate,
			DATEADD(day,1,AX.Dt_Ins)				DocumentDate,
			AXI.DocumentNum							DocumentNum,
			AX.Dt_Vencimento						Due,
			1*100									ExchRate,
			--AXI.Paridade*100						ExchRate,
			--AX.invoice_number						Invoice,
			--Case when SOL.ID is not null then isnull(Convert(Varchar(50),SOL.Doc_Number) + 'VV','SP' + Convert(Varchar(50),SOL.ID))+ 'VV' 
			--else Convert(Varchar(50),AX.invoice_number)+ 'VV' END Invoice,

			Case when SOL.ID is not null then isnull(Convert(Varchar(50),SOL.Doc_Number),'SP' + Convert(Varchar(50),SOL.ID))  +'V' else 
				Case when LEN(AX.invoice_number) >= 18 then Convert(Varchar(50),AX.ID_AX) +'V' else			
					Convert(Varchar(50),AX.invoice_number) +'V' END END Invoice,

			AXI.Num_Proc							JobNbr,
			AXI.MasterBOLNbr						MasterBOLNbr ,
			AXI.MasterBookingNbr					MasterBookingNbr,	
			''										PaymId,
			''										PaymMode ,
			isnull(V.CountryRegionID,isnull(V.CountryRegionID3,isnull(V.CountryRegionID4,V.CountryRegionID6))) CountryRegionIDV,
			Case when SOL.ID is not null and SOL.Doc_number is not null and isnull(V.CountryRegionID,isnull(V.CountryRegionID3,isnull(V.CountryRegionID4,V.CountryRegionID6))) ='BR' then 'VEN SER 10' Else
				Case when SOL.ID is not null and SOL.Doc_number is not null and isnull(V.CountryRegionID,isnull(V.CountryRegionID3,isnull(V.CountryRegionID4,V.CountryRegionID6))) <> 'BR' then 'VEN SER 20' Else
					AX.TaxGroup
					END END TaxGroup,	

			--Case when SOL.ID is not null and SOL.Doc_number is not null and E.cd_pais ='BR' then 'VEN SER 10' Else
			--	Case when SOL.ID is not null and SOL.Doc_number is not null and E.cd_pais <> 'BR' then 'VEN SER 20' Else
			--		AX.TaxGroup
			--		END END TaxGroup,	
			--AX.TaxGroup								TaxGroup,
			AXI.TaxGroup							TaxItemGroup,
			--AX.Dt_Canc								TransDate,
			DATEADD(day,1,AX.Dt_Ins)				TransDate,
			''										Voucher,
			--abs((dbo.valor(abs(axi.Valor),axi.DC)))			Valor,
			convert(decimal(18,2),abs((dbo.valor(abs(AXI.valor),AXI.DC)))	* (AXI.Paridade))	valor,
			(
				Case 
					when (dbo.valor(abs(AXI.valor),AXI.DC))>0 then 'AmountCurDebit' 
					else 'AmountCurCredit'
				End
			)										TipoCD,
			--AXI.Cd_Tp_TX							Cd_Tp_TX,
			AXI.cd_tp_Tx_ATL							Cd_Tp_TX,
			left(AXI.Num_Proc +  ' - ' +TT.Nome_Tp_Tx,60)	TXT,
			Case 
				When (AX.Tipo=1 or AX.tipo=3) then isnull(AX.Invoice_number,(AXI.num_proc)) 
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
			--cast(AXI.Valor*(TTA.Porcentagem/100) as decimal(10,2)) CorrSalesTaxAmt,
			0 CorrSalesTaxAmt,

			Case when SOL.ID is not null and isnull(AXI.citCityHallServiceCode,'') <> '' then SOL.Item_lei else
				Case when  isnull(AXI.citCityHallServiceCode,'') <> '' AND isnull(TFDR.Item_lei,'') <> ''  then TFDR.Item_lei 
					else AXI.citCityHallServiceCode End End citCityHallServiceCode,
			--AXI.citCityHallServiceCode				citCityHallServiceCode,

			dbo.FRemoveCaracteresEspeciais(AXI.citCityHallServiceDesc)citCityHallServiceDesc,
			AXI.CitTransDateNF						CitTransDateNF,
			AXI.[07Invoice]							[07Invoice]
		--from AX_DOC_Oracle AX with(nolock)
		--	Join AX_DOC AXDOC with(nolock) on AXDOC.Invoice_Number=AX.Invoice_Number
		--	Join AX_DOC_Item_Oracle AXI with(nolock) on AXI.id_ax=AX.id_ax
		 from AX_DOC AX with(nolock)			
			Join AX_DOC_Item AXI with(nolock) on AXI.id_ax=AX.id_ax
			left join vwNF_Fatura_ALL NF with(nolock) on NF.Num_Proc = AXI.Num_Proc and NF.Cd_Tp_Tx = AXI.cd_tp_Tx_ATL and NF.DC = AXI.DC
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=Moeda
			--Join Tipo_Tax_AX TTA with(nolock) on TTA.cd_tax_AX=AXI.TaxGroup
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=AXI.Cd_tp_TX_ATL
			Left Join dbo.AX_XML_Customer_Recebido C with(nolock) on AX.Cd_Pessoa_AX=C.AccountNum and AX.tipo <>2
			left join dbo.AX_XML_Vendor_Recebido V with(nolock) on AX.Cd_Pessoa_AX=V.AccountNum and AX.tipo =2
			left join Sol_Pgto_Cta_Cte SOL with(nolock) on Convert(varchar(25),SOL.ID) = AX.Numero_Documento
			--left join Pessoa_ATL_AX PA with(nolock) on PA.cd_ax =AX.cd_pessoa_ax and PA.tipo='F'
			--left join Pessoa P with(nolock) on P.cd_Pes =PA.cd_pes
			--left join Endereco E with(nolock) on E.cd_Pes =P.cd_pes and E.cd_tp_end = 'COM'

			left join vwTipo_NF_Doc_Register_AX_DOC_Sel TFDR with(nolock) on convert(varchar(50),TFDR.cd_servico) = convert(varchar(50),AXI.citCityHallServiceCode)
		Where 
			AX.id_AX=@ID_AX 
			and AXI.valor >0 
			and isnull(AXI.cd_tp_TX,'') <> '000.1'
			and NF.ID is null
			--and AXDOC.dt_Canc	 is not null 

		UNION

		select 		
			'Item'									Tipo,
			AXI.ID_Item								InvoiceLineNbr,
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
			''								CitCustomerPO,
			AX.Company								Company,
			AXI.Num_Proc_Master						ConsolNbr,
			AXI.CSREmail							CSREmail,
			--(
			--	Case AXI.Moeda
			--		When 'REL' then 'BRL'
			--		else AXI.Moeda
			--	End
			--)										CurrencyCode,
			'BRL'								CurrencyCode,
			dbo.fBusca_TipoDocCliente('N',AXI.Num_Proc,1) CustRef1,
			(Case 
				When AX.Tipo=3 then 'ADV' else '' End) CustRef2,
			''										CustRef3,
			''										CustRef4,
			Isnull(AXI.Dimensao_1,AX.Dimensao_1)	Dimensao_1,
			Isnull(AXi.Dimensao_2,AX.Dimensao_2)	Dimensao_2,
			case 
				when AX.Tipo=2 then V.Dimensao3
				else C.Dimensao3
			End										Dimensao_3,
			--Isnull(AXI.Dimensao_3,AX.Dimensao_3)	Dimensao_3,
			Isnull(AXI.Dimensao_4,AX.Dimensao_4)	Dimensao_4,
			Isnull(AXI.Dimensao_5,AX.Dimensao_5)	Dimensao_5,
			Isnull(AXI.Dimensao_6,AX.Dimensao_6)	Dimensao_6,
			Isnull(AXI.Dimensao_7,AX.Dimensao_7)	Dimensao_7,
			--AX.Dt_Documento							DocumentDate,
			--AXDOC.dt_Canc							DocumentDate,
			DATEADD(day,1,AXDOC.FatDtEmissao)		DocumentDate,
			AXI.DocumentNum							DocumentNum,
			AX.Dt_Vencimento						Due,
			1*100									ExchRate,
			--AXI.Paridade*100						ExchRate,
			--AX.invoice_number						Invoice,
			--Case when SOL.ID is not null then isnull(Convert(Varchar(50),SOL.Doc_Number) + 'VV','SP' + Convert(Varchar(50),SOL.ID))+ 'VV' 
			--else Convert(Varchar(50),AX.invoice_number)+ 'VV' END Invoice,

			Case when SOL.ID is not null then isnull(Convert(Varchar(50),SOL.Doc_Number),'SP' + Convert(Varchar(50),SOL.ID))  +'V' else 
				Case when LEN(AX.invoice_number) >= 18 then Convert(Varchar(50),AX.ID_AX) +'V' else			
					Convert(Varchar(50),AX.invoice_number) +'V' END END Invoice,

			AXI.Num_Proc							JobNbr,
			AXI.MasterBOLNbr						MasterBOLNbr ,
			AXI.MasterBookingNbr					MasterBookingNbr,	
			''										PaymId,
			''										PaymMode ,
			isnull(V.CountryRegionID,isnull(V.CountryRegionID3,isnull(V.CountryRegionID4,V.CountryRegionID6))) CountryRegionIDV,
			Case when SOL.ID is not null and SOL.Doc_number is not null and isnull(V.CountryRegionID,isnull(V.CountryRegionID3,isnull(V.CountryRegionID4,V.CountryRegionID6))) ='BR' then 'VEN SER 10' Else
				Case when SOL.ID is not null and SOL.Doc_number is not null and isnull(V.CountryRegionID,isnull(V.CountryRegionID3,isnull(V.CountryRegionID4,V.CountryRegionID6))) <> 'BR' then 'VEN SER 20' Else
					AX.TaxGroup
					END END TaxGroup,	

			--Case when SOL.ID is not null and SOL.Doc_number is not null and E.cd_pais ='BR' then 'VEN SER 10' Else
			--	Case when SOL.ID is not null and SOL.Doc_number is not null and E.cd_pais <> 'BR' then 'VEN SER 20' Else
			--		AX.TaxGroup
			--		END END TaxGroup,	
			--AX.TaxGroup								TaxGroup,
			AXI.TaxGroup							TaxItemGroup,
			--AXDOC.Dt_Canc								TransDate,
			DATEADD(day,1,AXDOC.FatDtEmissao)		TransDate,	
			''										Voucher,
			--abs((dbo.valor(abs(axi.Valor),axi.DC)))			Valor,
			convert(decimal(18,2),abs((dbo.valor(abs(AXI.valor),AXI.DC)))	* (AXI.Paridade))	valor,
			(
				Case 
					when (dbo.valor(abs(AXI.valor),AXI.DC))>0 then 'AmountCurDebit' 
					else 'AmountCurCredit'
				End
			)										TipoCD,
			--AXI.Cd_Tp_TX							Cd_Tp_TX,
			AXI.cd_tp_Tx_ATL							Cd_Tp_TX,
			left(AXI.Num_Proc +  ' - ' +TT.Nome_Tp_Tx,60)	TXT,
			Case 
				When (AX.Tipo=1 or AX.tipo=3) then isnull(AX.Invoice_number,(AXI.num_proc)) 
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
			--cast(AXI.Valor*(TTA.Porcentagem/100) as decimal(10,2)) CorrSalesTaxAmt,
			0 CorrSalesTaxAmt,

			Case when SOL.ID is not null and isnull(AXI.citCityHallServiceCode,'') <> '' then SOL.Item_lei else
				Case when  isnull(AXI.citCityHallServiceCode,'') <> '' AND isnull(TFDR.Item_lei,'') <> ''  then TFDR.Item_lei 
					else AXI.citCityHallServiceCode End End citCityHallServiceCode,
			--AXI.citCityHallServiceCode				citCityHallServiceCode,

			dbo.FRemoveCaracteresEspeciais(AXI.citCityHallServiceDesc)citCityHallServiceDesc,
			AXI.CitTransDateNF						CitTransDateNF,
			AXI.[07Invoice]							[07Invoice]
		 from AX_DOC_Oracle AX with(nolock)
			--Join vwNF_Fatura_ALL AXDOC with(nolock) on AXDOC.FatCod=AX.Invoice_Number
			Join AX_DOC_Item_Oracle AXI with(nolock) on AXI.id_ax=AX.id_ax
			join vwNF_Fatura_ALL AXDOC on AXDOC.Num_Proc = AXI.Num_Proc and AXDOC.Cd_Tp_Tx = AXI.cd_tp_Tx_ATL and AXDOC.DC = AXI.DC and AXDOC.FatCod=AX.Invoice_Number
			--join vwNF_Fatura_ALL AXDOC with(nolock) on AXDOC.Num_Proc = AXI.Num_Proc and AXDOC.Cd_Tp_Tx = AXI.cd_tp_Tx_ATL and AXDOC.DC = AXI.DC
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=Moeda
			--Join Tipo_Tax_AX TTA with(nolock) on TTA.cd_tax_AX=AXI.TaxGroup
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=AXI.Cd_tp_TX_ATL
			Left Join dbo.AX_XML_Customer_Recebido C with(nolock) on AX.Cd_Pessoa_AX=C.AccountNum and AX.tipo <>2
			left join dbo.AX_XML_Vendor_Recebido V with(nolock) on AX.Cd_Pessoa_AX=V.AccountNum and AX.tipo =2
			left join Sol_Pgto_Cta_Cte SOL with(nolock) on Convert(varchar(25),SOL.ID) = AX.Numero_Documento
			--left join Pessoa_ATL_AX PA with(nolock) on PA.cd_ax =AX.cd_pessoa_ax and PA.tipo='F'
			--left join Pessoa P with(nolock) on P.cd_Pes =PA.cd_pes
			--left join Endereco E with(nolock) on E.cd_Pes =P.cd_pes and E.cd_tp_end = 'COM'

			left join vwTipo_NF_Doc_Register_AX_DOC_Sel TFDR with(nolock) on convert(varchar(50),TFDR.cd_servico) = convert(varchar(50),AXI.citCityHallServiceCode)
		Where 
			AX.id_AX=@ID_AX
			and AXI.valor >0 
			and isnull(AXI.cd_tp_TX,'') <> '000.1'		
			--and AXDOC.dt_Canc	 is not null 

		UNION
			select		
				'Item'												Tipo,
				AXI.ID_Item											InvoiceLineNbr,
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
				''								CitCustomerPO,
				AX.Company											Company,
				AXI.Num_Proc_Master									ConsolNbr,
				AXI.CSREmail										CSREmail,
				--(
				--	Case AXI.Moeda
				--		When 'REL' then 'BRL'
				--		else AXI.Moeda
				--	End
				--)													CurrencyCode,
				'BRL'											CurrencyCode,
				dbo.fBusca_TipoDocCliente('N',AXI.Num_Proc,1)		CustRef1,
				Case 
					When AX.Tipo=3 then 'ADV' else '' End			CustRef2,
				''													CustRef3,
				''													CustRef4,
				Isnull(AXI.Dimensao_1, AX.Dimensao_1)				Dimensao_1,
				Isnull(AXi.Dimensao_2, AX.Dimensao_2)				Dimensao_2,
				case 
					when AX.Tipo=2 then V.Dimensao3
					else C.Dimensao3
				End													Dimensao_3,
				Isnull(AXI.Dimensao_4,AX.Dimensao_4)				Dimensao_4,
				Isnull(AXI.Dimensao_5, AX.Dimensao_5)				Dimensao_5,
				Isnull(AXI.Dimensao_6,AX.Dimensao_6)				Dimensao_6,
				Isnull(AXI.Dimensao_7,AX.Dimensao_7)				Dimensao_7,
				AX.dt_Canc											DocumentDate,
				AXI.DocumentNum										DocumentNum,
				AX.Dt_Vencimento									Due,
				--AXI.Paridade*100									ExchRate,
				1*100												ExchRate,
	--			Case 
	--				When AX.Tipo=2 then AXI.Num_Proc + '.' + AX.Invoice_number + trim(AXI.DC)+'.'+AXI.cd_tp_Tx_ATL  + 'VV'
	--				when len(AX.Invoice_number)=15 and tipo <> 2 then AXI.Num_Proc+'.'+isnull(TM.Cod_Int_Moeda,0)+ cast(AX.ID_AX as varchar(50)) +trim(AXI.DC)+'.'+axi.cd_tp_Tx_ATL  +'V'
	--				When Tipo=3 then Invoice_number +'.'+isnull(Cod_Int_Moeda,0) +trim(AXI.DC)+'.'+axi.cd_tp_Tx_ATL+'_ADVV'

	--				else Invoice_number+'.'+isnull(TM.Cod_Int_Moeda,0) +trim(AXI.DC)+'.'+AXI.cd_tp_Tx_ATL  +'V'
	----				else	@Num_Proc + '.' + Invoice_number +@DC+'.'+@Cd_Tp_TX_ATL 
	--			End													Invoice,
				--Convert(varchar(25),AXI.ID_AX)  + 'VV'				Invoice,
				--AX.invoice_number	+ 'VV'						Invoice,
				--Case when SOL.ID is not null then isnull(Convert(Varchar(50),SOL.Doc_Number) + 'VV','SP' + Convert(Varchar(50),SOL.ID))+ 'VV' 
				--else Convert(Varchar(50),AX.invoice_number)+ 'VV' END Invoice,

				Case when SOL.ID is not null then isnull(Convert(Varchar(50),SOL.Doc_Number),'SP' + Convert(Varchar(50),SOL.ID))  +'V' else 
					Case when LEN(AX.invoice_number) >= 18 then Convert(Varchar(50),AX.ID_AX) +'V' else			
						Convert(Varchar(50),AX.invoice_number) +'V' END END Invoice,

				AXI.Num_Proc											JobNbr,
				MasterBOLNbr										MasterBOLNbr ,
				MasterBookingNbr									MasterBookingNbr,	
				''													PaymId,
				''													PaymMode ,

				isnull(V.CountryRegionID,isnull(V.CountryRegionID3,isnull(V.CountryRegionID4,V.CountryRegionID6))) CountryRegionIDV,
				Case when SOL.ID is not null and SOL.Doc_number is not null and isnull(V.CountryRegionID,isnull(V.CountryRegionID3,isnull(V.CountryRegionID4,V.CountryRegionID6))) ='BR' then 'VEN SER 10' Else
					Case when SOL.ID is not null and SOL.Doc_number is not null and isnull(V.CountryRegionID,isnull(V.CountryRegionID3,isnull(V.CountryRegionID4,V.CountryRegionID6))) <> 'BR' then 'VEN SER 20' Else
						AX.TaxGroup
						END END TaxGroup,


				--Case when SOL.ID is not null and SOL.Doc_number is not null and E.cd_pais ='BR' then 'VEN SER 10' Else
				--	Case when SOL.ID is not null and SOL.Doc_number is not null and E.cd_pais <> 'BR' then 'VEN SER 20' Else
				--		AX.TaxGroup
				--		END END TaxGroup,	
				--AX.TaxGroup											TaxGroup,
				AXI.TaxGroup										TaxItemGroup,
				AX.Dt_Canc											TransDate,
				''													Voucher,
				--abs((dbo.valor(abs(axi.Valor),axi.DC)))				Valor,
				convert(decimal(18,2),abs((dbo.valor(abs(AXI.valor),AXI.DC)))	* (AXI.Paridade))	valor,
				--sum(convert(decimal(18,2),abs(dbo.valor(abs(valor),DC)) * (Paridade))) valor,
				(
					Case 
						when (dbo.valor(abs(valor),AXI.DC))>0 then 'AmountCurDebit'
						else 'AmountCurCredit'
					End
				)														TipoCD,
				--AXI.Cd_Tp_TX											Cd_Tp_TX,
				AXI.cd_tp_Tx_ATL							Cd_Tp_TX,
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
				--cast(AXI.Valor*(TTA.Porcentagem/100) as decimal(10,2))	CorrSalesTaxAmt,
				0 CorrSalesTaxAmt,

				Case when SOL.ID is not null and isnull(AXI.citCityHallServiceCode,'') <> '' then SOL.Item_lei else
					Case when  isnull(AXI.citCityHallServiceCode,'') <> '' AND isnull(TFDR.Item_lei,'') <> ''  then TFDR.Item_lei 
						else AXI.citCityHallServiceCode End End citCityHallServiceCode,
				--AXI.citCityHallServiceCode								citCityHallServiceCode,

				dbo.FRemoveCaracteresEspeciais(AXI.citCityHallServiceDesc)citCityHallServiceDesc,
				AXI.CitTransDateNF										CitTransDateNF,
				AXI.[07Invoice]											[07Invoice]	
			 from AX_Doc_oracle AX with(nolock)
				Join AX_DOC_Item_Oracle AXI with(nolock) on AXI.id_ax=AX.id_ax
				Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=Moeda
				--Join Tipo_TAX_AX TTA with(nolock) on TTA.cd_tax_AX=AXI.TaxGroup
				Join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=AXI.Cd_tp_TX_ATL
				Left Join dbo.AX_XML_Customer_Recebido C with(nolock) on AX.Cd_Pessoa_AX=C.AccountNum and AX.tipo <>2
				left join dbo.AX_XML_Vendor_Recebido V with(nolock) on AX.Cd_Pessoa_AX=V.AccountNum and AX.tipo =2
				left join Sol_Pgto_Cta_Cte SOL with(nolock) on Convert(varchar(25),SOL.ID) = AX.Numero_Documento
				--left join Pessoa_ATL_AX PA with(nolock) on PA.cd_ax =AX.cd_pessoa_ax and PA.tipo='F'
				--left join Pessoa P with(nolock) on P.cd_Pes =PA.cd_pes
				--left join Endereco E with(nolock) on E.cd_Pes =P.cd_pes and E.cd_tp_end = 'COM'

				left join vwTipo_NF_Doc_Register_AX_DOC_Sel TFDR with(nolock) on convert(varchar(50),TFDR.cd_servico) = convert(varchar(50),AXI.citCityHallServiceCode)

				--left join vwNF_FaturaValidas NF on NF.Num_Proc = AXI.Num_Proc and NF.Cd_Tp_Tx = AXI.cd_tp_Tx_ATL and NF.DC = AXI.DC
			Where 
				AX.id_AX=@ID_AX
				--and dc=@DC	
				--and moeda=@Moeda
				and AXI.valor > 0 
				and AXI.cd_tp_Tx is not null 
				--and	cd_tp_tx_ATL = @cd_tp_tx_ATL 
				--and axi.num_proc=@Num_Proc
				and AXI.cd_tp_TX <> '000.1'
				--AND NF.ID is null
				--AND AX.dt_Canc	 is not null 





		Order by 2
	End 




GO
