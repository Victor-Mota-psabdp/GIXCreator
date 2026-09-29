SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- select * from SCAC_Localidade
-- select * from SCAC_Localidade where dt_ins > getdate() -1
--select * from Tipo_Moeda  where cd_tp_moeda <> '0'
-- select * from TIPO_MOEDA where cd_tp_moeda not in ('EUR','USD') and cd_tp_moeda <> '0'
CREATE procedure [dbo].[spAtualizaTabelasATL_Sel]

AS

SELECT 'Tela_ATL' [Table], ' where dt_criacao > getdate()-5 ' [Where]
UNION ALL
SELECT 'Localidade', ' where desat_loc = ' + '''N''' + ' and dt_criacao > getdate()-5' [where]
UNION ALL
SELECT 'Cia_Aerea', ' where dt_criacao > getdate()-5 and SCAC is NOT null' [where]
UNION ALL
SELECT 'Armador', ' where dt_criacao > getdate()-5 and SCAC is NOT null' [where]
UNION ALL
SELECT 'Mensagem_Erro', ' where dt_criacao > getdate()-5' [where]
UNION ALL
SELECT 'SCAC_Localidade', ' where dt_ins > getdate()-1' [where]
-- UNION ALL
-- SELECT 'Tipo_Moeda', ' where cd_tp_moeda not in (''EUR'',''USD'') and cd_tp_moeda <> ''0''' [where]

ORDER BY 1




GO
