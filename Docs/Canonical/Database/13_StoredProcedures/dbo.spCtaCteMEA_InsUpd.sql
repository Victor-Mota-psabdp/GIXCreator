SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spCtaCteMEA_InsUpd]
	@Master			Varchar(14),
	@Tp_Tx			Varchar(50),
	@DC				Char(1),
	@Org_Ins		VarChar(9),
	@Dt_Ins			Char(10),
	@Tp_Moeda		Varchar(50),
	@Vlr_Org		Decimal(10,2),
	@Dt_Prev_Pgto	VarChar(10),
	@Cred_Dev		VarChar(20),
	@Desp_Dst		Char(1),
	@CPMF			Char(1),
	@Comp_RP		Char(1),
	@Comp_DN		Char(1),
	@Comp_CN		Char(1),
	@Comp_CPA		Char(1),
	@Num_NF			Varchar(12),
	@Ref_Acesso_NF	Varchar(1),
	@Vlr_Pgto_NF	Decimal(10,2),
	@Par_NF			float,
	@Comp_MBL_MEA	Char(1),
	@Contab			bit,
	@Vlr_Contab		Decimal(10,2),
	@Contab_Ant		bit,
	@Vlr_Contab_Ant Decimal(10,2),
	@Contab_Mes_Ano	Varchar(7),
	@Val_Con_Comp	Decimal(10,2),

	@Tp_Oper_CC		char(1),
	@Nome_Usuario	varchar	(50)
AS

--BEGIN TRANSACTION

	Declare @Cd_Tp_Tx	Varchar(3)
	Declare @Cd_Tp_Moeda	Varchar(3)
	Declare @Cd_Cred_Dev	Varchar(10) 
	Declare @cd_usuario		Varchar(6)		

	Set @cd_usuario = (Select Cd_usuario from Usuario where Nome_usuario = @Nome_Usuario)

	Set @Cd_Tp_Tx = (Select Cd_Tp_Tx from Tipo_Taxa where Nome_Tp_Tx = @Tp_Tx)		
	Set @Cd_Tp_Moeda = (Select Cd_Tp_Moeda from Tipo_Moeda where  Nome_Tp_Moeda = @Tp_Moeda)
	Set @Cd_Cred_Dev = (Select Cd_Pes from Pessoa where Apelido = @Cred_Dev)

		--Erbson 05-12-2013: Sempre utilizar a data atual para insert ou update.
		Set @Dt_Ins = (select convert(varchar,getdate(),103))

		--Erbson 08-01-2014: Não GRAVA CASO JÁ TENHA AX_DOC	
		IF EXISTS(select id_AX from vwAXDocs where NumeroInternoAX = @Master and cd_tp_tx_atl = @Cd_Tp_Tx and DC = @DC)
			BEGIN
				RETURN -2
			END

		--Erbson 23-01-2014: Não grava caso a moeda esteja desativada
		IF (select ativo from tipo_moeda where cd_Tp_Moeda = @Cd_Tp_Moeda) <> 1
			Begin
				RETURN -2
			End	

		IF NOT EXISTS(SELECT CD_TP_TX FROM CTA_CTE_MAS_EXP_AER WHERE NUM_PROC_MEA=@Master AND CD_TP_TX=@CD_TP_TX AND DC_MEA=@dc)
			BEGIN
			  INSERT INTO
				CTA_CTE_MAS_EXP_AER
					(
						Num_Proc_MEA,Cd_Tp_Tx,DC_MEA,Org_Ins_MEA,Dt_Ins_MEA,Cd_Tp_Moeda,
						Vlr_Org_MEA,Dt_Prev_Pgto_MEA,Cd_Cred_Dev_MEA,Desp_Dst_MEA,CPMF_MEA,
						Comp_RP_MEA,Comp_DN_MEA,Comp_CN_MEA,Comp_CPA_MEA,
						Num_NF_MEA,Ref_Acesso_NF_MEA,Vlr_Pgto_NF_MEA,Par_NF_MEA,Comp_MBL_MEA,Contab,
						Vlr_Contab,Contab_Ant,Vlr_Contab_Ant,Contab_Mes_Ano,Val_Con_Comp
					)
				VALUES
					(
						@Master,@Cd_Tp_Tx,@DC,@Org_Ins,@Dt_Ins,@Cd_Tp_Moeda,
						@Vlr_Org,@Dt_Prev_Pgto,@Cd_Cred_Dev,@Desp_Dst,@CPMF,	
						@Comp_RP,@Comp_DN,@Comp_CN,@Comp_CPA,
						@Num_NF,@Ref_Acesso_NF,@Vlr_Pgto_NF,@Par_NF,@Comp_MBL_MEA,@Contab,
						@Vlr_Contab,@Contab_Ant,@Vlr_Contab_Ant,@Contab_Mes_Ano,@Val_Con_Comp
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
						Desp_Dst_MEA=@Desp_Dst,
						CPMF_MEA=@CPMF,
						Comp_RP_MEA=@Comp_RP,
						Comp_DN_MEA=@Comp_DN,
						Comp_CN_MEA=@Comp_CN,
						Comp_CPA_MEA=@Comp_CPA,
						Num_NF_MEA=@Num_NF,
						Ref_Acesso_NF_MEA=@Ref_Acesso_NF,
						Vlr_Pgto_NF_MEA=@Vlr_Pgto_NF,
						Par_NF_MEA=@Par_NF,
						Comp_MBL_MEA=@Comp_MBL_MEA,
						Contab=@Contab,
						Vlr_Contab=@Vlr_Contab,
						Contab_Ant=@Contab_Ant,
						Vlr_Contab_Ant=@Vlr_Contab_Ant,
						Contab_Mes_Ano=@Contab_Mes_Ano,
						Val_Con_Comp=@Val_Con_Comp
				WHERE
						NUM_PROC_MEA=@Master AND CD_TP_TX=@CD_tP_TX AND DC_MEA=@DC
						and Num_NF_MEA is NULL
			   END
			
	Begin
		Insert into Log_Cta_Cte
					(
						Data_CC,Cd_Usuario,Tp_Oper_CC,Num_Proc_CC,Cd_Tp_Tx,DC_CC,Org_Ins,
						Dt_Ins,Cd_Tp_Moeda,Vlr_Org,Dt_Prev_Pgto,Cd_Cred_Dev,Desp_Org_Dst,
						CPMF,Comp_RP,Comp_DN,Comp_CN,Comp_CPA,Contab,Vlr_Contab,Contab_Ant,
						Cointab_Mes_Ano
					)
			Values
					(
						getDate(),@Cd_Usuario,@Tp_Oper_CC,@Master,@Cd_Tp_Tx,@DC,@Org_Ins,
						@Dt_Ins,@Cd_Tp_Moeda,@Vlr_Org,@Dt_Prev_Pgto,@Cd_Cred_Dev,@Desp_Dst,
						@CPMF,@Comp_RP,@Comp_DN,@Comp_CN,@Comp_CPA,@Contab,@Vlr_Contab,@Contab_Ant,
						@Contab_Mes_Ano
					)		
	End


--if @@error <> 0
--	BEGIN
--		ROLLBACK TRANSACTION
--		RETURN -2
--	END			

--COMMIT TRANSACTION

GO
