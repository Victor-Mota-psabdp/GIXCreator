SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[pDJS_Ledger_Header_Sel]
(
	@ID			BIGINT,
	@MessageID	varchar(max),
	@AH_Ledger	NVARCHAR(10),		
	@Type		CHAR(1)
)
AS


Declare @blnDivide bit
Declare @InvoiceNumber Varchar(40)
Declare @CSR	Varchar(100) --Ultimo usuario que criou ou alterou a taxa
	
If ((select COUNT(distinct moeda) from AX_Doc_Item where ID_AX=@ID)>1)
	begin
		Set @blnDivide=1
	End
else
	Begin
		Set @blnDivide=0	
	End

		Declare @Paridade Decimal(10,4)
		Declare @Total float
		Declare @int int
		
		Set @Int=(select count(distinct(paridade)) From Ax_DOC_Item  where ID_AX=@ID) --Moeda=@Moeda AND  )
		if @Int >1 
			Begin
				Set @Paridade=(select top 1 paridade from Ax_DOC_Item  where ID_AX=@ID and [07Invoice] is not null) --Moeda=@Moeda AND )
			End
		if @Paridade is null or @Paridade =0 
			BEgin
				Set @Paridade=(select top 1 paridade from Ax_DOC_Item  where ID_AX=@ID) --Moeda=@Moeda AND  )
			End

BEGIN
    IF @Type = 'A' --'0'
    BEGIN
		select 
			AX.id_ax						MessageID,
			AX.id_ax						ReverseMessageID,
			''								AH_Ledger,
			cd_pessoa_AX					AccountNum,			
			AX.AccountType,
			(
				Case Aprovado
					When 1 then 'Yes'
					When 0 then 'No'
				End
			)								Approved,
			Aprovado_Por					ApprovedBy,
			--Numero_House					BDPHouseBOLNbr,
			''								BDPHouseBOLNbr,
			AX.Company						Company,
			''								ConsolNbr,
			CSREmail						CSREmail,
			(
				Case Moeda
					When 'REL' then 'BRL'
					else Moeda
				End
			)								CurrencyCode,
			--dbo.fBusca_TipoDocCliente('N',Num_Proc,1) CustRef1,
			'' 								CustRef1,
			'' 								CustRef2,
			'' 								CustRef3,
			'' 								CustRef4,
			AX.Dimensao_1					Dimension_1,
			----100-67593 - Incluido o campo Dimensao_2
			AXI.Dimensao_2					Dimension_2,
			AX.Dimensao_3					Dimension_3,
			AX.Dimensao_4					Dimension_4,
			AX.Dimensao_5					Dimension_5,
			AX.Dimensao_6					Dimension_6,
			AX.Dimensao_7					Dimension_7,
			dt_documento					DocumentDate,
			Numero_Documento				DocumentNum,
			AX.Dt_Vencimento				Due,
			max(paridade)*100				ExchRate,
--			Case 
--				When tipo=2 then @Num_Proc + '.' + Invoice_number +@DC+'.'+@Cd_Tp_TX_ATL 
--				when len(Invoice_number)=15 and tipo <> 2 then @Num_Proc+'.'+isnull(Cod_Int_Moeda,0) + cast(AX.ID_AX as varchar(50)) +@DC+'.'+@Cd_Tp_TX_ATL
--				When Tipo=3 then Invoice_number +'.'+isnull(Cod_Int_Moeda,0) +@DC+'.'+@Cd_Tp_TX_ATL+'_ADVN'
--				else Invoice_number+'.'+isnull(Cod_Int_Moeda,0) +@DC+'.'+@Cd_Tp_TX_ATL
----				else	@Num_Proc + '.' + Invoice_number +@DC+'.'+@Cd_Tp_TX_ATL 
--			End								Invoice,
			AX.id_ax						Invoice,			
			--Num_Proc						JobNbr,
			'' 								JobNbr,
			--MasterBOLNbr					MasterBOLNbr ,
			''								MasterBOLNbr ,
			''								MasterBookingNbr,
			''								O7Invoice,
			''								PaymId,
			''								PaymMode ,
			AX.TaxGroup						TaxGroup,
			Null							TaxItemGroup,
			AX.dt_Ins						TransDate,
			--'2013-10-31' TransDate,
			''								Voucher,
			abs(sum(dbo.valor(abs(valor),DC))) [Value],
			(
				Case 
					when sum(dbo.valor(abs(valor),DC))>0 then 'AmountCurDebit'
					else 'AmountCurCredit'
				End
			)								TypeCD,	
			--left(Num_PRoc + ' - ' + Nome_tp_tx,60)   TXT,
			''								TXT,
			''									Cd_Tp_TX,
			Case 
				When tipo=1 and DocumentNum Is not NULL  then 'PT' 
			End								PostingProfile,
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
			''								StatutoryInvoice2_BDP,

			Case 
				when right(AXI.Cd_Tp_TX,1)='1' then 'No'
				else 'Yes'
			End							 TaxWithholdCalculate,
			'Ledger'					OffsetAccountType,
			Tipo	[Type],
			

			1 Oracle_UserID,
			1 IsActive,
			getdate() CreatedDate,
			getdate() UpdatedDate,
			getdate() CanceledDate
		from ax_doc AX with(nolock)
		Join AX_DOC_ITem AXI with(nolock) on AXI.id_ax=AX.id_ax
		LEFT Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=AXI.Moeda
		Join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=AXI.cd_tp_Tx_ATL
		Where 
			AX.id_AX='1783795'
			--AND Moeda=@Moeda
			and valor >0.00 
			--and DC=@DC 
			and AXI.cd_tp_Tx is not null
			--and cd_Tp_Tx_ATL=@Cd_Tp_TX_ATL 
			--And AXI.num_proc=@Num_Proc 
			and axi.cd_tp_Tx <> '000.1' 
		group by
			AX.id_ax,AX.cd_pessoa_AX,AX.AccountType,Aprovado,
			Aprovado_Por,AX.Company,CSREmail,Moeda,
			AX.Dimensao_1,AXI.Dimensao_2,AX.Dimensao_3,AX.Dimensao_4,AX.Dimensao_5,
			AX.Dimensao_6,AX.Dimensao_7,dt_documento,Numero_Documento,AX.Dt_Vencimento,AX.id_ax,
			AX.TaxGroup,AX.dt_Ins,DocumentNum,AXI.Cd_Tp_TX,Tipo
		HAVING
			abs(sum(dbo.valor(abs(valor),DC)))>0.00
       
    END

	IF @Type = 'B'
    BEGIN
        select
			AX.id_ax						ID,
			AX.id_ax						MessageID,
			AX.id_ax						ReverseMessageID,
			''								AH_Ledger,
			cd_pessoa_AX					AccountNum,			
			AX.AccountType					AccountType,

			(
				Case Aprovado
					When 1 then 'Yes'
					When 0 then 'No'
				End
			)								Approved,
			Aprovado_Por					ApprovedBy,
			''								BDPHouseBOLNbr,
			AX.Company						Company,
			''								ConsolNbr,
			''								CSREmail,
			(
				Case Moeda
					When 'REL' then 'BRL'
					else Moeda
				End
			)								CurrencyCode,
			'' 								CustRef1,
			'' 								CustRef2,
			'' 								CustRef3,
			'' 								CustRef4,
			AX.Dimensao_1					Dimension_1,
			----100-67593 - Incluido o campo Tipo_Prod_Code
			AXI.Dimensao_2					Dimension_2,
			case 
				when Tipo=2 then V.Dimensao3
				else C.Dimensao3
			End								Dimension_3,
			AX.Dimensao_4					Dimension_4,
			AX.Dimensao_5					Dimension_5,
			AX.Dimensao_6					Dimension_6,
			AX.Dimensao_7					Dimension_7,
			Dt_Canc							DocumentDate,
			Numero_Documento				DocumentNum,
			AX.Dt_Vencimento				Due,
			Max (Paridade)* 100				ExchRate,
--			Case 
--				When tipo=2 then @Num_Proc + '.' + Invoice_number +@DC+'.'+@Cd_Tp_TX_ATL +'V'
--				when len(Invoice_number)=15 and tipo <> 2 then @Num_Proc+'.'+isnull(Cod_Int_Moeda,0) +@DC+'.'+@Cd_Tp_TX_ATL + 'V'
--				When Tipo=3 then Invoice_number +'.'+isnull(Cod_Int_Moeda,0) +@DC+'.'+@Cd_Tp_TX_ATL+'_ADVNV'

--				else Invoice_number+'.'+isnull(Cod_Int_Moeda,0) +@DC+'.'+@Cd_Tp_TX_ATL + 'V'
----				else	@Num_Proc + '.' + Invoice_number +@DC+'.'+@Cd_Tp_TX_ATL 
--			End
			AX.id_ax						Invoice,
			'' 								JobNbr,
			'' 								MasterBOLNbr ,
			'' 								MasterBookingNbr,
			'' 								O7Invoice,
			''								PaymId,
			''								PaymMode,
			AX.TaxGroup						TaxGroup,
			Null							TaxItemGroup,
			Dt_Canc							TransDate,
			''								Voucher,
			abs(sum(dbo.valor(abs(valor),DC))) [Value],
			(
				Case 
					when sum(dbo.valor(abs(valor),DC))>0 then 'AmountCurCredit'
					else 'AmountCurDebit'
				End
			)								TypeCD,
			Case 
				When tipo=1 and DocumentNum Is not NULL  then 'PT' 
			End
											PostingProfile,
			--left(Num_Proc  + ' - ' + Nome_Tp_TX,60) TXT,
			''								TXT,
			''								Cd_Tp_TX,
			--Case 
			--	When (Tipo=1 or tipo=3)  then isnull(Invoice_number,max(num_proc)) 
			--	When tipo=2 then max(Num_Proc)
			--End								StatutoryInvoice1_BDP,
			''								StatutoryInvoice1_BDP ,
			--Case 
				
			--	When (Tipo=1 or tipo=3) and @blnDivide =0 then isnull(DocumentNum,'') 
			--	When tipo=2 then Invoice_number
			--End								StatutoryInvoice2_BDP,
			''								StatutoryInvoice2_BDP ,
			'No'							TaxWithholdCalculate,
			'Ledger'						OffsetAccountType,
			Tipo [Type]	,
			1 Oracle_UserID,
			1 IsActive,
			getdate() CreatedDate,
			getdate() UpdatedDate,
			getdate() CanceledDate
			
	from 
		AX_Doc AX
		Join AX_DOC_ITem AXI on AXI.ID_AX=AX.ID_AX
		Join Tipo_Moeda TM on TM.Cd_Tp_Moeda=AXI.Moeda
		Join Tipo_Taxa TT on TT.cd_tp_Tx=AXI.Cd_Tp_TX_ATL
		Left Join dbo.AX_XML_Customer_Recebido C on AX.Cd_Pessoa_AX=C.AccountNum and tipo <>2
		left join dbo.AX_XML_Vendor_Recebido V on AX.Cd_Pessoa_AX=V.AccountNum and tipo =2
	Where 
		AX.id_AX='1783795'
			--AND Moeda=@Moeda
		and valor >0.00 
			--and DC=@DC 
		and AXI.cd_tp_Tx is not null
			--and AXI.cd_Tp_Tx_ATL=@Cd_Tp_TX_ATL 
			--and axi.num_proc=@num_proc
		and axi.cd_tp_Tx <> '000.1' 
	Group by
		AX.id_ax,AX.cd_pessoa_AX,AX.AccountType,AX.Aprovado,
		Aprovado_Por,AX.Company,Moeda,AX.Dimensao_1,AXI.Dimensao_2,V.Dimensao3,
		C.Dimensao3,AX.Dimensao_4,AX.Dimensao_5,AX.Dimensao_6,AX.Dimensao_7,AX.Dt_Canc,
		AX.Numero_Documento,AX.Dt_Vencimento,
		--Max (Paridade)* 100				ExchRate,
		AX.TaxGroup,AX.Dt_Canc,AXI.DocumentNum,AX.Tipo	
	HAVING
			abs(sum(dbo.valor(abs(valor),DC)))>0
    END

	IF @Type = 'C'
    BEGIN
        select
			AX.id_ax						ID,
			AX.id_ax						MessageID,
			AX.id_ax						ReverseMessageID,
			''								AH_Ledger,
			cd_pessoa_AX					AccountNum,			
			AX.AccountType					AccountType,

			(
				Case Aprovado
					When 1 then 'Yes'
					When 0 then 'No'
				End
			)								Approved,
			Aprovado_Por					ApprovedBy,
			''								BDPHouseBOLNbr,
			AX.Company						Company,
			''								ConsolNbr,
			''								CSREmail,
			(
				Case Moeda
					When 'REL' then 'BRL'
					else Moeda
				End
			)								CurrencyCode,
			'' 								CustRef1,
			'' 								CustRef2,
			'' 								CustRef3,
			'' 								CustRef4,
			AX.Dimensao_1					Dimension_1,
			----100-67593 - Incluido o campo Tipo_Prod_Code
			AXI.Dimensao_2					Dimension_2,
			case 
				when Tipo=2 then V.Dimensao3
				else C.Dimensao3
			End								Dimension_3,
			AX.Dimensao_4					Dimension_4,
			AX.Dimensao_5					Dimension_5,
			AX.Dimensao_6					Dimension_6,
			AX.Dimensao_7					Dimension_7,
			Dt_Canc							DocumentDate,
			Numero_Documento				DocumentNum,
			AX.Dt_Vencimento				Due,
			Max (Paridade)* 100				ExchRate,
--			Case 
--				When tipo=2 then @Num_Proc + '.' + Invoice_number +@DC+'.'+@Cd_Tp_TX_ATL +'V'
--				when len(Invoice_number)=15 and tipo <> 2 then @Num_Proc+'.'+isnull(Cod_Int_Moeda,0) +@DC+'.'+@Cd_Tp_TX_ATL + 'V'
--				When Tipo=3 then Invoice_number +'.'+isnull(Cod_Int_Moeda,0) +@DC+'.'+@Cd_Tp_TX_ATL+'_ADVNV'

--				else Invoice_number+'.'+isnull(Cod_Int_Moeda,0) +@DC+'.'+@Cd_Tp_TX_ATL + 'V'
----				else	@Num_Proc + '.' + Invoice_number +@DC+'.'+@Cd_Tp_TX_ATL 
--			End
			AX.id_ax						Invoice,
			'' 								JobNbr,
			'' 								MasterBOLNbr ,
			'' 								MasterBookingNbr,
			'' 								O7Invoice,
			''								PaymId,
			''								PaymMode,
			AX.TaxGroup						TaxGroup,
			Null							TaxItemGroup,
			Dt_Canc							TransDate,
			''								Voucher,
			abs(sum(dbo.valor(abs(valor),DC))) [Value],
			(
				Case 
					when sum(dbo.valor(abs(valor),DC))>0 then 'AmountCurCredit'
					else 'AmountCurDebit'
				End
			)								TypeCD,
			Case 
				When tipo=1 and DocumentNum Is not NULL  then 'PT' 
			End
											PostingProfile,
			--left(Num_Proc  + ' - ' + Nome_Tp_TX,60) TXT,
			''								TXT,
			''								Cd_Tp_TX,
			--Case 
			--	When (Tipo=1 or tipo=3)  then isnull(Invoice_number,max(num_proc)) 
			--	When tipo=2 then max(Num_Proc)
			--End								StatutoryInvoice1_BDP,
			''								StatutoryInvoice1_BDP ,
			--Case 
				
			--	When (Tipo=1 or tipo=3) and @blnDivide =0 then isnull(DocumentNum,'') 
			--	When tipo=2 then Invoice_number
			--End								StatutoryInvoice2_BDP,
			''								StatutoryInvoice2_BDP ,
			'No'							TaxWithholdCalculate,
			'Ledger'						OffsetAccountType,
			Tipo [Type]	,
			1 Oracle_UserID,
			1 IsActive,
			getdate() CreatedDate,
			getdate() UpdatedDate,
			getdate() CanceledDate
			
	from 
		AX_Doc AX
		Join AX_DOC_ITem AXI on AXI.ID_AX=AX.ID_AX
		Join Tipo_Moeda TM on TM.Cd_Tp_Moeda=AXI.Moeda
		Join Tipo_Taxa TT on TT.cd_tp_Tx=AXI.Cd_Tp_TX_ATL
		Left Join dbo.AX_XML_Customer_Recebido C on AX.Cd_Pessoa_AX=C.AccountNum and tipo <>2
		left join dbo.AX_XML_Vendor_Recebido V on AX.Cd_Pessoa_AX=V.AccountNum and tipo =2
	Where 
		AX.id_AX='1783795'
			--AND Moeda=@Moeda
		and valor >0.00 
			--and DC=@DC 
		and AXI.cd_tp_Tx is not null
			--and AXI.cd_Tp_Tx_ATL=@Cd_Tp_TX_ATL 
			--and axi.num_proc=@num_proc
		and axi.cd_tp_Tx <> '000.1' 
	Group by
		AX.id_ax,AX.cd_pessoa_AX,AX.AccountType,AX.Aprovado,
		Aprovado_Por,AX.Company,Moeda,AX.Dimensao_1,AXI.Dimensao_2,V.Dimensao3,
		C.Dimensao3,AX.Dimensao_4,AX.Dimensao_5,AX.Dimensao_6,AX.Dimensao_7,AX.Dt_Canc,
		AX.Numero_Documento,AX.Dt_Vencimento,
		--Max (Paridade)* 100				ExchRate,
		AX.TaxGroup,AX.Dt_Canc,AXI.DocumentNum,AX.Tipo	
	HAVING
			abs(sum(dbo.valor(abs(valor),DC)))>0
    END
END

GO
