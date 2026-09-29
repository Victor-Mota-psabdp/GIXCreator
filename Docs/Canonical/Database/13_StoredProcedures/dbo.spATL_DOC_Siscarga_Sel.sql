SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_DOC_Siscarga_Sel]
(
	@JOB varchar(16)
)
as

Select 	
	Num_Proc 
from Doc_Anexos DA  With(nolock) 
where 
	DA.Num_Proc = @JOB	
	and Id_DC =153

GO
