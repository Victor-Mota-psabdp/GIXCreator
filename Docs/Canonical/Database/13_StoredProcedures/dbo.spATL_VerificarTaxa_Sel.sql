SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spATL_VerificarTaxa_Sel]
(

	@Num_Proc varchar(16),
	@Nome_Tp_Tx varchar(50),
	@Cd_Tp_Tx varchar(3),
	@DC		varchar(1)
)
as


if @Nome_Tp_Tx = ''
	Begin
		set @Cd_Tp_Tx = (Select cd_tp_tx from Tipo_Taxa with(nolock) where Cd_Tp_Tx = @Cd_Tp_Tx)
	end
else
	Begin 
		Set @Cd_Tp_Tx = (Select cd_tp_tx from Tipo_Taxa with(nolock) where Nome_Tp_Tx = @Nome_Tp_Tx)
	end
	
Declare @JOBALL varchar(max)

if len(@Num_Proc) = 14
	Begin
		select @JOBALL = COALESCE(@JOBALL + ', ','') + Num_Proc_HIA  from vwCta_Cte with(nolock)
		where Num_Proc_HIA in (select num_proc from vwCliente with(nolock) where master = @Num_Proc) and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HIA = @DC
	End

if LEN(@Num_Proc) = 16
	Begin
		select @JOBALL = COALESCE(@JOBALL + ', ','') + Num_Proc_HIA from vwCta_Cte with(nolock)
		where Num_Proc_HIA in (select master from vwCliente with(nolock) where num_proc = @Num_Proc) and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HIA = @DC
	End

select @JOBALL JOBs
GO
