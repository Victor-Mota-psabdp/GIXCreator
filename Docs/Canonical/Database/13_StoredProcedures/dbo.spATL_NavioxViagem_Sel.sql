SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Incluido para @Modal = 'E' Campo [Terminal]. 21/06/2017

CREATE PROCEDURE [dbo].[spATL_NavioxViagem_Sel] --'%','%','E'
(
	@Nome_Navio		varchar(25),
	@NR_Viagem		varchar(8),
	@Modal			varchar(1)
)
AS

if @Modal = 'E'
	select 
	id_viagem		[Code],
	NV.Nome_Navio	[Vessel],
	Nr_viagem		[Voyage],
	Ano_Viagem		[Year],
	L.Nome_Local	[Origin],
	--O.Descricao_OP	[Port Operator],
	T.Nome_Terminal	[Terminal],
	convert(varchar(10),V.ETD,103)	[ETD Date],
	convert(varchar(10),V.ATD,103)	[ATD Date],
	convert(varchar(10),V.ETA,103)	[ETA Date],
	convert(varchar(10),V.ATA,103)	[ATA Date],	
	V.Manifesto		[Manifesto],
	V.Notes			[Notes]	,
	V.ativo			[Ativo]
	--'Saved' [Status]
from Viagem_LLP V with(nolock)
	left Join navio_LLP NV with(nolock) on V.id_navio = NV.Id_Navio
	left join Localidade L with(nolock) on L.Cd_Local  = V.Cd_Dst
	--left join Tipo_Operador_Portuario O on O.ID_OP = V.id_op
	left join Terminal T with(nolock) on T.Cd_Terminal = V.Id_Terminal
 where 
	NV.nome_navio like @Nome_Navio 
	and V.Nr_viagem  like @NR_Viagem
	and NV.Nome_Navio <> ''
	and Modal = @Modal
	and V.ETD >= getdate ()-365 --adicionado por Leandro 15/05/2024
else
	select 
		id_viagem		[Code],
		NV.Nome_Navio	[Vessel],
		Nr_viagem		[Voyage],
		Ano_Viagem		[Year],
		L.Nome_Local	[Destination],
		O.Descricao_OP	[Port Operator],
		convert(varchar(10),V.ETD,103)	[ETD Date],
		convert(varchar(10),V.ATD,103)	[ATD Date],
		convert(varchar(10),V.ETA,103)	[ETA Date],
		convert(varchar(10),V.ATA,103)	[ATA Date],	
		V.Manifesto		[Manifesto],
		V.Notes			[Notes]	,
		V.ativo			[Ativo]
		--'Saved' [Status]
	from Viagem_LLP V with(nolock)
		left Join navio_LLP NV with(nolock) on V.id_navio = NV.Id_Navio
		left join Localidade L with(nolock) on L.Cd_Local  = V.Cd_Dst
		left join Tipo_Operador_Portuario O with(nolock) on O.ID_OP = V.id_op
	 where 
		NV.nome_navio like @Nome_Navio 
		and V.Nr_viagem  like @NR_Viagem
		and NV.Nome_Navio <> ''
		and Modal = @Modal
		and V.ETD >= getdate ()-365 --adicionado por Leandro 15/05/2024
GO
