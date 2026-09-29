SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[spRelacaoProcessoFechados_Vivian_Sel] '','2014-07-01','2014-07-15'
CREATE Procedure [dbo].[spRelacaoProcessoFechados_Vivian_Sel]

		@Grupo			Varchar(400),
		@DataInicial	Datetime,
		@DataFinal		Datetime

AS

declare @cd_pes_grupo varchar(20)

	If @Grupo is null or @Grupo = ''
		begin
		Set @cd_pes_grupo ='%'
		end
	else
		begin
			set @cd_pes_grupo = (select top 1 cd_pes from pessoa where apelido=@Grupo)
		end
Declare @Tabela Table (	
	[CNPJ] varchar(16),
	[JOB] Varchar(16),
	[N.Ref] Varchar(100),
	[Customer PO] Varchar(100),
	[TOTAL Value] float,
	[Nota Fiscal] int,
	[IRRF 1.5% Value] float,
	[PIS 0.65% Value] float,
	[Cofins 3% Value] float,
	[CSLL 1% Value] float,
	[TOTAL LEI 10833/03 4.65% Value] float
	)

insert @Tabela
select 
	num_cpf_CNPJ CNPJ,
	num_proc_hia[Job],
	dbo.fBusca_TipoDocCliente('N',num_proc_hia,1)[N.Ref],
	dbo.fBusca_TipoDocCliente('N',num_proc_hia,9)[Customer PO], 
	sum(dbo.valor(vlr_pgto_nf_hia,dc_hia)) [TOTAL Value],
	Nota_Fiscal, 
	cast(sum(dbo.valor(vlr_pgto_nf_hia,dc_hia))*(1.5/100) as decimal(10,2)) [IRRF 1.5% Value],
	cast(sum(dbo.valor(vlr_pgto_nf_hia,dc_hia))*(0.65/100) as decimal(10,2)) [PIS 0.65% Value], 
	cast(sum(dbo.valor(vlr_pgto_nf_hia,dc_hia))*(3.00/100) as decimal(10,2)) [Cofins 3% Value],
	cast(sum(dbo.valor(vlr_pgto_nf_hia,dc_hia))*(1.00/100) as decimal(10,2)) [CSLL 1% Value],
	cast(sum(dbo.valor(vlr_pgto_nf_hia,dc_hia))*(4.65/100) as decimal(10,2)) [TOTAL LEI 10833/03 4.65% Value]	
from vwcta_Cte CTA
Join Base_Nota_Fiscal NF on num_nf_hia=nota_fiscal and ref_Acesso=ref_Acesso_nf_hia
Join Pessoa PP on PP.cd_pes=nf.cd_pes
Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=nf.cd_pes and PLL.Cd_Pes_Grupo like @cd_pes_grupo
where
	emissao between @DataInicial and @DataFinal
	--AND substring(num_proc_hia,3,3) = (select grupo from grupo where cd_pes_grupo = @cd_pes_grupo)
Group by Num_Proc_Hia,num_cpf_Cnpj,Nota_Fiscal


select 
	[CNPJ],
	[JOB],
	[N.Ref],
	[Customer PO],
	[TOTAL Value],
	[Nota Fiscal],
	[IRRF 1.5% Value],
	[PIS 0.65% Value],
	[Cofins 3% Value],
	[CSLL 1% Value],
	[TOTAL LEI 10833/03 4.65% Value],
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
join @Tabela TB on TB.JOB =HOU.Num_proc_Him

union all

select 
	[CNPJ],
	[JOB],
	[N.Ref],
	[Customer PO],	
	[TOTAL Value],
	[Nota Fiscal],
	[IRRF 1.5% Value],
	[PIS 0.65% Value],
	[Cofins 3% Value],
	[CSLL 1% Value],
	[TOTAL LEI 10833/03 4.65% Value],
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
join @Tabela TB on TB.JOB =HOU.Num_proc_hia

Union ALL

select 
	[CNPJ],
	[JOB],
	[N.Ref],
	[Customer PO],	
	[TOTAL Value],
	[Nota Fiscal],
	[IRRF 1.5% Value],
	[PIS 0.65% Value],
	[Cofins 3% Value],
	[CSLL 1% Value],
	[TOTAL LEI 10833/03 4.65% Value],
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
join @Tabela TB on TB.JOB =HOU.Num_proc_Hio

Union ALL

select 
	[CNPJ],
	[JOB],
	[N.Ref],
	[Customer PO],
	[TOTAL Value],
	[Nota Fiscal],
	[IRRF 1.5% Value],
	[PIS 0.65% Value],
	[Cofins 3% Value],
	[CSLL 1% Value],
	[TOTAL LEI 10833/03 4.65% Value],
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
join @Tabela TB on TB.JOB=HOU.Num_proc_hea

union all


select 
	[CNPJ],
	[JOB],
	[N.Ref],
	[Customer PO],
	[TOTAL Value],
	[Nota Fiscal],
	[IRRF 1.5% Value],
	[PIS 0.65% Value],
	[Cofins 3% Value],
	[CSLL 1% Value],
	[TOTAL LEI 10833/03 4.65% Value],
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
join @Tabela TB on TB.JOB =HOU.Num_proc_heo

union all

select 
	[CNPJ],
	[JOB],
	[N.Ref],
	[Customer PO],
	[TOTAL Value],
	[Nota Fiscal],
	[IRRF 1.5% Value],
	[PIS 0.65% Value],
	[Cofins 3% Value],
	[CSLL 1% Value],
	[TOTAL LEI 10833/03 4.65% Value],
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
join @Tabela TB on TB.JOB =HOU.Num_proc_hem

GO
