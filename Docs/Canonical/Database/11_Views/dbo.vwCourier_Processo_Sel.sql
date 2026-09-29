SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--sp_help Courier_Processo
CREATE  VIEW [dbo].[vwCourier_Processo_Sel]
AS

		select 
			C.ID				[ID],
			C.ID_Item			[ID_Item],
			C.Num_Proc			[JOB],
			T.ID_Tp_Courier		[Courier Type Code],
			Nome_Tp_Courier		[Courier Type Name],
			C.Cd_Pes			[Client Code],
			P.Apelido			[Client Name],
			Num_Courier			[Courier Number],
			C.Dt_Courier		[Courier Date],
			C.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name],
			C.Dt_Ins			[Insert Date]	

		from 
			dbo.Courier_Processo C with(nolock)
			join Tipo_Courier	 T with(nolock) on C.ID_Tp_Courier = T.ID_Tp_Courier
			join Pessoa			 P with(nolock) on C.Cd_Pes = P.Cd_Pes
			left join Usuario	US with(nolock) on US.Cd_Usuario = C.Cd_Usuario
	

GO
