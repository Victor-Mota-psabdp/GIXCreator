SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spTipo_Status_BO_Sel]
	@Id_status as varchar(50)
as

select 
	ID_Status 
from 
	Tipo_Status_BO
where
	ID_Status = @Id_status


GO
