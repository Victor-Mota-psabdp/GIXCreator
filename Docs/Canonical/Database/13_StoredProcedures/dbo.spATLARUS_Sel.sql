SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATLARUS_Sel] -- [dbo].[spATLARUS_Sel]  '2014-01-29'
	@DataFinal	Datetime
as

Declare @Fatura Table
		(
			Fatcod		varchar(17),
			Num_proc	varchar(16),
			Cd_tp_Tx	Varchar(3),
			DC			Varchar(1),
			cd_pes		varchar(10),
			fatdtemissao datetime,
			fatdtvenc	datetime			
		)
	Begin 		
		Insert @Fatura		
			Select i.fatcod,(case when len(i.fatcod)= 15 then left(i.fatcod,14) else left(i.fatcod,16) end) ,	
			cd_tp_Tx,dc,cd_pes,fatdtemissao,fatdtvenc from item_fat I with(nolock)
				Join Fatura F with(nolock) on F.fatcod=i.fatcod 
			where
				fatdtEmissao >='2013-01-01' and fatstatus =1
	End

Declare @TaxasEmAberto Table
(
	Nome_Raz_Soc Varchar(100),
	Endereco Varchar(500),
	Fatura	Varchar(17),
	Apelido	Varchar(50),
	Num_proc	Varchar(16),
	Vencimento Datetime,
	Taxa		Varchar(60),
	DC			Char(1),
	Moeda		Varchar(3),
	Vlr_Org		Decimal (10,2),
	Vlr_Org_RS	Decimal(10,2),
	Range_Fluxo	Varchar(40),
	Cd_PEs		Varchar(10),
	Dt_Emis		Datetime,
	cd_ax		varchar(5),
	AX_DOC		bigint
)


Insert @TaxasEmAberto (Nome_Raz_Soc,Endereco,Fatura,Apelido,Num_proc,vencimento,taxa,dc,moeda,vlr_org,vlr_org_rs,cd_pes,dt_emis,cd_ax,AX_DOC)

Select 
 PP.Nome_Raz_Soc,
Rua +' ' + isnull(numero,'') + ' - ' + isnull(Cidade,'Nao Informada') + ' - ' + isnull(UF,'')  + 'CEP:' + isnull(CEP,''),
fat.fatcod,isnull(GRP.apelido,PP.Apelido),CTA.num_proc_hia,fatdtvenc,Nome_TP_TX Taxa,cta.dc_hia,cta.cd_Tp_moeda Moeda, Vlr_ORg_HIA,0,
FAT.Cd_Pes, fatdtemissao,AX.cd_ax, AD.id_Ax
From 
--	Fatura FAt With(Nolock)
	@Fatura FAt
--	Join item_fat Item With(Nolock) on item.fatcod=fat.fatcod
	Left Join Pessoa_LLP PLLP With(Nolock)  on PLLP.cd_pes=FAT.cd_pes
	Left Join Pessoa GRP with(nolock) on GRP.cd_pes=cd_pes_Grupo and GRP.cd_pes <> 'GRATL'
	Join PEssoa PP with(nolock) on PP.cd_pes=FAT.cd_pes
--	Join vwcta_cte cta with(nolock) on cta.num_proc_hia=lefT(item.fatcod,16) and item.cd_tp_tx=cta.cd_Tp_tx and item.dc=cta.dc_hia
	Join vwcta_cte cta with(nolock) on cta.num_proc_hia=Fat.num_proc and fat.cd_tp_tx=cta.cd_Tp_tx and fat.dc=cta.dc_hia
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=cta.cd_tp_tx
	Left Join vwcxas CXA with(nolock) on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_Tp_Tx and cta.dc_hia=cxa.dc_hia and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataFinal
	Left Join base_nota_fiscal NF with(nolock) on num_nf_hia=nota_fiscal and ref_Acesso=ref_acesso_nf_hia and cd_status <> '2'
	Left Join Endereco ED with(nolock) on PP.cd_pes=ed.cD_pes and cd_tp_end='COM'
	Left Join Pessoa_ATL_AX AX on (PP.cd_tp_ativ <> 'AGT' and AX.Cd_Pes = PP.Cd_Pes or PP.cd_tp_Ativ='AGT' and left(ax.cd_pes,len(ax.cd_pes)-1)=PP.cd_pes) and AX.Tipo='C'
	Left Join vwAXDocs AD with(nolock) on Cta.Num_Proc_HIA = AD.num_proc and Cta.Cd_Tp_Tx = AD.cd_tp_tx_Atl and Cta.DC_HIA = AD.dc 
where
	--PP.cd_tp_ativ <> 'AGT' 
	--and 
	cxa.num_Lcto is null
--	and fatstatus=1
	and desp_org_hia='N'
	and emissao is null
	and Ref_Ctb_Tx <> 'SRV'
	and fatdtemissao <=@DataFinal
	
union all
Select 
	PP.Nome_Raz_Soc,
	Rua +' ' + isnull(numero,'') + ' - ' + isnull(Cidade,'Nao Informada') + ' - ' + isnull(UF,'')  + 'CEP:' + isnull(CEP,''),
	Nota_Fiscal,isnull(GRP.apelido,PP.Apelido),CTA.num_proc_hia,convert(datetime,dt_prev_pgto_hia,105),Nome_TP_TX Taxa,cta.dc_hia,cta.cd_Tp_moeda Moeda, Vlr_ORg_HIA,0 ,
	PP.Cd_Pes, Emissao,AX.cd_ax, AD.id_Ax
From 
	vwcta_cte cta With(Nolock)
	Left Join Pessoa_LLP PLLP With(Nolock)  on PLLP.cd_pes=cd_cred_Dev_hia
	Left Join Pessoa GRP with(nolock) on GRP.cd_pes=cd_pes_Grupo and GRP.cd_pes <> 'GRATL'
	Join PEssoa PP with(nolock) on PP.cd_pes=cd_cred_Dev_hia
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=cta.cd_tp_tx
	Left Join vwcxas CXA with(nolock) on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_Tp_Tx and cta.dc_hia=cxa.dc_hia and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataFinal
	Join base_nota_fiscal NF with(nolock) on num_nf_hia=nota_fiscal and ref_Acesso=ref_acesso_nf_hia and cd_status <> '2'
	Left Join Endereco ED with(nolock)  on PP.cd_pes=ed.cD_pes and cd_tp_end='COM'
	Left Join Pessoa_ATL_AX AX on (PP.cd_tp_ativ <> 'AGT' and AX.Cd_Pes = PP.Cd_Pes or PP.cd_tp_Ativ='AGT' and left(ax.cd_pes,len(ax.cd_pes)-1)=PP.cd_pes) and AX.Tipo='C'
	Left Join vwAXDocs AD with(nolock) on Cta.Num_Proc_HIA = AD.num_proc and Cta.Cd_Tp_Tx = AD.cd_tp_tx_Atl and Cta.DC_HIA = AD.dc 
where
	--PP.cd_tp_ativ <> 'AGT' 
	--and 
	cxa.num_Lcto is null
	and desp_org_hia='N'
	and emissao  <=@DataFinal
	
Update @TaxasEmAberto
	--SEt vlr_org_rs=Vlr_ORg* [dbo].[FConverterMoeda](Moeda,'REL')
	SEt vlr_org_rs= Vlr_ORg * [dbo].[VerParidade](convert(varchar(10),Dt_Emis,103),Moeda,'OFC')

Update @TaxasEmAberto
	Set Range_Fluxo=
		(
			Case
				When Getdate()-vencimento <= 30 Then '30 Days'
				When Getdate()-vencimento <=60 then '60 Days'
				When getdate()-vencimento <=90 then '90 Days'
				When getdate() - vencimento <=120 then '120 Days'
				else 'More than 120 Days'
			End
		)
		

--select *,dbo.fBusca_Tarefa(Num_proc,124) [Envio de Cobrança Bancária], dbo.fBusca_TipoDocCliente('N',num_proc,1) CustomerReference From @TaxasEmAberto
--where fatura  in (select fatura from @TaxasEmAberto group by Fatura having sum(dbo.valor(Vlr_Org_RS,dc))>0)
update @TaxasEmAberto set moeda='BRL'
where moeda='REL'

select 
	num_proc [BDP Ref.],
	dbo.fBusca_TipoDocCliente('N',num_proc,1) [Customer Reference],
	Cd_Pes [Customer Code],
	Nome_Raz_Soc [Customer Name],
	Dt_Emis	[Invoice Dt],
	Vencimento [Due Dt],
	Moeda	[Currency],
	sum(Vlr_Org) [Value],
	sum(isnull(Vlr_Org_RS,dbo.FConverterMoeda(Moeda,'REL')*Vlr_Org)) [BRL Value],
--	sum(isnull(Vlr_Org_RS,[dbo].[VerParidade](Dt_Emis,Moeda,'OFC') * Vlr_Org)) [BRL Value],
	Range_Fluxo [Range],
	cd_ax		[cd_ax],
	AX_DOC [AX DOC]
	
from 
	@TaxasEmAberto
--Where 
--	dc='C' 
--retirado dia 29/01/14 cadu
Group by num_proc,moeda,range_fluxo,cd_pes,nome_raz_soc,dt_emis,vencimento,cd_ax,AX_DOC
GO
