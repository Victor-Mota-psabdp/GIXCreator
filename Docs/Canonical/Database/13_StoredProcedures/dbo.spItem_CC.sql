SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE   Procedure [dbo].[spItem_CC]
		@Processo	Varchar(16),
		@Cd_Tp_tx	Varchar(3),
		@DC		VarChar(1)

AS

IF LEFT(@PROCESSO,2)='IM' AND LEN(@PROCESSO)=16
	BEGIN
		SELECT 
			cta.cpmf_him CPMF,cta.comp_CPA_him comp_CPA, cta.comp_CN_him comp_CN, cta.comp_rp_him comp_rp, cta.Comp_DN_him Comp_DN, cta.cd_cred_dev_him cd_cred_dev, desp_org_him Desp,  cta.dt_prev_pgto_him dt_prev_pgto, CTA.Vlr_Org_HIM Vlr_Org, CTA.DT_INS_HIM Dt_Ins,cta.cd_tp_moeda,CTA.Num_Proc_Him Processo,CTA.cd_tp_tx, CTA.DC_HIM DC, CXA.NUM_LCTO CXA, CTA.NUM_NF_HIM nf,FATCOD,Val_Con_Comp
		FROM
			CTA_CTE_HOU_IMP_MAR CTA
			LEFT JOIN vwCXAS CXA ON CTA.NUM_PROC_HIM=CXA.NUM_PROC_HIA AND CTA.CD_TP_TX=CXA.CD_TP_TX AND CTA.DC_HIM=CXA.DC_HIA
			LEFT JOIN ITEM_FAT IT ON CTA.NUM_PROC_HIM=NUM_PROC AND CTA.CD_TP_TX=IT.CD_TP_TX  AND CTA.DC_HIM=IT.DC
		WHERE
			CTA.NUM_PROC_HIM=@PROCESSO AND CTA.CD_TP_TX=@CD_TP_TX AND CTA.DC_HIM=@DC
	END
ELSE IF LEFT(@PROCESSO,2)='IM' AND LEN(@PROCESSO)=14
	BEGIN
		SELECT 
			cta.cpmf_mim CPMF,cta.comp_CPA_mim comp_CPA, cta.comp_CN_mim comp_CN, cta.comp_rp_mim comp_rp, cta.Comp_DN_mim Comp_DN, cta.cd_cred_dev_mim cd_cred_dev, desp_org_mim Desp,  cta.dt_prev_pgto_mim dt_prev_pgto, CTA.Vlr_Org_mIM Vlr_Org, CTA.DT_INS_mIM Dt_Ins,cta.cd_tp_moeda,CTA.Num_Proc_mim Processo,CTA.cd_tp_tx, CTA.DC_mIM DC, CXA.NUM_LCTO CXA, CTA.NUM_NF_mIM nf,FATCOD,Val_Con_Comp
		FROM
			CTA_CTE_MAS_IMP_MAR CTA
			LEFT JOIN vwCXAS CXA ON CTA.NUM_PROC_MIM=CXA.NUM_PROC_HIA AND CTA.CD_TP_TX=CXA.CD_TP_TX AND CTA.DC_MIM=CXA.DC_HIA
			LEFT JOIN ITEM_FAT IT ON CTA.NUM_PROC_MIM=NUM_PROC AND CTA.CD_TP_TX=IT.CD_TP_TX  AND CTA.DC_MIM=IT.DC
		WHERE
			CTA.NUM_PROC_MIM=@PROCESSO AND CTA.CD_TP_TX=@CD_TP_TX AND CTA.DC_MIM=@DC
	END

ELSE IF LEFT(@PROCESSO,2)='EM' AND LEN(@PROCESSO)=16
	BEGIN
		SELECT 
			cta.cpmf_hem CPMF,cta.comp_CPA_hem comp_CPA, cta.comp_CN_hem comp_CN, cta.comp_rp_hem comp_rp, cta.Comp_DN_hem Comp_DN, cta.cd_cred_dev_hem cd_cred_dev, desp_DST_hem Desp,  cta.dt_prev_pgto_hem dt_prev_pgto, CTA.Vlr_Org_HeM Vlr_Org, CTA.DT_INS_HeM Dt_Ins,cta.cd_tp_moeda,CTA.Num_Proc_Hem Processo,CTA.cd_tp_tx, CTA.DC_HeM DC, CXA.NUM_LCTO CXA, CTA.NUM_NF_HeM nf,FATCOD,Val_Con_Comp
		FROM
			CTA_CTE_HOU_EXP_MAR CTA
			LEFT JOIN vwCXAS CXA ON CTA.NUM_PROC_HEM=CXA.NUM_PROC_HIA AND CTA.CD_TP_TX=CXA.CD_TP_TX AND CTA.DC_HEM=CXA.DC_HIA
			LEFT JOIN ITEM_FAT IT ON CTA.NUM_PROC_HEM=NUM_PROC AND CTA.CD_TP_TX=IT.CD_TP_TX  AND CTA.DC_HEM=IT.DC
		WHERE
			CTA.NUM_PROC_HEM=@PROCESSO AND CTA.CD_TP_TX=@CD_TP_TX AND CTA.DC_HEM=@DC
	END
ELSE IF LEFT(@PROCESSO,2)='EM' AND LEN(@PROCESSO)=14
	BEGIN
		SELECT 
			cta.cpmf_mem CPMF,cta.comp_CPA_mem comp_CPA, cta.comp_CN_mem comp_CN, cta.comp_rp_mem comp_rp, cta.Comp_DN_mem Comp_DN, cta.cd_cred_dev_mem cd_cred_dev, desp_dst_mem Desp,  cta.dt_prev_pgto_mem dt_prev_pgto, CTA.Vlr_Org_meM Vlr_Org, CTA.DT_INS_meM Dt_Ins,cta.cd_tp_moeda,CTA.Num_Proc_mem Processo,CTA.cd_tp_tx, CTA.DC_meM DC, CXA.NUM_LCTO CXA, CTA.NUM_NF_meM nf,FATCOD,Val_Con_Comp
		FROM
			CTA_CTE_MAS_EXP_MAR CTA
			LEFT JOIN vwCXAS CXA ON CTA.NUM_PROC_MEM=CXA.NUM_PROC_HIA AND CTA.CD_TP_TX=CXA.CD_TP_TX AND CTA.DC_MEM=CXA.DC_HIA
			LEFT JOIN ITEM_FAT IT ON CTA.NUM_PROC_MEM=NUM_PROC AND CTA.CD_TP_TX=IT.CD_TP_TX  AND CTA.DC_MEM=IT.DC
		WHERE
			CTA.NUM_PROC_MEM=@PROCESSO AND CTA.CD_TP_TX=@CD_TP_TX AND CTA.DC_MEM=@DC
	END

IF LEFT(@PROCESSO,2)='IA' AND LEN(@PROCESSO)=16
	BEGIN
		SELECT 
			cta.cpmf_hia CPMF,cta.comp_CPA_hia comp_CPA, cta.comp_CN_hia comp_CN, cta.comp_rp_hia comp_rp, cta.Comp_DN_hia Comp_DN, cta.cd_cred_dev_hia cd_cred_dev, desp_org_hia Desp,  cta.dt_prev_pgto_hia dt_prev_pgto, CTA.Vlr_Org_hia Vlr_Org, CTA.DT_INS_hia Dt_Ins,cta.cd_tp_moeda,CTA.Num_Proc_hia Processo,CTA.cd_tp_tx, CTA.DC_hia DC, CXA.NUM_LCTO CXA, CTA.NUM_NF_hia nf,FATCOD,Val_Con_Comp
		FROM
			CTA_CTE_HOU_IMP_aer CTA
			LEFT JOIN vwCXAS CXA ON CTA.NUM_PROC_hia=CXA.NUM_PROC_hia AND CTA.CD_TP_TX=CXA.CD_TP_TX AND CTA.DC_hia=CXA.DC_hia
			LEFT JOIN ITEM_FAT IT ON CTA.NUM_PROC_hia=NUM_PROC AND CTA.CD_TP_TX=IT.CD_TP_TX  AND CTA.DC_hia=IT.DC
		WHERE
			CTA.NUM_PROC_hia=@PROCESSO AND CTA.CD_TP_TX=@CD_TP_TX AND CTA.DC_hia=@DC
	END
ELSE IF LEFT(@PROCESSO,2)='IA' AND LEN(@PROCESSO)=14
	BEGIN
		SELECT 
			cta.cpmf_mia CPMF,cta.comp_CPA_mia comp_CPA, cta.comp_CN_mia comp_CN, cta.comp_rp_mia comp_rp, cta.Comp_DN_mia Comp_DN, cta.cd_cred_dev_mia cd_cred_dev, desp_org_mia Desp,  cta.dt_prev_pgto_mia dt_prev_pgto, CTA.Vlr_Org_mia Vlr_Org, CTA.DT_INS_mia Dt_Ins,cta.cd_tp_moeda,CTA.Num_Proc_mia Processo,CTA.cd_tp_tx, CTA.DC_mia DC, CXA.NUM_LCTO CXA, CTA.NUM_NF_mia nf,FATCOD,Val_Con_Comp
		FROM
			CTA_CTE_MAS_IMP_aer CTA
			LEFT JOIN vwCXAS CXA ON CTA.NUM_PROC_mia=CXA.NUM_PROC_hia AND CTA.CD_TP_TX=CXA.CD_TP_TX AND CTA.DC_mia=CXA.DC_hia
			LEFT JOIN ITEM_FAT IT ON CTA.NUM_PROC_mia=NUM_PROC AND CTA.CD_TP_TX=IT.CD_TP_TX  AND CTA.DC_mia=IT.DC
		WHERE
			CTA.NUM_PROC_mia=@PROCESSO AND CTA.CD_TP_TX=@CD_TP_TX AND CTA.DC_mia=@DC
	END

ELSE IF LEFT(@PROCESSO,2)='EA' AND LEN(@PROCESSO)=16
	BEGIN
		SELECT 
			cta.cpmf_hea CPMF,cta.comp_CPA_hea comp_CPA, cta.comp_CN_hea comp_CN, cta.comp_rp_hea comp_rp, cta.Comp_DN_hea Comp_DN, cta.cd_cred_dev_hea cd_cred_dev, desp_dst_hea Desp,  cta.dt_prev_pgto_hea dt_prev_pgto, CTA.Vlr_Org_hea Vlr_Org, CTA.DT_INS_hea Dt_Ins,cta.cd_tp_moeda,CTA.Num_Proc_hea Processo,CTA.cd_tp_tx, CTA.DC_hea DC, CXA.NUM_LCTO CXA, CTA.NUM_NF_hea nf,FATCOD,Val_Con_Comp
		FROM
			CTA_CTE_HOU_EXP_aer CTA
			LEFT JOIN vwCXAS CXA ON CTA.NUM_PROC_hea=CXA.NUM_PROC_hia AND CTA.CD_TP_TX=CXA.CD_TP_TX AND CTA.DC_hea=CXA.DC_hia
			LEFT JOIN ITEM_FAT IT ON CTA.NUM_PROC_hea=NUM_PROC AND CTA.CD_TP_TX=IT.CD_TP_TX  AND CTA.DC_hea=IT.DC
		WHERE
			CTA.NUM_PROC_hea=@PROCESSO AND CTA.CD_TP_TX=@CD_TP_TX AND CTA.DC_hea=@DC
	END
ELSE IF LEFT(@PROCESSO,2)='EA' AND LEN(@PROCESSO)=14
	BEGIN
		SELECT 
			cta.cpmf_mea CPMF,cta.comp_CPA_mea comp_CPA, cta.comp_CN_mea comp_CN, cta.comp_rp_mea comp_rp, cta.Comp_DN_mea Comp_DN, cta.cd_cred_dev_mea cd_cred_dev, desp_dst_mea Desp,  cta.dt_prev_pgto_mea dt_prev_pgto, CTA.Vlr_Org_mea Vlr_Org, CTA.DT_INS_mea Dt_Ins,cta.cd_tp_moeda,CTA.Num_Proc_mea Processo,CTA.cd_tp_tx, CTA.DC_mea DC, CXA.NUM_LCTO CXA, CTA.NUM_NF_mea nf,FATCOD,Val_Con_Comp
		FROM
			CTA_CTE_MAS_EXP_aer CTA
			LEFT JOIN vwCXAS CXA ON CTA.NUM_PROC_mea=CXA.NUM_PROC_hia AND CTA.CD_TP_TX=CXA.CD_TP_TX AND CTA.DC_mea=CXA.DC_hia
			LEFT JOIN ITEM_FAT IT ON CTA.NUM_PROC_mea=NUM_PROC AND CTA.CD_TP_TX=IT.CD_TP_TX  AND CTA.DC_mea=IT.DC
		WHERE
			CTA.NUM_PROC_mea=@PROCESSO AND CTA.CD_TP_TX=@CD_TP_TX AND CTA.DC_mea=@DC
	END

ELSE IF LEFT(@PROCESSO,2)='IO' AND LEN(@PROCESSO)=16
	BEGIN
		SELECT 
			cta.cpmf_hio CPMF,cta.comp_CPA_hio comp_CPA, cta.comp_CN_hio comp_CN, cta.comp_rp_hio comp_rp, cta.Comp_DN_hio Comp_DN, cta.cd_cred_dev_hio cd_cred_dev, desp_org_hio Desp,  cta.dt_prev_pgto_hio dt_prev_pgto, CTA.Vlr_Org_hio Vlr_Org, CTA.DT_INS_hio Dt_Ins,cta.cd_tp_moeda,CTA.Num_Proc_hio Processo,CTA.cd_tp_tx, CTA.DC_hio DC, CXA.NUM_LCTO CXA, CTA.NUM_NF_hio nf,FATCOD,Val_Con_Comp
		FROM
			CTA_CTE_HOU_imp_out CTA
			LEFT JOIN vwCXAS CXA ON CTA.NUM_PROC_hio=CXA.NUM_PROC_hia AND CTA.CD_TP_TX=CXA.CD_TP_TX AND CTA.DC_hio=CXA.DC_hia
			LEFT JOIN ITEM_FAT IT ON CTA.NUM_PROC_hio=NUM_PROC AND CTA.CD_TP_TX=IT.CD_TP_TX  AND CTA.DC_hio=IT.DC
		WHERE
			CTA.NUM_PROC_hio=@PROCESSO AND CTA.CD_TP_TX=@CD_TP_TX AND CTA.DC_hio=@DC
	END

ELSE IF LEFT(@PROCESSO,2)='EO' AND LEN(@PROCESSO)=16
	BEGIN
		SELECT 
			cta.cpmf_heo CPMF,cta.comp_CPA_heo comp_CPA, cta.comp_CN_heo comp_CN, cta.comp_rp_heo comp_rp, cta.Comp_DN_heo Comp_DN, cta.cd_cred_dev_heo cd_cred_dev, desp_org_heo Desp,  cta.dt_prev_pgto_heo dt_prev_pgto, CTA.Vlr_Org_heo Vlr_Org, CTA.DT_INS_heo Dt_Ins,cta.cd_tp_moeda,CTA.Num_Proc_heo Processo,CTA.cd_tp_tx, CTA.DC_heo DC, CXA.NUM_LCTO CXA, CTA.NUM_NF_heo nf,FATCOD,Val_Con_Comp
		FROM
			CTA_CTE_HOU_exp_out CTA
			LEFT JOIN vwCXAS CXA ON CTA.NUM_PROC_heo=CXA.NUM_PROC_hia AND CTA.CD_TP_TX=CXA.CD_TP_TX AND CTA.DC_heo=CXA.DC_hia
			LEFT JOIN ITEM_FAT IT ON CTA.NUM_PROC_heo=NUM_PROC AND CTA.CD_TP_TX=IT.CD_TP_TX  AND CTA.DC_heo=IT.DC
		WHERE
			CTA.NUM_PROC_heo=@PROCESSO AND CTA.CD_TP_TX=@CD_TP_TX AND CTA.DC_heo=@DC
	END
/*
IF LEFT(@PROCESSO,2)='IM' AND LEN(@PROCESSO)=16
	BEGIN
		SELECT 
			cta.cpmf_him CPMF,cta.comp_CPA_him comp_CPA, cta.comp_CN_him comp_CN, cta.comp_rp_him comp_rp, cta.Comp_DN_him Comp_DN, cta.cd_cred_dev_him cd_cred_dev, desp_org_him Desp,  cta.dt_prev_pgto_him dt_prev_pgto, CTA.Vlr_Org_HIM Vlr_Org, CTA.DT_INS_HIM Dt_Ins,cta.cd_tp_moeda,CTA.Num_Proc_Him Processo,CTA.cd_tp_tx, CTA.DC_HIM DC, CXA.NUM_LCTO CXA, CTA.NUM_NF_HIM nf,FATCOD,Val_Con_Comp
		FROM
			CTA_CTE_HOU_IMP_MAR CTA
			LEFT JOIN CAIXA_HOU_IMP_MAR CXA ON CTA.NUM_PROC_HIM=CXA.NUM_PROC_HIM AND CTA.CD_TP_TX=CXA.CD_TP_TX AND CTA.DC_HIM=CXA.DC_HIM
			LEFT JOIN ITEM_FAT IT ON CTA.NUM_PROC_HIM=NUM_PROC AND CTA.CD_TP_TX=IT.CD_TP_TX  AND CTA.DC_HIM=IT.DC
		WHERE
			CTA.NUM_PROC_HIM=@PROCESSO AND CTA.CD_TP_TX=@CD_TP_TX AND CTA.DC_HIM=@DC
	END
ELSE IF LEFT(@PROCESSO,2)='IM' AND LEN(@PROCESSO)=14
	BEGIN
		SELECT 
			cta.cpmf_mim CPMF,cta.comp_CPA_mim comp_CPA, cta.comp_CN_mim comp_CN, cta.comp_rp_mim comp_rp, cta.Comp_DN_mim Comp_DN, cta.cd_cred_dev_mim cd_cred_dev, desp_org_mim Desp,  cta.dt_prev_pgto_mim dt_prev_pgto, CTA.Vlr_Org_mIM Vlr_Org, CTA.DT_INS_mIM Dt_Ins,cta.cd_tp_moeda,CTA.Num_Proc_mim Processo,CTA.cd_tp_tx, CTA.DC_mIM DC, CXA.NUM_LCTO CXA, CTA.NUM_NF_mIM nf,FATCOD,Val_Con_Comp
		FROM
			CTA_CTE_MAS_IMP_MAR CTA
			LEFT JOIN CAIXA_MAS_IMP_MAR CXA ON CTA.NUM_PROC_MIM=CXA.NUM_PROC_MIM AND CTA.CD_TP_TX=CXA.CD_TP_TX AND CTA.DC_MIM=CXA.DC_MIM
			LEFT JOIN ITEM_FAT IT ON CTA.NUM_PROC_MIM=NUM_PROC AND CTA.CD_TP_TX=IT.CD_TP_TX  AND CTA.DC_MIM=IT.DC
		WHERE
			CTA.NUM_PROC_MIM=@PROCESSO AND CTA.CD_TP_TX=@CD_TP_TX AND CTA.DC_MIM=@DC
	END

ELSE IF LEFT(@PROCESSO,2)='EM' AND LEN(@PROCESSO)=16
	BEGIN
		SELECT 
			cta.cpmf_hem CPMF,cta.comp_CPA_hem comp_CPA, cta.comp_CN_hem comp_CN, cta.comp_rp_hem comp_rp, cta.Comp_DN_hem Comp_DN, cta.cd_cred_dev_hem cd_cred_dev, desp_DST_hem Desp,  cta.dt_prev_pgto_hem dt_prev_pgto, CTA.Vlr_Org_HeM Vlr_Org, CTA.DT_INS_HeM Dt_Ins,cta.cd_tp_moeda,CTA.Num_Proc_Hem Processo,CTA.cd_tp_tx, CTA.DC_HeM DC, CXA.NUM_LCTO CXA, CTA.NUM_NF_HeM nf,FATCOD,Val_Con_Comp
		FROM
			CTA_CTE_HOU_EXP_MAR CTA
			LEFT JOIN CAIXA_HOU_EXP_MAR CXA ON CTA.NUM_PROC_HEM=CXA.NUM_PROC_HEM AND CTA.CD_TP_TX=CXA.CD_TP_TX AND CTA.DC_HEM=CXA.DC_HEM
			LEFT JOIN ITEM_FAT IT ON CTA.NUM_PROC_HEM=NUM_PROC AND CTA.CD_TP_TX=IT.CD_TP_TX  AND CTA.DC_HEM=IT.DC
		WHERE
			CTA.NUM_PROC_HEM=@PROCESSO AND CTA.CD_TP_TX=@CD_TP_TX AND CTA.DC_HEM=@DC
	END
ELSE IF LEFT(@PROCESSO,2)='EM' AND LEN(@PROCESSO)=14
	BEGIN
		SELECT 
			cta.cpmf_mem CPMF,cta.comp_CPA_mem comp_CPA, cta.comp_CN_mem comp_CN, cta.comp_rp_mem comp_rp, cta.Comp_DN_mem Comp_DN, cta.cd_cred_dev_mem cd_cred_dev, desp_dst_mem Desp,  cta.dt_prev_pgto_mem dt_prev_pgto, CTA.Vlr_Org_meM Vlr_Org, CTA.DT_INS_meM Dt_Ins,cta.cd_tp_moeda,CTA.Num_Proc_mem Processo,CTA.cd_tp_tx, CTA.DC_meM DC, CXA.NUM_LCTO CXA, CTA.NUM_NF_meM nf,FATCOD,Val_Con_Comp
		FROM
			CTA_CTE_MAS_EXP_MAR CTA
			LEFT JOIN CAIXA_MAS_EXP_MAR CXA ON CTA.NUM_PROC_MEM=CXA.NUM_PROC_MEM AND CTA.CD_TP_TX=CXA.CD_TP_TX AND CTA.DC_MEM=CXA.DC_MEM
			LEFT JOIN ITEM_FAT IT ON CTA.NUM_PROC_MEM=NUM_PROC AND CTA.CD_TP_TX=IT.CD_TP_TX  AND CTA.DC_MEM=IT.DC
		WHERE
			CTA.NUM_PROC_MEM=@PROCESSO AND CTA.CD_TP_TX=@CD_TP_TX AND CTA.DC_MEM=@DC
	END

IF LEFT(@PROCESSO,2)='IA' AND LEN(@PROCESSO)=16
	BEGIN
		SELECT 
			cta.cpmf_hia CPMF,cta.comp_CPA_hia comp_CPA, cta.comp_CN_hia comp_CN, cta.comp_rp_hia comp_rp, cta.Comp_DN_hia Comp_DN, cta.cd_cred_dev_hia cd_cred_dev, desp_org_hia Desp,  cta.dt_prev_pgto_hia dt_prev_pgto, CTA.Vlr_Org_hia Vlr_Org, CTA.DT_INS_hia Dt_Ins,cta.cd_tp_moeda,CTA.Num_Proc_hia Processo,CTA.cd_tp_tx, CTA.DC_hia DC, CXA.NUM_LCTO CXA, CTA.NUM_NF_hia nf,FATCOD,Val_Con_Comp
		FROM
			CTA_CTE_HOU_IMP_aer CTA
			LEFT JOIN CAIXA_HOU_IMP_aer CXA ON CTA.NUM_PROC_hia=CXA.NUM_PROC_hia AND CTA.CD_TP_TX=CXA.CD_TP_TX AND CTA.DC_hia=CXA.DC_hia
			LEFT JOIN ITEM_FAT IT ON CTA.NUM_PROC_hia=NUM_PROC AND CTA.CD_TP_TX=IT.CD_TP_TX  AND CTA.DC_hia=IT.DC
		WHERE
			CTA.NUM_PROC_hia=@PROCESSO AND CTA.CD_TP_TX=@CD_TP_TX AND CTA.DC_hia=@DC
	END
ELSE IF LEFT(@PROCESSO,2)='IA' AND LEN(@PROCESSO)=14
	BEGIN
		SELECT 
			cta.cpmf_mia CPMF,cta.comp_CPA_mia comp_CPA, cta.comp_CN_mia comp_CN, cta.comp_rp_mia comp_rp, cta.Comp_DN_mia Comp_DN, cta.cd_cred_dev_mia cd_cred_dev, desp_org_mia Desp,  cta.dt_prev_pgto_mia dt_prev_pgto, CTA.Vlr_Org_mia Vlr_Org, CTA.DT_INS_mia Dt_Ins,cta.cd_tp_moeda,CTA.Num_Proc_mia Processo,CTA.cd_tp_tx, CTA.DC_mia DC, CXA.NUM_LCTO CXA, CTA.NUM_NF_mia nf,FATCOD,Val_Con_Comp
		FROM
			CTA_CTE_MAS_IMP_aer CTA
			LEFT JOIN CAIXA_MAS_IMP_aer CXA ON CTA.NUM_PROC_mia=CXA.NUM_PROC_mia AND CTA.CD_TP_TX=CXA.CD_TP_TX AND CTA.DC_mia=CXA.DC_mia
			LEFT JOIN ITEM_FAT IT ON CTA.NUM_PROC_mia=NUM_PROC AND CTA.CD_TP_TX=IT.CD_TP_TX  AND CTA.DC_mia=IT.DC
		WHERE
			CTA.NUM_PROC_mia=@PROCESSO AND CTA.CD_TP_TX=@CD_TP_TX AND CTA.DC_mia=@DC
	END

ELSE IF LEFT(@PROCESSO,2)='EA' AND LEN(@PROCESSO)=16
	BEGIN
		SELECT 
			cta.cpmf_hea CPMF,cta.comp_CPA_hea comp_CPA, cta.comp_CN_hea comp_CN, cta.comp_rp_hea comp_rp, cta.Comp_DN_hea Comp_DN, cta.cd_cred_dev_hea cd_cred_dev, desp_dst_hea Desp,  cta.dt_prev_pgto_hea dt_prev_pgto, CTA.Vlr_Org_hea Vlr_Org, CTA.DT_INS_hea Dt_Ins,cta.cd_tp_moeda,CTA.Num_Proc_hea Processo,CTA.cd_tp_tx, CTA.DC_hea DC, CXA.NUM_LCTO CXA, CTA.NUM_NF_hea nf,FATCOD,Val_Con_Comp
		FROM
			CTA_CTE_HOU_EXP_aer CTA
			LEFT JOIN CAIXA_HOU_EXP_aer CXA ON CTA.NUM_PROC_hea=CXA.NUM_PROC_hea AND CTA.CD_TP_TX=CXA.CD_TP_TX AND CTA.DC_hea=CXA.DC_hea
			LEFT JOIN ITEM_FAT IT ON CTA.NUM_PROC_hea=NUM_PROC AND CTA.CD_TP_TX=IT.CD_TP_TX  AND CTA.DC_hea=IT.DC
		WHERE
			CTA.NUM_PROC_hea=@PROCESSO AND CTA.CD_TP_TX=@CD_TP_TX AND CTA.DC_hea=@DC
	END
ELSE IF LEFT(@PROCESSO,2)='EA' AND LEN(@PROCESSO)=14
	BEGIN
		SELECT 
			cta.cpmf_mea CPMF,cta.comp_CPA_mea comp_CPA, cta.comp_CN_mea comp_CN, cta.comp_rp_mea comp_rp, cta.Comp_DN_mea Comp_DN, cta.cd_cred_dev_mea cd_cred_dev, desp_dst_mea Desp,  cta.dt_prev_pgto_mea dt_prev_pgto, CTA.Vlr_Org_mea Vlr_Org, CTA.DT_INS_mea Dt_Ins,cta.cd_tp_moeda,CTA.Num_Proc_mea Processo,CTA.cd_tp_tx, CTA.DC_mea DC, CXA.NUM_LCTO CXA, CTA.NUM_NF_mea nf,FATCOD,Val_Con_Comp
		FROM
			CTA_CTE_MAS_EXP_aer CTA
			LEFT JOIN CAIXA_MAS_EXP_aer CXA ON CTA.NUM_PROC_mea=CXA.NUM_PROC_mea AND CTA.CD_TP_TX=CXA.CD_TP_TX AND CTA.DC_mea=CXA.DC_mea
			LEFT JOIN ITEM_FAT IT ON CTA.NUM_PROC_mea=NUM_PROC AND CTA.CD_TP_TX=IT.CD_TP_TX  AND CTA.DC_mea=IT.DC
		WHERE
			CTA.NUM_PROC_mea=@PROCESSO AND CTA.CD_TP_TX=@CD_TP_TX AND CTA.DC_mea=@DC
	END

ELSE IF LEFT(@PROCESSO,2)='IO' AND LEN(@PROCESSO)=16
	BEGIN
		SELECT 
			cta.cpmf_hio CPMF,cta.comp_CPA_hio comp_CPA, cta.comp_CN_hio comp_CN, cta.comp_rp_hio comp_rp, cta.Comp_DN_hio Comp_DN, cta.cd_cred_dev_hio cd_cred_dev, desp_org_hio Desp,  cta.dt_prev_pgto_hio dt_prev_pgto, CTA.Vlr_Org_hio Vlr_Org, CTA.DT_INS_hio Dt_Ins,cta.cd_tp_moeda,CTA.Num_Proc_hio Processo,CTA.cd_tp_tx, CTA.DC_hio DC, CXA.NUM_LCTO CXA, CTA.NUM_NF_hio nf,FATCOD,Val_Con_Comp
		FROM
			CTA_CTE_HOU_imp_out CTA
			LEFT JOIN CAIXA_HOU_imp_out CXA ON CTA.NUM_PROC_hio=CXA.NUM_PROC_hio AND CTA.CD_TP_TX=CXA.CD_TP_TX AND CTA.DC_hio=CXA.DC_hio
			LEFT JOIN ITEM_FAT IT ON CTA.NUM_PROC_hio=NUM_PROC AND CTA.CD_TP_TX=IT.CD_TP_TX  AND CTA.DC_hio=IT.DC
		WHERE
			CTA.NUM_PROC_hio=@PROCESSO AND CTA.CD_TP_TX=@CD_TP_TX AND CTA.DC_hio=@DC
	END

ELSE IF LEFT(@PROCESSO,2)='EO' AND LEN(@PROCESSO)=16
	BEGIN
		SELECT 
			cta.cpmf_heo CPMF,cta.comp_CPA_heo comp_CPA, cta.comp_CN_heo comp_CN, cta.comp_rp_heo comp_rp, cta.Comp_DN_heo Comp_DN, cta.cd_cred_dev_heo cd_cred_dev, desp_org_heo Desp,  cta.dt_prev_pgto_heo dt_prev_pgto, CTA.Vlr_Org_heo Vlr_Org, CTA.DT_INS_heo Dt_Ins,cta.cd_tp_moeda,CTA.Num_Proc_heo Processo,CTA.cd_tp_tx, CTA.DC_heo DC, CXA.NUM_LCTO CXA, CTA.NUM_NF_heo nf,FATCOD,Val_Con_Comp
		FROM
			CTA_CTE_HOU_exp_out CTA
			LEFT JOIN CAIXA_HOU_exp_out CXA ON CTA.NUM_PROC_heo=CXA.NUM_PROC_heo AND CTA.CD_TP_TX=CXA.CD_TP_TX AND CTA.DC_heo=CXA.DC_heo
			LEFT JOIN ITEM_FAT IT ON CTA.NUM_PROC_heo=NUM_PROC AND CTA.CD_TP_TX=IT.CD_TP_TX  AND CTA.DC_heo=IT.DC
		WHERE
			CTA.NUM_PROC_heo=@PROCESSO AND CTA.CD_TP_TX=@CD_TP_TX AND CTA.DC_heo=@DC
	END

*/
	

	






GO
