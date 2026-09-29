SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE function [dbo].[FConverterMoedaCont] --'01-01-2009','01-01-2010','%','%','%','IOCSR20080200701'
	(
		@MoedaOrigem Char(3),
		@MoedaDestino Char(3),
		@Mes		int,
		@Ano		int
	)

returns 

	float

as
Begin
Declare @Data Datetime
Declare @MO float
Declare @MD float


Set @Data=cast(@Ano as varchar(4)) + '-' + cast(@mes as varchar(2)) + '-01'
Set @Data=Dateadd(month,1,@Data)
SEt @Data=@Data-1



if @MoedaOrigem=@MoedaDestino
	Begin
		return 1
	End
Else
	Begin
		Set @MO=(select top 1 par_moeda from paridade where cd_Tp_par='OFC' and cd_tp_moeda=@MoedaOrigem and (convert(Datetime,dt_par,105))<=@Data order by convert(Datetime,dt_par,105) desc)
		Set @MD=(select top 1 par_moeda from paridade where cd_Tp_par='OFC' and cd_tp_moeda=@MoedaDestino and (convert(Datetime,dt_par,105))<=@Data  order by convert(Datetime,dt_par,105) desc)
		
		if @MD=0 or @MO=0 
			Begin	
				Return (0)
			End
		Return(@MO/@MD)

	End
Return (0)

End


GO
