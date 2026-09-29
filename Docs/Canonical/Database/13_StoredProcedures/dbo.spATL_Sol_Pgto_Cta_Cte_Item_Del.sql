SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spATL_Sol_Pgto_Cta_Cte_Item_Del]
(	
	@Num_Proc	VarChar(16),
	@Cd_tp_tx	varchar(3),
	@DC			varchar(1)
)

AS
if	exists(select ID from Sol_Pgto_Cta_Cte_Item SP WHERE SP.num_proc = @Num_Proc and SP.Cd_tp_tx = @Cd_tp_tx and SP.dc = @DC)
	Begin
		Delete Sol_Pgto_Cta_Cte_Item WHERE num_proc = @Num_Proc and Cd_tp_tx = @Cd_tp_tx and dc = @DC
	End




GO
