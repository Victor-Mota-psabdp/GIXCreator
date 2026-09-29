SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from ATL_INT.dbo.Tipo_House_Temp
--sp_help Tipo_House_Temp
CREATE VIEW [dbo].[vwTipo_House_Temp_Sel]
AS
select 
	Id_TP_House_Temp [ID Type Aut. Def],
	HAWB,
	MAWB,
	Intl_Reference,
	Num_Proc,
	Cd_Export		[Shipper],
	Cd_Consig		[Consignee],
	Cd_Import		[Notify],
	Cd_planta		[Plant],
	Cd_Org			[Origin],
	Cd_Dst			[Discharge],
	Cd_DstFinal		[Final Destination],
	Cd_Armador		[Carrier],
	Navio			[Vessel],
	Viagem			[Voyage],
	ETA,
	ETD,
	ATA,
	ATD,
	Cd_Tp_Carga		[Cargo Type],
	Qtd_Tot_Vol		[Qty],
	Vol_Tot			[Volume],
	Peso_Liquido	[Net Weight],
	Peso_Bruto		[Gross Weight],
	Tp_Frete		[Terms of Sale Code],
	Cd_Tp_Moeda		[Amount Currency],
	Vlr_Frete_Efet	[Amount Value],
	Original_ETA	[Original ETA],
	Obs,Modal		[Modal],
	LEGTYPE,
	Peso_Cubado		[Charg. Weight],
	Vlr_Frete		[Other Amount Value],
	criaJOB			[Create JOB],
	Ativo			[Enabled]
from 
	ATL_INT.dbo.Tipo_House_Temp TT with(nolock)		











GO
