SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spFreteAuto_Ins] --'IAVCP201001001','IAATL20100100401'
(
	@Master		VarChar(14),
	@Job		varchar(16)
)

AS

--declare @Job char(16)
--set @Job = 'IMAKZ20110100101'

	declare @TipoFrete char(1)
	declare @TipoFreteMaster char(1)

	If left(@Master,2) = 'IM' and substring(@Master,3,3) <> 'CLI'
		BEGIN
			set @TipoFrete = (select tp_frete_him from House_Imp_Mar where Num_Proc_HIM = @Job)
			set @TipoFreteMaster = (select tp_frete_mim from Master_Imp_Mar where Num_Proc_mIM = @Master)
						
			if NOT exists (select * from Cta_Cte_Hou_imp_mar where Num_Proc_HIM = @Job and cd_tp_tx='FRT' and dc_him = 'C' )
				Begin
					insert into Cta_Cte_Hou_imp_mar	(
						Num_Proc_HIM, Cd_Tp_Tx, DC_HIM, Org_Ins_HIM, Dt_Ins_HIM, Cd_Tp_Moeda, Vlr_Org_HIM, Dt_Prev_Pgto_HIM, Cd_Cred_Dev_HIM, 
						Desp_Org_HIM, CPMF_HIM, Comp_RP_HIM, Comp_DN_HIM, Comp_CN_HIM, Comp_CPA_HIM, Num_DCN_HIM, Dt_Ctb_CC_HIM, Num_NF_HIM, 
						Ref_Acesso_NF_HIM, Vlr_Pgto_NF_HIM, Par_NF_HIM, Comp_Job_HIM, Contab, Vlr_Contab, Contab_Ant, Vlr_Contab_Ant, Contab_Mes_Ano, Val_Con_Comp
						)
					Select
						@Job, 'FRT', 'C', 'ATL', convert(char(10),getdate(),103), cd_tp_moeda, Vlr_Frete_Efet_HIM, convert(char(10),getdate(),103), cd_consig_him, 
						(case when @TipoFrete = 'C' and @TipoFreteMaster = 'P' then 'N' else 'S' end),'N','N','N','N','N',NULL,NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
					From  
						House_Imp_Mar
					Where
						Num_Proc_HIM = @Job
				End

				if NOT exists (select * from Cta_Cte_Hou_imp_mar where Num_Proc_HIM = @Job and cd_tp_tx='FRT' and dc_him = 'D') and @TipoFrete = 'C' and @TipoFreteMaster = 'P'
					Begin
						insert into Cta_Cte_Hou_imp_mar	(
							Num_Proc_HIM, Cd_Tp_Tx, DC_HIM, Org_Ins_HIM, Dt_Ins_HIM, Cd_Tp_Moeda, Vlr_Org_HIM, Dt_Prev_Pgto_HIM, Cd_Cred_Dev_HIM, 
							Desp_Org_HIM, CPMF_HIM, Comp_RP_HIM, Comp_DN_HIM, Comp_CN_HIM, Comp_CPA_HIM, Num_DCN_HIM, Dt_Ctb_CC_HIM, Num_NF_HIM, 
							Ref_Acesso_NF_HIM, Vlr_Pgto_NF_HIM, Par_NF_HIM, Comp_Job_HIM, Contab, Vlr_Contab, Contab_Ant, Vlr_Contab_Ant, Contab_Mes_Ano, Val_Con_Comp
							)
						Select
							@Job, 'FRT', 'D', 'ATL', convert(char(10),getdate(),103), cd_tp_moeda, Vlr_Frete_Efet_HIM, convert(char(10),getdate(),103), 
							(select cd_export_mim from master_imp_mar where num_proc_mim = @Master) shipper, 
							'N','N','N','N','N','N',NULL,NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
						From  
							House_Imp_Mar HOU
						Where
							Num_Proc_HIM = @Job
					End				
			END

	ELSE If left(@Master,2) = 'IA' and substring(@Master,3,3) <> 'CLI'
		BEGIN
			set @TipoFrete = (select tp_frete_HIA from House_Imp_Aer where Num_Proc_HIA = @Job)
			set @TipoFreteMaster = (select tp_frete_mim from Master_Imp_Mar where Num_Proc_mIM = @Master)

			if NOT exists (select * from Cta_Cte_Hou_imp_Aer where Num_Proc_HIA = @Job and cd_tp_tx='FRT' and dc_HIA = 'C' )
				Begin
					insert into Cta_Cte_Hou_imp_Aer	(
						Num_Proc_HIA, Cd_Tp_Tx, DC_HIA, Org_Ins_HIA, Dt_Ins_HIA, Cd_Tp_Moeda, Vlr_Org_HIA, Dt_Prev_Pgto_HIA, Cd_Cred_Dev_HIA, 
						Desp_Org_HIA, CPMF_HIA, Comp_RP_HIA, Comp_DN_HIA, Comp_CN_HIA, Comp_CPA_HIA, Num_DCN_HIA, Dt_Ctb_CC_HIA, Num_NF_HIA, 
						Ref_Acesso_NF_HIA, Vlr_Pgto_NF_HIA, Par_NF_HIA, Comp_Job_HIA, Contab, Vlr_Contab, Contab_Ant, Vlr_Contab_Ant, Contab_Mes_Ano, Val_Con_Comp
						)
					Select
						@Job, 'FRT', 'C', 'ATL', convert(char(10),getdate(),103), cd_tp_moeda, Vlr_Frete_Efet_HIA, convert(char(10),getdate(),103), cd_consig_HIA, 
						(case when @TipoFrete = 'C' and @TipoFreteMaster = 'P' then 'N' else 'S' end),'N','N','N','N','N',NULL,NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
					From  
						House_Imp_Aer
					Where
						Num_Proc_HIA = @Job
				End

			if NOT exists (select * from Cta_Cte_Hou_imp_Aer where Num_Proc_HIA = @Job and cd_tp_tx='FRT' and dc_HIA = 'D') and @TipoFrete = 'C' and @TipoFreteMaster = 'P'
				Begin
					insert into Cta_Cte_Hou_imp_Aer	(
						Num_Proc_HIA, Cd_Tp_Tx, DC_HIA, Org_Ins_HIA, Dt_Ins_HIA, Cd_Tp_Moeda, Vlr_Org_HIA, Dt_Prev_Pgto_HIA, Cd_Cred_Dev_HIA, 
						Desp_Org_HIA, CPMF_HIA, Comp_RP_HIA, Comp_DN_HIA, Comp_CN_HIA, Comp_CPA_HIA, Num_DCN_HIA, Dt_Ctb_CC_HIA, Num_NF_HIA, 
						Ref_Acesso_NF_HIA, Vlr_Pgto_NF_HIA, Par_NF_HIA, Comp_Job_HIA, Contab, Vlr_Contab, Contab_Ant, Vlr_Contab_Ant, Contab_Mes_Ano, Val_Con_Comp
						)
					Select
						@Job, 'FRT', 'D', 'ATL', convert(char(10),getdate(),103), cd_tp_moeda, Vlr_Frete_Efet_HIA, convert(char(10),getdate(),103), 
						(select cd_export_mia from master_imp_Aer where num_proc_mia = @Master) shipper, 
						'N','N','N','N','N','N',NULL,NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
					From  
						House_Imp_Aer HOU
					Where
						Num_Proc_HIA = @Job
				End
			
		END

	IF @@Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END
GO
