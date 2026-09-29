SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select distinct Descr_Campo from Tipo_Campo_Ordem order by Descr_Campo
--spTipoCampoOrdem_Sel 'Grupo DOW'
CREATE procedure [dbo].[spTipoCampoOrdem_Sel] --'Grupo MARS'
(
@Grupo varchar(20)
)
as

select 
	Descr_Campo, 
	(case
		when Tipo = 'B' then 'B - Boolean'
		when Tipo = 'C' then 'C - Char' 
		when Tipo = 'D' then 'D - Data'
		when Tipo = 'H' then 'H - Data/Hora' 
		when Tipo = 'F' then 'F - Float' 
		when Tipo = 'I' then 'I - Int' 
		when Tipo = 'S' then 'S - String'
		when Tipo = 'X' then 'X - Disabled'
	end) Tipo,
	isnull(Tab_Relacionada,'') Tab_Relacionada,
	isnull(Cod_Busca_PK,'') Cod_Busca,
	isnull(Campo_Exibicao,'') Campo_Exibicao	
from 
	tipo_campo_ordem T
	join pessoa P on P.cd_pes=T.cd_pes_grupo	
where
	apelido = @Grupo --or cd_pes_grupo='10017'
	and ativo = 1
	and id_campo not in (1,2,3,900)
order by
	1














GO
