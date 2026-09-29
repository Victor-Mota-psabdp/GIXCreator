SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fBusca_Volumes_QtyEmbal]
(
@Processo	Varchar(16)
)
RETURNS Varchar(400)
AS  
BEGIN 
	Declare @N_VOL	VarChar(400) 
	Declare @VOL	varchar(400) 

	Declare Cur_VOL cursor for 

		select CAST(sum(VOL.Qtd_Vol_EM) as varchar(50))  + ' - ' +   TE.Nome_Tp_Embal Volume from volume_exp_mar VOL with(nolock)
		join tipo_embalagem TE with(nolock) on VOL.cd_tp_embal = TE.cd_tp_embal
		where num_proc_hem = @Processo
		group by TE.Nome_Tp_Embal
		union all
		
		select CAST(sum(VOL.Qtd_Vol_EA) as varchar(50))  + ' - ' +   TE.Nome_Tp_Embal Volume from Volume_Exp_Aer VOL with(nolock)
		join tipo_embalagem TE with(nolock) on VOL.cd_tp_embal = TE.cd_tp_embal
		where Num_Proc_HEA = @Processo
		group by TE.Nome_Tp_Embal
		union all
		
		select CAST(sum(VOL.Qtd_Vol_EO) as varchar(50))  + ' - ' +   TE.Nome_Tp_Embal Volume from Volume_Exp_Out VOL with(nolock)
		join tipo_embalagem TE with(nolock) on VOL.cd_tp_embal = TE.cd_tp_embal
		where Num_Proc_HEO = @Processo
		group by TE.Nome_Tp_Embal
		union all
		
		select CAST(sum(VOL.Qtd_Vol_IM) as varchar(50))  + ' - ' +   TE.Nome_Tp_Embal Volume from Volume_Imp_Mar VOL with(nolock)
		join tipo_embalagem TE with(nolock) on VOL.cd_tp_embal = TE.cd_tp_embal
		where Num_Proc_HIM = @Processo
		group by TE.Nome_Tp_Embal
		union all
		
		select CAST(sum(VOL.Qtd_Vol_IA) as varchar(50))  + ' - ' +   TE.Nome_Tp_Embal Volume from Volume_Imp_Aer VOL with(nolock)
		join tipo_embalagem TE with(nolock) on VOL.cd_tp_embal = TE.cd_tp_embal
		where Num_Proc_HIA = @Processo
		group by TE.Nome_Tp_Embal
		union all
		
		select CAST(sum(VOL.Qtd_Vol_IO) as varchar(50))  + ' - ' +   TE.Nome_Tp_Embal Volume from Volume_Imp_Out VOL with(nolock)
		join tipo_embalagem TE with(nolock) on VOL.cd_tp_embal = TE.cd_tp_embal
		where Num_Proc_HIO = @Processo
		group by TE.Nome_Tp_Embal

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
