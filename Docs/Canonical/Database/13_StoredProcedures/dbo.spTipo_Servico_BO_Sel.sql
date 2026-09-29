SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spTipo_Servico_BO_Sel]
	@descr_Servico as varchar(50)
as

select 
	id_servico 
from 
	Tipo_Servico_BO 
where
	descr_Servico = @descr_Servico


GO
