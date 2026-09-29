SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_HIA_Sel 'IAATL201901001BR', ''
CREATE PROCEDURE [dbo].[spATL_HIA_Sel]
(
	@Num_Proc	VarChar(16),
	@Tipo		char(1)
)
AS

--if @Tipo = 'A' or @Tipo = 'B'
	Begin
		Select
			HOU.Num_Proc_HIA		[JOB],
			LLP.Intl_Ref_LIA		[Intl Reference],
			-- HOU.Dt_Emis_HIA			[Register Date],
            convert(datetime, Dt_Emis_HIA,103) [Register Date],			
			HOU.MAWB_HIA			[MAWB Number],
			HOU.HAWB_HIA			[HAWB Number],	
			Modal.cd_tp_modal		[Modal Code],
			Modal.Nome_Tp_Modal		[Modal Name],			
			HOU.Cd_Export_HIA		[Shipper Code],
			Ship.Apelido 			[Shipper Name],
			HOU.Cd_Consig_HIA		[Consignee Code],
			Consig.Apelido 			[Consignee Name],
			HOU.Cd_Import_HIA		[Notify Code],
			Import.Apelido 			[Notify Name],
			LLP.Cd_planta_LIA		[Origin Code],
			Origin.Nome_Local 		[Origin Name],
			HOU.Cd_Org_HIA			[Loading Code],
			Loading.Nome_Local 		[Loading Name],
			HOU.Cd_Dst_HIA			[Discharge Code],
			Discharge.Nome_Local 	[Discharge Name],
			llp.Cd_DstFinal_LIA		[Final Destination Code],
			DstFinal.Nome_Local		[Final Destination Name],
			JOB.Cd_Cia_Aer			[Air Company Code],
			CiaAER.Nome_Cia_Aer		[Air Company Name],
			HOU.Voo_HIA				[Voyage],
			LLP.ETD_LIA				[ETD],
			LLP.ATD_LIA				[ATD],
			LLP.ETA_LIA				[ETA],
			LLP.ATA_LIA				[ATA],			
			HOU.Qtd_Tot_Vol_HIA		[Nº of Pieces],
			HOU.Peso_Real_HIA		[Net Weight (KG)],
			HOU.Peso_Bruto_HIA		[Gross Weight (KG)],
			LLP.Peso_Cubado_LIA		[Charg Weight (KG)],
			HOU.Vol_Tot_HIA			[Volume(m3)],
			HOU.Cd_Tp_Moeda			[Currency Code],
			TM.Nome_Tp_Moeda		[Currency Name],
			HOU.Vlr_Frete_Efet_HIA	[Freight Value],
			HOU.Tp_Frete_HIA		[Freight Term Code],
			FreteType.Nome_Tp_Frete	[Freight Term Name],
			HOU.Obs_HIA				[Nature and Quality of Goods],
			LLP.Original_ETA_LIA	[Original ETA],						
			SAP_ShipNumber			[SAP Number],
			Hou.Cd_Dsp_HIA			[CHB Code],
			CHB.Apelido 			[CHB Name],			
			HOU.Cd_Tp_Oper			[Incoterm Code],
			TP.Nome_tp_Oper			[Incoterm Name],
			TTime_d					[Transit Time],
			LLP.Canal_LIA			[Channel],
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
			LLP.Courier_Number_LIA 	[Courier Number],
			LLP.Cd_Transportadora 	[Inland Trucker Code],
			Transp.Apelido			[Inland Trucker Name],
			Vlr_Invoice				[Invoice Value],
			LLP.Cd_Moeda_Invoice	[Currency Invoice Code],
			TM_INV.Nome_Tp_Moeda	[Currency Invoice Name],
			LLP.DL_Cargo_LIA		[Dead Line Cargo],
			LLP.id_status			[Status Code],
			Status.Status_Descricao 	[Status Name],			
			--LLP.Nr_Reserva			[Reservation Number],
			Descr.Descr 			[Description and Goods],
			Descr.Header 			[Description and Goods Header],	
				
			isnull(LLP.PO_Req_Date,LLP.ETA_LIA+10) [PO Req. Del. Date],
			LLP.MultiModal, --not used
			
			Num_Proc_MIA			[Consol Reference],
			PLLP.Cd_Pes_grupo 		[Group Code],
			PG.Apelido				[Group Name]
		From  
			House_Imp_AER  HOU with(nolock)
			Left Outer Join Job_Imp_AER 	JOB		with(nolock)		on HOU.Num_Proc_HIA		= JOB.Num_Proc_HIA
			Left Outer Join LLP_Imp_AER		LLP		with(nolock)		on HOU.Num_Proc_HIA		= LLP.Num_Proc_LIA
			Left Outer Join Pessoa			Ship	with(nolock)		on Hou.Cd_Export_HIA 	= Ship.Cd_Pes
			Left Outer Join Pessoa			Consig	with(nolock)		on Hou.Cd_Consig_HIA 	= Consig.Cd_Pes 
			Left Outer Join Pessoa_llp		PLLP	with(nolock)		on HOU.Cd_Consig_HIA	= PLLP.Cd_Pes
			Left Outer Join Pessoa			PG		with(nolock)		on PG.Cd_Pes			= PLLP.Cd_Pes_grupo
			Left Outer Join Pessoa			Import with(nolock)		on Hou.Cd_Import_HIA 	= Import.Cd_Pes
			Left Outer Join Pessoa			CHB with(nolock)		on Hou.Cd_Dsp_HIA		= CHB.Cd_Pes
			Left Outer Join Localidade		Loading with(nolock)	on Hou.Cd_Org_HIA 		= Loading.Cd_Local 
			Left Outer Join Localidade		Discharge with(nolock)	on Hou.Cd_Dst_HIA 		= Discharge.Cd_Local 
			Left Outer Join Localidade		Origin with(nolock)		on LLP.Cd_Planta_LIA 	= Origin.Cd_Local
			Left Outer Join Localidade		DstFinal with(nolock)	on LLP.Cd_DstFinal_LIA 	= DstFinal.Cd_Local
			Left Outer Join Cia_Aerea		CiaAER	 with(nolock)	on JOB.Cd_Cia_Aer	= CiaAER.Cd_Cia_Aer
			Left Outer Join Tipo_Moeda		TM with(nolock)			on HOU.Cd_Tp_Moeda 		= TM.Cd_Tp_Moeda
			Left Outer Join Tipo_Moeda		TM_INV with(nolock)		on LLP.Cd_Moeda_Invoice	= TM_INV.Cd_Tp_Moeda
			Left Outer Join Terminal		TERM with(nolock)		on LLP.Cd_Terminal		= TERM.Cd_Terminal
			Left Outer Join Pessoa			AG with(nolock)			on JOB.Cd_Agente		= AG.Cd_Pes
			Left Outer Join Pessoa			FORW with(nolock)		on LLP.Cd_Forwarder		= FORW.Cd_Pes
			Left Outer Join Usuario			SAL with(nolock)		on JOB.Cd_Vendedor		= SAL.Cd_Usuario
			Left Outer Join Usuario			CSR with(nolock)		on JOB.Cd_Usuario		= CSR.Cd_Usuario
			Left Outer Join Pessoa			OD with(nolock)			on LLP.Cd_Order			= OD.Cd_Pes
			Left Outer Join Nature_Goods	Descr with(nolock)		on HOU.Num_proc_HIA 	= Descr.Num_Proc 
			Left Outer Join Tipo_Oper		TP with(nolock)			on HOU.Cd_Tp_Oper 		= TP.Cd_Tp_Oper
			Left Outer Join Pessoa			Courier with(nolock)	on LLP.Cd_Courier 		= Courier.Cd_Pes
			Left Outer Join Pessoa			Transp with(nolock)		on LLP.Cd_Transportadora = Transp.Cd_Pes
			Left Outer Join Tipo_Status_Processo Status with(nolock) on STatus.id_status	=LLP.id_status
			Left Outer Join Tipo_Frete FreteType with(nolock) on FreteType.cd_tp_frete	=HOU.Tp_Frete_HIA
			Left Outer Join Tipo_Modal_Imp_Exp Modal with(nolock)	on Modal.cd_tp_modal	= left(HOU.num_proc_hia,2)
		
		Where
			HOU.Num_Proc_HIA = @Num_Proc

END

GO
