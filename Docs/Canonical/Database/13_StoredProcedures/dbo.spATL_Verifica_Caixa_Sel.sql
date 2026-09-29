SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spATL_Verifica_Caixa_Sel]
	@Num_Proc	Varchar(16),
	@Cd_tp_tx	varchar(6),
	@DC			varchar(1)	
AS

	select Num_Proc_HIA 
		from vwCXAS 
	where 
		Num_Proc_HIA = @Num_Proc
		and DC_HIA =  @DC
		and Cd_Tp_Tx = @Cd_tp_tx
GO
