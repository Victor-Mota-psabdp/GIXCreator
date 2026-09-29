SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spATL_Doc_Anexos_Sel]--'IMATL201109009BR' 
	
	@num_proc as varchar(16)

AS	
	Select
		DA.Id_DC [ID_DC],	
		Nome_Arquivo [File]
 	from 
		Doc_Anexos DA  With(nolock)
	where 
		DA.Num_Proc = @num_proc
		
		
		

	




GO
