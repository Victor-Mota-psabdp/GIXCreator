SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE Procedure [dbo].[spATLSimulaRent_Sel]
(
	@Num_Proc	varchar(16)
)

as

Declare @GrossRevenue	Decimal(10,2)
Declare @GrossCost		Decimal(10,2)
Declare @NFEmitidas		Decimal (10,2)
Declare @CostsMaster	Decimal(10,2)
Declare @CHBRecebimento	Decimal (10,2)
Declare @CHBPagamentos	Decimal(10,2)
Declare @Num_Master		Varchar(14)
DEclare @QtdHouse		int
--Set @Num_Proc='IMROB201110052BR'
--GrossRevenue

Set @GrossRevenue=
	isnull((
		Select sum(Vlr_Org_Hia*Isnull(Par_Moeda,1)) from vwcta_Cte CTA
		Left Join Paridade PAR on PAR.cd_tp_moeda=cta.cd_tp_moeda and cd_tp_par='OFC' and dt_par='31/01/2012'
		Where
			Num_Proc_Hia=@Num_Proc and desp_org_hia='N' and left(cd_tp_Tx,1)<>'X'
			and cta.cd_tp_moeda<>'REL' and dc_hia='C'
			and cd_tp_Tx not in ('DNF','DF2','154')

	),0)

Set @GrossRevenue=@GrossRevenue+
	isnull((
		Select sum(Vlr_Org_Hia) from vwcta_Cte CTA
		Where
			Num_Proc_Hia=@Num_Proc and desp_org_hia='N' and left(cd_tp_Tx,1)<>'X'
			and cta.cd_tp_moeda='REL' and dc_hia='C'
			and cd_tp_Tx not in ('DNF','DF2','154')
	),0)


Set @GrossCost=
	isnull((
		Select sum(Vlr_Org_Hia*Isnull(Par_Moeda,1)) from vwcta_Cte CTA
		Left Join Paridade PAR on PAR.cd_tp_moeda=cta.cd_tp_moeda and cd_tp_par='OFC' and dt_par='31/01/2012'
		Where
			Num_Proc_Hia=@Num_Proc and desp_org_hia='N' and left(cd_tp_Tx,1)<>'X'
			and cta.cd_tp_moeda<>'REL' and dc_hia='D'
			 and cd_tp_Tx not in ('DNF','DF2','154')
	),0)


Set @GrossCost=@GrossCost+
	isnull((
		Select sum(Vlr_Org_Hia) from vwcta_Cte CTA
		Where
			Num_Proc_Hia=@Num_Proc and desp_org_hia='N' and left(cd_tp_Tx,1)<>'X'
			and cta.cd_tp_moeda='REL' and dc_hia='D'
			and cd_tp_Tx not in ('DNF','DF2','154')
	),0)


set @NFEmitidas=
	(
		Select sum(dbo.valor(vlr_pgto_nf_hia,dc_hia)) from vwcta_Cte CTA
		Join base_nota_Fiscal NF on NF.ref_Acesso=ref_acesso_nf_hia and num_nf_hia=nota_fiscal
		Where
			Num_Proc_Hia=@Num_Proc and desp_org_hia='N' 
	)

Set @CHBRecebimento=
	isnull((
		Select sum(Vlr_Org_Hia*Isnull(Par_Moeda,1)) from vwcta_Cte CTA
		Left Join Paridade PAR on PAR.cd_tp_moeda=cta.cd_tp_moeda and cd_tp_par='OFC' and dt_par='31/01/2012'
		Where
			Num_Proc_Hia=@Num_Proc and desp_org_hia='N' and (left(cd_tp_Tx,1)='X'  or cd_tp_Tx in ('DNF','DF2','154'))
			and cta.cd_tp_moeda<>'REL' and dc_hia='C'
	),0)


Set @CHBRecebimento=@CHBRecebimento+
	isnull((
		Select sum(Vlr_Org_Hia) from vwcta_Cte CTA
		Where
			Num_Proc_Hia=@Num_Proc and desp_org_hia='N'  and (left(cd_tp_Tx,1)='X'  or cd_tp_Tx in ('DNF','DF2','154'))
			and cta.cd_tp_moeda='REL' and dc_hia='C'
	),0)

Set @CHBPagamentos=
	isnull((
		Select sum(Vlr_Org_Hia*Isnull(Par_Moeda,1)) from vwcta_Cte CTA
		Left Join Paridade PAR on PAR.cd_tp_moeda=cta.cd_tp_moeda and cd_tp_par='OFC' and dt_par='31/01/2012'
		Where
			Num_Proc_Hia=@Num_Proc and desp_org_hia='N' and ((left(cd_tp_Tx,1)='X'  or cd_tp_Tx in ('DNF','DF2','154')))
			and cta.cd_tp_moeda<>'REL' and dc_hia='D'
	),0)


Set @CHBPagamentos=@CHBPagamentos+
	isnull((
		Select sum(Vlr_Org_Hia) from vwcta_Cte CTA
		Where
			Num_Proc_Hia=@Num_Proc and desp_org_hia='N' and ((left(cd_tp_Tx,1)='X'  or cd_tp_Tx in ('DNF','DF2','154')))
			and cta.cd_tp_moeda='REL' and dc_hia='D'
	),0)

SEt @Num_Master=(select master from vwcliente where num_proc=@num_proc and master <> 'JOB')
Set @QtdHouse=(select count(num_proc) from vwcliente where master=@Num_Master)
Set @CostsMAster=0
if @Num_Master is not null
	Begin
		Set @QtdHouse=(select count(num_proc) from vwcliente where master=@Num_Master)

		set @CostsMaster=
			
		isnull((
				Select sum(dbo.valor(Vlr_Org_Hia,dc_hia)*Isnull(Par_Moeda,1)) from vwcta_Cte CTA
				Left Join Paridade PAR on PAR.cd_tp_moeda=cta.cd_tp_moeda and cd_tp_par='OFC' and dt_par='31/01/2012'
				Where
					Num_Proc_Hia=@Num_Master and desp_org_hia='N' and left(cd_tp_Tx,1)<>'X'
					and cta.cd_tp_moeda<>'REL' 
			),0)
		
		Set @CostsMaster=@CostsMaster+
	
			isnull((
				Select sum(dbo.valor(Vlr_Org_Hia,dc_hia)) from vwcta_Cte CTA
				Where
					Num_Proc_Hia=@Num_Master and desp_org_hia='N' and left(cd_tp_Tx,1)<>'X'
					and cta.cd_tp_moeda='REL' 
			),0)
		
		if @QtdHouse <> 0 
			Begin
				Set @CostsMaster=@CostsMaster/@QtdHouse
			end
	end


delete dbo.Rentabilidade_Job_Temp where num_proc=@Num_Proc


Insert Rentabilidade_Job_Temp
Select @num_Proc Job,@GrossRevenue GrossRevenue,@GrossCost*-1 GrossCost, @NFEmitidas NFEmitidas,@CHBRecebimento CHBRecebimento,@CHBPagamentos CHBPagamentos,@CHBRecebimento-@CHBPagamentos, @CostsMaster CustoMaster,(@GrossRevenue-@GrossCost+@CostsMaster)NetRevenueOperacional




GO
