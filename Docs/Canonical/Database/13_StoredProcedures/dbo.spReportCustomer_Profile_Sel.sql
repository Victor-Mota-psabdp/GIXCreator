SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spReportCustomer_Profile_Sel] --'COMANDO AER'
(
	@Pessoa varchar(20)
)
AS

set @Pessoa = ( select top 1 Apelido from Pessoa P join Customer_Profile CP with(nolock) on P.cd_pes = CP.Cd_Cliente where apelido = @Pessoa)
select 
CP.ID_CP [ID CP],
P.Apelido [Cliente],
CP.Modal,
CP.Data [Data de Criação CP],
(Case
		when Org.Nome_Local = 'Allentown' then 'All'
		Else Org.Nome_Local
end) [Origem],
(Case
		when Dst.Nome_Local = 'Allentown' then 'All'
		Else Dst.Nome_Local
end) [Destino],
Age.Apelido [Agente],
Sub.Apelido [Sub Agente],
U.Nome_Usuario [Nome Usuario],
CP.Dt_Vencimento [Data de Vencimento CP],
CP.Campo_Obs [Observação],
CP.Prazo,
CP.Dias,
TS.Descr_Servico [Serviço],
CP.Contato,
CP.Mercadoria,
CP.Peso_TN [Peso em TN],
CP.Peso_CM3_M3 [Peso CM³_M³],
TC.Nome_Tp_Carga [Tipo Carga],
CP.Vlr_Venda [Valor],
SCP.Descr_Status [Status],
CP.ID_Registro [ID Registro]

from Customer_Profile CP with(nolock)
Join Pessoa P with(nolock) on CP.Cd_Cliente = P.Cd_Pes
Join Localidade Org with(nolock) on CP.Cd_Org = Org.Cd_Local
Join Localidade Dst with(nolock) on CP.Cd_Dst = Dst.Cd_Local
left join Pessoa Age with(nolock) on CP.Cd_Agente = Age.Cd_Pes
left join Pessoa Sub with(nolock) on CP.Cd_Agente = Sub.Cd_Pes
left Join Usuario U with(nolock) on Cp.Cd_Usuario = U.Cd_Usuario
left Join Tipo_Servico_CP TS with(nolock) on CP.Cd_Tipo_Servico = TS.Cd_Tipo_Servico
left join Tipo_Carga TC with(nolock) on CP.Tipo_Carga = TC.Cd_Tp_Carga
Join tipo_status_cp SCP with(nolock) on CP.ID_Status_CP = SCP.ID_Status_CP

where P.Apelido = @Pessoa

order by

CP.ID_CP

OPTION (HASH JOIN)
GO
