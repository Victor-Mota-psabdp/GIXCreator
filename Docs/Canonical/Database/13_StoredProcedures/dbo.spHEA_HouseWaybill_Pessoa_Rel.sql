SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spHEA_HouseWaybill_Pessoa_Rel]--'10017'
		@cd_pes 	VarChar(25)
		
AS

select 		
	left([dbo].[FRemoveCaracteresEspeciais_EFreight]([dbo].[FRemoveAcentuacao](Sh.Nome_raz_soc)),20)	[Name],
	replace(ENDS.CEP COLLATE Latin1_General_BIN, char(32),'') [PostcodeCode],	
	left([dbo].[FRemoveCaracteresEspeciais_EFreight]((ENDS.Rua + ' ' + ends.numero)) ,35)[StreetName],
	left([dbo].[FRemoveAcentuacao](ENDS.Cidade),17)					[CityName],	
	--City name exceeds 17 character limit.
	ENDS.CD_pais											[CountryID],
	UPPER(ENDS.Pais)										[CountryName],
	
	COMS.contato											[PersonName],
	COMS.Depto_Ctt											[DepartmentName],
	[dbo].[FRemoveCaracteresEspeciais_EFreight]([dbo].[FRemoveAcentuacao](COMS.cd_int + COMS.cd_area_fone + COMS.prefixo + COMS.num_fone)) [DirectTelephoneCommunication],	
	COMFS.cd_int + COMFS.cd_area_fone + COMFS.prefixo + COMFS.num_fone [FaxCommunication],
	COMS.Compl_Fone											[URIEmailCommunication],
	COMFH.cd_int + COMFH.cd_area_fone + COMFH.prefixo + COMFH.num_fone [DirectTelephoneCommunicationHBL],
	ENDS.UF CountrySubDivisionID
		
from Pessoa Sh with(nolock)
	Left Join Endereco ENDS with(nolock) on SH.cd_pes=ENDS.cd_pes and ENDS.cd_tp_end = 'COM'
	left join comunicacao COMS with(nolock) on SH.cd_pes = COMS.cd_pes AND COMS.cd_tp_com = 'TC1'
	left join comunicacao COMFS with(nolock) on SH.cd_pes = COMFS.cd_pes AND COMFS.cd_tp_com = 'FC1'
	left join comunicacao COMFH with(nolock) on SH.cd_pes = COMFH.cd_pes AND COMFH.cd_tp_com = 'HBL'

Where
	Sh.cd_pes=@cd_pes


GO
