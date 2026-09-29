SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select [dbo].[fBusca_Volumes_Master_EA_NCM] ('EAVCP201909003')
--select [dbo].[fBusca_Volumes_NCM] ('EAATL201908023BR')

CREATE FUNCTION [dbo].[fBusca_Volumes_Master_EA_NCM] --'EAVCP201909003'
(
	@Num_Proc_Master	Varchar(14)
)
RETURNS Varchar(400)
AS  
BEGIN 
	Declare @N_VOL	VarChar(400) 
	Declare @VOL	varchar(400) 

	Declare Cur_VOL cursor for 
			
		select distinct NCM.NCM from Volume_Exp_Aer VOL with(nolock)
			JOIN House_Exp_Aer hou with(nolock) on hOU.Num_Proc_HEA = VOL.Num_Proc_HEA
			join tipo_embalagem TE with(nolock) on VOL.cd_tp_embal = TE.cd_tp_embal
			join NCM with(nolock) on VOL.ID_NCM = NCM.Id_NCM
		where 
			HOU.Num_Proc_MEA = @Num_Proc_Master
			--Num_Proc_HEA = @Processo

----------------------------------------------------------------------------
		open Cur_VOL
			Fetch Next From Cur_VOL Into @VOL
			While @@FETCH_STATUS = 0
			Begin
				if @N_VOL='' or @N_VOL is Null
					Begin
						Set @N_VOL=@VOL
					end
				else
					begin
						set @N_VOL=@N_VOL + '; '  + @VOL
					end
				
				Fetch Next From Cur_VOL Into @VOL
			end
		close Cur_VOL
		deallocate Cur_VOL 
		
	return @N_VOL
	
END

GO
