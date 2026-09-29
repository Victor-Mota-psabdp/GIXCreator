SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
[spPrestCC_Consolidado_REL] 'GRUPO SHERWIN','2020-08-07','2020-08-07'
GO
[spPrestCC_Consolidado_REL] 'GRUPO ATANOR','2020-08-01','2020-08-07'
GO
[spPrestCC_Consolidado_REL] 'GRUPO ALL','2020-08-01','2020-08-07'
go
[spPrestCC_Consolidado_REL] 'GRUPO blue cube','2020-08-12','2020-08-12'
*/

--[spPrestCC_Consolidado_REL] 'GRUPO SHERWIN','2020-08-07','2020-08-07'

CREATE Procedure [dbo].[spPrestCC_Consolidado_REL] 
	 @Grupo varchar(50),  
	 @DtInicial datetime,  
	 @DtFinal datetime  
AS

SET NOCOUNT ON

declare @total_adiantamento float
declare @total_Despesas float
declare @saldo float


DECLARE @PrestCC_Detalhe TABLE 
(
	[Data encerramento] [datetime],
	[JOB] [varchar](16) ,
	[PO] [varchar](400) ,
	[CNPJ] [varchar](14) ,
	[Favorecido] [varchar](60)  ,
	[CD_TP_TX] [varchar](3) ,
	[NOME_TP_TX] [varchar](200) ,
	TP_PGTO [char] (1),
	[Valor] DECIMAL(20,2),
	[VENCIMENTO] [datetime],
	TP CHAR(1)
) 


DECLARE @PrestCC_Consolidado TABLE 
(
	[ORDEM]	INT IDENTITY(1,1), 
	[Data encerramento] [datetime],
	[JOB] [varchar](16) ,
	[PO] [varchar](400) ,
	[CNPJ] [varchar](14) ,
	[Favorecido] [varchar](60)  ,
	[Adiantamento] DECIMAL(20,2) ,
	[Despesas + comissão BDP] DECIMAL(20,2) ,
	[Saldo final da Prestação de contas] DECIMAL(20,2),
	[A RECEBER / A DEVOLVER] [varchar](20) ,
	[VENCIMENTO] [datetime] 
) 

	INSERT INTO @PrestCC_Detalhe
	(
	[Data encerramento] 
	,[JOB]
	,[PO]
	,[CNPJ]
	,[Favorecido]
	,[CD_TP_TX]
	,[NOME_TP_TX]
	,[TP_PGTO]
	,[Valor] 
	,[VENCIMENTO]
	)
	SELECT 
	DISTINCT 
	FAT.Data_PC												as [Data encerramento]
	,LEFT(FAT.FATURA_PC,16)									as [JOB]
	,case when left(fat.fatura_pc,2) = 'BO' THEN
		dbo.fbusca_docs_po_modal(LEFT(FAT.FATURA_PC,16),'1')
	ELSE
		--dbo.fbusca_docs_po_modal(LEFT(FAT.FATURA_PC,16),'1')
		dbo.fBusca_PO_NumPedido(LEFT(FAT.FATURA_PC,16),'')     
	END														as [PO]
	,right(PP.Num_CPF_CNPJ,14) 								as [CNPJ]
	,PP.Nome_Raz_Soc										as [Favorecido]
	,ITM.CD_TP_TX
	,TT.NOME_TP_TX
	,TP_PGTO
	,ISNULL(ITM.VLR_PC,0)
	,fatDtVenc
	FROM 
	FATURA_CHB FAT (nolock) 
	INNER JOIN FATURA_CHB_ITEM ITM (nolock)  
		ON ITM.FATURA_CC=FAT.FATURA_PC
	INNER JOIN PESSOA PP (nolock) 
		ON PP.CD_PES=CD_PES_PC

	INNER JOIN Pessoa_LLP PLL (nolock) 
		ON PP.CD_PES = PLL.CD_PES
	INNER JOIN Grupo G (nolock) 
		on PLL.cd_pes_grupo = G.Cd_Pes_Grupo
	INNER JOIN pessoa PG  (nolock) 
		on G.cd_pes_grupo=PG.CD_PES  
	LEFT JOIN VWCTA_CTE CCH (nolock)  
		on CCH.Num_Proc_HIA = LEFT(FATURA_PC,16) 
		and CCH.Num_NF_HIA is not null 
		AND CCH.Ref_Acesso_NF_HIA <> 'P' 
		AND CCH.Ref_Acesso_NF_HIA is not null 
		and cch.cd_tp_tx = ITM.cd_tp_tx
	INNER join Tipo_Taxa TT (nolock)  on TT.cd_tp_Tx=itm.cd_tp_Tx
	INNER Join Fatura (nolock)  on fatcod=fatura_pc
	WHERE  TP_PGTO in ('B','A')
	and status_pc <> 'C'
	AND (PG.Apelido like @Grupo or @Grupo ='Grupo ALL')
	and FAT.Data_PC	 between @DtInicial and @DtFinal
	--and LEFT(FATURA_PC,16) = 'IMBCB202007001BR' -- TO TEST

	--dados da consolidada
	INSERT INTO @PrestCC_Detalhe
	(
	[Data encerramento] 
	,[JOB]
	,[PO]
	,[CNPJ]
	,[Favorecido]
	,[CD_TP_TX]
	,[NOME_TP_TX]
	,[TP_PGTO]
	,[Valor] 
	,[VENCIMENTO]
	)
	SELECT 
	DISTINCT 
	FAT.Data_PC												as [Data encerramento]
	,LEFT(FAT.FATURA_PC,16)									as [JOB]
	,dbo.fBusca_PO_NumPedido(LEFT(FAT.FATURA_PC,16),'')     as [PO]
	,right(PP.Num_CPF_CNPJ,14) 								as [CNPJ]
	,PP.Nome_Raz_Soc										as [Favorecido]
	,IFT.CD_TP_TX
	,NOME_TP_TX + ' ('+ FAT.BDP_Invoice + ')' NOME_TP_TX
	,TP_PGTO
	,ISNULL(IFT.Vlr_RS,0)
	,f.fatDtVenc
	FROM 
	FATURA_CHB FAT (nolock) 
	INNER JOIN FATURA_CHB_ITEM ITM (nolock)  
		ON ITM.FATURA_CC=FAT.FATURA_PC

	INNER JOIN Fatura FT with(nolock)
		on FT.fatcod=FAT.BDP_Invoice
	INNER JOIN Item_Fat IFT with(nolock)
		on FT.fatcod = IFT.FatCod

	INNER JOIN PESSOA PP (nolock) 
		ON PP.CD_PES=CD_PES_PC

	INNER JOIN Pessoa_LLP PLL (nolock) 
		ON PP.CD_PES = PLL.CD_PES
	INNER JOIN Grupo G (nolock) 
		on PLL.cd_pes_grupo = G.Cd_Pes_Grupo
	INNER JOIN pessoa PG  (nolock) 
		on G.cd_pes_grupo=PG.CD_PES  

	LEFT JOIN VWCTA_CTE CCH (nolock)  
		on CCH.Num_Proc_HIA = LEFT(FATURA_PC,16) 
		and CCH.Num_NF_HIA is not null 
		AND CCH.Ref_Acesso_NF_HIA <> 'P' 
		AND CCH.Ref_Acesso_NF_HIA is not null 
		and cch.cd_tp_tx = ITM.cd_tp_tx
	INNER join Tipo_Taxa TT (nolock) on TT.cd_tp_Tx=IFT.cd_tp_Tx
	INNER Join Fatura f (nolock)  on f.fatcod=fatura_pc
	WHERE  TP_PGTO in ('B','A')
	and status_pc <> 'C'
	AND (PG.Apelido like @Grupo or @Grupo ='Grupo ALL')
	and FAT.Data_PC	 between @DtInicial and @DtFinal
	--and LEFT(FATURA_PC,16) = 'IMBCB202007001BR'

	--SELECT 
	--DBO.fTipo_Taxa_pc([CD_TP_TX],[NOME_TP_TX])
	--,TP_PGTO
	--,
	--* FROM @PrestCC_Detalhe

	update @PrestCC_Detalhe
	set TP = 'A' -- adiantamento
	where DBO.fTipo_Taxa_pc([CD_TP_TX],[NOME_TP_TX]) = 'Adiantamentos'  or TP_PGTO = 'A'

	update @PrestCC_Detalhe
	set TP = 'D' -- DESPESAS
	where DBO.fTipo_Taxa_pc([CD_TP_TX],[NOME_TP_TX]) = 'Despesas' AND NOT TP_PGTO = 'A'


	INSERT INTO @PrestCC_Consolidado
	(
	[Data encerramento] 
	,[JOB] 
	,[PO] 
	,[CNPJ] 
	,[Favorecido] 
	,[Adiantamento] 
	,[Despesas + comissão BDP]
	,[VENCIMENTO]
	)
	SELECT  
	[Data encerramento]		
	,[JOB]					
	,[PO]					
	,[CNPJ]
	,[Favorecido]
	,ISNULL(SUM(CASE WHEN TP = 'A'  THEN
		[Valor]
	END),0)											as [Adiantamento]
	,ISNULL(SUM(CASE WHEN TP = 'D'  THEN
		[Valor] 
	END),0)											as [Despesas + comissão BDP]
	,[VENCIMENTO] 
	FROM @PrestCC_Detalhe
	GROUP BY
	[Data encerramento]		
	,[JOB]					
	,[PO]					
	,[CNPJ]
	,[Favorecido]
	,[VENCIMENTO]
	order by job

	UPDATE @PrestCC_Consolidado 
	SET [Saldo final da Prestação de contas] = ([Adiantamento] - [Despesas + comissão BDP])*-1 

	UPDATE @PrestCC_Consolidado 
	SET [A RECEBER / A DEVOLVER] = 
	CASE WHEN [Saldo final da Prestação de contas] > 0
	THEN
	'SALDO A RECEBER'
	ELSE 
	'SALDO A DEVOLVER'
	END

	SELECT 
	@total_adiantamento = SUM(ISNULL([Adiantamento],0))
	,@total_Despesas = SUM(ISNULL([Despesas + comissão BDP],0))
	,@saldo = SUM(ISNULL([Saldo final da Prestação de contas],0))
	FROM @PrestCC_Consolidado

	if exists(select * from @PrestCC_Consolidado)
	begin
		INSERT INTO @PrestCC_Consolidado
		(
		[JOB] 
		,[Adiantamento] 
		,[Despesas + comissão BDP]
		,[Saldo final da Prestação de contas] 
		)
		SELECT 
		'TOTAL'
		,@total_adiantamento
		,@total_Despesas
		,@saldo
	end


	SELECT
	[Data encerramento] 
	,[JOB] 
	,[PO] 
	,[CNPJ] 
	,[Favorecido] 
	,[Adiantamento] 
	,[Despesas + comissão BDP]
	,[Saldo final da Prestação de contas] 
	,[A RECEBER / A DEVOLVER]
	,[VENCIMENTO]
	FROM @PrestCC_Consolidado 
	order by [ORDEM]



	
SET NOCOUNT OFF
GO
