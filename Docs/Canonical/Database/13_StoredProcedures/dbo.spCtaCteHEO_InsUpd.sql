SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE       Procedure [dbo].[spCtaCteHEO_InsUpd]
		@Num_Proc	Varchar(16),
		@Tp_Tx		Varchar(50),
		@DC		Char(1),
		@Org_Ins	VarChar(9),
		@Dt_Ins		Char(10),
		@Tp_Moeda	Varchar(50),
		@Vlr_Org	Decimal(10,2),
		@Dt_Prev_Pgto	VarChar(10),
		@Cred_Dev	VarChar(20),
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

AS


BEGIN TRANSACTION

		Declare @Cd_Tp_Tx	Varchar(3)
		Declare @Cd_Tp_Moeda	Varchar(3)
		Declare @Cd_Cred_Dev	Varchar(10) 

		Set @Cd_Tp_Tx = (Select Cd_Tp_Tx from Tipo_Taxa with (nolock) where Nome_Tp_Tx = @Tp_Tx)
		Set @Cd_Tp_Moeda = (Select Cd_Tp_Moeda from Tipo_Moeda with (nolock) where  Nome_Tp_Moeda = @Tp_Moeda)
		Set @Cd_Cred_Dev = (Select Cd_Pes from Pessoa with (nolock) where Apelido = @Cred_Dev)

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
			ELSE
				BEGIN
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
							and Num_NF_HEO is NULL
				   END
		if @@error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -2
			END

		END			

COMMIT TRANSACTION











GO
