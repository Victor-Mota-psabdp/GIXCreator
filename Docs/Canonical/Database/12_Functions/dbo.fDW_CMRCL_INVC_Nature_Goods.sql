SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create function [dbo].[fDW_CMRCL_INVC_Nature_Goods]
(
	@Num_Proc Varchar(16) 
)

RETURNS varchar(500)

BEGIN
	 Declare @Resultado varchar(500)
	 set @Resultado =(select ng.Descr from Nature_Goods ng with(nolock) 
	 Where ng.Num_Proc=@Num_Proc)
	 RETURN @Resultado
END





GO
