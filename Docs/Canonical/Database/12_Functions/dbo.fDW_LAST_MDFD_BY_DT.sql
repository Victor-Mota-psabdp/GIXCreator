SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fDW_LAST_MDFD_BY_DT]
(
	@Num_Proc	varchar(16)
)
RETURNS datetime

AS

BEGIN
	Declare @Resultado datetime
				SET @Resultado =(
						select  
							max(excdataalt) Data 
						from 
							ATL_INT.dbo.Exchange_ODS O with(nolock) 
						where 
							O.excprocesso= @Num_Proc
							)
	

	RETURN @Resultado
END


GO
