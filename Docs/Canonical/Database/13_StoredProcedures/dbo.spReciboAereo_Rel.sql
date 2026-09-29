SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[spReciboAereo_Rel] 'EAATL201208004BR','LA2013020031','ITALBRONZE','São Paulo'

--[spReciboAereo_Rel] 'IAATL201303007BR','la2013031252', 'MAKENI','São Paulo'

CREATE procedure [dbo].[spReciboAereo_Rel] --'IMATL20101124901','LA2012011351','29','São Paulo'
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

		
		If Left(@Processo,2) = 'EA'
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
		
GO
