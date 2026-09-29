SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE Procedure  [dbo].[spNFWalMartTXT_Sel]

as

select 
		NC.ID_NF,
		NC.Cd_Cliente,
		EEM.UF UF_EM,
		Emissao,
		right(PEM.Num_CPF_CNPJ,14) CNPJ_EM, 
		Serie,
		Nota_fiscal,
		TP.Dt_Conclusao Dt_Entrada, 
		NC.Cd_IBGE_Municipio_Gerador,
		PEM.Nome_Raz_Soc Nome_Raz_Soc_EM,
		PEM.Apelido Apelido_EM,
		EEM.Rua Rua_EM,
		EEM.Numero Numero_EM,
		EEM.Compl_End Compl_End_EM,
		EEM.Bairro Bairro_EM,
		NC.Cd_IBGE_Municipio_Emitente,
		EEM.Cidade Cidade_EM,
		'0' + EEM.CEP CEP_EM,
		CMEM.Cd_Area_Fone + CMEM.Prefixo + CMEM.Num_Fone Fone_EM,
		isnull(PEM.Num_RG_IE,'') Num_RG_IE_EM,
		isnull(right(PEM.Num_CPF_CNPJ,14),'') CNPJ_DST,
		PDST.Nome_Raz_Soc Nome_Raz_Soc_DST,
		EDST.Rua Rua_DST,
		EDST.Numero Numero_DST,
		EDST.Compl_End Compl_End_DST,
		EDST.Bairro Bairro_DST,
		NC.Cd_IBGE_Municipio_Destinatario,
		EDST.Cidade Cidade_DST,
		EDST.UF UF_DST,
		'0' + EDST.CEP CEP_DST,
		EDST.Pais Pais_DST,
		NC.Cd_Pais_BACEN,
		CMDST.Cd_Area_Fone + CMDST.Prefixo + CMDST.Num_Fone Fone_DST,
		isnull(PDST.Num_RG_IE,'') Num_RG_IE_DST,
		isnull(NC.Vlr_Tot_ICMS,0) Vlr_Tot_ICMS,
		isnull(NC.Vlr_Tot_Base_ICMS_ST,0) Vlr_Tot_Base_ICMS_ST,
		isnull(NC.Vlr_Tot_ICMS_ST,0) Vlr_Tot_ICMS_ST,
		isnull(NC.Vlr_Tot_Prod_Serv,0) Vlr_Tot_Prod_Serv,
		isnull(NC.Vlr_Tot_Frete,0) Vlr_Tot_Frete,
		isnull(NC.Vlr_Tot_Seguro,0) Vlr_Tot_Seguro,
		isnull(NC.Vlr_Tot_Desconto,0) Vlr_Tot_Desconto,
		isnull(NC.Vlr_Tot_IPI,0) Vlr_Tot_IPI,
		isnull(NC.Vlr_Tot_PIS,0) Vlr_Tot_PIS,
		isnull(NC.Vlr_Tot_Cofins,0) Vlr_Tot_Cofins,
		isnull(NC.Vlr_Tot_Outras_Desp,0) Vlr_Tot_Outras_Desp,
		isnull(NC.Vlr_NF,0) Vlr_NF,
		isnull(NC.Info_Complementar,'') Info_Complementar,
		isnull(PO.Numero_PO_HIM,'') Pedido,
		isnull(right(TRP.Num_CPF_CNPJ,14),'') CNPJ_Transp,
		TRP.Nome_Raz_Soc Nome_Raz_Soc_Transp,
		isnull(TRP.Num_RG_IE,'') Num_RG_IE_EM,
		ETRP.Rua + ' ' + ETRP.Numero + ' - '+ ETRP.Compl_End + ' - ' + ETRP.Bairro End_Compl_Transp,
		ETRP.Cidade Cidade_Transp,
		ETRP.UF UF_Transp,
		replace(NC.CFOP,'.','') CFOP,
		isnull(DI.Numero_PO_HIM,'') Num_DI,
		isnull(DI.Data_PO_HIM,'') Data_DI,
		dbo.fBusca_CampoCliente(NC.Num_Proc,25) Local_Desembaraco
		
from 
		nota_cliente NC with(nolock)
		left outer join pessoa_llp PLLP with(nolock) on NC.cd_cliente = PLLP.cd_pes
		left outer join pessoa PEM with(nolock) on NC.cd_cliente = PEM.cd_pes
		left outer join endereco EEM with(nolock) on NC.cd_cliente = EEM.cd_pes
		left outer join tarefas_processos TP with(nolock) on NC.Num_proc = TP.Num_Proc and TP.id_task = 13
		left outer join comunicacao CMEM with(nolock) on NC.cd_cliente = CMEM.cd_pes and CMEM.cd_tp_com = 'TC1'
		left outer join house_imp_mar HOU with(nolock) on NC.Num_proc = HOU.Num_Proc_him
		left outer join pessoa PDST with(nolock) on HOU.Cd_Export_Him = PDST.cd_pes  
		left outer join endereco EDST with(nolock) on HOU.Cd_Export_Him = EDST.cd_pes
		left outer join comunicacao CMDST with(nolock) on HOU.Cd_Export_Him = CMDST.cd_pes and CMDST.cd_tp_com = 'TC1'
		left outer join PO_HIM PO with(nolock) on NC.Num_Proc = PO.Num_proc_him and PO.ID_DC = 1
		left outer join Pessoa TRP with(nolock) on NC.Cd_Transp = TRP.cd_pes
		left outer join endereco ETRP with(nolock) on NC.Cd_Transp = ETRP.cd_pes
		left outer join PO_HIM DI with(nolock) on NC.Num_Proc = PO.Num_proc_him and PO.ID_DC = 5
where PLLP.cd_pes_grupo = 'P16851'


GO
