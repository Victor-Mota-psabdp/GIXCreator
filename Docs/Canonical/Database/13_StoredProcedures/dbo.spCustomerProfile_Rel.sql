SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spCustomerProfile_Rel]--'2011-01-01','2011-05-10','0'
	@Dt_Inicial	datetime,
	@Dt_Final	datetime,
	@vendedor	varchar(6)
as

if @vendedor <> '0'  
	Begin
		select CP.id_cp,AG.apelido nome,LO.Cidade_local origin, 
			LD.nome_local destino, modal,VE.nome_usuario vendedor, dt_vencimento, campo_obs, 
			TS.Descr_Servico Descr_Servico,tsc.descr_status status from customer_profile CP
			left join pessoa AG on AG.cd_pes=CP.cd_cliente
			left join localidade LO on LO.cd_local=CP.cd_org
			left join localidade LD on LD.cd_local=CP.cd_dst	
			left join usuario VE on VE.cd_usuario=cp.cd_vendedor
			join Tipo_Servico_CP TS on CP.cd_tipo_servico = ts.cd_tipo_servico
			left join tipo_status_cp TSC on CP.id_status_cp = tsc.id_status_cp
		where cp.data between @Dt_Inicial and @Dt_Final
				and cp.cd_vendedor = @vendedor
		order by CP.id_cp
	End
else
	Begin
		select CP.id_cp,AG.apelido nome,LO.Cidade_local origin, 
			LD.nome_local destino, modal,VE.nome_usuario vendedor, dt_vencimento, campo_obs, 
			TS.Descr_Servico Descr_Servico,tsc.descr_status status from customer_profile CP
			left join pessoa AG on AG.cd_pes=CP.cd_cliente
			left join localidade LO on LO.cd_local=CP.cd_org
			left join localidade LD on LD.cd_local=CP.cd_dst	
			left join usuario VE on VE.cd_usuario=cp.cd_vendedor
			join Tipo_Servico_CP TS on CP.cd_tipo_servico = ts.cd_tipo_servico
			left join tipo_status_cp TSC on CP.id_status_cp = tsc.id_status_cp
		where cp.data between @Dt_Inicial and @Dt_Final				
		order by CP.id_cp
	End
		










GO
