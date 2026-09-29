SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE function Prd_Moeda(
			@Modal as Char(2),
			@Moeda as char(3),
			@data as Char(10)

)

RETURNS float
BEGIN
		Declare @Saida float



	if @Modal='EA'
		BEGIN
			
			Set @Saida=isnull((select par_moeda from paridade where convert(datetime,dt_par,105)=convert(datetime,@Data,105) and cd_tp_par='EXA' and cd_tp_moeda=@Moeda),(select par_moeda from paridade where convert(datetime,dt_par,105)=converT(datetime,@Data,105) and cd_tp_par='OFC' and cd_tp_moeda=@Moeda))
		END

	
	return @Saida


END




GO
