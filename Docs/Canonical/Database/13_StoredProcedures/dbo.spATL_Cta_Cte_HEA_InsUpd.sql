SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_Cta_Cte_HEA_InsUpd]
(
		@Num_Proc	Varchar(16),
		@Cd_Tp_Tx  Varchar(3),
		@DC		Char(1),
		@Org_Ins	VarChar(9),
		@Dt_Ins		Char(10),
		@Cd_Tp_Moeda Varchar(3),
		@Vlr_Org	Decimal(10,2),
		@Dt_Prev_Pgto	VarChar(10),
		@Cd_Cred_Dev Varchar(10),
		@Desp_Org	Char(1),
		@CPMF		Char(1),
		@Comp_RP	Char(1),
		@Comp_DN	Char(1),
		@Comp_CN	Char(1),
		@Comp_CPA	Char(1),
		@Num_DCN	VarChar(9),
		@Dt_Ctb_CC	VarChar(10),
		@Num_NF		Varchar(12),
		@Ref_Acesso_NF	Varchar(1),
		@Vlr_Pgto_NF	Decimal(10,2),
		@Par_NF		float,
		@Comp_Job	Char(1),
		@Contab		bit,
		@Vlr_Contab	Decimal(10,2),
		@Contab_Ant	bit,
		@Vlr_Contab_Ant Decimal(10,2),
		@Contab_Mes_Ano	Varchar(7),
		@Val_Con_Comp	Decimal(10,2)
)
AS

BEGIN TRANSACTION

		--Erbson 05-12-2013: Sempre utilizar a data atual para insert ou update.
		Set @Dt_Ins = (select convert(varchar,getdate(),103))
		
		--Erbson 08-01-2014: Não GRAVA CASO JÁ TENHA AX_DOC	
		IF EXISTS(select id_AX from vwAXDocs where num_proc = @Num_Proc and cd_tp_tx_atl = @Cd_Tp_Tx and DC = @DC)
			BEGIN
				RETURN -2
			END
		
		--Cadu 11-01-2018: Não GRAVA CASO JÁ TENHA Fatura Item Fat	
		IF EXISTS(select FatCod from vwFaturasValidas where num_proc = @Num_Proc and cd_tp_tx = @Cd_Tp_Tx and DC = @DC)
			BEGIN
				RETURN -2
			END
			
		--Erbson 23-01-2014: Não grava caso a moeda esteja desativada
		IF (select ativo from tipo_moeda with (nolock) where cd_Tp_Moeda = @Cd_Tp_Moeda) <> 1
			Begin
				RETURN -2
			End	
		
	IF LEFT(@NUM_PROC,2)='EA' AND LEN(@NUM_PROC)=16 
		BEGIN
			IF NOT EXISTS(SELECT CD_TP_TX FROM CTA_CTE_HOU_exp_AER WHERE NUM_PROC_HEA=@NUM_PROC AND CD_TP_TX=@CD_TP_TX AND DC_HEA=@dc)
				BEGIN
				  INSERT INTO
					CTA_CTE_HOU_Exp_AER
						(
							Num_Proc_HEA,
							Cd_Tp_Tx,
							DC_HEA,
							Org_Ins_HEA,
							Dt_Ins_HEA,
							Cd_Tp_Moeda,
							Vlr_Org_HEA,
							Dt_Prev_Pgto_HEA,
							Cd_Cred_Dev_HEA,
							Desp_dst_HEA,
							CPMF_HEA,
							Comp_RP_HEA,
							Comp_DN_HEA,
							Comp_CN_HEA,
							Comp_CPA_HEA,
							Num_DCN_HEA,
							Dt_Ctb_CC_HEA,
							Num_NF_HEA,
							Ref_Acesso_NF_HEA,
							Vlr_Pgto_NF_HEA,
							Par_NF_HEA,
							Comp_Job_HEA,
							Contab,
							Vlr_Contab,
							Contab_Ant,
							Vlr_Contab_Ant,
							Contab_Mes_Ano,
							Val_Con_Comp
						)
					VALUES
						(
							@Num_Proc,
							@Cd_Tp_Tx,
							@DC,
							@Org_Ins,
							@Dt_Ins,
							@Cd_Tp_Moeda,
							@Vlr_Org,
							@Dt_Prev_Pgto,
							@Cd_Cred_Dev,
							@Desp_Org,
							@CPMF,	
							@Comp_RP,
							@Comp_DN,
							@Comp_CN,
							@Comp_CPA,
							@Num_DCN,
							@Dt_Ctb_CC,
							@Num_NF,
							@Ref_Acesso_NF,
							@Vlr_Pgto_NF,
							@Par_NF,
							@Comp_Job,
							@Contab,
							@Vlr_Contab,
							@Contab_Ant,
							@Vlr_Contab_Ant,
							@Contab_Mes_Ano,
							@Val_Con_Comp
				)
				END
			ELSE
				BEGIN
				   UPDATE
					cta_cte_hou_exp_AER
						set
							Org_Ins_HEA=@Org_Ins,
							Dt_Ins_HEA=@Dt_Ins,
							Cd_Tp_Moeda=@Cd_Tp_Moeda,
							Vlr_Org_HEA=@Vlr_Org,
							Dt_Prev_Pgto_HEA=@Dt_Prev_Pgto,
							Cd_Cred_Dev_HEA=@Cd_Cred_Dev,
							Desp_dst_HEA=@Desp_Org,
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
							and Num_NF_HEA is NULL

				   END
		if @@error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -2
			END

		END			

COMMIT TRANSACTION







GO
