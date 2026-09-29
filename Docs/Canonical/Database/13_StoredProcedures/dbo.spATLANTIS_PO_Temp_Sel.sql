SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATLANTIS_PO_Temp_Sel]--'2'
(
	@ID	BIGINT
)

as
	select ID,ID_House_Temp,ID_Req,Intl_Reference,Num_Proc,
			ID_PO_Temp,Numero_PO_Temp,Name_Reference,Data_PO_Temp,ID_DC,cd_usuario,dt_ins	
	from PO_Temp
	where
		ID = @ID

GO
