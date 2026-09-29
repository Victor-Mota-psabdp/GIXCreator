SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spATL_MEM_Del]
(
	@Num_Proc_Master	VarChar(14)
)
AS

	if exists(select * from LLP_Master where Num_Proc_Master = @Num_Proc_Master)
		Begin
			Update LLP_Master set Tipo = 'C' where Num_Proc_Master = @Num_Proc_Master
		End
	

	


GO
