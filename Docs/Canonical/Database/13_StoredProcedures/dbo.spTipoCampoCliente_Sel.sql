SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE procedure [dbo].[spTipoCampoCliente_Sel] --'Grupo MARS'
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
		when Tipo = 'F' then 'F - Float' 
		when Tipo = 'I' then 'I - Int' 
		when Tipo = 'S' then 'S - String'
		when Tipo = 'X' then 'X - Disabled'
	end) Tipo,
	isnull(Tab_Relacionada,'') Tab_Relacionada,
	isnull(Cod_Busca,'') Cod_Busca,
	isnull(Campo_Exibicao,'') Campo_Exibicao,
	isnull(House,0) House,
	isnull(Master,0) Master,
	isnull(Export,0) Export,
	isnull(Import,0) Import,
	isnull(Air,0) Air,
	isnull(Ocean,0) Ocean,
	isnull(Other,0) Other
from 
	tipo_campo_cliente T
	join pessoa P on P.cd_pes=T.cd_pes_grupo
	left join tipo_campo_cliente_Modais M on M.Id_campo = T.Id_Campo
where
	apelido = @Grupo --or cd_pes_grupo='10017'
order by
	1












GO
