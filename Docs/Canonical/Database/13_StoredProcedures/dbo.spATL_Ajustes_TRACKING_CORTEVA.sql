SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_Ajustes_TRACKING_CORTEVA] 
AS
/*-------------------------------------------------------------------------------------------------------------------------
HISTORICO ALTERAÇÃO
. Data:	04/11/2019
. Solicitante: Roberta Beltran
. Desenvolvedor: Alessandra Suzuki Mariano
. Solicitação: Solicitada a melhoria no E-mail assunto: Melhorias Dow/Corteva/Dupont - Item 2
	. Tela “Order Management”, Campos: “Gross Weight” e “Net Weight”: 
	Se o processo possuir Nota fiscal, atualizar as  informações “Gross Weight” e “Net Weight” no PO. 
-------------------------------------------------------------------------------------------------------------------------
EXEMPLO EXECUÇÃO
-------------------------------------------------------------------------------------------------------------------------
*/
Declare @MSG varchar(400)


-- 1) CRIO A TABELA TEMPORARIA
DECLARE @tabela TABLE
(
[GRUPO]						VARCHAR(20)
,[PO]						VARCHAR(30)
,[JOB]						VARCHAR(16)
,[ID PO]					INT	
,[PRODUTO PO]				INT
,[LOTE]						VARCHAR(30)
,[ITEM]						VARCHAR(6)
,[PO - Net Weight]			FLOAT
,[PO - Gross Weight]		FLOAT
,[NOTA - Net Weight]		FLOAT
,[NOTA - Gross Weight]		FLOAT
,[ATUALIZA NET]				BIT
,[ATUALIZA GROSS]			BIT
)

-- 2) INSIRO OS DADOS
INSERT @tabela
SELECT
cs.Apelido				AS [GRUPO],
p.Num_Pedido			AS [PO],
h.Num_Proc				AS [JOB],
	PD.Cd_Pedido		AS [ID PO],
	PD.Cd_Produto		AS [PRODUTO PO],
	PD.LOTE				AS [LOTE],
	PD.Item				AS [ITEM],
pd.Peso_Liquido_TOT		AS [PO - Net Weight],
pd.Peso_Bruto_TOT		AS [PO - Gross Weight],		 
NCD.Peso_Liquido		AS [NOTA - Net Weight],
NCD.PESO_BRUTO			AS [NOTA - Gross Weight],
CASE WHEN (pd.Peso_Liquido_TOT<>NCD.Peso_Liquido)
THEN 1 ELSE 0 END									AS [ATUALIZA NET],	
CASE WHEN (pd.Peso_Bruto_TOT <> NCD.PESO_BRUTO)
THEN 1 ELSE 0 END									AS [ATUALIZA GROSS]
FROM pedido P (NOLOCK)
INNER JOIN pedido_det	PD (NOLOCK)
	ON P.Cd_pedido = PD.Cd_Pedido
INNER JOIN Pedido_Ship PS (NOLOCK) 
	ON PS.cd_pedido = P.Cd_pedido
INNER JOIN vwHouse_Imp H (NOLOCK) 
	ON H.Num_Proc = PS.Num_Proc
LEFT JOIN Tarefas_Processos TP222 (NOLOCK)
	ON H.Num_Proc = TP222.Num_Proc and TP222.ID_Task =222
INNER JOIN Pessoa CS (NOLOCK) 
	ON H.Cd_Consig = CS.Cd_Pes
INNER JOIN  Nota_Cliente	NC (NOLOCK) 
	ON NC.num_proc=PS.num_proc and nota_fiscal <> '1'  
INNER JOIN  Nota_Fiscal_Cliente_Det NCD (NOLOCK) 
	ON NCD.Id_NF=NC.ID_NF and NC.cd_cliente=NCD.cd_cliente and PS.cd_produto=NCD.cd_produto   
WHERE 

-- Apenas os aque a quantidade estão diferentes
((pd.Peso_Liquido_TOT<>NCD.Peso_Liquido) OR (pd.Peso_Bruto_TOT <> NCD.PESO_BRUTO))

-- Que tenha apenas um item na PO e uma nota só
AND H.Num_Proc in (select Num_Proc 
						FROM Pedido_Ship PS (NOLOCK) 
						INNER join  pedido P (NOLOCK)
							on PS.cd_pedido = P.Cd_pedido
						INNER JOIN pedido_det PD (NOLOCK)
							ON P.Cd_pedido = PD.Cd_Pedido
						where Num_Proc = H.Num_Proc
						GROUP BY Num_Proc 
						having COUNT(*) = 1)

and H.Num_Proc in		(select num_proc 
						from Nota_Cliente V2
						where V2.num_proc = H.Num_Proc
						group by V2.num_proc 
						having COUNT(*) = 1)

-- Fazendo os filtros do Tracking porque é o que importa ser acertado
and H.ID_Status <> '9'
and ((TP222.Dt_Conclusao >= '2019-01-01') or (TP222.Dt_Conclusao is null and convert(datetime,h.dt_emis,103) >= '2018-06-01'))
AND CS.num_cpf_cnpj IN 
('61064929007777'
,'61064929000330'
,'61064929000845'
,'47180625001975'
,'47180625002190'
,'61064929007262'
,'47180625002009'
,'61064929009478'
,'61064929000179'
,'47180625002270'
,'61064929007696'
)
--AND h.Num_Proc	= 'IMCSR201904539BR'
ORDER BY CS.Apelido,p.cd_pedido, h.num_proc, item


-- 3 - DECLARO AS VARIAVEIS PRO CURSOR
DECLARE  @GRUPO					VARCHAR(20)
DECLARE  @PO					VARCHAR(30)
DECLARE  @JOB					VARCHAR(16)
DECLARE  @IDPO					INT	
DECLARE  @PRODUTOPO				INT
DECLARE  @LOTE					VARCHAR(30)
DECLARE  @ITEM					VARCHAR(6)
DECLARE  @PONetWeight			FLOAT
DECLARE  @POGrossWeight			FLOAT
DECLARE  @NOTANetWeight			FLOAT
DECLARE  @NOTAGrossWeight		FLOAT
DECLARE  @ATUALIZANET			BIT
DECLARE  @ATUALIZAGROSS			BIT

-- 4 - DECLARO O CURSOR
DECLARE cTemp CURSOR FOR  
(  
SELECT * FROM @tabela
)  


-- 5 - ABRO E USO O CURSOR PARA FAZER UPDATE E GRAVAR HISTORICO GERAL
OPEN cTemp  
  
	FETCH NEXT FROM cTemp INTO @GRUPO,@PO,@JOB,@IDPO,@PRODUTOPO,@LOTE,@ITEM,@PONetWeight,@POGrossWeight,@NOTANetWeight,@NOTAGrossWeight,@ATUALIZANET,@ATUALIZAGROSS		

  
	WHILE @@Fetch_Status=0  
		BEGIN  
			IF @ATUALIZANET = 1
			BEGIN
				update pedido_det
				set Peso_Liquido_TOT = @NOTANetWeight
				FROM pedido_det PD
				WHERE
				PD.Cd_Pedido			= @IDPO
				AND PD.Cd_Produto		= @PRODUTOPO
				AND PD.LOTE				= @LOTE
				AND PD.Item				= @ITEM 
				
				set @MSG='PO Net Weight Updated from AJUSTES CORTEVA FROM: ' + convert(varchar(15),@PONetWeight) + ' TO: ' + convert(varchar(15),@NOTANetWeight)  + space(10) + 'Historic created by ATL System'
				--SELECT @JOB,Null,Null,'ATD',@MSG,'01-01-2010',Null,'ATL System','N','U',Null

				exec spHistG_InsUPD @JOB,Null,Null,'ATD',@MSG,'01-01-2010',Null,'ATL System','N','U',Null

			END
			
			IF @ATUALIZAGROSS = 1
			BEGIN				
				update pedido_det
				set Peso_Bruto_TOT = @NOTAGrossWeight
				FROM pedido_det PD
				WHERE
				PD.Cd_Pedido			= @IDPO
				AND PD.Cd_Produto		= @PRODUTOPO
				AND PD.LOTE				= @LOTE
				AND PD.Item				= @ITEM 
				
				set @MSG='PO Gross Weight Updated from AJUSTES CORTEVA FROM: ' + convert(varchar(15),@POGrossWeight) + ' TO: ' + convert(varchar(15),@NOTAGrossWeight)  + space(10) + 'Historic created by ATL System'
				--SELECT @JOB,Null,Null,'ATD',@MSG,'01-01-2010',Null,'ATL System','N','U',Null

				exec spHistG_InsUPD @JOB,Null,Null,'ATD',@MSG,'01-01-2010',Null,'ATL System','N','U',Null

			END
			
		  FETCH NEXT FROM cTemp into @GRUPO,@PO,@JOB,@IDPO,@PRODUTOPO,@LOTE,@ITEM,@PONetWeight,@POGrossWeight,@NOTANetWeight,@NOTAGrossWeight,@ATUALIZANET,@ATUALIZAGROSS		
		END  
  
CLOSE cTemp  
DEALLOCATE ctemp  
GO
