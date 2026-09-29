SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- [dbo].[spATL_Vessel_Control_Export_Rel]'2016-01-01','2016-12-31'
CREATE PROCEDURE [dbo].[spATL_Vessel_Control_Export_Rel]
(
	@dt_inicial as datetime,
	@dt_final as datetime 
)
AS

select
	V.id_viagem			[ID],
	NV.Nome_Navio		[Navio],	
	V.NR_Viagem [#Viagem],
	Convert(datetime,V.ETD,103)	[ETD],
	Convert(datetime,V.ATD,103)	[ATD],
	T.nome_terminal [Terminal] ,
	L.Nome_Local [Origem]
from Viagem_LLP V with(nolock)
	left Join navio_LLP NV with(nolock) on V.id_navio = NV.Id_Navio
	left join Localidade L with(nolock) on L.Cd_Local  = V.Cd_Dst
	left join Terminal T with(nolock) on T.Cd_Terminal = V.Id_Terminal
Where
	v.ETD between @dt_inicial and @dt_final
	and Modal = 'E'
order by V.ETD

GO
