SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwTipo_NF_Doc_Register_AX_DOC_Sel]
AS
select Distinct
	A.Cd_Servico,
	A.Item_lei	
from 
	Tipo_NF_Doc_Register A with(nolock) 
--where 
--	A.cd_servico in ('3330051')



GO
