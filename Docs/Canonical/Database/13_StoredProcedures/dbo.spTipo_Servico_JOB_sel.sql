SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spTipo_Servico_JOB_sel]--0
	@Id_TP_Servico bigint
	
as

SELECT 
	TP.Id_TP_Servico [ID]
FROM 
	Tipo_Servico TP 	
where	
	(TP.Id_TP_Servico  = @Id_TP_Servico )
	and JOB= 'S'
	
GO
