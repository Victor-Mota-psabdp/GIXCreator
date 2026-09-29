SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  Procedure [dbo].[spReportManagerInvoiceTotal_Sel] --[dbo].[spReportManagerInvoiceTotal_Sel]  'EMCSR20091110701'
	@Num_Proc	Varchar(16)
AS

Declare @ValorTotalInvoice Decimal(10,2)
Declare @Cd_Tp_Moeda	Varchar(3)
Declare @Incoterm		Varchar(3)
Declare @Seguro			Decimal(10,2)
Declare @Frete			Decimal(10,2)

Set @Seguro=0
Set @Frete=0
SEt @ValorTotalInvoice=0

Set @ValorTotalInvoice=
Isnull((
select 
	Sum(
	Case Upper(Tipo_Unid) 
		When 'KG' then Peso_Liquido * Preco_Unit
	Else
		quantidade*capacidade*preco_unit
	End) TOTAL

from invoice_det ID

Join Invoice_Cliente IC on IC.id_inv=ID.id_inv
Join Produto_Cliente PC on PC.cd_prod=ID.cd_produto

Where
	Num_PRoc=@Num_Proc

),0)

select top 1 @Cd_Tp_Moeda=Cd_Tp_Moeda,@incoterm=Incoterm from pedido P
Join Pedido_Ship  PS on PS.cd_pedido=P.cd_pedido
where num_proc=@Num_Proc

If @Incoterm='CIF' or @Incoterm='CFR' or @Incoterm='CPT'  or @Incoterm='CIP'  
	Begin
		if Upper(Left(@Num_PRoc,2)) ='EM'
			Begin
				Set @Frete=Isnull((select Vlr_Frete_Tot_Hem from house_exp_mar where num_proc_hem=@Num_proc),0)
			End
		if Upper(Left(@Num_PRoc,2)) ='EO'
			Begin
				Set @Frete=Isnull((select Vlr_Frete_efet_Heo from house_exp_out where num_proc_heo=@Num_proc),0)
			End
		if Upper(Left(@Num_PRoc,2)) ='EA'
			Begin
				Set @Frete=Isnull((select Vlr_Frete_Tot_Hea from house_exp_aer where num_proc_hea=@Num_proc),0)
		End
	End

Else
	Begin	
		set @Frete=0
	End

if @Incoterm='CIP' or @Incoterm='CIF'  
	Begin
		set @Seguro=Isnull((select sum(vlr_seguro) from invoice_Cliente where num_proc=@num_proc),0)
	End
Else
	Begin
		set @Seguro=0
	End

SEt @ValorTotalInvoice=@ValorTotalInvoice + @Seguro + @Frete

if Upper(Left(@Num_PRoc,2)) ='EM'
	Begin
		Update LLP_Exp_Mar set Cd_Moeda_Invoice=@Cd_TP_Moeda,Vlr_Invoice=@ValorTotalInvoice where num_proc_lem=@Num_Proc and vlr_Invoice is null

	End

if Upper(Left(@Num_PRoc,2)) ='EO'
	Begin
		Update LLP_Exp_OUT set Cd_Moeda_Invoice=@Cd_TP_Moeda,Vlr_Invoice=@ValorTotalInvoice where num_proc_leo=@Num_Proc and vlr_Invoice is null

	End

if Upper(Left(@Num_PRoc,2)) ='EA'
	Begin
		Update LLP_Exp_aer set Cd_Moeda_Invoice=@Cd_TP_Moeda,Vlr_Invoice=@ValorTotalInvoice where num_proc_lea=@Num_Proc and vlr_Invoice is null

	End

GO
