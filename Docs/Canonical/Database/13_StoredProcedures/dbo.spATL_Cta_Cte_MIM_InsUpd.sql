SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_Cta_Cte_MIM_InsUpd]
(
		@Num_Proc_Master		Varchar(14),
		@Cd_Tp_Tx	Varchar(3),
		@DC			Char(1),
		@Org_Ins	VarChar(9),
		@Dt_Ins		Char(10),
		@Cd_Tp_Moeda Varchar(3),
		@Vlr_Org		Decimal(10,2),
		@Dt_Prev_Pgto	VarChar(10),
		@Cd_Cred_Dev	Varchar(10),
		@Desp_Org	Char(1),
		@CPMF		Char(1),
		@Comp_RP	Char(1),
		@Comp_DN	Char(1),
		@Comp_CN	Char(1),
		@Comp_CPA	Char(1),		
		@Num_NF		Varchar(12),
		@Ref_Acesso_NF	Varchar(1),
		@Vlr_Pgto_NF	Decimal(10,2),
		@Par_NF		float,
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
		IF EXISTS(select id_AX from vwAXDocs where NumeroInternoAX = @Num_Proc_Master and cd_tp_tx_atl = @Cd_Tp_Tx and DC = @DC)
			BEGIN
				RETURN -2
			END		
			
		--Erbson 23-01-2014: Não grava caso a moeda esteja desativada
		IF (select ativo from tipo_moeda with (nolock) where cd_Tp_Moeda = @Cd_Tp_Moeda) <> 1
			Begin
				RETURN -2
			End	
		
	IF LEFT(@Num_Proc_Master,2)='IM' AND LEN(@Num_Proc_Master)=14 
		BEGIN
			IF NOT EXISTS(SELECT CD_TP_TX FROM Cta_Cte_Mas_Imp_Mar WHERE NUM_PROC_MIM=@Num_Proc_Master AND CD_TP_TX=@CD_TP_TX AND DC_MIM=@dc)
				BEGIN
				  INSERT INTO
					Cta_Cte_Mas_Imp_Mar
						(
							Num_Proc_MIM,Cd_Tp_Tx,DC_MIM,Org_Ins_MIM,Dt_Ins_MIM,Cd_Tp_Moeda,Vlr_Org_MIM,Dt_Prev_Pgto_MIM,Cd_Cred_Dev_MIM,Desp_Org_MIM,CPMF_MIM,
							Comp_RP_MIM,Comp_DN_MIM,Comp_CN_MIM,Comp_CPA_MIM,Num_NF_MIM,Ref_Acesso_NF_MIM,Vlr_Pgto_NF_MIM,Par_NF_MIM,Contab,
							Vlr_Contab,Contab_Ant,Vlr_Contab_Ant,Contab_Mes_Ano,Val_Con_Comp
						)
					VALUES
						(
							@Num_Proc_Master,@Cd_Tp_Tx,@DC,@Org_Ins,@Dt_Ins,@Cd_Tp_Moeda,@Vlr_Org,@Dt_Prev_Pgto,@Cd_Cred_Dev,@Desp_Org,@CPMF,	
							@Comp_RP,@Comp_DN,@Comp_CN,@Comp_CPA,@Num_NF,@Ref_Acesso_NF,@Vlr_Pgto_NF,@Par_NF,@Contab,@Vlr_Contab,@Contab_Ant,
							@Vlr_Contab_Ant,@Contab_Mes_Ano,@Val_Con_Comp							
						)
				END
			ELSE
				BEGIN
				   UPDATE
						Cta_Cte_Mas_Imp_Mar
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
						NUM_PROC_MIM=@Num_Proc_Master AND CD_TP_TX=@CD_tP_TX AND DC_MIM=@DC
						and Num_NF_MIM is NULL

				   END
		if @@error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -2
			END

		END			

COMMIT TRANSACTION







GO
