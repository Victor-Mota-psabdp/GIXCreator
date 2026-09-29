SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spFaturaArgAjusteRotina_Sel]

as
SET NOCOUNT ON;


Declare @TabelaTemp as Table
(
	Nota_Fiscal varchar(8),
	Emissao datetime,
	Ref_Acesso char(1),
	Apelido varchar(50),
	Condicoes varchar(30),
	Observ_NF varchar(1000),
	paridade float , 
	Valor_Total decimal(18,2),
	Valor_ISS decimal (18,2),
	Moeda varchar(50),
	[Status] int,
	Aliq_ISS decimal (18,2),
	
	cd_servico int, 
	descricao [varchar](500),	
	Item_lei varchar(50),
	CNAE	varchar(25),
	IRRF_Tx char(1)
)

SET NOCOUNT ON;

--insert into @TabelaTemp


select  distinct  
	BNF.nota_Fiscal ,BNF.Emissao,BNF.Ref_Acesso,PS.Apelido,BNF.Condicoes,BNF.Observ_NF,max(CC.Par_NF_HIA) paridade, 
	BNF.Valor_Total,BNF.Valor_ISS,NULL Moeda, '0' [Status],BNF.Aliq_ISS,
	BNF.cd_servico,BNF.Item_lei,BNF.CNAE,BNF.Descricao,BNF.IRRF_Tx
from
	base_nota_fiscal BNF with(nolock) 
	left outer join Pessoa PS with(nolock) on BNF.cd_pes = PS.cd_pes
	left join Fatura_ARG FA with(nolock) on FA.numero = BNF.nota_fiscal and FA.codigo = BNF.ref_acesso-- and FA.cd_pes=BNF.cd_pes 
	join vwcta_cte CC  with(nolock) on BNF.Nota_Fiscal= CC.Num_NF_HIA and BNF.Ref_Acesso = CC.Ref_Acesso_NF_HIA
	--join Tipo_Moeda TM with(nolock) on CC.Cd_Tp_Moeda = TM.Cd_Tp_Moeda
where
	Emissao >= '2013-01-01'  and FA.Numero is null

group by BNF.nota_Fiscal ,BNF.Emissao,BNF.Ref_Acesso,PS.Apelido,BNF.Condicoes,BNF.Observ_NF,paridade,
 BNF.Valor_Total,BNF.Valor_ISS,BNF.Aliq_ISS,BNF.cd_servico,BNF.Item_lei,BNF.CNAE,BNF.Descricao,BNF.IRRF_Tx
/*
	select 
	convert(datetime,Emissao,105),FA.Numero Num_FAT, BNF.nota_Fiscal Num_Base, PS.apelido,Nome_Raz_Soc Razao_Social,ED.Rua +', '+ ED.Numero Endereco, ED.Cidade, ED.UF,ED.Pais , Emissao, cd_status,Valor_total, Observ_nf, BNF.Aliq_ISS, Valor_ISS , FA.paridade, FA.condicao_venda, M.nome_tp_Moeda, Habilita_Impostos, US.Nome_usuario
from
	base_nota_fiscal BNF
	left outer join Pessoa PS with(nolock) on BNF.cd_pes = PS.cd_pes
	left outer join Endereco ED with(nolock)	on BNF.cd_Pes = ED.cd_pes
	left join Fatura_ARG FA with(nolock) on FA.numero = BNF.nota_fiscal and FA.codigo = BNF.ref_acesso and FA.cd_pes=BNF.cd_pes 
	left outer join tipo_moeda M with(nolock) on M.cd_tp_moeda = FA.cd_tp_moeda
	join usuario US on US.cd_Usuario = BNF.cd_Usuario
where
	convert(datetime,Emissao,105) between '2013-10-01' and convert(datetime,convert(varchar,getdate(),103),105)  and FA.Numero is null
	*/
GO
