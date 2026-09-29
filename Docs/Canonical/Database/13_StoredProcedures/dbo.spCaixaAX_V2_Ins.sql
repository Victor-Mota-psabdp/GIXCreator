SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spCaixaAX_V2_Ins]
(
	@Num_Proc		varchar(16),
	@Cd_Tp_Tx		varchar	(3),
	@DC				char(1),
	@Num_Lcto		varchar	(12),
	@Vlr_Ref		decimal	(18,2),
	@Par_Moeda		decimal	(18,2),
	@Vlr_Pgto_Rcto	decimal	(18,2),
	@Dt_Pgto_Rcto	datetime,
	@Cancelado		Varchar(50)
)
as

If  exists(select Num_Proc_hia from vwcta_cte where Num_proc_hia = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_Hia = @DC)
Begin




IF @Cancelado is not null and @Cancelado <>''
	Begin
				Update 
					Caixa_AX_V2
				Set
					Status = 0,
					Dt_Del = GETDATE()
				WHERE
					Num_Lcto = @Num_Lcto and Num_Proc=@Num_Proc AND Cd_Tp_Tx=@Cd_Tp_Tx AND DC=@DC and Status = 1
	End
Else
	Begin
		IF not exists(SELECT Num_Proc_HIA, Cd_Tp_Tx, DC_HIA FROM vwCxasTemp WHERE Num_Proc_HIA=@Num_Proc AND Cd_Tp_Tx=@Cd_Tp_Tx AND DC_HIA=@DC)
			Begin
				insert into Caixa_AX_V2
				(
					Num_Proc,
					Cd_Tp_Tx,
					DC,
					Num_Lcto,
					Vlr_Ref,
					Par_Moeda,
					Vlr_Pgto_Rcto,
					Dt_Pgto_Rcto,
					Status,
					Dt_Ins
				)Values
				(
					@Num_Proc,
					@Cd_Tp_Tx,
					@DC,
					@Num_Lcto,
					@Vlr_Ref,
					@Par_Moeda,
					@Vlr_Pgto_Rcto,
					@Dt_Pgto_Rcto,
					1,
					GETDATE()
				)
			End
	End	

	End
GO
