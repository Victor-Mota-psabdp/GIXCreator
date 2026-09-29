SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Exchange_GTNexus
CREATE  VIEW [dbo].[vwExchange_GTNexus_Sel]
AS

		select 
			E.ID				[ID],
			E.Num_Proc			[JOB],
			E.Type				[GIX Type Code],
			T.Nome_Tp_Gix		[GIX Type Name],
			E.Dt_Ins			[Insert Date],
			E.Dt_Send			[Send Date],
			E.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name],
			E.Tipo_Envio		[Gix Send Type Code],
			G.Nome_Tp_EnvioGix		[Gix Send Type Name]
		from dbo.Exchange_GTNexus E with(nolock)
			left join Tipo_Gix T on T.cd_tp_gix = E.type
			left join Tipo_Envio_GIX G on G.Cd_Tp_EnvioGix = E.Tipo_Envio
			left join Usuario	US with(nolock) on US.Cd_Usuario = E.Cd_Usuario
	

GO
