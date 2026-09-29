SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE      FUNCTION [dbo].[spHouseEA] 
(
@Processo	Varchar(16)
)
RETURNS Varchar(400) 
AS  
	BEGIN 
		Declare @StrHouse	VarChar(20)
		Declare @StrHouses	VarChar(400)

		Set @StrHouses = '' 
		Declare CurHouse Cursor For 
				Select HAWB_HEA From House_Exp_Aer Where Num_Proc_MEA = @Processo

		Open CurHouse 
			Fetch Next From CurHouse into @StrHouse 
			While @@Fetch_Status = 0
				Begin 
					If @StrHouses <> ''  
						Set @StrHouses = @StrHouses + ', ' + @StrHouse 
					Else
						Set @StrHouses = 'HAWB: ' + @StrHouse 
					Fetch Next From CurHouse into @StrHouse 
				End
		Close CurHouse
		Deallocate CurHouse	

		return @StrHouses	
	END	
				
		

GO
