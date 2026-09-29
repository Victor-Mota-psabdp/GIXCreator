SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_Acomp_Export_rel'EAAMZ201612005BR'
CREATE procedure [dbo].[spATL_Acomp_Export_rel](
@Num_Proc varchar(16)
)
as
select
Num_Proc [JOB BDP],
TRANS.Apelido [TRANSPORTADORA],
CLI.Apelido [CLIENTE],
CLI.Num_CPF_CNPJ [CNPJ],
dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'3')[SALES ORDER],
dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'1')[PO],
isnull(ARM.Nome_Armador,Aer.Nome_Cia_Aer) [ARMARDOR],
HOU.Booking_Number [BOOKING],
AGE.Apelido [AGENTE],
HOU.Vessel [NAVIO],
HOU.Viagem [VGN],
HOU.Cut_Date [DDL Carga] ,
NULL [IMO],
HOU.Dead_line [DDL Draft],
HOU.DL_VGM [DDL VGM],
TM.Nome_Terminal [TERMINAL DE EMBARQUE],
ORG.Nome_Local [AEROPORTO],
dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'4')[RE NRO],
dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,'4')[RE DT],
dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'12')[DDE NRO],
dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,'12')[DDE DT],
dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'26')[DSE NRO],
dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,'26')[DSE DT],
MAWB,
HAWB,
ORG.Nome_Local [ORIGEM]
from vwHouse_Exp HOU with(nolock)
left join Pessoa TRANS with(nolock) on HOU.Cd_Transportadora = TRANS.Cd_Pes
join Pessoa CLI with(nolock) on HOU.Cd_Export = CLI.Cd_Pes
left join Armador ARM with(nolock) on HOU.Cd_Armador = ARM.Cd_Armador
left join Cia_Aerea Aer with(nolock) on HOU.Cd_Armador = Aer.Cd_Cia_Aer
left join Pessoa AGE with(nolock) on HOU.Cd_Agente = AGE.Cd_Pes
left join Terminal TM with(nolock) on HOU.Cd_Terminal = TM.Cd_Terminal
left join Localidade ORG with(nolock) on HOU.Cd_Org = ORG.Cd_Local
left join Localidade PLO with(nolock) on HOU.cd_planta = PLO.Cd_Local
where HOU.Num_proc = @Num_Proc




GO
