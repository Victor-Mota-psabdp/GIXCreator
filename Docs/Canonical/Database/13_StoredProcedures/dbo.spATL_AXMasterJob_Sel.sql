SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--and Dimensao3 is not null --20250922 - no Oracle é mandatorio este campo - Cadu
--29062021 Cadu incluido o [dbo].[FRemoveAcentuacao] no EO
--20230502 Cadu Incluido o Nome_Raz_Soc no BO sem JOB
--20240509  Cadu Incluido para nao enviar com  shipper: 10017 para export


--select * from vwHouse_Exp where num_proc = 'EMATL202409003BR'
--[dbo].[spATL_AXMasterJob_Sel]'EMATL202409003BR'
CREATE Procedure [dbo].[spATL_AXMasterJob_Sel]-- 'EMATL202409003BR'
	@Num_Proc	varchar(16)
as

Declare @JobFirstFinTransDate Datetime
Declare @DtTemp Datetime



--Delete  accountnum unknown
if exists(select AccountNum from AX_XML_Customer_Recebido where AccountNum = 'Unknown')
	BEGIN
		DELETE AX_XML_Customer_Recebido where AccountNum = 'Unknown'
	END

Set @DtTemp = (select min(convert(Datetime,dt_ins_hia,105)) from vwcta_cte where num_proc_hia=@Num_proc and dc_hia='D')
Set @JobFirstFinTransDate=(select min(fatdtemissao) from fatura where left(fatcod,16)=@Num_Proc)

if isnull(@DtTemp,getdate()) < Isnull(@JobFirstFinTransDate,getdate())
	Begin
		Set @JobFirstFinTransDate=@DtTemp
	End
	
--IMPORTACAO AEREA
select top 1
	0.00 InsuredAmountUSD,
	'LCL' ShipmentType,
	'No' FNClose,
	Null CustRef2,
	Null CustRef3,
	Null CustRef4,
	Null CitCustomerPO,
	(CASE WHEN CP.campo_dados = '1' THEN 'No' else 'Yes'END) BDP_JobControlled,	--'Yes' BDP_JobControlled,
	Num_Proc_LIA JobNbr,
	--(
	--	Case hou.Num_Proc_MIA
	--		When 'JOB' then '850'
	--		else 122 
	--	End
	--)
	--AXProductCode,
	(CASE 
		WHEN isnull(CP221.campo_dados,'0')= '1' THEN 540
		WHEN hou.Num_Proc_MIA = 'JOB' THEN 850
		ELSE 122
	END) AS AXProductCode,
	CONVERT(Datetime,dt_emis_hia,105) JobCreationDate	,
	US.Nome_Usuario	UserName,
	US.email			UserEmail,
	US.Fone			UserPhone,
	'BRSAO'			AXLocationCode,
	Status_Descricao_Ingles			JobStatus,
	Null							JobClosedDateAX,
	Null							JobClosedDateOps,
	Hou.HAWB_HIA					HouseBOLNbr,
	HoU.MAWB_HIA	MasterBOLNbr,
	(
		Case hou.Num_Proc_MIA
			When 'JOB' then ''
			else hou.Num_Proc_MIA
		End
	) ConsolNbr,
	 Dimensao3 GlobalCustomerCode,
	 AX.cd_ax ClientCode,
	 PP.Nome_Raz_Soc ConsigneeName,
	 case 
		when hou.Num_Proc_HIA like '%HNK%' then left(dbo.fBusca_TipoDocCliente('N',num_proc_lia,8),100) 
		else 	 left(dbo.fBusca_TipoDocCliente('N',num_proc_lia,1),100) 
	End
	CustRef1,
	 ORg.Cd_Pais CountryOfOrigin,
	 Org.SCAC PortOfLoad,
	 ETD_LIA EstSailDate,
	 ATD_LIA ActSailDate,
	 DST.Cd_Pais CountryOfDestination,
	 DST.SCAC PortOfEntry,
	 Null EstEntryDate,
	 ATA_LIA ActEntryDate,
	 Null DateOfDelivery,
	 DST.SCAC  PortOfDischarge,
	 Null PlaceOfDelivery,
	 CIA.SCAC  CarrierCode,
	 Nome_Cia_Aer CarrierName,
	 cast(Isnull(Peso_Bruto_HIA,0) as decimal(18,2)) GrossWeight,
	 Cast(Isnull(Peso_Cubado_LIA,0) as decimal(18,2)) GrossWeightChargeable,
	 'No' Hazardous,
	 Cd_Tp_Oper  INCOTerms,
	 Null MasterBookingNbr,
	 'Air' ModeOfTransport,
	 0 NumOfContainers,
	 Null NVOCCCode,
	 'No' OpClose,
	 Cd_Vendedor SalesPersonCode,
	 null SalespersonCodeEXT,
	 VD.Nome_Usuario SalesPersonName,
	 SH.Nome_Raz_Soc  ShipperName,
	0.00 TEU,
	 null VesselName,
	 Cast(Isnull(Vol_Tot_HIA,0) as decimal(18,2))Volume,
	 Left(Voo_HIA,10) VoyageId,
	 @JobFirstFinTransDate JobFirstFinTransDate,
	 AX.CD_AX CustAccount,
	 PP.Nome_Raz_Soc CustName,
	AXA.cd_ax AXAgentVendAccount,
	Case
		When tp_frete_hia='P' Then 'Prepaid'
		else 'Collect'
	
	End	PrepaidOrCollect,
	'Import' TransportOrientation

from 
	House_Imp_Aer Hou with(nolock)
	Join LLP_Imp_aer LLP with(nolock) on Num_Proc_Lia=hou.num_proc_hia
	Join Job_Imp_Aer Job with(nolock) on Hou.Num_Proc_HIA = Job.Num_Proc_HIA
	Join Usuario US with(nolock) on US.Cd_Usuario = Job.cd_usuario
	Join Pessoa PP with(nolock) on PP.Cd_Pes=Cd_Consig_HIA
	Join Pessoa_ATL_AX AX with(nolock) on AX.Cd_Pes = PP.Cd_Pes and Tipo='C'
	Join Localidade ORg with(nolock) on Org.Cd_Local = Cd_Org_HIA
	Join Localidade DST with(nolock) on DST.Cd_Local = Cd_Dst_HIA 
	left Join Cia_Aerea CIA with(nolock) on CIA.Cd_Cia_Aer = job.Cd_Cia_Aer 
	Left Join Usuario VD with(nolock) on VD.Cd_Usuario = Cd_Vendedor 
	Join Pessoa SH with(nolock) on SH.Cd_Pes=Cd_Export_HIA 
	LEft Join Tipo_Status_Processo TSP with(nolock) on LLP.id_Status = TSP.id_status
	Join AX_XML_Customer_Recebido AXCR with(nolock) on AXCR.AccountNum=cd_ax
	Left Join Master_Imp_Aer MAS with(nolock) on Hou.num_proc_mia=mas.num_proc_mia
	LEft Join Pessoa_ATL_AX AXA with(nolock) on AXA.Cd_Pes = cd_export_mia and AXA.Tipo='F'
	join Campo_Processo CP with(nolock) on CP.num_proc = Hou.num_proc_hia and id_campo = 143
	left join campo_processo CP221 with(nolock) on cp221.num_proc = hou.num_proc_hia and CP221.id_campo = 221
Where
	Num_Proc_Lia = @Num_Proc
	and Dimensao3 is not null --20250922 - no Oracle é mandatorio este campo - Cadu
	


Union All


--IMPORTACAO MARITIMA
select top 1
	0.00 InsuredAmountUSD,
	Case 
		when Nome_Tp_Carga = 'Cabotagem' then 'FCL'
		else Nome_Tp_Carga
	End	 ShipmentType,
	'No' FNClose,
	Null CustRef2,
	Null CustRef3,
	Null CustRef4,
	Null CitCustomerPO,
	(CASE WHEN CP.campo_dados = '1' THEN 'No' else 'Yes'END) BDP_JobControlled, --'Yes' BDP_JobControlled,
	Num_Proc_lim JobNbr,
	--(
	--	Case hou.Num_Proc_mim
	--		When 'JOB' then '850'
	--		else 221
	--	End
	--)
	-- AXProductCode,
	(CASE 
		WHEN isnull(CP221.campo_dados,'0')= '1' THEN 520
		WHEN hou.Num_Proc_mim = 'JOB' THEN 850
		ELSE 221
	END) AS AXProductCode,
	CONVERT(Datetime,dt_emis_him,105) JobCreationDate	,
	US.Nome_Usuario	UserName,
	US.email			UserEmail,
	US.Fone			UserPhone,
	'BRSAO'			AXLocationCode,
	Status_Descricao_Ingles			JobStatus,
	Null			JobClosedDateAX,
	Null			JobClosedDateOps,
	Hou.HAWB_him	HouseBOLNbr,
	HoU.MAWB_him	MasterBOLNbr,
	(
		Case hou.Num_Proc_mim
			When 'JOB' then ''
			else hou.Num_Proc_mim
		End
	) ConsolNbr,
	 Dimensao3 GlobalCustomerCode,
	 AX.cd_ax ClientCode,
	 PP.Nome_Raz_Soc ConsigneeName,
	case 
		when hou.Num_Proc_HIM like '%HNK%' then left(dbo.fBusca_TipoDocCliente('N',num_proc_lim,8),100) 
		else 	 left(dbo.fBusca_TipoDocCliente('N',num_proc_lim,1),100) 
	End

	 CustRef1,
	 ORg.Cd_Pais CountryOfOrigin,
	 Org.SCAC PortOfLoad,
	 ETD_lim EstSailDate,
	 ATD_lim ActSailDate,
	 DST.Cd_Pais CountryOfDestination,
	 DST.SCAC PortOfEntry,
	 Null EstEntryDate,
	 ATA_lim ActEntryDate,
	 Null DateOfDelivery,
	 DST.SCAC  PortOfDischarge,
	 Null PlaceOfDelivery,
	 CIA.SCAC  CarrierCode,
	 Nome_ARmador CarrierName,
	 cast(isnull(Peso_Bruto_him,0) as decimal(18,2)) GrossWeight,
	 Cast(Isnull(Peso_Bruto_him,0) as decimal(18,2)) GrossWeightChargeable,
	 'No' Hazardous,
	 Cd_Tp_Oper  INCOTerms,
	 Null MasterBookingNbr,
	 'Ocean' ModeOfTransport,
	 0 NumOfContainers,
	 Null NVOCCCode,
	 'No' OpClose,
	 Cd_Vendedor SalesPersonCode,
	 null SalespersonCodeEXT,
	 VD.Nome_Usuario SalesPersonName,
	 SH.Nome_Raz_Soc  ShipperName,
	 [dbo].[fBusca_TEUS](@Num_PRoc)  TEU,
	 Navio_HIM VesselName,
	 Cast(Isnull(Vol_Tot_him,0) as decimal(18,2))Volume,
	 left(Viagem_HIM,10) VoyageId,
	 @JobFirstFinTransDate JobFirstFinTransDate,
	 AX.CD_AX CustAccount,
	 PP.Nome_Raz_Soc CustName,
	 AXA.cd_ax AXAgentVendAccount,
	Case
		When tp_frete_him='P' Then 'Prepaid'
		else 'Collect'	
	End	PrepaidOrCollect,
	'Import' TransportOrientation
from 
	House_Imp_mar Hou with(nolock)
	Join LLP_Imp_mar LLP with(nolock) on Num_Proc_lim=hou.num_proc_him
	Join Job_Imp_mar Job with(nolock) on Hou.Num_Proc_him = Job.Num_Proc_him
	Join Usuario US with(nolock) on US.Cd_Usuario = Job.cd_usuario
	Join Pessoa PP with(nolock) on PP.Cd_Pes=Cd_Consig_him
	Join Pessoa_ATL_AX AX with(nolock) on AX.Cd_Pes = PP.Cd_Pes and Tipo='C'
	Join Localidade ORg on Org.Cd_Local = Cd_Org_him
	Join Localidade DST on DST.Cd_Local = Cd_Dst_him 
	left Join Armador CIA with(nolock) on CIA.cd_armador = Job.cd_armador
	Left Join Usuario VD with(nolock) on VD.Cd_Usuario = Cd_Vendedor 
	Join Pessoa SH with(nolock) on SH.Cd_Pes=Cd_Export_him 
	Join Tipo_CArga TC on TC.cd_tp_carga=LLP.cd_tp_Carga
	LEft Join Tipo_Status_Processo TSP with(nolock) on LLP.id_Status = TSP.id_status
	Join AX_XML_Customer_Recebido AXCR with(nolock) on AXCR.AccountNum=cd_ax
	Left Join Master_Imp_MAR MAS with(nolock) on Hou.num_proc_mim=mas.num_proc_mim
	LEft Join Pessoa_ATL_AX AXA with(nolock) on AXA.Cd_Pes = cd_export_mim and AXA.Tipo='F'
	join Campo_Processo CP with(nolock) on CP.num_proc = Hou.num_proc_him and id_campo = 143
		left join campo_processo CP221 with(nolock) on cp221.num_proc = hou.num_proc_him and CP221.id_campo = 221


Where
	Num_Proc_lim = @Num_Proc 
	and Dimensao3 is not null --20250922 - no Oracle é mandatorio este campo - Cadu


Union all

--EXPORTACAO AEREA
select top 1
		0.00 InsuredAmountUSD,
	'LCL' ShipmentType,
	'No' FNClose,
	Null CustRef2,
	Null CustRef3,
	Null CustRef4,
	Null CitCustomerPO,
	(CASE WHEN CP.campo_dados = '1' THEN 'No' else 'Yes'END) BDP_JobControlled, --'Yes' BDP_JobControlled,
	Num_Proc_lea JobNbr,
	--(
	--	Case hou.Num_Proc_mea
	--		When 'JOB' then '850'
	--		else 112 
	--	End
	--)
	--AXProductCode,
	(CASE 
		WHEN isnull(CP221.campo_dados,'0')= '1' THEN 530
		WHEN hou.Num_Proc_mea = 'JOB' THEN 850
		ELSE 112
	END) AS AXProductCode,
	CONVERT(Datetime,dt_emis_hea,105) JobCreationDate	,
	US.Nome_Usuario	UserName,
	US.email			UserEmail,
	US.Fone			UserPhone,
	'BRSAO'			AXLocationCode,
	Status_Descricao_Ingles			JobStatus,
	Null			JobClosedDateAX,
	Null			JobClosedDateOps,
	Hou.HAWB_hea	HouseBOLNbr,
	HoU.MAWB_hea	MasterBOLNbr,
	(
		Case hou.Num_Proc_mea
			When 'JOB' then ''
			else hou.Num_Proc_mea
		End
	) ConsolNbr,
	 Dimensao3 GlobalCustomerCode,
	 ax.cd_ax ClientCode,
	 PP.Nome_Raz_Soc ConsigneeName,
	 
	case 
		when hou.Num_Proc_HEA like '%HNK%' then left(dbo.fBusca_TipoDocCliente('N',num_proc_lea,8),100) 
		else 	 left(dbo.fBusca_TipoDocCliente('N',num_proc_lea,1),100) 
	End

	 
	 CustRef1,
	 ORg.Cd_Pais CountryOfOrigin,
	 Org.SCAC PortOfLoad,
	 ETD_lea EstSailDate,
	 ATD_lea ActSailDate,
	 DST.Cd_Pais CountryOfDestination,
	 DST.SCAC PortOfEntry,
	 Null EstEntryDate,
	 ATA_lea ActEntryDate,
	 Null DateOfDelivery,
	 DST.SCAC  PortOfDischarge,
	 Null PlaceOfDelivery,
	 CIA.SCAC  CarrierCode,
	 Nome_Cia_Aer CarrierName,
	 cast(Isnull(Peso_Bruto_hea,0) as decimal(18,2)) GrossWeight,
	 Cast(Isnull(Peso_Cubado_lea,0) as decimal(18,2)) GrossWeightChargeable,
	 'No' Hazardous,
	 Cd_Tp_Oper  INCOTerms,
	 Null MasterBookingNbr,
	 'Air' ModeOfTransport,
	 0 NumOfContainers,
	 Null NVOCCCode,
	 'No' OpClose,
	 Cd_Vendedor SalesPersonCode,
	 null SalespersonCodeEXT,
	 VD.Nome_Usuario SalesPersonName,
	 SH.Nome_Raz_Soc  ShipperName,
	0.00 TEU,
	 null VesselName,
	 Cast(Isnull(Vol_Tot_hea,0) as decimal(18,2))Volume,
	 left(Voo_hea,10) VoyageId,
	 @JobFirstFinTransDate JobFirstFinTransDate,
	 AX.CD_AX CustAccount,
	 SH.Nome_Raz_Soc CustName,
	 	 AXA.cd_ax AXAgentVendAccount,
	Case
		When tp_frete_hea='P' Then 'Prepaid'
		else 'Collect'	
	End
		PrepaidOrCollect,
	'Export' TransportOrientation
from 
	House_exp_Aer Hou with(nolock)
	Join LLP_exp_aer LLP with(nolock) on Num_Proc_lea=hou.num_proc_hea
	Join Job_exp_Aer Job with(nolock) on Hou.Num_Proc_hea = Job.Num_Proc_hea
	Join Usuario US with(nolock) on US.Cd_Usuario = Job.cd_usuario
	Join Pessoa PP with(nolock) on PP.Cd_Pes=Cd_Export_HEA
	Join Localidade ORg with(nolock) on Org.Cd_Local = Cd_Org_hea
	Join Localidade DST with(nolock) on DST.Cd_Local = Cd_Dst_hea 
	LEft Join Cia_Aerea CIA with(nolock) on CIA.Cd_Cia_Aer = hou.Cd_Cia_Aer 
	Left Join Usuario VD with(nolock) on VD.Cd_Usuario = Cd_Vendedor 
	Join Pessoa SH with(nolock) on SH.Cd_Pes=Cd_Export_hea 
	Join Pessoa_ATL_AX AX with(nolock) on AX.Cd_Pes = SH.Cd_Pes and Tipo='C'

	LEft Join Tipo_Status_Processo TSP with(nolock) on LLP.id_Status = TSP.id_status
	Join AX_XML_Customer_Recebido AXCR with(nolock) on AXCR.AccountNum=cd_ax
	Left Join Master_Exp_Aer MAS with(nolock) on Hou.num_proc_mea=mas.num_proc_mea
	LEft Join Pessoa_ATL_ax AXA with(nolock) on AXA.Cd_Pes = cd_Consig_mea and AXA.Tipo='F'
	join Campo_Processo CP with(nolock) on CP.num_proc = Hou.num_proc_hea and id_campo = 143
	left join campo_processo CP221 with(nolock) on cp221.num_proc = hou.Num_Proc_HEA and CP221.id_campo = 221

Where
	Num_Proc_lea = @Num_Proc
	and HOU.Cd_Export_HEA not in ('10017')
	and Dimensao3 is not null --20250922 - no Oracle é mandatorio este campo - Cadu
	

Union All

--EXPORTACAO MARITIMA
select top 1
	0.00 InsuredAmountUSD,
	Case 
		when Nome_Tp_Carga = 'Cabotagem' then 'FCL'
		else Nome_Tp_Carga
	End	 ShipmentType,
	'No' FNClose,
	Null CustRef2,
	Null CustRef3,
	Null CustRef4,
	Null CitCustomerPO,
	(CASE WHEN CP.campo_dados = '1' THEN 'No' else 'Yes'END) BDP_JobControlled, --'Yes' BDP_JobControlled,
	Num_Proc_lem JobNbr,
	--(
	--	Case hou.Num_Proc_mem
	--		When 'JOB' then '850'
	--		else 216
	--	End
	--) 
	-- AXProductCode,
	(CASE 
		WHEN isnull(CP221.campo_dados,'0')= '1' THEN 510
		WHEN hou.Num_Proc_mem = 'JOB' THEN 850
		ELSE 216
	END) AS AXProductCode,
	CONVERT(Datetime,dt_emis_hem,105) JobCreationDate	,
	US.Nome_Usuario	UserName,
	US.email			UserEmail,
	US.Fone			UserPhone,
	'BRSAO'			AXLocationCode,
	Status_Descricao_Ingles			JobStatus,
	Null			JobClosedDateAX,
	Null			JobClosedDateOps,
	Hou.HAWB_hem	HouseBOLNbr,
	HoU.MAWB_hem	MasterBOLNbr,
	(
		Case hou.Num_Proc_mem
			When 'JOB' then ''
			else hou.Num_Proc_mem
		End
	) ConsolNbr,
	 Dimensao3 GlobalCustomerCode,
	 ax.cd_ax ClientCode,
	 PP.Nome_Raz_Soc ConsigneeName,
	 case 
		when hou.Num_Proc_Hem like '%HNK%' then left(dbo.fBusca_TipoDocCliente('N',num_proc_lem,8),100) 
		else 	 left(dbo.fBusca_TipoDocCliente('N',num_proc_lem,1),100) 
	End
 CustRef1,
	 ORg.Cd_Pais CountryOfOrigin,
	 Org.SCAC PortOfLoad,
	 ETD_lem EstSailDate,
	 ATD_lem ActSailDate,
	 DST.Cd_Pais CountryOfDestination,
	 DST.SCAC PortOfEntry,
	 Null EstEntryDate,
	 ATA_lem ActEntryDate,
	 Null DateOfDelivery,
	 DST.SCAC  PortOfDischarge,
	 Null PlaceOfDelivery,
	 CIA.SCAC  CarrierCode,
	 Nome_ARmador CarrierName,
	 cast(Isnull(Peso_Bruto_hem ,0)as decimal(18,2)) GrossWeight,
	 Cast(Isnull(Peso_Bruto_hem,0) as decimal(18,2)) GrossWeightChargeable,
	 'No' Hazardous,
	 Cd_Tp_Oper  INCOTerms,
	 Null MasterBookingNbr,
	 'Ocean' ModeOfTransport,
	 0 NumOfContainers,
	 Null NVOCCCode,
	 'No' OpClose,
	 Cd_Vendedor SalesPersonCode,
	 null SalespersonCodeEXT,
	 VD.Nome_Usuario SalesPersonName,
	 SH.Nome_Raz_Soc  ShipperName,
	 [dbo].[fBusca_TEUS](@Num_PRoc)  TEU,
	 Navio_hem VesselName,
	 Cast(ISnull(Vol_Tot_hem,0) as decimal(18,2))Volume,
	 left(Viagem_hem,10) VoyageId,
	 @JobFirstFinTransDate JobFirstFinTransDate,
	 ax.CD_AX CustAccount,
	 SH.Nome_Raz_Soc CustName,
	 	 AXA.cd_ax AXAgentVendAccount,
	Case
		When tp_frete_hem='P' Then 'Prepaid'
		else 'Collect'
	
	End	PrepaidOrCollect,
	'Export' TransportOrientation
from 
	House_exp_mar Hou with(nolock)
	Join LLP_exp_mar LLP with(nolock) on Num_Proc_lem=hou.num_proc_hem
	Join Job_exp_mar Job with(nolock) on Hou.Num_Proc_hem = Job.Num_Proc_hem
	Join Usuario US with(nolock) on US.Cd_Usuario = Job.cd_usuario
	Join Pessoa PP with(nolock) on PP.Cd_Pes=Cd_Consig_hem
	
	Left Join Localidade ORg with(nolock) on Org.Cd_Local = Cd_Org_hem
	Left Join Localidade DST with(nolock) on DST.Cd_Local = Cd_Dst_hem 
	LEft Join Armador CIA with(nolock) on CIA.cd_armador = cd_armador_lem
	Left Join Usuario VD with(nolock) on VD.Cd_Usuario = Cd_Vendedor 
	Join Pessoa SH with(nolock) on SH.Cd_Pes=Cd_Export_hem 
	Join Pessoa_ATL_AX AX with(nolock) on AX.Cd_Pes = SH.Cd_Pes and Tipo='C'
	Left Join Tipo_CArga TC with(nolock) on TC.cd_tp_carga=LLP.cd_tp_Carga
	LEft Join Tipo_Status_Processo TSP with(nolock) on LLP.id_Status = TSP.id_status
	Join AX_XML_Customer_Recebido AXCR with(nolock) on AXCR.AccountNum=AX.cd_ax
Left Join Master_Exp_mar MAS with(nolock) on Hou.num_proc_mem=mas.num_proc_mem
	LEft Join Pessoa_ATL_AX AXA with(nolock) on AXA.Cd_Pes = cd_Consig_mem and AXA.Tipo='F'
	join Campo_Processo CP with(nolock) on CP.num_proc = Hou.num_proc_hem and id_campo = 143
			left join campo_processo CP221 with(nolock) on CP221.num_proc = hou.num_proc_hem and CP221.id_campo = 221

Where
	Num_Proc_lem = @Num_Proc 
	and HOU.Cd_Export_hem not in ('10017')
	and Dimensao3 is not null --20250922 - no Oracle é mandatorio este campo - Cadu


Union all

--IMPORTACAO OUTROS
select top 1
	0.00 InsuredAmountUSD,
	'LCL' ShipmentType,
	'No' FNClose,
	Null CustRef2,
	Null CustRef3,
	Null CustRef4,
	Null CitCustomerPO,
	(CASE WHEN CP.campo_dados = '1' THEN 'No' else 'Yes'END) BDP_JobControlled, --'Yes' BDP_JobControlled,
	Num_Proc_LIo JobNbr,
	850 AXProductCode,
	CONVERT(Datetime,dt_emis_hio,105) JobCreationDate	,
	US.Nome_Usuario	UserName,
	US.email			UserEmail,
	US.Fone			UserPhone,
	'BRSAO'			AXLocationCode,
	Status_Descricao_Ingles			JobStatus,
	Null			JobClosedDateAX,
	Null			JobClosedDateOps,
	Hou.HAWB_HIo	HouseBOLNbr,
	HoU.MAWB_HIo	MasterBOLNbr,
	'' ConsolNbr,
	 Dimensao3 GlobalCustomerCode,
	 cd_ax ClientCode,
	 PP.Nome_Raz_Soc ConsigneeName,
	 	 case 
		when hou.Num_Proc_HIO like '%HNK%' then left(dbo.fBusca_TipoDocCliente('N',num_proc_lio,8),100) 
		else 	 left(dbo.fBusca_TipoDocCliente('N',num_proc_lio,1),100) 
	End

	 
	 CustRef1,
	 ORg.Cd_Pais CountryOfOrigin,
	 Org.SCAC PortOfLoad,
	 ETD_LIo EstSailDate,
	 ATD_LIo ActSailDate,
	 DST.Cd_Pais CountryOfDestination,
	 DST.SCAC PortOfEntry,
	 Null EstEntryDate,
	 ATA_LIo ActEntryDate,
	 Null DateOfDelivery,
	 DST.SCAC  PortOfDischarge,
	 Null PlaceOfDelivery,
	 ''  CarrierCode,
	 CIa.Nome_Raz_Soc CarrierName,
	 cast(Isnull(Peso_Bruto_HIo,0) as decimal(18,2)) GrossWeight,
	 Cast(Isnull(Peso_Cubado_LIo,0) as decimal(18,2)) GrossWeightChargeable,
	 'No' Hazardous,
	 Cd_Tp_Oper  INCOTerms,
	 Null MasterBookingNbr,
	 'Truck' ModeOfTransport,
	 0 NumOfContainers,
	 Null NVOCCCode,
	 'No' OpClose,
	 Cd_Vendedor SalesPersonCode,
	 null SalespersonCodeEXT,
	 VD.Nome_Usuario SalesPersonName,
	 SH.Nome_Raz_Soc  ShipperName,
	0.00 TEU,
	 null VesselName,
	 Cast(Isnull(Vol_Tot_HIo,0) as decimal(18,2))Volume,
	 '' VoyageId,
	 @JobFirstFinTransDate JobFirstFinTransDate,
	 CD_AX CustAccount,
	 PP.Nome_Raz_Soc CustName,
	 	 Null AXAgentVendAccount,
	Case
		When tp_frete_hio='P' Then 'Prepaid'
		else 'Collect'
	
	End		PrepaidOrCollect,
	'Import' TransportOrientation

from 
	House_Imp_out Hou with(nolock)
	Join LLP_Imp_out LLP with(nolock) on Num_Proc_Lio=hou.num_proc_hio
	Join Usuario US with(nolock) on US.Cd_Usuario = llp.cd_usuario
	Join Pessoa PP with(nolock) on PP.Cd_Pes=Cd_Consig_HIo
	Join Pessoa_ATL_AX AX with(nolock) on AX.Cd_Pes = PP.Cd_Pes and Tipo='C'
	Join Localidade ORg with(nolock) on Org.Cd_Local = Cd_Org_HIo
	Join Localidade DST with(nolock) on DST.Cd_Local = Cd_Dst_HIo 
	left Join Pessoa CIA with(nolock) on CIA.cd_pes= cd_carrier
	Left Join Usuario VD with(nolock) on VD.Cd_Usuario = Cd_Vendedor 
	Join Pessoa SH with(nolock) on SH.Cd_Pes=Cd_Export_HIo 
	LEft Join Tipo_Status_Processo TSP with(nolock) on LLP.id_Status = TSP.id_status
	Join AX_XML_Customer_Recebido AXCR with(nolock) on AXCR.AccountNum=cd_ax
	join Campo_Processo CP with(nolock) on CP.num_proc = Hou.num_proc_hio and id_campo = 143

Where
	Num_Proc_Lio = @Num_Proc 
	and Dimensao3 is not null --20250922 - no Oracle é mandatorio este campo - Cadu
	
Union all

--EXPORTACAO OUTROS
select top 1
	0.00 InsuredAmountUSD,
	'LCL' ShipmentType,
	'No' FNClose,
	Null CustRef2,
	Null CustRef3,
	Null CustRef4,
	Null CitCustomerPO,
	(CASE WHEN CP.campo_dados = '1' THEN 'No' else 'Yes'END) BDP_JobControlled, --'Yes' BDP_JobControlled,
	Num_Proc_Leo JobNbr,
	850 AXProductCode,
	CONVERT(Datetime,dt_emis_heo,105) JobCreationDate	,
	US.Nome_Usuario	UserName,
	US.email			UserEmail,
	US.Fone			UserPhone,
	'BRSAO'			AXLocationCode,
	Status_Descricao_Ingles			JobStatus,
		Null			JobClosedDateAX,
	Null			JobClosedDateOps,
	Hou.HAWB_Heo	HouseBOLNbr,
	''				MasterBOLNbr,
	'' ConsolNbr,
	 Dimensao3 GlobalCustomerCode,
	 cd_ax ClientCode,
	 PP.Nome_Raz_Soc ConsigneeName,
	 case 
		when hou.Num_Proc_HEO like '%HNK%' then left(dbo.fBusca_TipoDocCliente('N',num_proc_leo,8),100) 
		else 	 left(dbo.fBusca_TipoDocCliente('N',num_proc_leo,1),100) 
	End
 CustRef1,
	 ORg.Cd_Pais CountryOfOrigin,
	 Org.SCAC PortOfLoad,
	 ETD_Leo EstSailDate,
	 ATD_Leo ActSailDate,
	 DST.Cd_Pais CountryOfDestination,
	 DST.SCAC PortOfEntry,
	 Null EstEntryDate,
	 ATA_Leo ActEntryDate,
	 Null DateOfDelivery,
	 DST.SCAC  PortOfDischarge,
	 Null PlaceOfDelivery,
	 ''  CarrierCode,
	 left(dbo.FRemoveAcentuacao(cia.Nome_Raz_Soc),59) CarrierName,
	 cast(Isnull(Peso_Bruto_HEO,0) as decimal(18,2)) GrossWeight,
	 Cast(Isnull(Peso_Cubado_LEO,0) as decimal(18,2)) GrossWeightChargeable,
	 'No' Hazardous,
	 Cd_Tp_Oper  INCOTerms,
	 Null MasterBookingNbr,
	 'Truck' ModeOfTransport,
	 0 NumOfContainers,
	 Null NVOCCCode,
	 'No' OpClose,
	 Cd_Vendedor SalesPersonCode,
	 null SalespersonCodeEXT,
	 VD.Nome_Usuario SalesPersonName,
	 SH.Nome_Raz_Soc  ShipperName,
	0.00 TEU,
	 null VesselName,
	 Cast(Isnull(Vol_Tot_Heo,0) as decimal(18,2))Volume,
	 '' VoyageId,
	 @JobFirstFinTransDate JobFirstFinTransDate,
	 CD_AX CustAccount,
	 SH.Nome_Raz_Soc CustName,
	 	 	 Null AXAgentVendAccount,
	Case
		When tp_frete_heo='P' Then 'Prepaid'
		else 'Collect'
	
	End PrepaidOrCollect,
	'Export' TransportOrientation
from 
	House_exp_out Hou
	Join LLP_exp_out LLP with(nolock) on Num_Proc_Leo=hou.num_proc_heo
	Join Usuario US with(nolock) on US.Cd_Usuario = llp.cd_usuario
	Join Pessoa PP with(nolock) on PP.Cd_Pes=Cd_Consig_heo
	Join Localidade ORg with(nolock) on Org.Cd_Local = Cd_Org_Heo
	Join Localidade DST with(nolock) on DST.Cd_Local = Cd_Dst_Heo 
	Left Join Pessoa CIA with(nolock) on cia.cd_pes=cd_carrier
	Left Join Usuario VD with(nolock) on VD.Cd_Usuario = Cd_Vendedor 
	Join Pessoa SH with(nolock) on SH.Cd_Pes=Cd_Export_Heo 
	Join Pessoa_ATL_AX AX with(nolock) on AX.Cd_Pes = SH.Cd_Pes and Tipo='C'
	LEft Join Tipo_Status_Processo TSP with(nolock) on LLP.id_Status = TSP.id_status
	Join AX_XML_Customer_Recebido AXCR with(nolock) on AXCR.AccountNum=cd_ax
	join Campo_Processo CP with(nolock) on CP.num_proc = Hou.num_proc_heo and id_campo = 143
	
Where
	Num_Proc_Leo= @Num_Proc 
	and HOU.Cd_Export_heo not in ('10017')
	and Dimensao3 is not null --20250922 - no Oracle é mandatorio este campo - Cadu
	
Union all

--BDP Others
select top 1
	0.00								InsuredAmountUSD,
	'LCL'								ShipmentType,
	'No'								FNClose,
	Null								CustRef2,
	Null								CustRef3,
	Null								CustRef4,
	Null								CitCustomerPO,
	(CASE WHEN CP.campo_dados = '1' THEN 'No' else 'Yes'END) BDP_JobControlled, --'Yes' BDP_JobControlled,
	Num_Proc_LBO						JobNbr,
	800									AXProductCode,
	CONVERT(Datetime,Dt_Emis_HBO,105)	JobCreationDate	,
	US.Nome_Usuario						UserName,
	US.email							UserEmail,
	US.Fone								UserPhone,
	'BRSAO'								AXLocationCode,
	Status_Descricao_Ingles				JobStatus,
	Null								JobClosedDateAX,
	Null								JobClosedDateOps,
	''									HouseBOLNbr,
	''									MasterBOLNbr,
	''									ConsolNbr,
	Dimensao3							GlobalCustomerCode,
	cd_ax								ClientCode,
	PP.Nome_Raz_Soc						ConsigneeName,	
	Null								CustRef1,				
	Null								CountryOfOrigin,			
	Null								PortOfLoad,				
	Null								EstSailDate,				
	Null								ActSailDate,				
	Null								CountryOfDestination,	
	Null								PortOfEntry,				
	Null								EstEntryDate,
	Null								ActEntryDate,			
	Null								DateOfDelivery,
	Null								PortOfDischarge,			
	Null								PlaceOfDelivery,
	''									CarrierCode,
	''									CarrierName,				
	0.00								GrossWeight,				
	0.00 								GrossWeightChargeable,	
	'No' 								Hazardous,
	'' 									INCOTerms,				
	Null 								MasterBookingNbr,
	'Others' 							ModeOfTransport, 
	0 									NumOfContainers,
	Null 								NVOCCCode,
	'No' 								OpClose,
	'' 									SalesPersonCode,			
	null 								SalespersonCodeEXT,
	Null								SalesPersonName,
	'' 									ShipperName,				
	0.00 								TEU,
	null 								VesselName,
	0.00 								Volume,					
	'' 									VoyageId,
	@JobFirstFinTransDate 				JobFirstFinTransDate,
	CD_AX 								CustAccount,
	PP.Nome_Raz_Soc						CustName,			
	Null 								AXAgentVendAccount,
	'Prepaid' 							PrepaidOrCollect,
	'Import'							TransportOrientation
from 
	House_BDP_OUT Hou with(nolock)
	Join LLP_BDP_OUT LLP with(nolock) on Num_Proc_LBO=hou.Num_Proc_HBO
	Join Usuario US with(nolock) on US.Cd_Usuario = llp.cd_usuario
	Join Pessoa PP with(nolock) on PP.Cd_Pes=HOU.cd_cliente_hbo
	Join Pessoa_ATL_AX AX with(nolock) on AX.Cd_Pes = PP.Cd_Pes and Tipo='C'	
	Left Join Usuario VD with(nolock) on VD.Cd_Usuario = llp.cd_usuario 	
	LEft Join Tipo_Status_Processo TSP with(nolock) on LLP.id_Status = TSP.id_status
	Join AX_XML_Customer_Recebido AXCR with(nolock) on AXCR.AccountNum=cd_ax
	join Campo_Processo CP with(nolock) on CP.num_proc = Hou.Num_Proc_HBO and id_campo = 143
Where
	Num_Proc_LBO= @Num_Proc and LLP.Id_TP_Servico > 1
	and Dimensao3 is not null --20250922 - no Oracle é mandatorio este campo - Cadu
	
	
UNION ALL
--BDP Outros com JOB Amarrado

	select top 1
	0.00								InsuredAmountUSD,
	(
		Case LEFT(JBO.Num_Proc,2) 
			when 'IM' then 
				(Case 
					when TC.Nome_Tp_Carga = 'Cabotagem' then 'FCL'
					else TC.Nome_Tp_Carga
				End)
			when 'IA' then 'LCL' 
			when 'EA' then 'LCL'
			when 'EM' then
				(Case 
					when TC.Nome_Tp_Carga = 'Cabotagem' then 'FCL'
					else TC.Nome_Tp_Carga
				End)
			when 'EO' then 'LCL'
			when 'IO' then 'LCL'
		End
	)									ShipmentType,
	'No'								FNClose,
	Null								CustRef2,
	Null								CustRef3,
	Null								CustRef4,
	Null								CitCustomerPO,
	--'Yes'								BDP_JobControlled,
	(CASE WHEN CP.campo_dados = '1' THEN 'No' else 'Yes'END) BDP_JobControlled, --'Yes' BDP_JobControlled,
	Num_Proc_LBO						JobNbr,
	
	(Case LEFT(JBO.Num_Proc,2) 
		when 'IM' then
			(Case V.Master
				When 'JOB' then '850'
				else 221
			End)				
		when 'IA' then 
			(Case V.Master
				When 'JOB' then '850'
				else 122 
			End)
		when 'EA' then 
			(Case V.Master
				When 'JOB' then '850'
				else 112 
			End)
		when 'EM' then 
			(Case V.Master
				When 'JOB' then '850'
				else 216
			End)
		when 'EO' then 850
		when 'IO' then 850		
	End)								AXProductCode,
	
	CONVERT(Datetime,Dt_Emis_HBO,105)	JobCreationDate	,
	US.Nome_Usuario						UserName,
	US.email							UserEmail,
	US.Fone								UserPhone,
	'BRSAO'								AXLocationCode,
	Status_Descricao_Ingles				JobStatus,
	Null								JobClosedDateAX,
	Null								JobClosedDateOps,
	V.HAWB								HouseBOLNbr,
	V.MAWB								MasterBOLNbr,	
	
	--(Case LEFT(JBO.Num_Proc,2) 
	--	when 'IM' then
	--		(Case V.Master
	--			When 'JOB' then ''
	--			else V.Master
	--		End)				
	--	when 'IA' then 
	--		(Case V.Master
	--			When 'JOB' then ''
	--			else V.Master 
	--		End)
	--	when 'EA' then 
	--		(Case V.Master
	--			When 'JOB' then ''
	--			else V.Master
	--		End)
	--	when 'EM' then 
	--		(Case V.Master
	--			When 'JOB' then ''
	--			else V.Master
	--		End)
	--	when 'EO' then ''
	--	when 'IO' then ''		
	--End)
	JBO.Num_Proc						ConsolNbr,
	Dimensao3							GlobalCustomerCode,
	AX.cd_ax							ClientCode,
	PP.Nome_Raz_Soc						ConsigneeName,
	left(dbo.fBusca_TipoDocCliente('N',JBO.Num_Proc,1),100) CustRef1,	
	ORg.Cd_Pais							CountryOfOrigin,
	Org.SCAC							PortOfLoad,
	V.ETD								EstSailDate,
	V.ATD								ActSailDate,
	DST.Cd_Pais							CountryOfDestination,
	DST.SCAC							PortOfEntry,	
	Null								EstEntryDate,
	V.ATA								ActEntryDate,
	Null								DateOfDelivery,
	DST.SCAC							PortOfDischarge,
	Null								PlaceOfDelivery,
	
	(Case LEFT(JBO.Num_Proc,2) 
		when 'IM' then
			Armador.SCAC			
		when 'IA' then 
			Cia_Aerea.SCAC
		when 'EA' then 
			Cia_Aerea.SCAC
		when 'EM' then 
			Armador.SCAC
		when 'EO' then ''
		when 'IO' then ''		
	End)								CarrierCode,
	(Case LEFT(JBO.Num_Proc,2) 
		when 'IM' then
			Armador.Nome_Armador			
		when 'IA' then 
			Cia_Aerea.Nome_Cia_Aer
		when 'EA' then 
			Cia_Aerea.Nome_Cia_Aer
		when 'EM' then 
			Armador.Nome_Armador
		when 'EO' then 
			Carrier.Nome_Raz_Soc
		when 'IO' then 
			Carrier.Nome_Raz_Soc		
	End)								CarrierName,
	
	cast(Isnull(V.Peso_Bruto,0) as decimal(18,2)) GrossWeight,
	
	(Case LEFT(JBO.Num_Proc,2) 
		when 'IM' then
			cast(Isnull(V.Peso_Bruto,0) as decimal(18,2))			
		when 'IA' then 
			Cast(Isnull(V.Peso_cubado,0) as decimal(18,2))
		when 'EA' then 
			Cast(Isnull(V.Peso_cubado,0) as decimal(18,2))
		when 'EM' then 
			cast(Isnull(V.Peso_Bruto,0) as decimal(18,2))
		when 'EO' then 
			Cast(Isnull(V.Peso_cubado,0) as decimal(18,2))
		when 'IO' then 
			Cast(Isnull(V.Peso_cubado,0) as decimal(18,2))		
	End)								 GrossWeightChargeable,
		
	'No' 								Hazardous,
	Hou.Cd_tp_oper						Incoterms,				
	Null 								MasterBookingNbr,
	(Case LEFT(JBO.Num_Proc,2) 
		when 'IM' then
			'Ocean'			
		when 'IA' then 
			'Air'
		when 'EA' then 
			'Air'
		when 'EM' then 
			'Ocean'
		when 'EO' then 
			'Truck'
		when 'IO' then 
			'Truck'		
	End) 								ModeOfTransport, 
	0 									NumOfContainers,
	Null 								NVOCCCode,
	'No' 								OpClose,
	V.cd_vendedor						SalesPersonCode,			
	null 								SalespersonCodeEXT,
	VD.Nome_Usuario						SalesPersonName,
	SH.Nome_Raz_Soc						ShipperName,				
	0.00 								TEU,
	V.Navio								VesselName,
	Cast(Isnull(V.Vol_Tot,0) as decimal(18,2))Volume,
	Left(V.Viagem ,10)					VoyageId,
	--V.Viagem 							VoyageId,
	@JobFirstFinTransDate 				JobFirstFinTransDate,
	AX.CD_AX 							CustAccount,
	(Case LEFT(JBO.Num_Proc,2) 
		when 'IM' then
			PP.Nome_Raz_Soc		
		when 'IA' then 
			PP.Nome_Raz_Soc	
		when 'EA' then 
			SH.Nome_Raz_Soc
		when 'EM' then 
			SH.Nome_Raz_Soc
		when 'EO' then 
			SH.Nome_Raz_Soc
		when 'IO' then 
			PP.Nome_Raz_Soc		
	End)								CustName,			
	
	AXA.cd_ax AXAgentVendAccount,
	V.Tipo_Frete					PrepaidOrCollect,

	(Case LEFT(JBO.Num_Proc,1) 
		when 'I' then
			'Import'	
		when 'E' then 
			'Export'
		
	End)							TransportOrientation

from 
	House_BDP_OUT		Hou		with(nolock)
	Join LLP_BDP_OUT	LLP		with(nolock) on Num_Proc_LBO=hou.Num_Proc_HBO
	Join Usuario		US		with(nolock) on US.Cd_Usuario = llp.cd_usuario
	Join Pessoa			PP		with(nolock) on PP.Cd_Pes=HOU.cd_cliente_hbo
	Join Pessoa_ATL_AX	AX		with(nolock) on AX.Cd_Pes = PP.Cd_Pes and Tipo='C'
	
	join JOB_HBO		JBO		with(nolock) on JBO.Num_Proc_HBO = Hou.num_proc_hbo	
	--join vwAX_Interface V		with(nolock) on V.Num_Proc = JBO.Num_Proc	
	
	join vwAX_Interface_HBO V		with(nolock) on V.Num_Proc = JBO.Num_Proc
	left Join Tipo_Carga		TC		with(nolock) on TC.cd_tp_carga= V.cd_tp_Carga	
	Join Localidade		ORg		with(nolock) on Org.Cd_Local = V.Cd_Org
	Join Localidade		DST		with(nolock) on DST.Cd_Local = v.Cd_Dst 
	
	left Join Cia_Aerea Cia_Aerea	with(nolock)on Cia_Aerea.Cd_Cia_Aer = V.cd_armador 
	left Join Armador	Armador		with(nolock) on Armador.cd_armador = V.cd_armador
	Left Join Pessoa	Carrier		with(nolock) on Carrier.cd_pes=V.cd_armador
	Left Join Usuario	VD			with(nolock) on VD.Cd_Usuario = V.cd_vendedor 
	Join Pessoa			SH			with(nolock) on SH.Cd_Pes=V.cd_export	
		
	LEft Join Tipo_Status_Processo TSP with(nolock) on LLP.id_Status = TSP.id_status
	
	Join AX_XML_Customer_Recebido AXCR with(nolock) on AXCR.AccountNum=AX.cd_ax	
	LEft Join Pessoa_ATL_AX AXA with(nolock) on AXA.Cd_Pes = V.cd_cliente_master and AXA.Tipo='F'
	join Campo_Processo CP with(nolock) on CP.num_proc = Hou.Num_Proc_HBO and id_campo = 143
Where
	Num_Proc_LBO= @Num_Proc and LLP.Id_TP_Servico = 1
	and Dimensao3 is not null --20250922 - no Oracle é mandatorio este campo - Cadu



	/*
----IMPORTACAO AEREA
--select top 1
--	0.00 InsuredAmountUSD,
--	'LCL' ShipmentType,
--	'No' FNClose,
--	Null CustRef2,
--	Null CustRef3,
--	Null CustRef4,
--	Null CitCustomerPO,
--	'Yes' BDP_JobControlled,
--	Num_Proc_LIA JobNbr,
--	(
--		Case hou.Num_Proc_MIA
--			When 'JOB' then '850'
--			else 122 
--		End
--	)
--	AXProductCode,
--	CONVERT(Datetime,dt_emis_hia,105) JobCreationDate	,
--	US.Nome_Usuario	UserName,
--	US.email			UserEmail,
--	US.Fone			UserPhone,
--	'BRSAO'			AXLocationCode,
--	Status_Descricao_Ingles			JobStatus,
--	Null							JobClosedDateAX,
--	Null							JobClosedDateOps,
--	Hou.HAWB_HIA					HouseBOLNbr,
--	HoU.MAWB_HIA	MasterBOLNbr,
--	(
--		Case hou.Num_Proc_MIA
--			When 'JOB' then ''
--			else hou.Num_Proc_MIA
--		End
--	) ConsolNbr,
--	 Dimensao3 GlobalCustomerCode,
--	 AX.cd_ax ClientCode,
--	 PP.Nome_Raz_Soc ConsigneeName,
--	 left(dbo.fBusca_TipoDocCliente('N',num_proc_lia,1),100) CustRef1,
--	 ORg.Cd_Pais CountryOfOrigin,
--	 Org.SCAC PortOfLoad,
--	 ETD_LIA EstSailDate,
--	 ATD_LIA ActSailDate,
--	 DST.Cd_Pais CountryOfDestination,
--	 DST.SCAC PortOfEntry,
--	 Null EstEntryDate,
--	 ATA_LIA ActEntryDate,
--	 Null DateOfDelivery,
--	 DST.SCAC  PortOfDischarge,
--	 Null PlaceOfDelivery,
--	 CIA.SCAC  CarrierCode,
--	 Nome_Cia_Aer CarrierName,
--	 cast(Isnull(Peso_Bruto_HIA,0) as decimal(18,2)) GrossWeight,
--	 Cast(Isnull(Peso_Cubado_LIA,0) as decimal(18,2)) GrossWeightChargeable,
--	 'No' Hazardous,
--	 Cd_Tp_Oper  INCOTerms,
--	 Null MasterBookingNbr,
--	 'Air' ModeOfTransport,
--	 0 NumOfContainers,
--	 Null NVOCCCode,
--	 'No' OpClose,
--	 Cd_Vendedor SalesPersonCode,
--	 null SalespersonCodeEXT,
--	 VD.Nome_Usuario SalesPersonName,
--	 SH.Nome_Raz_Soc  ShipperName,
--	0.00 TEU,
--	 null VesselName,
--	 Cast(Isnull(Vol_Tot_HIA,0) as decimal(18,2))Volume,
--	 Left(Voo_HIA,10) VoyageId,
--	 @JobFirstFinTransDate JobFirstFinTransDate,
--	 AX.CD_AX CustAccount,
--	 PP.Nome_Raz_Soc CustName,
--	AXA.cd_ax AXAgentVendAccount,
--	Case
--		When tp_frete_hia='P' Then 'Prepaid'
--		else 'Collect'
	
--	End
--		PrepaidOrCollect

--from 
--	House_Imp_Aer Hou
--	Join LLP_Imp_aer LLP with(nolock) on Num_Proc_Lia=hou.num_proc_hia
--	Join Job_Imp_Aer Job with(nolock) on Hou.Num_Proc_HIA = Job.Num_Proc_HIA
--	Join Usuario US with(nolock) on US.Cd_Usuario = Job.cd_usuario
--	Join Pessoa PP with(nolock) on PP.Cd_Pes=Cd_Consig_HIA
--	Join Pessoa_ATL_AX AX with(nolock) on AX.Cd_Pes = PP.Cd_Pes and Tipo='C'
--	Join Localidade ORg on Org.Cd_Local = Cd_Org_HIA
--	Join Localidade DST on DST.Cd_Local = Cd_Dst_HIA 
--	left Join Cia_Aerea CIA with(nolock) on CIA.Cd_Cia_Aer = job.Cd_Cia_Aer 
--	Left Join Usuario VD with(nolock) on VD.Cd_Usuario = Cd_Vendedor 
--	Join Pessoa SH with(nolock) on SH.Cd_Pes=Cd_Export_HIA 
--	LEft Join Tipo_Status_Processo TSP with(nolock) on LLP.id_Status = TSP.id_status
--	Join AX_XML_Customer_Recebido AXCR with(nolock) on AXCR.AccountNum=cd_ax
--	Left Join Master_Imp_Aer MAS with(nolock) on Hou.num_proc_mia=mas.num_proc_mia
--	LEft Join Pessoa_ATL_AX AXA with(nolock) on AXA.Cd_Pes = cd_export_mia and AXA.Tipo='F'
--Where
--	Num_Proc_Lia = @Num_Proc 
	


--Union All


----IMPORTACAO MARITIMA
--select top 1
--	0.00 InsuredAmountUSD,
--	Case 
--		when Nome_Tp_Carga = 'Cabotagem' then 'FCL'
--		else Nome_Tp_Carga
--	End	 ShipmentType,
--	'No' FNClose,
--	Null CustRef2,
--	Null CustRef3,
--	Null CustRef4,
--	Null CitCustomerPO,
--	'Yes' BDP_JobControlled,
--	Num_Proc_lim JobNbr,
--	(
--		Case hou.Num_Proc_mim
--			When 'JOB' then '850'
--			else 221
--		End
--	)
--	 AXProductCode,
--	CONVERT(Datetime,dt_emis_him,105) JobCreationDate	,
--	US.Nome_Usuario	UserName,
--	US.email			UserEmail,
--	US.Fone			UserPhone,
--	'BRSAO'			AXLocationCode,
--	Status_Descricao_Ingles			JobStatus,
--	Null			JobClosedDateAX,
--	Null			JobClosedDateOps,
--	Hou.HAWB_him	HouseBOLNbr,
--	HoU.MAWB_him	MasterBOLNbr,
--	(
--		Case hou.Num_Proc_mim
--			When 'JOB' then ''
--			else hou.Num_Proc_mim
--		End
--	) ConsolNbr,
--	 Dimensao3 GlobalCustomerCode,
--	 AX.cd_ax ClientCode,
--	 PP.Nome_Raz_Soc ConsigneeName,
--	 left(dbo.fBusca_TipoDocCliente('N',num_proc_lim,1),100) CustRef1,
--	 ORg.Cd_Pais CountryOfOrigin,
--	 Org.SCAC PortOfLoad,
--	 ETD_lim EstSailDate,
--	 ATD_lim ActSailDate,
--	 DST.Cd_Pais CountryOfDestination,
--	 DST.SCAC PortOfEntry,
--	 Null EstEntryDate,
--	 ATA_lim ActEntryDate,
--	 Null DateOfDelivery,
--	 DST.SCAC  PortOfDischarge,
--	 Null PlaceOfDelivery,
--	 CIA.SCAC  CarrierCode,
--	 Nome_ARmador CarrierName,
--	 cast(isnull(Peso_Bruto_him,0) as decimal(18,2)) GrossWeight,
--	 Cast(Isnull(Peso_Bruto_him,0) as decimal(18,2)) GrossWeightChargeable,
--	 'No' Hazardous,
--	 Cd_Tp_Oper  INCOTerms,
--	 Null MasterBookingNbr,
--	 'Ocean' ModeOfTransport,
--	 0 NumOfContainers,
--	 Null NVOCCCode,
--	 'No' OpClose,
--	 Cd_Vendedor SalesPersonCode,
--	 null SalespersonCodeEXT,
--	 VD.Nome_Usuario SalesPersonName,
--	 SH.Nome_Raz_Soc  ShipperName,
--	 [dbo].[fBusca_TEUS](@Num_PRoc)  TEU,
--	 Navio_HIM VesselName,
--	 Cast(Isnull(Vol_Tot_him,0) as decimal(18,2))Volume,
--	 left(Viagem_HIM,10) VoyageId,
--	 @JobFirstFinTransDate JobFirstFinTransDate,
--	 AX.CD_AX CustAccount,
--	 PP.Nome_Raz_Soc CustName,
--	 AXA.cd_ax AXAgentVendAccount,
--	Case
--		When tp_frete_him='P' Then 'Prepaid'
--		else 'Collect'
	
--	End
--		PrepaidOrCollect
--from 
--	House_Imp_mar Hou
--	Join LLP_Imp_mar LLP with(nolock) on Num_Proc_lim=hou.num_proc_him
--	Join Job_Imp_mar Job with(nolock) on Hou.Num_Proc_him = Job.Num_Proc_him
--	Join Usuario US with(nolock) on US.Cd_Usuario = Job.cd_usuario
--	Join Pessoa PP with(nolock) on PP.Cd_Pes=Cd_Consig_him
--	Join Pessoa_ATL_AX AX with(nolock) on AX.Cd_Pes = PP.Cd_Pes and Tipo='C'
--	Join Localidade ORg on Org.Cd_Local = Cd_Org_him
--	Join Localidade DST on DST.Cd_Local = Cd_Dst_him 
--	left Join Armador CIA with(nolock) on CIA.cd_armador = Job.cd_armador
--	Left Join Usuario VD with(nolock) on VD.Cd_Usuario = Cd_Vendedor 
--	Join Pessoa SH with(nolock) on SH.Cd_Pes=Cd_Export_him 
--	Join Tipo_CArga TC on TC.cd_tp_carga=LLP.cd_tp_Carga
--	LEft Join Tipo_Status_Processo TSP with(nolock) on LLP.id_Status = TSP.id_status
--	Join AX_XML_Customer_Recebido AXCR with(nolock) on AXCR.AccountNum=cd_ax
--	Left Join Master_Imp_MAR MAS with(nolock) on Hou.num_proc_mim=mas.num_proc_mim
--	LEft Join Pessoa_ATL_AX AXA with(nolock) on AXA.Cd_Pes = cd_export_mim and AXA.Tipo='F'

--Where
--	Num_Proc_lim = @Num_Proc 


--Union all

----EXPORTACAO AEREA
--select top 1
--		0.00 InsuredAmountUSD,
--	'LCL' ShipmentType,
--	'No' FNClose,
--	Null CustRef2,
--	Null CustRef3,
--	Null CustRef4,
--	Null CitCustomerPO,
--	'Yes' BDP_JobControlled,
--	Num_Proc_lea JobNbr,
--	(
--		Case hou.Num_Proc_mea
--			When 'JOB' then '850'
--			else 112 
--		End
--	)
--	AXProductCode,
--	CONVERT(Datetime,dt_emis_hea,105) JobCreationDate	,
--	US.Nome_Usuario	UserName,
--	US.email			UserEmail,
--	US.Fone			UserPhone,
--	'BRSAO'			AXLocationCode,
--	Status_Descricao_Ingles			JobStatus,
--	Null			JobClosedDateAX,
--	Null			JobClosedDateOps,
--	Hou.HAWB_hea	HouseBOLNbr,
--	HoU.MAWB_hea	MasterBOLNbr,
--	(
--		Case hou.Num_Proc_mea
--			When 'JOB' then ''
--			else hou.Num_Proc_mea
--		End
--	) ConsolNbr,
--	 Dimensao3 GlobalCustomerCode,
--	 ax.cd_ax ClientCode,
--	 PP.Nome_Raz_Soc ConsigneeName,
--	 left(dbo.fBusca_TipoDocCliente('N',num_proc_lea,1),100) CustRef1,
--	 ORg.Cd_Pais CountryOfOrigin,
--	 Org.SCAC PortOfLoad,
--	 ETD_lea EstSailDate,
--	 ATD_lea ActSailDate,
--	 DST.Cd_Pais CountryOfDestination,
--	 DST.SCAC PortOfEntry,
--	 Null EstEntryDate,
--	 ATA_lea ActEntryDate,
--	 Null DateOfDelivery,
--	 DST.SCAC  PortOfDischarge,
--	 Null PlaceOfDelivery,
--	 CIA.SCAC  CarrierCode,
--	 Nome_Cia_Aer CarrierName,
--	 cast(Isnull(Peso_Bruto_hea,0) as decimal(18,2)) GrossWeight,
--	 Cast(Isnull(Peso_Cubado_lea,0) as decimal(18,2)) GrossWeightChargeable,
--	 'No' Hazardous,
--	 Cd_Tp_Oper  INCOTerms,
--	 Null MasterBookingNbr,
--	 'Air' ModeOfTransport,
--	 0 NumOfContainers,
--	 Null NVOCCCode,
--	 'No' OpClose,
--	 Cd_Vendedor SalesPersonCode,
--	 null SalespersonCodeEXT,
--	 VD.Nome_Usuario SalesPersonName,
--	 SH.Nome_Raz_Soc  ShipperName,
--	0.00 TEU,
--	 null VesselName,
--	 Cast(Isnull(Vol_Tot_hea,0) as decimal(18,2))Volume,
--	 left(Voo_hea,10) VoyageId,
--	 @JobFirstFinTransDate JobFirstFinTransDate,
--	 AX.CD_AX CustAccount,
--	 SH.Nome_Raz_Soc CustName,
--	 	 AXA.cd_ax AXAgentVendAccount,
--	Case
--		When tp_frete_hea='P' Then 'Prepaid'
--		else 'Collect'
	
--	End
--		PrepaidOrCollect
--from 
--	House_exp_Aer Hou
--	Join LLP_exp_aer LLP with(nolock) on Num_Proc_lea=hou.num_proc_hea
--	Join Job_exp_Aer Job with(nolock) on Hou.Num_Proc_hea = Job.Num_Proc_hea
--	Join Usuario US with(nolock) on US.Cd_Usuario = Job.cd_usuario
--	Join Pessoa PP with(nolock) on PP.Cd_Pes=Cd_Export_HEA
--	Join Localidade ORg on Org.Cd_Local = Cd_Org_hea
--	Join Localidade DST on DST.Cd_Local = Cd_Dst_hea 
--	LEft Join Cia_Aerea CIA with(nolock) on CIA.Cd_Cia_Aer = hou.Cd_Cia_Aer 
--	Left Join Usuario VD with(nolock) on VD.Cd_Usuario = Cd_Vendedor 
--	Join Pessoa SH with(nolock) on SH.Cd_Pes=Cd_Export_hea 
--	Join Pessoa_ATL_AX AX with(nolock) on AX.Cd_Pes = SH.Cd_Pes and Tipo='C'

--	LEft Join Tipo_Status_Processo TSP with(nolock) on LLP.id_Status = TSP.id_status
--	Join AX_XML_Customer_Recebido AXCR with(nolock) on AXCR.AccountNum=cd_ax
--	Left Join Master_Exp_Aer MAS with(nolock) on Hou.num_proc_mea=mas.num_proc_mea
--	LEft Join Pessoa_ATL_ax AXA with(nolock) on AXA.Cd_Pes = cd_Consig_mea and AXA.Tipo='F'
--Where
--	Num_Proc_lea = @Num_Proc
	

--Union All

----EXPORTACAO MARITIMA

--select top 1
--	0.00 InsuredAmountUSD,
--	Case 
--		when Nome_Tp_Carga = 'Cabotagem' then 'FCL'
--		else Nome_Tp_Carga
--	End	 ShipmentType,
--	'No' FNClose,
--	Null CustRef2,
--	Null CustRef3,
--	Null CustRef4,
--	Null CitCustomerPO,
--	'Yes' BDP_JobControlled,
--	Num_Proc_lem JobNbr,
--	(
--		Case hou.Num_Proc_mem
--			When 'JOB' then '850'
--			else 216
--		End
--	) 
--	 AXProductCode,
--	CONVERT(Datetime,dt_emis_hem,105) JobCreationDate	,
--	US.Nome_Usuario	UserName,
--	US.email			UserEmail,
--	US.Fone			UserPhone,
--	'BRSAO'			AXLocationCode,
--	Status_Descricao_Ingles			JobStatus,
--	Null			JobClosedDateAX,
--	Null			JobClosedDateOps,
--	Hou.HAWB_hem	HouseBOLNbr,
--	HoU.MAWB_hem	MasterBOLNbr,
--	(
--		Case hou.Num_Proc_mem
--			When 'JOB' then ''
--			else hou.Num_Proc_mem
--		End
--	) ConsolNbr,
--	 Dimensao3 GlobalCustomerCode,
--	 ax.cd_ax ClientCode,
--	 PP.Nome_Raz_Soc ConsigneeName,
--	 left(dbo.fBusca_TipoDocCliente('N',num_proc_lem,1),100) CustRef1,
--	 ORg.Cd_Pais CountryOfOrigin,
--	 Org.SCAC PortOfLoad,
--	 ETD_lem EstSailDate,
--	 ATD_lem ActSailDate,
--	 DST.Cd_Pais CountryOfDestination,
--	 DST.SCAC PortOfEntry,
--	 Null EstEntryDate,
--	 ATA_lem ActEntryDate,
--	 Null DateOfDelivery,
--	 DST.SCAC  PortOfDischarge,
--	 Null PlaceOfDelivery,
--	 CIA.SCAC  CarrierCode,
--	 Nome_ARmador CarrierName,
--	 cast(Isnull(Peso_Bruto_hem ,0)as decimal(18,2)) GrossWeight,
--	 Cast(Isnull(Peso_Bruto_hem,0) as decimal(18,2)) GrossWeightChargeable,
--	 'No' Hazardous,
--	 Cd_Tp_Oper  INCOTerms,
--	 Null MasterBookingNbr,
--	 'Ocean' ModeOfTransport,
--	 0 NumOfContainers,
--	 Null NVOCCCode,
--	 'No' OpClose,
--	 Cd_Vendedor SalesPersonCode,
--	 null SalespersonCodeEXT,
--	 VD.Nome_Usuario SalesPersonName,
--	 SH.Nome_Raz_Soc  ShipperName,
--	 [dbo].[fBusca_TEUS](@Num_PRoc)  TEU,
--	 Navio_hem VesselName,
--	 Cast(ISnull(Vol_Tot_hem,0) as decimal(18,2))Volume,
--	 left(Viagem_hem,10) VoyageId,
--	 @JobFirstFinTransDate JobFirstFinTransDate,
--	 ax.CD_AX CustAccount,
--	 SH.Nome_Raz_Soc CustName,
--	 	 AXA.cd_ax AXAgentVendAccount,
--	Case
--		When tp_frete_hem='P' Then 'Prepaid'
--		else 'Collect'
	
--	End
--		PrepaidOrCollect
--from 
--	House_exp_mar Hou
--	Join LLP_exp_mar LLP with(nolock) on Num_Proc_lem=hou.num_proc_hem
--	Join Job_exp_mar Job with(nolock) on Hou.Num_Proc_hem = Job.Num_Proc_hem
--	Join Usuario US with(nolock) on US.Cd_Usuario = Job.cd_usuario
--	Join Pessoa PP with(nolock) on PP.Cd_Pes=Cd_Consig_hem
	
--	Left Join Localidade ORg on Org.Cd_Local = Cd_Org_hem
--	Left Join Localidade DST on DST.Cd_Local = Cd_Dst_hem 
--	LEft Join Armador CIA with(nolock) on CIA.cd_armador = cd_armador_lem
--	Left Join Usuario VD with(nolock) on VD.Cd_Usuario = Cd_Vendedor 
--	Join Pessoa SH with(nolock) on SH.Cd_Pes=Cd_Export_hem 
--	Join Pessoa_ATL_AX AX with(nolock) on AX.Cd_Pes = SH.Cd_Pes and Tipo='C'
--	Left Join Tipo_CArga TC on TC.cd_tp_carga=LLP.cd_tp_Carga
--	LEft Join Tipo_Status_Processo TSP with(nolock) on LLP.id_Status = TSP.id_status
--	Join AX_XML_Customer_Recebido AXCR with(nolock) on AXCR.AccountNum=AX.cd_ax
--Left Join Master_Exp_mar MAS with(nolock) on Hou.num_proc_mem=mas.num_proc_mem
--	LEft Join Pessoa_ATL_AX AXA with(nolock) on AXA.Cd_Pes = cd_Consig_mem and AXA.Tipo='F'
--Where
--	Num_Proc_lem = @Num_Proc 


--Union all

----IMPORTACAO OUTROS
--select top 1
--	0.00 InsuredAmountUSD,
--	'LCL' ShipmentType,
--	'No' FNClose,
--	Null CustRef2,
--	Null CustRef3,
--	Null CustRef4,
--	Null CitCustomerPO,
--	'Yes' BDP_JobControlled,
--	Num_Proc_LIo JobNbr,
--	850 AXProductCode,
--	CONVERT(Datetime,dt_emis_hio,105) JobCreationDate	,
--	US.Nome_Usuario	UserName,
--	US.email			UserEmail,
--	US.Fone			UserPhone,
--	'BRSAO'			AXLocationCode,
--	Status_Descricao_Ingles			JobStatus,
--	Null			JobClosedDateAX,
--	Null			JobClosedDateOps,
--	Hou.HAWB_HIo	HouseBOLNbr,
--	HoU.MAWB_HIo	MasterBOLNbr,
--	'' ConsolNbr,
--	 Dimensao3 GlobalCustomerCode,
--	 cd_ax ClientCode,
--	 PP.Nome_Raz_Soc ConsigneeName,
--	 left(dbo.fBusca_TipoDocCliente('N',num_proc_lio,1),100) CustRef1,
--	 ORg.Cd_Pais CountryOfOrigin,
--	 Org.SCAC PortOfLoad,
--	 ETD_LIo EstSailDate,
--	 ATD_LIo ActSailDate,
--	 DST.Cd_Pais CountryOfDestination,
--	 DST.SCAC PortOfEntry,
--	 Null EstEntryDate,
--	 ATA_LIo ActEntryDate,
--	 Null DateOfDelivery,
--	 DST.SCAC  PortOfDischarge,
--	 Null PlaceOfDelivery,
--	 ''  CarrierCode,
--	 CIa.Nome_Raz_Soc CarrierName,
--	 cast(Isnull(Peso_Bruto_HIo,0) as decimal(18,2)) GrossWeight,
--	 Cast(Isnull(Peso_Cubado_LIo,0) as decimal(18,2)) GrossWeightChargeable,
--	 'No' Hazardous,
--	 Cd_Tp_Oper  INCOTerms,
--	 Null MasterBookingNbr,
--	 'Truck' ModeOfTransport,
--	 0 NumOfContainers,
--	 Null NVOCCCode,
--	 'No' OpClose,
--	 Cd_Vendedor SalesPersonCode,
--	 null SalespersonCodeEXT,
--	 VD.Nome_Usuario SalesPersonName,
--	 SH.Nome_Raz_Soc  ShipperName,
--	0.00 TEU,
--	 null VesselName,
--	 Cast(Isnull(Vol_Tot_HIo,0) as decimal(18,2))Volume,
--	 '' VoyageId,
--	 @JobFirstFinTransDate JobFirstFinTransDate,
--	 CD_AX CustAccount,
--	 PP.Nome_Raz_Soc CustName,
--	 	 Null AXAgentVendAccount,
--	Case
--		When tp_frete_hio='P' Then 'Prepaid'
--		else 'Collect'
	
--	End
--		PrepaidOrCollect

--from 
--	House_Imp_out Hou
--	Join LLP_Imp_out LLP with(nolock) on Num_Proc_Lio=hou.num_proc_hio
--	Join Usuario US with(nolock) on US.Cd_Usuario = llp.cd_usuario
--	Join Pessoa PP with(nolock) on PP.Cd_Pes=Cd_Consig_HIo
--	Join Pessoa_ATL_AX AX with(nolock) on AX.Cd_Pes = PP.Cd_Pes and Tipo='C'
--	Join Localidade ORg on Org.Cd_Local = Cd_Org_HIo
--	Join Localidade DST on DST.Cd_Local = Cd_Dst_HIo 
--	left Join Pessoa CIA with(nolock) on CIA.cd_pes= cd_carrier
--	Left Join Usuario VD with(nolock) on VD.Cd_Usuario = Cd_Vendedor 
--	Join Pessoa SH with(nolock) on SH.Cd_Pes=Cd_Export_HIo 
--	LEft Join Tipo_Status_Processo TSP with(nolock) on LLP.id_Status = TSP.id_status
--	Join AX_XML_Customer_Recebido AXCR with(nolock) on AXCR.AccountNum=cd_ax

--Where
--	Num_Proc_Lio = @Num_Proc 
	
--Union all

----EXPORTACAO OUTROS
--select top 1
--	0.00 InsuredAmountUSD,
--	'LCL' ShipmentType,
--	'No' FNClose,
--	Null CustRef2,
--	Null CustRef3,
--	Null CustRef4,
--	Null CitCustomerPO,
--	'Yes' BDP_JobControlled,
--	Num_Proc_Leo JobNbr,
--	850 AXProductCode,
--	CONVERT(Datetime,dt_emis_heo,105) JobCreationDate	,
--	US.Nome_Usuario	UserName,
--	US.email			UserEmail,
--	US.Fone			UserPhone,
--	'BRSAO'			AXLocationCode,
--	Status_Descricao_Ingles			JobStatus,
--		Null			JobClosedDateAX,
--	Null			JobClosedDateOps,
--	Hou.HAWB_Heo	HouseBOLNbr,
--	''				MasterBOLNbr,
--	'' ConsolNbr,
--	 Dimensao3 GlobalCustomerCode,
--	 cd_ax ClientCode,
--	 PP.Nome_Raz_Soc ConsigneeName,
--	 left(dbo.fBusca_TipoDocCliente('N',num_proc_leo,1),100) CustRef1,
--	 ORg.Cd_Pais CountryOfOrigin,
--	 Org.SCAC PortOfLoad,
--	 ETD_Leo EstSailDate,
--	 ATD_Leo ActSailDate,
--	 DST.Cd_Pais CountryOfDestination,
--	 DST.SCAC PortOfEntry,
--	 Null EstEntryDate,
--	 ATA_Leo ActEntryDate,
--	 Null DateOfDelivery,
--	 DST.SCAC  PortOfDischarge,
--	 Null PlaceOfDelivery,
--	 ''  CarrierCode,
--	 cia.Nome_Raz_Soc CarrierName,
--	 cast(Isnull(Peso_Bruto_HEO,0) as decimal(18,2)) GrossWeight,
--	 Cast(Isnull(Peso_Cubado_LEO,0) as decimal(18,2)) GrossWeightChargeable,
--	 'No' Hazardous,
--	 Cd_Tp_Oper  INCOTerms,
--	 Null MasterBookingNbr,
--	 'Truck' ModeOfTransport,
--	 0 NumOfContainers,
--	 Null NVOCCCode,
--	 'No' OpClose,
--	 Cd_Vendedor SalesPersonCode,
--	 null SalespersonCodeEXT,
--	 VD.Nome_Usuario SalesPersonName,
--	 SH.Nome_Raz_Soc  ShipperName,
--	0.00 TEU,
--	 null VesselName,
--	 Cast(Isnull(Vol_Tot_Heo,0) as decimal(18,2))Volume,
--	 '' VoyageId,
--	 @JobFirstFinTransDate JobFirstFinTransDate,
--	 CD_AX CustAccount,
--	 SH.Nome_Raz_Soc CustName,
--	 	 	 Null AXAgentVendAccount,
--	Case
--		When tp_frete_heo='P' Then 'Prepaid'
--		else 'Collect'
	
--	End
--		PrepaidOrCollect
--from 
--	House_exp_out Hou
--	Join LLP_exp_out LLP with(nolock) on Num_Proc_Leo=hou.num_proc_heo
--	Join Usuario US with(nolock) on US.Cd_Usuario = llp.cd_usuario
--	Join Pessoa PP with(nolock) on PP.Cd_Pes=Cd_Consig_heo
--	Join Localidade ORg on Org.Cd_Local = Cd_Org_Heo
--	Join Localidade DST on DST.Cd_Local = Cd_Dst_Heo 
--	Left Join Pessoa CIA on cia.cd_pes=cd_carrier
--	Left Join Usuario VD with(nolock) on VD.Cd_Usuario = Cd_Vendedor 
--	Join Pessoa SH with(nolock) on SH.Cd_Pes=Cd_Export_Heo 
--	Join Pessoa_ATL_AX AX with(nolock) on AX.Cd_Pes = SH.Cd_Pes and Tipo='C'
--	LEft Join Tipo_Status_Processo TSP with(nolock) on LLP.id_Status = TSP.id_status
--	Join AX_XML_Customer_Recebido AXCR with(nolock) on AXCR.AccountNum=cd_ax
	
--Where
--	Num_Proc_Leo= @Num_Proc 
	
--Union all

----BDP Others
--select top 1
--	0.00								InsuredAmountUSD,
--	'LCL'								ShipmentType,
--	'No'								FNClose,
--	Null								CustRef2,
--	Null								CustRef3,
--	Null								CustRef4,
--	Null								CitCustomerPO,
--	'Yes'								BDP_JobControlled,
--	Num_Proc_LBO						JobNbr,
--	800									AXProductCode,
--	CONVERT(Datetime,Dt_Emis_HBO,105)	JobCreationDate	,
--	US.Nome_Usuario						UserName,
--	US.email							UserEmail,
--	US.Fone								UserPhone,
--	'BRSAO'								AXLocationCode,
--	Status_Descricao_Ingles				JobStatus,
--	Null								JobClosedDateAX,
--	Null								JobClosedDateOps,
--	''									HouseBOLNbr,
--	''									MasterBOLNbr,
--	''									ConsolNbr,
--	Dimensao3							GlobalCustomerCode,
--	cd_ax								ClientCode,
--	PP.Nome_Raz_Soc						ConsigneeName,	
--	Null								CustRef1,				
--	Null								CountryOfOrigin,			
--	Null								PortOfLoad,				
--	Null								EstSailDate,				
--	Null								ActSailDate,				
--	Null								CountryOfDestination,	
--	Null								PortOfEntry,				
--	Null								EstEntryDate,
--	Null								ActEntryDate,			
--	Null								DateOfDelivery,
--	Null								PortOfDischarge,			
--	Null								PlaceOfDelivery,
--	''									CarrierCode,
--	''									CarrierName,				
--	0.00								GrossWeight,				
--	0.00 								GrossWeightChargeable,	
--	'No' 								Hazardous,
--	'' 									INCOTerms,				
--	Null 								MasterBookingNbr,
--	'Others' 							ModeOfTransport, 
--	0 									NumOfContainers,
--	Null 								NVOCCCode,
--	'No' 								OpClose,
--	'' 									SalesPersonCode,			
--	null 								SalespersonCodeEXT,
--	Null								SalesPersonName,
--	'' 									ShipperName,				
--	0.00 								TEU,
--	null 								VesselName,
--	0.00 								Volume,					
--	'' 									VoyageId,
--	@JobFirstFinTransDate 				JobFirstFinTransDate,
--	CD_AX 								CustAccount,
--	'' 									CustName,			
--	Null 								AXAgentVendAccount,
--	'Prepaid' 									PrepaidOrCollect			
--from 
--	House_BDP_OUT Hou
--	Join LLP_BDP_OUT LLP with(nolock) on Num_Proc_LBO=hou.Num_Proc_HBO
--	Join Usuario US with(nolock) on US.Cd_Usuario = llp.cd_usuario
--	Join Pessoa PP with(nolock) on PP.Cd_Pes=HOU.cd_cliente_hbo
--	Join Pessoa_ATL_AX AX with(nolock) on AX.Cd_Pes = PP.Cd_Pes and Tipo='C'	
--	Left Join Usuario VD with(nolock) on VD.Cd_Usuario = llp.cd_usuario 	
--	LEft Join Tipo_Status_Processo TSP with(nolock) on LLP.id_Status = TSP.id_status
--	Join AX_XML_Customer_Recebido AXCR with(nolock) on AXCR.AccountNum=cd_ax	
--Where
--	Num_Proc_LBO= @Num_Proc and LLP.Id_TP_Servico > 1
	
	
--UNION ALL
----BDP Outros com JOB Amarrado

--	select top 1
--	0.00								InsuredAmountUSD,
--	(
--		Case LEFT(JBO.Num_Proc,2) 
--			when 'IM' then 
--				(Case 
--					when TC.Nome_Tp_Carga = 'Cabotagem' then 'FCL'
--					else TC.Nome_Tp_Carga
--				End)
--			when 'IA' then 'LCL' 
--			when 'EA' then 'LCL'
--			when 'EM' then
--				(Case 
--					when TC.Nome_Tp_Carga = 'Cabotagem' then 'FCL'
--					else TC.Nome_Tp_Carga
--				End)
--			when 'EO' then 'LCL'
--			when 'IO' then 'LCL'
--		End
--	)									ShipmentType,
--	'No'								FNClose,
--	Null								CustRef2,
--	Null								CustRef3,
--	Null								CustRef4,
--	Null								CitCustomerPO,
--	'Yes'								BDP_JobControlled,
--	Num_Proc_LBO						JobNbr,
	
--	(Case LEFT(JBO.Num_Proc,2) 
--		when 'IM' then
--			(Case V.Master
--				When 'JOB' then '850'
--				else 221
--			End)				
--		when 'IA' then 
--			(Case V.Master
--				When 'JOB' then '850'
--				else 122 
--			End)
--		when 'EA' then 
--			(Case V.Master
--				When 'JOB' then '850'
--				else 112 
--			End)
--		when 'EM' then 
--			(Case V.Master
--				When 'JOB' then '850'
--				else 216
--			End)
--		when 'EO' then 850
--		when 'IO' then 850		
--	End)								AXProductCode,
	
--	CONVERT(Datetime,Dt_Emis_HBO,105)	JobCreationDate	,
--	US.Nome_Usuario						UserName,
--	US.email							UserEmail,
--	US.Fone								UserPhone,
--	'BRSAO'								AXLocationCode,
--	Status_Descricao_Ingles				JobStatus,
--	Null								JobClosedDateAX,
--	Null								JobClosedDateOps,
--	V.HAWB								HouseBOLNbr,
--	V.MAWB								MasterBOLNbr,	
	
--	--(Case LEFT(JBO.Num_Proc,2) 
--	--	when 'IM' then
--	--		(Case V.Master
--	--			When 'JOB' then ''
--	--			else V.Master
--	--		End)				
--	--	when 'IA' then 
--	--		(Case V.Master
--	--			When 'JOB' then ''
--	--			else V.Master 
--	--		End)
--	--	when 'EA' then 
--	--		(Case V.Master
--	--			When 'JOB' then ''
--	--			else V.Master
--	--		End)
--	--	when 'EM' then 
--	--		(Case V.Master
--	--			When 'JOB' then ''
--	--			else V.Master
--	--		End)
--	--	when 'EO' then ''
--	--	when 'IO' then ''		
--	--End)
--	JBO.Num_Proc						ConsolNbr,
--	Dimensao3							GlobalCustomerCode,
--	AX.cd_ax							ClientCode,
--	PP.Nome_Raz_Soc						ConsigneeName,
--	left(dbo.fBusca_TipoDocCliente('N',JBO.Num_Proc,1),100) CustRef1,	
--	ORg.Cd_Pais							CountryOfOrigin,
--	Org.SCAC							PortOfLoad,
--	V.ETD								EstSailDate,
--	V.ATD								ActSailDate,
--	DST.Cd_Pais							CountryOfDestination,
--	DST.SCAC							PortOfEntry,	
--	Null								EstEntryDate,
--	V.ATA								ActEntryDate,
--	Null								DateOfDelivery,
--	DST.SCAC							PortOfDischarge,
--	Null								PlaceOfDelivery,
	
--	(Case LEFT(JBO.Num_Proc,2) 
--		when 'IM' then
--			Armador.SCAC			
--		when 'IA' then 
--			Cia_Aerea.SCAC
--		when 'EA' then 
--			Cia_Aerea.SCAC
--		when 'EM' then 
--			Armador.SCAC
--		when 'EO' then ''
--		when 'IO' then ''		
--	End)								CarrierCode,
--	(Case LEFT(JBO.Num_Proc,2) 
--		when 'IM' then
--			Armador.Nome_Armador			
--		when 'IA' then 
--			Cia_Aerea.Nome_Cia_Aer
--		when 'EA' then 
--			Cia_Aerea.Nome_Cia_Aer
--		when 'EM' then 
--			Armador.Nome_Armador
--		when 'EO' then 
--			Carrier.Nome_Raz_Soc
--		when 'IO' then 
--			Carrier.Nome_Raz_Soc		
--	End)								CarrierName,
	
--	cast(Isnull(V.Peso_Bruto,0) as decimal(18,2)) GrossWeight,
	
--	(Case LEFT(JBO.Num_Proc,2) 
--		when 'IM' then
--			cast(Isnull(V.Peso_Bruto,0) as decimal(18,2))			
--		when 'IA' then 
--			Cast(Isnull(V.Peso_cubado,0) as decimal(18,2))
--		when 'EA' then 
--			Cast(Isnull(V.Peso_cubado,0) as decimal(18,2))
--		when 'EM' then 
--			cast(Isnull(V.Peso_Bruto,0) as decimal(18,2))
--		when 'EO' then 
--			Cast(Isnull(V.Peso_cubado,0) as decimal(18,2))
--		when 'IO' then 
--			Cast(Isnull(V.Peso_cubado,0) as decimal(18,2))		
--	End)								 GrossWeightChargeable,
		
--	'No' 								Hazardous,
--	Hou.Cd_tp_oper						Incoterms,				
--	Null 								MasterBookingNbr,
--	(Case LEFT(JBO.Num_Proc,2) 
--		when 'IM' then
--			'Ocean'			
--		when 'IA' then 
--			'Air'
--		when 'EA' then 
--			'Air'
--		when 'EM' then 
--			'Ocean'
--		when 'EO' then 
--			'Truck'
--		when 'IO' then 
--			'Truck'		
--	End) 								ModeOfTransport, 
--	0 									NumOfContainers,
--	Null 								NVOCCCode,
--	'No' 								OpClose,
--	V.cd_vendedor						SalesPersonCode,			
--	null 								SalespersonCodeEXT,
--	VD.Nome_Usuario						SalesPersonName,
--	SH.Nome_Raz_Soc						ShipperName,				
--	0.00 								TEU,
--	V.Navio								VesselName,
--	Cast(Isnull(V.Vol_Tot,0) as decimal(18,2))Volume,				
--	V.Viagem 							VoyageId,
--	@JobFirstFinTransDate 				JobFirstFinTransDate,
--	AX.CD_AX 							CustAccount,
--	(Case LEFT(JBO.Num_Proc,2) 
--		when 'IM' then
--			PP.Nome_Raz_Soc		
--		when 'IA' then 
--			PP.Nome_Raz_Soc	
--		when 'EA' then 
--			SH.Nome_Raz_Soc
--		when 'EM' then 
--			SH.Nome_Raz_Soc
--		when 'EO' then 
--			SH.Nome_Raz_Soc
--		when 'IO' then 
--			PP.Nome_Raz_Soc		
--	End)								CustName,			
	
--	AXA.cd_ax AXAgentVendAccount,
--	V.Tipo_Frete					PrepaidOrCollect
--from 
--	House_BDP_OUT		Hou
--	Join LLP_BDP_OUT	LLP		with(nolock) on Num_Proc_LBO=hou.Num_Proc_HBO
--	Join Usuario		US		with(nolock) on US.Cd_Usuario = llp.cd_usuario
--	Join Pessoa			PP		with(nolock) on PP.Cd_Pes=HOU.cd_cliente_hbo
--	Join Pessoa_ATL_AX	AX		with(nolock) on AX.Cd_Pes = PP.Cd_Pes and Tipo='C'
	
--	join JOB_HBO		JBO		with(nolock) on JBO.Num_Proc_HBO = Hou.num_proc_hbo	
--	--join vwAX_Interface V		with(nolock) on V.Num_Proc = JBO.Num_Proc	
	
--	join vwAX_Interface_HBO V		with(nolock) on V.Num_Proc = JBO.Num_Proc
--	left Join Tipo_Carga		TC		with(nolock) on TC.cd_tp_carga= V.cd_tp_Carga	
--	Join Localidade		ORg		with(nolock) on Org.Cd_Local = V.Cd_Org
--	Join Localidade		DST		with(nolock) on DST.Cd_Local = v.Cd_Dst 
	
--	left Join Cia_Aerea Cia_Aerea	with(nolock)on Cia_Aerea.Cd_Cia_Aer = V.cd_armador 
--	left Join Armador	Armador		with(nolock) on Armador.cd_armador = V.cd_armador
--	Left Join Pessoa	Carrier		with(nolock) on Carrier.cd_pes=V.cd_armador
--	Left Join Usuario	VD			with(nolock) on VD.Cd_Usuario = V.cd_vendedor 
--	Join Pessoa			SH			with(nolock) on SH.Cd_Pes=V.cd_export	
		
--	LEft Join Tipo_Status_Processo TSP with(nolock) on LLP.id_Status = TSP.id_status
	
--	Join AX_XML_Customer_Recebido AXCR with(nolock) on AXCR.AccountNum=AX.cd_ax	
--	LEft Join Pessoa_ATL_AX AXA with(nolock) on AXA.Cd_Pes = V.cd_cliente_master and AXA.Tipo='F'
--Where
--	Num_Proc_LBO= @Num_Proc and LLP.Id_TP_Servico = 1
*/
GO
