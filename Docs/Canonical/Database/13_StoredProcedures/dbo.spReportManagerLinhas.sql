SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spReportManagerLinhas]


as


select 
	cd_pes_grupo,right(SHP.num_cpf_CNPJ,14) CNPJ,Num_Proc_Lem Job, ETA_LEM ETA, ETD_LEM ETD,dt_conclusao Desembaraco,org.nome_local Origem,
	dst.nome_local Destino,SHP.Nome_Raz_Soc Shipper,CNS.Nome_Raz_Soc Consignee,
	cd_proc_cliente CodProd, produto_descr,ATA_Lem ATA, ATD_LEM ATD,dbo.fBusca_TipoDocCliente('N',num_proc_lem,1) PO_Number,
	dbo.fBusca_TipoDocCliente('N',num_proc_lem,3) Sales_Order,Business_Group_descr Value_Center
	
from 
	LLP_Exp_Mar
	Left Join Tarefas_Processos TP on TP.num_proc=num_proc_lem and id_task=4
	Join House_Exp_Mar HOU on hou.num_proc_hem=num_proc_lem
	Join Localidade Org on Org.cd_local=cd_org_hem	
	Join Localidade Dst on Dst.cd_local=cd_dst_hem
	Join Pessoa SHP on SHP.cd_pes=cd_export_hem
	Join Pessoa CNS on CNS.cd_pes=cd_consig_hem
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_export_hem
	Join Pedido_Ship PS on PS.num_proc=num_proc_lem
	Join Produto_Cliente PC on PC.cd_prod=PS.cd_produto
	Join De_Para_Produto DPP on cd_proc_cliente=GMID
Where
	Num_Proc_Lem in
			(
				Select distinct excprocesso from exchange 
				Where
					excdtenvio between getdate()-1 and getdate()

			)






GO
