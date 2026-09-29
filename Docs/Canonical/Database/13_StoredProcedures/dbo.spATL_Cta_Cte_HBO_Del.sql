SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure [dbo].[spATL_Cta_Cte_HBO_Del]
(
	@Num_Proc		Varchar(16),
	@Cd_Tp_Tx		Varchar(3),
	@DC				Char(1)
)

AS

	--Erbson 08-01-2014: Não GRAVA CASO JÁ TENHA AX_DOC	
	if len(@Num_Proc) = 16
		Begin
			IF EXISTS(select id_AX from vwAXDocs where num_proc = @Num_Proc and cd_tp_tx_atl = @Cd_Tp_Tx and DC = @DC)
				BEGIN
					RETURN -2
				END
		End
	else
	Begin
			IF EXISTS(select id_AX from vwAXDocs where NumeroInternoAX = @Num_Proc and cd_tp_tx_atl = @Cd_Tp_Tx and DC = @DC)
				BEGIN
					RETURN -2
				END
	End
		
Declare @UltimaFatura varchar(50)
Set @UltimaFatura =(select dbo.[FBusca_UltimaFatura](@Num_Proc,@DC,@Cd_Tp_Tx))
			IF @UltimaFatura is not null and @UltimaFatura <> ''
			BEGIN
				RETURN -2
			END
Begin Transaction

	if left(@num_proc,2)='BO' and len(@num_proc)=16
		Begin
			Delete
				Cta_Cte_HOU_BDP_OUT
			Where
				num_proc_hbo=@num_proc and cd_tp_Tx=@cd_tp_tx and dc_hbo=@dc 
				and (num_nf_hbo is null or num_nf_hbo='')
		End
	
IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END
	
Commit transaction



GO
