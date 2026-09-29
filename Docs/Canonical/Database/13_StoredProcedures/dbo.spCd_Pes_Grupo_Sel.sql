SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spCd_Pes_Grupo_Sel]--'GRUPO DOW'
(		
	@Apelido	varchar(60)
)
	
AS

select PL.cd_pes_grupo from Pessoa_LLP PL
    join pessoa P on P.cd_pes=PL.cd_pes
    join Grupo G on G.cd_Pes_Grupo=PL.Cd_Pes_Grupo
    where apelido =@Apelido
	
	






GO
