SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Courier
create procedure [dbo].[spATL_Tipo_Courier_Del]
(
	@ID_Tp_Courier		Int			
)
as
	if exists(select ID_Tp_Courier from Tipo_Courier where ID_Tp_Courier= @ID_Tp_Courier) 
	begin
		UPDATE Tipo_Courier SET Status = 0  where ID_Tp_Courier= @ID_Tp_Courier
	end

GO
