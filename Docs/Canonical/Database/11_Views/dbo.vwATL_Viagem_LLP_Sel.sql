SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Viagem_LLP
CREATE VIEW [dbo].[vwATL_Viagem_LLP_Sel]
AS
	select 
		Nr_viagem		[Voyage],
		V.ID_Viagem		[Code],
		V.Modal			[Modal],
		V.ID_Navio		[Vessel Code],			
		NV.Nome_Navio	[Vessel Name],		
		Ano_Viagem		[Year],
		V.Cd_Dst		[Origin/Destination Code],
		L.Nome_Local	[Origin/Destination Name],
		--O.Descricao_OP	[Port Operator],
		V.Id_Terminal	[Terminal Code],
		T.Nome_Terminal	[Terminal Name],
		convert(varchar(10),V.ETD,103)	[ETD Date],
		convert(varchar(10),V.ATD,103)	[ATD Date],
		convert(varchar(10),V.ETA,103)	[ETA Date],
		convert(varchar(10),V.ATA,103)	[ATA Date],	
		V.Manifesto		[Manifesto],
		V.Notes			[Notes]	,
		V.ativo			[Ativo]
		--'Saved' [Status]
	from Viagem_LLP V
		left Join navio_LLP NV on V.id_navio = NV.Id_Navio
		left join Localidade L on L.Cd_Local  = V.Cd_Dst
		left join Terminal T on T.Cd_Terminal = V.Id_Terminal

GO
