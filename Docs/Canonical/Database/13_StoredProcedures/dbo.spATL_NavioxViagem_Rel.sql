SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spATL_NavioxViagem_Rel] '2010-01-01','2015-12-31','ALL'
CREATE PROCEDURE [dbo].[spATL_NavioxViagem_Rel] 
(
	@dt_inicial as datetime,
	@dt_final as datetime,
	@Destination varchar(50)
)
AS

select
	V.id_viagem			[ID],
	NV.Nome_Navio		[Navio/ jobs],	
	V.NR_Viagem         [Viagem],
	Convert(varchar(10),V.ETA,103)	ETA, --[DT. PREV.],
	Convert(varchar(10),V.ATA,103)	ATA, --[DT. CHEG.],
	O.Descricao_OP		[LOCAL DE ATRACAÇÃO],
	P.Nome_pais			[NACIONALIDADE],
	V.Manifesto			[MANIFESTO],
	A.Nome_Armador		[AGÊNCIA],
	L.Nome_Local		[Destination],
	V.Notes				[Notes]
	
from Viagem_LLP V with(nolock)
	left Join navio_LLP NV with(nolock) on V.id_navio = NV.Id_Navio
	left join Localidade L with(nolock) on L.Cd_Local  = V.Cd_Dst
	left join Tipo_Operador_Portuario O with(nolock) on O.ID_OP = V.id_op
	left join Pais P with(nolock) on P.cd_pais = NV.cd_pais
	left join Armador A with(nolock) on A.cd_armador = NV.cd_armador
	
Where
	v.ETA between @dt_inicial and @dt_final and (L.Nome_Local = @Destination or @Destination = 'ALL')
	and Modal = 'I'
order by V.ETA

OPTION(HASH JOIN)
	
	
GO
