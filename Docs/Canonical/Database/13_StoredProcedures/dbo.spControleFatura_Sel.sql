SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spControleFatura_Sel]--'900001/2012'

	 @controle varchar(15)

as 
	select 
		CONVERT(VARCHAR(12),dt_rcto_fatura,103) dt_rcto_fatura,
		--dt_rcto_fatura,
		CONVERT(VARCHAR(12),dt_envio_cliente,103) dt_envio_cliente, 
		--dt_envio_cliente,		
		valor,
		TM.nome_tp_moeda, 
		Paridade,
		valor_brl,
		responsabilidade_bdp,
		periodo,
		periodo_bdp,
		contato_cliente,
		analise,
		TC.nome_doc tipo_cobranca,
		P.apelido Fornecedor,
		num_fatura,		
		CONVERT(VARCHAR(12),dt_vcto_fatura,103) dt_vcto_fatura,		
		--dt_vcto_fatura,
		num_proc,
		periodo_inicial,
		periodo_final,
		CF.cd_protocolo Protocolo,
		CFP.dt_creacao,
		U.nome_usuario,
		TRC.Reason_descr		
	from controle_fatura CF
		join tipo_moeda TM on TM.cd_tp_moeda = CF.cd_tp_moeda
		join pessoa P on P.cd_pes = CF.cd_fornecedor
		join tipo_Cobranca_Controle_Fatura TC on TC.id_dc = CF.cd_tipo
		left join controle_fatura_protocolo CFP on cfp.cd_protocolo = CF.cd_protocolo
		left join usuario U on U.cd_usuario = CFP.cd_usuario
		left join Tipo_reason_code TRC on TRC.cd_reason = CF.cd_reason
	where
		CF.cd_controlefatura = @controle
	
GO
