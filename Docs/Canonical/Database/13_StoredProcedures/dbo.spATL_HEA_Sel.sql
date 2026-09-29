SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spATL_HEA_Sel] 
(
	@Num_Proc	VarChar(16),
	@Tipo		char(1)
)
AS

--if @Tipo = 'A' or @Tipo = 'B'
	Begin
		Select		
			HOU.Num_Proc_HEA		[JOB],
			LLP.Intl_Ref_LEA		[Intl Reference],
			-- HOU.Dt_Emis_HEA			[Register Date],
            convert(datetime, Dt_Emis_HEA,103) [Register Date],				
			HOU.MAWB_HEA			[MAWB Number],
			HOU.HAWB_HEA			[HAWB Number],
			Modal.cd_tp_modal		[Modal Code],
			Modal.Nome_Tp_Modal		[Modal Name],						
			HOU.Cd_Export_HEA		[Shipper Code],
			Ship.Apelido 			[Shipper Name],
			HOU.Cd_Consig_HEA		[Consignee Code],
			Consig.Apelido 			[Consignee Name],
			HOU.Cd_Notify_HEA		[Notify Code],
			Export.Apelido 			[Notify Name],
			LLP.Cd_planta_LEA		[Origin Code],
			Origin.Nome_Local 		[Origin Name],
			HOU.Cd_Org_HEA			[Loading Code],
			Loading.Nome_Local 		[Loading Name],
			HOU.Cd_Dst_HEA			[Discharge Code],
			Discharge.Nome_Local 	[Discharge Name],
			llp.Cd_DstFinal_LEA		[Final Destination Code],
			DstFinal.Nome_Local		[Final Destination Name],
			HOU.Cd_Cia_Aer			[Air Company Code],
			CiaAER.Nome_Cia_Aer		[Air Company Name],
			HOU.Voo_HEA				[Voyage],
			LLP.ETD_LEA				[ETD],
			LLP.ATD_LEA				[ATD],
			LLP.ETA_LEA				[ETA],
			LLP.ATA_LEA				[ATA],			
			HOU.Qtd_Tot_Vol_HEA		[Nº of Pieces],
			HOU.Peso_Real_HEA		[Net Weight (KG)],
			HOU.Peso_Bruto_HEA		[Gross Weight (KG)],
			LLP.Peso_Cubado_LEA		[Charg Weight (KG)],
			HOU.Vol_Tot_HEA			[Volume(m3)],
			HOU.Cd_Tp_Moeda			[Currency Code],
			TM.Nome_Tp_Moeda		[Currency Name],
			HOU.Vlr_Frete_Tot_HEA	[Freight Value],
			HOU.Tp_Frete_HEA		[Freight Term Code],
			FreteType.Nome_Tp_Frete	[Freight Term Name],
			HOU.Obs_HEA				[Nature and Quality of Goods],		
			LLP.Original_ETA_LEA	[Original ETA],						
			SAP_ShipNumber			[SAP Number],
			Hou.Cd_Dsp_HEA			[CHB Code],
			CHB.Apelido 			[CHB Name],			
			HOU.Cd_Tp_Oper			[Incoterm Code],
			TP.Nome_tp_Oper			[Incoterm Name],
			TTime_d					[Transit Time],
			LLP.Canal_LEA			[Channel],
			JOB.Cd_Agente			[Agent Code],
			AG.Apelido				[Agent Name],
			JOB.Cd_Vendedor			[Sales Code],
			SAL.Nome_Usuario		[Sales Name],			
			JOB.Cd_Usuario			[Customer Code],
			CSR.Nome_Usuario		[Customer Name],
			LLP.Cd_Terminal			[Terminal Code],
			TERM.Nome_Terminal		[Terminal Name],
			LLP.Cd_Order			[Order Code],
			OD.Apelido				[Order Name],
			LLP.Cd_Forwarder		[Forwarder Code],
			FORW.Apelido			[Forwarder Name],
			LLP.Cd_Courier			[Courier Code],
			Courier.Apelido 		[Courier Name],
			LLP.Courier_Number_LEA 	[Courier Number],
			LLP.Cd_Transportadora 	[Inland Trucker Code],
			Transp.Apelido			[Inland Trucker Name],
			Vlr_Invoice				[Invoice Value],
			LLP.Cd_Moeda_Invoice	[Currency Invoice Code],
			TM_INV.Nome_Tp_Moeda	[Currency Invoice Name],
			LLP.DL_Cargo_LEA		[Dead Line Cargo],
			LLP.id_status			[Status Code],
			Status.Status_Descricao 	[Status Name],			
			--LLP.Nr_Reserva			[Reservation Number],
			Descr.Descr 			[Description and Goods],
			Descr.Header 			[Description and Goods Header],
			isnull(LLP.PO_Req_Date,LLP.ETA_LEA+10) [PO Req. Del. Date],
			LLP.MultiModal ,--not used
						
			HOU.Tx_Refer_HEA		[Exchanges Rate],			
			LLP.Net_Rates_LEA		[Net Rates],
			LLP.Selling_Rates_LEA	[Selling Rates],
			LLP.Comissao_Agente_Lea	[Agent Commission],
			LLP.Cd_Notify_2			[Notify 2 Code],
			NTF2.Apelido 			[Notify 2 Name],
			HAN.Hand_Hea_1			[Handling 1],
			HAN.Hand_HEA_2			[Handling 2],
			HAN.Hand_Hea_3			[Handling 3],
			
			JOB.Cd_Tp_Embal			[Packing Code],		
			Emb.Nome_Tp_Embal		[Packing Name],

			Num_Proc_MEA			[Consol Reference],
			PLLP.Cd_Pes_grupo 		[Group Code],
			PG.Apelido				[Group Name]

	From 
		House_exp_Aer HOU with(nolock) 
		Left Outer Join Job_Exp_Aer	JOB			with(nolock)	on HOU.Num_proc_HEA = JOB.Num_Proc_HEA
		Left Outer Join LLP_Exp_Aer	LLP			with(nolock) 	on HOU.Num_proc_HEA = LLP.Num_proc_LEA
		Left Outer Join Pessoa		Ship		with(nolock) 	on HOU.Cd_Export_HEA = Ship.Cd_Pes
		Left Outer Join Pessoa_llp	PLLP		with(nolock)		on HOU.Cd_Export_HEA = PLLP.Cd_Pes
		Left Outer Join Pessoa		PG			with(nolock)			on PG.Cd_Pes = PLLP.Cd_Pes_grupo
		Left Outer Join Pessoa		Consig		with(nolock) 	on HOU.Cd_Consig_HEA = Consig.Cd_Pes 
		Left Outer Join Pessoa		Export		with(nolock) 	on HOU.Cd_Notify_HEA = Export.Cd_Pes
		Left Outer Join Pessoa		CHB			with(nolock) 	on HOU.Cd_Dsp_HEA = CHB.Cd_Pes		
		Left Outer Join Localidade	Loading		with(nolock) 	on HOU.Cd_Org_HEA = Loading.Cd_Local 
		Left Outer Join Localidade	Discharge	with(nolock) 	on HOU.Cd_Dst_HEA = Discharge.Cd_Local
		Left Outer Join Localidade	Origin		with(nolock) 	on LLP.cd_Planta_LEA = Origin.cd_local
		Left Outer Join Localidade	DstFinal	with(nolock) 	on LLP.cd_dstfinal_LEA = Dstfinal.cd_local		
		Left Outer Join Cia_Aerea	CiaAER		with(nolock) 	on LLP.cd_CiaAerea_LEA = CiaAER.Cd_Cia_Aer
		Left Outer Join Tipo_Moeda	TM		with(nolock) 	on HOU.Cd_Tp_Moeda = TM.Cd_Tp_Moeda
		Left Outer Join Tipo_Moeda	TM_INV	with(nolock) 	on LLP.Cd_Moeda_Invoice = TM_INV.Cd_Tp_Moeda
		Left Outer Join Terminal 	TERM	with(nolock) 	on LLP.Cd_Terminal = TERM.Cd_Terminal
		Left Outer Join Pessoa		AG		with(nolock) 	on JOB.Cd_Agente = AG.Cd_Pes
		Left Outer Join Pessoa		FORW	with(nolock) 	on LLP.Cd_Forwarder = FORW.Cd_Pes
		Left Outer Join Usuario		SAL		with(nolock) 	on JOB.Cd_Vendedor = SAL.Cd_Usuario
		Left Outer Join Usuario		CSR		with(nolock) 	on JOB.Cd_Usuario = CSR.Cd_Usuario
		Left Outer Join Pessoa		OD		with(nolock) 	on LLP.Cd_Order = OD.Cd_Pes
		Left Outer Join Nature_Goods Descr	with(nolock) 	on HOU.Num_proc_HEA = Descr.Num_Proc
		Left Outer Join Tipo_Oper	TP		with(nolock) 	on HOU.cd_tp_oper = TP.Cd_tp_oper		
		Left Outer Join Pessoa		Courier	with(nolock) 	on LLP.Cd_Courier = Courier.Cd_Pes
		Left Outer Join Pessoa		Transp	with(nolock) 	on LLP.Cd_Transportadora = Transp.Cd_Pes
		Left Outer Join Tipo_Status_Processo Status with(nolock) on STatus.id_status=LLP.id_status
		Left Outer Join Tipo_Frete FreteType with(nolock) on FreteType.cd_tp_frete	=HOU.Tp_Frete_HEA
		Left Outer Join Pessoa			NTF2 with(nolock) on LLP.Cd_Notify_2 = NTF2.Cd_Pes
		
		Left Outer Join Tipo_Modal_Imp_Exp Modal with(nolock)	on Modal.cd_tp_modal	= left(HOU.num_proc_hea,2)
		
		
		Left Outer Join Handling_HEA	HAN	with(nolock) 	on HOU.Num_Proc_Hea = HAN.Num_Proc_Hea
		Left Outer Join Tipo_Embalagem	Emb	with(nolock) 	on JOB.Cd_Tp_Embal = Emb.Cd_Tp_Embal				
	Where
		HOU.Num_Proc_HEA= @Num_Proc

END

GO
