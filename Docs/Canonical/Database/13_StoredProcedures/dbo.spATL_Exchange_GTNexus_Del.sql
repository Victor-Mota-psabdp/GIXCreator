SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_Exchange_GTNexus_Del]
(
	@ID				BigInt,
	@Num_Proc		varchar(16),	
	@cd_tp_gix		varchar(2)
)
as

if exists(select ID from Exchange_GTNexus where Num_Proc = @Num_Proc and Type = @cd_tp_gix)
	BEGIN
		delete	
			Exchange_GTNexus 
		where	
			Num_Proc = @Num_Proc and Type = @cd_tp_gix			
	END			


GO
