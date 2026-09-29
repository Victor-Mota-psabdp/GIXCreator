SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_ExchangeGTNexus_Ins] (
	@Num_Proc varchar(16),
	@Cd_Usuario varchar(6),
	@Nome_Tp_Gix	varchar(50),
	--@Tipo_Envio varchar(1),
	@Nome_Tp_EnvioGix  varchar(50)	
)
as

Declare @Cd_Tp_Gix varchar(2)
set @Cd_Tp_Gix = (Select Cd_Tp_Gix from Tipo_Gix where nome_Tp_Gix = @Nome_Tp_Gix)

Declare @Cd_Tp_Envio varchar(1)
set @Cd_Tp_Envio = (Select cd_tp_envioGix from Tipo_Envio_GIX where Nome_Tp_EnvioGix = @Nome_Tp_EnvioGix)

Declare @Cd_Tp_EnvioUlt varchar(1)
Declare @Dt_InsUlt datetime

--if @Tipo_Envio <> '1'
--	Begin
--		Select @Cd_Tp_EnvioUlt = Tipo_Envio, @Dt_InsUlt =MAX(Dt_Ins) from Exchange_GTNexus where Num_Proc = @Num_Proc and Type = @Cd_Tp_Gix group by Tipo_Envio


--		if @Cd_Tp_EnvioUlt is NULL or @Cd_Tp_EnvioUlt = '1'
--			Begin 
--				set @Cd_Tp_Envio = '9'
--			End

--		if @Cd_Tp_EnvioUlt <> '1'
--			Begin 
--				Set @Cd_Tp_Envio = '4'
--			End
--	End 
--else
--	Begin
--		Set @Cd_Tp_Envio = '1'
--	End

insert 
		Exchange_GTNexus
		(
			Num_Proc,
			Type,
			Dt_Ins,
			Dt_Send,
			Cd_Usuario,
			Tipo_Envio	
		)
		values
		(
			@Num_Proc,
			@Cd_Tp_Gix,
			Getdate(),
			NULL,
			@Cd_Usuario,
			@Cd_Tp_Envio
		)

GO
