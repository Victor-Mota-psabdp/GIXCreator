SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spATL_Cta_Cte_MIM_Del]
(
	@Num_Proc_Master		Varchar(14),
	@Cd_tp_tx	varchar(3),
	@DC			varchar(1),
	@Tipo		char(1)
)

AS
	IF EXISTS(select id_AX from vwAXDocs where NumeroInternoAX = @Num_Proc_Master and cd_tp_tx_atl = @Cd_Tp_Tx and DC = @DC)
	BEGIN
		RETURN -2
	END

	if exists(select Num_Proc_MIM FROM Cta_Cte_Mas_Imp_Mar CC with(nolock) WHERE CC.Num_Proc_MIM = @Num_Proc_Master and CC.Cd_tp_tx = @Cd_tp_tx and	CC.DC_MIM = @DC)
	BEGIN
		Begin
			Delete
				Cta_Cte_Mas_Imp_Mar
			Where
				Num_Proc_MIM=@Num_Proc_Master and cd_tp_Tx=@cd_tp_tx and DC_MIM=@dc
				and (num_nf_MIM is null or num_nf_MIM='')
		End
	END




GO
