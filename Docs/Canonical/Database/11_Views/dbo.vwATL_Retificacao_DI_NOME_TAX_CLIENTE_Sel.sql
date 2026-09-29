SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Retificacao_DI
--select distinct NOME_TAX_CLIENTE from [Retificacao_DI] where NOME_TAX_CLIENTE is not null";
CREATE view [dbo].[vwATL_Retificacao_DI_NOME_TAX_CLIENTE_Sel] 

AS
	
select 
	distinct R.NOME_TAX_CLIENTE					[Responsavel no TAX cliente]	
from [Retificacao_DI] R with(nolock)		
	where R.NOME_TAX_CLIENTE is not null

GO
