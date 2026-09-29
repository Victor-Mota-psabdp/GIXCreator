SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spTipo_Oper_Sel]
	@Nome_Tp_Oper as varchar(50)
as

select 
	Cd_Tp_Oper 
from 
	Tipo_Oper 
where
	Nome_Tp_Oper = @Nome_Tp_Oper
GO
