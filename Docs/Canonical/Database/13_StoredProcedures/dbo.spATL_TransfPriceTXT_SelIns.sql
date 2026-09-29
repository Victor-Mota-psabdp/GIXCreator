SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_TranfPricingTXT_SelIns'IMCSR201504456BR'


CREATE procedure [dbo].[spATL_TransfPriceTXT_SelIns]
(
@Num_Proc varchar(16)
)
as

Declare @Codigo_da_Empresa Varchar(9)
Declare @Codigo_da_Filial Varchar(9)
Declare @Codigo_do_Material Varchar(20)
Declare @Data_da_Operaçao Varchar(8)
Declare @Tipo_de_Documento Varchar(3)
Declare @Numero_do_Documento Varchar(15)
Declare @Item Varchar(5)
Declare @Natureza_de_Operaçao Varchar(6)
Declare @Natureza_do_Estoque Varchar(5)
Declare @Quantidade varchar(17)--Decimal(17,3)
Declare @Indicador_de_Lançamento Varchar(3)
Declare @Unidade_de_Medida Varchar(3)
Declare @Codigo_PF_PJ Varchar(16)
Declare @Categoria_PF_PJ varchar(2)
Declare @Valor_Custo_Total varchar(17)--Decimal(17,2)
Declare @Valor_do_Custo_Aduaneiro_Outros varchar(17)--Decimal(17,2)
Declare @Valor_do_Frete_Internacional varchar(17)--Decimal(17,2)
Declare @Valor_do_Seguro_Iternacional varchar(17)--Decimal(17,2)
Declare @Valor_do_Imposto_Importaçao varchar(17)--Decimal(17,2)
Declare @Utilizaçao_SAP Varchar(3)
Declare @Divisao varchar(4)
Declare @Numero_da_DI Varchar(12)

Declare @ID bigint

set @ID = (Select ISNULL(max(ID),0)+1  from Tranf_Pricing_TXT)

select 

@Codigo_da_Empresa = PD.Business_Place,
@Codigo_da_Filial=PD.Plant,
@Codigo_do_Material=PC.cd_Proc_Cliente,
--@Data_da_Operaçao=NC.Emissao,
@Data_da_Operaçao = replace(convert(varchar(10),NC.Emissao,103),'/',''),
@Tipo_de_Documento='NF',
@Numero_do_Documento=NC.Nota_Fiscal,
 --ND.ID_NF,
@Item=ND.ID_Item, --checar numeração
@Natureza_de_Operaçao=replace(NC.CFOP,'.',''),
@Natureza_do_Estoque='MP',
@Quantidade= replace(cast(ND.Quantidade as decimal(17,3)),'.',','),
@Indicador_de_Lançamento='D',
@Unidade_de_Medida=(case when PDet.UoM ='' then PDet.Peso_UOM when PDet.UoM is null then PDet.Peso_UOM else PDet.UoM end),
@Codigo_PF_PJ=Tax_Number_1,
@Categoria_PF_PJ='FO',
--@Valor_Custo_Total=ND.FOB,
@Valor_Custo_Total=replace(cast(ND.FOB as decimal(17,2)),'.',','),
 --ND.Vlr_Total_NF,
--@Valor_do_Custo_Aduaneiro_Outros=ND.Vlr_Total_NF - isnull(ND.FOB, ND.Vlr_Total_Item)-Vlr_Seguro-Vl_II,
@Valor_do_Custo_Aduaneiro_Outros = replace(cast(ND.Vlr_Total_NF - isnull(ND.FOB, ND.Vlr_Total_Item)-Vlr_Seguro-Vl_II as decimal(17,2)),'.',','),
 --isnull(ND.FOB, ND.Vlr_Total_Item)
--@Valor_do_Frete_Internacional=ND.Vlr_Frete,
@Valor_do_Frete_Internacional=replace(cast(ND.Vlr_Frete as decimal(17,2)),'.',','),
--@Valor_do_Seguro_Iternacional=ND.Vlr_Seguro,
@Valor_do_Seguro_Iternacional=replace(cast(ND.Vlr_Seguro as decimal(17,2)),'.',','),
--@Valor_do_Imposto_Importaçao=ND.Vl_II,
@Valor_do_Imposto_Importaçao=replace(cast(ND.Vl_II as decimal(17,2)),'.',','),
@Utilizaçao_SAP = '',
@Divisao ='',
@Numero_da_DI= dbo.[fBusca_Docs_PO_Modal](NC.num_proc,5)
 from Nota_Cliente NC
join Nota_Fiscal_Cliente_Det ND with(nolock) on NC.ID_NF = ND.ID_NF and NC.CD_Cliente = ND.Cd_Cliente
join Pedido P with(nolock) on ND.Cd_Pedido = P.Cd_pedido
join Pedido_Det PDet with(nolock) on ND.Cd_Pedido = PDet.Cd_pedido and ND.Cd_Produto = PDet.Cd_Produto
join Pessoa_LLP PL with(nolock) on Nc.CD_Cliente = PL.Cd_Pes 
join Produto_Cliente PC with(nolock) on ND.Cd_Produto = PC.cd_prod and PL.Cd_Pes_Grupo = PC.cd_Cliente
--join Pedido P on ND.Cd_Pedido = P.Cd_pedido
--join vwALL_JOBs JO on NC.Num_Proc = JO.Num_proc
join Plantas_Dow PD with(nolock) on NC.CNPJ = PD.Tax_Number_1 and P.Planta = PD.Plant
where 
	--NC.ID_NF = '35549' and NC.Num_Proc = 'IMCSR201503012BR' and 
	Emissao >= '2014-01-01' and left(replace(CFOP,'.',''),2) ='31' and SUBSTRING(NC.num_proc,3,3) in ('CSR') and  NC.Vlr_NF <>0
order by  Emissao desc,NC.Num_proc, ID_Item



set @Codigo_da_Empresa = dbo.PreencheStringV2(@Codigo_da_Empresa,9,' ')
set @Codigo_da_Filial = dbo.PreencheStringV2(@Codigo_da_Filial,9,' ')
set @Codigo_do_Material = dbo.PreencheStringV2(@Codigo_do_Material,20,' ')
set @Data_da_Operaçao = dbo.PreencheStringV2(@Data_da_Operaçao,8,' ')
set @Tipo_de_Documento = dbo.PreencheStringV2(@Tipo_de_Documento,3,' ')
set @Numero_do_Documento = dbo.PreencheStringV2(@Numero_do_Documento,15,' ')
set @Item = dbo.PreencheStringV2(@Item,5,' ')
set @Natureza_de_Operaçao = dbo.PreencheStringV2(@Natureza_de_Operaçao,6,' ')
set @Natureza_do_Estoque = dbo.PreencheStringV2(@Natureza_do_Estoque,5,' ')
set @Quantidade = dbo.PreencheStringV2(@Quantidade,17,' ')
set @Indicador_de_Lançamento = dbo.PreencheStringV2(@Indicador_de_Lançamento,1,' ')
set @Unidade_de_Medida = dbo.PreencheStringV2(@Unidade_de_Medida,3,' ')
set @Codigo_PF_PJ = dbo.PreencheStringV2(@Codigo_PF_PJ,16,' ')
set @Categoria_PF_PJ = dbo.PreencheStringV2(@Categoria_PF_PJ,2,' ')
set @Valor_Custo_Total = dbo.PreencheStringV2(@Valor_Custo_Total,17,' ')
set @Valor_do_Custo_Aduaneiro_Outros = dbo.PreencheStringV2(@Valor_do_Custo_Aduaneiro_Outros,17,' ')
set @Valor_do_Frete_Internacional = dbo.PreencheStringV2(@Valor_do_Frete_Internacional,17,' ')
set @Valor_do_Seguro_Iternacional = dbo.PreencheStringV2(@Valor_do_Seguro_Iternacional,17,' ')
set @Valor_do_Imposto_Importaçao = dbo.PreencheStringV2(@Valor_do_Imposto_Importaçao,17,' ')
set @Utilizaçao_SAP = dbo.PreencheStringV2(@Utilizaçao_SAP,1,' ')
set @Divisao = dbo.PreencheStringV2(@Divisao,4,' ')
set @Numero_da_DI = dbo.PreencheStringV2(@Numero_da_DI,12,' ')

insert INTO Tranf_Pricing_TXT
select
@ID,
@Num_Proc,
@Codigo_da_Empresa [Código da Empresa],
@Codigo_da_Filial [Código da Filial],
@Codigo_do_Material [Código do Material],
@Data_da_Operaçao [Data da Operação],
@Tipo_de_Documento [Tipo de Documento],
@Numero_do_Documento [Número do Documento],
@Item [Item],
@Natureza_de_Operaçao [Natureza de Operação],
@Natureza_do_Estoque [Natureza do Estoque],
@Quantidade [Quantidade],
@Indicador_de_Lançamento [Indicador de Lançamento],
@Unidade_de_Medida [Unidade de Medida],
@Codigo_PF_PJ [Código PF/PJ],
@Categoria_PF_PJ [Categoria PF/PJ],
@Valor_Custo_Total [Valor Custo  Total],
@Valor_do_Custo_Aduaneiro_Outros [Valor do Custo Aduaneiro (Outros)],
@Valor_do_Frete_Internacional [Valor do Frete Internacional],
@Valor_do_Seguro_Iternacional [Valor do Seguro Iternacional],
@Valor_do_Imposto_Importaçao [Valor do Imposto Importação],
@Utilizaçao_SAP [Utilização (SAP)],
@Divisao [Divisão],
@Numero_da_DI [Numero da DI]


GO
