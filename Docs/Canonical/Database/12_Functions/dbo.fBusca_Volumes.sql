SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


--select * from
--update invoice_cliente
--set status='Created'
--where num_proc='EMCSR20080214101'

--select * from VOLainer_mas_exp_mar where num_VOL_em like 'medu9035%'

--select dbo.fBusca_VOLainers ('EMCSR20080206001')

CREATE		FUNCTION [dbo].[fBusca_Volumes]
(
@Processo	Varchar(16)
)
RETURNS Varchar(400)
AS  
BEGIN 
	Declare @N_VOL	VarChar(400) 
	Declare @VOL	varchar(400) 

	Declare Cur_VOL cursor for 

		select (nome_tp_embal +' - '+ convert(varchar(30),qtd_vol_im)) Volume  from volume_imp_mar VOL with(nolock)
		join tipo_embalagem TE with(nolock) on VOL.cd_tp_embal = TE.cd_tp_embal
		where num_proc_him = @Processo

           	Union All
		select (nome_tp_embal +' - '+ convert(varchar(30),qtd_vol_em)) Volume  from volume_exp_mar VOL with(nolock)
		join tipo_embalagem TE with(nolock) on VOL.cd_tp_embal = TE.cd_tp_embal
		where num_proc_hem = @Processo

		Union All
		select (nome_tp_embal +' - '+ convert(varchar(30),qtd_vol_ia)) Volume  from volume_imp_aer VOL with(nolock)
		join tipo_embalagem TE with(nolock) on VOL.cd_tp_embal = TE.cd_tp_embal
		where num_proc_hia = @Processo

           	Union All
		select (nome_tp_embal +' - '+ convert(varchar(30),qtd_vol_ea)) Volume  from volume_exp_aer VOL with(nolock)
		join tipo_embalagem TE with(nolock) on VOL.cd_tp_embal = TE.cd_tp_embal
		where num_proc_hea = @Processo

           	Union All
		select (nome_tp_embal +' - '+ convert(varchar(30),qtd_vol_io)) Volume  from volume_imp_out VOL with(nolock)
		join tipo_embalagem TE with(nolock) on VOL.cd_tp_embal = TE.cd_tp_embal
		where num_proc_hio = @Processo

           	Union All
		select (nome_tp_embal +' - '+ convert(varchar(30),qtd_vol_eo)) Volume  from volume_exp_out VOL with(nolock)
		join tipo_embalagem TE with(nolock) on VOL.cd_tp_embal = TE.cd_tp_embal
		where num_proc_heo = @Processo


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
