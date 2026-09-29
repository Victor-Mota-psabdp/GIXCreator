SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spHouse_Temp_Del]
(
	@ID				bigint
)
as
	--if exists(select Intl_Reference from House_Temp where ID = @ID and Num_proc is not null) 
	--Begin
	--	Update House_Temp set Num_proc = null, Dt_Emis = null where ID = @ID and Num_proc is not null
	--End
GO
