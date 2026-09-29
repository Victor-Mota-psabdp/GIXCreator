SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[spRelacaoProcessoFechadosFAT_Vivian_Sel] '','2014-07-01','2014-07-15'
CREATE Procedure [dbo].[spRelacaoProcessoFechadosFAT_Vivian_Sel] --'','2014-07-01','2014-07-31'
	@Grupo			Varchar(400),
	@DataInicial	Datetime,
	@DataFinal		Datetime
AS
Declare @Tabela Table (	
	[Fatura BDP] Varchar(17),
	[CNPJ] varchar(16),
	[Ref. PO] Varchar(100),
	[Ref. Cliente] Varchar(100),
	[Data Emissao]	Datetime,	
	[BDP Servicos Valor] float,
	[Adiantamento Valor] float,
	[Total Faturamento Valor] float,
	[Saldo Valor] float
	)
Declare @TabelaC Table (	
[JOB] Varchar(16),
[Consignee] Varchar(50),
[Exportador] Varchar(50),
[LLP Unit] Varchar(50),
[CSR] Varchar(50),
[Destination] Varchar(50),
[Origin] Varchar(50),
[Import/Export] Varchar(50)
	)
	Declare @Cd_Grupo as varchar(10)
	
	If @Grupo is null or @Grupo = ''
		begin
		Set @Cd_Grupo ='%'
		end
	else
		begin
			Set @Cd_Grupo = (select top 1 Cd_Pes from pessoa where apelido=@Grupo)
		end

--Inserir informações Basicas

Insert @Tabela([Fatura BDP],CNPJ,[Ref. PO],[Ref. Cliente],[Data Emissao])

Select 
	Fatura_PC,num_cpf_cnpj,dbo.fBusca_TipoDocCliente('N',left([Fatura_PC],16),1),
	dbo.fBusca_TipoDocCliente('N',left([Fatura_PC],16),3),Data_PC 
from 
	Fatura_CHB 
	Join Pessoa PP on pp.cd_pes=cd_pes_pc
	Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=cd_pes_pc and PLL.Cd_Pes_Grupo like @Cd_Grupo
where 
	status_Pc='E' and Data_PC between @DataInicial and @DataFinal--and fatura_pc like '%SUN%'


update  @tabela  set [Adiantamento Valor]=isnull((select sum(vlr_pc) from fatura_chb_item where fatura_cc=[Fatura BDP] and cd_Tp_Tx in (select cd_tp_Tx from tipo_Taxa where nome_Tp_Tx like 'Adiant%')) ,0)

update  @Tabela  set [Total Faturamento Valor]=isnull((select sum(vlr_pc) from fatura_chb_item where fatura_cc=[Fatura BDP] and tp_pgto='B' and cd_Tp_Tx in (select cd_tp_Tx from tipo_Taxa where nome_Tp_Tx not like 'Adiant%')) ,0)

update  @Tabela  set [BDP Servicos Valor]=
isnull(
(
	select 
		sum(vlr_pc) 
	from 
		fatura_chb_item CHB
		Join vwcta_Cte CTA on cta.num_proc_hia=left([Fatura BDP],16) and dc_hia='C' and num_nf_hia is null
	where 
		fatura_cc=[Fatura BDP] and tp_pgto='B' and CHB.cd_Tp_Tx in (select cd_tp_Tx from tipo_Taxa where nome_Tp_Tx not like 'Adiant%'))



 ,0)

update  @tabela  set [Saldo Valor]=[Adiantamento Valor]-[Total Faturamento Valor]

/*
select 	
	[Fatura BDP],
	[CNPJ],
	[Ref. PO],
	[Ref. Cliente],
	[Data Emissao],	
	[BDP Servicos Valor],
	[Adiantamento Valor],
	[Total Faturamento Valor],
	[Saldo Valor]
from 
	@Tabela 
*/
select 
[Fatura BDP],
[CNPJ],
[Ref. PO],
[Ref. Cliente],
Convert(Varchar(10),[Data Emissao],103) [Data Emissao],	
[BDP Servicos Valor],
[Adiantamento Valor],
[Total Faturamento Valor],
[Saldo Valor],
CN.Apelido [Consignee],
EX.Apelido [Exportador],
GN.Apelido [LLP Unit],
US.Nome_Usuario [CSR],
ORG.Nome_Local [Destination],
DST.Nome_Local [Origin],
'Import'[Import/Export]
from House_Imp_Mar HOU
join Job_Imp_Mar JB with(nolock) on HOU.Num_Proc_HIM = JB.Num_Proc_HIM
join Usuario US with(nolock) on JB.Cd_Usuario = US.Cd_Usuario
join Pessoa CN with(nolock) on HOU.Cd_Consig_Him=CN.Cd_Pes
join Pessoa EX with(nolock) on HOU.Cd_Export_Him=EX.Cd_Pes
left join Pessoa_LLP PA with(nolock) on HOU.Cd_Consig_Him=PA.Cd_Pes
join Pessoa GN with(nolock) on PA.Cd_Pes_grupo = GN.Cd_pes
join Localidade ORG with(nolock) on HOU.Cd_Org_Him = ORG.Cd_Local
join Localidade DST with(nolock) on HOU.Cd_DST_Him = DST.Cd_Local
join @Tabela TB on left([Fatura BDP],len(TB.[Fatura BDP])-1) =HOU.Num_proc_Him

union all

select 
[Fatura BDP],
[CNPJ],
[Ref. PO],
[Ref. Cliente],
Convert(Varchar(10),[Data Emissao],103) [Data Emissao],	
[BDP Servicos Valor],
[Adiantamento Valor],
[Total Faturamento Valor],
[Saldo Valor],
CN.Apelido [Consignee],
EX.Apelido [Exportador],
GN.Apelido [LLP Unit],
US.Nome_Usuario [CSR],
ORG.Nome_Local [Destination],
DST.Nome_Local [Origin],
'Import'[Import/Export]
from House_Imp_Aer HOU
join Job_Imp_Aer JB with(nolock) on HOU.Num_Proc_hia = JB.Num_Proc_hia
join Usuario US with(nolock) on JB.Cd_Usuario = US.Cd_Usuario
join Pessoa CN with(nolock) on HOU.Cd_Consig_hia=CN.Cd_Pes
join Pessoa EX with(nolock) on HOU.Cd_Export_hia=EX.Cd_Pes
left join Pessoa_LLP PA with(nolock) on HOU.Cd_Consig_hia=PA.Cd_Pes
join Pessoa GN with(nolock) on PA.Cd_Pes_grupo = GN.Cd_pes
join Localidade ORG with(nolock) on HOU.Cd_Org_hia = ORG.Cd_Local
join Localidade DST with(nolock) on HOU.Cd_DST_hia = DST.Cd_Local
join @Tabela TB on left([Fatura BDP],len(TB.[Fatura BDP])-1) =HOU.Num_proc_hia

Union ALL

select 
[Fatura BDP],
[CNPJ],
[Ref. PO],
[Ref. Cliente],
Convert(Varchar(10),[Data Emissao],103) [Data Emissao],	
[BDP Servicos Valor],
[Adiantamento Valor],
[Total Faturamento Valor],
[Saldo Valor],
CN.Apelido [Consignee],
EX.Apelido [Exportador],
GN.Apelido [LLP Unit],
US.Nome_Usuario [CSR],
ORG.Nome_Local [Destination],
DST.Nome_Local [Origin],
'Import'[Import/Export]
from House_Imp_Out HOU
join LLP_Imp_Out JB with(nolock) on HOU.Num_Proc_Hio = JB.Num_Proc_Lio
join Usuario US with(nolock) on JB.Cd_Usuario = US.Cd_Usuario
join Pessoa CN with(nolock) on HOU.Cd_Consig_Hio=CN.Cd_Pes
join Pessoa EX with(nolock) on HOU.Cd_Export_Hio=EX.Cd_Pes
left join Pessoa_LLP PA with(nolock) on HOU.Cd_Consig_Hio=PA.Cd_Pes
join Pessoa GN with(nolock) on PA.Cd_Pes_grupo = GN.Cd_pes
join Localidade ORG with(nolock) on HOU.Cd_Org_Hio = ORG.Cd_Local
join Localidade DST with(nolock) on HOU.Cd_DST_Hio = DST.Cd_Local
join @Tabela TB on left([Fatura BDP],len(TB.[Fatura BDP])-1) =HOU.Num_proc_Hio

Union ALL

select 
[Fatura BDP],
[CNPJ],
[Ref. PO],
[Ref. Cliente],
Convert(Varchar(10),[Data Emissao],103) [Data Emissao],	
[BDP Servicos Valor],
[Adiantamento Valor],
[Total Faturamento Valor],
[Saldo Valor],
CN.Apelido [Consignee],
EX.Apelido [Exportador],
GN.Apelido [LLP Unit],
US.Nome_Usuario [CSR],
ORG.Nome_Local [Destination],
DST.Nome_Local [Origin],
'Export'[Import/Export]
from House_Exp_Aer HOU
join Job_Exp_Aer JB with(nolock) on HOU.Num_Proc_hea = JB.Num_Proc_hea
join Usuario US with(nolock) on JB.Cd_Usuario = US.Cd_Usuario
join Pessoa CN with(nolock) on HOU.Cd_Consig_hea=CN.Cd_Pes
join Pessoa EX with(nolock) on HOU.Cd_Export_hea=EX.Cd_Pes
left join Pessoa_LLP PA with(nolock) on HOU.Cd_Export_hea=PA.Cd_Pes
join Pessoa GN with(nolock) on PA.Cd_Pes_grupo = GN.Cd_pes
join Localidade ORG with(nolock) on HOU.Cd_Org_hea = ORG.Cd_Local
join Localidade DST with(nolock) on HOU.Cd_DST_hea = DST.Cd_Local
join @Tabela TB on left([Fatura BDP],len(TB.[Fatura BDP])-1) =HOU.Num_proc_hea

union all


select 
[Fatura BDP],
[CNPJ],
[Ref. PO],
[Ref. Cliente],
Convert(Varchar(10),[Data Emissao],103) [Data Emissao],	
[BDP Servicos Valor],
[Adiantamento Valor],
[Total Faturamento Valor],
[Saldo Valor],
CN.Apelido [Consignee],
EX.Apelido [Exportador],
GN.Apelido [LLP Unit],
US.Nome_Usuario [CSR],
ORG.Nome_Local [Destination],
DST.Nome_Local [Origin],
'Export'[Import/Export]
from House_Exp_Out HOU
join LLP_Exp_Out JB with(nolock) on HOU.Num_Proc_Heo = JB.Num_Proc_Leo
join Usuario US with(nolock) on JB.Cd_Usuario = US.Cd_Usuario
join Pessoa CN with(nolock) on HOU.Cd_Consig_heo=CN.Cd_Pes
join Pessoa EX with(nolock) on HOU.Cd_Export_heo=EX.Cd_Pes
left join Pessoa_LLP PA with(nolock) on HOU.Cd_Export_heo=PA.Cd_Pes
join Pessoa GN with(nolock) on PA.Cd_Pes_grupo = GN.Cd_pes
join Localidade ORG with(nolock) on HOU.Cd_Org_heo = ORG.Cd_Local
join Localidade DST with(nolock) on HOU.Cd_DST_heo = DST.Cd_Local
join @Tabela TB on left([Fatura BDP],len(TB.[Fatura BDP])-1) =HOU.Num_proc_heo

union all

select 
[Fatura BDP],
[CNPJ],
[Ref. PO],
[Ref. Cliente],
Convert(Varchar(10),[Data Emissao],103) [Data Emissao],	
[BDP Servicos Valor],
[Adiantamento Valor],
[Total Faturamento Valor],
[Saldo Valor],
CN.Apelido [Consignee],
EX.Apelido [Exportador],
GN.Apelido [LLP Unit],
US.Nome_Usuario [CSR],
ORG.Nome_Local [Destination],
DST.Nome_Local [Origin],
'Export'[Import/Export]
from House_exp_mar HOU
join Job_exp_mar JB with(nolock) on HOU.Num_Proc_hem = JB.Num_Proc_hem
join Usuario US with(nolock) on JB.Cd_Usuario = US.Cd_Usuario
join Pessoa CN with(nolock) on HOU.Cd_Consig_hem=CN.Cd_Pes
join Pessoa EX with(nolock) on HOU.Cd_Export_hem=EX.Cd_Pes
left join Pessoa_LLP PA with(nolock) on HOU.Cd_Export_hem=PA.Cd_Pes
join Pessoa GN with(nolock) on PA.Cd_Pes_grupo = GN.Cd_pes
join Localidade ORG with(nolock) on HOU.Cd_Org_hem = ORG.Cd_Local
join Localidade DST with(nolock) on HOU.Cd_DST_hem = DST.Cd_Local
join @Tabela TB on left([Fatura BDP],len(TB.[Fatura BDP])-1) =HOU.Num_proc_hem
GO
