SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PRocedure [dbo].[spInseriResultadoJob_Temp]-- 'EMAET201205001BR'

@Num_Proc	Varchar(16)


AS


Declare @GR				Decimal(10,2)
Declare @Costs			Decimal(10,2)
Declare	@NF				Decimal(10,2)
Declare @CHB_Credito	Decimal(10,2)
Declare @CHB_Debito		Decimal(10,2)
Declare @CHB_Saldo		Decimal(10,2)
Declare @Custo_Master	Decimal(10,2)
Declare @NR				Decimal(10,2)

Declare @Num_Master		Varchar(14)
Declare @Qty			Int

Set @GR=(select sum(vlr_pgto_Rcto_hia) from vwcxas where num_proc_hia=@Num_Proc and dc_hia='C' and left(cd_Tp_Tx,1)<> 'X')
Set @Costs=(select sum(vlr_pgto_Rcto_hia) from vwcxas where num_proc_hia=@Num_Proc and dc_hia='D' and left(cd_Tp_Tx,1)<> 'X')
Set @NF=
		(
		select sum(Isnull(Vlr_Pgto_Rcto_Hia,Vlr_Pgto_NF_HIA)) from vwcta_Cte cta
		Left Join vwcxas CXA on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
		Join Base_Nota_Fiscal NF on nota_fiscal=num_nf_hia and ref_Acesso=ref_acesso_nf_hia		
		where cta.num_proc_hia=@Num_Proc and cta.dc_hia='C' and left(cta.cd_Tp_Tx,1)<> 'X'	
		)
Set @CHB_Credito=(select sum(vlr_pgto_Rcto_hia) from vwcxas where num_proc_hia=@Num_Proc and dc_hia='C' and left(cd_Tp_Tx,1)= 'X')
Set @CHB_Debito=(select sum(vlr_pgto_Rcto_hia) from vwcxas where num_proc_hia=@Num_Proc and dc_hia='D' and left(cd_Tp_Tx,1)= 'X')
print 'procurar o mastter'
SEt @Num_Master=(select Master from vwcliente where num_proc=@Num_Proc)

if @Num_Master <> 'JOB'
	Begin
		Set @Qty=(select count(num_proc) from vwcliente where master=@Num_Master)
	End
if @Qty is null or @Qty=0
	Begin
		Set @Qty=1
	End

Set @Custo_Master = (select sum(dbo.valor(vlr_pgto_rcto_hia,dc_hia)) from vwcxas where num_proc_hia=@Num_Master)
Set @Custo_Master= @Custo_Master/@Qty

delete dbo.Rentabilidade_Job_Temp where num_proc=@num_proc

insert Rentabilidade_Job_Temp
SElect @Num_Proc,@GR,@Costs,@NF,@CHB_Credito,@CHB_Debito,@CHB_Saldo,@Custo_Master,@NR


GO
