SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO





CREATE     FUNCTION [dbo].[fPar_M]
(
@Date		VarChar(10),
@Moeda	Char(3),
@Modal	Char(3)='IMM'

)
RETURNS float
AS  
	BEGIN 
		Declare @paridade float
		SET @Paridade=(select top 1 par_moeda from paridade with(nolock) where cd_tp_moeda=@Moeda and converT(datetime,dt_par,105)<=convert(datetime,@date,105) and cd_tp_par=@Modal order by convert(datetime,dt_par,105) desc)
	

				Return @Paridade

	END

















GO
