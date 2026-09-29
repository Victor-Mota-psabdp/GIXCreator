SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spViagem_LLP_Update_Pending_Sel]
	
as

--I = ETA_Lim = ETA,ATA_Lim = ATA
select distinct L.Id_Viagem Id_Viagem, L.Modal  Modal from Viagem_LLP L
	join vwHouse_Imp H on H.Id_Viagem = L.Id_Viagem 
	join Navio_LLP N on N.Id_Navio = L.Id_Navio
Where
	--H.Num_Proc like 'IMCSR%' and 
	L.ATA <> H.ATA
	And L.dt_ins > getdate() -720
	and L.Modal = 'I'

UNION

select distinct L.Id_Viagem Id_Viagem, L.Modal  Modal from Viagem_LLP L
	join vwHouse_Imp H on H.Id_Viagem = L.Id_Viagem 
	join Navio_LLP N on N.Id_Navio = L.Id_Navio
Where
	--H.Num_Proc like 'IMCSR%' and 
	L.ETA <> H.ETA
	And L.dt_ins > getdate() -720
	and L.Modal = 'I'

UNION

--E = ETD_Lem = ETD,ATD_Lem = ATD
select distinct L.Id_Viagem Id_Viagem, L.Modal  Modal from Viagem_LLP L
	join vwHouse_Imp H on H.Id_Viagem = L.Id_Viagem 
	join Navio_LLP N on N.Id_Navio = L.Id_Navio
Where
	--H.Num_Proc like 'IMCSR%' and 
	L.ATD <> H.ATD
	And L.dt_ins > getdate() -720
	and L.Modal = 'E'

UNION

select distinct L.Id_Viagem Id_Viagem, L.Modal  Modal from Viagem_LLP L
	join vwHouse_Imp H on H.Id_Viagem = L.Id_Viagem 
	join Navio_LLP N on N.Id_Navio = L.Id_Navio
Where
	--H.Num_Proc like 'IMCSR%' and 
	L.ETD <> H.ETD
	And L.dt_ins > getdate() -720
	and L.Modal = 'E'

order by 1


GO
