SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[spATL_Courier_Processo_Del]
(
	@Num_Proc varchar(16),
	@ID_Tp_Courier int,
	@Cd_Pes varchar(10),
	@Num_Courier varchar(50)
)
as
if exists(select ID from Courier_Processo where Num_Proc = @Num_Proc and ID_Tp_Courier = @ID_Tp_Courier 
	and Cd_Pes = @Cd_Pes and @Num_Courier = Num_Courier )
BEGIN
	delete	Courier_Processo 
	where	Num_Proc = @Num_Proc and ID_Tp_Courier = @ID_Tp_Courier 
			and Cd_Pes = @Cd_Pes and @Num_Courier = Num_Courier 
END					


GO
