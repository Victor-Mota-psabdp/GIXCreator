SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--alterado no remessa internacional é preciso alterar uma conta onde se lê 11155 o correto é 22223 para todos no caso de Remessa:(siberio)
--[spATL_ContBLS_OutPut] '','2013-03-01','2013-03-31'
CREATE Procedure [dbo].[spATL_ContBLSTx_OutPut]
(
@JOB	varchar(16),
@DataInicial	datetime,
@DataFinal Datetime

)

as
/*

	atualizacao para DOC REGISTer 

*/
Declare @ano int
Declare @mes int 
SEt @mes=month(@datafinal)
SEt @ano=year(@Datafinal)

exec spGeraValoresReaisCont_Upd @mes,@ano

--FIM 


--,'EMATL201208007BR'
If @JOB <> '' and @JOB is not NULL
	Begin
		delete contabilidade_bls where num_proc  = @JOB and encerrado=0
	End
else
	Begin
		--print 'Apagando DB por data'
		delete contabilidade_bls where data between @datainicial and @datafinal and encerrado=0
	End

If @JOB <> '' and @JOB is not NULL
	Begin
	insert contabilidade_bls
		Select Convert(datetime,dt_ins_hia,105),cc.num_proc_hia,cc.cd_tp_tx,cc.dc_hia,vlr_org_hia,vlr_org_hia* [dbo].[VerParidade](dt_ins_hia,cc.cd_tp_moeda,'OFC'),'FAT',0,
			
				22399,22223,cd_cred_Dev_hia,'Fatura: ' + CC.num_proc_hia + ' - Fornecedor: ' + apelido From vwcta_Cte CC
		Join vwcliente C on C.num_proc=CC.num_proc_Hia
		Join Item_Fat fat on fat.num_proc=cc.num_proc_hia and fat.cd_tp_Tx=cc.cd_tp_tx and fat.dc=CC.dc_hia
		Join Pessoa PP on pp.cd_pes=cd_cred_dev_hia
		where
			--data <=@Datafinal
			left(cc.cd_tp_tx,1)<>'X' 
			and dc_hia='D'
			and desp_org_hia='N'
			--and fat.num_proc is null
			--and convert(Datetime,dt_ins_hia,105) between @DataInicial and @DataFinal
			and vlr_org_hia <> 0
			and cc.num_proc_hia = @JOB
			

		Union all --Cta_cte_Master

		Select Convert(datetime,dt_ins_hia,105),cc.num_proc_hia,cc.cd_tp_tx,cc.dc_hia,vlr_org_hia,vlr_org_hia* [dbo].[VerParidade](dt_ins_hia,cc.cd_tp_moeda,'OFC'),'FAT',0,
				22399,
				22223,cd_cred_Dev_hia,'Fatura: ' + CC.num_proc_hia + ' - Fornecedor: ' + apelido From vwcta_Cte CC
		Join LLP_Master C on num_proc_master=CC.num_proc_hia
		Join Item_Fat fat on fat.num_proc=cc.num_proc_hia and fat.cd_tp_Tx=cc.cd_tp_tx and fat.dc=CC.dc_hia
		Join Pessoa PP on pp.cd_pes=cd_cred_dev_hia
		where
			--ETD_Master <=@DataFinal and
			left(cc.cd_tp_tx,1)<>'X' and
			dc_hia='D' and
			desp_org_hia='N' and
			--fat.num_proc is null and
			--convert(Datetime,dt_ins_hia,105) between @DataInicial and @DataFinal
			vlr_org_hia <> 0 and
			cc.num_proc_hia = @JOB

		Union All
		Select Convert(datetime,dt_ins_hia,105),cc.num_proc_hia,cc.cd_tp_tx,cc.dc_hia,vlr_org_hia,vlr_org_hia* [dbo].[VerParidade](dt_ins_hia,cc.cd_tp_moeda,'OFC'),'PROV',0,
			
				22399,22223,cd_cred_Dev_hia,'Provisão de Pagamento: ' + CC.num_proc_hia + ' - Fornecedor: ' + apelido From vwcta_Cte CC
		Join vwcliente C on C.num_proc=CC.num_proc_Hia
		Left Join Item_Fat fat on fat.num_proc=cc.num_proc_hia and fat.cd_tp_Tx=cc.cd_tp_tx and fat.dc=CC.dc_hia
		Join Pessoa PP on pp.cd_pes=cd_cred_dev_hia
		where
			--data <=@Datafinal
			left(cc.cd_tp_tx,1)<>'X' 
			and dc_hia='D'
			and desp_org_hia='N'
			and fat.num_proc is null
			--and convert(Datetime,dt_ins_hia,105) between @DataInicial and @DataFinal
			and vlr_org_hia <> 0
			and cc.num_proc_hia = @JOB
			

		Union all --Cta_cte_Master

		Select Convert(datetime,dt_ins_hia,105),cc.num_proc_hia,cc.cd_tp_tx,cc.dc_hia,vlr_org_hia,vlr_org_hia* [dbo].[VerParidade](dt_ins_hia,cc.cd_tp_moeda,'OFC'),'PROV',0,
				22399,
				22223,cd_cred_Dev_hia,'Provisão de Pagamento: ' + CC.num_proc_hia + ' - Fornecedor: ' + apelido From vwcta_Cte CC
		Join LLP_Master C on num_proc_master=CC.num_proc_hia
		Left Join Item_Fat fat on fat.num_proc=cc.num_proc_hia and fat.cd_tp_Tx=cc.cd_tp_tx and fat.dc=CC.dc_hia
		Join Pessoa PP on pp.cd_pes=cd_cred_dev_hia
		where
			--ETD_Master <=@DataFinal and
			left(cc.cd_tp_tx,1)<>'X' and
			dc_hia='D' and
			desp_org_hia='N' and
			fat.num_proc is null and
			--convert(Datetime,dt_ins_hia,105) between @DataInicial and @DataFinal
			vlr_org_hia <> 0 and
			cc.num_proc_hia = @JOB

		Union All

		Select 
			emissao,cc.num_proc_hia,cc.cd_tp_tx,cc.dc_hia,vlr_pgto_nf_hia,vlr_pgto_nf_hia,'NF',0,
			(Case DC_HIA
				When 'C' then 22400
				--When 'C' then 0
				else (Case 
								when TD.cd_tp_Tx is not null then '33338' ---Adicionado por Anderson - 04/07/2013
								When TD.cd_tp_Tx is null  and  left(cc.num_proc_hia,2)='EA' then '33333'
								When TD.cd_tp_Tx is null  and  left(cc.num_proc_hia,2)='IA' then '33334'
								When TD.cd_tp_Tx is null  and  left(cc.num_proc_hia,2)='EM' then '33335'
								When TD.cd_tp_Tx is null  and  left(cc.num_proc_hia,2)='IM' then '33336'
								When TD.cd_tp_Tx is null  and  left(cc.num_proc_hia,2)='IO' then '33337'
								When TD.cd_tp_Tx is null  and left(cc.num_proc_hia,2)='EO' then '33337'
								End)
			End),
			
			(Case DC_HIA
				--When 'D' then 0
				When 'C' then (Case
								when TD.cd_tp_Tx is not null then '33338' ---Adicionado por Anderson - 04/07/2013
								When  TD.cd_tp_Tx is null and left(cc.num_proc_hia,2)='EA' then '33333'
								When  TD.cd_tp_Tx is null  and  left(cc.num_proc_hia,2)='IA' then '33334'
								When  TD.cd_tp_Tx is null  and  left(cc.num_proc_hia,2)='EM' then '33335'
								When  TD.cd_tp_Tx is null  and  left(cc.num_proc_hia,2)='IM' then '33336'
								When  TD.cd_tp_Tx is null  and  left(cc.num_proc_hia,2)='IO' then '33337'
								When  TD.cd_tp_Tx is null  and  left(cc.num_proc_hia,2)= 'EO' then '33337'
								End)
				When 'D' then 22400
			End),

				cd_cred_Dev_hia,'JOB: ' + CC.num_proc_Hia + ' - Nota Fiscal Emitida: ' + cast(Num_Nf_HIA as varchar(30))+ ' - Cliente: ' + apelido 
		From 
			vwcta_Cte CC
			Join vwcliente C on C.num_proc=CC.num_proc_Hia
		Join Pessoa PP on pp.cd_pes=cd_cred_dev_hia
		Join BAse_Nota_Fiscal NF on NF.nota_Fiscal=num_nf_hia and ref_acesso=ref_Acesso_nf_hia
		Left Join TAxas_Despacho TD on CC.cd_tp_tx collate SQL_Latin1_General_CP1_CI_AS =TD.cd_tp_Tx collate SQL_Latin1_General_CP1_CI_AS
		where
			left(cc.cd_tp_tx,1)<>'X' 
			and desp_org_hia='N'
			--and Emissao  between @DataInicial and @DataFinal
			and cc.num_proc_hia = @JOB


		union all


		Select 
			convert(Datetime,dt_pgto_rcto,105),cc.num_proc_hia,cc.cd_tp_tx,cc.dc_hia,vlr_pgto_rcto_hia,vlr_pgto_rcto_hia,'LA',0,
			(Case cc.DC_HIA
				When 'C' then cd_Cta_ctb_red
				else 22223
			End),
			
			(Case cc.DC_HIA
				When 'D' then cd_Cta_ctb_red
				When 'C' then 11155
			End),

				cd_cred_Dev_hia,  'LA: ' + CXA.Num_Lcto + ' - ' + CC.num_proc_hia + ' - Cliente/Fornecedor: ' + apelido + ' - ' + TT.Nome_Tp_Tx
		From 
			vwcta_Cte CC
		Join vwcliente	C on C.num_proc=CC.num_proc_Hia
		Join Pessoa		PP on pp.cd_pes=cd_cred_dev_hia
		Join vwcxas		CXA	on cxa.num_proc_hia=cc.num_proc_hia and cxa.dc_hia=cc.dc_hia and cc.cd_tp_Tx=cxa.cd_tp_tx and cxa.Num_lcto <> 'REMESSA'
		Join Pgto_rcto	PG on PG.num_lcto=CXA.num_lcto 
		Join cta_Cte	CCC on CCC.cd_banco=PG.cd_banco and CCC.cd_agencia=PG.cd_agencia and CCC.num_cta_cte=PG.num_cta_cte
		Join cta_ctb	CB on CB.cd_Cta_ctb=CCC.cd_cta_ctb
		Join Tipo_Taxa	TT on CXA.cd_tp_tx = TT.cd_tp_tx
		where
			left(cc.cd_tp_tx,1)<>'X' 
			and desp_org_hia='N'
			and cxa.num_proc_hia = @JOB
			--and convert(Datetime,dt_pgto_rcto,105)  between @DataInicial and @DataFinal
		Union All

		Select 
			convert(Datetime,dt_pgto_rcto,105),cc.num_proc_hia,cc.cd_tp_tx,cc.dc_hia,vlr_pgto_rcto_hia,vlr_pgto_rcto_hia,'LA',0,
			(Case cc.DC_HIA
				When 'C' then cd_Cta_ctb_red
				else 22223
			End),
			
			(Case cc.DC_HIA
				When 'D' then cd_Cta_ctb_red
				When 'C' then 11155
			End),

				cd_cred_Dev_hia,  'LA: ' + CXA.Num_Lcto + ' - ' + CC.num_proc_hia + ' - Cliente/Fornecedor: ' + apelido + ' - ' + TT.Nome_Tp_Tx
		From 
			vwcta_Cte CC
			Join vwcliente C on C.[master]=CC.num_proc_Hia
		Join Pessoa PP on pp.cd_pes=cd_cred_dev_hia
		Join vwcxas CXA on cxa.num_proc_hia=cc.num_proc_hia and cxa.dc_hia=cc.dc_hia and cc.cd_tp_Tx=cxa.cd_tp_tx and cxa.Num_lcto <> 'REMESSA'
		Join Pgto_rcto PG on PG.num_lcto=CXA.num_lcto 
		Join cta_Cte CCC on CCC.cd_banco=PG.cd_banco and CCC.cd_agencia=PG.cd_agencia and CCC.num_cta_cte=PG.num_cta_cte
		Join cta_ctb CB on CB.cd_Cta_ctb=CCC.cd_cta_ctb
		Join Tipo_Taxa	TT on CXA.cd_tp_tx = TT.cd_tp_tx
		where
			left(cc.cd_tp_tx,1)<>'X' 
			and desp_org_hia='N'
			and cxa.num_proc_hia = @JOB

		Union All


		Select 
			convert(Datetime,dt_ra,105),cc.num_proc_hia,cc.cd_tp_tx,cc.dc_hia,vlr_pgto_rcto_hia,vlr_pgto_rcto_hia,'RA',0,
			(Case cc.DC_HIA
				When 'C' then cd_Cta_ctb_red
--				else 11155
				else 22223
			End),
			
			(Case cc.DC_HIA
				When 'D' then cd_Cta_ctb_red
--				When 'C' then 11155
				When 'C' then 22223
			End),

				cd_cred_Dev_hia,'Remessa Internacional:' + num_ref_ra + ' - ' + CC.num_proc_hia + ' - Cliente/Fornecedor: ' + apelido 
		From 
			vwcta_Cte CC
			Join vwcliente C on C.num_proc=CC.num_proc_Hia
		Join Pessoa PP on pp.cd_pes=cd_cred_dev_hia
		Join vwcxas CXA on cxa.num_proc_hia=cc.num_proc_hia and cxa.dc_hia=cc.dc_hia and cc.cd_tp_Tx=cxa.cd_tp_tx
		Join Remessa_aer PG on num_ref_ra=num_rcb_hia
		Join cta_Cte CCC on CCC.cd_banco=PG.cd_banco and CCC.cd_agencia=PG.cd_agencia and CCC.num_cta_cte=PG.num_cta_cte
		Join cta_ctb CB on CB.cd_Cta_ctb=CCC.cd_cta_ctb
		where
			left(cc.cd_tp_tx,1)<>'X' 
			and desp_org_hia='N'
			and cxa.num_proc_hia = @JOB
			--and convert(Datetime,dt_ra,105)  between @DataInicial and @DataFinal

		Union all



		Select 
			convert(Datetime,dt_rm,105),cc.num_proc_hia,cc.cd_tp_tx,cc.dc_hia,vlr_pgto_rcto_hia,vlr_pgto_rcto_hia,'RA',0,
			(Case cc.DC_HIA
				When 'C' then cd_Cta_ctb_red
--				else 11155
				else 22223
			End),
			
			(Case cc.DC_HIA
				When 'D' then cd_Cta_ctb_red
--				When 'C' then 11155
				When 'C' then 22223
			End),
				cd_cred_Dev_hia,
					
					'Remessa Internacional: ' + num_ref_rm +  ' - ' + CC.num_proc_hia + ' - Cliente/Fornecedor: ' + apelido 
		From 
			vwcta_Cte CC
			Join vwcliente C on C.num_proc=CC.num_proc_Hia
		Join Pessoa PP on pp.cd_pes=cd_cred_dev_hia
		Join vwcxas CXA on cxa.num_proc_hia=cc.num_proc_hia and cxa.dc_hia=cc.dc_hia and cc.cd_tp_Tx=cxa.cd_tp_tx
		Join Remessa_MAR PG on num_ref_rm=num_rcb_hia
		Join cta_Cte CCC on CCC.cd_banco=PG.cd_banco and CCC.cd_agencia=PG.cd_agencia and CCC.num_cta_cte=PG.num_cta_cte
		Join cta_ctb CB on CB.cd_Cta_ctb=CCC.cd_cta_ctb
		where
			left(cc.cd_tp_tx,1)<>'X' 
			and desp_org_hia='N'
			and cxa.num_proc_hia = @JOB
			--and convert(Datetime,dt_rm,105)  between @DataInicial and @DataFinal

		union all

		Select 
			convert(Datetime,dt_pgto_rcto,105),cc.num_proc_hia,cc.cd_tp_tx,cc.dc_hia,vlr_pgto_rcto_hia,vlr_pgto_rcto_hia,'LA-CHB',0,
			(Case cc.DC_HIA
				When 'C' then cd_Cta_ctb_red
				else 11155
			End),
			
			(Case cc.DC_HIA
				When 'D' then cd_Cta_ctb_red
				When 'C' then 11155
			End),
				cd_cred_Dev_hia,
					
					'LA: ' + CXA.Num_Lcto + ' - ' + CC.num_proc_hia + ' - Cliente/Fornecedor: ' + apelido 
		From 
			vwcta_Cte CC
			Join vwcliente C on C.num_proc=CC.num_proc_Hia
		Join Pessoa PP on pp.cd_pes=cd_cred_dev_hia
		Join vwcxas CXA on cxa.num_proc_hia=cc.num_proc_hia and cxa.dc_hia=cc.dc_hia and cc.cd_tp_Tx=cxa.cd_tp_tx
		Join Pgto_rcto PG on PG.num_lcto=CXA.num_lcto
		Join cta_Cte CCC on CCC.cd_banco=PG.cd_banco and CCC.cd_agencia=PG.cd_agencia and CCC.num_cta_cte=PG.num_cta_cte
		Join cta_ctb CB on CB.cd_Cta_ctb=CCC.cd_cta_ctb
		where
			left(cc.cd_tp_tx,1)='X' 
			and desp_org_hia='N'
			and cxa.num_proc_hia = @JOB
			--and convert(Datetime,dt_pgto_rcto,105)  between @DataInicial and @DataFinal
union all
		Select 
			dt_ins,num_proc,cd_tp_tx,dc,Isnull(RFI.Valor_Total_Moeda_Local,Valor_Total),Isnull(RFI.Valor_Total_Moeda_Local,Valor_Total),'Doc-Register',0,
			(Case DC
				--siberio pediu pra alterar pra  de 22400 para 22223 11/6
				-- no when era D
				--When 'D' then 22223
				--Sibério pediu para alterar de 22223 para 22399 05-07-2013
				When 'C' then 22399
				--When 'C' then 0
				else (Case left(num_proc,2)
								When 'EA' then '44446'
								When 'IA' then '44444'
								When 'EM' then '44447'
								When 'IM' then '44445'
								When 'IO' then '44448'
								When 'EO' then '44448'
								End)
			End),
			
			(Case DC
				--no when era D
				--When 'D' then 0
				--When 'D' then (Case left(num_proc,2)
				When 'C' then (Case left(num_proc,2)
								When 'EA' then '44446'
								When 'IA' then '44444'
								When 'EM' then '44447'
								When 'IM' then '44445'
								When 'IO' then '44448'
								When 'EO' then '44448'
								End)
				--neste when era C
				--When 'C' then 22223
				--When 'D' then 22223
				When 'D' then 22399
			End),

				RF.cd_pes,'JOB: ' + Num_Proc + ' - Doc Register: ' + cast((RFI.num_registro) as varchar(30))+ ' - Fornecedor: ' + apelido 
		From 
			 registro_financeiro RF 
			--Join vwcliente C on C.num_proc=CC.num_proc_Hia
			join registro_financeiro_item RFI on RF.ano=rfi.ano and rfi.mes=rf.mes and rf.num_registro=rfi.num_registro

		Join Pessoa PP on pp.cd_pes=RF.cd_pes
		where
			--month(@datafinal)=RFI.mes and year(@datafinal)=RFI.ano
			num_proc = @JOB

	End
Else
	Begin
	
		insert contabilidade_bls
				Select Convert(datetime,dt_ins_hia,105),cc.num_proc_hia,cc.cd_tp_tx,cc.dc_hia,vlr_org_hia,vlr_org_hia* [dbo].[VerParidade](dt_ins_hia,cc.cd_tp_moeda,'OFC'),'FAT',0,
			
				22399,22223,cd_cred_Dev_hia,'Fatura: ' + CC.num_proc_hia + ' - Fornecedor: ' + apelido From vwcta_Cte CC
		Join vwcliente C on C.num_proc=CC.num_proc_Hia
		Join Item_Fat fat on fat.num_proc=cc.num_proc_hia and fat.cd_tp_Tx=cc.cd_tp_tx and fat.dc=CC.dc_hia
		Join Pessoa PP on pp.cd_pes=cd_cred_dev_hia
		where
			--data <=@Datafinal
			left(cc.cd_tp_tx,1)<>'X' 
			and dc_hia='D'
			and desp_org_hia='N'
			--and fat.num_proc is null
			and convert(Datetime,dt_ins_hia,105) between @DataInicial and @DataFinal
			and vlr_org_hia <> 0
			--and cc.num_proc_hia = @JOB
			

		Union all --Cta_cte_Master

		Select Convert(datetime,dt_ins_hia,105),cc.num_proc_hia,cc.cd_tp_tx,cc.dc_hia,vlr_org_hia,vlr_org_hia* [dbo].[VerParidade](dt_ins_hia,cc.cd_tp_moeda,'OFC'),'FAT',0,
				22399,
				22223,cd_cred_Dev_hia,'Fatura: ' + CC.num_proc_hia + ' - Fornecedor: ' + apelido From vwcta_Cte CC
		Join LLP_Master C on num_proc_master=CC.num_proc_hia
		Join Item_Fat fat on fat.num_proc=cc.num_proc_hia and fat.cd_tp_Tx=cc.cd_tp_tx and fat.dc=CC.dc_hia
		Join Pessoa PP on pp.cd_pes=cd_cred_dev_hia
		where
			--ETD_Master <=@DataFinal and
			left(cc.cd_tp_tx,1)<>'X' and
			dc_hia='D' and
			desp_org_hia='N' and
			--fat.num_proc is null and
			convert(Datetime,dt_ins_hia,105) between @DataInicial and @DataFinal
			and vlr_org_hia <> 0
			--cc.num_proc_hia = @JOB

		Union All
		
		Select Convert(datetime,dt_ins_hia,105),cc.num_proc_hia,cc.cd_tp_tx,cc.dc_hia,vlr_org_hia,vlr_org_hia* [dbo].[VerParidade](dt_ins_hia,cc.cd_tp_moeda,'OFC'),'PROV',0,
			
				22399,22223,cd_cred_Dev_hia,'Provisão de Pagamento: ' + CC.num_proc_hia + ' - Fornecedor: ' + apelido From vwcta_Cte CC
		Join vwcliente C on C.num_proc=CC.num_proc_Hia
		Left Join Item_Fat fat on fat.num_proc=cc.num_proc_hia and fat.cd_tp_Tx=cc.cd_tp_tx and fat.dc=CC.dc_hia
		Join Pessoa PP on pp.cd_pes=cd_cred_dev_hia
		where
			data <=@Datafinal
			and left(cc.cd_tp_tx,1)<>'X' 
			and dc_hia='D'
			and desp_org_hia='N'
			and fat.num_proc is null
			and convert(Datetime,dt_ins_hia,105) between @DataInicial and @DataFinal
			and vlr_org_hia <> 0

			

		Union all --Cta_cte_Master

		Select Convert(datetime,dt_ins_hia,105),cc.num_proc_hia,cc.cd_tp_tx,cc.dc_hia,vlr_org_hia,vlr_org_hia* [dbo].[VerParidade](dt_ins_hia,cc.cd_tp_moeda,'OFC'),'PROV',0,
				22399,
				22223,cd_cred_Dev_hia,'Provisão de Pagamento: ' + CC.num_proc_hia + ' - Fornecedor: ' + apelido From vwcta_Cte CC
		Join LLP_Master C on num_proc_master=CC.num_proc_hia
		Left Join Item_Fat fat on fat.num_proc=cc.num_proc_hia and fat.cd_tp_Tx=cc.cd_tp_tx and fat.dc=CC.dc_hia
		Join Pessoa PP on pp.cd_pes=cd_cred_dev_hia
		where
			ETD_Master <=@DataFinal and
			left(cc.cd_tp_tx,1)<>'X' and
			dc_hia='D' and
			desp_org_hia='N' and
			fat.num_proc is null and
			convert(Datetime,dt_ins_hia,105) between @DataInicial and @DataFinal and
			vlr_org_hia <> 0 

		Union All

		Select 
			emissao,cc.num_proc_hia,cc.cd_tp_tx,cc.dc_hia,vlr_pgto_nf_hia,vlr_pgto_nf_hia,'NF',0,
			(Case DC_HIA
				When 'C' then 22400
				--When 'C' then 0
				else (Case left(cc.num_proc_hia,2)
								When 'EA' then '33333'
								When 'IA' then '33334'
								When 'EM' then '33335'
								When 'IM' then '33336'
								When 'IO' then '33337'
								When 'EO' then '33337'
								End)
			End),
			
			(Case DC_HIA
				--When 'D' then 0
				When 'C' then (Case left(cc.num_proc_hia,2)
								When 'EA' then '33333'
								When 'IA' then '33334'
								When 'EM' then '33335'
								When 'IM' then '33336'
								When 'IO' then '33337'
								When 'EO' then '33337'
								End)
				When 'D' then 22400
			End),

				cd_cred_Dev_hia,'JOB: ' + CC.num_proc_Hia + ' - Nota Fiscal Emitida: ' + cast(isnull(RPS_NFE,Num_Nf_HIA) as varchar(30))+ ' - Cliente: ' + apelido 
		From 
			vwcta_Cte CC
			--Join vwcliente C on C.num_proc=CC.num_proc_Hia
		Join Pessoa PP on pp.cd_pes=cd_cred_dev_hia
		Join BAse_Nota_Fiscal NF on NF.nota_Fiscal=num_nf_hia and ref_acesso=ref_Acesso_nf_hia
		where
			left(cc.cd_tp_tx,1)<>'X' 
			and desp_org_hia='N'
			and Emissao between @DataInicial and @DataFinal

		union all
/*
		Select 
			convert(Datetime,dt_pgto_rcto,105),cc.num_proc_hia,cc.cd_tp_tx,cc.dc_hia,vlr_pgto_rcto_hia,vlr_pgto_rcto_hia,'LA',0,
			(Case cc.DC_HIA
				When 'C' then cd_Cta_ctb_red
				else 22223
			End),
			
			(Case cc.DC_HIA
				When 'D' then cd_Cta_ctb_red
				When 'C' then 11155
			End),

				cd_cred_Dev_hia,  'LA: ' + CXA.Num_Lcto + ' - ' + CC.num_proc_hia + ' - Cliente/Fornecedor: ' + apelido 
		From 
			vwcta_Cte CC
			Join vwcliente C on C.num_proc=CC.num_proc_Hia
		Join Pessoa PP on pp.cd_pes=cd_cred_dev_hia
		Join vwcxas CXA on cxa.num_proc_hia=cc.num_proc_hia and cxa.dc_hia=cc.dc_hia and cc.cd_tp_Tx=cxa.cd_tp_tx and cxa.Num_lcto <> 'REMESSA'
		Join Pgto_rcto PG on PG.num_lcto=CXA.num_lcto 
		Join cta_Cte CCC on CCC.cd_banco=PG.cd_banco and CCC.cd_agencia=PG.cd_agencia and CCC.num_cta_cte=PG.num_cta_cte
		Join cta_ctb CB on CB.cd_Cta_ctb=CCC.cd_cta_ctb
		where
			left(cc.cd_tp_tx,1)<>'X' 
			and desp_org_hia='N'
			and convert(Datetime,dt_pgto_rcto,105)  between @DataInicial and @DataFinal
		
		Union All
*/
		Select 
			convert(Datetime,dt_pgto_rcto,105),cc.num_proc_hia,cc.cd_tp_tx,cc.dc_hia,vlr_pgto_rcto_hia,vlr_pgto_rcto_hia,'LA',0,
			(Case cc.DC_HIA
				When 'C' then CB.cd_Cta_ctb_red
				else 22223
			End),
			
			(Case cc.DC_HIA
				When 'D' then CB.cd_Cta_ctb_red
				When 'C' then Isnull(PAS.cd_Cta_Ctb_red,11155)
			End),

				cd_cred_Dev_hia,  
				(
					case 
						when (pas.cd_Cta_Ctb_red is not null and CC.dc_hia='C' and nome_Tp_Tx like 'Demurrage%') then 'Receita de Demurrage - '
						else ''
					end
				) +
				'LA: ' + CXA.Num_Lcto + ' - ' + CC.num_proc_hia + ' - Cliente/Fornecedor: ' + apelido 
		From 
			vwcta_Cte CC
			--Join vwcliente C on C.[master]=CC.num_proc_Hia
		Join Pessoa PP on pp.cd_pes=cd_cred_dev_hia
		Join vwcxas CXA on cxa.num_proc_hia=cc.num_proc_hia and cxa.dc_hia=cc.dc_hia and cc.cd_tp_Tx=cxa.cd_tp_tx and cxa.Num_lcto <> 'REMESSA'
		Join Pgto_rcto PG on PG.num_lcto=CXA.num_lcto 
		Join cta_Cte CCC on CCC.cd_banco=PG.cd_banco and CCC.cd_agencia=PG.cd_agencia and CCC.num_cta_cte=PG.num_cta_cte
		Join cta_ctb CB on CB.cd_Cta_ctb=CCC.cd_cta_ctb
		Join Tipo_Taxa TT on tt.cd_tp_tx=CC.cd_tp_Tx
		Left Join cta_ctb PAS on PAS.cd_cta_ctb=cd_Cta_Ctb_atv
		where
			left(cc.cd_tp_tx,1)<>'X' 
			and desp_org_hia='N'
			and convert(Datetime,dt_pgto_rcto,105)  between @DataInicial and @DataFinal
		Union All


		Select 
			convert(Datetime,dt_ra,105),cc.num_proc_hia,cc.cd_tp_tx,cc.dc_hia,vlr_pgto_rcto_hia,vlr_pgto_rcto_hia,'RA',0,
			(Case cc.DC_HIA
				When 'C' then cd_Cta_ctb_red
--				else 11155
				else 22223
			End),
			
			(Case cc.DC_HIA
				When 'D' then cd_Cta_ctb_red
--				When 'C' then 11155
				When 'C' then 22223
			End),

				cd_cred_Dev_hia,'Remessa Internacional:' + num_ref_ra + ' - ' + CC.num_proc_hia + ' - Cliente/Fornecedor: ' + apelido 
		From 
			vwcta_Cte CC
		--	Join vwcliente C on C.num_proc=CC.num_proc_Hia
		Join Pessoa PP on pp.cd_pes=cd_cred_dev_hia
		Join vwcxas CXA on cxa.num_proc_hia=cc.num_proc_hia and cxa.dc_hia=cc.dc_hia and cc.cd_tp_Tx=cxa.cd_tp_tx
		Join Remessa_aer PG on num_ref_ra=num_rcb_hia
		Join cta_Cte CCC on CCC.cd_banco=PG.cd_banco and CCC.cd_agencia=PG.cd_agencia and CCC.num_cta_cte=PG.num_cta_cte
		Join cta_ctb CB on CB.cd_Cta_ctb=CCC.cd_cta_ctb
		where
			left(cc.cd_tp_tx,1)<>'X' 
			and desp_org_hia='N'
			and convert(Datetime,dt_ra,105)  between @DataInicial and @DataFinal

		Union all



		Select 
			convert(Datetime,dt_rm,105),cc.num_proc_hia,cc.cd_tp_tx,cc.dc_hia,vlr_pgto_rcto_hia,vlr_pgto_rcto_hia,'RA',0,
			(Case cc.DC_HIA
				When 'C' then cd_Cta_ctb_red
--				else 11155
				else 22223
			End),
			
			(Case cc.DC_HIA
				When 'D' then cd_Cta_ctb_red
--				When 'C' then 11155
				When 'C' then 22223
			End),
				cd_cred_Dev_hia,
					
					'Remessa Internacional: ' + num_ref_rm +  ' - ' + CC.num_proc_hia + ' - Cliente/Fornecedor: ' + apelido 
		From 
			vwcta_Cte CC
		--	Join vwcliente C on C.num_proc=CC.num_proc_Hia
		Join Pessoa PP on pp.cd_pes=cd_cred_dev_hia
		Join vwcxas CXA on cxa.num_proc_hia=cc.num_proc_hia and cxa.dc_hia=cc.dc_hia and cc.cd_tp_Tx=cxa.cd_tp_tx
		Join Remessa_MAR PG on num_ref_rm=num_rcb_hia
		Join cta_Cte CCC on CCC.cd_banco=PG.cd_banco and CCC.cd_agencia=PG.cd_agencia and CCC.num_cta_cte=PG.num_cta_cte
		Join cta_ctb CB on CB.cd_Cta_ctb=CCC.cd_cta_ctb
		where
			left(cc.cd_tp_tx,1)<>'X' 
			and desp_org_hia='N'
			and convert(Datetime,dt_rm,105)  between @DataInicial and @DataFinal

		union all

		Select 
			convert(Datetime,dt_pgto_rcto,105),cc.num_proc_hia,cc.cd_tp_tx,cc.dc_hia,vlr_pgto_rcto_hia,vlr_pgto_rcto_hia,'LA-CHB',0,
			(Case cc.DC_HIA
				When 'C' then cd_Cta_ctb_red
				else 22236 
			End),
			
			(Case cc.DC_HIA
				When 'D' then cd_Cta_ctb_red
				When 'C' then 22236 
			End),
				cd_cred_Dev_hia,
					
					'LA: ' + CXA.Num_Lcto + ' - ' + CC.num_proc_hia + ' - Cliente/Fornecedor: ' + apelido 
		From 
			vwcta_Cte CC
			--Join vwcliente C on C.num_proc=CC.num_proc_Hia
		Join Pessoa PP on pp.cd_pes=cd_cred_dev_hia
		Join vwcxas CXA on cxa.num_proc_hia=cc.num_proc_hia and cxa.dc_hia=cc.dc_hia and cc.cd_tp_Tx=cxa.cd_tp_tx
		Join Pgto_rcto PG on PG.num_lcto=CXA.num_lcto
		Join cta_Cte CCC on CCC.cd_banco=PG.cd_banco and CCC.cd_agencia=PG.cd_agencia and CCC.num_cta_cte=PG.num_cta_cte
		Join cta_ctb CB on CB.cd_Cta_ctb=CCC.cd_cta_ctb
		where
			left(cc.cd_tp_tx,1)='X' 
			and desp_org_hia='N'
			and convert(Datetime,dt_pgto_rcto,105)  between @DataInicial and @DataFinal
	
	Union all 
	
		Select 
			dt_ins,num_proc,cd_tp_tx,dc,Isnull(RFI.Valor_Total_Moeda_Local,Valor_Total),Isnull(RFI.Valor_Total_Moeda_Local,Valor_Total),'Doc-Register',0,
			(Case DC
				--siberio pediu pra alterar pra  de 22400 para 22223 11/6
				-- no when era D
				--When 'D' then 22223
				--Sibério pediu para alterar de 22223 para 22399 05-07-2013
				When 'C' then 22399
				--When 'C' then 0
				else (Case left(num_proc,2)
								When 'EA' then '44446'
								When 'IA' then '44444'
								When 'EM' then '44447'
								When 'IM' then '44445'
								When 'IO' then '44448'
								When 'EO' then '44448'
								End)
			End),
			
			(Case DC
				--no when era D
				--When 'D' then 0
				--When 'D' then (Case left(num_proc,2)
				When 'C' then (Case left(num_proc,2)
								When 'EA' then '44446'
								When 'IA' then '44444'
								When 'EM' then '44447'
								When 'IM' then '44445'
								When 'IO' then '44448'
								When 'EO' then '44448'
								End)
				--neste when era C
				--When 'C' then 22223
				--When 'D' then 22223
				When 'D' then 22399
			End),

				RF.cd_pes,'JOB: ' + Num_Proc + ' - Doc Register: ' + cast((RFI.num_registro) as varchar(30))+ ' - Fornecedor: ' + apelido 
		From 
			 registro_financeiro RF 
			--Join vwcliente C on C.num_proc=CC.num_proc_Hia
			join registro_financeiro_item RFI on RF.ano=rfi.ano and rfi.mes=rf.mes and rf.num_registro=rfi.num_registro

		Join Pessoa PP on pp.cd_pes=RF.cd_pes
		where
			month(@datafinal)=RFI.mes and year(@datafinal)=RFI.ano


	End
GO
