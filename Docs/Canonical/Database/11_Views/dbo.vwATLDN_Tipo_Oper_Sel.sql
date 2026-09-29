SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwATLDN_Tipo_Oper_Sel]
AS
SELECT 
	O.Cd_Tp_Oper AS Code,
	--O.Nome_Tp_Oper AS [Freight Name],
	O.Nome_Tp_Oper AS [Incoterm Name],
	--O.Cd_Tp_Frete  as [Freight Type],
	O.Cd_Tp_Frete  as [Freight Type Code],
	F.Nome_Tp_Frete  as [Freight Type Name]
from Tipo_Oper O with(nolock)
left join tipo_frete F with(nolock) on F.Cd_Tp_Frete = O.Cd_Tp_Frete
WHERE 
	cd_tp_oper not in ('CSR','BDP')

-- SELECT 
-- 	tp.Cd_Tp_Oper AS ID, 
-- 	tp.Nome_Tp_Oper AS Description,
-- 	 Cd_Tp_Oper AS Code,
-- 	 Nome_Tp_Oper AS [Freight Name],
-- 	 Cd_Tp_Frete  as [Freight Type]
-- FROM dbo.Tipo_Oper AS tp 
-- WHERE cd_tp_oper not in ('CSR','BDP')









GO
