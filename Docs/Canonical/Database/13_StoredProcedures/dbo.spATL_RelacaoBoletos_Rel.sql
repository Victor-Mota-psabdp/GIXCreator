SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure spATL_RelacaoBoletos_Rel
	@DataInicial Datetime,
	@DataFinal	Datetime
	AS

/*-------------------------------------------------------------------------------------------------------------------------
HISTORICO ALTERAÇÃO
. Data:	27/06/2019
. Solicitante: Financeiro
. Desenvolvedor: Alessandra Suzuki Mariano
. Solicitação: Solicitada alteração no Ticket 100-149046 conforme
	. Incluir coluna "Cliente" no relatorio "Relação de Boletos"
	. Incluir coluna "Job" no relatorio "Relação de Boletos" 

-------------------------------------------------------------------------------------------------------------------------
EXEMPLO EXECUÇÃO
	exec spATL_RelacaoBoletos_Rel '2019-01-01','2019-06-27'
-------------------------------------------------------------------------------------------------------------------------
*/

SELECT 
	p.Apelido		[Cliente],
	I.num_proc		[JOB],	
	B.Cd_Boleto		[Numero],
	B.FatCod		[Fatura],
	B.Dt_Boleto		[Data Boleto],
	B.Valor			[Valor]
FROM boleto B
INNER JOIN fatura F 
	on B.fatcod = F.fatcod
INNER JOIN item_fat I 
	on I.fatcod = F.fatcod
INNER JOIN pessoa P 
	on P.cd_pes = F.cd_pes
WHERE B.dt_boleto  between @DataInicial	and @DataFinal

UNION

SELECT distinct 
	p.Apelido		[Cliente],  
	I.num_proc		[JOB],   
	B.Cd_Boleto		[Numero],  
	B.FatCod		[Fatura],  
	B.Dt_Boleto		[Data Boleto],  
	B.Valor			[Valor]
FROM boleto B  
INNER JOIN NF_Fatura F   
	on B.fatcod = F.Numero_Fat  
INNER JOIN NF_Fatura_Item I
	on  I.ID = F.ID	
INNER JOIN pessoa P   
	on P.cd_pes = F.cd_pes  
WHERE B.dt_boleto  between @DataInicial	and @DataFinal

GO
