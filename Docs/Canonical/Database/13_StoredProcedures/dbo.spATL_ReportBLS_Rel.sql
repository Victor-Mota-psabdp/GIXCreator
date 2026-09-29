SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spATL_ReportBLS_Rel '2013-12-01','2013-12-31'
CREATE procedure spATL_ReportBLS_Rel

@Inicial datetime,
@Final datetime

as

--Declare @Tab Table (
--					[JOB]			varchar(16),
--					[Dt. Criação]	varchar(10),
--					[Grupo]			varchar(50),
--					[Credor/Devedor]varchar(50),
--					[BDP Charge]	varchar(50),
--					[Cd_Tp_Tx]		varchar(3),
--					[Moeda]			varchar(50),
--					[D/C]			varchar(1),
--					[Valor]			decimal(18,2),
--					[Valor em Reais]decimal(18,2),
--					[Entrada]		decimal(18,2),
--					[Entrada em aberto]decimal(18,2),
--					[Saida]			decimal(18,2),
--					[Saida em Aberto]decimal(18,2),
--					[Serviços]		decimal(18,2),
--					[Serviços Em Aberto]decimal(18,2),
--					[Custo]			decimal(18,2),
--					[Custo Em Aberto]	decimal(18,2)

--)
insert Report_ABS
select 
	CC.Num_proc_hia		[JOB],
	VC.Dt_Criacao		[Dt. Criação],
	GN.Apelido			[Grupo], 
	PS.Apelido			[Credor/Devedor],
	TT.Nome_Tp_TX		[BDP Charge],
	CC.Cd_Tp_Tx, 
	TM.Nome_Tp_Moeda	[Moeda], 
	CC.DC_Hia			[D/C],
	CC.Vlr_Org_Hia		[Valor],
	Case
		when CC.Par_NF_Hia is Null then cast(dbo.VerParidade(Dt_Ins_Hia,CC.Cd_Tp_Moeda,'OFC')*CC.Vlr_Org_Hia as decimal(18,2))
		else Cast(CC.Vlr_Org_Hia*CC.Par_NF_Hia as decimal(18,2))
	End [Valor em Reais],
	NULL[Entrada],
	NULL[Entrada em aberto],
	NULL[Saida],
	NULL[Saida em Aberto],
	NULL[Serviços],
	NULL[Serviços Em Aberto],
	NULL[Custo],
	NULL[Custo Aberto]	
from 
	vwcta_cte CC with(nolock)
join vwcliente VC with(nolock) on CC.Num_proc_hia = VC.Num_Proc
left join Pessoa_LLP PA with(nolock) on VC.Cd_Cliente=PA.Cd_Pes
join Pessoa GN with(nolock) on PA.Cd_Pes_grupo = GN.Cd_pes
join Pessoa PS with(nolock) on CC.cd_cred_dev_Hia = Ps.cd_Pes
join Tipo_Taxa TT with(nolock) on CC.Cd_Tp_Tx = TT.Cd_Tp_Tx
join Tipo_Moeda TM with(nolock) on CC.cd_Tp_Moeda = TM.Cd_Tp_Moeda
where convert(datetime,Dt_Ins_Hia,103) between  @Inicial and @Final --and cc.Num_Proc_HIA = 'IMATL201311103BR'


--*****Busca
Declare @Num_Proc Varchar(16)
Declare @Cd_Tp_Tx varchar(3)
Declare @DC		varchar(1)
--*******

--***Resultados
Declare @Entrada		decimal(18,2)
Declare @EntradaA	decimal(18,2)
Declare	@Saida		decimal(18,2)
Declare @SaidaA		decimal(18,2)
Declare @Servicos	decimal(18,2)
Declare @ServicosA	decimal(18,2)	
Declare @Custo 		decimal(18,2)
Declare @CustoA		decimal(18,2)

Declare C_Taxas cursor for

select [JOB],[Cd_Tp_Tx],[DC] from Report_ABS

Open C_Taxas

Fetch Next From C_Taxas Into @Num_Proc,@Cd_Tp_Tx,@DC
	While @@FETCH_STATUS = 0
		Begin
		if @DC = 'C'
			Begin

				set @Entrada = (Select isnull(cast(dbo.VerParidade(Cta.Dt_Ins_Hia,Cta.Cd_Tp_Moeda,'OFC')*Cta.Vlr_Org_Hia as decimal(18,2)),0) From vwcta_Cte cta with(nolock) 
						Left Join base_nota_fiscal NF with(nolock) on NF.nota_Fiscal=num_nf_hia and ref_acesso=ref_acesso_nf_hia
						left Join registro_financeiro_item RF with(nolock) on RF.num_proc=cta.num_proc_hia and RF.dc=cta.dc_hia and rf.cd_tp_Tx=cta.cd_tp_Tx
						where 
							rf.num_proc is null and
							nf.nota_fiscal is null and 
							cta.DC_hia = @DC and cta.num_proc_hia=@Num_proc and cta.Cd_Tp_tx = @Cd_Tp_Tx)
						
				set @EntradaA = (Select isnull(cast(dbo.VerParidade(Cta.Dt_Ins_Hia,Cta.Cd_Tp_Moeda,'OFC')*Cta.Vlr_Org_Hia as decimal(18,2)),0) From vwcta_Cte cta with(nolock) 
						left Join vwCXAS cxa with(nolock) on cta.num_proc_hia=cxa.num_proc_hia and cta.dc_hia=cxa.dc_hia and cta.cd_tp_tx=cxa.cd_tp_Tx and convert(datetime,cxa.Dt_Pgto_Rcto_HIA,105)<= @Final
						Left Join base_nota_fiscal NF with(nolock) on NF.nota_Fiscal=num_nf_hia and ref_acesso=ref_acesso_nf_hia
						left Join registro_financeiro_item RF with(nolock) on RF.num_proc=cta.num_proc_hia and RF.dc=cta.dc_hia and rf.cd_tp_Tx=cta.cd_tp_Tx
						where 
							rf.num_proc is null and
							nf.nota_fiscal is null and 
							cxa.Num_Lcto is null  and
							cta.DC_hia = @DC and cta.num_proc_hia=@Num_proc and cta.Cd_Tp_tx = @Cd_Tp_Tx)
				--print 'Caixa:'
				--print @EntradaA
				--print @DC
				--print @Num_proc
				--print @Cd_Tp_Tx

			End
			
			if @DC = 'D'
				Begin
					set @Saida = (Select isnull(cast(dbo.VerParidade(Cta.Dt_Ins_Hia,Cta.Cd_Tp_Moeda,'OFC')*Cta.Vlr_Org_Hia as decimal(18,2)),0) From vwcta_Cte cta with(nolock) 
								Left Join base_nota_fiscal NF with(nolock) on NF.nota_Fiscal=num_nf_hia and ref_acesso=ref_acesso_nf_hia
								left Join registro_financeiro_item RF with(nolock) on RF.num_proc=cta.num_proc_hia and RF.dc=cta.dc_hia and rf.cd_tp_Tx=cta.cd_tp_Tx
								where 
									rf.num_proc is null and 
									nf.nota_fiscal is null and 
									cta.DC_hia = @DC and cta.num_proc_hia=@Num_proc and cta.Cd_Tp_tx = @Cd_Tp_Tx)
								
					set @SaidaA = (Select isnull(cast(dbo.VerParidade(Cta.Dt_Ins_Hia,Cta.Cd_Tp_Moeda,'OFC')*Cta.Vlr_Org_Hia as decimal(18,2)),0) From vwcta_Cte cta with(nolock) 
								left Join vwCXAS cxa with(nolock) on cta.num_proc_hia=cxa.num_proc_hia and cta.dc_hia=cxa.dc_hia and cta.cd_tp_tx=cxa.Cd_Tp_Tx and convert(datetime,cxa.Dt_Pgto_Rcto_HIA,103) <= @Final
								Left Join base_nota_fiscal NF with(nolock) on NF.nota_Fiscal=num_nf_hia and ref_acesso=ref_acesso_nf_hia
								left Join registro_financeiro_item RF with(nolock) on RF.num_proc=cta.num_proc_hia and RF.dc=cta.dc_hia and rf.cd_tp_Tx=cta.cd_tp_Tx
								where 
									rf.num_proc is null and
									nf.nota_fiscal is null and 
									cxa.Num_Lcto is null and 
									cta.DC_hia = @DC and cta.num_proc_hia=@Num_proc and cta.Cd_Tp_tx = @Cd_Tp_Tx)

				End
				
				set @Servicos = (Select isnull(cast(dbo.VerParidade(Cta.Dt_Ins_Hia,Cta.Cd_Tp_Moeda,'OFC')*Cta.Vlr_Org_Hia as decimal(18,2)),0) From vwcta_Cte cta with(nolock) 
							Left Join base_nota_fiscal NF with(nolock) on NF.nota_Fiscal=num_nf_hia and ref_acesso=ref_acesso_nf_hia
							left Join registro_financeiro_item RF with(nolock) on RF.num_proc=cta.num_proc_hia and RF.dc=cta.dc_hia and rf.cd_tp_Tx=cta.cd_tp_Tx
							where 
								rf.num_proc is null and
								nf.nota_fiscal is not null and 
								cta.DC_hia = @DC and cta.num_proc_hia=@Num_proc and cta.Cd_Tp_tx = @Cd_Tp_Tx)
								
				set @ServicosA = (Select isnull(cast(dbo.VerParidade(Cta.Dt_Ins_Hia,Cta.Cd_Tp_Moeda,'OFC')*Cta.Vlr_Org_Hia as decimal(18,2)),0) From vwcta_Cte cta with(nolock) 
								left Join vwCXAS cxa with(nolock) on cta.num_proc_hia=cxa.num_proc_hia and cta.dc_hia=cxa.dc_hia and cta.cd_tp_tx=cxa.cd_tp_Tx and  convert(datetime,cxa.Dt_Pgto_Rcto_HIA,103) <= @Final
								Left Join base_nota_fiscal NF with(nolock) on NF.nota_Fiscal=num_nf_hia and ref_acesso=ref_acesso_nf_hia
								left Join registro_financeiro_item RF with(nolock) on RF.num_proc=cta.num_proc_hia and RF.dc=cta.dc_hia and rf.cd_tp_Tx=cta.cd_tp_Tx
								where 
									rf.num_proc is null and
									nf.nota_fiscal is not null and 
									--cxa.Num_Lcto is null and 
									cxa.Num_Lcto is null and
									cta.DC_hia = @DC and cta.num_proc_hia=@Num_proc and cta.Cd_Tp_tx = @Cd_Tp_Tx)
				set @Custo = (Select isnull(cast(dbo.VerParidade(Cta.Dt_Ins_Hia,Cta.Cd_Tp_Moeda,'OFC')*Cta.Vlr_Org_Hia as decimal(18,2)),0) From vwcta_Cte cta with(nolock) 
							--Left Join base_nota_fiscal NF with(nolock) on NF.nota_Fiscal=num_nf_hia and ref_acesso=ref_acesso_nf_hia
							left Join registro_financeiro_item RF with(nolock) on RF.num_proc=cta.num_proc_hia and RF.dc=cta.dc_hia and rf.cd_tp_Tx=cta.cd_tp_Tx
							where 
							/*
								(rf.num_proc is not null or
								nf.nota_fiscal is not null) and 
								*/
								rf.num_proc is not null and
								cta.DC_hia = @DC and cta.num_proc_hia=@Num_proc and cta.Cd_Tp_tx = @Cd_Tp_Tx)
								
				set @CustoA = (Select isnull(cast(dbo.VerParidade(Cta.Dt_Ins_Hia,Cta.Cd_Tp_Moeda,'OFC')*Cta.Vlr_Org_Hia as decimal(18,2)),0) From vwcta_Cte cta with(nolock) 
								left Join vwCXAS cxa with(nolock) on cta.num_proc_hia=cxa.num_proc_hia and cta.dc_hia=cxa.dc_hia and cta.cd_tp_tx=cxa.cd_tp_Tx and  convert(datetime,cxa.Dt_Pgto_Rcto_HIA,103) <= @Final
								--Left Join base_nota_fiscal NF with(nolock) on NF.nota_Fiscal=num_nf_hia and ref_acesso=ref_acesso_nf_hia
								left Join registro_financeiro_item RF with(nolock) on RF.num_proc=cta.num_proc_hia and RF.dc=cta.dc_hia and rf.cd_tp_Tx=cta.cd_tp_Tx
								where 
								/*
									(rf.num_proc is not null or 
									nf.nota_fiscal is not null) and 
									*/
									rf.num_proc is not null and
									--cxa.Num_Lcto is null and 
									cxa.Num_Lcto is null and
									cta.DC_hia = @DC and cta.num_proc_hia=@Num_proc and cta.Cd_Tp_tx = @Cd_Tp_Tx)
								
		update Report_ABS set 
					Entrada = @Entrada, 
					[Entradaaberto] = @EntradaA, 
					[Saida] = @Saida, 
					[SaidaAberto]=@SaidaA,
					[Servico]=@Servicos,
					[ServicoAberto] = @ServicosA,
					[Custo] = @Custo,
					[CustoAberto] = @CustoA
		where [JOB] = @Num_Proc and [Cd_Tp_tx]= @Cd_Tp_Tx and [DC]=@DC
		set @Entrada = NULL
		set @EntradaA = NULL
		set @Saida = NULL
		set @SaidaA = NULL
		set @Servicos = NULL
		set @ServicosA = NULL
		set @Custo = NULL
		set @CustoA = NULL
			Fetch Next From C_Taxas Into @Num_Proc,@Cd_Tp_Tx,@DC
		End
	close C_Taxas
	deallocate C_Taxas
	



GO
