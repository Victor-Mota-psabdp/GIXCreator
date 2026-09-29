SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  procedure [dbo].[spATL_BuscaJobSFDCSearch_sel]
as

select JS.SFDCID, HOU.Num_Proc,'BRL'Currency_Code,NULL [Status], NULL [Notas],GS.SFDCID Grupo_SFDCID,NULL CollectionStatus,NULL Collection_Details__c from vwhouse_EXP HOU with(nolock)
join JOB_SFDC JS with(nolock) on JS.Num_Proc= HOU.Num_Proc
join Pessoa_LLP PL with(nolock) on HOU.Cd_Export = PL.Cd_Pes
join Grupo GP with(nolock) on PL.Cd_Pes_Grupo = GP.Cd_Pes_Grupo
join Grupo_SFDC GS with(nolock) on GP.Grupo = GS.GRupo 
where  GS.SFDCID is not null and JS.Dt_Envio  is not NULL and JS.SFDCID is null
and hou.Num_Proc= 'IMROB201203031BR'
union all
select JS.SFDCID, HOU.Num_Proc,'BRL'Currency_Code,NULL [Status],NULL [Notas],GS.SFDCID Grupo_SFDCID,NULL CollectionStatus,NULL Collection_Details__c from vwhouse_Imp HOU with(nolock)
join JOB_SFDC JS with(nolock) on JS.Num_Proc = HOU.Num_Proc
join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig = PL.Cd_Pes
join Grupo GP with(nolock) on PL.Cd_Pes_Grupo = GP.Cd_Pes_Grupo
join Grupo_SFDC GS with(nolock) on GP.Grupo = GS.GRupo 
where  GS.SFDCID is not null and JS.Dt_Envio is not NULL and JS.SFDCID is null
and hou.Num_Proc= 'IMROB201203031BR'
--select * from JOB_SFDC where Num_Proc='IMROB201203031BR'
-- dbo.FRemoveCaracteresEspeciais(replace(replace(UPPER(HOU.Notas), CHAR(13), CHAR(32)), CHAR(10), CHAR(32))) [Notas]


GO
