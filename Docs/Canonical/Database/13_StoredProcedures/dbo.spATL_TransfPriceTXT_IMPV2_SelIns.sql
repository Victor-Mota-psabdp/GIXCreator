SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_TransfPriceTXT_V2_SelIns'IMCSR201311445BR'
/*
select * from Nota_Cliente
where Emissao between '2014-01-01'  and '2014-12-31' and Num_Proc like 'IMCSR%'and left(replace(CFOP,'.',''),2) ='31' and Vlr_NF <>0
select 
Codigo_Empresa +
Codigo_Filial +
Codigo_Material +
	Data_Operação +
Tipo_Documento +
Numero_Documento +
Item +
Natureza_Operacao +
Natureza_Estoque +
Quantidade +
Indicador_Lancamento +
Unidade_Medida +
Codigo_PF_PJ +
Categoria_PF_PJ +
Valor_Custo_Total +
Valor_Custo_Aduaneiro_Outros +
Valor_Frete_Internacional +
Valo_Seguro_Internacional +
Valor_Imposto_Importacao +
Utilizacao_SAP +
Divisao +
Numero_DI  +
Moeda  from Transf_Price_TXT_IMP
where ID in (18,19)
sp_help Transf_Price_TXT_IMP
*/
--[spATL_TransfPriceTXT_IMP_SelIns] '330','P000002148','IMCSR201311445BR'

CREATE procedure [dbo].[spATL_TransfPriceTXT_IMPV2_SelIns] 

--@ID_NF varchar(50),
--@CD_Cliente varchar(50),
--@Num_proc varchar(16)

as





Declare @Temp Table(
ID bigint,
Num_Proc varchar(16),
Codigo_da_Empresa	Varchar(9),
Codigo_da_Filial	Varchar(9),
Codigo_do_Material	Varchar(18),
Data_da_Operaçao	Varchar(8),
Tipo_de_Documento	Varchar(3),
Numero_do_Documento	Varchar(15),
Item	Varchar(5),
Natureza_de_Operaçao	Varchar(6),
Natureza_do_Estoque	Varchar(5),
Quantidade	varchar(17),--Decimal(17,3)
Indicador_de_Lançamento	Varchar(3),
Unidade_de_Medida	Varchar(3),
Codigo_PF_PJ	Varchar(16),
Categoria_PF_PJ	varchar(2),
Valor_Custo_Total	varchar(17),--Decimal(17,2)
Valor_do_Custo_Aduaneiro_Outros	varchar(17),--Decimal(17,2)
Valor_do_Frete_Internacional	varchar(17),--Decimal(17,2)
Valor_do_Seguro_Iternacional	varchar(17),--Decimal(17,2)
Valor_do_Imposto_Importaçao	varchar(17),--Decimal(17,2)
Utilizaçao_SAP	Varchar(3),
Divisao	varchar(4),
Numero_da_DI	Varchar(12),
Moeda varchar(10)
)



				Declare @ProcessoTemp Table(
					Num_proc varchar(16),
					VlrFaturaReais  Decimal(17,2)
					)
					insert @ProcessoTemp
					Select CC.Num_Proc, isnull(sum(Vlr_Item_Custo),0) from Custo_Cliente CC  with(nolock)
					join vwPO_Imp PO with(nolock) on CC.Num_Proc = PO.Num_Proc
					Where year(PO.Data_DI) = '2014' and  SUBSTRING(CC.num_proc,3,3) in ('CSR','ROB') 
					and (cd_Tp_TX  in (select cd_Tp_Tx from tipo_Taxa  with(nolock) where nome_Tp_Tx like '%Siscomex%') 
					or cd_Tp_TX  in (select cd_Tp_Tx from tipo_Taxa  with(nolock) where nome_Tp_Tx like 'AFRMM%') 
					or cd_Tp_TX  in (select cd_Tp_Tx from tipo_Taxa  with(nolock) where nome_Tp_Tx like '%THC%') ) 	
					group by CC.Num_Proc
							
insert into @Temp
select 
distinct
NULL ID,
NC.Num_Proc,
Co_Code,
PD.Business_Place,
Rtrim(PC.cd_Proc_Cliente),
--replace(convert(varchar(10),dbo.fBusca_DATA_PO_Modal(@Num_Proc,5) ,103),'/','') ,
replace(convert(varchar(10),PO.Data_DI,103),'/','') ,
'NF',
NC.Nota_Fiscal,
'',--ND.ID_Item, --checar numeração
replace(NC.CFOP,'.',''),
'MP',
replace(cast(ND.Quantidade as decimal(17,3)),'.',','),
'D',
(case when PDet.UoM ='' then PDet.Peso_UOM when PDet.UoM is null then PDet.Peso_UOM else PDet.UoM end),
Tax_Number_1,
'FO',
replace(cast((ND.FOB - ND.Vlr_Frete)/PR.Campo_Dados as decimal(17,2)),'.',','),
replace(cast(((Vlr_Rel.VlrFaturaReais)*[dbo].[fBuscaPorcentagem_CdProduto](NC.Num_Proc,ND.cd_produto)* DBO.fBuscaPorcentagem_CdPedido_Transf(NC.Num_Proc,PDet.ITEM,ND.cd_pedido)*dbo.fBuscaPorcentagem_Pedido_Prod(NC.Num_Proc,ND.cd_pedido,ND.cd_produto))/PR.Campo_Dados as decimal(17,2)),'.',','),
--replace(cast(ND.Vlr_Total_NF - isnull(ND.FOB, ND.Vlr_Total_Item)-Vlr_Seguro-Vl_II as decimal(17,2)),'.',','),
replace(cast(ND.Vlr_Frete/PR.Campo_Dados as decimal(17,2)),'.',','),
replace(cast(ND.Vlr_Seguro/PR.Campo_Dados as decimal(17,2)),'.',','),
replace(cast(ND.Vl_II/PR.Campo_Dados as decimal(17,2)),'.',','),
'',
LLP.Cd_Tp_Oper,
dbo.[fBusca_Docs_PO_Modal](NC.num_proc,5),
'USD'  Moeda
 from Nota_Cliente NC with(nolock)
JOIN Nota_Fiscal_Cliente_Det ND with(nolock) on NC.ID_NF = ND.ID_NF and NC.CD_Cliente = ND.Cd_Cliente
INNER HASH JOIN Pedido P with(nolock) on ND.Cd_Pedido = P.Cd_pedido
INNER HASH JOIN Pedido_Det PDet with(nolock) on ND.Cd_Pedido = PDet.Cd_pedido and ND.Cd_Produto = PDet.Cd_Produto
JOIN Pessoa_LLP PL with(nolock) on Nc.CD_Cliente = PL.Cd_Pes 
INNER HASH JOIN Produto_Cliente PC with(nolock) on ND.Cd_Produto = PC.cd_prod and PL.Cd_Pes_Grupo = PC.cd_Cliente
INNER HASH JOIN Plantas_Dow PD with(nolock) on NC.CNPJ = PD.Tax_Number_1 --and P.Planta = PD.Plant
JOIN vwHouse_Imp LLP with(nolock) on NC.Num_Proc = LLP.Num_Proc
JOIN Campo_Processo PR with(nolock) on NC.Num_Proc = PR.Num_Proc and Id_Campo = '31'
join vwPO_Imp PO with(nolock) on NC.Num_Proc = PO.Num_Proc
left join @ProcessoTemp Vlr_Rel  on PO.Num_proc = Vlr_Rel.Num_proc
where 
	 year(PO.Data_DI) = '2014' and  SUBSTRING(NC.num_proc,3,3) in ('CSR','ROB') and Vlr_Rel.VlrFaturaReais <> 0




insert INTO Transf_Price_TXT_IMPV2
select 
row_number() over (order by Num_proc)ID,
Num_proc,
dbo.PreencheStringDireita(Codigo_da_Empresa,9,' '),
dbo.PreencheStringDireita(Codigo_da_Filial,9,' '),
dbo.PreencheStringV2(Codigo_do_Material,18,'0'),
dbo.PreencheStringDireita(Data_da_Operaçao,8,' '),
dbo.PreencheStringDireita(Tipo_de_Documento,3,' '),
dbo.PreencheStringDireita(Numero_do_Documento,15,' '),
dbo.PreencheStringDireita(row_number() over (PARTITION BY Numero_do_Documento order by Num_PRoc),5,' '),
dbo.PreencheStringDireita(Natureza_de_Operaçao,6,' '),
dbo.PreencheStringDireita(Natureza_do_Estoque,5,' '),
dbo.PreencheStringV2(Quantidade,17,'0'),
dbo.PreencheStringDireita(Indicador_de_Lançamento,1,' '),
dbo.PreencheStringDireita(Unidade_de_Medida,3,' '),
dbo.PreencheStringDireita(Codigo_PF_PJ,16,' '),
dbo.PreencheStringDireita(Categoria_PF_PJ,2,' '),
dbo.PreencheStringV2(Valor_Custo_Total,17,'0'),
dbo.PreencheStringV2(Valor_do_Custo_Aduaneiro_Outros,17,'0'),
dbo.PreencheStringV2(Valor_do_Frete_Internacional,17,'0'),
dbo.PreencheStringV2(Valor_do_Seguro_Iternacional,17,'0'),
dbo.PreencheStringV2(Valor_do_Imposto_Importaçao,17,'0'),
dbo.PreencheStringDireita(Utilizaçao_SAP,1,' '),
dbo.PreencheStringDireita(Divisao,4,' '),
dbo.PreencheStringDireita(Numero_da_DI,12,' '),
dbo.PreencheStringDireita(Moeda,10,' ')
from 
@Temp



--set @Codigo_da_Empresa = dbo.PreencheStringV2(@Codigo_da_Empresa,9,' ')
--set @Codigo_da_Filial = dbo.PreencheStringV2(@Codigo_da_Filial,9,' ')
--set @Codigo_do_Material = dbo.PreencheStringV2(@Codigo_do_Material,20,' ')
--set @Data_da_Operaçao = dbo.PreencheStringV2(@Data_da_Operaçao,8,' ')
--set @Tipo_de_Documento = dbo.PreencheStringV2(@Tipo_de_Documento,3,' ')
--set @Numero_do_Documento = dbo.PreencheStringV2(@Numero_do_Documento,15,' ')
--set @Item = dbo.PreencheStringV2(@Item,5,' ')
--set @Natureza_de_Operaçao = dbo.PreencheStringV2(@Natureza_de_Operaçao,6,' ')
--set @Natureza_do_Estoque = dbo.PreencheStringV2(@Natureza_do_Estoque,5,' ')
--set @Quantidade = dbo.PreencheStringV2(@Quantidade,17,' ')
--set @Indicador_de_Lançamento = dbo.PreencheStringV2(@Indicador_de_Lançamento,1,' ')
--set @Unidade_de_Medida = dbo.PreencheStringV2(@Unidade_de_Medida,3,' ')
--set @Codigo_PF_PJ = dbo.PreencheStringV2(@Codigo_PF_PJ,16,' ')
--set @Categoria_PF_PJ = dbo.PreencheStringV2(@Categoria_PF_PJ,2,' ')
--set @Valor_Custo_Total = dbo.PreencheStringV2(@Valor_Custo_Total,17,' ')
--set @Valor_do_Custo_Aduaneiro_Outros = dbo.PreencheStringV2(@Valor_do_Custo_Aduaneiro_Outros,17,' ')
--set @Valor_do_Frete_Internacional = dbo.PreencheStringV2(@Valor_do_Frete_Internacional,17,' ')
--set @Valor_do_Seguro_Iternacional = dbo.PreencheStringV2(@Valor_do_Seguro_Iternacional,17,' ')
--set @Valor_do_Imposto_Importaçao = dbo.PreencheStringV2(@Valor_do_Imposto_Importaçao,17,' ')
--set @Utilizaçao_SAP = dbo.PreencheStringV2(@Utilizaçao_SAP,1,' ')
--set @Divisao = dbo.PreencheStringV2(@Divisao,4,' ')
--set @Numero_da_DI = dbo.PreencheStringV2(@Numero_da_DI,12,' ')

--insert INTO Tranf_Pricing_TXT
--select
--@ID,
--@Num_Proc,
--@Codigo_da_Empresa [Código da Empresa],
--@Codigo_da_Filial [Código da Filial],
--@Codigo_do_Material [Código do Material],
--@Data_da_Operaçao [Data da Operação],
--@Tipo_de_Documento [Tipo de Documento],
--@Numero_do_Documento [Número do Documento],
--@Item [Item],
--@Natureza_de_Operaçao [Natureza de Operação],
--@Natureza_do_Estoque [Natureza do Estoque],
--@Quantidade [Quantidade],
--@Indicador_de_Lançamento [Indicador de Lançamento],
--@Unidade_de_Medida [Unidade de Medida],
--@Codigo_PF_PJ [Código PF/PJ],
--@Categoria_PF_PJ [Categoria PF/PJ],
--@Valor_Custo_Total [Valor Custo  Total],
--@Valor_do_Custo_Aduaneiro_Outros [Valor do Custo Aduaneiro (Outros)],
--@Valor_do_Frete_Internacional [Valor do Frete Internacional],
--@Valor_do_Seguro_Iternacional [Valor do Seguro Iternacional],
--@Valor_do_Imposto_Importaçao [Valor do Imposto Importação],
--@Utilizaçao_SAP [Utilização (SAP)],
--@Divisao [Divisão],
--@Numero_da_DI [Numero da DI]


GO
