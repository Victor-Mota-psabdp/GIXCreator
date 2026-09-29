SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spTipo_Banco_sel]--0
	@id_tp_banco int
	
as

SELECT 
	TP.id_tp_banco [ID], 
	TP.nome_tp_banco [Name],
	TP.Nome_full_banco [Complete Name],
	US.Nome_Usuario [User], 
	TP.Ativo
FROM 
	[Tipo_Banco] TP 
JOIN Usuario US ON TP.Cd_Usuario = us.Cd_Usuario
where
	(@id_tp_banco = 0 and TP.id_tp_banco like '%')
	or
	(TP.id_tp_banco  = @id_tp_banco )
	
GO
