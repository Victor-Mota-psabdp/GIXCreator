SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE function [dbo].[FConverterMoeda] --'01-01-2009','01-01-2010','%','%','%','IOCSR20080200701'
	(
		@MoedaOrigem Char(3),
		@MoedaDestino Char(3)
	)

returns 

	float

as
Begin
Declare @MO float
Declare @MD float


if @MoedaOrigem=@MoedaDestino
	Begin
		return 1
	End
Else
	Begin
		Set @MO=(select top 1 par_moeda from paridade with(nolock) where cd_Tp_par='OFC' and cd_tp_moeda=@MoedaOrigem order by convert(Datetime,dt_par,105) desc)
		Set @MD=(select top 1 par_moeda from paridade with(nolock) where cd_Tp_par='OFC' and cd_tp_moeda=@MoedaDestino order by convert(Datetime,dt_par,105) desc)
		
		if @MD=0 or @MO=0 
			Begin	
				Return (0)
			End
		Return(@MO/@MD)

	End
Return (0)

End
GO
