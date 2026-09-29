SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spContabilidadeCtaCte_INS]
 
	@Num_Proc		varchar(16),	
	@DC				char(1),
	@Vlr_Org		float	

AS

BEGIN TRANSACTION

declare @Cd_Cred_Dev	varchar(10)
declare @Dt_Prev_Pgto	varchar	(10)
declare	@DT_INS			varchar	(10)
declare @Cd_tp_moeda	varchar(3)
declare @Cd_tp_tx		varchar(3)

set @Dt_Prev_Pgto = convert(varchar(10), getdate(), 103)
set @DT_INS = convert(varchar(10), getdate(), 103)
set @cd_tp_moeda = 'REL'
set @Cd_Tp_Tx = 'ENC'



	BEGIN
		---------------Importação Maritima
		IF Left(@Num_Proc,2)='IM'
			BEGIN		
					
				--set @Cd_Cred_Dev = (select cd_consig_him from house_imp_mar where num_proc_him = @num_proc)
				set @Cd_Cred_Dev = (select isnull(mim.cd_export_mim,'10012') from house_imp_mar hou
									left join master_imp_mar MIM on MIM.num_proc_mim = hou.num_proc_mim and hou.num_proc_mim <> 'JOB'
									where num_proc_him = @Num_Proc)

				if not exists(select * from cta_cte_hou_imp_mar where Num_Proc_HIM=@Num_Proc AND Cd_Tp_Tx=@Cd_Tp_Tx  AND DC_HIM=@DC)		
					BEGIN
						INSERT INTO
						CTA_CTE_HOU_IMP_MAR
							(
								Num_Proc_HIM,Cd_Tp_Tx,DC_HIM,Org_Ins_HIM,Dt_Ins_HIM,Cd_Tp_Moeda,Vlr_Org_HIM,Dt_Prev_Pgto_HIM,
								Cd_Cred_Dev_HIM,Desp_Org_HIM,CPMF_HIM,Comp_RP_HIM,Comp_DN_HIM,Comp_CN_HIM,Comp_CPA_HIM,
								Num_DCN_HIM,Dt_Ctb_CC_HIM,Num_NF_HIM,Ref_Acesso_NF_HIM,Vlr_Pgto_NF_HIM,Par_NF_HIM,
								Comp_Job_HIM,Contab,Vlr_Contab,Contab_Ant,Vlr_Contab_Ant,Contab_Mes_Ano,Val_Con_Comp
							)
						VALUES
							(
								@Num_Proc,@Cd_Tp_Tx,@DC,'Imp. Mar',@Dt_INS,@Cd_tp_moeda,@Vlr_Org,@Dt_Prev_Pgto,
								@Cd_Cred_Dev,'S','N','N','N','N','N',
								Null,NULL,NULL,NULL,NULL,NULL,
								'N',0,NULL,0,NULL,NULL,NULL		
							)
					END
			END
			

		-------------Importação Aerea
		ELSE IF Left(@Num_Proc,2)='IA'
			BEGIN
				--set @Cd_Cred_Dev = (select cd_consig_hia from house_imp_aer where num_proc_hia = @num_proc)
				set @Cd_Cred_Dev = (select isnull(mim.cd_export_mia,'10012') from house_imp_aer hou
									left join master_imp_aer MIM on MIM.num_proc_mia = hou.num_proc_mia and hou.num_proc_mia <> 'JOB'
									where num_proc_hia = @Num_Proc)

				if not exists(select * from cta_cte_hou_imp_AER where Num_Proc_HIA=@Num_Proc AND Cd_Tp_Tx=@Cd_Tp_Tx AND DC_HIA=@dc)		
					BEGIN
						INSERT INTO					
						CTA_CTE_HOU_IMP_AER
							(
								Num_Proc_HIA,Cd_Tp_Tx,DC_HIA,Org_Ins_HIA,Dt_Ins_HIA,Cd_Tp_Moeda,
								Vlr_Org_HIA,Dt_Prev_Pgto_HIA,Cd_Cred_Dev_HIA,Desp_Org_HIA,CPMF_HIA,
								Comp_RP_HIA,Comp_DN_HIA,Comp_CN_HIA,Comp_CPA_HIA,Num_DCN_HIA,Dt_Ctb_CC_HIA,
								Num_NF_HIA,Ref_Acesso_NF_HIA,Vlr_Pgto_NF_HIA,Par_NF_HIA,Comp_Job_HIA,Contab,
								Vlr_Contab,Contab_Ant,Vlr_Contab_Ant,Contab_Mes_Ano,Val_Con_Comp
							)
						VALUES
							(
								@Num_Proc,@Cd_Tp_Tx,@DC,'Imp. Mar',@Dt_INS,@Cd_tp_moeda,@Vlr_Org,@Dt_Prev_Pgto,
								@Cd_Cred_Dev,'S','N','N','N','N','N',
								NULL,NULL,NULL,NULL,NULL,NULL,
								'N',0,NULL,0,NULL,NULL,NULL		
							)
					END
			END
			

		-------------Importação Outros
		ELSE IF Left(@Num_Proc,2)='IO'
			BEGIN	
				--set @Cd_Cred_Dev = (select cd_consig_hio from house_imp_out where num_proc_hio = @num_proc)
				set @Cd_Cred_Dev = '10012'
		
				if not exists(select * from cta_cte_hou_imp_out where Num_Proc_HIO=@Num_Proc AND Cd_Tp_Tx=@Cd_Tp_Tx AND DC_HIO=@dc)				
					BEGIN
					  INSERT INTO
						CTA_CTE_HOU_IMP_OUT
							(
								Num_Proc_HIO,Cd_Tp_Tx,DC_HIO,Org_Ins_HIO,Dt_Ins_HIO,Cd_Tp_Moeda,
								Vlr_Org_HIO,Dt_Prev_Pgto_HIO,Cd_Cred_Dev_HIO,Desp_Org_HIO,CPMF_HIO,
								Comp_RP_HIO,Comp_DN_HIO,Comp_CN_HIO,Comp_CPA_HIO,Num_DCN_HIO,Dt_Ctb_CC_HIO,
								Num_NF_HIO,Ref_Acesso_NF_HIO,Vlr_Pgto_NF_HIO,Par_NF_HIO,Comp_Job_HIO,Contab,
								Vlr_Contab,Contab_Ant,Vlr_Contab_Ant,Contab_Mes_Ano,Val_Con_Comp
							)
						VALUES
							(
								@Num_Proc,@Cd_Tp_Tx,@DC,'Imp. Mar',@Dt_INS,@Cd_Tp_Moeda,@Vlr_Org,@Dt_Prev_Pgto,
								@Cd_Cred_Dev,'S','N','N','N','N','N',
								NULL,NULL,NULL,NULL,NULL,NULL,
								'N',0,NULL,0,NULL,NULL,NULL		
							)
					END
			END

------------------EXPORTAÇÂO
		-------------Exportação Maritima
		ELSE IF Left(@Num_Proc,2)='EM'
			BEGIN
				--set @Cd_Cred_Dev = (select cd_consig_hem from house_exp_mar where num_proc_hem = @num_proc)
				set @Cd_Cred_Dev = (select isnull(mim.cd_export_mem,'10012') from house_exp_mar hou
									left join master_exp_mar MIM on MIM.num_proc_mem = hou.num_proc_mem and hou.num_proc_mem <> 'JOB'
									where num_proc_hem = @Num_Proc)

				if not exists(select * from cta_cte_hou_exp_mar where Num_Proc_HEM=@Num_Proc AND Cd_Tp_Tx=@Cd_Tp_Tx AND DC_HEM=@dc)				
					BEGIN
					  INSERT INTO
						CTA_CTE_HOU_Exp_MAR
							(
								Num_Proc_HEM,Cd_Tp_Tx,DC_HEM,Org_Ins_HEM,Dt_Ins_HEM,Cd_Tp_Moeda,Vlr_Org_HEM,Dt_Prev_Pgto_HEM,
								Cd_Cred_Dev_HEM,Desp_dst_HEM,CPMF_HEM,Comp_RP_HEM,Comp_DN_HEM,Comp_CN_HEM,Comp_CPA_HEM,
								Num_DCN_HEM,Dt_Ctb_CC_HEM,Num_NF_HEM,Ref_Acesso_NF_HEM,Vlr_Pgto_NF_HEM,Par_NF_HEM,
								Comp_Job_HEM,Contab,Vlr_Contab,Contab_Ant,Vlr_Contab_Ant,Contab_Mes_Ano,Val_Con_Comp
							)
						VALUES
							(
								@Num_Proc,@Cd_Tp_Tx,@DC,'Imp. Mar',@Dt_INS,@Cd_Tp_Moeda,@Vlr_Org,@Dt_Prev_Pgto,
								@Cd_Cred_Dev,'S','N','N','N','N','N',
								NULL,NULL,NULL,NULL,NULL,NULL,
								'N',0,NULL,0,NULL,NULL,NULL		
							)
					END			
			END
	-------------Exportação Aerea
		ELSE IF Left(@Num_Proc,2)='EA'
			BEGIN
				--set @Cd_Cred_Dev = (select cd_consig_hea from house_exp_aer where num_proc_hea = @num_proc)
				set @Cd_Cred_Dev = (select isnull(mim.cd_export_mea,'10012') from house_exp_aer hou
					left join master_exp_aer MIM on MIM.num_proc_mea = hou.num_proc_mea and hou.num_proc_mea <> 'JOB'
					where num_proc_hea = @Num_Proc)

				if not exists(select * from cta_cte_hou_exp_aer where Num_Proc_HEA=@Num_Proc AND Cd_Tp_Tx=@Cd_Tp_Tx AND DC_HEA=@dc)				
					BEGIN
					  INSERT INTO
						CTA_CTE_HOU_Exp_AER
							(
								Num_Proc_HEA,Cd_Tp_Tx,DC_HEA,Org_Ins_HEA,Dt_Ins_HEA,Cd_Tp_Moeda,Vlr_Org_HEA,Dt_Prev_Pgto_HEA,
								Cd_Cred_Dev_HEA,Desp_dst_HEA,CPMF_HEA,Comp_RP_HEA,Comp_DN_HEA,Comp_CN_HEA,Comp_CPA_HEA,
								Num_DCN_HEA,Dt_Ctb_CC_HEA,Num_NF_HEA,Ref_Acesso_NF_HEA,Vlr_Pgto_NF_HEA,Par_NF_HEA,Comp_Job_HEA,
								Contab,Vlr_Contab,Contab_Ant,Vlr_Contab_Ant,Contab_Mes_Ano,Val_Con_Comp
							)
						VALUES
							(
								@Num_Proc,@Cd_Tp_Tx,@DC,'Imp. Mar',@Dt_INS,@Cd_Tp_Moeda,@Vlr_Org,@Dt_Prev_Pgto,
								@Cd_Cred_Dev,'S','N','N','N','N','N',
								NULL,NULL,NULL,NULL,NULL,NULL,
								'N',0,NULL,0,NULL,NULL,NULL		
							)
					END
			END			

	-------------Exportação Outros
		ELSE IF Left(@Num_Proc,2)='EO'
			BEGIN			
				--set @Cd_Cred_Dev = (select cd_consig_heo from house_exp_out where num_proc_heo = @num_proc)
				set @Cd_Cred_Dev = '10012'

				if not exists(select * from cta_cte_hou_exp_out where Num_Proc_HEO=@Num_Proc AND Cd_Tp_Tx=@Cd_Tp_Tx AND DC_HEO=@dc)					
					BEGIN
					  INSERT INTO
						CTA_CTE_HOU_EXP_OUT
							(
								Num_Proc_HEO,Cd_Tp_Tx,DC_HEO,Org_Ins_HEO,Dt_Ins_HEO,Cd_Tp_Moeda,
								Vlr_Org_HEO,Dt_Prev_Pgto_HEO,Cd_Cred_Dev_HEO,Desp_Org_HEO,CPMF_HEO,
								Comp_RP_HEO,Comp_DN_HEO,Comp_CN_HEO,Comp_CPA_HEO,Num_DCN_HEO,Dt_Ctb_CC_HEO,
								Num_NF_HEO,Ref_Acesso_NF_HEO,Vlr_Pgto_NF_HEO,Par_NF_HEO,Comp_Job_HEO,Contab,
								Vlr_Contab,Contab_Ant,Vlr_Contab_Ant,Contab_Mes_Ano,Val_Con_Comp
							)
						VALUES
							(
								@Num_Proc,@Cd_Tp_Tx,@DC,'Imp. Mar',@Dt_INS,@Cd_Tp_Moeda,@Vlr_Org,@Dt_Prev_Pgto,
								@Cd_Cred_Dev,'S','N','N','N','N','N',
								NULL,NULL,NULL,NULL,NULL,NULL,
								'N',0,NULL,0,NULL,NULL,NULL		
							)
					END
			END		

	END

	IF @@ERROR<>0 
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END

COMMIT TRANSACTION
				
GO
