SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[spATL_HIO_Sel]'IOCOV200900010BR','T',''
--select * from LLP_Imp_Out where tipo_Lio = ''
CREATE PROCEDURE [dbo].[spATL_HIO_Sel]
(
	@Num_Proc		VarChar(16),
	@Tipo_Lio		Char(1),
	@Tipo			char(1)
)
AS

--if @Tipo = 'A' or @Tipo = 'B'
	Begin
		Select  
	--House_IMP_out
			HOU.Num_Proc_HIO		[JOB],
			LLP.Intl_Ref_Lio		[Intl Reference],
			-- HOU.Dt_Emis_HIO			[Register Date],
            convert(datetime, Dt_Emis_HIO,103) [Register Date],	
			HOU.MAWB_HIO			[MAWB Number],
			HOU.HAWB_HIO			[HAWB Number],			
			HOU.Cd_Export_HIO		[Shipper Code],
			Ship.Apelido 			[Shipper Name],
			Hou.Cd_Consig_HIO		[Consignee Code],
			Consig.Apelido 			[Consignee Name],
			Hou.Cd_Import_HIO		[Notify Code],
			Import.Apelido 			[Notify Name],
			LLP.Cd_Planta_Lio		[Origin Code],
			Origin.Nome_Local 		[Origin Name],
			Hou.Cd_Org_HIO			[Loading Code],
			Loading.Nome_Local 		[Loading Name],
			hou.Cd_Dst_HIO			[Discharge Code],
			Discharge.Nome_Local 	[Discharge Name],
			llp.Cd_DstFinal_Lio		[Final Destination Code],
			DstFinal.Nome_Local		[Final Destination Name],
			LLP.Cd_Carrier			[Carrier Code],
			Carrier.Apelido			[Carrier Name],	
				
			HOU.Voo_HIO 			[Voyage],
			
			LLP.ETD_LIO				[ETD],
			LLP.ATD_LIO				[ATD],
			LLP.ETA_LIO				[ETA],
			LLP.ATA_LIO				[ATA],
			
			HOU.Qtd_Tot_Vol_HIO		[Nº of Pieces],
			HOU.Peso_Real_HIO	[Net Weight (KG)],
			HOU.Peso_Bruto_HIO		[Gross Weight (KG)],
			HOU.Vol_Tot_HIO			[Volume(m3)],
			
			HOU.Cd_Tp_Moeda			[Currency Code],
			TM.Nome_Tp_Moeda		[Currency Name],
			HOU.Vlr_Frete_efet_HIO	[Freight Value],
			HOU.Tp_Frete_HIO		[Freight Term Code],
			FreteType.Nome_Tp_Frete	[Freight Term Name],
			HOU.Obs_HIO				[Nature and Quality of Goods],
			LLP.Original_ETA_Lio	[Original ETA],
			SAP_ShipNumber			[SAP Number],
			LLP.Cd_Despachante		[CHB Code],
			CHB.Apelido 			[CHB Name],
			HOU.Cd_Tp_Oper			[Incoterm Code],
			TP.Nome_tp_Oper			[Incoterm Name],
			HOU.TTime_d				[Transit Time],
			LLP.Canal_Lio			[Channel],			
			LLP.Cd_Agente			[Agent Code],
			Agente.Apelido			[Agent Name],
			LLP.Cd_Vendedor			[Sales Code],
			Sales.Nome_Usuario		[Sales Name],
			LLP.Cd_Usuario			[Customer Code],
			CSR.Nome_Usuario		[Customer Name],
			LLP.Cd_Terminal			[Terminal Code],
			TERM.Nome_Terminal		[Terminal Name],
			LLP.Cd_Order			[Order Code],
			OD.Apelido				[Order Name],
			LLP.Cd_Forwarder		[Forwarder Code],
			Forwarder.Apelido		[Forwarder Name],
			LLP.Cd_Courier			[Courier Code],
			Courier.Apelido 		[Courier Name],
			LLP.Courier_Number_LIO 	[Courier Number],
			LLP.Cd_Transportadora 	[Inland Trucker Code],
			Transp.Apelido			[Inland Trucker Name],
			Vlr_Invoice				[Invoice Value],
			LLP.Cd_Moeda_Invoice	[Currency Invoice Code],
			TM_INV.Nome_Tp_Moeda	[Currency Invoice Name],
			LLP.DL_Cargo_LIO		[Dead Line Cargo],
			LLP.id_status			[Status Code],
			Status.Status_Descricao 	[Status Name],
			Descr.Descr 			[Description and Goods],
			Descr.Header 			[Description and Goods Header],					
			isnull(LLP.PO_Req_Date,LLP.ETA_LIO+10) [PO Req. Del. Date],
			LLP.MultiModal, --not used
			Modal.cd_tp_modal		[Modal Code],
			Modal.Nome_Tp_Modal		[Modal Name],
			
			LLP.Tipo_Lio			[Others Modal Code],
			RT.Modal				[Others Modal Name],
				
			LLP.Peso_Cubado_LIO		[Charg. Weight (KG)],		
			
			--cd_cliente,
			--BDP_OFFICE.Apelido BDPOffice,		
			--ImportDate.Dt_Conclusao ImportDate,
			--ExportDate.Dt_Conclusao ExportDate

			NULL					[Consol Reference],
			
			PLLP.Cd_Pes_grupo 		[Group Code],
			PG.Apelido				[Group Name]
		From  
			House_IMP_OUT HOU with(nolock)
			Left Outer Join LLP_IMP_OUT	LLP			with(nolock) on HOU.Num_proc_HIO = LLP.Num_proc_LIO
			Left Outer Join Pessoa		Ship		with(nolock) on Cd_Export_HIO = Ship.Cd_Pes	
			Left Outer Join Pessoa		Consig		with(nolock) on Cd_Consig_HIO = Consig.Cd_Pes 
			
			Left Outer Join Pessoa_llp	PLLP		with(nolock) on HOU.Cd_Consig_HIO = PLLP.Cd_Pes
			Left Outer Join Pessoa		PG			with(nolock) on PG.Cd_Pes = PLLP.Cd_Pes_grupo
			
			Left Outer Join Pessoa		Import		with(nolock) on Cd_Import_HIO = Import.Cd_Pes
			Left Outer Join Pessoa		CHB			with(nolock) on LLP.Cd_Despachante = CHB.Cd_Pes	
			Left Outer Join Localidade	Loading		with(nolock) on Cd_Org_HIO = Loading.Cd_Local 
			Left Outer Join Localidade	Discharge	with(nolock) on Cd_Dst_HIO = Discharge.Cd_Local 
			Left Outer Join Localidade	Origin		with(nolock) on LLP.cd_Planta_LIO = Origin.cd_local
			Left Outer Join Localidade	DstFinal	with(nolock) on LLP.cd_dstfinal_LIO = Dstfinal.cd_local
			Left Outer Join Pessoa		Carrier		with(nolock) on LLP.Cd_Carrier = Carrier.Cd_Pes
			Left Outer Join Tipo_Frete  FreteType	with(nolock) on FreteType.cd_tp_frete	=HOU.Tp_Frete_HIO
							
			Left Outer Join Pessoa		Agente		with(nolock) on LLP.Cd_Agente = Agente.Cd_Pes
			Left Outer Join Pessoa		Forwarder	with(nolock) on LLP.Cd_Forwarder = Forwarder.Cd_Pes
			Left Outer Join Usuario		Sales		with(nolock) on LLP.Cd_Vendedor = Sales.Cd_Usuario
			Left Outer Join Usuario		CSR			with(nolock) on LLP.Cd_Usuario = CSR.Cd_Usuario
			
			Left Outer Join Tipo_Moeda	TM			with(nolock) on HOU.Cd_Tp_Moeda = TM.Cd_Tp_Moeda
			Left Outer Join Tipo_Moeda	TM_INV		with(nolock) on LLP.Cd_Moeda_Invoice = TM_INV.Cd_Tp_Moeda
			Left Outer Join Pessoa		OD			with(nolock) on LLP.Cd_Order = OD.Cd_Pes
			Left Outer Join Terminal	TERM		with(nolock) on LLP.Cd_Terminal = TERM.Cd_Terminal
			Left Outer Join Pessoa		Courier		with(nolock) on LLP.Cd_Courier = Courier.Cd_Pes
			Left Outer Join Tipo_Oper	TP			with(nolock) on HOU.cd_tp_oper = TP.Cd_tp_oper
			Left Outer Join Pessoa		Transp		with(nolock) on LLP.Cd_Transportadora = Transp.Cd_Pes
			Left Outer Join Nature_Goods Descr		with(nolock) on HOU.Num_proc_hio = Descr.Num_Proc
			Left Outer Join Tipo_Status_Processo Status with(nolock) on STatus.id_status=LLP.id_status		
			Left Outer Join Tipo_Modal_Imp_Exp Modal with(nolock) on Modal.cd_tp_modal	= left(HOU.num_proc_hio,2)
			Left Outer Join Tipo_Modal RT with(nolock) on RT.Id	= LLP.Tipo_Lio
	
			--Left Outer Join Pessoa		BDP_OFFICE		on LLP.Cd_Office = BDP_OFFICE.Cd_Pes
			--Left Outer Join Tarefas_Processos ImportDate on Hou.Num_Proc_HIO=ImportDate.Num_Proc and ImportDate.id_task=245
			--Left Outer Join Tarefas_Processos ExportDate on Hou.Num_Proc_HIO=ExportDate.Num_Proc and ExportDate.id_task=245
		Where
			HOU.Num_Proc_HIO= @Num_Proc --and Tipo_Lio = @Tipo_Lio

	END

GO
