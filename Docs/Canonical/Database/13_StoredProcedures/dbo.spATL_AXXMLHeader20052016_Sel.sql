SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_AXXMLHeader20052016_Sel] 
	@id_AX int,
	@Moeda VArchar(40),
	@Cancela int,
	@DC char(1),
	@Cd_Tp_TX_ATL varchar(3),
	@Num_Proc varchar(16)
as

Declare @blnDivide bit
Declare @InvoiceNumber Varchar(40)
Declare @CSR	Varchar(100) --Ultimo usuario que criou ou alterou a taxa


	
If ((select COUNT(distinct moeda) from AX_Doc_Item where ID_AX=@id_AX)>1)
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
		
		Set @Int=(select count(distinct(paridade)) From Ax_DOC_Item  where Moeda=@Moeda AND ID_AX=@ID_aX )
		if @Int >1 
			Begin
				Set @Paridade=(select top 1 paridade from Ax_DOC_Item  where Moeda=@Moeda AND ID_AX=@ID_aX and [07Invoice] is not null)
			End
		if @Paridade is null or @Paridade =0 
			BEgin
				Set @Paridade=(select top 1 paridade from Ax_DOC_Item  where Moeda=@Moeda AND ID_AX=@ID_aX )
			End
		if @Int >1 
			Begin
			
				Update Ax_DoC_Item set paridade=@paridade where Moeda=@Moeda AND ID_AX=@ID_aX
			End

If @Cancela =0

	Begin

		select 


			AX.id_ax,
			cd_pessoa_AX AccountNum,
			AX.AccountType,
			(
				Case Aprovado
					When 1 then 'Yes'
					When 0 then 'No'
				End
			) Approved,
			Aprovado_Por ApprovedBy,
			Numero_House  BDPHouseBOLNbr,
			AX.Company,
			'' ConsolNbr,
			CSREmail   CSREmail,
			(
				Case Moeda
					When 'REL' then 'BRL'
					else Moeda
				End
			)
			CurrencyCode,
			dbo.fBusca_TipoDocCliente('N',Num_Proc,1) CustRef1,
			'' CustRef2,
			'' CustRef3,
			'' CustRef4,
			AX.Dimensao_1,
			AX.Dimensao_2,
			AX.Dimensao_3,
			AX.Dimensao_4,
			AX.Dimensao_5,
			AX.Dimensao_6,
			AX.Dimensao_7,
			dt_documento DocumentDate,
			Numero_Documento DocumentNum,
			AX.Dt_Vencimento Due,
			max(
			
			--@Paridade
			paridade
			
			)*100 ExchRate,
			Case 
				When tipo=2 then @Num_Proc + '.' + Invoice_number +@DC+'.'+@Cd_Tp_TX_ATL 
				when len(Invoice_number)=15 and tipo <> 2 then @Num_Proc+'.'+isnull(Cod_Int_Moeda,0) + cast(AX.ID_AX as varchar(50)) +@DC+'.'+@Cd_Tp_TX_ATL
				When Tipo=3 then Invoice_number +'.'+isnull(Cod_Int_Moeda,0) +@DC+'.'+@Cd_Tp_TX_ATL+'_ADVN'
				else Invoice_number+'.'+isnull(Cod_Int_Moeda,0) +@DC+'.'+@Cd_Tp_TX_ATL
--				else	@Num_Proc + '.' + Invoice_number +@DC+'.'+@Cd_Tp_TX_ATL 
			End
			Invoice,
			Num_Proc  JobNbr,
			MasterBOLNbr  MasterBOLNbr ,
			'' MasterBookingNbr,
			'' O7Invoice,
			'' PaymId,
			'' PaymMode ,
			AX.TaxGroup TaxGroup,
			Null TaxItemGroup,
			AX.dt_Ins TransDate,
			--'2013-10-31' TransDate,
			'' Voucher,
			abs(sum(dbo.valor(abs(valor),DC))) Valor,
			(
				Case 
					when sum(dbo.valor(abs(valor),DC))>0 then 'AmountCurDebit'
					else 'AmountCurCredit'
				End
			) TipoCD,
			
			
				left(Num_PRoc + ' - ' + Nome_tp_tx,60)  
			
			      TXT,

			Case 
				when (Tipo=1 or tipo=3) and @blnDivide =1 then isnull(Invoice_number,max(num_proc))+'.'+isnull(Cod_Int_Moeda,0)  
				When (Tipo=1 or tipo=3) and @blnDivide =0 then isnull(Invoice_number,max(num_proc)) 
				When tipo=2 then max(Num_Proc)
			End   StatutoryInvoice1_BDP,
			Case 
				
				When (Tipo=1 or tipo=3) and @blnDivide =0 then isnull(DocumentNum,'') 
				When tipo=2 then Invoice_number
			End   StatutoryInvoice2_BDP,

			Case 
				when right(AXI.Cd_Tp_TX,1)='1' then 'No'
				else 'Yes'
			End
			 TaxWithholdCalculate,
			'Ledger' OffsetAccountType,
			Tipo
			
		 from ax_doc AX
		Join AX_DOC_ITem AXI on AXI.id_ax=AX.id_ax
		LEFT Join Tipo_Moeda TM on TM.cd_tp_moeda=Moeda
		Join Tipo_Taxa TT on TT.cd_tp_Tx=AXI.cd_tp_Tx_ATL
	--	Left Join @TableJob T on T.Num_Proc = AXI.Num_Proc 
		Where 
			AX.id_AX=@id_AX AND   Moeda=@Moeda
		and valor >0.00 and DC=@DC and 	AXI.cd_tp_Tx is not null
		and cd_Tp_Tx_ATL=@Cd_Tp_TX_ATL 
		And AXI.num_proc=@Num_Proc 
		and axi.cd_tp_Tx <> '000.1' 
		group by AX.id_ax ,cd_pessoa_AX,AX.AccountType,Aprovado,Aprovado_Por,AX.Company, Moeda,AX.Dimensao_1,AX.Dimensao_2,AX.Dimensao_3,
		AX.Dimensao_4,	AX.Dimensao_5,	AX.Dimensao_6,	AX.Dimensao_7,dt_documento,Numero_Documento, Dt_Vencimento, Invoice_number,AX.Dt_INS,Cod_Int_Moeda,Tipo,
		AX.TaxGroup ,AXI.cd_tp_Tx,numero_house,CSREmail,num_proc,MasterBOLNbr,DocumentNum  ,Nome_tp_Tx
		HAVING
			abs(sum(dbo.valor(abs(valor),DC)))>0.00
		
	End
Else

	Begin
		select 

			AX.id_ax,
			cd_pessoa_AX AccountNum,
			AX.AccountType,
			(
				Case Aprovado
					When 1 then 'Yes'
					When 0 then 'No'
				End
			) Approved,
			Aprovado_Por ApprovedBy,
			'' BDPHouseBOLNbr,
			AX.Company,
			'' ConsolNbr,
			'' CSREmail,
			(
				Case Moeda
					When 'REL' then 'BRL'
					else Moeda
				End
			)
			CurrencyCode,
			'' CustRef1,
			'' CustRef2,
			'' CustRef3,
			'' CustRef4,
			AX.Dimensao_1,
			AX.Dimensao_2,
			case 
				when Tipo=2 then V.Dimensao3
				else C.Dimensao3
			End	Dimensao_3,
			AX.Dimensao_4,
			AX.Dimensao_5,
			AX.Dimensao_6,
			AX.Dimensao_7,
			Dt_Canc DocumentDate,
			Numero_Documento DocumentNum,
			AX.Dt_Vencimento Due,
			Max (Paridade)* 100 ExchRate,
			Case 
				When tipo=2 then @Num_Proc + '.' + Invoice_number +@DC+'.'+@Cd_Tp_TX_ATL
				when len(Invoice_number)=15 and tipo <> 2 then @Num_Proc+'.'+isnull(Cod_Int_Moeda,0) +@DC+'.'+@Cd_Tp_TX_ATL
				When Tipo=3 then Invoice_number +'.'+isnull(Cod_Int_Moeda,0) +@DC+'.'+@Cd_Tp_TX_ATL+'_ADVN'

				else Invoice_number+'.'+isnull(Cod_Int_Moeda,0) +@DC+'.'+@Cd_Tp_TX_ATL
--				else	@Num_Proc + '.' + Invoice_number +@DC+'.'+@Cd_Tp_TX_ATL 
			End
			Invoice,
			'' JobNbr,
			'' MasterBOLNbr ,
			'' MasterBookingNbr,
			'' O7Invoice,
			'' PaymId,
			'' PaymMode ,
				AX.TaxGroup TaxGroup,
			Null TaxItemGroup,
			Dt_Canc TransDate,
			'' Voucher,
			abs(sum(dbo.valor(abs(valor),DC))) Valor,
			(
				Case 
					when sum(dbo.valor(abs(valor),DC))>0 then 'AmountCurCredit'
					else 'AmountCurDebit'
				End
			) TipoCD,
			
			left(Num_Proc  + ' - ' + Nome_Tp_TX,60) TXT,
			Case 
				When (Tipo=1 or tipo=3)  then isnull(Invoice_number,max(num_proc)) 
				When tipo=2 then max(Num_Proc)
			End   StatutoryInvoice1_BDP,
			Case 
				
				When (Tipo=1 or tipo=3) and @blnDivide =0 then isnull(DocumentNum,'') 
				When tipo=2 then Invoice_number
			End   StatutoryInvoice2_BDP,

			'No' TaxWithholdCalculate,
			'Ledger' OffsetAccountType,
			Tipo
			
from 
	ax_doc AX
	Join AX_DOC_ITem AXI on AXI.id_ax=AX.id_ax
	Join Tipo_Moeda TM on TM.cd_tp_moeda=Moeda
	Join Tipo_Taxa TT on TT.cd_tp_Tx=Cd_Tp_TX_ATL
	Left Join dbo.AX_XML_Customer_Recebido C on cd_pessoa_AX=C.accountnum and tipo <>2
	left join dbo.AX_XML_Vendor_Recebido V on cd_pessoa_AX=V.accountnum and tipo =2
Where AX.id_AX=@id_AX AND   Moeda=@Moeda
		and valor >0.00 and DC=@DC and 	AXI.cd_tp_Tx is not null
		and AXI.cd_Tp_Tx_ATL=@Cd_Tp_TX_ATL 
		and axi.num_proc=@num_proc
		and axi.cd_tp_Tx <> '000.1' 
	group by AX.id_ax ,cd_pessoa_AX,AX.AccountType,Aprovado,Aprovado_Por,AX.Company, Moeda,AX.Dimensao_1,AX.Dimensao_2,AX.Dimensao_3,
		AX.Dimensao_4,	AX.Dimensao_5,	AX.Dimensao_6,	AX.Dimensao_7,dt_documento,Numero_Documento, Dt_Vencimento, Invoice_number,AX.Dt_INS,paridade,Cod_Int_Moeda,Tipo,
		AX.TaxGroup ,Dt_Canc,Num_Proc,Nome_tp_tx,DocumentNum,C.dimensao3,V.dimensao3
		HAVING
			abs(sum(dbo.valor(abs(valor),DC)))>0

	End


GO
