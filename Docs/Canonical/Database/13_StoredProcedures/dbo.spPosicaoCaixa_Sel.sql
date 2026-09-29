SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  Procedure spPosicaoCaixa_Sel --spPosicaoCaixa_Sel 'IMCSR201301001BR'
	@Num_Proc varchar(16)
as

Declare @int int
Declare  @CaixaCredito decimal(18,2)
Declare @CaixaDebito	Decimal(18,2)

set @int=
(

	Select count(*) from vwcta_Cte cta
	Left Join vwcxas cxa on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_Tx and cta.dc_hia=cxa.dc_hia
	where cta.num_proc_hia=@num_proc and desp_org_hia='N' and cxa.num_lcto is null
)
Print @int
if @int =0 or @int is null
	Begin
		set @CaixaCredito=(Select sum(Vlr_Pgto_Rcto_Hia) From vwcxas cxa
		Join vwcta_Cte cta on cta.num_proc_hia=cxa.num_proc_hia and cta.dc_hia=cxa.dc_hia and cta.cd_tp_tx=cxa.cd_tp_Tx
		Left Join base_nota_fiscal NF on NF.nota_Fiscal=num_nf_hia and ref_acesso=ref_acesso_nf_hia
		left Join registro_financeiro_item RF on RF.num_proc=cxa.num_proc_hia and RF.dc=cxa.dc_hia and rf.cd_tp_Tx=cxa.cd_tp_Tx
		where rf.num_proc is null and nf.nota_fiscal is null and cxa.dc_hia='C' and cxa.num_proc_hia=@num_proc)

		set @CaixaDebito=(Select sum(Vlr_Pgto_Rcto_Hia) From vwcxas cxa
		Join vwcta_Cte cta on cta.num_proc_hia=cxa.num_proc_hia and cta.dc_hia=cxa.dc_hia and cta.cd_tp_tx=cxa.cd_tp_Tx
		Left Join base_nota_fiscal NF on NF.nota_Fiscal=num_nf_hia and ref_acesso=ref_acesso_nf_hia
		left Join registro_financeiro_item RF on RF.num_proc=cxa.num_proc_hia and RF.dc=cxa.dc_hia and rf.cd_tp_Tx=cxa.cd_tp_Tx
		where rf.num_proc is null and nf.nota_fiscal is null and cxa.dc_hia='D' and cxa.num_proc_hia=@num_proc)
	
		delete dbo.Saldo_Contabil_Processo where num_proc=@Num_proc

		Insert Saldo_Contabil_Processo(num_proc,entradas_caixa,saida_caixa) values(@num_proc,@CaixaCredito,@CaixaDebito)
	End


GO
