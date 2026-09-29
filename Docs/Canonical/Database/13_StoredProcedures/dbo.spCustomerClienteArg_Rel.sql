SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spCustomerClienteArg_Rel]--'156'
	@ID_CP int
as

select distinct CP.ID_CP,CP.Contato, CP.Mercadoria, AG.nome_raz_soc razon_social,En.CEP, En.Rua, En.Numero,En.Compl_End,En.Bairro, en.Cidade,  En.Pais,TEL.Prefixo, TEL.Num_Fone,
		LO.cidade_local localorigem,LO.pais_local pais_Local, LD.cidade_local localdestino,LD.Pais_Local Pais_Destino, modal, convert(varchar(10),data,103) Data, A.apelido agente, SA.apelido subagente, VE.nome_usuario vendedor,DEP.Nome_Area Area,VE.Email, convert(varchar(10),dt_vencimento,103) Dt_Vencimento, campo_obs, TS.Descr_Servico 
from customer_profile CP
	left join Customer_profile_taxas CPT on CPT.id_cp=CP.id_cp
	left join pessoa AG on AG.cd_pes=CP.cd_cliente
	left join Endereco En on  EN.cd_pes = AG.cd_pes and cd_tp_end = 'COM'
	left join localidade LO on LO.cd_local=CP.cd_org
	left join localidade LD on LD.cd_local=CP.cd_dst
	left join pessoa A on A.cd_pes = cp.cd_agente
	left join pessoa SA on SA.cd_pes=cp.cd_subagente
	left join usuario VE on VE.cd_usuario=cp.cd_vendedor
	left join Area DEP on DEP.cd_Area = VE.cd_Area
	join Tipo_Servico_CP TS on CP.cd_tipo_servico = ts.cd_tipo_servico
	join Comunicacao TEL on TEL.cd_pes = A.cd_pes
	 
where
	CP.ID_CP = @ID_CP







GO
