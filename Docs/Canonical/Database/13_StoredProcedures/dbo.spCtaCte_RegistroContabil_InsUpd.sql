SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--cadu_08-10-13 - criei esta stored pra ser usada no doc register, retirando o nf is null, pois qdo o user da update ja
--tem nf(doc register incluido)
CREATE Procedure [dbo].[spCtaCte_RegistroContabil_InsUpd]

		@Num_Proc		Varchar(16),
		@Cd_Tp_Tx		Varchar(3),
		@DC				Char(1),
		@Org_Ins		VarChar(9),
		@Dt_Ins			Char(10),
		@Cd_Tp_Moeda	Varchar(3),
		@Vlr_Org		Decimal(10,2),
		@Dt_Prev_Pgto	VarChar(10),
		@Cd_Cred_Dev	VarChar(10),
		@Desp_Org		Char(1),
		@CPMF			Char(1),
		@Comp_RP		Char(1),
		@Comp_DN		Char(1),
		@Comp_CN		Char(1),
		@Comp_CPA		Char(1),
		@Num_DCN		VarChar(9),
		@Dt_Ctb_CC		VarChar(10),
		@Num_NF			Varchar(12),
		@Ref_Acesso_NF	Varchar(1),
		@Vlr_Pgto_NF	Decimal(10,2),
		@Par_NF			float,
		@Comp_Job		Char(1),
		@Contab			bit,
		@Vlr_Contab		Decimal(10,2),
		@Contab_Ant		bit,
		@Vlr_Contab_Ant Decimal(10,2),
		@Contab_Mes_Ano	Varchar(7),
		@Val_Con_Comp	Decimal(10,2)

AS

BEGIN TRANSACTION

		--Erbson 05-12-2013: Sempre utilizar a data atual para insert ou update.
		Set @Dt_Ins = (select convert(varchar,getdate(),103))
		
		--Erbson 08-01-2014: Não GRAVA CASO JÁ TENHA AX_DOC	/copiei do spCtaCteModal_InsUpd - cadu - 09/06/2014
		IF EXISTS(select id_AX from vwAXDocs where num_proc = @Num_Proc and cd_tp_tx_atl = @Cd_Tp_Tx and DC = @DC)
			BEGIN
				RETURN -2
			END
		
		--Erbson 23-01-2014: Não grava caso a moeda esteja desativada /copiei do spCtaCteModal_InsUpd - cadu - 09/06/2014
		IF (select ativo from tipo_moeda where cd_Tp_Moeda = @Cd_Tp_Moeda) <> 1
			Begin
				RETURN -2
			End	

if exists(select * from vwcxas where num_proc_hia=@num_proc and cd_tp_Tx=@cd_tp_tx and dc_hia=@dc) 
	Begin
		
		ROLLBACK TRANSACTION
		return -2
	End

IF LEFT(@NUM_PROC,2)='IM' AND LEN(@NUM_PROC)=16
	BEGIN	
		IF NOT EXISTS(SELECT CD_TP_TX FROM CTA_CTE_HOU_IMP_MAR WHERE NUM_PROC_HIM=@NUM_PROC AND CD_TP_TX=@CD_TP_TX AND DC_HIM=@dc)
			BEGIN
				INSERT INTO
					CTA_CTE_HOU_IMP_MAR
						(
							Num_Proc_HIM,Cd_Tp_Tx,DC_HIM,Org_Ins_HIM,Dt_Ins_HIM,Cd_Tp_Moeda,
							Vlr_Org_HIM,Dt_Prev_Pgto_HIM,Cd_Cred_Dev_HIM,Desp_Org_HIM,CPMF_HIM,
							Comp_RP_HIM,Comp_DN_HIM,Comp_CN_HIM,Comp_CPA_HIM,Num_DCN_HIM,Dt_Ctb_CC_HIM,
							Num_NF_HIM,Ref_Acesso_NF_HIM,Vlr_Pgto_NF_HIM,Par_NF_HIM,Comp_Job_HIM,Contab,
							Vlr_Contab,Contab_Ant,Vlr_Contab_Ant,Contab_Mes_Ano,Val_Con_Comp
						)
					VALUES
						(
							@Num_Proc,@Cd_Tp_Tx,@DC,@Org_Ins,@Dt_Ins,@Cd_Tp_Moeda,@Vlr_Org,
							@Dt_Prev_Pgto,@Cd_Cred_Dev,@Desp_Org,@CPMF,	@Comp_RP,@Comp_DN,
							@Comp_CN,@Comp_CPA,@Num_DCN,@Dt_Ctb_CC,@Num_NF,	@Ref_Acesso_NF,
							@Vlr_Pgto_NF,@Par_NF,@Comp_Job,	@Contab,@Vlr_Contab,@Contab_Ant,
							@Vlr_Contab_Ant,@Contab_Mes_Ano,@Val_Con_Comp
						)
			END	
		ELSE
			BEGIN
				UPDATE
					cta_cte_hou_imp_mar
					set
						Org_Ins_HIM=@Org_Ins,
						Dt_Ins_HIM=@Dt_Ins,
						Cd_Tp_Moeda=@Cd_Tp_Moeda,
						Vlr_Org_HIM=@Vlr_Org,
						Dt_Prev_Pgto_HIM=@Dt_Prev_Pgto,
						Cd_Cred_Dev_HIM=@Cd_Cred_Dev,
						Desp_Org_HIM=@Desp_Org,
						CPMF_HIM=@CPMF,
						Comp_RP_HIM=@Comp_RP,
						Comp_DN_HIM=@Comp_DN,
						Comp_CN_HIM=@Comp_CN,
						Comp_CPA_HIM=@Comp_CPA,
						Num_DCN_HIM=@Num_DCN,
						Dt_Ctb_CC_HIM=@Dt_Ctb_CC,
						Num_NF_HIM=@Num_NF,
						Ref_Acesso_NF_HIM=@Ref_Acesso_NF,
						Vlr_Pgto_NF_HIM=@Vlr_Pgto_NF,
						Par_NF_HIM=@Par_NF,
						Comp_Job_HIM=@Comp_Job,
						Contab=@Contab,
						Vlr_Contab=@Vlr_Contab,
						Contab_Ant=@Contab_Ant,
						Vlr_Contab_Ant=@Vlr_Contab_Ant,
						Contab_Mes_Ano=@Contab_Mes_Ano,
						Val_Con_Comp=@Val_Con_Comp
				WHERE
						NUM_PROC_HIM=@NUM_PROC AND CD_TP_TX=@CD_tP_TX AND DC_HIM=@DC
						--AND NUM_NF_HIM IS NULL 
						and ref_acesso_nf_him is null
			END
	END

IF LEFT(@NUM_PROC,2)='EM' AND LEN(@NUM_PROC)=16 
	BEGIN
		IF NOT EXISTS(SELECT CD_TP_TX FROM CTA_CTE_HOU_EXP_MAR WHERE NUM_PROC_HEM=@NUM_PROC AND CD_TP_TX=@CD_TP_TX AND DC_HEM=@dc)
			BEGIN
				INSERT INTO
					CTA_CTE_HOU_EXP_MAR
						(
							Num_Proc_HEM,Cd_Tp_Tx,DC_HEM,Org_Ins_HEM,Dt_Ins_HEM,Cd_Tp_Moeda,
							Vlr_Org_HEM,Dt_Prev_Pgto_HEM,Cd_Cred_Dev_HEM,Desp_Dst_HEM,CPMF_HEM,
							Comp_RP_HEM,Comp_DN_HEM,Comp_CN_HEM,Comp_CPA_HEM,Num_DCN_HEM,Dt_Ctb_CC_HEM,
							Num_NF_HEM,Ref_Acesso_NF_HEM,Vlr_Pgto_NF_HEM,Par_NF_HEM,Comp_Job_HEM,Contab,
							Vlr_Contab,Contab_Ant,Vlr_Contab_Ant,Contab_Mes_Ano,Val_Con_Comp
						)
					VALUES
						(
							@Num_Proc,@Cd_Tp_Tx,@DC,@Org_Ins,@Dt_Ins,@Cd_Tp_Moeda,@Vlr_Org,
							@Dt_Prev_Pgto,@Cd_Cred_Dev,@Desp_Org,@CPMF,	@Comp_RP,@Comp_DN,
							@Comp_CN,@Comp_CPA,@Num_DCN,@Dt_Ctb_CC,@Num_NF,	@Ref_Acesso_NF,
							@Vlr_Pgto_NF,@Par_NF,@Comp_Job,	@Contab,@Vlr_Contab,@Contab_Ant,
							@Vlr_Contab_Ant,@Contab_Mes_Ano,@Val_Con_Comp
						)
			END
		ELSE			BEGIN
				UPDATE
					cta_cte_hou_EXP_MAR
						set
							Org_Ins_HEM=@Org_Ins,
							Dt_Ins_HEM=@Dt_Ins,
							Cd_Tp_Moeda=@Cd_Tp_Moeda,
							Vlr_Org_HEM=@Vlr_Org,
							Dt_Prev_Pgto_HEM=@Dt_Prev_Pgto,
							Cd_Cred_Dev_HEM=@Cd_Cred_Dev,
							Desp_Dst_HEM=@Desp_Org,
							CPMF_HEM=@CPMF,
							Comp_RP_HEM=@Comp_RP,
							Comp_DN_HEM=@Comp_DN,
							Comp_CN_HEM=@Comp_CN,
							Comp_CPA_HEM=@Comp_CPA,
							Num_DCN_HEM=@Num_DCN,
							Dt_Ctb_CC_HEM=@Dt_Ctb_CC,
							Num_NF_HEM=@Num_NF,
							Ref_Acesso_NF_HEM=@Ref_Acesso_NF,
							Vlr_Pgto_NF_HEM=@Vlr_Pgto_NF,
							Par_NF_HEM=@Par_NF,
							Comp_Job_HEM=@Comp_Job,
							Contab=@Contab,
							Vlr_Contab=@Vlr_Contab,
							Contab_Ant=@Contab_Ant,
							Vlr_Contab_Ant=@Vlr_Contab_Ant,
							Contab_Mes_Ano=@Contab_Mes_Ano,
							Val_Con_Comp=@Val_Con_Comp
					WHERE
							NUM_PROC_HEM=@NUM_PROC AND CD_TP_TX=@CD_tP_TX AND DC_HEM=@DC
							--AND NUM_NF_HEM IS NULL
							and ref_acesso_nf_hem is null	
		END
	END

IF LEFT(@NUM_PROC,2)='IA' AND LEN(@NUM_PROC)=16
	BEGIN
		IF NOT EXISTS(SELECT CD_TP_TX FROM CTA_CTE_HOU_IMP_AER WHERE NUM_PROC_HIA=@NUM_PROC AND CD_TP_TX=@CD_TP_TX AND DC_HIA=@dc)
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
							@Num_Proc,@Cd_Tp_Tx,@DC,@Org_Ins,@Dt_Ins,@Cd_Tp_Moeda,@Vlr_Org,
							@Dt_Prev_Pgto,@Cd_Cred_Dev,@Desp_Org,@CPMF,	@Comp_RP,@Comp_DN,
							@Comp_CN,@Comp_CPA,@Num_DCN,@Dt_Ctb_CC,@Num_NF,	@Ref_Acesso_NF,
							@Vlr_Pgto_NF,@Par_NF,@Comp_Job,	@Contab,@Vlr_Contab,@Contab_Ant,
							@Vlr_Contab_Ant,@Contab_Mes_Ano,@Val_Con_Comp
						)
			END
		ELSE			BEGIN
				UPDATE
					cta_cte_hou_imp_AER
						set
							Org_Ins_HIA=@Org_Ins,
							Dt_Ins_HIA=@Dt_Ins,
							Cd_Tp_Moeda=@Cd_Tp_Moeda,
							Vlr_Org_HIA=@Vlr_Org,
							Dt_Prev_Pgto_HIA=@Dt_Prev_Pgto,
							Cd_Cred_Dev_HIA=@Cd_Cred_Dev,
							Desp_Org_HIA=@Desp_Org,
							CPMF_HIA=@CPMF,
							Comp_RP_HIA=@Comp_RP,
							Comp_DN_HIA=@Comp_DN,
							Comp_CN_HIA=@Comp_CN,
							Comp_CPA_HIA=@Comp_CPA,
							Num_DCN_HIA=@Num_DCN,
							Dt_Ctb_CC_HIA=@Dt_Ctb_CC,
							Num_NF_HIA=@Num_NF,
							Ref_Acesso_NF_HIA=@Ref_Acesso_NF,
							Vlr_Pgto_NF_HIA=@Vlr_Pgto_NF,
							Par_NF_HIA=@Par_NF,
							Comp_Job_HIA=@Comp_Job,
							Contab=@Contab,
							Vlr_Contab=@Vlr_Contab,
							Contab_Ant=@Contab_Ant,
							Vlr_Contab_Ant=@Vlr_Contab_Ant,
							Contab_Mes_Ano=@Contab_Mes_Ano,
							Val_Con_Comp=@Val_Con_Comp
					WHERE
							NUM_PROC_HIA=@NUM_PROC AND CD_TP_TX=@CD_tP_TX AND DC_HIA=@DC
							--AND NUM_NF_HIA IS NULL	
							and ref_acesso_nf_hia is null
		END
	END

IF LEFT(@NUM_PROC,2)='EA' AND LEN(@NUM_PROC)=16 
	BEGIN
		IF NOT EXISTS(SELECT CD_TP_TX FROM CTA_CTE_HOU_EXP_AER WHERE NUM_PROC_HEA=@NUM_PROC AND CD_TP_TX=@CD_TP_TX AND DC_HEA=@dc)
			BEGIN
				INSERT INTO
					CTA_CTE_HOU_EXP_AER
						(
							Num_Proc_HEA,Cd_Tp_Tx,DC_HEA,Org_Ins_HEA,Dt_Ins_HEA,Cd_Tp_Moeda,
							Vlr_Org_HEA,Dt_Prev_Pgto_HEA,Cd_Cred_Dev_HEA,Desp_Dst_HEA,CPMF_HEA,
							Comp_RP_HEA,Comp_DN_HEA,Comp_CN_HEA,Comp_CPA_HEA,Num_DCN_HEA,Dt_Ctb_CC_HEA,
							Num_NF_HEA,Ref_Acesso_NF_HEA,Vlr_Pgto_NF_HEA,Par_NF_HEA,Comp_Job_HEA,Contab,
							Vlr_Contab,Contab_Ant,Vlr_Contab_Ant,Contab_Mes_Ano,Val_Con_Comp
						)
					VALUES
						(
							@Num_Proc,@Cd_Tp_Tx,@DC,@Org_Ins,@Dt_Ins,@Cd_Tp_Moeda,@Vlr_Org,
							@Dt_Prev_Pgto,@Cd_Cred_Dev,@Desp_Org,@CPMF,	@Comp_RP,@Comp_DN,
							@Comp_CN,@Comp_CPA,@Num_DCN,@Dt_Ctb_CC,@Num_NF,	@Ref_Acesso_NF,
							@Vlr_Pgto_NF,@Par_NF,@Comp_Job,	@Contab,@Vlr_Contab,@Contab_Ant,
							@Vlr_Contab_Ant,@Contab_Mes_Ano,@Val_Con_Comp
						)
			END
		ELSE			BEGIN
				UPDATE
					cta_cte_hou_EXP_AER
						set
							Org_Ins_HEA=@Org_Ins,
							Dt_Ins_HEA=@Dt_Ins,
							Cd_Tp_Moeda=@Cd_Tp_Moeda,
							Vlr_Org_HEA=@Vlr_Org,
							Dt_Prev_Pgto_HEA=@Dt_Prev_Pgto,
							Cd_Cred_Dev_HEA=@Cd_Cred_Dev,
							Desp_Dst_HEA=@Desp_Org,
							CPMF_HEA=@CPMF,
							Comp_RP_HEA=@Comp_RP,
							Comp_DN_HEA=@Comp_DN,
							Comp_CN_HEA=@Comp_CN,
							Comp_CPA_HEA=@Comp_CPA,
							Num_DCN_HEA=@Num_DCN,
							Dt_Ctb_CC_HEA=@Dt_Ctb_CC,
							Num_NF_HEA=@Num_NF,
							Ref_Acesso_NF_HEA=@Ref_Acesso_NF,
							Vlr_Pgto_NF_HEA=@Vlr_Pgto_NF,
							Par_NF_HEA=@Par_NF,
							Comp_Job_HEA=@Comp_Job,
							Contab=@Contab,
							Vlr_Contab=@Vlr_Contab,
							Contab_Ant=@Contab_Ant,
							Vlr_Contab_Ant=@Vlr_Contab_Ant,
							Contab_Mes_Ano=@Contab_Mes_Ano,
							Val_Con_Comp=@Val_Con_Comp
					WHERE
							NUM_PROC_HEA=@NUM_PROC AND CD_TP_TX=@CD_tP_TX AND DC_HEA=@DC
							--AND NUM_NF_Hea IS NULL
							and ref_acesso_nf_hea is null
			END
	END

IF LEFT(@NUM_PROC,2)='IO' AND LEN(@NUM_PROC)=16 
	BEGIN
		IF NOT EXISTS(SELECT CD_TP_TX FROM CTA_CTE_HOU_IMP_OUT WHERE NUM_PROC_HIO=@NUM_PROC AND CD_TP_TX=@CD_TP_TX AND DC_HIO=@dc)
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
							@Num_Proc,@Cd_Tp_Tx,@DC,@Org_Ins,@Dt_Ins,@Cd_Tp_Moeda,@Vlr_Org,
							@Dt_Prev_Pgto,@Cd_Cred_Dev,@Desp_Org,@CPMF,	@Comp_RP,@Comp_DN,
							@Comp_CN,@Comp_CPA,@Num_DCN,@Dt_Ctb_CC,@Num_NF,	@Ref_Acesso_NF,
							@Vlr_Pgto_NF,@Par_NF,@Comp_Job,	@Contab,@Vlr_Contab,@Contab_Ant,
							@Vlr_Contab_Ant,@Contab_Mes_Ano,@Val_Con_Comp
						)
			END
		ELSE			BEGIN
				UPDATE
					cta_cte_hou_imp_OUT
						set
							Org_Ins_HIO=@Org_Ins,
							Dt_Ins_HIO=@Dt_Ins,
							Cd_Tp_Moeda=@Cd_Tp_Moeda,
							Vlr_Org_HIO=@Vlr_Org,
							Dt_Prev_Pgto_HIO=@Dt_Prev_Pgto,
							Cd_Cred_Dev_HIO=@Cd_Cred_Dev,
							Desp_Org_HIO=@Desp_Org,
							CPMF_HIO=@CPMF,
							Comp_RP_HIO=@Comp_RP,
							Comp_DN_HIO=@Comp_DN,
							Comp_CN_HIO=@Comp_CN,
							Comp_CPA_HIO=@Comp_CPA,
							Num_DCN_HIO=@Num_DCN,
							Dt_Ctb_CC_HIO=@Dt_Ctb_CC,
							Num_NF_HIO=@Num_NF,
							Ref_Acesso_NF_HIO=@Ref_Acesso_NF,
							Vlr_Pgto_NF_HIO=@Vlr_Pgto_NF,
							Par_NF_HIO=@Par_NF,
							Comp_Job_HIO=@Comp_Job,
							Contab=@Contab,
							Vlr_Contab=@Vlr_Contab,
							Contab_Ant=@Contab_Ant,
							Vlr_Contab_Ant=@Vlr_Contab_Ant,
							Contab_Mes_Ano=@Contab_Mes_Ano,
							Val_Con_Comp=@Val_Con_Comp
					WHERE
							NUM_PROC_HIO=@NUM_PROC AND CD_TP_TX=@CD_tP_TX AND DC_HIO=@DC
							--AND NUM_NF_HIO IS NULL
							and ref_acesso_nf_hio is null
			END
	END

IF LEFT(@NUM_PROC,2)='EO' AND LEN(@NUM_PROC)=16 
	BEGIN
		IF NOT EXISTS(SELECT CD_TP_TX FROM CTA_CTE_HOU_EXP_OUT WHERE NUM_PROC_HEO=@NUM_PROC AND CD_TP_TX=@CD_TP_TX AND DC_HEO=@dc)
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
							@Num_Proc,@Cd_Tp_Tx,@DC,@Org_Ins,@Dt_Ins,@Cd_Tp_Moeda,@Vlr_Org,
							@Dt_Prev_Pgto,@Cd_Cred_Dev,@Desp_Org,@CPMF,	@Comp_RP,@Comp_DN,
							@Comp_CN,@Comp_CPA,@Num_DCN,@Dt_Ctb_CC,@Num_NF,	@Ref_Acesso_NF,
							@Vlr_Pgto_NF,@Par_NF,@Comp_Job,	@Contab,@Vlr_Contab,@Contab_Ant,
							@Vlr_Contab_Ant,@Contab_Mes_Ano,@Val_Con_Comp
						)
			END
		ELSE			BEGIN
				UPDATE
					cta_cte_hou_EXP_OUT
						set
							Org_Ins_HEO=@Org_Ins,
							Dt_Ins_HEO=@Dt_Ins,
							Cd_Tp_Moeda=@Cd_Tp_Moeda,
							Vlr_Org_HEO=@Vlr_Org,
							Dt_Prev_Pgto_HEO=@Dt_Prev_Pgto,
							Cd_Cred_Dev_HEO=@Cd_Cred_Dev,
							Desp_Org_HEO=@Desp_Org,
							CPMF_HEO=@CPMF,
							Comp_RP_HEO=@Comp_RP,
							Comp_DN_HEO=@Comp_DN,
							Comp_CN_HEO=@Comp_CN,
							Comp_CPA_HEO=@Comp_CPA,
							Num_DCN_HEO=@Num_DCN,
							Dt_Ctb_CC_HEO=@Dt_Ctb_CC,
							Num_NF_HEO=@Num_NF,
							Ref_Acesso_NF_HEO=@Ref_Acesso_NF,
							Vlr_Pgto_NF_HEO=@Vlr_Pgto_NF,
							Par_NF_HEO=@Par_NF,
							Comp_Job_HEO=@Comp_Job,
							Contab=@Contab,
							Vlr_Contab=@Vlr_Contab,
							Contab_Ant=@Contab_Ant,
							Vlr_Contab_Ant=@Vlr_Contab_Ant,
							Contab_Mes_Ano=@Contab_Mes_Ano,
							Val_Con_Comp=@Val_Con_Comp
					WHERE
							NUM_PROC_HEO=@NUM_PROC AND CD_TP_TX=@CD_tP_TX AND DC_HEO=@DC
							--AND NUM_NF_HEO IS NULL
							and ref_acesso_nf_heo is null
			END
	END

-----------------------------------------------------------------------------------------------
IF LEFT(@NUM_PROC,2)='IM' AND LEN(@NUM_PROC)=14
		BEGIN
			IF NOT EXISTS(SELECT CD_TP_TX FROM CTA_CTE_MAS_IMP_MAR WHERE NUM_PROC_MIM=@NUM_PROC AND CD_TP_TX=@CD_TP_TX AND DC_MIM=@dc)
				BEGIN
					INSERT INTO
						CTA_CTE_MAS_IMP_MAR
						(
							Num_Proc_MIM,Cd_Tp_Tx,DC_MIM,Org_Ins_MIM,Dt_Ins_MIM,Cd_Tp_Moeda,
							Vlr_Org_MIM,Dt_Prev_Pgto_MIM,Cd_Cred_Dev_MIM,Desp_Org_MIM,CPMF_MIM,
							Comp_RP_MIM,Comp_DN_MIM,Comp_CN_MIM,Comp_CPA_MIM,
							Num_NF_MIM,Ref_Acesso_NF_MIM,Vlr_Pgto_NF_MIM,Par_NF_MIM,Contab,
							Vlr_Contab,Contab_Ant,Vlr_Contab_Ant,Contab_Mes_Ano,Val_Con_Comp
						)
					VALUES
						(
							@NUM_PROC,@Cd_Tp_Tx,@DC,@Org_Ins,@Dt_Ins,@Cd_Tp_Moeda,
							@Vlr_Org,@Dt_Prev_Pgto,@Cd_Cred_Dev,@Desp_Org,@CPMF,	
							@Comp_RP,@Comp_DN,@Comp_CN,@Comp_CPA,@Num_NF,@Ref_Acesso_NF,
							@Vlr_Pgto_NF,@Par_NF,@Contab,@Vlr_Contab,@Contab_Ant,
							@Vlr_Contab_Ant,@Contab_Mes_Ano,@Val_Con_Comp
						)
				END
			ELSE
				BEGIN
					UPDATE
						cta_cte_mas_imp_mar
						set
							Org_Ins_MIM=@Org_Ins,
							Dt_Ins_MIM=@Dt_Ins,
							Cd_Tp_Moeda=@Cd_Tp_Moeda,
							Vlr_Org_MIM=@Vlr_Org,
							Dt_Prev_Pgto_MIM=@Dt_Prev_Pgto,
							Cd_Cred_Dev_MIM=@Cd_Cred_Dev,
							Desp_Org_MIM=@Desp_Org,
							CPMF_MIM=@CPMF,
							Comp_RP_MIM=@Comp_RP,
							Comp_DN_MIM=@Comp_DN,
							Comp_CN_MIM=@Comp_CN,
							Comp_CPA_MIM=@Comp_CPA,
							Num_NF_MIM=@Num_NF,
							Ref_Acesso_NF_MIM=@Ref_Acesso_NF,
							Vlr_Pgto_NF_MIM=@Vlr_Pgto_NF,
							Par_NF_MIM=@Par_NF,
							Contab=@Contab,
							Vlr_Contab=@Vlr_Contab,
							Contab_Ant=@Contab_Ant,
							Vlr_Contab_Ant=@Vlr_Contab_Ant,
							Contab_Mes_Ano=@Contab_Mes_Ano,
							Val_Con_Comp=@Val_Con_Comp
					WHERE
							NUM_PROC_MIM=@NUM_PROC AND CD_TP_TX=@CD_tP_TX AND DC_MIM=@DC
							--AND NUM_NF_MIM IS NULL
							and Ref_Acesso_NF_MIM is null	
			END
		END

IF LEFT(@NUM_PROC,2)='EM' AND LEN(@NUM_PROC)=14
		BEGIN
			IF NOT EXISTS(SELECT CD_TP_TX FROM CTA_CTE_MAS_EXP_MAR WHERE NUM_PROC_MEM=@NUM_PROC AND CD_TP_TX=@CD_TP_TX AND DC_MEM=@dc)
				BEGIN
					INSERT INTO
						CTA_CTE_MAS_EXP_MAR
						(
							Num_Proc_MEM,Cd_Tp_Tx,DC_MEM,Org_Ins_MEM,Dt_Ins_MEM,Cd_Tp_Moeda,
							Vlr_Org_MEM,Dt_Prev_Pgto_MEM,Cd_Cred_Dev_MEM,Desp_Dst_MEM,CPMF_MEM,
							Comp_RP_MEM,Comp_DN_MEM,Comp_CN_MEM,Comp_CPA_MEM,
							Num_NF_MEM,Ref_Acesso_NF_MEM,Vlr_Pgto_NF_MEM,Par_NF_MEM,Contab,
							Vlr_Contab,Contab_Ant,Vlr_Contab_Ant,Contab_Mes_Ano,Val_Con_Comp
						)
					VALUES
						(
							@NUM_PROC,@Cd_Tp_Tx,@DC,@Org_Ins,@Dt_Ins,@Cd_Tp_Moeda,
							@Vlr_Org,@Dt_Prev_Pgto,@Cd_Cred_Dev,@Desp_Org,@CPMF,	
							@Comp_RP,@Comp_DN,@Comp_CN,@Comp_CPA,@Num_NF,@Ref_Acesso_NF,
							@Vlr_Pgto_NF,@Par_NF,@Contab,@Vlr_Contab,@Contab_Ant,
							@Vlr_Contab_Ant,@Contab_Mes_Ano,@Val_Con_Comp
						)
				END
			ELSE
				BEGIN
					UPDATE
						cta_cte_mas_EXP_mar
						set
							Org_Ins_MEM=@Org_Ins,
							Dt_Ins_MEM=@Dt_Ins,
							Cd_Tp_Moeda=@Cd_Tp_Moeda,
							Vlr_Org_MEM=@Vlr_Org,
							Dt_Prev_Pgto_MEM=@Dt_Prev_Pgto,
							Cd_Cred_Dev_MEM=@Cd_Cred_Dev,
							Desp_Dst_MEM=@Desp_Org,
							CPMF_MEM=@CPMF,
							Comp_RP_MEM=@Comp_RP,
							Comp_DN_MEM=@Comp_DN,
							Comp_CN_MEM=@Comp_CN,
							Comp_CPA_MEM=@Comp_CPA,
							Num_NF_MEM=@Num_NF,
							Ref_Acesso_NF_MEM=@Ref_Acesso_NF,
							Vlr_Pgto_NF_MEM=@Vlr_Pgto_NF,
							Par_NF_MEM=@Par_NF,
							Contab=@Contab,
							Vlr_Contab=@Vlr_Contab,
							Contab_Ant=@Contab_Ant,
							Vlr_Contab_Ant=@Vlr_Contab_Ant,
							Contab_Mes_Ano=@Contab_Mes_Ano,
							Val_Con_Comp=@Val_Con_Comp
					WHERE
							NUM_PROC_MEM=@NUM_PROC AND CD_TP_TX=@CD_tP_TX AND DC_MEM=@DC
							--AND NUM_NF_MEM IS NULL
							and Ref_Acesso_NF_MEM is null
				END
		END

IF LEFT(@NUM_PROC,2)='IA' AND LEN(@NUM_PROC)=14
		BEGIN
			IF NOT EXISTS(SELECT CD_TP_TX FROM CTA_CTE_MAS_IMP_AER WHERE NUM_PROC_MIA=@NUM_PROC AND CD_TP_TX=@CD_TP_TX AND DC_MIA=@dc)
				BEGIN
					INSERT INTO
						CTA_CTE_MAS_IMP_AER
						(
							Num_Proc_MIA,Cd_Tp_Tx,DC_MIA,Org_Ins_MIA,Dt_Ins_MIA,Cd_Tp_Moeda,
							Vlr_Org_MIA,Dt_Prev_Pgto_MIA,Cd_Cred_Dev_MIA,Desp_Org_MIA,CPMF_MIA,
							Comp_RP_MIA,Comp_DN_MIA,Comp_CN_MIA,Comp_CPA_MIA,
							Num_NF_MIA,Ref_Acesso_NF_MIA,Vlr_Pgto_NF_MIA,Par_NF_MIA,Contab,
							Vlr_Contab,Contab_Ant,Vlr_Contab_Ant,Contab_Mes_Ano,Val_Con_Comp
						)
					VALUES
						(
							@NUM_PROC,@Cd_Tp_Tx,@DC,@Org_Ins,@Dt_Ins,@Cd_Tp_Moeda,
							@Vlr_Org,@Dt_Prev_Pgto,@Cd_Cred_Dev,@Desp_Org,@CPMF,	
							@Comp_RP,@Comp_DN,@Comp_CN,@Comp_CPA,@Num_NF,@Ref_Acesso_NF,
							@Vlr_Pgto_NF,@Par_NF,@Contab,@Vlr_Contab,@Contab_Ant,
							@Vlr_Contab_Ant,@Contab_Mes_Ano,@Val_Con_Comp
						)
				END
			ELSE
				BEGIN
					UPDATE
						cta_cte_mas_Imp_Aer
						set
							Org_Ins_MIA=@Org_Ins,
							Dt_Ins_MIA=@Dt_Ins,
							Cd_Tp_Moeda=@Cd_Tp_Moeda,
							Vlr_Org_MIA=@Vlr_Org,
							Dt_Prev_Pgto_MIA=@Dt_Prev_Pgto,
							Cd_Cred_Dev_MIA=@Cd_Cred_Dev,
							Desp_Org_MIA=@Desp_Org,
							CPMF_MIA=@CPMF,
							Comp_RP_MIA=@Comp_RP,
							Comp_DN_MIA=@Comp_DN,
							Comp_CN_MIA=@Comp_CN,
							Comp_CPA_MIA=@Comp_CPA,
							Num_NF_MIA=@Num_NF,
							Ref_Acesso_NF_MIA=@Ref_Acesso_NF,
							Vlr_Pgto_NF_MIA=@Vlr_Pgto_NF,
							Par_NF_MIA=@Par_NF,
							Contab=@Contab,
							Vlr_Contab=@Vlr_Contab,
							Contab_Ant=@Contab_Ant,
							Vlr_Contab_Ant=@Vlr_Contab_Ant,
							Contab_Mes_Ano=@Contab_Mes_Ano,
							Val_Con_Comp=@Val_Con_Comp
					WHERE
							NUM_PROC_MIA=@NUM_PROC AND CD_TP_TX=@CD_tP_TX AND DC_MIA=@DC
							--AND NUM_NF_MIA IS NULL
							and Ref_Acesso_NF_MIA is null	
			END
		END

IF LEFT(@NUM_PROC,2)='EA' AND LEN(@NUM_PROC)=14
		BEGIN
			IF NOT EXISTS(SELECT CD_TP_TX FROM CTA_CTE_MAS_EXP_AER WHERE NUM_PROC_MEA=@NUM_PROC AND CD_TP_TX=@CD_TP_TX AND DC_MEA=@dc)
				BEGIN
					INSERT INTO
						CTA_CTE_MAS_EXP_AER
						(
							Num_Proc_MEA,Cd_Tp_Tx,DC_MEA,Org_Ins_MEA,Dt_Ins_MEA,Cd_Tp_Moeda,
							Vlr_Org_MEA,Dt_Prev_Pgto_MEA,Cd_Cred_Dev_MEA,Desp_Dst_MEA,CPMF_MEA,
							Comp_RP_MEA,Comp_DN_MEA,Comp_CN_MEA,Comp_CPA_MEA,
							Num_NF_MEA,Ref_Acesso_NF_MEA,Vlr_Pgto_NF_MEA,Par_NF_MEA,Contab,
							Vlr_Contab,Contab_Ant,Vlr_Contab_Ant,Contab_Mes_Ano,Val_Con_Comp
						)
					VALUES
						(
							@NUM_PROC,@Cd_Tp_Tx,@DC,@Org_Ins,@Dt_Ins,@Cd_Tp_Moeda,
							@Vlr_Org,@Dt_Prev_Pgto,@Cd_Cred_Dev,@Desp_Org,@CPMF,	
							@Comp_RP,@Comp_DN,@Comp_CN,@Comp_CPA,@Num_NF,@Ref_Acesso_NF,
							@Vlr_Pgto_NF,@Par_NF,@Contab,@Vlr_Contab,@Contab_Ant,
							@Vlr_Contab_Ant,@Contab_Mes_Ano,@Val_Con_Comp
						)
				END
			ELSE
				BEGIN
					UPDATE
						cta_cte_mas_EXP_AER
						set
							Org_Ins_MEA=@Org_Ins,
							Dt_Ins_MEA=@Dt_Ins,
							Cd_Tp_Moeda=@Cd_Tp_Moeda,
							Vlr_Org_MEA=@Vlr_Org,
							Dt_Prev_Pgto_MEA=@Dt_Prev_Pgto,
							Cd_Cred_Dev_MEA=@Cd_Cred_Dev,
							Desp_Dst_MEA=@Desp_Org,
							CPMF_MEA=@CPMF,
							Comp_RP_MEA=@Comp_RP,
							Comp_DN_MEA=@Comp_DN,
							Comp_CN_MEA=@Comp_CN,
							Comp_CPA_MEA=@Comp_CPA,
							Num_NF_MEA=@Num_NF,
							Ref_Acesso_NF_MEA=@Ref_Acesso_NF,
							Vlr_Pgto_NF_MEA=@Vlr_Pgto_NF,
							Par_NF_MEA=@Par_NF,
							Contab=@Contab,
							Vlr_Contab=@Vlr_Contab,
							Contab_Ant=@Contab_Ant,
							Vlr_Contab_Ant=@Vlr_Contab_Ant,
							Contab_Mes_Ano=@Contab_Mes_Ano,
							Val_Con_Comp=@Val_Con_Comp
					WHERE
							NUM_PROC_MEA=@NUM_PROC AND CD_TP_TX=@CD_tP_TX AND DC_MEA=@DC
							--AND NUM_NF_MEA IS NULL
							and Ref_Acesso_NF_Mea is null
				END
		END


if @@error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -2
	END

COMMIT TRANSACTION
		








GO
