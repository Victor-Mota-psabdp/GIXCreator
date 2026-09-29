SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure spATLReportTransportationValues_Rel
		
		@Shipper as varchar(40),
		@Consignee as varchar(40)

		AS


select 
	H.Num_Proc [Job],
	B.Nome_BDP_Produto [BDP Product],
	H.Master [Consol Ref.],
	SH.Nome_Raz_Soc [Shipper],
	CN.Nome_Raz_Soc [consignee],
	CN.Num_CPF_CNPJ [CNPJ],
	org.Nome_Local [POL],
	dst.Nome_Local [POD],
	h.Cd_Tp_Oper [Incoterm],
	PP.Nome_Raz_Soc [Credor/Debitor],
	cta.DC_HIA [D/C],
	cta.cd_tp_moeda [Currency],
	cta.Vlr_Org_HIA [Original Value],
	TSP.Status_Descricao [Status of Job]

 from 
	vwhouse_imp H
	join campo_processo CP 
		with(nolock) on  h.Num_Proc=CP.Num_Proc and Campo_Dados >1 and CP.Id_Campo=143
	Join BDP_Produto B 
		with(nolock) on B.id_pd=campo_dados
	join vwcta_cte cta 
		on cta.Num_Proc_HIA=h.Num_Proc and Cd_Cred_Dev_HIA<>Cd_Consig
	Join tipo_taxa tt 
		with (nolock) on tt.cd_tp_tx=cta.cd_tp_Tx
	Join Pessoa pp 
		with (nolock) on pp.cd_pes=Cd_Cred_Dev_HIA
	Join Pessoa CN 
		with(nolock) on cN.cd_pes=Cd_Consig
	join Pessoa 
		sh with(nolock) on sh.Cd_Pes=Cd_Export
	Join Localidade org 
		with(nolock) on org.Cd_Local=cd_org
	Join Localidade dst 
		with(nolock) on dst.Cd_Local=cd_dst
	Left join Tipo_Status_Processo TSP 
		with(nolock) on h.ID_Status=TSP.ID_Status

where
	eta >=getdate()-180
	and 
		(CN.Apelido like @Consignee or @Consignee='ALL')
	and
		(SH.Apelido like @Consignee or @Shipper='ALL')
		

Union all

select 
	H.Num_Proc [Job],
	B.Nome_BDP_Produto [BDP Product],
	H.Master [Consol Ref.],
	SH.Nome_Raz_Soc [Shipper],
	CN.Nome_Raz_Soc [consignee],
	CN.Num_CPF_CNPJ [CNPJ],
	org.Nome_Local [POL],
	dst.Nome_Local [POD],
	h.Cd_Tp_Oper [Incoterm],
	PP.Nome_Raz_Soc [Credor/Debitor],
	cta.DC_HIA [D/C],
	cta.cd_tp_moeda [Currency],
	cta.Vlr_Org_HIA [Original Value],
	TSP.Status_Descricao [Status of Job]


 from vwhouse_exp H
	join campo_processo CP 
		with(nolock) on  h.Num_Proc=CP.Num_Proc and Campo_Dados >1 and CP.Id_Campo=143
	Join BDP_Produto B 
		with(nolock) on B.id_pd=campo_dados
	join vwcta_cte cta 
		on cta.Num_Proc_HIA=h.Num_Proc and Cd_Cred_Dev_HIA<>Cd_Consig
	Join tipo_taxa tt 
		with (nolock) on tt.cd_tp_tx=cta.cd_tp_Tx
	Join Pessoa pp 
		with (nolock) on pp.cd_pes=Cd_Cred_Dev_HIA
	Join Pessoa CN 
		with(nolock) on cN.cd_pes=Cd_Consig
	join Pessoa 
		sh with(nolock) on sh.Cd_Pes=Cd_Export
	Join Localidade org 
		with(nolock) on org.Cd_Local=cd_org
	Join Localidade dst 
		with(nolock) on dst.Cd_Local=cd_dst
	Left join Tipo_Status_Processo TSP 
		with(nolock) on h.ID_Status=TSP.ID_Status
where

	eta >=getdate()-180
	and 
		(CN.Apelido like @Consignee or @Consignee='ALL')
	and
		(SH.Apelido like @Consignee or @Shipper='ALL')

GO
