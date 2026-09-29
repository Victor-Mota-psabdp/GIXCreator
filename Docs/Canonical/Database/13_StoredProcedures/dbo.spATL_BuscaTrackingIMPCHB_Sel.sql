SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_BuscaTrackingIMPCHB_Sel](
@Grupo varchar(50)

)
as

select 
[Modal],
[BDP Ref.],
[Consol. Ref.],
[Group],
[Consignee],
[CNPJ],
[Master],
[House],
[P.O.],
[Product],
[Origin],
[Destination],
[Carrier],
[Vessel / Flight #],
[Containers / Volumes],
[Necessidade LI?],
[L.I.],
CONVERT(varchar(10),[Data Solic. L.I.],103) [Data Solic. L.I.],
CONVERT(varchar(10),[Data Def. L.I.],103) [Data Def. L.I.],
CONVERT(varchar(10),[Data Vcto.],103) [Data Vcto.],
CONVERT(varchar(10),[ETD Date],103) [ETD Date],
CONVERT(varchar(10),[ATD Date],103) [ATD Date],
CONVERT(varchar(10),[Data Aprov. Draft],103) [Data Aprov. Draft],
CONVERT(varchar(10),[Data Abertura Pasta],103) [Data Abertura Pasta],
CONVERT(varchar(10),[Data Digitação],103) [Data Digitação],
CONVERT(varchar(10),[Data Cheg. Docs.],103) [Data Cheg. Docs.],
CONVERT(varchar(10),[Data Sol. Numerario],103) [Data Sol. Numerario],
CONVERT(varchar(10),[Data Redest. Container],103) [Data Redest. Container],
CONVERT(varchar(10),[ETA Date],103) [ETA Date],
[Saldo Processo Valor],
CONVERT(varchar(10),[ATA Date],103) [ATA Date],
CONVERT(varchar(10),[Data Pgto. AFRMM],103) [Data Pgto. AFRMM],
[Terminal],
CONVERT(varchar(10),[Data Entr. Terminal],103) [Data Entr. Terminal],
CONVERT(varchar(10),[Data Desova],103) [Data Desova],
CONVERT(varchar(10),[Data Presença Carga],103) [Data Presença Carga],
CONVERT(varchar(10),[Data Liberação BL],103) [Data Liberação BL],
[D.I.],
CONVERT(varchar(10),[Data D.I.],103) [Data D.I.],
CONVERT(varchar(10),[Data Desembaraço],103) [Data Desembaraço],
CONVERT(varchar(10),[Data Pgto Armazenagem],103) [Data Pgto Armazenagem],
CONVERT(varchar(10),[Data Pgto Armazenagem],103) [Data Pgto Armazenagem],
CONVERT(varchar(10),[Data Averbação],103) [Data Averbação],
[Channel],
CONVERT(varchar(10),[Data Env Draft NFe],103) [Data Env Draft NFe],
CONVERT(varchar(10),[Data Entr Docs Transp],103) [Data Entr Docs Transp],
CONVERT(varchar(10),[Data Env Draft NF Compl],103) [Data Env Draft NF Compl],
CONVERT(varchar(10),[Data Env Docs Faturamento],103) [Data Env Docs Faturamento],
CONVERT(varchar(10),[Data Env. Faturamento SP],103) [Data Env. Faturamento SP],
CONVERT(varchar(10),[Data Receb. Faturamento],103) [Data Receb. Faturamento],
CONVERT(varchar(10),[Data Prev Entrega],103) [Data Prev Entrega],
CONVERT(varchar(10),[Data Entrega Planta],103) [Data Entrega Planta],
[Histórico],
[Notes (OBS)],
[Urgente],
[Localidade],
[Certificado de Origem],
[Drawback - Ato Concess.]
from Tracking_IMP_CHB with(nolock)
GO
