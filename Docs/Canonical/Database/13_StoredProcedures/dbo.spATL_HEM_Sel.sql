SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spATL_HEM_Sel]'EMSAM201811002BR','D'
--[spHEM_Sel]'EMSAM201811002BR'
CREATE PROCEDURE [dbo].[spATL_HEM_Sel]
(
	@Num_Proc	VarChar(16),
	@Tipo		char(1)
)
AS

--if @Tipo = 'A' or @Tipo = 'B'
	Begin
		Select 
		HOU.Num_Proc_HEM		[JOB],
		LLP.Intl_Ref_Lem		[Intl Reference],
		-- HOU.Dt_Emis_HEM			[Register Date],
         convert(datetime, Dt_Emis_HEM,103) [Register Date],			
		HOU.MAWB_HeM			[MAWB Number],
		HOU.HAWB_HEM			[HAWB Number],
		Modal.cd_tp_modal		[Modal Code],
		Modal.Nome_Tp_Modal		[Modal Name],			
		HOU.Cd_Export_HEM		[Shipper Code],
		Ship.Apelido 			[Shipper Name],
		Hou.Cd_Consig_HEM		[Consignee Code],
		Consig.Apelido 			[Consignee Name],
		Hou.Cd_Notify_HEM		[Notify Code],
		Export.Apelido 			[Notify Name],
		
		LLP.Cd_Planta_Lem		[Origin Code],
		Origin.Nome_Local 		[Origin Name],
		HOu.Cd_Org_HeM			[Loading Code],
		Loading.Nome_Local 		[Loading Name],
		hou.Cd_Dst_HEM			[Discharge Code],
		Discharge.Nome_Local 	[Discharge Name],
		llp.Cd_DstFinal_Lem		[Final Destination Code],
		DstFinal.Nome_Local		[Final Destination Name],
		LLP.cd_armador_lem		[Carrier Code],
		Carrier.Nome_Armador	[Carrier Name],
		
		LLP.ID_Viagem			[Voyage Code],
		Viagem_LLP.NR_Viagem	[Voyage Number],			
		HOU.Viagem_HEM 			[Voyage],
			
		Viagem_LLP.ID_Navio		[Vessel Code],
		Navio_LLP.Nome_Navio	[Vessel Name],
		HOU.Navio_HEM 			[Vessel],		 

		LLP.ETD_Lem				[ETD],
		LLP.ATD_Lem				[ATD],
		LLP.ETA_Lem				[ETA],
		LLP.ATA_Lem				[ATA],			
		LLP.Cd_Tp_Carga			[Type Of Cargo Code],
		TC.Nome_Tp_Carga		[Type Of Cargo Name],
		
		HOU.Qtd_Tot_Vol_HEM		[Nº of Pieces],
		HOU.Peso_Liquido_HEM	[Net Weight (KG)],
		HOU.Peso_Bruto_HEM		[Gross Weight (KG)],
		HOU.Vol_Tot_HEM			[Volume(m3)],
		HOU.Cd_Tp_Moeda			[Currency Code],
		TM.Nome_Tp_Moeda		[Currency Name],
		HOU.Vlr_Frete_Tot_HEM	[Freight Value],
		HOU.Tp_Frete_HEM		[Freight Term Code],
		FreteType.Nome_Tp_Frete	[Freight Term Name],
		HOU.Obs_HEM				[Nature and Quality of Goods],		
		LLP.Original_ETA_LeM	[Original ETA],
		SAP_ShipNumber			[SAP Number],
		Hou.Cd_Dsp_HEM			[CHB Code],
		CHB.Apelido 			[CHB Name],			
		HOU.Cd_Tp_Oper			[Incoterm Code],
		TP.Nome_tp_Oper			[Incoterm Name],
		HOU.TTime_d				[Transit Time],
		LLP.Canal_Lem			[Channel],		
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
		LLP.Courier_Number_Lem 	[Courier Number],
		LLP.Cd_Transportadora 	[Inland Trucker Code],
		Transp.Apelido			[Inland Trucker Name],
		
		LLP.Vlr_Invoice			[Invoice Value],
		LLP.Cd_Moeda_Invoice	[Currency Invoice Code],
		TM_INV.Nome_Tp_Moeda	[Currency Invoice Name],
		LLP.DL_Cargo_Lem		[Dead Line Cargo],
		LLP.id_status			[Status Code],
		Status.Status_Descricao 	[Status Name],			
		JOB.Nr_Reserva			[Reservation Number],
		--Nature_Gooods
		--Descr.Descr				Descr,
		(case when (UPPER(Discharge.Cd_Pais) in ('IN') OR UPPER(DstFinal.Cd_Pais)in ('IN'))
					 and UPPER(ENDN.Cd_Pais)in ('IN') and Descr.Descr IS null THEN
			isnull(Descr.Descr,'')  + '||CONTINUATION OF CONSIGNEE|' +
			isnull(Consig.Nome_raz_soc,'') + '|' +
			isnull(ENDC.RUA,'') + isnull(ENDC.NUMERO,'') + isnull(ENDC.BAIRRO,'') + isnull(ENDC.CIDADE,'') + UPPER(isnull(ENDC.PAIS,'')) + '|' +		
			'Pin Code Consignee: ' + ISNULL(ENDC.CEP,'') + '|' +
			'Import Export Code Number: ' + isnull(CP_IEC_CS.Campo_Dados,'') + '|' +
			'PAN NUMBER: ' + isnull(CP_PAN_CS.Campo_Dados,'') + '|' +
			'GST Number: ' + isnull(CP_GST_CS.Campo_Dados,'')	 + '|' +
			'Email ID: ' + isnull(CMC.compl_fone,'') 
			+ '|||CONTINUATION OF NOTIFY|' +	
			isnull(Export.Nome_raz_Soc,'') + '|' +
			isnull(ENDN.RUA,'') + isnull(ENDN.NUMERO,'') +isnull(ENDN.BAIRRO,'') +isnull(ENDN.CIDADE,'')+UPPER(isnull(ENDN.PAIS,'')) + '|' +
			'Pin Code Notify: ' + ISNULL(ENDN.CEP,'') + '|' +
			--'Import Export Code Number / 
			'PAN NUMBER: ' + isnull(CP_PAN_NF.Campo_Dados,'') + '|' +
			--'GSTN Number :' + isnull(CP_IEC_NF.Campo_Dados,'')	 + '|' +
			'Email ID : ' + isnull(CMCN.compl_fone,'')  + '||' +			
			'Total Invoice Value: ' + ISNULL(convert(varchar(25),llp.Vlr_Invoice),'')
		else 
			(case when (UPPER(Discharge.Cd_Pais) in ('IN') OR UPPER(DstFinal.Cd_Pais)in ('IN')) 
				and UPPER(isnull(ENDN.Cd_Pais,''))not in ('IN') and Descr.Descr IS null
			THEN 
				isnull(Descr.Descr,'')  + '||CONTINUATION OF CONSIGNEE|' +
				isnull(Consig.Nome_raz_soc,'') + '|' +
				isnull(ENDC.RUA,'') + isnull(ENDC.NUMERO,'') + isnull(ENDC.BAIRRO,'') + isnull(ENDC.CIDADE,'') + UPPER(isnull(ENDC.PAIS,'')) + '|' +		
				'Pin Code Consignee: ' + ISNULL(ENDC.CEP,'') + '|' +
				'Import Export Code Number: ' + isnull(CP_IEC_CS.Campo_Dados,'') + '|' +
				'PAN NUMBER: ' + isnull(CP_PAN_CS.Campo_Dados,'') + '|' +
				'GST Number: ' + isnull(CP_GST_CS.Campo_Dados,'')	 + '|' +
				'Email ID: ' + isnull(CMC.compl_fone,'')  + '||' +			
				'Total Invoice Value: ' + ISNULL(convert(varchar(25),llp.Vlr_Invoice),'')
			else
				isnull(Descr.Descr,'')  
			end)
		end)					[Description and Goods],		
		
			
		isnull(Descr.Header,'')			[Description and Goods Header],	
		
		isnull(LLP.PO_Req_Date,LLP.ETA_LEM+10)  [PO Req. Del. Date],
		LLP.MultiModal, --not used
			
				
	
		LLP.Net_Rates_Lem		[Net Rates],
		LLP.Selling_Rates_Lem	[Selling Rates],
		LLP.Comissao_Agente_Lem	[Agent Comission],
		LLP.Cd_Notify_2			[Notify 2 Code],
		NTF.Apelido				[Notify 2 Name],
		LLP.Dt_BL_Lem			[BL Date],			
				
		Num_Proc_MEM			[Consol Reference],
		
		PLLP.Cd_Pes_grupo 		[Group Code],
		PG.Apelido				[Group Name]
		
	From  
		House_exp_Mar HOU with(nolock)
		Left Outer Join Pessoa		Export	with(nolock)	on Cd_Notify_HEM = Export.Cd_Pes
		Left Outer Join Endereco	ENDN	with(nolock)	on Export.cd_pes = ENDN.cd_pes  and ENDN.cd_tp_end = 'COM' 
		Left Outer Join comunicacao	CMCN	with(nolock)	on Export.cd_pes = CMCN.cd_pes and CMCN.cd_tp_com = 'HBL'
				
		Left Outer Join Pessoa		Consig	with(nolock)	on Cd_Consig_HEM = Consig.Cd_Pes 
		Left Outer Join Endereco	ENDC	with(nolock)	on Consig.cd_pes=ENDC.cd_pes  and ENDC.cd_tp_end = 'COM'	
		Left Outer Join comunicacao	CMC		with(nolock)	on Consig.cd_pes = CMC.cd_pes and CMC.cd_tp_com = 'HBL'	
		
		Left Outer Join Pessoa		Ship with(nolock)		on HOU.Cd_Export_HEM = Ship.Cd_Pes
		Left Outer Join Pessoa_llp	PLLP with(nolock)		on HOU.Cd_Export_HEM = PLLP.Cd_Pes
		Left Outer Join Pessoa		PG with(nolock)			on PG.Cd_Pes = PLLP.Cd_Pes_grupo
		
		Left Outer Join Pessoa		CHB with(nolock)		on Cd_Dsp_HEM = CHB.Cd_Pes		
		Left Outer Join LLP_Exp_mar	LLP with(nolock)		on HOU.Num_proc_hem = LLP.Num_proc_LEM
		Left Outer Join Localidade	Origin with(nolock)		on LLP.cd_Planta_Lem = Origin.cd_local
		Left Outer Join Localidade	DstFinal with(nolock)	on LLP.cd_dstfinal_lem = Dstfinal.cd_local
		Left Outer Join Armador		Carrier with(nolock)	on LLP.cd_armador_lem = Carrier.cd_Armador
		Left Outer Join Tipo_Carga	TC with(nolock)			on LLP.cd_tp_carga = TC.cd_tp_Carga 
		Left Outer Join Pessoa		Courier with(nolock)	on LLP.Cd_Courier = Courier.Cd_Pes
		Left Outer Join Pessoa		Forwarder with(nolock)	on LLP.Cd_Forwarder = Forwarder.Cd_Pes
		Left Outer Join Job_Exp_Mar	JOB with(nolock)		on HOU.Num_proc_hem = JOB.Num_Proc_HEM
		Left Outer Join Pessoa		Agente with(nolock)		on JOB.Cd_Agente = Agente.Cd_Pes
		Left Outer Join Usuario		Sales with(nolock)		on JOB.Cd_Vendedor = Sales.Cd_Usuario
		Left Outer Join Usuario		CSR with(nolock)		on JOB.Cd_Usuario = CSR.Cd_Usuario
		Left Outer Join Nature_Goods Descr with(nolock)		on HOU.Num_proc_hem = Descr.Num_Proc 
		Left Outer Join Localidade	Loading with(nolock)	on Cd_Org_HEM = Loading.Cd_Local 
		Left Outer Join Localidade	Discharge with(nolock)	on Cd_Dst_HEM = Discharge.Cd_Local 
		Left Outer Join Tipo_Moeda	TM with(nolock)			on HOU.Cd_Tp_Moeda = TM.Cd_Tp_Moeda
		Left Outer Join Tipo_Moeda	TM_INV with(nolock)		on LLP.Cd_Moeda_Invoice	= TM_INV.Cd_Tp_Moeda
		Left Outer Join Pessoa		OD with(nolock)			on LLP.Cd_Order = OD.Cd_Pes
		Left Outer Join Terminal	TERM with(nolock)		on LLP.Cd_Terminal = TERM.Cd_Terminal
		Left Outer Join Tipo_Oper	TP with(nolock)			on HOU.cd_tp_oper = TP.Cd_tp_oper
		Left Outer Join Pessoa		Transp with(nolock)		on LLP.Cd_Transportadora = Transp.Cd_Pes
		Left Outer Join Pessoa		NTF with(nolock)		on LLP.Cd_Notify_2 = NTF.Cd_Pes
		Left Outer Join Tipo_Status_Processo Status with(nolock) on STatus.id_status=LLP.id_status
		
		left Outer join Campo_Pessoa CP_PAN_CS with(nolock)	on CP_PAN_CS.Cd_Pes = Consig.Cd_Pes and CP_PAN_CS.Id_Campo = '20'
		left Outer join Campo_Pessoa CP_IEC_CS with(nolock)	on CP_IEC_CS.Cd_Pes = Consig.Cd_Pes and CP_IEC_CS.Id_Campo = '21'
		left Outer join Campo_Pessoa CP_GST_CS with(nolock)	on CP_GST_CS.Cd_Pes = Consig.Cd_Pes and CP_GST_CS.Id_Campo = '22'
		
		left Outer join Campo_Pessoa CP_PAN_NF with(nolock)	on CP_PAN_NF.Cd_Pes = Export.Cd_Pes and CP_PAN_NF.Id_Campo = '20'
		left Outer join Campo_Pessoa CP_IEC_NF with(nolock)	on CP_IEC_NF.Cd_Pes = Export.Cd_Pes and CP_IEC_NF.Id_Campo = '21'
		
		Left Outer Join Viagem_LLP	Viagem_LLP with(nolock)	on LLP.ID_Viagem = Viagem_LLP.ID_Viagem
		Left Outer Join Navio_LLP	Navio_LLP with(nolock)	on Viagem_LLP.ID_Navio = Navio_LLP.Id_Navio
		Left Outer Join Tipo_Frete	FreteType with(nolock)	on FreteType.cd_tp_frete	=HOU.Tp_Frete_HEM
		Left Outer Join Tipo_Modal_Imp_Exp Modal with(nolock)	on Modal.cd_tp_modal	= left(HOU.num_proc_hem,2)
	Where
		HOU.Num_Proc_HEM= @Num_Proc

	END

GO
