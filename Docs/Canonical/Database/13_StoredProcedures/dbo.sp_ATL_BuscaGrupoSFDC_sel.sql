SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  procedure [dbo].[sp_ATL_BuscaGrupoSFDC_sel]
as

select   distinct 'BRL' Currency_Code, Upper(GP.Grupo) Grupo, Upper(Apelido)Apelido, SFDCID from Grupo GP 
Left join Grupo_SFDC GS on GP.Grupo = GS.Grupo
join Pessoa PS on GP.Cd_Pes_Grupo = PS.Cd_Pes
join Exchange_grupo EG on GP.Grupo = EG.Grupo
where EG.Dt_Envio is null and SFDCID is null



GO
