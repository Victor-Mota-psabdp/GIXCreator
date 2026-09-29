SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spCustomerCliente_Sel] --'8'
	@ID_CP int
as

select 
	CL.Apelido Cliente,
	modal,
	data,
	ORG.Nome_Local Origem, 
	DST.Nome_Local Destino,
	AG.apelido agente, 
	SA.apelido subagente, 
	VE.nome_usuario vendedor, 
	dt_vencimento, 
	campo_obs,
	Prazo, 
	Dias, 
	Descr_Servico,
	CP.Contato Contato, 
	CP.Mercadoria Mercadoria, 
	CP.Peso_TN Peso_TN, 
	CP.Peso_CM3_M3 Peso_CM3_M3, 
	TC.Nome_Tp_Carga Tipo_Carga, 
	CP.Vlr_Venda Vlr_Venda,
	cast(TSC.id_status_cp as varchar(2)) + ' - ' + TSC.descr_status  Status,
	cast(TR.ID_Registro as varchar(2)) + ' - ' + TR.Descr_Registro Registro
from customer_profile CP with (nolock)
	left outer	join pessoa AG			with (nolock) on AG.cd_pes=CP.cd_agente
	left outer	join pessoa SA			with (nolock) on SA.cd_pes=cp.cd_subagente
	left outer	join usuario VE			with (nolock) on VE.cd_usuario=cp.cd_vendedor
				join pessoa CL			with (nolock) on CP.Cd_Cliente = CL.cd_pes
				join tipo_servico_CP TS with (nolock) on CP.Cd_tipo_servico = TS.Cd_Tipo_Servico
	left outer	join Localidade ORG		with (nolock) on CP.cd_Org=ORG.cd_local
	left outer	join Localidade DST		with (nolock) on CP.cd_DST=DST.cd_local
	left outer	join tipo_status_cp TSC with (nolock) on tsc.id_status_cp = CP.id_status_cp
	left outer	join Tipo_Registro TR	with (nolock) on TR.ID_Registro = CP.ID_Registro
	left outer	join Tipo_Carga TC		with (nolock) on CP.Tipo_Carga = TC.Cd_Tp_Carga
where
	@ID_CP = ID_CP


GO
