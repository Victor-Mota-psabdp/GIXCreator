SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
EXEC spATL_CamposAdicionaisGrupo_Rel 'Grupo ALL'

EXEC spATL_CamposAdicionaisGrupo_Rel ''

EXEC spATL_CamposAdicionaisGrupo_Rel NULL



EXEC spATL_CamposAdicionaisGrupo_Rel 'GRUPO BDP'

EXEC spATL_CamposAdicionaisGrupo_Rel 'Grupo DOW'




*/

CREATE procedure [dbo].[spATL_CamposAdicionaisGrupo_Rel]
(
	@Grupo varchar(50)
)

as

declare @Cd_Grupo varchar(20)

if isnull(@Grupo,'') = ''
	Begin
		set @Cd_Grupo = '%'
	End
else if @Grupo = 'Grupo ALL'
	Begin
		set @Cd_Grupo = '%'
	End
else if @Grupo = 'GRUPO BDP'
	Begin
		set @Cd_Grupo = '10017'
	End
else if @Grupo <> 'Grupo ALL'
	Begin
		set @Cd_Grupo = (select cd_pes from Pessoa where Apelido = @Grupo)
	End
else 
	set @Cd_Grupo = '%'





select 
tcc.ID_Campo
,Descr_Campo

,Cd_Pes_Grupo								as [Código do Grupo]

,Case when Apelido = 'BDP (SÃO PAULO)'
then 'TODOS GRUPOS'
else Apelido end							as [Nome do Grupo]

,case 
when Tipo = 'X' then 'Inativo'
else 'Ativo' end as [Status]


,case 
when Tipo = 'B' then 'Sim ou Não'
when Tipo = 'S' then 'Texto'
when Tipo = 'C' then 'Texto'
when Tipo = 'F' then 'Numérico c/ Casas Decimais'
when Tipo = 'I' then 'Numérico s/ Casas Decimais'
when Tipo = 'D' then 'Data'
when Tipo = 'X' then ''
else '' end as Tipo_campo

,case 
when isnull(Tab_relacionada,'') = '' then 'Sim'
else 'Não' end as [Campo Livre]

,case 
when house = '1' then 'House'
 when master = '1' then 'Master'
else '' end as				[Nivel do campo]


,case 
when Export = '1' and Air = 1 then 'Sim'
else 'Não' end as				[EA]
,case 
when Export = '1' and Ocean = 1 then 'Sim'
else 'Não' end as				[EM]
,case 
when Export = '1' and Other = 1 then 'Sim'
else 'Não' end as				[EO]

,case 
when Import = '1' and Air = 1 then 'Sim'
else 'Não' end as				[IA]
,case 
when Import = '1' and Ocean = 1 then 'Sim'
else 'Não' end as				[IM]
,case 
when Import = '1' and Other = 1 then 'Sim'
else 'Não' end as				[IO]



from Tipo_Campo_Cliente TCC (nolock)
inner join Tipo_Campo_Cliente_Modais TCCM (nolock)
	ON TCC.id_campo = tccm.id_campo
inner join Pessoa (nolock)
	on cd_pes_grupo = cd_pes
where Cd_Pes_Grupo like @Cd_Grupo
GO
