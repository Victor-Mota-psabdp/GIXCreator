SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[vwArmador_HBL_EM]

as

select 
	cd_armador,Nome_Armador 
from 
	Armador
where 
	cd_armador in ('SBH','BDP')



GO
