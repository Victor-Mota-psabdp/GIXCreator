SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spOperadorPortuario_sel]
	@ID_OP int
	as

SELECT 
	TP.ID_OP [ID], 
	TP.Descricao_OP [Descricao], 
	TP.Dt_Criacao [Criacao], 
	US.Nome_Usuario [Nome], 
	TP.Ativo  [Status]
FROM 
	Tipo_Operador_Portuario TP 
JOIN Usuario US ON TP.Cd_Usuario = us.Cd_Usuario
where
	TP.ID_OP = @ID_OP
	
GO
