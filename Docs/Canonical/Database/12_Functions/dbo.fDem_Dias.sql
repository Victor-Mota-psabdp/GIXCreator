SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fDem_Dias] (
			@Processo Char(16),
			@Container Varchar(50)
)
returns int
AS
BEGIN
	Declare @Dias int


	Set @Dias = Isnull((select sum(d_Cobrados) from demurrage_ATL_det 
			Left Join fatura on left(fatcod,16)  =  Processo and right(fatcod,1)   =fatura  
			Where FatStatus=1 and processo=@processo and container=@container),0)
	Return @dias
END


GO
