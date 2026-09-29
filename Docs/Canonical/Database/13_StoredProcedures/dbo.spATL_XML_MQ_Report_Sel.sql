SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from atl_int.dbo.XML_MQ
--select * from  ATL_INT.DBO.GIX_Request_Header where SystemCode = '8'
--[spATL_XML_MQ_Report_Sel]'8'

--SELECT * FROM LLP_Exp_Aer WHERE Num_Proc_LEA  = 'EAATL201906012BR'
 	
--SELECT * FROM House_Exp_Aer
--SELECT * FROM Cia_Aerea WHERE Cd_Cia_Aer = 'LH'
CREATE Procedure [dbo].[spATL_XML_MQ_Report_Sel]--'8'
(
	@SystemCode BIGINT
)
as
select
	right(ForwarderReferenceNumber.ReferenceNumber ,2)		[Country Code], 
	HOU.Num_Proc_MEA										[BDP Job Number],
	ForwarderReferenceNumber.ReferenceNumber				[House Job Number],	
	(Case when HOU.Num_Proc_MEA = 'JOB' THEN 'N' ELSE 'Y' END)	[Consolidate JOB - Y/N],
	isnull(HouseAirwayBill.ReferenceNumber,'N/A')			[AWB Number],
	CA.SCAC													[Carrier Code],
	''														[Filing Status],
	Status.StatusDate + ' ' +Status.StatusTime				[Filing Date & Time],
	Status.StatusDescription								[Transmission status Message (both internal and External)],
	ORG.Nome_Local											[Airport of Depature],
	DST.Nome_Local											[Airport of Destination],

	SHM.Nome_raz_soc											[MAWB Exporter Name],
	isnull('Street:' + ENDSHM.Rua,' ') +	isnull('Nº:'+ ENDSHM.Numero,' ') +
	isnull('-'+ENDSHM.compl_end + ' ',' ') + isnull('ZIP Code:'+ltrim(ENDSHM.Cep) + ' ',' ') +
	isnull('City:'+ENDSHM.Cidade,' ') + isnull('Country:'+ ENDSHM.CD_pais,' ') [MAWB Exporter Address],
	CS.Nome_raz_soc											[MAWB Cosignee Name],
	isnull('Street:' + ENDCSM.Rua,' ') +	isnull('Nº:'+ ENDCSM.Numero,' ') +
	isnull('-'+ENDCSM.compl_end + ' ',' ') + isnull('ZIP Code:'+ltrim(ENDCSM.Cep) + ' ',' ') +
	isnull('City:'+ENDCSM.Cidade,' ') + isnull('Country:'+ ENDCSM.CD_pais,' ') [MAWB Cosignee Address],
	
	SH.Nome_raz_soc												[HAWB Exporter Name],
	isnull('Street:' + ENDS.Rua,' ') +	isnull('Nº:'+ ENDS.Numero,' ') +
	isnull('-'+ENDS.compl_end + ' ',' ') + isnull('ZIP Code:'+ltrim(ENDS.Cep) + ' ',' ') +
	isnull('City:'+ENDS.Cidade,' ') + isnull('Country:'+ ENDS.CD_pais,' ') [HAWB Exporter Address],
	CS.Nome_raz_soc											[HAWB Consignee Name],
	isnull('Street:' + ENDC.Rua,' ') +	isnull('Nº:'+ ENDC.Numero,' ') +
	isnull('-'+ENDC.compl_end + ' ',' ') + isnull('ZIP Code:'+ltrim(ENDC.Cep) + ' ',' ') +
	isnull('City:'+ENDC.Cidade,' ') + isnull('Country:'+ ENDC.CD_pais,' ') [HAWB Consignee Address],
	
	convert(decimal(18,2),Peso_Bruto_hea)								[Total Gross Weight],
	NumberofPackages.MeasurementValue									[Total Number of Packages],
	
	Obs_HEA																	[Cargo Description],
	US.Nome_Usuario														[User Name],
	CONVERT(VARCHAR(12),LLP.ETA_Lea,101)								[First Flight Date],
	CONVERT(VARCHAR(11),LLP.ETA_Lea,114)								[First Flight Time],
	DST.IATACODE + ' ' + DST.Nome_Local + ' ' + DST.Cd_Pais				[First Flight Destination],
	
	'' [Second Flight Destination],
	'' [Third Flight Destination]
																		
	--Header.Header_RequestType	[Header RequestType],
	--Header.Header_Action		[Header Action],
	--Header.Header_Type			[Header Type],
	
	--Notify.Parties_Type			[Parties],
	
	--ConsolIndicator.Ref_Type	[References type],
	--ConsolIndicator.Ref_Number	[ReferenceNumber],
	
	--MasterAirwayBill.type				[Transportation ReferenceType],
	--MasterAirwayBill.ReferenceNumber	[Transportation ReferenceNumber],
	
	--HouseAirwayBill.type				[Transportation ReferenceType],
	--HouseAirwayBill.ReferenceNumber	[Transportation ReferenceNumber],
	
	--ForwarderReferenceNumber.type				[Transportation ReferenceType],
	--ForwarderReferenceNumber.ReferenceNumber	[Transportation ReferenceNumber],
	
	--Status.StatusType				[Status StatusType],
	--Status.StatusCode_Value			[Status StatusCode],
	--Status.StatusDescription		[Status StatusDescription],
	--Status.StatusDate				[Status StatusDate],
	--Status.StatusTime				[Status StatusTime],
	
	--NumberofPackages.item						[Footer Measurements item],
	--NumberofPackages.MeasurementValue			[Footer MeasurementValue],	
	
	--Header.DT_SEND_MESSAGE			[Sent Date],
	--US.Nome_Usuario					[User]
 FROM ATL_INT.DBO.GIX_Request_Header Header
	LEFT JOIN ATL_INT.DBO.GIX_Header_Parties Notify ON Notify.ID_Req = Header.ID_Req 
		AND Notify.Parties_Type = 'Notify'
	LEFT JOIN ATL_INT.DBO.GIX_Header_References ConsolIndicator ON ConsolIndicator.ID_Req = Header.ID_Req 
		AND ConsolIndicator.Ref_Type = 'ConsolIndicator'	
	LEFT JOIN ATL_INT.DBO.GIX_Header_Transportation_ReferenceType MasterAirwayBill ON MasterAirwayBill.ID_Req = Header.ID_Req 
		AND MasterAirwayBill.type = 'MasterAirwayBill'
	LEFT JOIN ATL_INT.DBO.GIX_Header_Transportation_ReferenceType ForwarderReferenceNumber ON ForwarderReferenceNumber.ID_Req = Header.ID_Req 
		AND ForwarderReferenceNumber.type = 'ForwarderReferenceNumber'
	LEFT JOIN ATL_INT.DBO.GIX_Header_Status Status ON Status.ID_Req = Header.ID_Req 
		--AND ErrorOfTransaction.StatusType = 'ErrorOfTransaction'
	--LEFT JOIN ATL_INT.DBO.GIX_Header_Status DateofTransaction ON DateofTransaction.ID_Req = Header.ID_Req 
	--	--AND DateofTransaction.StatusType = 'DateofTransaction'
	
	LEFT JOIN ATL_INT.DBO.GIX_Header_Transportation_ReferenceType HouseAirwayBill ON HouseAirwayBill.ID_Req = Header.ID_Req 
		AND HouseAirwayBill.type = 'HouseAirwayBill'
	LEFT JOIN ATL_INT.DBO.GIX_Footer_Measurements NumberofPackages ON NumberofPackages.ID_Req = Header.ID_Req 
		AND NumberofPackages.item = 'NumberofPackages'
	JOIN Exchange_GTNexus GT ON GT.Num_Proc = ForwarderReferenceNumber.ReferenceNumber AND GT.Type = 'AC'
	JOIN Usuario US on US.Cd_Usuario = GT.Cd_Usuario
	
	
	join House_Exp_Aer HOU on HOU.Num_Proc_HEA = ForwarderReferenceNumber.ReferenceNumber
	join LLP_Exp_Aer LLP on HOU.Num_Proc_HEA = LLP.Num_Proc_Lea
	
	LEFT JOIN Cia_Aerea CA on CA.Cd_Cia_Aer = LLP.Cd_CiaAerea_Lea
	left join localidade ORG ON ORG.CD_LOCAL = HOU.CD_ORG_HEA
	left join localidade DST ON DST.CD_LOCAL = HOU.CD_DST_HEA
	LEFT JOIN Master_Exp_Aer MEA ON MEA.Num_Proc_MEA = HOU.Num_Proc_MEA
	Left Join Pessoa SHM on SHM.cd_pes=MEA.cd_export_mea
	Left Join Endereco ENDSHM on SHM.cd_pes=ENDSHM.cd_pes and ENDSHM.cd_tp_end = 'COM'	
	
	Left Join Pessoa CSM on CSM.cd_pes=MEA.cd_consig_mea
	Left Join Endereco ENDCSM on CSM.cd_pes=ENDCSM.cd_pes and ENDCSM.cd_tp_end = 'COM'
	
	Left Join Pessoa CS on CS.cd_pes=HOU.cd_consig_hea
	Left Join Endereco ENDC on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
	
	Left Join Pessoa Sh on SH.cd_pes=HOU.cd_export_hea
	Left Join Endereco ENDS on SH.cd_pes=ENDS.cd_pes and ENDS.cd_tp_end = 'COM'

 WHERE
	--[DT_SEND_MESSAGE] IS NULL
	SystemCode = @SystemCode
	AND DT_SEND_MESSAGE is not null
	


	
	
	

GO
