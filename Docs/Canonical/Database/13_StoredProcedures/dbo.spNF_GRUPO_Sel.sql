SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
--Marcela --new proc 100-182106  
  
--drop proc [dbo].[spNF_GRUPO_Sel]    
CREATE procedure [dbo].[spNF_GRUPO_Sel]    
 @Grupo varchar(3)  
      
AS    
--use atlantis  
select 
rem.Email  
, gru.Grupo
, pes.Apelido
, rr.*
, rem.*
, gru.*
,pes.*   
from report rr with(nolock)  
inner join Report_Email rem with(nolock) 
	on rr.id = rem.Id_Report  
inner join grupo gru with(nolock) 
	on gru.grupo = @Grupo --@grupo  
inner join pessoa pes with(nolock) 
	on pes.Cd_Pes = gru.Cd_Pes_Grupo  
where 
--rr.id = 238 and 
rr.stored = 'spNF_DOW_Sel' and 
rem.Parametros like '%'+ @Grupo + '%'  
  
GO
