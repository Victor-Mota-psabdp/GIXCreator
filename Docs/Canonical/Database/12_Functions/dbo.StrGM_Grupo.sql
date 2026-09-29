SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





CREATE      function StrGM_Grupo(
			@Cliente varchar(40),
			@Consig varchAR(10)
		)returns varchar(40)
AS 

BEGIN
	
	if @Consig='10517' or @Consig='P10803' or @Consig='P11445'
		begin
			return 'GM México'
		end
			return @Cliente
	
END








GO
