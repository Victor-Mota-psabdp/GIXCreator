SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_HIM_Sel 'IMATL201901001br', ''
CREATE PROCEDURE [dbo].[spATL_HIM_Sel]
(
	@Num_Proc	VarChar(16),
	@Tipo		char(1)
)
AS

--if @Tipo = 'A' or @Tipo = 'B'
	Begin
		Select
			HOU.Num_Proc_HIM		[JOB],
			LLP.Intl_Ref_Lim		[Intl Reference],
			-- HOU.Dt_Emis_HIM			[Register Date],
            convert(datetime, Dt_Emis_HIM,103) [Register Date],			
			HOU.MAWB_HIM			[MAWB Number],
			HOU.HAWB_HIM			[HAWB Number],			
			HOU.Cd_Export_HIM		[Shipper Code],
			Ship.Apelido 			[Shipper Name],
			Hou.Cd_Consig_HIM		[Consignee Code],
			Consig.Apelido 			[Consignee Name],
			Hou.Cd_Import_HIM		[Notify Code],
			Import.Apelido 			[Notify Name],
			LLP.Cd_planta_Lim		[Origin Code],
			Origin.Nome_Local 		[Origin Name],
			HOu.Cd_Org_HIM			[Loading Code],
			Loading.Nome_Local 		[Loading Name],
			hou.Cd_Dst_HIM			[Discharge Code],
			Discharge.Nome_Local 	[Discharge Name],
			llp.Cd_DstFinal_Lim		[Final Destination Code],
			DstFinal.Nome_Local		[Final Destination Name],
			JOB.Cd_Armador			[Carrier Code],
			Carrier.Nome_Armador	[Carrier Name],
			
			LLP.ID_Viagem			[Voyage Code],
			Viagem_LLP.NR_Viagem	[Voyage Number],			
			HOU.Viagem_HIM 			[Voyage],
			
			Viagem_LLP.ID_Navio		[Vessel Code],
			Navio_LLP.Nome_Navio	[Vessel Name],
			HOU.Navio_HIM 			[Vessel],
			
			LLP.ETD_Lim				[ETD],
			LLP.ATD_Lim				[ATD],
			LLP.ETA_Lim				[ETA],
			LLP.ATA_Lim				[ATA],			
			LLP.Cd_Tp_Carga			[Type Of Cargo Code],
			TC.Nome_Tp_Carga		[Type Of Cargo Name],
			HOU.Qtd_Tot_Vol_HIM		[Nº of Pieces],
			HOU.Peso_Liquido_HIM	[Net Weight (KG)],
			HOU.Peso_Bruto_HIM		[Gross Weight (KG)],
			HOU.Vol_Tot_HIM			[Volume(m3)],
			HOU.Cd_Tp_Moeda			[Currency Code],
			TM.Nome_Tp_Moeda		[Currency Name],
			HOU.Vlr_Frete_Efet_HIM	[Freight Value],
			HOU.Tp_Frete_HIM		[Freight Term Code],
			FreteType.Nome_Tp_Frete	[Freight Term Name],
			HOU.Obs_HIM				[Nature and Quality of Goods],
			LLP.Original_ETA_LIM	[Original ETA],
			SAP_ShipNumber			[SAP Number],
			Hou.Cd_Despachante		[CHB Code],
			CHB.Apelido 			[CHB Name],			
			HOU.Cd_Tp_Oper			[Incoterm Code],
			TP.Nome_tp_Oper			[Incoterm Name],
			HOU.TTime_d				[Transit Time],
			LLP.Canal_Lim			[Channel],
			JOB.Cd_Agente			[Agent Code],
			Agente.Apelido			[Agent Name],
			JOB.Cd_Vendedor			[Sales Code],
			Sales.Nome_Usuario		[Sales Name],			
			JOB.Cd_Usuario			[Customer Code],
			CSR.Nome_Usuario		[Customer Name],
			LLP.Cd_Terminal			[Terminal Code],
			TERM.Nome_Terminal		[Terminal Name],
			LLP.Cd_Order			[Order Code],
			OD.Apelido				[Order Name],
			LLP.Cd_Forwarder		[Forwarder Code],
			Forwarder.Apelido		[Forwarder Name],
			LLP.Cd_Courier			[Courier Code],
			Courier.Apelido 		[Courier Name],
			LLP.Courier_Number_LIM 	[Courier Number],
			LLP.Cd_Transportadora 	[Inland Trucker Code],
			Transp.Apelido			[Inland Trucker Name],
			Vlr_Invoice				[Invoice Value],
			LLP.Cd_Moeda_Invoice	[Currency Invoice Code],
			TM_INV.Nome_Tp_Moeda	[Currency Invoice Name],
			LLP.DL_Cargo_Lim		[Dead Line Cargo],
			LLP.id_status			[Status Code],
			Status.Status_Descricao 	[Status Name],			
			LLP.Nr_Reserva			[Reservation Number],
			Descr.Descr 			[Description and Goods],
			Descr.Header 			[Description and Goods Header],	
				
			isnull(LLP.PO_Req_Date,LLP.ETA_LIM+10) [PO Req. Del. Date],
			LLP.MultiModal, --not used
			
			Modal.cd_tp_modal [Modal Code],
			Modal.Nome_Tp_Modal [Modal Name],
			
			Num_Proc_MIM			[Consol Reference],
			
			PLLP.Cd_Pes_grupo 		[Group Code],
			PG.Apelido				[Group Name]
						
		From  
			House_Imp_Mar  HOU with(nolock)
			Left Outer Join Job_Imp_Mar 	JOB with(nolock)		on HOU.Num_Proc_HIM 	= JOB.Num_Proc_HIM
			Left Outer Join LLP_Imp_Mar		LLP with(nolock)		on HOU.Num_Proc_HIM		= LLP.Num_Proc_Lim
			Left Outer Join Pessoa			Ship with(nolock)		on Hou.Cd_Export_HIM 	= Ship.Cd_Pes
			Left Outer Join Pessoa			Consig with(nolock)		on Hou.Cd_Consig_HIM 	= Consig.Cd_Pes 
			
			Left Outer Join Pessoa_llp		PLLP with(nolock)		on HOU.Cd_Consig_HIM = PLLP.Cd_Pes
			Left Outer Join Pessoa			PG with(nolock)			on PG.Cd_Pes = PLLP.Cd_Pes_grupo
			
			
			Left Outer Join Pessoa			Import with(nolock)		on Hou.Cd_Import_HIM 	= Import.Cd_Pes
			Left Outer Join Pessoa			CHB with(nolock)		on Hou.Cd_Despachante	= CHB.Cd_Pes
			Left Outer Join Localidade		Loading with(nolock)	on Hou.Cd_Org_HIM 		= Loading.Cd_Local 
			Left Outer Join Localidade		Discharge with(nolock)	on Hou.Cd_Dst_HIM 		= Discharge.Cd_Local 
			Left Outer Join Localidade		Origin with(nolock)		on LLP.Cd_Planta_Lim 	= Origin.Cd_Local
			Left Outer Join Localidade		DstFinal with(nolock)	on LLP.Cd_DstFinal_LIM 	= DstFinal.Cd_Local
			Left Outer Join Armador			Carrier with(nolock)		on JOB.Cd_Armador		= Carrier.Cd_Armador
			Left Outer Join Tipo_Moeda		TM with(nolock)			on HOU.Cd_Tp_Moeda 		= TM.Cd_Tp_Moeda
			Left Outer Join Tipo_Moeda		TM_INV with(nolock)		on LLP.Cd_Moeda_Invoice	= TM_INV.Cd_Tp_Moeda
			Left Outer Join Tipo_Carga		TC with(nolock)			on LLP.Cd_Tp_Carga		= TC.Cd_Tp_Carga
			Left Outer Join Terminal		TERM with(nolock)		on LLP.Cd_Terminal		= TERM.Cd_Terminal
			Left Outer Join Pessoa			Agente with(nolock)			on JOB.Cd_Agente		= Agente.Cd_Pes
			Left Outer Join Pessoa			Forwarder with(nolock)		on LLP.Cd_Forwarder		= Forwarder.Cd_Pes
			Left Outer Join Usuario			Sales with(nolock)		on JOB.Cd_Vendedor		= Sales.Cd_Usuario
			Left Outer Join Usuario			CSR with(nolock)		on JOB.Cd_Usuario		= CSR.Cd_Usuario
			Left Outer Join Pessoa			OD with(nolock)			on LLP.Cd_Order			= OD.Cd_Pes
			Left Outer Join Nature_Goods	Descr with(nolock)		on HOU.Num_proc_him 	= Descr.Num_Proc 
			Left Outer Join Tipo_Oper		TP with(nolock)			on HOU.Cd_Tp_Oper 		= TP.Cd_Tp_Oper
			Left Outer Join Pessoa			Courier with(nolock)	on LLP.Cd_Courier 		= Courier.Cd_Pes
			Left Outer Join Pessoa			Transp with(nolock)		on LLP.Cd_Transportadora = Transp.Cd_Pes
			Left Outer Join Tipo_Status_Processo Status with(nolock) on STatus.id_status	=LLP.id_status
			Left Outer Join Tipo_Frete FreteType with(nolock) on FreteType.cd_tp_frete	=HOU.Tp_Frete_HIM
			
			Left Outer Join Tipo_Modal_Imp_Exp Modal with(nolock) on Modal.cd_tp_modal	=left(HOU.num_proc_him,2)
			
			
			Left Outer Join Viagem_LLP		Viagem_LLP with(nolock)	on LLP.ID_Viagem		= Viagem_LLP.ID_Viagem
			Left Outer Join Navio_LLP		Navio_LLP with(nolock)	on Viagem_LLP.ID_Navio = Navio_LLP.Id_Navio
			
		Where
			HOU.Num_Proc_HIM = @Num_Proc

END

GO
