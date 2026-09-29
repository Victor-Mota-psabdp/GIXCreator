SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_SETS2ATLViagem_Sel]
(
	@Num_Proc varchar(16)
)

as

select 
	H.ID_Viagem, NV.Nome_Navio,V.NR_Viagem,V.Modal,L.Nome_Local,V.ATD,V.ATA 
from 
	vwHouse_Exp H 
	join Viagem_LLP V with(nolock) on H.ID_Viagem = V.ID_Viagem
	left Join navio_LLP NV with(nolock) on V.id_navio = NV.Id_Navio
	left join Localidade L with(nolock) on L.Cd_Local  = V.Cd_Dst
where 
	Num_Proc = @Num_Proc

Union all

select 
	H.ID_Viagem, NV.Nome_Navio,V.NR_Viagem,V.Modal,L.Nome_Local,V.ATD,V.ATA 
from 
	vwHouse_Imp H 
	join Viagem_LLP V with(nolock) on H.ID_Viagem = V.ID_Viagem
	left Join navio_LLP NV with(nolock) on V.id_navio = NV.Id_Navio
	left join Localidade L with(nolock) on L.Cd_Local  = V.Cd_Dst
where 
	Num_Proc = @Num_Proc
GO
