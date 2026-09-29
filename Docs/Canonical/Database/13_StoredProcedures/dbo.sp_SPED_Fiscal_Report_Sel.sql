SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[sp_SPED_Fiscal_Report_Sel] 
	@Grupo			VARCHAR(50) , 
	@DataInicial	DATETIME,
	@DataFinal		DATETIME
AS
/* -------------------------------------------------------------------------------------------------------------------------
HISTORY CHANGE
. Date: 17/06/2021
. Applicant: 
. Developer: Alessandra Suzuki Mariano / Beatriz Barbosa
. Request:100-275340	
-------------------------------------------------------------------------------------------------------------------------
EXECUTION EXECUTION
EXEC sp_SPED_Fiscal_Report_Sel 'GRUPO NUTRITION&BIOS','2021-03-01','2021-03-31'
EXEC sp_SPED_Fiscal_Report_Sel 'GRUPO DOW','2019-01-01','2019-06-30'
-------------------------------------------------------------------------------------------------------------------------
*/


/*
-- Filtros variaveis
-- Processo do Grupo Dow
-- Task "Averbação" id_task 15 com o filtro dentro da data inicial / final informada pelo cliente
-- Data inicial
-- Data final
*/

DECLARE @Output TABLE
	(
	[NF Number]										VARCHAR(80) ,
	[CNPJ]											VARCHAR(20) ,
	[Shipper]										VARCHAR(60) ,
	[NRO_RE]										VARCHAR(400) ,
	[Data da declaração]							DATETIME ,
	[DUE Access Key Number]							VARCHAR(400) ,
	[RUC Number]									VARCHAR(400) ,
	[Data do conhecimento de embarque]				DATETIME ,
	[Data da averbacao da Declaracao de exportacao] DATETIME ,
	[NAT_EXP]										CHAR(1) ,
	[Numero do conhecimento de embarque]			VARCHAR(400) ,
	[Tipo de conhecimento de embarque]				CHAR(2) ,
	[PAIS]											VARCHAR(3) ,
	[Chave da Nota Fiscal Eletronica]				INT ,
	[IND_DOC]										CHAR(1) ,
	[Número da declaração]							VARCHAR(400) ,
	[Modal]											VARCHAR(12) ,
	[BDP Reference]									VARCHAR(16) ,
	[Data Prevista Atracação]						DATETIME ,
	[Desembaraço da DUE]							DATETIME
	)

	INSERT INTO @Output
	SELECT   
	VPO.Numero_PO													AS	[NF Number]
	,CASE LEN (PES.Num_CPF_CNPJ) WHEN 15 THEN 
	SUBSTRING(PES.Num_CPF_CNPJ,2,2) + '.' 
	+ SUBSTRING(PES.Num_CPF_CNPJ,4,3) + '.' 
	+ SUBSTRING(PES.Num_CPF_CNPJ,7,3) + '/' 
	+ SUBSTRING(PES.Num_CPF_CNPJ,10,4) + '-' 
	+ SUBSTRING(PES.Num_CPF_CNPJ,14,2)
	WHEN 14 THEN 
	SUBSTRING(PES.Num_CPF_CNPJ,1,2) + '.' 
	+ SUBSTRING(PES.Num_CPF_CNPJ,3,3) + '.' 
	+ SUBSTRING(PES.Num_CPF_CNPJ,6,3) + '/' 
	+ SUBSTRING(PES.Num_CPF_CNPJ,9,4) + '-' 
	+ SUBSTRING(PES.Num_CPF_CNPJ,13,2)
	ELSE PES.Num_CPF_CNPJ
	END																AS	[CNPJ]
	,PES.Nome_Raz_Soc												AS	[Shipper]
	,DBO.fBusca_Docs_PO_Modal(HOU.NUM_PROC,'204')					AS	[NRO_RE]
	,DBO.fBusca_DATA_PO_Modal(HOU.NUM_PROC,'204')					AS	[Data da declaração]
	,DBO.fBusca_Docs_PO_Modal(HOU.NUM_PROC,'209')					AS	[DUE Access Key Number]
	,DBO.fBusca_Docs_PO_Modal(HOU.NUM_PROC,'205')					AS	[RUC Number]
	,HOU.ATD														AS	[Data do conhecimento de embarque]
	,TP15.DT_CONCLUSAO												AS	[Data da averbacao da Declaracao de exportacao]
	,'0'															AS	[NAT_EXP]
	,HOU.HAWB														AS	[Numero do conhecimento de embarque]
	,CASE SUBSTRING(HOU.NUM_PROC,1,2)   
     WHEN 'EM' THEN '10'
	 WHEN 'EA' THEN '3'
	 WHEN 'EO' THEN '13'
     ELSE NULL 
	END																AS	[Tipo de conhecimento de embarque]
	,SUBSTRING(DP.Cd_Dst,1,3)										AS	[PAIS]	
	,NULL															AS	[Chave da Nota Fiscal Eletronica]
	,'2'															AS  [IND_DOC]
	,DBO.fBusca_Docs_PO_Modal(HOU.NUM_PROC,'204')					AS	[Número da declaração]
	,HOU.MODAL														AS	[Modal]
	,HOU.NUM_PROC													AS	[BDP Reference]
	,HOU.ETD														AS  [Data Prevista Atracação]
	,TP04.DT_CONCLUSAO												AS	[Desembaraço da DUE]
	FROM vwHouse_exp HOU (NOLOCK)	-- Processos de Exportação
	INNER JOIN localidade LOCDEST (NOLOCK)		
		ON HOU.Cd_DstFinal = LOCDEST.Cd_Local 
	LEFT JOIN DE_PARA DP (NOLOCK) 
		ON LOCDEST.pais_local = DP.Cd_Org
		AND DP.Cd_Tipo = 21
	LEFT JOIN Tarefas_processos TP15 (NOLOCK)
		ON HOU.Num_Proc = TP15.NUM_PROC
		AND TP15.ID_TASK = 15 
	LEFT JOIN Tarefas_processos TP04 (NOLOCK)
		ON HOU.Num_Proc = TP04.NUM_PROC
		AND TP04.ID_TASK = 4
	INNER JOIN PESSOA PES (NOLOCK)
		ON HOU.CD_EXPORT = PES.CD_PES 
	LEFT JOIN VWPO VPO (NOLOCK)
		ON HOU.NUM_PROC =  VPO.NUM_PROC
		AND VPO.ID_DC = 10
	LEFT JOIN VWPO_ALL VPO2 (NOLOCK)
		ON HOU.NUM_PROC =  VPO2.NUM_PROC
		AND VPO2.ID_DC = 204
	-- JOINS PARA PUXAR QUAL GRUPO PERTENCE O PROCESSO
	INNER JOIN Pessoa_LLP LLP (NOLOCK)  
		ON LLP.Cd_Pes = HOU.Cd_Export  
	INNER JOIN Pessoa GRUPO (NOLOCK)  
		ON GRUPO.CD_PES = LLP.Cd_Pes_Grupo  

	WHERE GRUPO.APELIDO =  @Grupo
	AND VPO2.Data_PO between @DataInicial and @DataFinal 
	 --HOU.Num_Proc IN ( 'EMCSR202102065BR','EACSR202103001BR','EOCSR202103028BR','EMCSR202101101BR')

	
	SELECT * FROM @Output


	--select * from localidade where cd_local = 'VRX'
	--SELECT * FROM Pais_Itau where nome_pais = 'Mexico'
	--LEFT(PAI.Cd_Pais_Itau,3)	AS	[PAIS]	


GO
