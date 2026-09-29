SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spPrestCC_BUSCA_TIPO_SEL]
	@Fatura_PC varchar(17)
as

select
	(Case when Cd_Tipo = 'P' then 'Principal'
	else (case when Cd_Tipo = 'C' then 'Complementar'
	else (case when Cd_Tipo = 'D' then 'Draft'
	else (case when Cd_Tipo = 'E' then 'Devolução'	
	End)End)End)End) Tipo
from Fatura_CHB 
where 
Fatura_PC =@Fatura_PC

GO
