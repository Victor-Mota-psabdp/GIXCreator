SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--9 -original
--4 - changed
--1 - cancelled
--select Nome_Tp_EnvioGix from [dbo].[Tipo_Envio_GIX] order by cd_tp_envioGix desc
--select * from Exchange_GTNexus
--select * from Tipo_Gix
--BK	GT-Nexus - Booking
--SH	GT-Nexus - Shipment
--SL	SOLAS

--Primeiro é preciso enviar um 9, depois de enviar um 9 pode ser enviado varios 9
--depois de enviado um 9 por eniar varios 4(changed)
--depois de enviado um novo pode ser enviado o 1(cancelado)

--select * from Exchange_GTNexus
--[spATL_ExchangeGTNexus_VerificaEnvio_Sel] 'EMCSR201604034BR','Changed','GT-Nexus - Booking'

CREATE procedure [dbo].[spATL_ExchangeGTNexus_VerificaEnvio_Sel] 
(
	@Num_Proc			varchar(16),
	@Nome_Tp_EnvioGix	varchar(50),
	@Nome_Tp_Gix		varchar(50)
)

as
	 select Num_Proc from Exchange_GTNexus E
		join Tipo_Envio_GIX T on E.Tipo_envio = T.cd_tp_envioGix
		join Tipo_Gix G on G.Cd_Tp_Gix = E.Type
	where
		E.Num_Proc =@Num_Proc
		and g.Nome_Tp_Gix = @Nome_Tp_Gix
		and Tipo_Envio = 9
		

GO
