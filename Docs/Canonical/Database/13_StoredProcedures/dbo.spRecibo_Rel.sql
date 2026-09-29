SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from po_hia where num_proc_hia= 'iavix20090600201'
--select * from pessoa where nome_raz_soc = 'VILA PORTO INTERNATIONAL BUSINESS S/A'
--select * from caixa_hou_imp_mar where num_rcb_him = 'RCA120100251'
--[spRecibo_Rel] 'IMVPF201111002BR','LA2012011351','VILA PORTO','São Paulo'


CREATE procedure [dbo].[spRecibo_Rel] --'IMATL20101124901','LA2012011351','29','São Paulo'
	@Processo as varchar(16),
	@Num_Lcto as varchar(12),
	@Cred_Dev as varchar(50),
	@Site as varchar(20)
as

	Declare @Cd_Cred_Dev as varchar(10)
	Declare @Cd_Pes_Site as varchar(10)

	Set @Cd_Cred_Dev = (Select cd_pes from pessoa With(nolock) where apelido = @Cred_Dev)
	
	set @Cd_Pes_Site = (
		Case 
			when @Site = 'São Paulo'	  then '10017'
			when @Site = 'Santos'		  then '10018'
			when @Site = 'Recife'		  then '110077'
			when @Site = 'Belo Horizonte' then 'P11355'
--			when @Site = 'Rio de Janeiro' then ''
			when @Site = 'Porto Alegre'   then 'P13313'
--			when @Site = 'Campinas'		  then ''
		end)

If len(@Processo) = 16 or substring(@Processo,3,3) = 'REM'
	Begin
		If left(@Processo,2) = 'EM' 
			Begin
				select 
					EPT.Nome_Raz_Soc,
					CX.vlr_Pgto_Rcto_Hem Vlr_Pgto_Rcto,
					CX.DC_hem DC, 
					CX.Num_Rcb_Hem	Num_Rcb,
					EPT.Num_CPF_CNPJ EXP_CNPJ,
					EPT.Num_RG_IE EXP_IE,
					EDR.Rua EXP_Rua,   
					EDR.Numero	EXP_Numero,
					EDR.Bairro	EXP_Bairro,
					EDR.Cidade	EXP_Cidade,
					EDR.UF		EXP_UF,
					HOU.Num_Proc_Hem Processo,
					HOU.MAWB_Hem MASTER,
					HOU.HAWB_Hem HOUSE,
					EDS.Rua		     EDS_Rua,   
					EDS.Numero	     EDS_Numero,
					EDS.Bairro	     EDS_Bairro,
					EDS.Cidade       EDS_Cidade,
					EDS.CEP		     EDS_CEP,
					EDS.Compl_End    EDS_Compl_End,
					EDS.UF		     EDS_UF,
					CMS.cd_area_fone CMS_cd_area_fone,
					CMS.prefixo      CMS_prefixo,
					CMS.Num_Fone     CMS_Num_Fone,
					CMS.Compl_Fone   CMS_Compl_Fone,
					'Maritimo'		Tipo_Frete,
					convert(datetime,PR.Dt_Vcto,103) Dt_Vcto,
					dbo.fBusca_Docs_PO_Modal(CX.num_proc_hem,'1') PO,
					dbo.fBusca_Docs_PO_Modal(CX.num_proc_hem,'9') [Customer PO]
--					PO.numero_po_hem PO

			    from 
					pgto_rcto PR With(nolock)
				left outer join caixa_hou_exp_mar CX With(nolock) on PR.Num_Lcto = CX.Num_Lcto
				left outer join house_exp_mar HOU With(nolock) on CX.Num_proc_hem = HOU.Num_proc_hem
--				left outer join po_hem PO on hou.num_proc_hem = PO.num_proc_hem and PO.id_dc = 1
				left outer join cta_cte_hou_exp_mar CC With(nolock) on CX.Num_proc_hem = CC.Num_proc_hem and CC.cd_tp_tx = CX.cd_tp_tx and CC.dc_hem = CX.dc_hem
				left outer join Pessoa EPT With(nolock) on @Cd_Cred_Dev = EPT.cd_pes
				left outer join Endereco EDR With(nolock) on @Cd_Cred_Dev = EDR.cd_pes and cd_tp_end = 'COM'
				left outer join Pessoa SIT With(nolock) on @Cd_Pes_Site = SIT.Cd_Pes
				left Outer join Endereco EDS With(nolock) on @Cd_Pes_Site = EDS.Cd_Pes and EDS.cd_tp_end = 'COM'
				left outer join Comunicacao CMS With(nolock) on @Cd_Pes_Site = CMS.Cd_Pes and CMS.cd_tp_com = 'TC1'				
		   where CX.num_proc_hem = @Processo and CX.num_lcto = @Num_Lcto and CC.Cd_Cred_Dev_hem = @Cd_Cred_Dev
			End
		Else If left(@Processo,2) = 'IM'
			Begin
				select 
					EPT.Nome_Raz_Soc,
					CX.vlr_Pgto_Rcto_him Vlr_Pgto_Rcto,
					CX.DC_him DC,
					CX.Num_Rcb_Him Num_Rcb,
					EPT.Num_CPF_CNPJ EXP_CNPJ,
					EPT.Num_RG_IE EXP_IE,
					EDR.Rua EXP_Rua,   
					EDR.Numero	EXP_Numero,
					EDR.Bairro	EXP_Bairro,
					EDR.Cidade	EXP_Cidade,
					EDR.UF		EXP_UF,
					HOU.Num_Proc_him Processo,
					HOU.MAWB_him MASTER,
					HOU.HAWB_him HOUSE,
					EDS.Rua		     EDS_Rua,   
					EDS.Numero	     EDS_Numero,
					EDS.Bairro	     EDS_Bairro,
					EDS.Cidade       EDS_Cidade,
					EDS.CEP		     EDS_CEP,
					EDS.Compl_End    EDS_Compl_End,
					EDS.UF		     EDS_UF,
					CMS.cd_area_fone CMS_cd_area_fone,
					CMS.prefixo      CMS_prefixo,
					CMS.Num_Fone     CMS_Num_Fone,
					CMS.Compl_Fone   CMS_Compl_Fone,
					'Maritimo'		Tipo_Frete,
					convert(datetime,PR.Dt_Vcto,103) Dt_Vcto,
					dbo.fBusca_Docs_PO_Modal(CX.num_proc_him,'1') PO,
					dbo.fBusca_Docs_PO_Modal(CX.num_proc_him,'9') [Customer PO]
--					numero_po_him PO
				from 
					pgto_rcto PR With(nolock)
				left outer join caixa_hou_imp_mar CX With(nolock) on PR.Num_Lcto = CX.Num_Lcto
				left outer join house_imp_mar HOU With(nolock) on CX.Num_proc_him = HOU.Num_proc_him
--				left outer join po_him PO on hou.num_proc_him = PO.num_proc_him and PO.id_dc = 1
				left outer join cta_cte_hou_imp_mar CC With(nolock) on CX.Num_proc_him = CC.Num_proc_him and CC.cd_tp_tx = CX.cd_tp_tx and CC.dc_him = CX.dc_him
				left outer join Pessoa EPT With(nolock) on @Cd_Cred_Dev= EPT.cd_pes
				left outer join Endereco EDR With(nolock) on @Cd_Cred_Dev = EDR.cd_pes and cd_tp_end = 'COM'
				left outer join Pessoa SIT With(nolock) on @Cd_Pes_Site = SIT.Cd_Pes
				left Outer join Endereco EDS With(nolock) on @Cd_Pes_Site = EDS.Cd_Pes and EDS.cd_tp_end = 'COM'
				left outer join Comunicacao CMS With(nolock) on @Cd_Pes_Site = CMS.Cd_Pes and CMS.cd_tp_com = 'TC1'
				where CX.num_proc_him = @Processo and CX.num_lcto = @Num_Lcto and CC.Cd_Cred_Dev_him = @Cd_Cred_Dev
					and cx.cd_Tp_tx <> 'XCA'
			End
		Else If Left(@Processo,2) = 'EA'
			Begin
				select 
					EPT.Nome_Raz_Soc,
					CX.vlr_Pgto_Rcto_hea Vlr_Pgto_Rcto, 
					CX.DC_hea DC,
					CX.Num_Rcb_Hea Num_Rcb,
					EPT.Num_CPF_CNPJ EXP_CNPJ,
					EPT.Num_RG_IE EXP_IE,
					EDR.Rua EXP_Rua,   
					EDR.Numero	EXP_Numero,
					EDR.Bairro	EXP_Bairro,
					EDR.Cidade	EXP_Cidade,
					EDR.UF		EXP_UF,
					HOU.Num_Proc_hea Processo,
					HOU.MAWB_hea MASTER,
					HOU.HAWB_hea HOUSE,
					EDS.Rua		     EDS_Rua,   
					EDS.Numero	     EDS_Numero,
					EDS.Bairro	     EDS_Bairro,
					EDS.Cidade       EDS_Cidade,
					EDS.CEP		     EDS_CEP,
					EDS.Compl_End    EDS_Compl_End,
					EDS.UF		     EDS_UF,
					CMS.cd_area_fone CMS_cd_area_fone,
					CMS.prefixo      CMS_prefixo,
					CMS.Num_Fone     CMS_Num_Fone,
					CMS.Compl_Fone   CMS_Compl_Fone,
					'Aéreo'		Tipo_Frete,
					convert(datetime,PR.Dt_Vcto,103) Dt_Vcto,
					dbo.fBusca_Docs_PO_Modal(CX.num_proc_hea,'1') PO,
					dbo.fBusca_Docs_PO_Modal(CX.num_proc_hea,'9') [Customer PO]
--					Po.numero_po_hea PO
			     from 
					pgto_rcto PR With(nolock)
				left outer join caixa_hou_exp_aer CX With(nolock) on PR.Num_Lcto = CX.Num_Lcto
				left outer join house_exp_aer HOU With(nolock) on CX.Num_proc_hea = HOU.Num_proc_hea
--				left outer join po_hea PO on hou.num_proc_hea = PO.num_proc_hea and PO.id_dc = 1
				left outer join cta_cte_hou_exp_aer CC With(nolock) on CX.Num_proc_hea = CC.Num_proc_hea and CC.cd_tp_tx = CX.cd_tp_tx and CC.dc_hea = CX.dc_hea
				left outer join Pessoa EPT With(nolock) on @Cd_Cred_Dev = EPT.cd_pes
				left outer join Endereco EDR With(nolock) on @Cd_Cred_Dev = EDR.cd_pes and cd_tp_end = 'COM'
				left outer join Pessoa SIT With(nolock) on @Cd_Pes_Site = SIT.Cd_Pes
				left Outer join Endereco EDS With(nolock) on @Cd_Pes_Site = EDS.Cd_Pes and EDS.cd_tp_end = 'COM'
				left outer join Comunicacao CMS With(nolock) on @Cd_Pes_Site = CMS.Cd_Pes and CMS.cd_tp_com = 'TC1'
				where CX.num_proc_hea = @Processo and CX.num_lcto = @Num_Lcto and CC.Cd_Cred_Dev_hea = @Cd_Cred_Dev
			End
		Else If left(@Processo,2) = 'IA'
			Begin
				select 
					EPT.Nome_Raz_Soc,
					CX.vlr_Pgto_Rcto_hia Vlr_Pgto_Rcto,
					CX.DC_hia DC, 
					CX.Num_Rcb_Hia Num_Rcb,
					EPT.Num_CPF_CNPJ EXP_CNPJ,
					EPT.Num_RG_IE EXP_IE,
					EDR.Rua EXP_Rua,   
					EDR.Numero	EXP_Numero,
					EDR.Bairro	EXP_Bairro,
					EDR.Cidade	EXP_Cidade,
					EDR.UF		EXP_UF,
					HOU.Num_Proc_hia Processo,
					HOU.MAWB_hia MASTER,
					HOU.HAWB_hia HOUSE,
					EDS.Rua		     EDS_Rua,   
					EDS.Numero	     EDS_Numero,
					EDS.Bairro	     EDS_Bairro,
					EDS.Cidade       EDS_Cidade,
					EDS.CEP		     EDS_CEP,
					EDS.Compl_End    EDS_Compl_End,
					EDS.UF		     EDS_UF,
					CMS.cd_area_fone CMS_cd_area_fone,
					CMS.prefixo      CMS_prefixo,
					CMS.Num_Fone     CMS_Num_Fone,
					CMS.Compl_Fone   CMS_Compl_Fone,
					'Aéreo'		Tipo_Frete,
					convert(datetime,PR.Dt_Vcto,103) Dt_Vcto,
					dbo.fBusca_Docs_PO_Modal(CX.num_proc_hia,'1') PO,
					dbo.fBusca_Docs_PO_Modal(CX.num_proc_hia,'9') [Customer PO]
--					Po.numero_po_hia PO
				from 
					pgto_rcto PR With(nolock)
				left outer join caixa_hou_imp_aer CX With(nolock) on PR.Num_Lcto = CX.Num_Lcto
				left outer join house_imp_aer HOU With(nolock) on CX.Num_proc_hia = HOU.Num_proc_hia
--				left outer join po_hia PO on hou.num_proc_hia = PO.num_proc_hia and PO.id_dc = 1
				left outer join cta_cte_hou_imp_aer CC With(nolock) on CX.Num_proc_hia = CC.Num_proc_hia and CC.cd_tp_tx = CX.cd_tp_tx and CC.dc_hia = CX.dc_hia
				left outer join Pessoa EPT With(nolock) on @Cd_Cred_Dev = EPT.cd_pes
				left outer join Endereco EDR With(nolock) on @Cd_Cred_Dev = EDR.cd_pes and cd_tp_end = 'COM'
				left outer join Pessoa SIT With(nolock) on @Cd_Pes_Site = SIT.Cd_Pes
				left Outer join Endereco EDS With(nolock) on @Cd_Pes_Site = EDS.Cd_Pes and EDS.cd_tp_end = 'COM'
				left outer join Comunicacao CMS With(nolock) on @Cd_Pes_Site = CMS.Cd_Pes and CMS.cd_tp_com = 'TC1'
				where CX.num_proc_hia = @Processo and CX.num_lcto = @Num_Lcto and CC.Cd_Cred_Dev_hia = @Cd_Cred_Dev
			End
		Else If left(@Processo,2) = 'EO'
			Begin
				select 
					EPT.Nome_Raz_Soc,
					CX.vlr_Pgto_Rcto_heo Vlr_Pgto_Rcto,
					CX.DC_heo DC, 
					CX.Num_Rcb_Heo Num_Rcb,
					EPT.Num_CPF_CNPJ EXP_CNPJ,
					EPT.Num_RG_IE EXP_IE,
					EDR.Rua EXP_Rua,   
					EDR.Numero	EXP_Numero,
					EDR.Bairro	EXP_Bairro,
					EDR.Cidade	EXP_Cidade,
					EDR.UF		EXP_UF,
					HOU.Num_Proc_heo Processo,
					HOU.MAWB_heo MASTER,
					HOU.HAWB_heo HOUSE,
					EDS.Rua		     EDS_Rua,   
					EDS.Numero	     EDS_Numero,
					EDS.Bairro	     EDS_Bairro,
					EDS.Cidade       EDS_Cidade,
					EDS.CEP		     EDS_CEP,
					EDS.Compl_End    EDS_Compl_End,
					EDS.UF		     EDS_UF,
					CMS.cd_area_fone CMS_cd_area_fone,
					CMS.prefixo      CMS_prefixo,
					CMS.Num_Fone     CMS_Num_Fone,
					CMS.Compl_Fone   CMS_Compl_Fone,
					LLP.Tipo_Leo	Tipo_Frete,
					convert(datetime,PR.Dt_Vcto,103) Dt_Vcto,
					dbo.fBusca_Docs_PO_Modal(CX.num_proc_heo,'1') PO,
					dbo.fBusca_Docs_PO_Modal(CX.num_proc_heo,'9') [Customer PO]
--					PO.numero_po_heo PO
				from 
					pgto_rcto PR With(nolock)
				left outer join caixa_hou_exp_out CX With(nolock) on PR.Num_Lcto = CX.Num_Lcto
				left outer join house_exp_out HOU With(nolock) on CX.Num_proc_heo = HOU.Num_proc_heo
--				left outer join po_heo PO on hou.num_proc_heo = PO.num_proc_heo and PO.id_dc = 1
				join llp_exp_out LLP With(nolock) on HOU.Num_proc_heo = LLP.Num_proc_leo
				left outer join cta_cte_hou_exp_out CC With(nolock) on CX.Num_proc_heo = CC.Num_proc_heo and CC.cd_tp_tx = CX.cd_tp_tx and CC.dc_heo = CX.dc_heo 
				left outer join Pessoa EPT With(nolock) on @Cd_Cred_Dev = EPT.cd_pes
				left outer join Endereco EDR With(nolock) on @Cd_Cred_Dev = EDR.cd_pes and cd_tp_end = 'COM'
				left outer join Pessoa SIT With(nolock) on @Cd_Pes_Site = SIT.Cd_Pes
				left Outer join Endereco EDS With(nolock) on @Cd_Pes_Site = EDS.Cd_Pes and EDS.cd_tp_end = 'COM'
				left outer join Comunicacao CMS With(nolock) on @Cd_Pes_Site = CMS.Cd_Pes and CMS.cd_tp_com = 'TC1'
				where CX.num_proc_heo = @Processo and CX.num_lcto = @Num_Lcto and CC.Cd_Cred_Dev_heo = @Cd_Cred_Dev
			End
		Else If left(@Processo,2) = 'IO'
			Begin
				select 
					EPT.Nome_Raz_Soc,
					CX.vlr_Pgto_Rcto_hio Vlr_Pgto_Rcto, 
					CX.DC_hio DC,
					CX.Num_Rcb_Hio Num_Rcb,
					EPT.Num_CPF_CNPJ EXP_CNPJ,
					EPT.Num_RG_IE EXP_IE,
					EDR.Rua EXP_Rua,   
					EDR.Numero	EXP_Numero,
					EDR.Bairro	EXP_Bairro,
					EDR.Cidade	EXP_Cidade,
					EDR.UF		EXP_UF,
					HOU.Num_Proc_hio Processo,
					HOU.MAWB_hio MASTER,
					HOU.HAWB_hio HOUSE,
					EDS.Rua		     EDS_Rua,   
					EDS.Numero	     EDS_Numero,
					EDS.Bairro	     EDS_Bairro,
					EDS.Cidade       EDS_Cidade,
					EDS.CEP		     EDS_CEP,
					EDS.Compl_End    EDS_Compl_End,
					EDS.UF		     EDS_UF,
					CMS.cd_area_fone CMS_cd_area_fone,
					CMS.prefixo      CMS_prefixo,
					CMS.Num_Fone     CMS_Num_Fone,
					CMS.Compl_Fone   CMS_Compl_Fone,
					LLP.Tipo_Lio	Tipo_Frete,
					convert(datetime,PR.Dt_Vcto,103) Dt_Vcto,
					dbo.fBusca_Docs_PO_Modal(CX.num_proc_hio,'1') PO,
					dbo.fBusca_Docs_PO_Modal(CX.num_proc_hio,'9') [Customer PO]
--					PO.numero_po_hio PO
				from 
					pgto_rcto PR With(nolock)
				left outer join caixa_hou_imp_out CX With(nolock) on PR.Num_Lcto = CX.Num_Lcto
				left outer join house_imp_out HOU With(nolock) on CX.Num_proc_hio = HOU.Num_proc_hio
--				left outer join po_hio PO on hou.num_proc_hio = PO.num_proc_hio and PO.id_dc = 1
				join llp_imp_out LLP With(nolock) on HOU.Num_proc_hio = LLP.Num_proc_lio
				left outer join cta_cte_hou_imp_out CC With(nolock) on CX.Num_proc_hio = CC.Num_proc_hio and CC.cd_tp_tx = CX.cd_tp_tx and CC.dc_hio = CX.dc_hio
				left outer join Pessoa EPT With(nolock) on @Cd_Cred_Dev = EPT.cd_pes
				left outer join Endereco EDR With(nolock) on @Cd_Cred_Dev = EDR.cd_pes and cd_tp_end = 'COM'
				left outer join Pessoa SIT With(nolock) on @Cd_Pes_Site = SIT.Cd_Pes
				left Outer join Endereco EDS With(nolock) on @Cd_Pes_Site = EDS.Cd_Pes and EDS.cd_tp_end = 'COM'
				left outer join Comunicacao CMS With(nolock) on @Cd_Pes_Site = CMS.Cd_Pes and CMS.cd_tp_com = 'TC1'
				where CX.num_proc_hio = @Processo and CX.num_lcto = @Num_Lcto and CC.Cd_Cred_Dev_hio = @Cd_Cred_Dev
			End
End
If len(@Processo) = 14
	Begin
		If left(@Processo,2) = 'EM'
			Begin
				select 
					EPT.Nome_Raz_Soc,
					CX.vlr_Pgto_Rcto_mem Vlr_Pgto_Rcto, 
					CX.DC_mem DC,
					CX.Num_Rcb_mem Num_Rcb,
					EPT.Num_CPF_CNPJ EXP_CNPJ,
					EPT.Num_RG_IE EXP_IE,
					EDR.Rua EXP_Rua,   
					EDR.Numero	EXP_Numero,
					EDR.Bairro	EXP_Bairro,
					EDR.Cidade	EXP_Cidade,
					EDR.UF		EXP_UF,
					MAS.Num_Proc_mem Processo,
					MAS.MAWB_mem MASTER,
					EDS.Rua		     EDS_Rua,   
					EDS.Numero	     EDS_Numero,
					EDS.Bairro	     EDS_Bairro,
					EDS.Cidade       EDS_Cidade,
					EDS.CEP		     EDS_CEP,
					EDS.Compl_End    EDS_Compl_End,
					EDS.UF		     EDS_UF,
					CMS.cd_area_fone CMS_cd_area_fone,
					CMS.prefixo      CMS_prefixo,
					CMS.Num_Fone     CMS_Num_Fone,
					CMS.Compl_Fone   CMS_Compl_Fone,
					Null HOUSE,
					'Maritimo'		Tipo_Frete,
					convert(datetime,PR.Dt_Vcto,103) Dt_Vcto,
					dbo.fBusca_Docs_PO_Modal(CX.num_proc_mem,'1') PO,
					dbo.fBusca_Docs_PO_Modal(CX.num_proc_mem,'9') [Customer PO]
--					PO.numero_po_hem PO
				from 
					pgto_rcto PR With(nolock)
				left outer join caixa_MAS_exp_mar CX With(nolock) on PR.Num_Lcto = CX.Num_Lcto
				left outer join master_exp_mar MAS With(nolock) on CX.Num_proc_mem = MAS.Num_proc_mem
--				left outer join po_hem PO on MAS.num_proc_mem = PO.num_proc_hem and PO.id_dc = 1
				left outer join cta_cte_mas_exp_mar CC With(nolock) on CX.Num_proc_mem = CC.Num_proc_mem and CC.cd_tp_tx = CX.cd_tp_tx and CC.dc_mem = CX.dc_mem
				left outer join Pessoa EPT With(nolock) on @Cd_Cred_Dev = EPT.cd_pes
				left outer join Endereco EDR With(nolock) on @Cd_Cred_Dev = EDR.cd_pes and cd_tp_end = 'COM'
				left outer join Pessoa SIT With(nolock) on @Cd_Pes_Site = SIT.Cd_Pes
				left Outer join Endereco EDS With(nolock) on @Cd_Pes_Site = EDS.Cd_Pes and EDS.cd_tp_end = 'COM'
				left outer join Comunicacao CMS With(nolock) on @Cd_Pes_Site = CMS.Cd_Pes and CMS.cd_tp_com = 'TC1'
				where CX.num_proc_mem = @Processo and CX.num_lcto = @Num_Lcto and CC.Cd_Cred_Dev_mem = @Cd_Cred_Dev
			End	
		Else If left(@Processo,2) = 'IM'
			Begin
				select 
					EPT.Nome_Raz_Soc,
					CX.vlr_Pgto_Rcto_mim Vlr_Pgto_Rcto, 
					CX.DC_mim DC,
					CX.Num_Rcb_mim Num_Rcb,
					EPT.Num_CPF_CNPJ EXP_CNPJ,
					EPT.Num_RG_IE EXP_IE,
					EDR.Rua EXP_Rua,   
					EDR.Numero	EXP_Numero,
					EDR.Bairro	EXP_Bairro,
					EDR.Cidade	EXP_Cidade,
					EDR.UF		EXP_UF,
					MAS.Num_Proc_mim Processo,
					MAS.MAWB_mim MASTER,
					EDS.Rua		     EDS_Rua,   
					EDS.Numero	     EDS_Numero,
					EDS.Bairro	     EDS_Bairro,
					EDS.Cidade       EDS_Cidade,
					EDS.CEP		     EDS_CEP,
					EDS.Compl_End    EDS_Compl_End,
					EDS.UF		     EDS_UF,
					CMS.cd_area_fone CMS_cd_area_fone,
					CMS.prefixo      CMS_prefixo,
					CMS.Num_Fone     CMS_Num_Fone,
					CMS.Compl_Fone   CMS_Compl_Fone,
					Null HOUSE,
					'Maritimo'		Tipo_Frete,
					convert(datetime,PR.Dt_Vcto,103) Dt_Vcto,
					dbo.fBusca_Docs_PO_Modal(CX.num_proc_mim,'1') PO,
					dbo.fBusca_Docs_PO_Modal(CX.num_proc_mim,'9') [Customer PO]
--					PO.numero_po_him PO
				from 
					pgto_rcto PR With(nolock)
				left outer join caixa_MAS_imp_mar CX With(nolock) on PR.Num_Lcto = CX.Num_Lcto
				left outer join master_imp_mar MAS With(nolock) on CX.Num_proc_mim = MAS.Num_proc_mim
--				left outer join po_him PO on MAS.num_proc_mim = PO.num_proc_him and PO.id_dc = 1
				left outer join cta_cte_mas_imp_mar CC With(nolock) on CX.Num_proc_mim = CC.Num_proc_mim and CC.cd_tp_tx = CX.cd_tp_tx and CC.dc_mim = CX.dc_mim
				left outer join Pessoa EPT With(nolock) on @Cd_Cred_Dev = EPT.cd_pes
				left outer join Endereco EDR With(nolock) on @Cd_Cred_Dev = EDR.cd_pes and cd_tp_end = 'COM'
				left outer join Pessoa SIT With(nolock) on @Cd_Pes_Site = SIT.Cd_Pes
				left Outer join Endereco EDS With(nolock) on @Cd_Pes_Site = EDS.Cd_Pes and EDS.cd_tp_end = 'COM'
				left outer join Comunicacao CMS With(nolock) on @Cd_Pes_Site = CMS.Cd_Pes and CMS.cd_tp_com = 'TC1'
				where CX.num_proc_mim = @Processo and CX.num_lcto = @Num_Lcto and CC.Cd_Cred_Dev_mim = @Cd_Cred_Dev
			End
	    Else If left(@Processo,2) = 'EA'
			Begin
				select 
					EPT.Nome_Raz_Soc,
					CX.vlr_Pgto_Rcto_mea Vlr_Pgto_Rcto, 
					CX.DC_mea DC,
					CX.Num_Rcb_mea Num_Rcb,
					EPT.Num_CPF_CNPJ EXP_CNPJ,
					EPT.Num_RG_IE EXP_IE,
					EDR.Rua EXP_Rua,   
					EDR.Numero	EXP_Numero,
					EDR.Bairro	EXP_Bairro,
					EDR.Cidade	EXP_Cidade,
					EDR.UF		EXP_UF,
					MAS.Num_Proc_mea Processo,
					MAS.MAWB_mea MASTER,
					EDS.Rua		     EDS_Rua,   
					EDS.Numero	     EDS_Numero,
					EDS.Bairro	     EDS_Bairro,
					EDS.Cidade       EDS_Cidade,
					EDS.CEP		     EDS_CEP,
					EDS.Compl_End    EDS_Compl_End,
					EDS.UF		     EDS_UF,
					CMS.cd_area_fone CMS_cd_area_fone,
					CMS.prefixo      CMS_prefixo,
					CMS.Num_Fone     CMS_Num_Fone,
					CMS.Compl_Fone   CMS_Compl_Fone,
					Null HOUSE,
					'Aéreo'		Tipo_Frete,
					convert(datetime,PR.Dt_Vcto,103) Dt_Vcto,
					dbo.fBusca_Docs_PO_Modal( CX.num_proc_mea,'1') PO,
					dbo.fBusca_Docs_PO_Modal(CX.num_proc_mea,'9') [Customer PO]
--					PO.numero_po_hea PO
				from 
					pgto_rcto PR With(nolock)
				left outer join caixa_MAS_exp_aer CX With(nolock) on PR.Num_Lcto = CX.Num_Lcto
				left outer join master_exp_aer MAS With(nolock) on CX.Num_proc_mea = MAS.Num_proc_mea
--				left outer join po_hea PO on MAS.num_proc_mea = PO.num_proc_hea and PO.id_dc = 1
				left outer join cta_cte_mas_exp_aer CC With(nolock) on CX.Num_proc_mea = CC.Num_proc_mea and CC.cd_tp_tx = CX.cd_tp_tx and CC.dc_mea = CX.dc_mea
				left outer join Pessoa EPT With(nolock) on @Cd_Cred_Dev = EPT.cd_pes
				left outer join Endereco EDR With(nolock) on @Cd_Cred_Dev = EDR.cd_pes and cd_tp_end = 'COM'
				left outer join Pessoa SIT With(nolock) on @Cd_Pes_Site = SIT.Cd_Pes
				left Outer join Endereco EDS With(nolock) on @Cd_Pes_Site = EDS.Cd_Pes and EDS.cd_tp_end = 'COM'
				left outer join Comunicacao CMS With(nolock) on @Cd_Pes_Site = CMS.Cd_Pes and CMS.cd_tp_com = 'TC1'
				where CX.num_proc_mea = @Processo and CX.num_lcto = @Num_Lcto and CC.Cd_Cred_Dev_mea = @Cd_Cred_Dev
			End
		Else If Left(@Processo,2) = 'IA'
			Begin
				select 
					EPT.Nome_Raz_Soc,
					CX.vlr_Pgto_Rcto_mia Vlr_Pgto_Rcto,
					CX.DC_mia DC, 
					CX.Num_Rcb_mia Num_Rcb,
					EPT.Num_CPF_CNPJ EXP_CNPJ,
					EPT.Num_RG_IE EXP_IE,
					EDR.Rua EXP_Rua,   
					EDR.Numero	EXP_Numero,
					EDR.Bairro	EXP_Bairro,
					EDR.Cidade	EXP_Cidade,
					EDR.UF		EXP_UF,
					MAS.Num_Proc_mia Processo,
					MAS.MAWB_mia MASTER,
					EDS.Rua		     EDS_Rua,   
					EDS.Numero	     EDS_Numero,
					EDS.Bairro	     EDS_Bairro,
					EDS.Cidade       EDS_Cidade,
					EDS.CEP		     EDS_CEP,
					EDS.Compl_End    EDS_Compl_End,
					EDS.UF		     EDS_UF,
					CMS.cd_area_fone CMS_cd_area_fone,
					CMS.prefixo      CMS_prefixo,
					CMS.Num_Fone     CMS_Num_Fone,
					CMS.Compl_Fone   CMS_Compl_Fone,
					Null HOUSE,
					'Aéreo Maritimo'		Tipo_Frete,
					convert(datetime,PR.Dt_Vcto,103) Dt_Vcto,
					dbo.fBusca_Docs_PO_Modal(CX.num_proc_mia,'1') PO,
					dbo.fBusca_Docs_PO_Modal(CX.num_proc_mia,'9') [Customer PO]
--					PO.numero_po_hia PO
				from 
					pgto_rcto PR With(nolock)
				left outer join caixa_MAS_imp_aer CX With(nolock) on PR.Num_Lcto = CX.Num_Lcto
				left outer join master_imp_aer MAS With(nolock) on CX.Num_proc_mia = MAS.Num_proc_mia
--				left outer join po_hia PO on MAS.num_proc_mia = PO.num_proc_hia and PO.id_dc = 1
				left outer join cta_cte_mas_imp_aer CC With(nolock) on CX.Num_proc_mia = CC.Num_proc_mia and CC.cd_tp_tx = CX.cd_tp_tx and CC.dc_mia = CX.dc_mia
				left outer join Pessoa EPT With(nolock) on @Cd_Pes_Site = EPT.cd_pes
				left outer join Endereco EDR With(nolock) on @Cd_Pes_Site = EDR.cd_pes and cd_tp_end = 'COM'
				left outer join Pessoa SIT With(nolock) on @Cd_Pes_Site = SIT.Cd_Pes
				left Outer join Endereco EDS With(nolock) on @Cd_Pes_Site = EDS.Cd_Pes and EDS.cd_tp_end = 'COM'
				left outer join Comunicacao CMS With(nolock) on @Cd_Pes_Site = CMS.Cd_Pes and CMS.cd_tp_com = 'TC1'
				where CX.num_proc_mia = @Processo and CX.num_lcto = @Num_Lcto and CC.Cd_Cred_Dev_mia = @Cd_Cred_Dev
			End
END
































GO
