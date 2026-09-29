SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from House_Exp_Mar h
--	join Localidade l on l.Cd_Local=  h.Cd_Dst_HEM
--where
--	Cd_Pais ='IN'	

CREATE	PROCEDURE [dbo].[spHEM_Sel] --'EMSAM201811002BR'
(
	@Processo		VarChar(16)
)
AS
	Select  
--House_exp_mar
		Dt_Emis_HEM,
		HOU.MAWB_HEM 			MAWB_HEM,
		HOU.HAWB_HEM 			HAWB_HEM,
		Ship.Apelido 			Shipper,
		Consig.Apelido 			Consignee,
		Export.Apelido 			Notify,
		Orig.Nome_Local 		Loading,
		Destin.Nome_Local 		Delivery,
		Viagem_HEM Voyage,
		Navio_HEM Vessel,
		CHB.Apelido CHB,
		--Dt_Saida_HEM,
		--Dt_Cheg_HEM,
		Qtd_Tot_Vol_HEM,
		Peso_Bruto_HEM,
		Peso_Liquido_HEM,
		Vol_Tot_HEM, 
		Tp_Frete_HEM,
		TM.Nome_Tp_Moeda,
		Vlr_Frete_Tot_HEM,
		SAP_ShipNumber 			SAP,
		TP.NOME_Tp_Oper 		Incoterm,
		TTime_d,
		Obs_HEM,
--JOB_EXP_MAR
		JOB.Nr_Reserva 			Booking,
		Sales.Nome_Usuario		Vendedor,
		Agente.Apelido			Agente, 
		CSR.Nome_Usuario		Customer,
--LLP
		LLP.ETA_LEM 			ETA_LEM,
		LLP.ETD_LEM 			ETD_LEM,
		LLP.ATA_LEM 			ATA_LEM,
		LLP.ATD_LEM 			ATD_LEM,
		Planta.nome_local 		Planta,
		DstFinal.Nome_Local 	DstFinal,
		Armador.Nome_Armador 	Armador,
		Carga.Nome_tp_Carga 	Carga,
		Courier.Apelido 		Courier,
		LLP.Courier_Number_Lem  Courier_Number,
		Forwarder.Apelido 		Forwarder,
		LLP.Intl_Ref_Lem		Intl_ref,
		LLP.Net_Rates_Lem		Net_Rates_Lem,
		LLP.Canal_Lem			Canal_Lem,
		TERM.Nome_Terminal		Terminal,
		OD.Apelido				Order_Lem,
		LLP.Selling_Rates_Lem	Selling_Rates_Lem,
		LLP.Original_ETA_Lem	Original_ETA_Lem,
		Transp.Apelido			Transportadora,
		NTF.Apelido				Notify_2,
		LLP.Dt_BL_Lem			Dt_BL,
		MultiModal,
		Vlr_Invoice,
		TM_INV.Nome_Tp_Moeda	Moeda_INV,
		LLP.Comissao_Agente_Lem	Comissao_Agente_Lem,
		isnull(LLP.PO_Req_Date,LLP.ETA_LEM+10) PO_Req_Date,

		Num_Proc_MEM			Ref_Consolidada,
		Status_Descricao Status_Job,
		LLP.ID_Status	ID_Status,
		llp.ID_Viagem			id_viagem,
		
	--Nature_Gooods
		--Descr.Descr				Descr,
		(case when (UPPER(Destin.Cd_Pais) in ('IN') OR UPPER(DstFinal.Cd_Pais)in ('IN'))
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
			(case when (UPPER(Destin.Cd_Pais) in ('IN') OR UPPER(DstFinal.Cd_Pais)in ('IN')) 
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
		end)					[Descr],		
		
			
		isnull(Descr.Header,'')			Header

		
		
	From  
		House_exp_Mar HOU with(nolock)
		--Left Outer Join Pessoa		Export with(nolock)		on Cd_Notify_HEM = Export.Cd_Pes
		--Left Outer Join Pessoa		Consig with(nolock)		on Cd_Consig_HEM = Consig.Cd_Pes 
		Left Outer Join Pessoa			Export	with(nolock)		on Cd_Notify_HEM = Export.Cd_Pes
		Left Outer Join Endereco		ENDN	with(nolock)	on Export.cd_pes = ENDN.cd_pes  and ENDN.cd_tp_end = 'COM' 
		Left Outer Join comunicacao		CMCN	with(nolock)	on Export.cd_pes = CMCN.cd_pes and CMCN.cd_tp_com = 'HBL'
		
		Left Outer Join Pessoa			Consig	with(nolock)		on Cd_Consig_HEM = Consig.Cd_Pes 
		Left Outer Join Endereco		ENDC	with(nolock)	on Consig.cd_pes=ENDC.cd_pes  and ENDC.cd_tp_end = 'COM'	
		Left Outer Join comunicacao		CMC		with(nolock)	on Consig.cd_pes = CMC.cd_pes and CMC.cd_tp_com = 'HBL'	
		
		Left Outer Join Pessoa		Ship with(nolock)		on Cd_Export_HEM = Ship.Cd_Pes
		Left Outer Join Pessoa		CHB with(nolock)			on Cd_Dsp_HEM = CHB.Cd_Pes		
		Left Outer Join LLP_Exp_mar	LLP with(nolock)			on HOU.Num_proc_hem = LLP.Num_proc_LEM
		Left Outer Join Localidade	Planta with(nolock)		on LLP.cd_Planta_Lem = Planta.cd_local
		Left Outer Join Localidade	DstFinal with(nolock)	on LLP.cd_dstfinal_lem = Dstfinal.cd_local
		Left Outer Join Armador		Armador with(nolock)		on LLP.cd_armador_lem = Armador.cd_Armador
		Left Outer Join Tipo_Carga	Carga with(nolock)		on LLP.cd_tp_carga = Carga.cd_tp_Carga 
		Left Outer Join Pessoa		Courier with(nolock)		on LLP.Cd_Courier = Courier.Cd_Pes
		Left Outer Join Pessoa		Forwarder with(nolock)	on LLP.Cd_Forwarder = Forwarder.Cd_Pes
		Left Outer Join Job_Exp_Mar	JOB with(nolock)			on HOU.Num_proc_hem = JOB.Num_Proc_HEM
		Left Outer Join Pessoa		Agente with(nolock)		on JOB.Cd_Agente = Agente.Cd_Pes
		Left Outer Join Usuario		Sales with(nolock)		on JOB.Cd_Vendedor = Sales.Cd_Usuario
		Left Outer Join Usuario		CSR with(nolock)			on JOB.Cd_Usuario = CSR.Cd_Usuario
		Left Outer Join Nature_Goods Descr with(nolock)		on HOU.Num_proc_hem = Descr.Num_Proc 
		Left Outer Join Localidade	Orig with(nolock)		on Cd_Org_HEM = Orig.Cd_Local 
		Left Outer Join Localidade	Destin with(nolock)		on Cd_Dst_HEM = Destin.Cd_Local 
		Left Outer Join Tipo_Moeda	TM with(nolock)			on HOU.Cd_Tp_Moeda = TM.Cd_Tp_Moeda
		Left Outer Join Tipo_Moeda	TM_INV with(nolock)		on LLP.Cd_Moeda_Invoice	= TM_INV.Cd_Tp_Moeda
		Left Outer Join Pessoa		OD with(nolock)			on LLP.Cd_Order = OD.Cd_Pes
		Left Outer Join Terminal	TERM with(nolock)		on LLP.Cd_Terminal = TERM.Cd_Terminal
		Left Outer Join Tipo_Oper	TP with(nolock)			on HOU.cd_tp_oper = TP.Cd_tp_oper
		Left Outer Join Pessoa		Transp with(nolock)		on LLP.Cd_Transportadora = Transp.Cd_Pes
		Left Outer Join Pessoa		NTF with(nolock)			on LLP.Cd_Notify_2 = NTF.Cd_Pes
		Left Outer Join Tipo_Status_Processo Status with(nolock) on STatus.id_status=LLP.id_status
		
		left Outer join Campo_Pessoa		CP_PAN_CS with(nolock)	on CP_PAN_CS.Cd_Pes = Consig.Cd_Pes and CP_PAN_CS.Id_Campo = '20'
		left Outer join Campo_Pessoa		CP_IEC_CS with(nolock)	on CP_IEC_CS.Cd_Pes = Consig.Cd_Pes and CP_IEC_CS.Id_Campo = '21'
		left Outer join Campo_Pessoa		CP_GST_CS with(nolock)	on CP_GST_CS.Cd_Pes = Consig.Cd_Pes and CP_GST_CS.Id_Campo = '22'
		
		left Outer join Campo_Pessoa		CP_PAN_NF with(nolock)	on CP_PAN_NF.Cd_Pes = Export.Cd_Pes and CP_PAN_NF.Id_Campo = '20'
		left Outer join Campo_Pessoa		CP_IEC_NF with(nolock)	on CP_IEC_NF.Cd_Pes = Export.Cd_Pes and CP_IEC_NF.Id_Campo = '21'
	Where
		HOU.Num_Proc_HEM= @Processo



/*
ALTER	PROCEDURE [dbo].[spHEM_Sel] 
(
@Processo		VarChar(16)
)
AS
	Select  
--House_exp_mar
		Dt_Emis_HEM,
		HOU.MAWB_HEM 			MAWB_HEM,
		HOU.HAWB_HEM 			HAWB_HEM,
		Ship.Apelido 			Shipper,
		Consig.Apelido 			Consignee,
		Export.Apelido 			Notify,
		Orig.Nome_Local 		Loading,
		Destin.Nome_Local 		Delivery,
		Viagem_HEM Voyage,
		Navio_HEM Vessel,
		CHB.Apelido CHB,
		--Dt_Saida_HEM,
		--Dt_Cheg_HEM,
		Qtd_Tot_Vol_HEM,
		Peso_Bruto_HEM,
		Peso_Liquido_HEM,
		Vol_Tot_HEM, 
		Tp_Frete_HEM,
		TM.Nome_Tp_Moeda,
		Vlr_Frete_Tot_HEM,
		SAP_ShipNumber 			SAP,
		TP.NOME_Tp_Oper 		Incoterm,
		TTime_d,
		Obs_HEM,
--JOB_EXP_MAR
		JOB.Nr_Reserva 			Booking,
		Sales.Nome_Usuario		Vendedor,
		Agente.Apelido			Agente, 
		CSR.Nome_Usuario		Customer,
--LLP
		LLP.ETA_LEM 			ETA_LEM,
		LLP.ETD_LEM 			ETD_LEM,
		LLP.ATA_LEM 			ATA_LEM,
		LLP.ATD_LEM 			ATD_LEM,
		Planta.nome_local 		Planta,
		DstFinal.Nome_Local 	DstFinal,
		Armador.Nome_Armador 	Armador,
		Carga.Nome_tp_Carga 	Carga,
		Courier.Apelido 		Courier,
		LLP.Courier_Number_Lem  Courier_Number,
		Forwarder.Apelido 		Forwarder,
		LLP.Intl_Ref_Lem		Intl_ref,
		LLP.Net_Rates_Lem		Net_Rates_Lem,
		LLP.Canal_Lem			Canal_Lem,
		TERM.Nome_Terminal		Terminal,
		OD.Apelido				Order_Lem,
		LLP.Selling_Rates_Lem	Selling_Rates_Lem,
		LLP.Original_ETA_Lem	Original_ETA_Lem,
		Transp.Apelido			Transportadora,
		NTF.Apelido				Notify_2,
		LLP.Dt_BL_Lem			Dt_BL,
		MultiModal,
		Vlr_Invoice,
		TM_INV.Nome_Tp_Moeda	Moeda_INV,
		LLP.Comissao_Agente_Lem	Comissao_Agente_Lem,
		isnull(LLP.PO_Req_Date,LLP.ETA_LEM+10) PO_Req_Date,
--Nature_Gooods
		Descr.Descr				Descr,
		Num_Proc_MEM			Ref_Consolidada,
		Status_Descricao Status_Job,
		LLP.ID_Status	ID_Status,
		Descr.Header Header
	From  
		House_exp_Mar HOU
		Left Outer Join Pessoa		Export		on Cd_Notify_HEM = Export.Cd_Pes
		Left Outer Join Pessoa		Consig		on Cd_Consig_HEM = Consig.Cd_Pes 
		Left Outer Join Pessoa		Ship		on Cd_Export_HEM = Ship.Cd_Pes
		Left Outer Join Pessoa		CHB			on Cd_Dsp_HEM = CHB.Cd_Pes		
		Left Outer Join LLP_Exp_mar	LLP			on HOU.Num_proc_hem = LLP.Num_proc_LEM
		Left Outer Join Localidade	Planta		on LLP.cd_Planta_Lem = Planta.cd_local
		Left Outer Join Localidade	DstFinal	on LLP.cd_dstfinal_lem = Dstfinal.cd_local
		Left Outer Join Armador		Armador		on LLP.cd_armador_lem = Armador.cd_Armador
		Left Outer Join Tipo_Carga	Carga		on LLP.cd_tp_carga = Carga.cd_tp_Carga 
		Left Outer Join Pessoa		Courier		on LLP.Cd_Courier = Courier.Cd_Pes
		Left Outer Join Pessoa		Forwarder	on LLP.Cd_Forwarder = Forwarder.Cd_Pes
		Left Outer Join Job_Exp_Mar	JOB			on HOU.Num_proc_hem = JOB.Num_Proc_HEM
		Left Outer Join Pessoa		Agente		on JOB.Cd_Agente = Agente.Cd_Pes
		Left Outer Join Usuario		Sales		on JOB.Cd_Vendedor = Sales.Cd_Usuario
		Left Outer Join Usuario		CSR			on JOB.Cd_Usuario = CSR.Cd_Usuario
		Left Outer Join Nature_Goods Descr		on HOU.Num_proc_hem = Descr.Num_Proc 
		Left Outer Join Localidade	Orig		on Cd_Org_HEM = Orig.Cd_Local 
		Left Outer Join Localidade	Destin		on Cd_Dst_HEM = Destin.Cd_Local 
		Left Outer Join Tipo_Moeda	TM			on HOU.Cd_Tp_Moeda = TM.Cd_Tp_Moeda
		Left Outer Join Tipo_Moeda	TM_INV		on LLP.Cd_Moeda_Invoice	= TM_INV.Cd_Tp_Moeda
		Left Outer Join Pessoa		OD			on LLP.Cd_Order = OD.Cd_Pes
		Left Outer Join Terminal	TERM		on LLP.Cd_Terminal = TERM.Cd_Terminal
		Left Outer Join Tipo_Oper	TP			on HOU.cd_tp_oper = TP.Cd_tp_oper
		Left Outer Join Pessoa		Transp		on LLP.Cd_Transportadora = Transp.Cd_Pes
		Left Outer Join Pessoa		NTF			on LLP.Cd_Notify_2 = NTF.Cd_Pes
		Left Outer Join Tipo_Status_Processo Status on STatus.id_status=LLP.id_status
	Where
		HOU.Num_Proc_HEM= @Processo
*/
GO
