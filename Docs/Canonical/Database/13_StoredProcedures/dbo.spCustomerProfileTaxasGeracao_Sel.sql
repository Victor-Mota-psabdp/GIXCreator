SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spCustomerProfileTaxasGeracao_Sel]
	
AS


select apelido,num_proc_him Num_Proc,cd_consig_him,nome_tp_Tx
,'C' DC_Compra,Nome_Tp_Moeda,CPT.Vlr_Venda from house_imp_mar hou
Join Pessoa_LLP PP on PP.cd_pes=cd_consig_him
Join Grupo GRP on GRP.cd_pes_grupo=pp.cd_pes_grupo
Join LLP_Imp_Mar LLP on LLP.num_proc_lim=hou.num_proc_him
Join Customer_Profile CP on CP.cd_cliente=pp.cd_pes_grupo and cd_tipo_servico='C'
Left Join Geracao_Cta_Cte_Log Clog on hou.num_proc_him=Clog.num_proc
Join customer_profile_taxas CPT on CPT.id_cp=CP.id_cp
Join Tipo_Taxa TT on TT.cd_tp_Tx=CPT.cd_tp_Tx
Join Tipo_Moeda TM on TM.cd_tp_moeda=Cd_Tp_moeda_Venda
Join Pessoa CS on cd_consig_him=cs.cd_pes
Where
	CLOG.num_proc is null


GO
