SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help spATL_Altera_BL_Sel
/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O ///  Busca pelo Nome - Ativos
Z ///  Verifica Nome X Codigo
*/

Create procedure [dbo].[spATL_Altera_BL_Sel]
(
    @num_proc   varchar(20),
	@Tipo    	CHAR(1) 
)
as

Begin
             select 
							num_proc,
							cmbShipper,
							txtShipper,
							cmbConsignee,
							txtConsignee,
							cmbNotify,
							txtNotify,
							cmbOrigin,
							cmbLoading,
							cmbDelivery,
							cmbFinalDestination,
							cmbCarrier,
							cmbVoyage,
							txtVessel,
							ab.cd_usuario [User Code],
							u.Nome_Usuario [User Name],
							status,
							dt_ins,
							cmbCiaAerea,
							txtVoo,
							txtVoyage,
							cmbVessel,
							cmbIssuing,
							txtIssuing,
							txtCarriage,
							txtCustoms,
							txtAmount,
							txtSignatureShipper,
							txtSignatureCarrier,
							txtShipperPostcodeCode,
							txtShipperStreetName,
							txtShipperCityName,
							txtShipperCountryID,
							txtShipperCountryName,
							txtShipperPersonName,
							txtShipperDepartmentName,
							txtShipperDirectTelephoneCommunication,
							txtShipperFaxCommunication,
							txtShipperURIEmailCommunication,
							txtConsigneePostcodeCode,
							txtConsigneeStreetName,
							txtConsigneeCityName,
							txtConsigneeCountryID,
							txtConsigneeCountryName,
							txtConsigneePersonName,
							txtConsigneeDepartmentName,
							txtConsigneeDirectTelephoneCommunication,
							txtConsigneeFaxCommunication,
							txtConsigneeURIEmailCommunication,
							txtNotifyPostcodeCode,
							txtNotifyStreetName,
							txtNotifyCityName,
							txtNotifyCountryID,
							txtNotifyCountryName,
							txtNotifyPersonName,
							txtNotifyDepartmentName,
							txtNotifyDirectTelephoneCommunication,
							txtNotifyFaxCommunication,
							txtNotifyURIEmailCommunication,
							txtIssuingPostcodeCode,
							txtIssuingStreetName,
							txtIssuingCityName,
							txtIssuingCountryID,
							txtIssuingCountryName,
							txtIssuingPersonName,
							txtIssuingDepartmentName,
							txtIssuingDirectTelephoneCommunication,
							txtIssuingFaxCommunication,
							txtIssuingURIEmailCommunication
from 
	Altera_BL  ab With(nolock)
	left join  usuario u With(nolock) on ab.cd_usuario = u.cd_usuario
	Where num_proc  = @num_proc
End


GO
