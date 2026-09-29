SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE Procedure [dbo].[spCustomerCliente_Rel]--'BDP (CHARLOTTE)','1','1'
	@ID_CP int
as
--
--	set @cd_cliente = (select cd_pes from pessoa where apelido = @cliente)
--	
--	if @org <> ''
--		set @cd_org = (select cd_local from localidade where nome_local=@org)
--	else
--		set @cd_org = 'ALL'	
--	
--	if @dst <> ''
--		set @cd_dst = (select cd_local from localidade where nome_local=@dst)
--	else
--		set @cd_dst = 'ALL'

select AG.apelido nome,AG.nome_raz_soc nme_raz_soc, Ag.num_cpf_cnpj num_cpf_cnpj,LO.nome_local localorigem,LO.Cidade_local cidade, lo.pais_local pais, LD.nome_local localdestino, modal, data, A.apelido agente, SA.apelido subagente, VE.nome_usuario vendedor, dt_vencimento, campo_obs, TS.Descr_Servico from customer_profile CP
	left join pessoa AG on AG.cd_pes=CP.cd_cliente
	left join localidade LO on LO.cd_local=CP.cd_org
	left join localidade LD on LD.cd_local=CP.cd_dst
	left join pessoa A on A.cd_pes = cp.cd_agente
	left join pessoa SA on SA.cd_pes=cp.cd_subagente
	left join usuario VE on VE.cd_usuario=cp.cd_vendedor
	join Tipo_Servico_CP TS on CP.cd_tipo_servico = ts.cd_tipo_servico
where
	ID_CP = @ID_CP






GO
