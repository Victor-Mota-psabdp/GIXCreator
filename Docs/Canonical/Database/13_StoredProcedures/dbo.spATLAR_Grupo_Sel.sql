SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from Pessoa where Nome_Raz_Soc = 'AETHRA SISTEMAS AUTOMOTIVOS S.A.'

CREATE Procedure [dbo].[spATLAR_Grupo_Sel] --'2015-08-31','GRUPO AETHRA'
	@DataFinal	Datetime,
	@Grupo varchar(50)
as

Declare @TaxasEmAberto Table
(
	Nome_Raz_Soc Varchar(100),
	Endereco	 Varchar(500),
	Fatura		 Varchar(17),
	Apelido		 Varchar(50),
	Num_proc	 Varchar(16),
	Vencimento   Datetime,
	Taxa		 Varchar(60),
	DC			 Char(1),
	Moeda		 Varchar(3),
	Vlr_Org		 Decimal (18,2),
	Vlr_Org_RS	 Decimal(18,2),
	Range_Fluxo	 Varchar(40)
)

Insert @TaxasEmAberto (Nome_Raz_Soc,Endereco,Fatura,Apelido,Num_proc,vencimento,taxa,dc,moeda,vlr_org,vlr_org_rs)

Select 
 PP.Nome_Raz_Soc,
Rua +' ' + isnull(numero,'') + ' - ' + isnull(Cidade,'Nao Informada') + ' - ' + isnull(UF,'')  + 'CEP:' + isnull(CEP,''),
fat.fatcod,isnull(GRP.apelido,PP.Apelido),CTA.num_proc_hia,fatdtvenc,Nome_TP_TX Taxa,cta.dc_hia,
cta.cd_Tp_moeda Moeda, dbo.valor(Vlr_ORg_HIA,cta.DC_HIA),0 
From 
	Fatura FAt With(Nolock)
	Join item_fat Item With(Nolock) on item.fatcod=fat.fatcod
	Left Join Pessoa_LLP PLLP With(Nolock)  on PLLP.cd_pes=FAT.cd_pes
	Left Join Pessoa GRP with(nolock) on GRP.cd_pes=cd_pes_Grupo and GRP.cd_pes <> 'GRATL'
	Join PEssoa PP with(nolock) on PP.cd_pes=FAT.cd_pes
	Join vwcta_cte cta with(nolock) on cta.num_proc_hia=lefT(item.fatcod,16) and item.cd_tp_tx=cta.cd_Tp_tx and item.dc=cta.dc_hia
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=cta.cd_tp_tx
	Left Join vwcxas CXA with(nolock) on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_Tp_Tx and cta.dc_hia=cxa.dc_hia and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataFinal
	Left Join base_nota_fiscal NF with(nolock) on num_nf_hia=nota_fiscal and ref_Acesso=ref_acesso_nf_hia and cd_status <> '2'
	Left Join Endereco ED with(nolock) on PP.cd_pes=ed.cD_pes and cd_tp_end='COM'
where
	PP.cd_tp_ativ <> 'AGT' 
	and cxa.num_Lcto is null
	and fatstatus=1
	and desp_org_hia='N'
	and emissao is null
	and Ref_Ctb_Tx <> 'SRV'
	and fatdtemissao <=@DataFinal
	and isnull(GRP.apelido,PP.Apelido) = @Grupo
	
union all
Select 
PP.Nome_Raz_Soc,
Rua +' ' + isnull(numero,'') + ' - ' + isnull(Cidade,'Nao Informada') + ' - ' + isnull(UF,'')  + 'CEP:' + isnull(CEP,''),
Nota_Fiscal,isnull(GRP.apelido,PP.Apelido),CTA.num_proc_hia,convert(datetime,dt_prev_pgto_hia,105),Nome_TP_TX Taxa,
cta.dc_hia,cta.cd_Tp_moeda Moeda, dbo.valor(Vlr_ORg_HIA,cta.DC_HIA),0 From vwcta_cte cta With(Nolock)
Left Join Pessoa_LLP PLLP With(Nolock)  on PLLP.cd_pes=cd_cred_Dev_hia
Left Join Pessoa GRP with(nolock) on GRP.cd_pes=cd_pes_Grupo and GRP.cd_pes <> 'GRATL'
Join PEssoa PP with(nolock) on PP.cd_pes=cd_cred_Dev_hia
Join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=cta.cd_tp_tx
Left Join vwcxas CXA with(nolock) on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_Tp_Tx and cta.dc_hia=cxa.dc_hia and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataFinal
Join base_nota_fiscal NF with(nolock) on num_nf_hia=nota_fiscal and ref_Acesso=ref_acesso_nf_hia and cd_status <> '2'
Left Join Endereco ED with(nolock)  on PP.cd_pes=ed.cD_pes and cd_tp_end='COM'
where
	PP.cd_tp_ativ <> 'AGT' 
	and cxa.num_Lcto is null

	and desp_org_hia='N'
	and emissao  <=@DataFinal
	and isnull(GRP.apelido,PP.Apelido) = @Grupo
	
Update @TaxasEmAberto
	SEt vlr_org_rs=Vlr_ORg* [dbo].[FConverterMoeda](Moeda,'REL')


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
		

-- Alterado para incluir a coluna de PO no relatorio - Rafael Matjas - 27/06/2013
		
select *,dbo.fBusca_Tarefa(Num_proc,124) [Envio de Cobrança Bancária],dbo.fBusca_Docs_PO_Modal(Num_proc,9) [PO]
 From @TaxasEmAberto

--select *,dbo.fBusca_Tarefa(Num_proc,124) [Envio de Cobrança Bancária] From @TaxasEmAberto
--where fatura  in (select fatura from @TaxasEmAberto group by Fatura having sum(dbo.valor(Vlr_Org_RS,dc))>0)


GO
