SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--cadu 04/08/2015 - retirada a data de 01/06/2015

CREATE procedure [dbo].[spATL_adtoDOw_TST]

as

Declare @Num_Proc	Varchar(16)
Declare @Data		Datetime
Declare @Nome_Tp_Tx	Varchar(50)
Declare @Valor		Decimal(10,2)
Declare @Cd_tp_Tx	Varchar(3)
Declare @Encerrado bit
Declare @Fatura Varchar(17)
Declare @OBS	Varchar(500)
Declare @StatusJob	int
Declare @DataDevol	datetime
Declare @LA		Varchar(20)
Declare @Valor_Em_Aberto Decimal(10,2)

Declare @SaldoProcesso	decimal(10,2)

				Declare @FaturaTB Table
					(
						FaturaCod	Varchar(17),
						Cd_Tp_Tx	Varchar(3),
						DC			Varchar(1),
						Data		Datetime,
						LA			Varchar(15)
					)
Declare cTemp cursor for

	Select 
		Upper(Num_PRoc_HIA) Job,convert(datetime,dt_pgto_Rcto_hia,105) Data,Nome_Tp_tx,Vlr_Pgto_Rcto_HIA Data, CXA.CD_Tp_TX
	From 
		vwcxas CXA
		Join Tipo_Taxa TT with(nolock) on tt.cd_tp_tx=cxa.cd_tp_tx
		left Join Pgto_Rcto PG with(nolock) on PG.num_lcto=cxa.num_lcto
		Left Join ADM_Adiantamentos AA with(nolock) on AA.num_proc=CXA.num_proc_hia and AA.cd_tp_tx=CXA.cd_tp_tx and Encerrado=1
	where 
		--substring(num_proc_hia,3,3) in ('STB','CSR','ROB')
		--and 
		cxa.dc_hia='C' and nome_Tp_Tx like 'Adiantamento%'
		and AA.num_proc is null
		--and Num_Proc_HIA='EMCSR201502034BR'
		--and convert(Datetime,cxa.Dt_Pgto_Rcto_HIA  ,105) >='01-01-2015'
	order by convert(datetime,dt_pgto_Rcto,105) desc
	Open cTemp
	Fetch Next From cTemp into @Num_proc,@data,@nome_tp_tx,@Valor,@Cd_Tp_tx
		While @@FETCH_STATUS = 0
			begin
				print @Num_Proc
				print '------------------------------------------'
				Set @DataDevol=null
				set @Obs=''
				Set @FAtura = Isnull((select max(fatura_cc) from fatura_chb_item with(nolock) where len(fatura_cc) = 17 and left(fatura_cc,16)=@Num_proc and Cd_Tp_Tx=@cd_tp_Tx),'')
				set @Valor_Em_Aberto = (
				
								select sum(vlr_rs) from vwFaturasValidas f with(nolock)
								Left Join vwCXAS C on F.Cd_Tp_Tx=C.Cd_Tp_Tx and F.Num_Proc=C.Num_Proc_HIA and F.DC=C.DC_HIA
								
								Left Join  dbo.vwFaturasValidasArg FA with(nolock) on FA.Num_Proc = F.Num_Proc and F.Cd_Tp_Tx = FA.Cd_Tp_Tx and F.DC = FA.DC 
								Where C.Num_Proc_HIA is null and FatCod=@FAtura
								and FA.Cd_tp_tx not in ('CF1','C01','IRR','P01')
								and FA.Num_Proc is null 
								)  

				Delete @FaturaTB
				Set @SaldoProcesso=Null
				
				if	@Fatura <> '' 
					Begin
						Insert @FaturaTB (FaturaCod,Cd_tp_Tx,dc)
							Select FatCod,I.Cd_tp_tx,dc from item_Fat I
							Join vwcta_cte cta with(nolock) on cta.num_proc_hia=left(I.FatCod,16) and I.cd_tp_tx=CTA.cd_Tp_tx and cta.dc_hia=I.dc and CTa.num_nf_hia is null and desp_org_hia='N'
							where fatcod=@Fatura and vlr_org <>0 and vlr_org_hia <> 0
							and I.Cd_tp_tx not in ('CF1','C01','IRR','P01')

						Update @FaturaTB 
								Set 
									Data=convert(datetime,Dt_Pgto_Rcto_HIA,105),
									LA = 'AX'
								From
									@FaturaTB I
									Join vwcta_cte cta with(nolock) on cta.num_proc_hia=left(I.Faturacod,16) and I.cd_tp_tx=CTA.cd_Tp_tx and cta.dc_hia=I.dc and CTa.num_nf_hia is null
									Join vwcxas cxa with(nolock) on cxa.num_proc_hia=cta.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia and desp_org_hia='N'
									--Left Join Pgto_Rcto PG on PG.num_lcto=cxa.num_Lcto

						if Not exists (
									select * from @FaturaTB where LA is null
									)
							Begin
									print 'Entrou na fatura'
					
									Set @DataDevol=(select top 1 Data from @FaturaTB where data is not null)
									Set @LA=(select top 1 LA from @FaturaTB where data is not null) 								
									Set @Encerrado=1						
									Set @Obs='Processo encerrado' + ' - ' + Isnull(@LA,'')
									
							End		
							
						Else
							if  exists(select * from @FaturaTB F Join Tipo_taxa TT with(nolock) on tt.cd_tp_Tx=F.cd_tp_Tx where LA is null and dc='C' and nome_tp_tx like 'Prestação%')
								BEgin
								
									Set @Encerrado=1						
									Set @Obs='Processo encerrado - Saldo a favor da BDP'
								
								End
							else
								Begin
									Set @Encerrado=0						
									Set @Obs='Processos em aberto - programação de devolução'							
						
								end
																		
					End
				Else
					
					Begin
						print 'Entrou no Else'
						Set @SaldoProcesso= (select dbo.fBuscaSaldoCaixaSemServicos_Sel(@Num_Proc))
						if left(@Num_Proc,2)='IM'
							Begin
								Set @StatusJob=(select id_status from llp_imp_mar with(nolock) where num_proc_lim=@Num_proc)
							End				
						if left(@Num_Proc,2)='IA'
							Begin
								Set @StatusJob=(select id_status from llp_imp_aer with(nolock) where num_proc_lia=@Num_proc)
							End				
						if left(@Num_Proc,2)='IO'
							Begin
								Set @StatusJob=(select id_status from llp_imp_out with(nolock) where num_proc_lio=@Num_proc)
							End				
						if left(@Num_Proc,2)='EM'
							Begin
								Set @StatusJob=(select id_status from llp_exp_mar with(nolock) where num_proc_lem=@Num_proc)
							End				
						if left(@Num_Proc,2)='EA'
							Begin
								Set @StatusJob=(select id_status from llp_exp_aer with(nolock) where num_proc_lea=@Num_proc)
							End				
						if left(@Num_Proc,2)='EO'
							Begin
								Set @StatusJob=(select id_status from llp_exp_OUT with(nolock) where num_proc_leO=@Num_proc)
							End				
						IF @StatusJob=9 and @SaldoProcesso=0
							Begin
								Set @Encerrado=1						
								Set @Obs='Processo cancelado e devolvido Saldo'								
							End
						Else
							Begin
								Set @Encerrado=0
								set @Obs=''
							End
					End
				exec spATL_ADMAdiantamentos_InsUpd @Num_Proc,@Nome_TP_Tx,@Cd_tp_Tx,	@Valor,	@Data,	@Fatura	,@DataDevol,	@Encerrado,@Obs,@SaldoProcesso,@Valor_Em_Aberto
				print '----------------------------------------------------------------------'
				Fetch Next From cTemp into @Num_proc,@data,@nome_tp_tx,@Valor,@Cd_Tp_tx
			
			End
			
	
	

GO
