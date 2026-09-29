SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE pVerParidade_Sel 
(
@Tp_Par	Char(3),
@Moeda	char(3)
)
AS
	select top 1 Par_Moeda from paridade where cd_tp_par = @Tp_Par and cd_tp_moeda = @Moeda order by convert(datetime, dt_par, 105) desc
GO
