SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select [dbo].[fBusca_Volumes_NCM] ('EAATL201908022BR')
--select [dbo].[fBusca_Volumes_NCM] ('EAATL201908023BR')

CREATE FUNCTION [dbo].[fBusca_Volumes_NCM] --'EMATL201606001BR'
(
@Processo	Varchar(16)
)
RETURNS Varchar(400)
AS  
BEGIN 
	Declare @N_VOL	VarChar(400) 
	Declare @VOL	varchar(400) 

	Declare Cur_VOL cursor for 


		select distinct NCM.NCM  from volume_exp_mar VOL with(nolock)
		join tipo_embalagem TE with(nolock) on VOL.cd_tp_embal = TE.cd_tp_embal
		join NCM with(nolock) on VOL.ID_NCM = NCM.Id_NCM
		where num_proc_hem = @Processo
		
		union all
		
		select distinct NCM.NCM  from Volume_Exp_Aer VOL with(nolock)
		join tipo_embalagem TE with(nolock) on VOL.cd_tp_embal = TE.cd_tp_embal
		join NCM with(nolock) on VOL.ID_NCM = NCM.Id_NCM
		where Num_Proc_HEA = @Processo

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
