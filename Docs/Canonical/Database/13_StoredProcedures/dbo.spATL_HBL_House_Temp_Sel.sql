SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_HBL_House_Temp_Sel] 
(
@HAWB varchar(100),
@Cd_Pes_Grupo varchar(10),
@Tipo char(1)
)
AS

if @Tipo = 'C'
Begin
	SELECT HIM.Num_Proc as Num_Proc FROM vwHouse_Imp HIM WITH(NOLOCK)
	JOIN HOUSE_TEMP H  WITH(NOLOCK) on H.HAWB = HIM.HAWB AND H.Cd_Export = HIM.Cd_Export
	JOIN PESSOA_LLP LLP  WITH(NOLOCK) on LLP.Cd_Pes = HIM.Cd_Export
	JOIN GRUPO G  WITH(NOLOCK) on G.Cd_Pes_Grupo = LLP.Cd_Pes_Grupo
	JOIN PESSOA P  WITH(NOLOCK) on P.Cd_Pes = LLP.Cd_Pes
	WHERE 
	HIM.HAWB = @HAWB
	and LLP.CD_PES_GRUPO = @Cd_Pes_Grupo

END

GO
