SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE Procedure [dbo].[spCustomerProcura_Sel]--'1','%','%','%'
	@ID_CP		int,
	@nome_cliente varchar(30),
	@nome_origem varchar(30),
	@nome_destino varchar(30)
as
	if @ID_CP is null
		Begin
			select CP.ID_CP, AP.apelido apelido, LO.nome_local origin, LD.nome_local destination, modal,data, AG.apelido agente, SA.apelido subagente, VE.nome_usuario vendedor, dt_vencimento, campo_obs,Prazo, Descr_Servico, Dias from customer_profile CP
			join pessoa AP on AP.cd_pes=CP.cd_cliente
			left outer join localidade LO on LO.cd_local=CP.cd_org
			left outer join localidade LD on LD.cd_local=CP.cd_dst
			left outer join pessoa AG on AG.cd_pes=CP.cd_agente
			left outer join pessoa SA on SA.cd_pes=cp.cd_subagente
			left outer join usuario VE on VE.cd_usuario=cp.cd_vendedor
			join Tipo_Servico_cp TS on CP.Cd_tipo_servico = TS.Cd_Tipo_Servico
		where
			AP.apelido like @nome_cliente and
			LO.nome_local like @nome_origem and
			LD.nome_local like @nome_destino
		End
	else

		Begin
			select CP.ID_CP, AP.apelido apelido, LO.nome_local origin, LD.nome_local destination, modal,data, AG.apelido agente, SA.apelido subagente, VE.nome_usuario vendedor, dt_vencimento, campo_obs,Prazo, Descr_Servico, Dias from customer_profile CP
			join pessoa AP on AP.cd_pes=CP.cd_cliente
			left outer join localidade LO on LO.cd_local=CP.cd_org
			left outer join localidade LD on LD.cd_local=CP.cd_dst
			left outer join pessoa AG on AG.cd_pes=CP.cd_agente
			left outer join pessoa SA on SA.cd_pes=cp.cd_subagente
			left outer join usuario VE on VE.cd_usuario=cp.cd_vendedor
			join Tipo_Servico_cp TS on CP.Cd_tipo_servico = TS.Cd_Tipo_Servico
		where
			CP.ID_CP = @ID_CP
		End

		








GO
