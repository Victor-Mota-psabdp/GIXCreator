SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE Procedure [dbo].[spReportManagerAtualiza_InsUPD]

AS

Declare	@Cd_Grupo	varchar(50)
Declare	@Job_Number	varchar(16)
Declare	@PO_Number_Concat	varchar(50)
Declare	@Sales_Order_Concat	varchar(50)
Declare	@CNPJ	varchar(14)
Declare	@Shipper	varchar(50)
Declare	@Consignee	varchar(50)
Declare	@ETA	datetime
Declare	@ATA	datetime
Declare	@ETD	datetime
Declare	@ATD	datetime
Declare	@Dt_Despacho	datetime
Declare	@Cod_Produto	varchar(50)
Declare	@Descricao_Produto	varchar(200)
Declare	@Value_Center	varchar(50)
Declare	@Origem	varchar(40)
Declare	@Destino	varchar(40)



Declare cTemp cursor for
			
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

	open cTemp
	fetch next from cTemp into @cd_Grupo,@CNPJ,@Job_Number,@ETA,@ETD,@Dt_despacho,@origem,@Destino,@Shipper,@Consignee,@Cod_Produto,@Descricao_Produto,@ATA,@ATD,@PO_Number_Concat,@Sales_Order_Concat,@Value_Center

	While @@Fetch_Status=0
		Begin
			print @Cd_Grupo 
			exec ReportManager.dbo.[spDadosProdutoLinha_InsUpd] @Cd_Grupo,	@Job_Number,	@PO_Number_Concat,	@Sales_Order_Concat,	@CNPJ,	@Shipper,	@Consignee,	@ETA,	@ATA,	@ETD,	@ATD,	@Dt_Despacho,	@Cod_Produto,	@Descricao_Produto,	@Value_Center,	@Origem,	@Destino
			fetch next from cTemp into @cd_Grupo,@CNPJ,@Job_Number,@ETA,@ETD,@Dt_despacho,@origem,@Destino,@Shipper,@Consignee,@Cod_Produto,@Descricao_Produto,@ATA,@ATD,@PO_Number_Concat,@Sales_Order_Concat,@Value_Center

		End
	close ctemp
	deallocate cTemp




GO
