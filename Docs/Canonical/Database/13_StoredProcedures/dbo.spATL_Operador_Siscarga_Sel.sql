SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Operador_Siscarga_Sel]  
  
as  
  
select Nome_Usuario from Usuario where Cd_Usuario in ('lae','AZ','tsa','ngb','cpp','mbz') --and ck_ativo = 1  



GO
