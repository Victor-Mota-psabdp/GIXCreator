SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--SELECT * from [dbo].[[DW_TRANS_PRTY]]

CREATE VIEW [dbo].[DW_TRANS_PRTY]
AS


-- Modal Imp Mar

-- Consignee
SELECT
HEM.Num_Proc_HIM 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIM	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,G.Smart_IMP	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Contato	[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIM		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Mar HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIM = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HIM = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HIM = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HIM = C.Cd_Pes AND CD_TP_COM='IA1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HIM = PS.Num_Proc
left join Pessoa_LLP  PL with(nolock) on P.Cd_Pes = PL.Cd_Pes
Left Join Grupo G with(nolock) on PL.Cd_Pes_Grupo = G.Cd_Pes_Grupo


where 

--hem.Num_Proc_HIM = 'IMSWB202408019BR'

convert(datetime,HEM.Dt_Emis_HIM,105) > getdate() -31

Union All

--DeliverTo

SELECT
HEM.Num_Proc_HIM 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIM	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,G.Smart_IMP	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,null		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIM		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Mar HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIM = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HIM = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HIM = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HIM = C.Cd_Pes AND CD_TP_COM='IA1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HIM = PS.Num_Proc
left join Pessoa_LLP  PL with(nolock) on P.Cd_Pes = PL.Cd_Pes
Left Join Grupo G with(nolock) on PL.Cd_Pes_Grupo = G.Cd_Pes_Grupo 


where 

--hem.Num_Proc_HIM = 'IMSWB202408019BR'

convert(datetime,HEM.Dt_Emis_HIM,105) > getdate() -31


Union All

-- Shipper
SELECT
HEM.Num_Proc_HIM 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIM	[AUD_LD_DT]
,'01BDPBRSAO'			[BDP_SS_ID]
,E.Cidade				[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais				[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,P.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Compl_Fone		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIM 		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Mar HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIM = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Export_HIM = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Export_HIM = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Export_HIM = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HIM = PS.Num_Proc


where 

--hem.Num_Proc_HIM = 'IMSWB202408019BR'

convert(datetime,HEM.Dt_Emis_HIM,105) > getdate() -31

Union All

--ShipFrom
SELECT
HEM.Num_Proc_HIM 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIM	[AUD_LD_DT]
,'01BDPBRSAO'			[BDP_SS_ID]
,E.Cidade				[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais				[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,P.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)	[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Compl_Fone		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIM 		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Mar HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIM = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Export_HIM = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Export_HIM = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Export_HIM = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HIM = PS.Num_Proc


where 

--hem.Num_Proc_HIM = 'IMSWB202408019BR'

convert(datetime,HEM.Dt_Emis_HIM,105) > getdate() -31

Union All

--ShipTo
SELECT
HEM.Num_Proc_HIM 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIM	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,P.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Contato		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIM		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Mar HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIM = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HIM = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HIM = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HIM = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HIM = PS.Num_Proc


where 

--hem.Num_Proc_HIM = 'IMSWB202408019BR'

convert(datetime,HEM.Dt_Emis_HIM,105) > getdate() -31

Union All

--SoldTo
SELECT
HEM.Num_Proc_HIM 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIM	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,P.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Contato		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIM		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Mar HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIM = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HIM = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HIM = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HIM = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HIM = PS.Num_Proc


where 

--hem.Num_Proc_HIM = 'IMSWB202408019BR'

convert(datetime,HEM.Dt_Emis_HIM,105) > getdate() -31

Union ALL

-- Notify
SELECT
HEM.Num_Proc_HIM 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIM	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,P.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)	[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,null		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIM		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Mar HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIM = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HIM = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HIM = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HIM = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HIM = PS.Num_Proc



where 

--hem.Num_Proc_HIM = 'IMSWB202408019BR'

convert(datetime,HEM.Dt_Emis_HIM,105) > getdate() -31

Union ALL

-- Partner
SELECT
HEM.Num_Proc_HIM 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIM	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,p.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)	[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,[dbo].[FRemoveAcentuacao](US.Nome_Usuario)		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,null		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIM		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Mar HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIM = LC.Cd_Local
Left Join Pessoa P with(nolock) on  P.Cd_Pes = '10017'
Left join Endereco E with(nolock) on p.cd_pes = E.Cd_Pes
Left join Comunicacao C with(nolock) on p.Cd_Pes = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HIM = PS.Num_Proc
left join po_him PO with(nolock) on hem.Num_Proc_HIM = po.Num_Proc_HIM and po.ID_PO_HIM = 1
left Join Usuario US with(nolock) on PO.cd_usuario = US.cd_usuario

where 

--hem.Num_Proc_HIM = 'IMSWB202408019BR'

convert(datetime,HEM.Dt_Emis_HIM,105) > getdate() -31

Union All

--Plant
SELECT
HEM.Num_Proc_HIM 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIM	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,PL.Cd_Planta [PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,NULL		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIM		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Mar HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIM = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HIM = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HIM = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HIM = C.Cd_Pes AND CD_TP_COM='TC1'
left join pedido_ship PS with(nolock) on hem.Num_Proc_HIM = PS.Num_Proc
Join Pedido PD with(nolock) on PS.cd_pedido=PD.cd_pedido
left join Pessoa_LLP  PL with(nolock) on PL.Cd_Pes = PD.Cd_Buyer




where 

--hem.Num_Proc_HIM = 'IMSWB202408019BR'

convert(datetime,HEM.Dt_Emis_HIM,105) > getdate() -31

Union All

--BDPRepresentative

SELECT
HEM.Num_Proc_HIM 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIM	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,p.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,[dbo].[FRemoveAcentuacao](US.Nome_Usuario)		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,null		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIM		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Mar HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIM = LC.Cd_Local
Left Join Pessoa P with(nolock) on  P.Cd_Pes = '10017'
Left join Endereco E with(nolock) on p.cd_pes = E.Cd_Pes
Left join Comunicacao C with(nolock) on p.Cd_Pes = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HIM = PS.Num_Proc
left join po_him PO with(nolock) on hem.Num_Proc_HIM = po.Num_Proc_HIM and po.ID_PO_HIM = 1
left Join Usuario US with(nolock) on PO.cd_usuario = US.cd_usuario

where 

--hem.Num_Proc_HIM = 'IMSWB202408019BR'

convert(datetime,HEM.Dt_Emis_HIM,105) > getdate() -31

Union ALL

--Buyer
SELECT
HEM.Num_Proc_HIM 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIM	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,G.Smart_IMP	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,null		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIM		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Mar HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIM = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HIM = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HIM = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HIM = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HIM = PS.Num_Proc
left join Pessoa_LLP  PL with(nolock) on P.Cd_Pes = PL.Cd_Pes
Left Join Grupo G with(nolock) on PL.Cd_Pes_Grupo = G.Cd_Pes_Grupo

where 

--hem.Num_Proc_HIM = 'IMSWB202408019BR'

convert(datetime,HEM.Dt_Emis_HIM,105) > getdate() -31

Union ALL

--Importer
SELECT
HEM.Num_Proc_HIM 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIM	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,G.Smart_IMP	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,null		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIM		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Mar HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIM = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HIM = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HIM = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HIM = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HIM = PS.Num_Proc
left join Pessoa_LLP  PL with(nolock) on P.Cd_Pes = PL.Cd_Pes
Left Join Grupo G with(nolock) on PL.Cd_Pes_Grupo = G.Cd_Pes_Grupo

where 

--hem.Num_Proc_HIM = 'IMSWB202408019BR'

convert(datetime,HEM.Dt_Emis_HIM,105) > getdate() -31

Union All

--Seller
SELECT
HEM.Num_Proc_HIM 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIM	[AUD_LD_DT]
,'01BDPBRSAO'			[BDP_SS_ID]
,E.Cidade				[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais				[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,P.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Compl_Fone		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIM 		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Mar HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIM = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Export_HIM = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Export_HIM = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Export_HIM = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HIM = PS.Num_Proc


where 

--hem.Num_Proc_HIM = 'IMSWB202408019BR'

convert(datetime,HEM.Dt_Emis_HIM,105) > getdate() -31

Union All

--Supplier
SELECT
HEM.Num_Proc_HIM 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIM	[AUD_LD_DT]
,'01BDPBRSAO'			[BDP_SS_ID]
,E.Cidade				[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais				[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,P.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Compl_Fone		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIM 		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Mar HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIM = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Export_HIM = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Export_HIM = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Export_HIM = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HIM = PS.Num_Proc


where 

--hem.Num_Proc_HIM = 'IMSWB202408019BR'

convert(datetime,HEM.Dt_Emis_HIM,105) > getdate() -31




Union All -- Modal Exp Mar


-- Consignee
SELECT
HEM.Num_Proc_HEM 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEM	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,isnull(G.Smart_EXP, P.Cd_Pes)	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Contato	[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEM		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_Mar HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEM = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HEM = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HEM = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HEM = C.Cd_Pes AND CD_TP_COM='IA1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEM = PS.Num_Proc
left join Pessoa_LLP  PL with(nolock) on P.Cd_Pes = PL.Cd_Pes
Left Join Grupo G with(nolock) on PL.Cd_Pes_Grupo = G.Cd_Pes_Grupo


where 

--hem.Num_Proc_HEM = 'EMATL202408002BR'

convert(datetime,HEM.Dt_Emis_HEM,105) > getdate() -31

Union All

--DeliverTo

SELECT
HEM.Num_Proc_HEM 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEM	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,isnull(G.Smart_EXP,P.cd_pes)	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,null		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEM		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_Mar HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEM = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HEM = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HEM = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HEM = C.Cd_Pes AND CD_TP_COM='IA1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEM = PS.Num_Proc
left join Pessoa_LLP  PL with(nolock) on P.Cd_Pes = PL.Cd_Pes
Left Join Grupo G with(nolock) on PL.Cd_Pes_Grupo = G.Cd_Pes_Grupo 


where 

--hem.Num_Proc_HEM = 'EMATL202408002BR'

convert(datetime,HEM.Dt_Emis_HEM,105) > getdate() -31


Union All

-- Shipper
SELECT
HEM.Num_Proc_HEM 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEM	[AUD_LD_DT]
,'01BDPBRSAO'			[BDP_SS_ID]
,E.Cidade				[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais				[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,isnull(g.Smart_EXP, P.Cd_Pes)	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Compl_Fone		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEM 		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_Mar HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEM = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Export_HEM = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Export_HEM = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Export_HEM = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEM = PS.Num_Proc
left join Pessoa_LLP  PL with(nolock) on P.Cd_Pes = PL.Cd_Pes
Left Join Grupo G with(nolock) on PL.Cd_Pes_Grupo = G.Cd_Pes_Grupo 


where 

--hem.Num_Proc_HEM = 'EMATL202408002BR'

convert(datetime,HEM.Dt_Emis_HEM,105) > getdate() -31

Union All

--ShipFrom
SELECT
HEM.Num_Proc_HEM 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEM	[AUD_LD_DT]
,'01BDPBRSAO'			[BDP_SS_ID]
,E.Cidade				[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais				[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,P.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)	[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Compl_Fone		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEM 		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_Mar HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEM = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Export_HEM = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Export_HEM = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Export_HEM = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEM = PS.Num_Proc


where 

--hem.Num_Proc_HEM = 'EMATL202408002BR'

convert(datetime,HEM.Dt_Emis_HEM,105) > getdate() -31

Union All

--ShipTo
SELECT
HEM.Num_Proc_HEM 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEM	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,P.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Contato		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEM		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_Mar HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEM = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HEM = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HEM = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HEM = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEM = PS.Num_Proc


where 

--hem.Num_Proc_HEM = 'EMATL202408002BR'

convert(datetime,HEM.Dt_Emis_HEM,105) > getdate() -31

Union All

--SoldTo
SELECT
HEM.Num_Proc_HEM 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEM	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,P.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Contato		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEM		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_EXP_Mar HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEM = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HEM = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HEM = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HEM = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEM = PS.Num_Proc


where 

--hem.Num_Proc_HEM = 'EMATL202408002BR'

convert(datetime,HEM.Dt_Emis_HEM,105) > getdate() -31

Union ALL

-- Notify
SELECT
HEM.Num_Proc_HEM 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEM	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,P.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)	[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,null		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEM		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_Mar HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEM = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HEM = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HEM = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HEM = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEM = PS.Num_Proc



where 

--hem.Num_Proc_HEM = 'EMATL202408002BR'

convert(datetime,HEM.Dt_Emis_HEM,105) > getdate() -31

Union ALL

-- Partner
SELECT
HEM.Num_Proc_HEM 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEM	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,p.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)	[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,[dbo].[FRemoveAcentuacao](US.Nome_Usuario)		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,null		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEM		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_Mar HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEM = LC.Cd_Local
Left Join Pessoa P with(nolock) on  P.Cd_Pes = '10017'
Left join Endereco E with(nolock) on p.cd_pes = E.Cd_Pes
Left join Comunicacao C with(nolock) on p.Cd_Pes = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEM = PS.Num_Proc
left join po_hem PO with(nolock) on hem.Num_Proc_HEM = po.Num_Proc_HEM and po.ID_PO_HEM = 1
left Join Usuario US with(nolock) on PO.cd_usuario = US.cd_usuario

where 

--hem.Num_Proc_HEM = 'EMATL202408002BR'

convert(datetime,HEM.Dt_Emis_HEM,105) > getdate() -31

Union All

--Plant
SELECT
HEM.Num_Proc_HEM 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEM	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,isnull(PL.Cd_Planta, '05031') [PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,NULL		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEM		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_Mar HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEM = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HEM = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HEM = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HEM = C.Cd_Pes AND CD_TP_COM='TC1'
left join pedido_ship PS with(nolock) on hem.Num_Proc_HEM = PS.Num_Proc
left Join Pedido PD with(nolock) on PS.cd_pedido=PD.cd_pedido
left join Pessoa_LLP  PL with(nolock) on PL.Cd_Pes = PD.Cd_Buyer




where 

--hem.Num_Proc_HEM = 'EMATL202408002BR'

convert(datetime,HEM.Dt_Emis_HEM,105) > getdate() -31

Union All

--BDPRepresentative

SELECT
HEM.Num_Proc_HEM 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEM	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,p.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,[dbo].[FRemoveAcentuacao](US.Nome_Usuario)		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,null		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEM		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_Mar HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEM = LC.Cd_Local
Left Join Pessoa P with(nolock) on  P.Cd_Pes = '10017'
Left join Endereco E with(nolock) on p.cd_pes = E.Cd_Pes
Left join Comunicacao C with(nolock) on p.Cd_Pes = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEM = PS.Num_Proc
left join po_hem PO with(nolock) on hem.Num_Proc_HEM = po.Num_Proc_HEM and po.ID_PO_HEM = 1
JOIN Job_Exp_Mar JOB	WITH (nolock)  ON job.Num_Proc_HEM=HEM.Num_Proc_HEM
left Join Usuario US with(nolock) on JOB.cd_usuario = US.cd_usuario



where 

--hem.Num_Proc_HEM = 'EMATL202408002BR'

convert(datetime,HEM.Dt_Emis_HEM,105) > getdate() -31

Union ALL

--Buyer
SELECT
HEM.Num_Proc_HEM 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEM	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,isnull(g.Smart_EXP, P.Cd_Pes)	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,null		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEM		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_Mar HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEM = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HEM = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HEM = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HEM = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEM = PS.Num_Proc
left join Pessoa_LLP  PL with(nolock) on P.Cd_Pes = PL.Cd_Pes
Left Join Grupo G with(nolock) on PL.Cd_Pes_Grupo = G.Cd_Pes_Grupo

where 

--hem.Num_Proc_HEM = 'EMATL202408002BR'

convert(datetime,HEM.Dt_Emis_HEM,105) > getdate() -31

Union ALL

--Importer
SELECT
HEM.Num_Proc_HEM 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEM	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,isnull(g.Smart_EXP, P.Cd_Pes)	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,null		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEM		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_Mar HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEM = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HEM = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HEM = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HEM = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEM = PS.Num_Proc
left join Pessoa_LLP  PL with(nolock) on P.Cd_Pes = PL.Cd_Pes
Left Join Grupo G with(nolock) on PL.Cd_Pes_Grupo = G.Cd_Pes_Grupo

where 

--hem.Num_Proc_HEM = 'EMATL202408002BR'

convert(datetime,HEM.Dt_Emis_HEM,105) > getdate() -31

Union All

--Seller
SELECT
HEM.Num_Proc_HEM 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEM	[AUD_LD_DT]
,'01BDPBRSAO'			[BDP_SS_ID]
,E.Cidade				[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais				[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,P.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Compl_Fone		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEM 		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_Mar HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEM = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Export_HEM = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Export_HEM = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Export_HEM = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEM = PS.Num_Proc


where 

--hem.Num_Proc_HEM = 'EMATL202408002BR'

convert(datetime,HEM.Dt_Emis_HEM,105) > getdate() -31

Union All

--Supplier
SELECT
HEM.Num_Proc_HEM 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEM	[AUD_LD_DT]
,'01BDPBRSAO'			[BDP_SS_ID]
,E.Cidade				[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais				[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,P.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Compl_Fone		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEM 		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_Mar HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEM = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Export_HEM = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Export_HEM = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Export_HEM = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEM = PS.Num_Proc


where 

--hem.Num_Proc_HEM = 'EMATL202408002BR'

convert(datetime,HEM.Dt_Emis_HEM,105) > getdate() -31


Union All 

--Modal Imp Aer

-- Consignee
SELECT
HEM.Num_Proc_HIA 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIA	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,isnull(G.Smart_EXP, P.Cd_Pes)	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Contato	[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIA		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_imp_aer HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIA = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HIA = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HIA = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HIA = C.Cd_Pes AND CD_TP_COM='IA1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HIA = PS.Num_Proc
left join Pessoa_LLP  PL with(nolock) on P.Cd_Pes = PL.Cd_Pes
Left Join Grupo G with(nolock) on PL.Cd_Pes_Grupo = G.Cd_Pes_Grupo


where 

--hem.Num_Proc_Hia = 'IASWB202407005BR'

convert(datetime,HEM.Dt_Emis_HIA,105) > getdate() -31

Union All

--DeliverTo

SELECT
HEM.Num_Proc_HIA 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIA	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,isnull(G.Smart_EXP,P.cd_pes)	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,null		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIA		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Aer HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIA = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HIA = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HIA = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HIA = C.Cd_Pes AND CD_TP_COM='IA1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HIA = PS.Num_Proc
left join Pessoa_LLP  PL with(nolock) on P.Cd_Pes = PL.Cd_Pes
Left Join Grupo G with(nolock) on PL.Cd_Pes_Grupo = G.Cd_Pes_Grupo 


where 

--hem.Num_Proc_HIA = 'IASWB202407005BR'

convert(datetime,HEM.Dt_Emis_HIA,105) > getdate() -31


Union All

-- Shipper
SELECT
HEM.Num_Proc_HIA 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIA	[AUD_LD_DT]
,'01BDPBRSAO'			[BDP_SS_ID]
,E.Cidade				[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais				[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,isnull(g.Smart_EXP, P.Cd_Pes)	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Compl_Fone		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIA 		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Aer HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIA = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Export_HIA = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Export_HIA = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Export_HIA = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HIA = PS.Num_Proc
left join Pessoa_LLP  PL with(nolock) on P.Cd_Pes = PL.Cd_Pes
Left Join Grupo G with(nolock) on PL.Cd_Pes_Grupo = G.Cd_Pes_Grupo 


where 

--hem.Num_Proc_HIA = 'IASWB202407005BR'

convert(datetime,HEM.Dt_Emis_HIA,105) > getdate() -31

Union All

--ShipFrom
SELECT
HEM.Num_Proc_HIA 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIA	[AUD_LD_DT]
,'01BDPBRSAO'			[BDP_SS_ID]
,E.Cidade				[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais				[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,P.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)	[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Compl_Fone		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIA 		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Aer HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIA = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Export_HIA = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Export_HIA = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Export_HIA = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HIA = PS.Num_Proc


where 

--hem.Num_Proc_HIA = 'IASWB202407005BR'

convert(datetime,HEM.Dt_Emis_HIA,105) > getdate() -31

Union All

--ShipTo
SELECT
HEM.Num_Proc_HIA 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIA	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,P.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Contato		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIA		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Aer HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIA = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HIA = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HIA = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HIA = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HIA = PS.Num_Proc


where 

--hem.Num_Proc_HIA = 'IASWB202407005BR'

convert(datetime,HEM.Dt_Emis_HIA,105) > getdate() -31

Union All

--SoldTo
SELECT
HEM.Num_Proc_HIA 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIA	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,P.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Contato		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIA		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Aer HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIA = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HIA = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HIA = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HIA = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HIA = PS.Num_Proc


where 

--hem.Num_Proc_Hia = 'IASWB202407005BR'

convert(datetime,HEM.Dt_Emis_HIA,105) > getdate() -31

Union ALL

-- Notify
SELECT
HEM.Num_Proc_HIA 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIA	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,P.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)	[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,null		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIA		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Aer HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIA = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HIA = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HIA = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HIA = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HIA = PS.Num_Proc



where 

--hem.Num_Proc_HIA = 'IASWB202407005BR'

convert(datetime,HEM.Dt_Emis_HIA,105) > getdate() -31

Union ALL

-- Partner
SELECT
HEM.Num_Proc_HIA 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIA	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,p.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)	[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,[dbo].[FRemoveAcentuacao](US.Nome_Usuario)		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,null		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIA		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Aer HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIA = LC.Cd_Local
Left Join Pessoa P with(nolock) on  P.Cd_Pes = '10017'
Left join Endereco E with(nolock) on p.cd_pes = E.Cd_Pes
Left join Comunicacao C with(nolock) on p.Cd_Pes = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HIA = PS.Num_Proc
left join po_hem PO with(nolock) on hem.Num_Proc_HIA = po.Num_Proc_HEM and po.ID_PO_HEM = 1
left Join Usuario US with(nolock) on PO.cd_usuario = US.cd_usuario

where 

--hem.Num_Proc_HIA = 'IASWB202407005BR'

convert(datetime,HEM.Dt_Emis_HIA,105) > getdate() -31

Union All

--Plant
SELECT
HEM.Num_Proc_HIA 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIA	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,isnull(PL.Cd_Planta, '05031') [PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,NULL		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIA		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Aer HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIA = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HIA = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HIA = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HIA = C.Cd_Pes AND CD_TP_COM='TC1'
left join pedido_ship PS with(nolock) on hem.Num_Proc_HIA = PS.Num_Proc
left Join Pedido PD with(nolock) on PS.cd_pedido=PD.cd_pedido
left join Pessoa_LLP  PL with(nolock) on PL.Cd_Pes = PD.Cd_Buyer




where 

--hem.Num_Proc_HIA = 'IASWB202407005BR'

convert(datetime,HEM.Dt_Emis_HIA,105) > getdate() -31

Union All

--BDPRepresentative

SELECT
HEM.Num_Proc_HIA 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIA	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,p.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,[dbo].[FRemoveAcentuacao](US.Nome_Usuario)		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,null		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIA		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Aer HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIA = LC.Cd_Local
Left Join Pessoa P with(nolock) on  P.Cd_Pes = '10017'
Left join Endereco E with(nolock) on p.cd_pes = E.Cd_Pes
Left join Comunicacao C with(nolock) on p.Cd_Pes = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HIA = PS.Num_Proc
left join po_hem PO with(nolock) on hem.Num_Proc_HIA = po.Num_Proc_HEM and po.ID_PO_HEM = 1
JOIN Job_Imp_Aer JOB	WITH (nolock)  ON job.Num_Proc_HIA=HEM.Num_Proc_HIA
left Join Usuario US with(nolock) on JOB.cd_usuario = US.cd_usuario



where 

--hem.Num_Proc_HIA = 'IASWB202407005BR'

convert(datetime,HEM.Dt_Emis_HIA,105) > getdate() -31

Union ALL

--Buyer
SELECT
HEM.Num_Proc_HIA 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDTIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIA	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,isnull(g.Smart_EXP, P.Cd_Pes)	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,null		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIA		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Aer HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIA = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HIA = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HIA = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HIA = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HIA = PS.Num_Proc
left join Pessoa_LLP  PL with(nolock) on P.Cd_Pes = PL.Cd_Pes
Left Join Grupo G with(nolock) on PL.Cd_Pes_Grupo = G.Cd_Pes_Grupo

where 

--hem.Num_Proc_HIA = 'IASWB202407005BR'

convert(datetime,HEM.Dt_Emis_HIA,105) > getdate() -31

Union ALL

--Importer
SELECT
HEM.Num_Proc_HIA 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIA	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,isnull(g.Smart_EXP, P.Cd_Pes)	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,null		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIA		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Aer HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIA = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HIA = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HIA = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HIA = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HIA = PS.Num_Proc
left join Pessoa_LLP  PL with(nolock) on P.Cd_Pes = PL.Cd_Pes
Left Join Grupo G with(nolock) on PL.Cd_Pes_Grupo = G.Cd_Pes_Grupo

where 

--hem.Num_Proc_HIA = 'IASWB202407005BR'

convert(datetime,HEM.Dt_Emis_HIA,105) > getdate() -31

Union All

--Seller
SELECT
HEM.Num_Proc_HIA 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIA	[AUD_LD_DT]
,'01BDPBRSAO'			[BDP_SS_ID]
,E.Cidade				[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais				[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,P.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Compl_Fone		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIA 		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Aer HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIA = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Export_HIA = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Export_HIA = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Export_HIA = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HIA = PS.Num_Proc


where 

--hem.Num_Proc_HIA = 'IASWB202407005BR'

convert(datetime,HEM.Dt_Emis_HIA,105) > getdate() -31

Union All

--Supplier
SELECT
HEM.Num_Proc_HIA 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIA	[AUD_LD_DT]
,'01BDPBRSAO'			[BDP_SS_ID]
,E.Cidade				[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais				[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,P.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Compl_Fone		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIA 		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Aer HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIA = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Export_HIA = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Export_HIA = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Export_HIA = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HIA = PS.Num_Proc


where 

--hem.Num_Proc_HIA = 'IASWB202407005BR'

convert(datetime,HEM.Dt_Emis_HIA,105) > getdate() -31


Union ALL

-- Exp Aer


-- Consignee
SELECT
HEM.Num_Proc_HEA 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEA	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,isnull(G.Smart_EXP, P.Cd_Pes)	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Contato	[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEA		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_Aer HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEA = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HEA = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HEA = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HEA = C.Cd_Pes AND CD_TP_COM='IA1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEA = PS.Num_Proc
left join Pessoa_LLP  PL with(nolock) on P.Cd_Pes = PL.Cd_Pes
Left Join Grupo G with(nolock) on PL.Cd_Pes_Grupo = G.Cd_Pes_Grupo


where 

--hem.Num_Proc_HEA = 'EAFIR202407007BR'

convert(datetime,HEM.Dt_Emis_HEA,105) > getdate() -31

Union All

--DeliverTo

SELECT
HEM.Num_Proc_HEA 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEA	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,isnull(G.Smart_EXP,P.cd_pes)	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,null		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEA		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_Aer HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEA = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HEA = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HEA = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HEA = C.Cd_Pes AND CD_TP_COM='IA1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEA = PS.Num_Proc
left join Pessoa_LLP  PL with(nolock) on P.Cd_Pes = PL.Cd_Pes
Left Join Grupo G with(nolock) on PL.Cd_Pes_Grupo = G.Cd_Pes_Grupo 


where 

--hem.Num_Proc_HEA = 'EAFIR202407007BR'

convert(datetime,HEM.Dt_Emis_HEA,105) > getdate() -31


Union All

-- Shipper
SELECT
HEM.Num_Proc_HEA 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEA	[AUD_LD_DT]
,'01BDPBRSAO'			[BDP_SS_ID]
,E.Cidade				[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais				[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,isnull(g.Smart_EXP, P.Cd_Pes)	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Compl_Fone		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEA 		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_Aer HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEA = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Export_HEA = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Export_HEA = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Export_HEA = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEA = PS.Num_Proc
left join Pessoa_LLP  PL with(nolock) on P.Cd_Pes = PL.Cd_Pes
Left Join Grupo G with(nolock) on PL.Cd_Pes_Grupo = G.Cd_Pes_Grupo 


where 

--hem.Num_Proc_HEA = 'EAFIR202407007BR'

convert(datetime,HEM.Dt_Emis_HEA,105) > getdate() -31

Union All

--ShipFrom
SELECT
HEM.Num_Proc_HEA 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEA	[AUD_LD_DT]
,'01BDPBRSAO'			[BDP_SS_ID]
,E.Cidade				[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais				[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,P.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)	[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Compl_Fone		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEA 		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_Aer HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEA = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Export_HEA = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Export_HEA = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Export_HEA = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEA = PS.Num_Proc


where 

--hem.Num_Proc_HEA = 'EAFIR202407007BR'

convert(datetime,HEM.Dt_Emis_HEA,105) > getdate() -31

Union All

--ShipTo
SELECT
HEM.Num_Proc_HEA 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEA	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,P.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Contato		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEA		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_Aer HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEA = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HEA = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HEA = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HEA = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEA = PS.Num_Proc


where 

--hem.Num_Proc_HEA = 'EAFIR202407007BR'

convert(datetime,HEM.Dt_Emis_HEA,105) > getdate() -31

Union All

--SoldTo
SELECT
HEM.Num_Proc_HEA 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEA	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,P.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Contato		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEA		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_exp_Aer HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEA = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HEA = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HEA = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HEA = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEA = PS.Num_Proc


where 

--hem.Num_Proc_HEA = 'EAFIR202407007BR'

convert(datetime,HEM.Dt_Emis_HEA,105) > getdate() -31

Union ALL

-- Notify
SELECT
HEM.Num_Proc_HEA 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEA	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,P.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)	[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,null		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEA		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_Aer HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEA = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HEA = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HEA = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HEA = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEA = PS.Num_Proc



where 

--hem.Num_Proc_HEA = 'EAFIR202407007BR'

convert(datetime,HEM.Dt_Emis_HEA,105) > getdate() -31

Union ALL

-- Partner
SELECT
HEM.Num_Proc_HEA 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEA	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,p.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)	[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,[dbo].[FRemoveAcentuacao](US.Nome_Usuario)		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,null		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEA		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_Aer HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEA = LC.Cd_Local
Left Join Pessoa P with(nolock) on  P.Cd_Pes = '10017'
Left join Endereco E with(nolock) on p.cd_pes = E.Cd_Pes
Left join Comunicacao C with(nolock) on p.Cd_Pes = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEA = PS.Num_Proc
left join po_hem PO with(nolock) on hem.Num_Proc_HEA = po.Num_Proc_HEM and po.ID_PO_HEM = 1
left Join Usuario US with(nolock) on PO.cd_usuario = US.cd_usuario

where 

--hem.Num_Proc_HEA = 'EAFIR202407007BR'

convert(datetime,HEM.Dt_Emis_HEA,105) > getdate() -31

Union All

--Plant
SELECT
HEM.Num_Proc_HEA 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEA	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,isnull(PL.Cd_Planta, '05031') [PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,NULL		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEA		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_Aer HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEA = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HEA = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HEA = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HEA = C.Cd_Pes AND CD_TP_COM='TC1'
left join pedido_ship PS with(nolock) on hem.Num_Proc_HEA = PS.Num_Proc
left Join Pedido PD with(nolock) on PS.cd_pedido=PD.cd_pedido
left join Pessoa_LLP  PL with(nolock) on PL.Cd_Pes = PD.Cd_Buyer




where 

--hem.Num_Proc_HEA = 'EAFIR202407007BR'

convert(datetime,HEM.Dt_Emis_HEA,105) > getdate() -31

Union All

--BDPRepresentative

SELECT
HEM.Num_Proc_HEA 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEA	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,p.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,[dbo].[FRemoveAcentuacao](US.Nome_Usuario)		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,null		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEA		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_Aer HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEA = LC.Cd_Local
Left Join Pessoa P with(nolock) on  P.Cd_Pes = '10017'
Left join Endereco E with(nolock) on p.cd_pes = E.Cd_Pes
Left join Comunicacao C with(nolock) on p.Cd_Pes = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEA = PS.Num_Proc
left join po_hem PO with(nolock) on hem.Num_Proc_HEA = po.Num_Proc_HEM and po.ID_PO_HEM = 1
JOIN Job_exp_Aer JOB	WITH (nolock)  ON job.Num_Proc_HEA=HEM.Num_Proc_HEA
left Join Usuario US with(nolock) on JOB.cd_usuario = US.cd_usuario



where 

--hem.Num_Proc_HEA = 'EAFIR202407007BR'

convert(datetime,HEM.Dt_Emis_HEA,105) > getdate() -31

Union ALL

--Buyer
SELECT
HEM.Num_Proc_HEA 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDTIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEA	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,isnull(g.Smart_EXP, P.Cd_Pes)	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,null		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEA		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_Aer HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEA = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HEA = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HEA = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HEA = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEA = PS.Num_Proc
left join Pessoa_LLP  PL with(nolock) on P.Cd_Pes = PL.Cd_Pes
Left Join Grupo G with(nolock) on PL.Cd_Pes_Grupo = G.Cd_Pes_Grupo

where 

--hem.Num_Proc_HEA = 'EAFIR202407007BR'

convert(datetime,HEM.Dt_Emis_HEA,105) > getdate() -31

Union ALL

--Importer
SELECT
HEM.Num_Proc_HEA 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEA	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,isnull(g.Smart_EXP, P.Cd_Pes)	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,null		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEA		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_Aer HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEA = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HEA = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HEA = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HEA = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEA = PS.Num_Proc
left join Pessoa_LLP  PL with(nolock) on P.Cd_Pes = PL.Cd_Pes
Left Join Grupo G with(nolock) on PL.Cd_Pes_Grupo = G.Cd_Pes_Grupo

where 

--hem.Num_Proc_HEA = 'EAFIR202407007BR'

convert(datetime,HEM.Dt_Emis_HEA,105) > getdate() -31

Union All

--Seller
SELECT
HEM.Num_Proc_HEA 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEA	[AUD_LD_DT]
,'01BDPBRSAO'			[BDP_SS_ID]
,E.Cidade				[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais				[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,P.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Compl_Fone		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEA 		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_Aer HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEA = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Export_HEA = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Export_HEA = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Export_HEA = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEA = PS.Num_Proc


where 

--hem.Num_Proc_HEA = 'EAFIR202407007BR'

convert(datetime,HEM.Dt_Emis_HEA,105) > getdate() -31

Union All

--Supplier
SELECT
HEM.Num_Proc_HEA 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEA	[AUD_LD_DT]
,'01BDPBRSAO'			[BDP_SS_ID]
,E.Cidade				[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais				[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,P.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Compl_Fone		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEA 		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_Aer HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEA = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Export_HEA = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Export_HEA = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Export_HEA = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEA = PS.Num_Proc


where 

--hem.Num_Proc_HEA = 'EAFIR202407007BR'

convert(datetime,HEM.Dt_Emis_HEA,105) > getdate() -31


Union All

--Exp Out


-- Consignee
SELECT
HEM.Num_Proc_HEO 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEO	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,isnull(G.Smart_EXP, P.Cd_Pes)	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Contato	[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEO		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_out HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEO = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HEO = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HEO = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HEO = C.Cd_Pes AND CD_TP_COM='IA1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEO = PS.Num_Proc
left join Pessoa_LLP  PL with(nolock) on P.Cd_Pes = PL.Cd_Pes
Left Join Grupo G with(nolock) on PL.Cd_Pes_Grupo = G.Cd_Pes_Grupo


where 

--hem.Num_Proc_HEO = 'EOOXT202407002BR'

convert(datetime,HEM.Dt_Emis_HEO,105) > getdate() -31

Union All

--DeliverTo

SELECT
HEM.Num_Proc_HEO 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEO	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,isnull(G.Smart_EXP,P.cd_pes)	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,null		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEO		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_Out HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEO = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HEO = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HEO = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HEO = C.Cd_Pes AND CD_TP_COM='IA1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEO = PS.Num_Proc
left join Pessoa_LLP  PL with(nolock) on P.Cd_Pes = PL.Cd_Pes
Left Join Grupo G with(nolock) on PL.Cd_Pes_Grupo = G.Cd_Pes_Grupo 


where 

--hem.Num_Proc_HEO = 'EOOXT202407002BR'

convert(datetime,HEM.Dt_Emis_HEO,105) > getdate() -31


Union All

-- Shipper
SELECT
HEM.Num_Proc_HEO 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEO	[AUD_LD_DT]
,'01BDPBRSAO'			[BDP_SS_ID]
,E.Cidade				[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais				[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,isnull(g.Smart_EXP, P.Cd_Pes)	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Compl_Fone		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEO 		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_Out HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEO = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Export_HEO = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Export_HEO = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Export_HEO = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEO = PS.Num_Proc
left join Pessoa_LLP  PL with(nolock) on P.Cd_Pes = PL.Cd_Pes
Left Join Grupo G with(nolock) on PL.Cd_Pes_Grupo = G.Cd_Pes_Grupo 


where 

--hem.Num_Proc_HEO = 'EOOXT202407002BR'

convert(datetime,HEM.Dt_Emis_HEO,105) > getdate() -31

Union All

--ShipFrom
SELECT
HEM.Num_Proc_HEO 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEO	[AUD_LD_DT]
,'01BDPBRSAO'			[BDP_SS_ID]
,E.Cidade				[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais				[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,P.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)	[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Compl_Fone		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEO 		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_Out HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEO = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Export_HEO = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Export_HEO = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Export_HEO = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEO = PS.Num_Proc


where 

--hem.Num_Proc_HEO = 'EOOXT202407002BR'

convert(datetime,HEM.Dt_Emis_HEO,105) > getdate() -31

Union All

--ShipTo
SELECT
HEM.Num_Proc_HEO 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEO	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,P.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Contato		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEO		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_out HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEO = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HEO = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HEO = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HEO = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEO = PS.Num_Proc


where 

--hem.Num_Proc_HEO = 'EOOXT202407002BR'

convert(datetime,HEM.Dt_Emis_HEO,105) > getdate() -31

Union All

--SoldTo
SELECT
HEM.Num_Proc_HEO 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEO	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,P.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Contato		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEO		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_Out HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEO = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HEO = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HEO = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HEO = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEO = PS.Num_Proc


where 

--hem.Num_Proc_HEO = 'EOOXT202407002BR'

convert(datetime,HEM.Dt_Emis_HEO,105) > getdate() -31

Union ALL

-- Notify
SELECT
HEM.Num_Proc_HEO 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEO	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,P.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)	[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,null		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEO		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_Out HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEO = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HEO = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HEO = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HEO = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEO = PS.Num_Proc



where 

--hem.Num_Proc_HEO = 'EOOXT202407002BR'

convert(datetime,HEM.Dt_Emis_HEO,105) > getdate() -31

Union ALL

-- Partner
SELECT
HEM.Num_Proc_HEO 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEO	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,p.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)	[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,[dbo].[FRemoveAcentuacao](US.Nome_Usuario)		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,null		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEO		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_Out HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEO = LC.Cd_Local
Left Join Pessoa P with(nolock) on  P.Cd_Pes = '10017'
Left join Endereco E with(nolock) on p.cd_pes = E.Cd_Pes
Left join Comunicacao C with(nolock) on p.Cd_Pes = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEO = PS.Num_Proc
left join po_heo PO with(nolock) on hem.Num_Proc_HEO = po.Num_Proc_HEO and po.ID_PO_HEO = 1
left Join Usuario US with(nolock) on PO.cd_usuario = US.cd_usuario

where 

--hem.Num_Proc_HEO = 'EOOXT202407002BR'

convert(datetime,HEM.Dt_Emis_HEO,105) > getdate() -31

Union All

--Plant
SELECT
HEM.Num_Proc_HEO 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEO	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,isnull(PL.Cd_Planta, '05031') [PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,NULL		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEO		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_Out HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEO = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HEO = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HEO = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HEO = C.Cd_Pes AND CD_TP_COM='TC1'
left join pedido_ship PS with(nolock) on hem.Num_Proc_HEO = PS.Num_Proc
left Join Pedido PD with(nolock) on PS.cd_pedido=PD.cd_pedido
left join Pessoa_LLP  PL with(nolock) on PL.Cd_Pes = PD.Cd_Buyer




where 

--hem.Num_Proc_HEO = 'EOOXT202407002BR'

convert(datetime,HEM.Dt_Emis_HEO,105) > getdate() -31

Union All

--BDPRepresentative

SELECT
HEM.Num_Proc_HEO 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEO	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,p.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,[dbo].[FRemoveAcentuacao](US.Nome_Usuario)		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,null		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEO		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_Out HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEO = LC.Cd_Local
Left Join Pessoa P with(nolock) on  P.Cd_Pes = '10017'
Left join Endereco E with(nolock) on p.cd_pes = E.Cd_Pes
Left join Comunicacao C with(nolock) on p.Cd_Pes = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEO = PS.Num_Proc
left join PO_HEO PO with(nolock) on hem.Num_Proc_HEO = po.Num_Proc_HEO and po.ID_PO_HEO = 1
left Join Usuario US with(nolock) on PO.cd_usuario = US.cd_usuario



where 

--hem.Num_Proc_HEO = 'EOOXT202407002BR'

convert(datetime,HEM.Dt_Emis_HEO,105) > getdate() -31

Union ALL

--Buyer
SELECT
HEM.Num_Proc_HEO 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDTIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEO	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,isnull(g.Smart_EXP, P.Cd_Pes)	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,null		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEO		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_out HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEO = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HEO = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HEO = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HEO = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEO = PS.Num_Proc
left join Pessoa_LLP  PL with(nolock) on P.Cd_Pes = PL.Cd_Pes
Left Join Grupo G with(nolock) on PL.Cd_Pes_Grupo = G.Cd_Pes_Grupo

where 

--hem.Num_Proc_HEO = 'EOOXT202407002BR'

convert(datetime,HEM.Dt_Emis_HEO,105) > getdate() -31

Union ALL

--Importer
SELECT
HEM.Num_Proc_HEO 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEO	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,isnull(g.Smart_EXP, P.Cd_Pes)	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,null		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEO		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_Out HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEO = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HEO = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HEO = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HEO = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEO = PS.Num_Proc
left join Pessoa_LLP  PL with(nolock) on P.Cd_Pes = PL.Cd_Pes
Left Join Grupo G with(nolock) on PL.Cd_Pes_Grupo = G.Cd_Pes_Grupo

where 

--hem.Num_Proc_HEO = 'EOOXT202407002BR'

convert(datetime,HEM.Dt_Emis_HEO,105) > getdate() -31

Union All

--Seller
SELECT
HEM.Num_Proc_HEO 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEO	[AUD_LD_DT]
,'01BDPBRSAO'			[BDP_SS_ID]
,E.Cidade				[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais				[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,P.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Compl_Fone		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEO 		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_Out HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEO = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Export_HEO = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Export_HEO = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Export_HEO = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEO = PS.Num_Proc


where 

--hem.Num_Proc_HEO = 'EOOXT202407002BR'

convert(datetime,HEM.Dt_Emis_HEO,105) > getdate() -31

Union All

--Supplier
SELECT
HEM.Num_Proc_HEO 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HEO	[AUD_LD_DT]
,'01BDPBRSAO'			[BDP_SS_ID]
,E.Cidade				[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais				[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,P.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Compl_Fone		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HEO 		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Exp_Out HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HEO = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Export_HEO = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Export_HEO = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Export_HEO = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HEO = PS.Num_Proc


where 

--hem.Num_Proc_HEO = 'EOOXT202407002BR'

convert(datetime,HEM.Dt_Emis_HEO,105) > getdate() -31


Union All

--Imp Out


-- Consignee
SELECT
HEM.Num_Proc_HIO 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIO	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,isnull(G.Smart_EXP, P.Cd_Pes)	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Contato	[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIO		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_imp_out HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIO = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HIO = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HIO = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HIO = C.Cd_Pes AND CD_TP_COM='IA1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HIO = PS.Num_Proc
left join Pessoa_LLP  PL with(nolock) on P.Cd_Pes = PL.Cd_Pes
Left Join Grupo G with(nolock) on PL.Cd_Pes_Grupo = G.Cd_Pes_Grupo


where 

--hem.Num_Proc_HIO = 'IOSWB202407003BR'

convert(datetime,HEM.Dt_Emis_HIO,105) > getdate() -31

Union All

--DeliverTo

SELECT
HEM.Num_Proc_HIO 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIO	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,isnull(G.Smart_EXP,P.cd_pes)	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,null		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIO		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Out HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIO = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HIO = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HIO = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HIO = C.Cd_Pes AND CD_TP_COM='IA1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HIO = PS.Num_Proc
left join Pessoa_LLP  PL with(nolock) on P.Cd_Pes = PL.Cd_Pes
Left Join Grupo G with(nolock) on PL.Cd_Pes_Grupo = G.Cd_Pes_Grupo 


where 

--hem.Num_Proc_HIO = 'IOSWB202407003BR'

convert(datetime,HEM.Dt_Emis_HIO,105) > getdate() -31


Union All

-- Shipper
SELECT
HEM.Num_Proc_HIO 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIO	[AUD_LD_DT]
,'01BDPBRSAO'			[BDP_SS_ID]
,E.Cidade				[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais				[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,isnull(g.Smart_EXP, P.Cd_Pes)	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Compl_Fone		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIO 		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Out HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIO = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Export_HIO = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Export_HIO = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Export_HIO = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HIO = PS.Num_Proc
left join Pessoa_LLP  PL with(nolock) on P.Cd_Pes = PL.Cd_Pes
Left Join Grupo G with(nolock) on PL.Cd_Pes_Grupo = G.Cd_Pes_Grupo 


where 

--hem.Num_Proc_HIO = 'IOSWB202407003BR'

convert(datetime,HEM.Dt_Emis_HIO,105) > getdate() -31

Union All

--ShipFrom
SELECT
HEM.Num_Proc_HIO 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIO	[AUD_LD_DT]
,'01BDPBRSAO'			[BDP_SS_ID]
,E.Cidade				[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais				[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,P.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)	[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Compl_Fone		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIO 		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Out HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIO = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Export_HIO = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Export_HIO = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Export_HIO = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HIO = PS.Num_Proc


where 

--hem.Num_Proc_HIO = 'IOSWB202407003BR'

convert(datetime,HEM.Dt_Emis_HIO,105) > getdate() -31

Union All

--ShipTo
SELECT
HEM.Num_Proc_HIO 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIO	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,P.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Contato		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIO		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Out HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIO = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HIO = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HIO = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HIO = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HIO = PS.Num_Proc


where 

--hem.Num_Proc_HIO = 'IOSWB202407003BR'

convert(datetime,HEM.Dt_Emis_HIO,105) > getdate() -31

Union All

--SoldTo
SELECT
HEM.Num_Proc_HiO 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIO	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,P.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Contato		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIO		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Out HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIO = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HIO = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HIO = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HIO = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HIO = PS.Num_Proc


where 

--hem.Num_Proc_HIO = 'IOSWB202407003BR'

convert(datetime,HEM.Dt_Emis_HIO,105) > getdate() -31

Union ALL

-- Notify
SELECT
HEM.Num_Proc_HIO 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIO	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,P.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)	[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,null		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIO		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Out HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIO = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HIO = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HIO = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HIO = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HiO = PS.Num_Proc



where 

--hem.Num_Proc_HIO = 'IOSWB202407003BR'

convert(datetime,HEM.Dt_Emis_HIO,105) > getdate() -31

Union ALL

-- Partner
SELECT
HEM.Num_Proc_HIO 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIO	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,p.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)	[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,[dbo].[FRemoveAcentuacao](US.Nome_Usuario)		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,null		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIO		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Out HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIO = LC.Cd_Local
Left Join Pessoa P with(nolock) on  P.Cd_Pes = '10017'
Left join Endereco E with(nolock) on p.cd_pes = E.Cd_Pes
Left join Comunicacao C with(nolock) on p.Cd_Pes = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HIO = PS.Num_Proc
left join po_heo PO with(nolock) on hem.Num_Proc_HIO = po.Num_Proc_HEO and po.ID_PO_HEO = 1
left Join Usuario US with(nolock) on PO.cd_usuario = US.cd_usuario

where 

--hem.Num_Proc_HIO = 'IOSWB202407003BR'

convert(datetime,HEM.Dt_Emis_HIO,105) > getdate() -31

Union All

--Plant
SELECT
HEM.Num_Proc_HIO 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIO	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,isnull(PL.Cd_Planta, '05031') [PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,NULL		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIO		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Out HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIO = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HIO = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HIO = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HIO = C.Cd_Pes AND CD_TP_COM='TC1'
left join pedido_ship PS with(nolock) on hem.Num_Proc_HIO = PS.Num_Proc
left Join Pedido PD with(nolock) on PS.cd_pedido=PD.cd_pedido
left join Pessoa_LLP  PL with(nolock) on PL.Cd_Pes = PD.Cd_Buyer




where 

--hem.Num_Proc_HIO = 'IOSWB202407003BR'

convert(datetime,HEM.Dt_Emis_HIO,105) > getdate() -31

Union All

--BDPRepresentative

SELECT
HEM.Num_Proc_HIO 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null	[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIO	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,p.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,[dbo].[FRemoveAcentuacao](US.Nome_Usuario)		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,null		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIO		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Out HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIO = LC.Cd_Local
Left Join Pessoa P with(nolock) on  P.Cd_Pes = '10017'
Left join Endereco E with(nolock) on p.cd_pes = E.Cd_Pes
Left join Comunicacao C with(nolock) on p.Cd_Pes = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HIO = PS.Num_Proc
left join PO_HEO PO with(nolock) on hem.Num_Proc_HIO = po.Num_Proc_HEO and po.ID_PO_HEO = 1
left Join Usuario US with(nolock) on PO.cd_usuario = US.cd_usuario



where 

--hem.Num_Proc_HIO = 'IOSWB202407003BR'

convert(datetime,HEM.Dt_Emis_HIO,105) > getdate() -31

Union ALL

--Buyer
SELECT
HEM.Num_Proc_HIO 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDTIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIO	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,isnull(g.Smart_EXP, P.Cd_Pes)	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,null		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIO		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Out HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIO = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HIO = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HIO = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HIO = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HIO = PS.Num_Proc
left join Pessoa_LLP  PL with(nolock) on P.Cd_Pes = PL.Cd_Pes
Left Join Grupo G with(nolock) on PL.Cd_Pes_Grupo = G.Cd_Pes_Grupo

where 

--hem.Num_Proc_HIO = 'IOSWB202407003BR'

convert(datetime,HEM.Dt_Emis_HIO,105) > getdate() -31

Union ALL

--Importer
SELECT
HEM.Num_Proc_HIO 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIO	[AUD_LD_DT]
,'01BDPBRSAO'		[BDP_SS_ID]
,E.Cidade		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,isnull(g.Smart_EXP, P.Cd_Pes)	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,null		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIO		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Out HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIO = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Consig_HIO = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Consig_HIO = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Consig_HIO = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HIO = PS.Num_Proc
left join Pessoa_LLP  PL with(nolock) on P.Cd_Pes = PL.Cd_Pes
Left Join Grupo G with(nolock) on PL.Cd_Pes_Grupo = G.Cd_Pes_Grupo

where 

--hem.Num_Proc_HIO = 'IOSWB202407003BR'

convert(datetime,HEM.Dt_Emis_HIO,105) > getdate() -31

Union All

--Seller
SELECT
HEM.Num_Proc_HIO 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIO	[AUD_LD_DT]
,'01BDPBRSAO'			[BDP_SS_ID]
,E.Cidade				[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais				[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,P.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Compl_Fone		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIO 		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Out HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIO = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Export_HIO = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Export_HIO = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Export_HIO = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HIO = PS.Num_Proc


where 

--hem.Num_Proc_HIO = 'IOSWB202407003BR'

convert(datetime,HEM.Dt_Emis_HIO,105) > getdate() -31

Union All

--Supplier
SELECT
HEM.Num_Proc_HIO 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
,[dbo].[FRemoveAcentuacao](E.Rua+ ' ' + Isnull(E.Numero,'') + ' ' + Isnull(E.Compl_end,''))		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,null		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
,hem.Dt_Emis_HIO	[AUD_LD_DT]
,'01BDPBRSAO'			[BDP_SS_ID]
,E.Cidade				[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
,E.CD_pais				[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
,E.Pais		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
--,NULL		[GOVT_ID]
--,NULL		[GOVT_ID]
,P.Cd_Pes	[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
--,NULL		[PRTY_CD]
,NULL		[PRTY_ID]
,[dbo].[FRemoveAcentuacao](P.Nome_Raz_Soc)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
--,NULL		[PRTY_NM]
,C.Compl_Fone		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
,NULL		[EMAIL_ADDR]
,NULL		[FAX_NUM]
,HEM.Num_Proc_HIO 		[FRWDR_REF_NBR_1]
,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
,E.CD_pais+E.scac		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

from House_Imp_Out HEM with(nolock)
Left Join Localidade LC with(nolock) on HEM.Cd_Dst_HIO = LC.Cd_Local
Left Join Pessoa P with(nolock) on HEM.Cd_Export_HIO = P.Cd_Pes
Left join Endereco E with(nolock) on HEM.Cd_Export_HIO = E.Cd_Pes
Left join Comunicacao C with(nolock) on HEM.Cd_Export_HIO = C.Cd_Pes AND CD_TP_COM='TC1'
Left join pedido_ship PS with(nolock) on HEM.Num_Proc_HIO = PS.Num_Proc


where 

--hem.Num_Proc_HIO = 'IOSWB202407003BR'

convert(datetime,HEM.Dt_Emis_HIO,105) > getdate() -31

 
--SELECT
--HEM.Num_Proc_HEM		[BDPJOBNUMBER]
--,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,10)		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,10)		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,10)		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,10)		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
--,NULL		[AUD_LD_DT]
--,NULL		[BDP_SS_ID]
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,11)		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
--,LC.Cd_Pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
----,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,12)		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
--,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
--,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
----,NULL		[GOVT_ID]
----,NULL		[GOVT_ID]
--,'BR'+LC.Cd_Local		[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
----,NULL		[PRTY_CD]
--,NULL		[PRTY_ID]
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,9)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
----,NULL		[PRTY_NM]
--,C.Cd_Pes		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
--,NULL		[EMAIL_ADDR]
--,NULL		[FAX_NUM]
--,HEM.Num_Proc_HEM 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
----,NULL		[FRWDR_REF_NBR]
--,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
--,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
--,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
--,LC.Cd_Pais+LC.Cd_Local		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
--,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

--from House_Exp_Mar HEM with(nolock)
--Join Localidade LC with(nolock) on HEM.Cd_Dst_HEM = LC.Cd_Local
--Join Pessoa P with(nolock) on HEM.Cd_Consig_HEM = P.Cd_Pes
--join Endereco E with(nolock) on P.Cd_Pes = E.Cd_Pes
--join Comunicacao C with(nolock) on P.Cd_Pes = C.Cd_Pes
--join pedido_ship PS with(nolock) on HEM.Num_Proc_HEM = PS.Num_Proc

--where 

--convert(datetime,HEM.Dt_Emis_HEM,105) > getdate() -31

--Union ALL

--SELECT
--HEM.Num_Proc_HIM		[BDPJOBNUMBER]
--,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,10)		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,10)		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,10)		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,10)		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
--,NULL		[AUD_LD_DT]
--,NULL		[BDP_SS_ID]
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,11)		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
--,LC.Cd_Pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
----,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,12)		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
--,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
--,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
----,NULL		[GOVT_ID]
----,NULL		[GOVT_ID]
--,'BR'+LC.Cd_Local		[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
----,NULL		[PRTY_CD]
--,NULL		[PRTY_ID]
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,9)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
----,NULL		[PRTY_NM]
--,C.Cd_Pes		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
--,NULL		[EMAIL_ADDR]
--,NULL		[FAX_NUM]
--,HEM.Num_Proc_HIM 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
----,NULL		[FRWDR_REF_NBR]
--,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
--,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
--,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
--,LC.Cd_Pais+LC.Cd_Local		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
--,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

--from House_Imp_Mar HEM with(nolock)
--Join Localidade LC with(nolock) on HEM.Cd_Dst_HIM = LC.Cd_Local
--Join Pessoa P with(nolock) on HEM.Cd_Consig_HIM = P.Cd_Pes
--join Endereco E with(nolock) on P.Cd_Pes = E.Cd_Pes
--join Comunicacao C with(nolock) on P.Cd_Pes = C.Cd_Pes
--join pedido_ship PS with(nolock) on HEM.Num_Proc_HIM = PS.Num_Proc

--where 

--convert(datetime,HEM.Dt_Emis_HIM,105) > getdate() -31

--Union ALL

--SELECT
--HEM.Num_Proc_HEA		[BDPJOBNUMBER]
--,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,10)		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,10)		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,10)		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,10)		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
--,NULL		[AUD_LD_DT]
--,NULL		[BDP_SS_ID]
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,11)		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
--,LC.Cd_Pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
----,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,12)		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
--,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
--,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
----,NULL		[GOVT_ID]
----,NULL		[GOVT_ID]
--,'BR'+LC.Cd_Local		[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
----,NULL		[PRTY_CD]
--,NULL		[PRTY_ID]
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,9)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
----,NULL		[PRTY_NM]
--,C.Cd_Pes		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
--,NULL		[EMAIL_ADDR]
--,NULL		[FAX_NUM]
--,HEM.Num_Proc_HEA 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
----,NULL		[FRWDR_REF_NBR]
--,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
--,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
--,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
--,LC.Cd_Pais+LC.Cd_Local		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
--,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

--from House_Exp_Aer HEM with(nolock)
--Join Localidade LC with(nolock) on HEM.Cd_Dst_HEA = LC.Cd_Local
--Join Pessoa P with(nolock) on HEM.Cd_Consig_HEA = P.Cd_Pes
--join Endereco E with(nolock) on P.Cd_Pes = E.Cd_Pes
--join Comunicacao C with(nolock) on P.Cd_Pes = C.Cd_Pes
--join pedido_ship PS with(nolock) on HEM.Num_Proc_HEA = PS.Num_Proc

--where 

--convert(datetime,HEM.Dt_Emis_HEA,105) > getdate() -31

--Union ALL

--SELECT
--HEM.Num_Proc_HIA		[BDPJOBNUMBER]
--,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,10)		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,10)		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,10)		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,10)		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
--,NULL		[AUD_LD_DT]
--,NULL		[BDP_SS_ID]
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,11)		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
--,LC.Cd_Pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
----,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,12)		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
--,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
--,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
----,NULL		[GOVT_ID]
----,NULL		[GOVT_ID]
--,'BR'+LC.Cd_Local		[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
----,NULL		[PRTY_CD]
--,NULL		[PRTY_ID]
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,9)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
----,NULL		[PRTY_NM]
--,C.Cd_Pes		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
--,NULL		[EMAIL_ADDR]
--,NULL		[FAX_NUM]
--,HEM.Num_Proc_HIA 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
----,NULL		[FRWDR_REF_NBR]
--,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
--,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
--,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
--,LC.Cd_Pais+LC.Cd_Local		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
--,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

--from House_Imp_Aer HEM with(nolock)
--Join Localidade LC with(nolock) on HEM.Cd_Dst_HIA = LC.Cd_Local
--Join Pessoa P with(nolock) on HEM.Cd_Consig_HIA = P.Cd_Pes
--join Endereco E with(nolock) on P.Cd_Pes = E.Cd_Pes
--join Comunicacao C with(nolock) on P.Cd_Pes = C.Cd_Pes
--join pedido_ship PS with(nolock) on HEM.Num_Proc_HIA = PS.Num_Proc

--where 

--convert(datetime,HEM.Dt_Emis_HIA,105) > getdate() -31


--Union ALL

--SELECT
--HEM.Num_Proc_HEO		[BDPJOBNUMBER]
--,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,10)		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,10)		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,10)		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,10)		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
--,NULL		[AUD_LD_DT]
--,NULL		[BDP_SS_ID]
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,11)		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
--,LC.Cd_Pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
----,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,12)		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
--,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
--,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
----,NULL		[GOVT_ID]
----,NULL		[GOVT_ID]
--,'BR'+LC.Cd_Local		[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
----,NULL		[PRTY_CD]
--,NULL		[PRTY_ID]
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,9)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
----,NULL		[PRTY_NM]
--,C.Cd_Pes		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
--,NULL		[EMAIL_ADDR]
--,NULL		[FAX_NUM]
--,HEM.Num_Proc_HEO 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
----,NULL		[FRWDR_REF_NBR]
--,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
--,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
--,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
--,LC.Cd_Pais+LC.Cd_Local		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
--,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

--from House_Exp_Out HEM with(nolock)
--Join Localidade LC with(nolock) on HEM.Cd_Dst_HEO = LC.Cd_Local
--Join Pessoa P with(nolock) on HEM.Cd_Consig_HEO = P.Cd_Pes
--join Endereco E with(nolock) on P.Cd_Pes = E.Cd_Pes
--join Comunicacao C with(nolock) on P.Cd_Pes = C.Cd_Pes
--join pedido_ship PS with(nolock) on HEM.Num_Proc_HEO = PS.Num_Proc

--where 

--convert(datetime,HEM.Dt_Emis_HEO,105) > getdate() -31


--Union ALL

--SELECT
--HEM.Num_Proc_HIO		[BDPJOBNUMBER]
--,NULL		[ADDITIONAL_NM]-- Not Send <Header><Parties><Party-Contacts><Contact-Title></Contact-Title></Party-Contacts></Parties></Header></Request>
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,10)		[ADDR_LN_1_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,10)		[ADDR_LN_2_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,10)		[ADDR_LN_3_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,10)		[ADDR_LN_4_TXT]-- <Request><Header><Parties><Party-Address></Party-Address></Parties></Header></Request>
--,NULL		[AUD_LD_DT]
--,NULL		[BDP_SS_ID]
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,11)		[CITY_NM]-- <Request><Header><Parties><Party-City></Party-City></Parties></Header></Request>
--,LC.Cd_Pais		[CNTRY_CD]-- <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
----,NULL		[CNTRY_CD]-- Not Send <Request><Header><Parties><Party-Country></Party-Country></Parties></Header></Request>
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,12)		[CNTRY_NM]-- <Request><Header><Parties><Party-CountryName></Party-CountryName></Parties></Header></Request>
--,P.GLOBAL_ENTITY_ID		[GEIC_ID]-- <Request><Header><Parties><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>
--,P.Num_CPF_CNPJ		[GOVT_ID]-- <Request><Header><Parties><GovIDNumber></GovIDNumber></Parties></Header></Request>
----,NULL		[GOVT_ID]
----,NULL		[GOVT_ID]
--,'BR'+LC.Cd_Local		[PRTY_CD]-- <Request><Header><Parties><Party-ID></Party-ID></Parties></Header></Request>
----,NULL		[PRTY_CD]
--,NULL		[PRTY_ID]
--,[dbo].[fBusca_Campo_Ordem] (PS.cd_pedido,9)		[PRTY_NM]-- <Request><Header><Parties><Party-Name></Party-Name></Parties></Header></Request>
----,NULL		[PRTY_NM]
--,C.Cd_Pes		[CONTACT]-- <Header><Parties><Party-Contacts><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
--,NULL		[EMAIL_ADDR]
--,NULL		[FAX_NUM]
--,HEM.Num_Proc_HIO 		[FRWDR_REF_NBR]-- """<Request><Header><References type=""""BDPJobNumber""""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"""
----,NULL		[FRWDR_REF_NBR]
--,NULL		[PRTY_ROLE_CD]-- Not Send <Request><Header><Parties type=""></Parties></Header></Request>
--,E.CEP		[PSTL_CD]-- <Header><Parties><Party-PostalCode></Party-PostalCode></Parties></Header></Request>
--,E.UF			[ST_PROV_CD]-- <Header><Parties><Party-State-Prov></Party-State-Prov></Parties></Header></Request>
--,LC.Cd_Pais+LC.Cd_Local		[UNLOC_CD]-- <Header><Parties><Party-UnlocCode></Party-UnlocCode></Parties></Header></Request>
--,C.Num_Fone		[PHONE_NUM]-- """If Request/Header/Parties/Party-Contacts/Contact-CommunicationAddress/type= """"Telephone"""" <Header><Parties><Party-Contacts><Contact-CommunicationAddress></Contact-CommunicationAddress></Party-Contacts></Parties></Header></Request>"""

--from House_Imp_Out HEM with(nolock)
--Join Localidade LC with(nolock) on HEM.Cd_Dst_HIO = LC.Cd_Local
--Join Pessoa P with(nolock) on HEM.Cd_Consig_HIO = P.Cd_Pes
--join Endereco E with(nolock) on P.Cd_Pes = E.Cd_Pes
--join Comunicacao C with(nolock) on P.Cd_Pes = C.Cd_Pes
--join pedido_ship PS with(nolock) on HEM.Num_Proc_HIO = PS.Num_Proc

--where 

--convert(datetime,HEM.Dt_Emis_HIO,105) > getdate() -31


GO
