SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spConsultaTabela_Sel]'vwSolPgtoCtaCte'
CREATE procedure [dbo].[spConsultaTabela_Sel]
(
@Tabela varchar(50)
)

AS

SELECT 
    COLUNAS.NAME AS COLUNA,
    TIPOS.NAME AS TIPO,
    COLUNAS.max_length AS TAMANHO,
    COLUNAS.is_nullable AS EH_NULO
 
FROM 
    SYS.OBJECTS AS TABELAS 
    --SYS.COLUMNS AS COLUNAS,
    --SYS.TYPES   AS TIPOS
INNER JOIN sys.columns COLUNAS ON TABELAS.object_id = COLUNAS.object_id 
INNER JOIN sys.types TIPOS ON TIPOS.system_type_id = COLUNAS.system_type_id AND TIPOS.name != 'sysname'
WHERE 
    -- JOINS 
    --TABELAS.ID = COLUNAS.ID
    --AND COLUNAS.USERTYPE = TIPOS.USERTYPE
    TABELAS.NAME = @Tabela --and
    --TIPOS.name != 'sysname'

ORDER BY
	column_id
GO
