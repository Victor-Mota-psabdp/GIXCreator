SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Proc_NCM
create procedure [dbo].[spATL_Proc_NCM_Del]
			
	@Id_NCM_Proc	int,
	@Num_Proc		VarChar(16)

AS

	if exists(select Id_NCM_Proc from Proc_NCM where Id_NCM_Proc = @Id_NCM_Proc and Num_Proc = @Num_Proc)
	BEGIN
		Delete 
			Proc_NCM
		WHERE
			Id_NCM_Proc = @Id_NCM_Proc and Num_Proc = @Num_Proc
	END	


	








GO
