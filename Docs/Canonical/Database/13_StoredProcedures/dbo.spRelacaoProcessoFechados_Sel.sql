SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spRelacaoProcessoFechados_Sel] --'GRUPO SUN CHEMICAL','2011-01-01','2011-09-30',''

		@Grupo			Varchar(400),
		@DataInicial	Datetime,
		@DataFinal		Datetime

AS

declare @cd_pes_grupo varchar(20)
set @cd_pes_grupo = (select cd_pes from pessoa where apelido=@Grupo)

select 
	num_cpf_CNPJ CNPJ,num_proc_hia[Job],dbo.fBusca_TipoDocCliente('N',num_proc_hia,1)[N.Ref],dbo.fBusca_TipoDocCliente('N',num_proc_hia,9)[Customer PO], 
	sum(dbo.valor(vlr_pgto_nf_hia,dc_hia)) [TOTAL Value],Nota_Fiscal, cast(sum(dbo.valor(vlr_pgto_nf_hia,dc_hia))*(1.5/100) as decimal(10,2)) [IRRF 1.5% Value],
	cast(sum(dbo.valor(vlr_pgto_nf_hia,dc_hia))*(0.65/100) as decimal(10,2)) [PIS 0.65% Value], cast(sum(dbo.valor(vlr_pgto_nf_hia,dc_hia))*(3.00/100) as decimal(10,2)) [Cofins 3% Value],
	cast(sum(dbo.valor(vlr_pgto_nf_hia,dc_hia))*(1.00/100) as decimal(10,2)) [CSLL 1% Value],cast(sum(dbo.valor(vlr_pgto_nf_hia,dc_hia))*(4.65/100) as decimal(10,2)) [TOTAL LEI 10833/03 4.65% Value]	
from vwcta_Cte CTA
Join Base_Nota_Fiscal NF on num_nf_hia=nota_fiscal and ref_Acesso=ref_Acesso_nf_hia
Join Pessoa PP on PP.cd_pes=nf.cd_pes
where
	emissao between @DataInicial and @DataFinal
	AND substring(num_proc_hia,3,3) = (select grupo from grupo where cd_pes_grupo = @cd_pes_grupo)
Group by Num_Proc_Hia,num_cpf_Cnpj,Nota_Fiscal

 
GO
