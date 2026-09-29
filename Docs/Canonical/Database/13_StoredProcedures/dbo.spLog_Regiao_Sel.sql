SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLog_Regiao_Sel]
(
	@Cd_Regiao		VARCHAR(3),		
	@Tipo			char(1)
)
AS

	BEGIN
		Select 
			r.ID_Log				[Log ID],
			r.Dt_Alter				[Log Date],
			r.Cd_Regiao				[Region Code],
			r.Nome_Regiao			[Region Name],
			r.Cd_Usuario			[User Code],	 
			u.Nome_Usuario			[User Name],			
			r.LocICS2   			[Region ICS2]
		from Log_Regiao   r with(nolock)
		left join Usuario u with(nolock) on U.Cd_Usuario = r.Cd_Usuario
		where r.Cd_Regiao = @Cd_Regiao
		order by 
			r.Dt_Alter
	END

GO
