SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spMEA_Waybill_IncludedCustomsNote_Rel]--'EAGRU201610006'

		@Processo 	VarChar(14)

AS	

--XXXX Shipper XXXXXXXXXX	
--T , EIN_Number ,SHP,ConsignorParty_CountryID
--178	10017	S	Armador do MBL
select 	
	'T'					ContentCode,
	--(case when UPPER(ENDC.CD_pais) = 'CN' THEN
	--(case when UPPER(ENDC.CD_pais) in ('CN','ID','MY')THEN
	(case when P.HTS = 1 THEN
		(case when isnull(dbo.fBusca_CampoCliente(MEA.num_proc_mea,178),'BDP') = 'BDP' then 
			'EIN23-1878776'
		ELSE
			'EIN20-8141384'	
		end) 
	ELSE
		'' end)			Content,
	'SHP'				SubjectCode,	
	ENDS.CD_pais		CountryID,		--[ConsignorParty_CountryID],	
	1 ORDERBY
from 
	Master_Exp_Aer				MEA with(nolock)
	Left Outer Join LLP_Master	LLP	with(nolock) on MEA.num_proc_mea = LLP.Num_Proc_master
	Left Join Localidade		LCD with(nolock) on MEA.cd_dst_mea = LCD.cd_local
	left Join Pais				P with(nolock)on P.Cd_Pais = LCD.Cd_Pais
	Left Join Pessoa			CS	with(nolock) on CS.cd_pes=MEA.cd_consig_mea
	Left Join Endereco			ENDC with(nolock) on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
	Left Join Pessoa			Sh with(nolock) on SH.cd_pes=cd_export_mea
	Left Join Endereco			ENDS with(nolock) on SH.cd_pes=ENDS.cd_pes and ENDS.cd_tp_end = 'COM'	
Where
	MEA.Num_Proc_mea=@Processo

UNION
--CP , CONTATO ,SHP,ConsignorParty_CountryID
select 	
	'CP'					ContentCode,
	CM.Contato			Content,
	'SHP'				SubjectCode,	
	ENDS.CD_pais		CountryID		--[ConsignorParty_CountryID],
	,2 ORDERBY	
from 
	Master_Exp_Aer MEA with(nolock)
	Left Outer Join LLP_Master LLP	with(nolock)  on MEA.num_proc_mea = LLP.Num_Proc_master
	Left Join Pessoa CS				with(nolock) on CS.cd_pes=MEA.cd_consig_mea
	Left Join Endereco ENDC			with(nolock) on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
	Left Join Pessoa Sh				with(nolock) on SH.cd_pes=cd_export_mea
	Left Join Endereco ENDS			with(nolock) on SH.cd_pes=ENDS.cd_pes and ENDS.cd_tp_end = 'COM'
	Left Outer Join Comunicacao CM	with(nolock) on CM.cd_pes=SH.cd_pes and cd_Tp_com='TC1'	
Where
	MEA.Num_Proc_mea=@Processo

UNION	
--CT , TELEPHONE ,SHP,ConsignorParty_CountryID
--178	10017	S	Armador do MBL
select 	
	'CT'					ContentCode,
	COMS.cd_int + COMS.cd_area_fone + COMS.prefixo + COMS.num_fone Content, --[DirectTelephoneCommunication],	
	'SHP'				SubjectCode,	
	ENDS.CD_pais		CountryID		--[ConsignorParty_CountryID],
	,3 ORDERBY	
from 
	Master_Exp_Aer MEA with(nolock)
	Left Outer Join LLP_Master LLP	with(nolock) on MEA.num_proc_mea = LLP.Num_Proc_master
	Left Join Pessoa CS				with(nolock) on CS.cd_pes=MEA.cd_consig_mea
	Left Join Endereco ENDC			with(nolock) on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
	Left Join Pessoa Sh				with(nolock) on SH.cd_pes=cd_export_mea
	Left Join Endereco ENDS			with(nolock) on SH.cd_pes=ENDS.cd_pes and ENDS.cd_tp_end = 'COM'
	left join comunicacao COMS		with(nolock) on SH.cd_pes = COMS.cd_pes AND COMS.cd_tp_com = 'TC1'
Where
	MEA.Num_Proc_mea=@Processo	

UNION

--XXXX Consignee XXXXXXXXXX
--T, USCI CODE, CNE, CN
select 	
	'T'					ContentCode,
	--(case when UPPER(ENDC.CD_pais) = 'CN' THEN
	(case when P.HTS = 1 THEN
	--(case when UPPER(ENDC.CD_pais) in ('CN','ID','MY')THEN
		CP18.Campo_Dados ELSE
		null END)		Content,
	'CNE'				SubjectCode,	
	ENDC.CD_pais		CountryID		--[ConsigneeParty_CountryID],	
	,4 ORDERBY	
	
from 
	Master_Exp_Aer MEA with(nolock)
	Left Outer Join LLP_Master		LLP with(nolock) ON MEA.num_proc_mea = LLP.Num_Proc_master
	Left Join Localidade			LCD with(nolock) ON MEA.cd_dst_mea = LCD.cd_local
	left Join Pais					P	with(nolock) ON P.Cd_Pais = LCD.Cd_Pais
	Left Outer Join Pessoa			CS	with(nolock) ON CS.cd_pes=MEA.cd_consig_mea
	Left Outer Join Endereco		ENDC with(nolock) ON CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
	left Outer join Campo_Pessoa	CP18 with(nolock) ON CP18.Cd_Pes = CS.Cd_Pes and CP18.Id_Campo = '18'
Where
	MEA.Num_Proc_mea=@Processo
	
UNION
--CP, CONTATO, CNE, CN
select 	
	'CP'				ContentCode,
	CM.Contato			Content,
	'CNE'				SubjectCode,	
	ENDC.CD_pais		CountryID		--[ConsigneeParty_CountryID],
	,5 ORDERBY		
	
from 
	Master_Exp_Aer				MEA	with(nolock)
	Left Outer Join LLP_Master	LLP	with(nolock) ON MEA.num_proc_mea = LLP.Num_Proc_master
	Left Outer Join Pessoa		CS	with(nolock) ON CS.cd_pes=MEA.cd_consig_mea
	Left Outer Join Endereco	ENDC with(nolock) ON CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
	Left Outer Join Comunicacao CM	with(nolock) ON CM.cd_pes=cs.cd_pes and cd_Tp_com='HBL'
Where
	MEA.Num_Proc_mea=@Processo

UNION
--CT, TELEPHONE, CNE, CN
select 	
	'CT'					ContentCode,
	CM.cd_int + CM.cd_area_fone + CM.prefixo + CM.num_fone 	Content,--[DirectTelephoneCommunicationHBL]
	'CNE'				SubjectCode,	
	ENDC.CD_pais		CountryID		--[ConsigneeParty_CountryID],
	,6 ORDERBY		
	
from 
	Master_Exp_Aer				MEA with(nolock)
	Left Outer Join LLP_Master	LLP	with(nolock) on MEA.num_proc_mea = LLP.Num_Proc_master
	Left Outer Join Pessoa		CS	with(nolock) on CS.cd_pes=MEA.cd_consig_mea
	Left Outer Join Endereco	ENDC with(nolock) on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
	Left Outer Join Comunicacao CM	with(nolock) on CM.cd_pes=cs.cd_pes and cd_Tp_com='HBL'
Where
	MEA.Num_Proc_mea=@Processo
	

UNION
	
--XXXXXXXXXXX Notify
--T, USCI CODE, CO, CN
select 	
	'T'					ContentCode,
	--(case when UPPER(ENDC.CD_pais) = 'CN' THEN
	(case when P.HTS = 1 THEN
	--(case when UPPER(ENDC.CD_pais) in ('CN','ID','MY') THEN
		CP18.Campo_Dados ELSE
		null END)		Content,
	'NFY'				SubjectCode,	
	ENDC.CD_pais		CountryID		--[ConsigneeParty_CountryID],
	,7 ORDERBY		
	
from 
	Master_Exp_Aer MEA with(nolock)
	Left Outer Join LLP_Master		LLP with(nolock) ON MEA.num_proc_mea = LLP.Num_Proc_master
	Left Join Localidade			LCD with(nolock) ON MEA.cd_dst_mea = LCD.cd_local
	left Join Pais					P with(nolock)on P.Cd_Pais = LCD.Cd_Pais
	Left Outer Join Pessoa			CS with(nolock) ON CS.cd_pes=LLP.Cd_Notify
	Left Outer Join Endereco		ENDC with(nolock) ON CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
	left Outer join Campo_Pessoa	CP18 with(nolock) ON CP18.Cd_Pes = CS.Cd_Pes and CP18.Id_Campo = '18'
Where
	MEA.Num_Proc_mea=@Processo
	
UNION
--CP, CONTATO, CNE, CN
select 	
	'CP'					ContentCode,
	CM.Contato				Content,
	'NFY'				SubjectCode,	
	ENDC.CD_pais		CountryID		--[ConsigneeParty_CountryID],
	,8 ORDERBY		
	
from 
	Master_Exp_Aer MEA with(nolock)
	Left Outer Join LLP_Master	LLP	with(nolock) ON MEA.num_proc_mea = LLP.Num_Proc_master
	Left Outer Join Pessoa			CS with(nolock) ON CS.cd_pes=LLP.Cd_Notify
	Left Outer Join Endereco	ENDC with(nolock) ON CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
	Left Outer Join Comunicacao CM	with(nolock) ON CM.cd_pes=cs.cd_pes and cd_Tp_com='HBL'
Where
	MEA.Num_Proc_mea=@Processo

UNION
--CT, TELEPHONE, CNE, CN
select 	
	'CT'					ContentCode,
	CM.cd_int + CM.cd_area_fone + CM.prefixo + CM.num_fone 	Content,--[DirectTelephoneCommunicationHBL]
	'NFY'				SubjectCode,	
	ENDC.CD_pais		CountryID		--[ConsigneeParty_CountryID],
	,9 ORDERBY		
	
from 
	Master_Exp_Aer MEA
	Left Outer Join LLP_Master	LLP	on MEA.num_proc_mea = LLP.Num_Proc_master
	Left Outer Join Pessoa			CS with(nolock) ON CS.cd_pes=LLP.Cd_Notify
	Left Outer Join Endereco	ENDC on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
	Left Outer Join Comunicacao CM	on CM.cd_pes=cs.cd_pes and cd_Tp_com='HBL'
Where
	MEA.Num_Proc_mea=@Processo
	
ORDER BY 5
	
	
	
	/*
	
ALTER PROCEDURE [dbo].[spMEA_Waybill_IncludedCustomsNote_Rel]--'EAGRU201610006'

		@Processo 	VarChar(14)

AS	

--XXXX Shipper XXXXXXXXXX	
--T , EIN_Number ,SHP,ConsignorParty_CountryID
--178	10017	S	Armador do MBL
select 	
	'T'					ContentCode,
	(case when UPPER(ENDC.CD_pais) = 'CN' THEN
		(case when isnull(dbo.fBusca_CampoCliente(MEA.num_proc_mea,178),'BDP') = 'BDP' then 
			'EIN23-1878776'
		ELSE
			'EIN20-8141384'	
		end) 
	ELSE
		'' end)			Content,
	'SHP'				SubjectCode,	
	ENDS.CD_pais		CountryID,		--[ConsignorParty_CountryID],	
	1 ORDERBY
from 
	Master_Exp_Aer				MEA with(nolock)
	Left Outer Join LLP_Master LLP	with(nolock) on MEA.num_proc_mea = LLP.Num_Proc_master
	Left Join Pessoa			CS	with(nolock) on CS.cd_pes=MEA.cd_consig_mea
	Left Join Endereco			ENDC with(nolock) on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
	Left Join Pessoa			Sh with(nolock) on SH.cd_pes=cd_export_mea
	Left Join Endereco			ENDS with(nolock) on SH.cd_pes=ENDS.cd_pes and ENDS.cd_tp_end = 'COM'	
Where
	MEA.Num_Proc_mea=@Processo

UNION
--CP , CONTATO ,SHP,ConsignorParty_CountryID
select 	
	'CP'					ContentCode,
	CM.Contato			Content,
	'SHP'				SubjectCode,	
	ENDS.CD_pais		CountryID		--[ConsignorParty_CountryID],
	,2 ORDERBY	
from 
	Master_Exp_Aer MEA with(nolock)
	Left Outer Join LLP_Master LLP	with(nolock)  on MEA.num_proc_mea = LLP.Num_Proc_master
	Left Join Pessoa CS				with(nolock) on CS.cd_pes=MEA.cd_consig_mea
	Left Join Endereco ENDC			with(nolock) on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
	Left Join Pessoa Sh				with(nolock) on SH.cd_pes=cd_export_mea
	Left Join Endereco ENDS			with(nolock) on SH.cd_pes=ENDS.cd_pes and ENDS.cd_tp_end = 'COM'
	Left Outer Join Comunicacao CM	with(nolock) on CM.cd_pes=SH.cd_pes and cd_Tp_com='TC1'	
Where
	MEA.Num_Proc_mea=@Processo

UNION	
--CT , TELEPHONE ,SHP,ConsignorParty_CountryID
--178	10017	S	Armador do MBL
select 	
	'CT'					ContentCode,
	COMS.cd_int + COMS.cd_area_fone + COMS.prefixo + COMS.num_fone Content, --[DirectTelephoneCommunication],	
	'SHP'				SubjectCode,	
	ENDS.CD_pais		CountryID		--[ConsignorParty_CountryID],
	,3 ORDERBY	
from 
	Master_Exp_Aer MEA with(nolock)
	Left Outer Join LLP_Master LLP	with(nolock) on MEA.num_proc_mea = LLP.Num_Proc_master
	Left Join Pessoa CS				with(nolock) on CS.cd_pes=MEA.cd_consig_mea
	Left Join Endereco ENDC			with(nolock) on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
	Left Join Pessoa Sh				with(nolock) on SH.cd_pes=cd_export_mea
	Left Join Endereco ENDS			with(nolock) on SH.cd_pes=ENDS.cd_pes and ENDS.cd_tp_end = 'COM'
	left join comunicacao COMS		with(nolock) on SH.cd_pes = COMS.cd_pes AND COMS.cd_tp_com = 'TC1'
Where
	MEA.Num_Proc_mea=@Processo	

UNION

--XXXX Consignee XXXXXXXXXX
--T, USCI CODE, CNE, CN
select 	
	'T'					ContentCode,
	(case when UPPER(ENDC.CD_pais) = 'CN' THEN
		CP18.Campo_Dados ELSE
		null END)		Content,
	'CNE'				SubjectCode,	
	ENDC.CD_pais		CountryID		--[ConsigneeParty_CountryID],	
	,4 ORDERBY	
	
from 
	Master_Exp_Aer MEA with(nolock)
	Left Outer Join LLP_Master		LLP with(nolock) ON MEA.num_proc_mea = LLP.Num_Proc_master
	Left Outer Join Pessoa			CS with(nolock) ON CS.cd_pes=MEA.cd_consig_mea
	Left Outer Join Endereco		ENDC with(nolock) ON CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
	left Outer join Campo_Pessoa	CP18 with(nolock) ON CP18.Cd_Pes = CS.Cd_Pes and CP18.Id_Campo = '18'
Where
	MEA.Num_Proc_mea=@Processo
	
UNION
--CP, CONTATO, CNE, CN
select 	
	'CP'				ContentCode,
	CM.Contato			Content,
	'CNE'				SubjectCode,	
	ENDC.CD_pais		CountryID		--[ConsigneeParty_CountryID],
	,5 ORDERBY		
	
from 
	Master_Exp_Aer				MEA	with(nolock)
	Left Outer Join LLP_Master	LLP	with(nolock) ON MEA.num_proc_mea = LLP.Num_Proc_master
	Left Outer Join Pessoa		CS	with(nolock) ON CS.cd_pes=MEA.cd_consig_mea
	Left Outer Join Endereco	ENDC with(nolock) ON CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
	Left Outer Join Comunicacao CM	with(nolock) ON CM.cd_pes=cs.cd_pes and cd_Tp_com='HBL'
Where
	MEA.Num_Proc_mea=@Processo

UNION
--CT, TELEPHONE, CNE, CN
select 	
	'CT'					ContentCode,
	CM.cd_int + CM.cd_area_fone + CM.prefixo + CM.num_fone 	Content,--[DirectTelephoneCommunicationHBL]
	'CNE'				SubjectCode,	
	ENDC.CD_pais		CountryID		--[ConsigneeParty_CountryID],
	,6 ORDERBY		
	
from 
	Master_Exp_Aer				MEA with(nolock)
	Left Outer Join LLP_Master	LLP	with(nolock) on MEA.num_proc_mea = LLP.Num_Proc_master
	Left Outer Join Pessoa		CS	with(nolock) on CS.cd_pes=MEA.cd_consig_mea
	Left Outer Join Endereco	ENDC with(nolock) on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
	Left Outer Join Comunicacao CM	with(nolock) on CM.cd_pes=cs.cd_pes and cd_Tp_com='HBL'
Where
	MEA.Num_Proc_mea=@Processo
	

UNION
	
--XXXXXXXXXXX Notify
--T, USCI CODE, CO, CN
select 	
	'T'					ContentCode,
	(case when UPPER(ENDC.CD_pais) = 'CN' THEN
		CP18.Campo_Dados ELSE
		null END)		Content,
	'NFY'				SubjectCode,	
	ENDC.CD_pais		CountryID		--[ConsigneeParty_CountryID],
	,7 ORDERBY		
	
from 
	Master_Exp_Aer MEA with(nolock)
	Left Outer Join LLP_Master		LLP with(nolock) ON MEA.num_proc_mea = LLP.Num_Proc_master
	Left Outer Join Pessoa			CS with(nolock) ON CS.cd_pes=LLP.Cd_Notify
	Left Outer Join Endereco		ENDC with(nolock) ON CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
	left Outer join Campo_Pessoa	CP18 with(nolock) ON CP18.Cd_Pes = CS.Cd_Pes and CP18.Id_Campo = '18'
Where
	MEA.Num_Proc_mea=@Processo
	
UNION
--CP, CONTATO, CNE, CN
select 	
	'CP'					ContentCode,
	CM.Contato				Content,
	'NFY'				SubjectCode,	
	ENDC.CD_pais		CountryID		--[ConsigneeParty_CountryID],
	,8 ORDERBY		
	
from 
	Master_Exp_Aer MEA with(nolock)
	Left Outer Join LLP_Master	LLP	with(nolock) ON MEA.num_proc_mea = LLP.Num_Proc_master
	Left Outer Join Pessoa			CS with(nolock) ON CS.cd_pes=LLP.Cd_Notify
	Left Outer Join Endereco	ENDC with(nolock) ON CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
	Left Outer Join Comunicacao CM	with(nolock) ON CM.cd_pes=cs.cd_pes and cd_Tp_com='HBL'
Where
	MEA.Num_Proc_mea=@Processo

UNION
--CT, TELEPHONE, CNE, CN
select 	
	'CT'					ContentCode,
	CM.cd_int + CM.cd_area_fone + CM.prefixo + CM.num_fone 	Content,--[DirectTelephoneCommunicationHBL]
	'NFY'				SubjectCode,	
	ENDC.CD_pais		CountryID		--[ConsigneeParty_CountryID],
	,9 ORDERBY		
	
from 
	Master_Exp_Aer MEA
	Left Outer Join LLP_Master	LLP	on MEA.num_proc_mea = LLP.Num_Proc_master
	Left Outer Join Pessoa			CS with(nolock) ON CS.cd_pes=LLP.Cd_Notify
	Left Outer Join Endereco	ENDC on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
	Left Outer Join Comunicacao CM	on CM.cd_pes=cs.cd_pes and cd_Tp_com='HBL'
Where
	MEA.Num_Proc_mea=@Processo
	
ORDER BY 5



*/
--ALTER PROCEDURE [dbo].[spMEA_Waybill_IncludedCustomsNote_Rel]--'EAGRU201610006'

--		@Processo 	VarChar(14)

--AS	

----XXXX Shipper XXXXXXXXXX	
----T , EIN_Number ,SHP,ConsignorParty_CountryID
----178	10017	S	Armador do MBL
--select 	
--	'T'					ContentCode,
--	--(case when UPPER(ENDC.CD_pais) = 'CN' THEN
--	(case when UPPER(ENDC.CD_pais) in ('CN','ID')THEN
--		(case when isnull(dbo.fBusca_CampoCliente(MEA.num_proc_mea,178),'BDP') = 'BDP' then 
--			'EIN23-1878776'
--		ELSE
--			'EIN20-8141384'	
--		end) 
--	ELSE
--		'' end)			Content,
--	'SHP'				SubjectCode,	
--	ENDS.CD_pais		CountryID,		--[ConsignorParty_CountryID],	
--	1 ORDERBY
--from 
--	Master_Exp_Aer				MEA with(nolock)
--	Left Outer Join LLP_Master LLP	with(nolock) on MEA.num_proc_mea = LLP.Num_Proc_master
--	Left Join Pessoa			CS	with(nolock) on CS.cd_pes=MEA.cd_consig_mea
--	Left Join Endereco			ENDC with(nolock) on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
--	Left Join Pessoa			Sh with(nolock) on SH.cd_pes=cd_export_mea
--	Left Join Endereco			ENDS with(nolock) on SH.cd_pes=ENDS.cd_pes and ENDS.cd_tp_end = 'COM'	
--Where
--	MEA.Num_Proc_mea=@Processo

--UNION
----CP , CONTATO ,SHP,ConsignorParty_CountryID
--select 	
--	'CP'					ContentCode,
--	CM.Contato			Content,
--	'SHP'				SubjectCode,	
--	ENDS.CD_pais		CountryID		--[ConsignorParty_CountryID],
--	,2 ORDERBY	
--from 
--	Master_Exp_Aer MEA with(nolock)
--	Left Outer Join LLP_Master LLP	with(nolock)  on MEA.num_proc_mea = LLP.Num_Proc_master
--	Left Join Pessoa CS				with(nolock) on CS.cd_pes=MEA.cd_consig_mea
--	Left Join Endereco ENDC			with(nolock) on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
--	Left Join Pessoa Sh				with(nolock) on SH.cd_pes=cd_export_mea
--	Left Join Endereco ENDS			with(nolock) on SH.cd_pes=ENDS.cd_pes and ENDS.cd_tp_end = 'COM'
--	Left Outer Join Comunicacao CM	with(nolock) on CM.cd_pes=SH.cd_pes and cd_Tp_com='TC1'	
--Where
--	MEA.Num_Proc_mea=@Processo

--UNION	
----CT , TELEPHONE ,SHP,ConsignorParty_CountryID
----178	10017	S	Armador do MBL
--select 	
--	'CT'					ContentCode,
--	COMS.cd_int + COMS.cd_area_fone + COMS.prefixo + COMS.num_fone Content, --[DirectTelephoneCommunication],	
--	'SHP'				SubjectCode,	
--	ENDS.CD_pais		CountryID		--[ConsignorParty_CountryID],
--	,3 ORDERBY	
--from 
--	Master_Exp_Aer MEA with(nolock)
--	Left Outer Join LLP_Master LLP	with(nolock) on MEA.num_proc_mea = LLP.Num_Proc_master
--	Left Join Pessoa CS				with(nolock) on CS.cd_pes=MEA.cd_consig_mea
--	Left Join Endereco ENDC			with(nolock) on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
--	Left Join Pessoa Sh				with(nolock) on SH.cd_pes=cd_export_mea
--	Left Join Endereco ENDS			with(nolock) on SH.cd_pes=ENDS.cd_pes and ENDS.cd_tp_end = 'COM'
--	left join comunicacao COMS		with(nolock) on SH.cd_pes = COMS.cd_pes AND COMS.cd_tp_com = 'TC1'
--Where
--	MEA.Num_Proc_mea=@Processo	

--UNION

----XXXX Consignee XXXXXXXXXX
----T, USCI CODE, CNE, CN
--select 	
--	'T'					ContentCode,
--	--(case when UPPER(ENDC.CD_pais) = 'CN' THEN
--	(case when UPPER(ENDC.CD_pais) in ('CN','ID')THEN
--		CP18.Campo_Dados ELSE
--		null END)		Content,
--	'CNE'				SubjectCode,	
--	ENDC.CD_pais		CountryID		--[ConsigneeParty_CountryID],	
--	,4 ORDERBY	
	
--from 
--	Master_Exp_Aer MEA with(nolock)
--	Left Outer Join LLP_Master		LLP with(nolock) ON MEA.num_proc_mea = LLP.Num_Proc_master
--	Left Outer Join Pessoa			CS with(nolock) ON CS.cd_pes=MEA.cd_consig_mea
--	Left Outer Join Endereco		ENDC with(nolock) ON CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
--	left Outer join Campo_Pessoa	CP18 with(nolock) ON CP18.Cd_Pes = CS.Cd_Pes and CP18.Id_Campo = '18'
--Where
--	MEA.Num_Proc_mea=@Processo
	
--UNION
----CP, CONTATO, CNE, CN
--select 	
--	'CP'				ContentCode,
--	CM.Contato			Content,
--	'CNE'				SubjectCode,	
--	ENDC.CD_pais		CountryID		--[ConsigneeParty_CountryID],
--	,5 ORDERBY		
	
--from 
--	Master_Exp_Aer				MEA	with(nolock)
--	Left Outer Join LLP_Master	LLP	with(nolock) ON MEA.num_proc_mea = LLP.Num_Proc_master
--	Left Outer Join Pessoa		CS	with(nolock) ON CS.cd_pes=MEA.cd_consig_mea
--	Left Outer Join Endereco	ENDC with(nolock) ON CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
--	Left Outer Join Comunicacao CM	with(nolock) ON CM.cd_pes=cs.cd_pes and cd_Tp_com='HBL'
--Where
--	MEA.Num_Proc_mea=@Processo

--UNION
----CT, TELEPHONE, CNE, CN
--select 	
--	'CT'					ContentCode,
--	CM.cd_int + CM.cd_area_fone + CM.prefixo + CM.num_fone 	Content,--[DirectTelephoneCommunicationHBL]
--	'CNE'				SubjectCode,	
--	ENDC.CD_pais		CountryID		--[ConsigneeParty_CountryID],
--	,6 ORDERBY		
	
--from 
--	Master_Exp_Aer				MEA with(nolock)
--	Left Outer Join LLP_Master	LLP	with(nolock) on MEA.num_proc_mea = LLP.Num_Proc_master
--	Left Outer Join Pessoa		CS	with(nolock) on CS.cd_pes=MEA.cd_consig_mea
--	Left Outer Join Endereco	ENDC with(nolock) on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
--	Left Outer Join Comunicacao CM	with(nolock) on CM.cd_pes=cs.cd_pes and cd_Tp_com='HBL'
--Where
--	MEA.Num_Proc_mea=@Processo
	

--UNION
	
----XXXXXXXXXXX Notify
----T, USCI CODE, CO, CN
--select 	
--	'T'					ContentCode,
--	--(case when UPPER(ENDC.CD_pais) = 'CN' THEN
--	(case when UPPER(ENDC.CD_pais) in ('CN','ID')THEN
--		CP18.Campo_Dados ELSE
--		null END)		Content,
--	'NFY'				SubjectCode,	
--	ENDC.CD_pais		CountryID		--[ConsigneeParty_CountryID],
--	,7 ORDERBY		
	
--from 
--	Master_Exp_Aer MEA with(nolock)
--	Left Outer Join LLP_Master		LLP with(nolock) ON MEA.num_proc_mea = LLP.Num_Proc_master
--	Left Outer Join Pessoa			CS with(nolock) ON CS.cd_pes=LLP.Cd_Notify
--	Left Outer Join Endereco		ENDC with(nolock) ON CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
--	left Outer join Campo_Pessoa	CP18 with(nolock) ON CP18.Cd_Pes = CS.Cd_Pes and CP18.Id_Campo = '18'
--Where
--	MEA.Num_Proc_mea=@Processo
	
--UNION
----CP, CONTATO, CNE, CN
--select 	
--	'CP'					ContentCode,
--	CM.Contato				Content,
--	'NFY'				SubjectCode,	
--	ENDC.CD_pais		CountryID		--[ConsigneeParty_CountryID],
--	,8 ORDERBY		
	
--from 
--	Master_Exp_Aer MEA with(nolock)
--	Left Outer Join LLP_Master	LLP	with(nolock) ON MEA.num_proc_mea = LLP.Num_Proc_master
--	Left Outer Join Pessoa			CS with(nolock) ON CS.cd_pes=LLP.Cd_Notify
--	Left Outer Join Endereco	ENDC with(nolock) ON CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
--	Left Outer Join Comunicacao CM	with(nolock) ON CM.cd_pes=cs.cd_pes and cd_Tp_com='HBL'
--Where
--	MEA.Num_Proc_mea=@Processo

--UNION
----CT, TELEPHONE, CNE, CN
--select 	
--	'CT'					ContentCode,
--	CM.cd_int + CM.cd_area_fone + CM.prefixo + CM.num_fone 	Content,--[DirectTelephoneCommunicationHBL]
--	'NFY'				SubjectCode,	
--	ENDC.CD_pais		CountryID		--[ConsigneeParty_CountryID],
--	,9 ORDERBY		
	
--from 
--	Master_Exp_Aer MEA
--	Left Outer Join LLP_Master	LLP	on MEA.num_proc_mea = LLP.Num_Proc_master
--	Left Outer Join Pessoa			CS with(nolock) ON CS.cd_pes=LLP.Cd_Notify
--	Left Outer Join Endereco	ENDC on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
--	Left Outer Join Comunicacao CM	on CM.cd_pes=cs.cd_pes and cd_Tp_com='HBL'
--Where
--	MEA.Num_Proc_mea=@Processo
	
--ORDER BY 5
	
	
	
--	/*
	
--ALTER PROCEDURE [dbo].[spMEA_Waybill_IncludedCustomsNote_Rel]--'EAGRU201610006'

--		@Processo 	VarChar(14)

--AS	

----XXXX Shipper XXXXXXXXXX	
----T , EIN_Number ,SHP,ConsignorParty_CountryID
----178	10017	S	Armador do MBL
--select 	
--	'T'					ContentCode,
--	(case when UPPER(ENDC.CD_pais) = 'CN' THEN
--		(case when isnull(dbo.fBusca_CampoCliente(MEA.num_proc_mea,178),'BDP') = 'BDP' then 
--			'EIN23-1878776'
--		ELSE
--			'EIN20-8141384'	
--		end) 
--	ELSE
--		'' end)			Content,
--	'SHP'				SubjectCode,	
--	ENDS.CD_pais		CountryID,		--[ConsignorParty_CountryID],	
--	1 ORDERBY
--from 
--	Master_Exp_Aer				MEA with(nolock)
--	Left Outer Join LLP_Master LLP	with(nolock) on MEA.num_proc_mea = LLP.Num_Proc_master
--	Left Join Pessoa			CS	with(nolock) on CS.cd_pes=MEA.cd_consig_mea
--	Left Join Endereco			ENDC with(nolock) on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
--	Left Join Pessoa			Sh with(nolock) on SH.cd_pes=cd_export_mea
--	Left Join Endereco			ENDS with(nolock) on SH.cd_pes=ENDS.cd_pes and ENDS.cd_tp_end = 'COM'	
--Where
--	MEA.Num_Proc_mea=@Processo

--UNION
----CP , CONTATO ,SHP,ConsignorParty_CountryID
--select 	
--	'CP'					ContentCode,
--	CM.Contato			Content,
--	'SHP'				SubjectCode,	
--	ENDS.CD_pais		CountryID		--[ConsignorParty_CountryID],
--	,2 ORDERBY	
--from 
--	Master_Exp_Aer MEA with(nolock)
--	Left Outer Join LLP_Master LLP	with(nolock)  on MEA.num_proc_mea = LLP.Num_Proc_master
--	Left Join Pessoa CS				with(nolock) on CS.cd_pes=MEA.cd_consig_mea
--	Left Join Endereco ENDC			with(nolock) on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
--	Left Join Pessoa Sh				with(nolock) on SH.cd_pes=cd_export_mea
--	Left Join Endereco ENDS			with(nolock) on SH.cd_pes=ENDS.cd_pes and ENDS.cd_tp_end = 'COM'
--	Left Outer Join Comunicacao CM	with(nolock) on CM.cd_pes=SH.cd_pes and cd_Tp_com='TC1'	
--Where
--	MEA.Num_Proc_mea=@Processo

--UNION	
----CT , TELEPHONE ,SHP,ConsignorParty_CountryID
----178	10017	S	Armador do MBL
--select 	
--	'CT'					ContentCode,
--	COMS.cd_int + COMS.cd_area_fone + COMS.prefixo + COMS.num_fone Content, --[DirectTelephoneCommunication],	
--	'SHP'				SubjectCode,	
--	ENDS.CD_pais		CountryID		--[ConsignorParty_CountryID],
--	,3 ORDERBY	
--from 
--	Master_Exp_Aer MEA with(nolock)
--	Left Outer Join LLP_Master LLP	with(nolock) on MEA.num_proc_mea = LLP.Num_Proc_master
--	Left Join Pessoa CS				with(nolock) on CS.cd_pes=MEA.cd_consig_mea
--	Left Join Endereco ENDC			with(nolock) on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
--	Left Join Pessoa Sh				with(nolock) on SH.cd_pes=cd_export_mea
--	Left Join Endereco ENDS			with(nolock) on SH.cd_pes=ENDS.cd_pes and ENDS.cd_tp_end = 'COM'
--	left join comunicacao COMS		with(nolock) on SH.cd_pes = COMS.cd_pes AND COMS.cd_tp_com = 'TC1'
--Where
--	MEA.Num_Proc_mea=@Processo	

--UNION

----XXXX Consignee XXXXXXXXXX
----T, USCI CODE, CNE, CN
--select 	
--	'T'					ContentCode,
--	(case when UPPER(ENDC.CD_pais) = 'CN' THEN
--		CP18.Campo_Dados ELSE
--		null END)		Content,
--	'CNE'				SubjectCode,	
--	ENDC.CD_pais		CountryID		--[ConsigneeParty_CountryID],	
--	,4 ORDERBY	
	
--from 
--	Master_Exp_Aer MEA with(nolock)
--	Left Outer Join LLP_Master		LLP with(nolock) ON MEA.num_proc_mea = LLP.Num_Proc_master
--	Left Outer Join Pessoa			CS with(nolock) ON CS.cd_pes=MEA.cd_consig_mea
--	Left Outer Join Endereco		ENDC with(nolock) ON CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
--	left Outer join Campo_Pessoa	CP18 with(nolock) ON CP18.Cd_Pes = CS.Cd_Pes and CP18.Id_Campo = '18'
--Where
--	MEA.Num_Proc_mea=@Processo
	
--UNION
----CP, CONTATO, CNE, CN
--select 	
--	'CP'				ContentCode,
--	CM.Contato			Content,
--	'CNE'				SubjectCode,	
--	ENDC.CD_pais		CountryID		--[ConsigneeParty_CountryID],
--	,5 ORDERBY		
	
--from 
--	Master_Exp_Aer				MEA	with(nolock)
--	Left Outer Join LLP_Master	LLP	with(nolock) ON MEA.num_proc_mea = LLP.Num_Proc_master
--	Left Outer Join Pessoa		CS	with(nolock) ON CS.cd_pes=MEA.cd_consig_mea
--	Left Outer Join Endereco	ENDC with(nolock) ON CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
--	Left Outer Join Comunicacao CM	with(nolock) ON CM.cd_pes=cs.cd_pes and cd_Tp_com='HBL'
--Where
--	MEA.Num_Proc_mea=@Processo

--UNION
----CT, TELEPHONE, CNE, CN
--select 	
--	'CT'					ContentCode,
--	CM.cd_int + CM.cd_area_fone + CM.prefixo + CM.num_fone 	Content,--[DirectTelephoneCommunicationHBL]
--	'CNE'				SubjectCode,	
--	ENDC.CD_pais		CountryID		--[ConsigneeParty_CountryID],
--	,6 ORDERBY		
	
--from 
--	Master_Exp_Aer				MEA with(nolock)
--	Left Outer Join LLP_Master	LLP	with(nolock) on MEA.num_proc_mea = LLP.Num_Proc_master
--	Left Outer Join Pessoa		CS	with(nolock) on CS.cd_pes=MEA.cd_consig_mea
--	Left Outer Join Endereco	ENDC with(nolock) on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
--	Left Outer Join Comunicacao CM	with(nolock) on CM.cd_pes=cs.cd_pes and cd_Tp_com='HBL'
--Where
--	MEA.Num_Proc_mea=@Processo
	

--UNION
	
----XXXXXXXXXXX Notify
----T, USCI CODE, CO, CN
--select 	
--	'T'					ContentCode,
--	(case when UPPER(ENDC.CD_pais) = 'CN' THEN
--		CP18.Campo_Dados ELSE
--		null END)		Content,
--	'NFY'				SubjectCode,	
--	ENDC.CD_pais		CountryID		--[ConsigneeParty_CountryID],
--	,7 ORDERBY		
	
--from 
--	Master_Exp_Aer MEA with(nolock)
--	Left Outer Join LLP_Master		LLP with(nolock) ON MEA.num_proc_mea = LLP.Num_Proc_master
--	Left Outer Join Pessoa			CS with(nolock) ON CS.cd_pes=LLP.Cd_Notify
--	Left Outer Join Endereco		ENDC with(nolock) ON CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
--	left Outer join Campo_Pessoa	CP18 with(nolock) ON CP18.Cd_Pes = CS.Cd_Pes and CP18.Id_Campo = '18'
--Where
--	MEA.Num_Proc_mea=@Processo
	
--UNION
----CP, CONTATO, CNE, CN
--select 	
--	'CP'					ContentCode,
--	CM.Contato				Content,
--	'NFY'				SubjectCode,	
--	ENDC.CD_pais		CountryID		--[ConsigneeParty_CountryID],
--	,8 ORDERBY		
	
--from 
--	Master_Exp_Aer MEA with(nolock)
--	Left Outer Join LLP_Master	LLP	with(nolock) ON MEA.num_proc_mea = LLP.Num_Proc_master
--	Left Outer Join Pessoa			CS with(nolock) ON CS.cd_pes=LLP.Cd_Notify
--	Left Outer Join Endereco	ENDC with(nolock) ON CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
--	Left Outer Join Comunicacao CM	with(nolock) ON CM.cd_pes=cs.cd_pes and cd_Tp_com='HBL'
--Where
--	MEA.Num_Proc_mea=@Processo

--UNION
----CT, TELEPHONE, CNE, CN
--select 	
--	'CT'					ContentCode,
--	CM.cd_int + CM.cd_area_fone + CM.prefixo + CM.num_fone 	Content,--[DirectTelephoneCommunicationHBL]
--	'NFY'				SubjectCode,	
--	ENDC.CD_pais		CountryID		--[ConsigneeParty_CountryID],
--	,9 ORDERBY		
	
--from 
--	Master_Exp_Aer MEA
--	Left Outer Join LLP_Master	LLP	on MEA.num_proc_mea = LLP.Num_Proc_master
--	Left Outer Join Pessoa			CS with(nolock) ON CS.cd_pes=LLP.Cd_Notify
--	Left Outer Join Endereco	ENDC on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
--	Left Outer Join Comunicacao CM	on CM.cd_pes=cs.cd_pes and cd_Tp_com='HBL'
--Where
--	MEA.Num_Proc_mea=@Processo
	
--ORDER BY 5



--*/








	
	
	
	
	




GO
