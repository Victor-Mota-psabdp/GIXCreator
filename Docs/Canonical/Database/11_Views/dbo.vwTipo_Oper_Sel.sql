SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vwTipo_Oper_Sel]
AS
SELECT 
	tp.Cd_Tp_Oper AS ID, 
	tp.Nome_Tp_Oper AS Description
FROM dbo.Tipo_Oper AS tp 
WHERE cd_tp_oper not in ('CSR','BDP')


--ALTER VIEW [dbo].[vwTipo_Oper_Sel]
--AS
--SELECT 
--	tp.Cd_Tp_Oper AS ID, 
--	tp.Nome_Tp_Oper AS Description
--FROM dbo.Tipo_Oper AS tp 








GO
