SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--11-04-2026 - antonio -  incluir  a paginação para segregar a procura por itens 
-- procurar depois somente o que tem que incluir sem varrer os todo os jobs 
--A todos 
-- C por ID 
-- [dbo].[spATL_JSON_FComex_Capa_Valores_Line_Sel] 43192,'C'
-- verificando se a quantidade de itens ja esta gravada na tabela 
--06-04-2026 - incluir os campos de paginação 
-- E - Comparar se todos os itens ja subiram para a tabela de integração usando a empresa e 
-- a quantidade de itens lidos < processados 
-- [spATL_JSON_FComex_Capa_Valores_Line_Sel] 0,1,'E'

CREATE procedure [dbo].[spATL_JSON_FComex_Capa_Valores_Line_Sel]

    @Id_Processo [bigint],
	@Id_Empresa [bigint],
	@Tipo varchar(1)

/*
-- A - Todos 
-- C - Unico registro 
-- E - lidos < processados 
*/
AS

if @Tipo='A'
			Begin
                Select 
				        [Id_Processo],
						[Fob_Usd],
						[Cif_Usd],
						[Frete_Usd],
						[Fob_Reais],
						[Acrescimos_Reais],
						[Seguro_Reais],
						[Frete_Reais],
						[Moeda_Frete],
						[Moeda_CFR],
						[Cif_Reais],
						[ItemsTotalPages], 
						[ItemsTotalQty],
						[ItemsTotalIncluded]
				from 	ATL_INT.dbo.JSON_FComex_Capa_Valores_Line
				order by Id_Processo 	
			End
if @Tipo ='C'
			Begin
                Select 
				        [Id_Processo],
						[Fob_Usd],
						[Cif_Usd],
						[Frete_Usd],
						[Fob_Reais],
						[Acrescimos_Reais],
						[Seguro_Reais],
						[Frete_Reais],
						Case when J.[Moeda_Frete] = '0' then NULL else J.[Moeda_Frete] End	[Moeda_Frete],
						Case when J.[Moeda_CFR] = '0' then NULL else J.[Moeda_CFR] End	[Moeda_CFR],
						[Cif_Reais],
						[ItemsTotalPages], 
						[ItemsTotalQty],
						[ItemsTotalIncluded]
				from 	ATL_INT.dbo.JSON_FComex_Capa_Valores_Line J
				Where
						Id_Processo = @Id_Processo 
				and  CAST([ItemsTotalIncluded] as INT) = cast([ItemsTotalQty] as INT) 
			end 

if @Tipo ='E'
			Begin
                Select 
				        j.[Id_Processo],
						[Fob_Usd],
						[Cif_Usd],
						[Frete_Usd],
						[Fob_Reais],
						[Acrescimos_Reais],
						[Seguro_Reais],
						[Frete_Reais],
						Case when c.[Moeda_Frete] = '0' then NULL else c.[Moeda_Frete] End	[Moeda_Frete],
						Case when c.[Moeda_CFR] = '0' then NULL else c.[Moeda_CFR] End	[Moeda_CFR],
						c.[Cif_Reais],
						c.[ItemsTotalPages], 
						c.[ItemsTotalQty],
						c.[ItemsTotalIncluded]
				from 	ATL_INT.dbo.JSON_FComex_Capa_Valores_Line  C
				join    atl_int.dbo.JSON_FComex_JobReferences_Line j 
				on     c.Id_Processo = j.Id_Processo
				and    j.Id_Empresa =  @Id_Empresa
                where CAST(c.[ItemsTotalIncluded] as INT) < cast(c.[ItemsTotalQty] as INT)   
			 end 

GO
