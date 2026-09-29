SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Log_Cta_Cte
CREATE Procedure [dbo].[spATL_Log_Cta_Cte_Ins]
(
	@Cd_Usuario		varchar	(6),
	@Tp_Oper_CC		char	(1),
	@Num_Proc_CC	varchar	(16),
	@Cd_Tp_Tx		varchar	(3),
	@DC_CC			char	(1),
	@Org_Ins		varchar	(9),
	@Dt_Ins			varchar	(10),
	@Cd_Tp_Moeda	varchar	(3),
	@Vlr_Org		float,
	@Dt_Prev_Pgto	varchar	(10),
	@Cd_Cred_Dev	varchar	(10),
	@Desp_Org_Dst	char	(1),
	@CPMF			char	(1),
	@Comp_RP		char	(1),
	@Comp_DN		char	(1),
	@Comp_CN		char	(1),
	@Comp_CPA		char	(1),
	@Contab			bit,
	@Vlr_Contab		float,
	@Contab_Ant		bit,
	@Cointab_Mes_Ano varchar(7)
)

AS

BEGIN TRANSACTION

	Insert into Log_Cta_Cte
		(
			Data_CC,Cd_Usuario,Tp_Oper_CC,Num_Proc_CC,Cd_Tp_Tx,DC_CC,Org_Ins,Dt_Ins,Cd_Tp_Moeda,Vlr_Org,
			Dt_Prev_Pgto,Cd_Cred_Dev,Desp_Org_Dst,CPMF,Comp_RP,Comp_DN,Comp_CN,Comp_CPA,Contab,Vlr_Contab,
			Contab_Ant,Cointab_Mes_Ano
		)
	Values
		(
			getDate(),@Cd_Usuario,@Tp_Oper_CC,@Num_Proc_CC,@Cd_Tp_Tx,@DC_CC,@Org_Ins,@Dt_Ins,@Cd_Tp_Moeda,@Vlr_Org,
			@Dt_Prev_Pgto,@Cd_Cred_Dev,@Desp_Org_Dst,@CPMF,@Comp_RP,@Comp_DN,@Comp_CN,@Comp_CPA,@Contab,@Vlr_Contab,
			@Contab_Ant,@Cointab_Mes_Ano
		)
	IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END

COMMIT TRANSACTION

GO
