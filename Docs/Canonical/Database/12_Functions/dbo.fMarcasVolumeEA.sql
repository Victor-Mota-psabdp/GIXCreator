SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--select dbo.fMarcasVolumeEA ('EACSR20071200101')

CREATE		FUNCTION fMarcasVolumeEA 
(
@Processo	Varchar(16)
)
RETURNS Varchar(400) 
AS  
BEGIN 
		Declare @NVOL	VarChar(400)
		Declare @VOL	varchar(400) 


		Declare Cur_VOL cursor for 
			select 
				Marca_EA + ' ' + Contra_Marca
			from
				VOLUME_EXP_AER
			Where
				Num_Proc_HEA=@Processo
			group by Marca_EA,Contra_Marca
----------------------------------------------------------------------------
		open Cur_VOL
			Fetch Next From Cur_VOL Into @VOL
			While @@FETCH_STATUS = 0
			Begin
				if @nVOL='' or @nVOL is Null
					Begin
						Set @nVOL=@VOL
					end
				else
					begin
						set @nVOL=@nVOL + ' - '  + @VOL
					end
				
				Fetch Next From Cur_VOL Into @VOL
			end
		close Cur_VOL
		deallocate Cur_VOL 
		
	return @nVOL
	
END




GO
