SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  procedure [dbo].[spODSIntItineraryiD_Sel]  
	@Num_Proc varchar(16),
	@Containernumber Varchar(20)
AS

If not exists(select * from [dbo].[Container_Additional_Info] with(nolock) where num_proc=@Num_Proc and num_cont=replace(@Containernumber,'-','') and Itinerary_ID is not null)
	begin
		SELECT  C.Campo_Dados Itinerary_ID FROM Campo_Processo C WHERE ID_CAMPO=202 AND NUM_PROC=@Num_Proc
	End
else
	Begin
		select Itinerary_ID from [dbo].[Container_Additional_Info] with(nolock) where num_proc=@Num_Proc and num_cont=replace(@Containernumber,'-','') and Itinerary_ID is not null

	end
GO
