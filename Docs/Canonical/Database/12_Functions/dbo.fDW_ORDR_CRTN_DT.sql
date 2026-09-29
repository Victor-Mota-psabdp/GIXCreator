SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[fDW_ORDR_CRTN_DT]
(
	@Num_Proc Varchar(16) 
)

RETURNS datetime

BEGIN
	Declare @Result datetime

	 set @Result =
	 (
		 select top 1 Dt_pedido from pedido_ship PS with(nolock)
			Join Pedido PD with(nolock) on PD.cd_pedido=PS.cd_pedido
			where num_proc=@Num_Proc
			group by Dt_pedido
	)

	 RETURN @Result
END




GO
